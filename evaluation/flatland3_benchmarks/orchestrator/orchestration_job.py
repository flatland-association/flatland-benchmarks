import logging

from kubernetes.client import V1Job, V1JobList, V1PodList, V1Pod, V1PodStatus

from orchestrator import K8sFlatlandBenchmarksOrchestrator
from orchestrator_common import pretty_dumps_dict

logger = logging.getLogger(__name__)
# based on https://github.com/codalab/codabench/blob/develop/orchestrator/orchestrator.py
import os
import time
from pathlib import Path
from typing import Dict

import yaml
from kubernetes import client, config


def make_orchestration_job_definition(orch_config: Dict[str, str]) -> dict:
  submission_id = orch_config["submission_id"]
  orchestrator_image = orch_config["orchestrator_image"]

  submission_job_path = Path(__file__).parent / "orchestration_job.yaml"
  with submission_job_path.open() as submission_job_file:
    orchestration_job_definition = yaml.safe_load(submission_job_file)
  orchestration_job_definition["metadata"]["labels"]["orchestration"] = submission_id
  orchestration_job_definition["metadata"]["name"] = f"orchestration-{submission_id}"
  orchestration_job_definition["spec"]["template"]["metadata"]["labels"]["orchestration"] = submission_id
  orchestration_job_definition["spec"]["template"]["spec"]["serviceAccountName"] = orch_config["service_account_name"]
  container_definition = orchestration_job_definition["spec"]["template"]["spec"]["containers"][0]

  container_definition["image"] = orchestrator_image
  container_definition["args"] = ["python", "orchestration_job.py"]
  container_definition["env"] = [{"name": k.upper(), "value": str(v)} for k, v in orch_config.items() if v is not None]
  print(pretty_dumps_dict(orchestration_job_definition))
  return orchestration_job_definition


def trigger_orchestrator_job(orch_config):
  submission_id = orch_config["submission_id"]
  kubernetes_namespace = orch_config["kubernetes_namespace"]
  submission_data_url = orch_config["submission_data_url"]

  # https://github.com/kubernetes-client/python/
  # https://github.com/kubernetes-client/python/blob/master/examples/in_cluster_config.py
  batch_api = client.BatchV1Api()
  core_api = client.CoreV1Api()

  logger.info(f"// START orchestration for submission submission_id={submission_id}")
  orchestration_job_definition = make_orchestration_job_definition(orch_config)
  job_name = orchestration_job_definition["metadata"]["name"]

  batch_api.create_namespaced_job(kubernetes_namespace,
                                  client.V1Job(metadata=orchestration_job_definition["metadata"], spec=orchestration_job_definition["spec"]))
  start_time_job = time.time()
  all_done = False
  any_failed = False
  while not all_done and not any_failed:
    time.sleep(1)
    jobs: V1JobList = batch_api.list_namespaced_job(namespace=kubernetes_namespace, label_selector=f"orchestration={submission_id}")
    assert len(jobs.items) == 1
    all_done = True
    job: V1Job = jobs.items[-1]
    all_done = all_done and job.status.conditions is not None
    job_status_conditions_ = [cond.type for cond in job.status.conditions] if job.status.conditions is not None else None
    any_failed = any_failed or (job_status_conditions_ is not None and 'Complete' not in job_status_conditions_)

    if any_failed or all_done:
      end_time = time.time()
      ret = {}
      pods: V1PodList = core_api.list_namespaced_pod(namespace=kubernetes_namespace, label_selector=f"job-name={job_name}")
      if len(pods.items) != 1:
        raise Exception(
          f"Failed task with submission_id={submission_id} with submission_data_url={submission_data_url}. Could not gather stats there where {len(pods.items)} pods.")
      pod: V1Pod = pods.items[-1]
      pod_status: V1PodStatus = pod.status
      try:
        ret["events"] = core_api.list_namespaced_event(kubernetes_namespace, field_selector=f'involvedObject.name={pod._metadata._name}').to_dict()
      except Exception as e:
        ret["events"] = f"Failed to fetch events  from pod for submission_id={submission_id} with submission_data_url={submission_data_url}. {e}"
        logger.warning(f"Failed to fetch events or log from pod for submission_id={submission_id} with submission_data_url={submission_data_url}.", exc_info=e)
      try:
        ret["log"] = core_api.read_namespaced_pod_log(pod.metadata.name, namespace=kubernetes_namespace)
      except Exception as e:
        ret["log"] = f"Failed to fetch log from pod for submission_id={submission_id} with submission_data_url={submission_data_url}. {e}"
        logger.warning(f"Failed to fetch events or log from pod for submission_id={submission_id} with submission_data_url={submission_data_url}.", exc_info=e)
      if any_failed:
        logger.error(pretty_dumps_dict(job.to_dict()), )
        logger.error(pretty_dumps_dict(ret["events"]), )
        logger.error("\n".join(ret["log"].split("\\n")), )
        logger.error(
          f"\\\\ FAILED orchestration for submission submission_id={submission_id}: {job_status_conditions_}. Took {end_time - start_time_job:.2f} seconds")
        raise RuntimeError(
          f"Orchestration for submission submission_id={submission_id} failed: {job_status_conditions_}. Took {end_time - start_time_job:.2f} seconds. {job.to_dict()}")
      if all_done:
        logger.info(pretty_dumps_dict(job.to_dict()), )
        logger.info(pretty_dumps_dict(ret["events"]), )
        logger.info("\n".join(ret["log"].split("\\n")), )
        logger.info(
          f"\\\\ END orchestration for submission submission_id={submission_id}: {job_status_conditions_}. Took {end_time - start_time_job:.2f} seconds.")
        break


def main():
  config.load_incluster_config()
  # https://github.com/kubernetes-client/python/
  # https://github.com/kubernetes-client/python/blob/master/examples/in_cluster_config.py
  batch_api = client.BatchV1Api()
  core_api = client.CoreV1Api()

  orch_config = _load_orchestration_config()

  return K8sFlatlandBenchmarksOrchestrator(
    batch_api=batch_api,
    core_api=core_api,
    **orch_config
  ).orchestrator(
    submission_data_url=orch_config["submission_data_url"],
    tests=orch_config["tests"],
  )


def _load_orchestration_config(_ENV_VARS: Dict[str, str] = None) -> dict:
  if _ENV_VARS is None:
    _ENV_VARS = {}

  def _require_config(name: str, default=None, accept_none=False) -> str:
    """Return a required configuration value from environment or .env, with a clear error if missing."""
    value = os.getenv(name) or _ENV_VARS.get(name)
    if value is None:
      if default is None and not accept_none:
        raise RuntimeError(f"Required configuration value '{name}' is not set.")
      return default
    return value

  AWS_ENDPOINT_URL = _require_config("AWS_ENDPOINT_URL")
  AWS_ACCESS_KEY_ID = _require_config("AWS_ACCESS_KEY_ID")
  AWS_SECRET_ACCESS_KEY = _require_config("AWS_SECRET_ACCESS_KEY")
  S3_BUCKET = _require_config("S3_BUCKET")

  submission_id = _require_config("SUBMISSION_ID")
  submission_data_url = _require_config("SUBMISSION_DATA_URL")
  tests = _require_config("TESTS", None, True)
  if tests is not None:
    tests = tests.split(",")

  FAB_API_URL = _require_config("FAB_API_URL")
  CLIENT_ID = _require_config("CLIENT_ID")
  CLIENT_SECRET = _require_config("CLIENT_SECRET")
  TOKEN_URL = _require_config("TOKEN_URL")
  PERCENTAGE_COMPLETE_THRESHOLD = _require_config("PERCENTAGE_COMPLETE_THRESHOLD", None, True)
  if PERCENTAGE_COMPLETE_THRESHOLD is not None:
    PERCENTAGE_COMPLETE_THRESHOLD = float(PERCENTAGE_COMPLETE_THRESHOLD)
  RUNNING_TIME_LIMIT = _require_config("RUNNING_TIME_LIMIT", None, True)
  if RUNNING_TIME_LIMIT is not None:
    RUNNING_TIME_LIMIT = float(RUNNING_TIME_LIMIT)
  TOTAL_RUNNING_TIME_LIMIT = _require_config("TOTAL_RUNNING_TIME_LIMIT", None, True)
  if TOTAL_RUNNING_TIME_LIMIT is not None:
    TOTAL_RUNNING_TIME_LIMIT = float(TOTAL_RUNNING_TIME_LIMIT)
  WAIT_FOR_POD_TO_RUN_LIMIT = _require_config("WAIT_FOR_POD_TO_RUN_LIMIT", None, True)
  if WAIT_FOR_POD_TO_RUN_LIMIT is not None:
    WAIT_FOR_POD_TO_RUN_LIMIT = int(WAIT_FOR_POD_TO_RUN_LIMIT)
  WAIT_FOR_POD_TO_START_LIMIT = _require_config("WAIT_FOR_POD_TO_START_LIMIT", None, True)
  if WAIT_FOR_POD_TO_START_LIMIT is not None:
    WAIT_FOR_POD_TO_START_LIMIT = int(WAIT_FOR_POD_TO_START_LIMIT)

  orch_config = dict(
    submission_id=submission_id,
    kubernetes_namespace=_require_config("KUBERNETES_NAMESPACE", "fab-int"),
    active_deadline_seconds=int(os.getenv("ACTIVE_DEADLINE_SECONDS", "7200")),
    submissions_pvc=_require_config("SUBMISSIONS_PVC", "fab-int-submissions"),
    environments_pvc=_require_config("ENVIRONMENTS_PVC", "fab-int-data"),
    environments_zip=_require_config("ENVIRONMENTS_ZIP", "environments.zip"),
    k8s_resource_allocation=_require_config("K8S_RESOURCE_ALLOCATION",
                                            '{"requests": {"memory": "1Gi", "cpu": "1"}, "limits": {"memory": "2Gi", "cpu": "2"}}'),
    additional_submission_args=_require_config("ADDITIONAL_SUBMISSION_ARGS", None, True),
    aws_endpoint_url=AWS_ENDPOINT_URL,
    aws_access_key_id=AWS_ACCESS_KEY_ID,
    aws_secret_access_key=AWS_SECRET_ACCESS_KEY,
    s3_bucket=S3_BUCKET,
    fab_api_url=FAB_API_URL,
    client_id=CLIENT_ID,
    client_secret=CLIENT_SECRET,
    token_url=TOKEN_URL,
    percentage_complete_threshold=PERCENTAGE_COMPLETE_THRESHOLD,
    running_time_limit=RUNNING_TIME_LIMIT,
    total_running_time_limit=TOTAL_RUNNING_TIME_LIMIT,
    wait_for_pod_to_start_limit=WAIT_FOR_POD_TO_START_LIMIT,
    wait_for_pod_to_run_limit=WAIT_FOR_POD_TO_RUN_LIMIT,
    submission_data_url=submission_data_url,
    tests=tests,
    orchestrator_image=_require_config("ORCHESTRATOR_IMAGE"),
    service_account_name=_require_config("SERVICE_ACCOUNT_NAME"),
  )
  return orch_config


if __name__ == '__main__':
  main()
