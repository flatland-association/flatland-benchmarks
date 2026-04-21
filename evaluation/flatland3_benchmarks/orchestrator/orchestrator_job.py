import logging

from kubernetes.client import V1Job, V1JobList

from orchestrator import K8sFlatlandBenchmarksOrchestrator

logger = logging.getLogger(__name__)
# based on https://github.com/codalab/codabench/blob/develop/orchestrator/orchestrator.py
import os
import time
from pathlib import Path
from typing import List

import yaml
from kubernetes import client, config


def make_orchestration_job_definition(orchestrator_image: str, submission_id: str) -> dict:
  submission_job_path = Path(__file__).parent / "orchestration_job.yaml"
  with submission_job_path.open() as submission_job_file:
    orchestration_job_definition = yaml.safe_load(submission_job_file)
  orchestration_job_definition["metadata"]["labels"]["orchestration"] = submission_id
  orchestration_job_definition["metadata"]["name"] = f"orchestration-{submission_id}"
  container_definition = orchestration_job_definition["spec"]["template"]["spec"]["containers"][0]

  orchestration_job_definition["spec"]["template"]["metadata"]["labels"]["orchestration"] = submission_id

  container_definition["image"] = orchestrator_image

  return orchestration_job_definition


def trigger_orchestrator_job(submission_id: str,
                             submission_data_url: str, tests: List[str] = None,
                             kubernetes_namespace: str = None,
                             orchestrator_image: str = None,
                             **kwargs):
  if kubernetes_namespace is None:
    kubernetes_namespace = os.environ.get("KUBERNETES_NAMESPACE", "fab-int")
  if orchestrator_image is None:
    orchestrator_image = os.environ.get("ORCHESTRATOR_IMAGE", "ghcr.io/flatland-association/fab-flatland3-benchmarks-orchestrator:572-failure-reason")

  # https://github.com/kubernetes-client/python/
  # https://github.com/kubernetes-client/python/blob/master/examples/in_cluster_config.py
  batch_api = client.BatchV1Api()

  logger.info(f"// START orchestration for submission submission_id={submission_id}")
  submission_definition = make_orchestration_job_definition(orchestrator_image=orchestrator_image, submission_id=submission_id)

  batch_api.create_namespaced_job(kubernetes_namespace, client.V1Job(metadata=submission_definition["metadata"], spec=submission_definition["spec"]))
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
    end_time = time.time()
    if any_failed:
      logger.error(job.to_dict())
      logger.error(f"\\\\ FAILED orchestration for submission submission_id={submission_id}. Took {end_time - start_time_job:.2f} seconds")
      raise RuntimeError(f"Orchestration for submission submission_id={submission_id} failed. Took {end_time - start_time_job:.2f} seconds. {job.to_dict()}")
    if all_done:
      logger.info(f"\\\\ END orchestration for submission submission_id={submission_id}. Took {end_time - start_time_job:.2f} seconds.")
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


def _load_orchestration_config() -> dict:
  AWS_ENDPOINT_URL = os.environ.get("AWS_ENDPOINT_URL", None)
  AWS_ACCESS_KEY_ID = os.environ.get("AWS_ACCESS_KEY_ID", None)
  AWS_SECRET_ACCESS_KEY = os.environ.get("AWS_SECRET_ACCESS_KEY", None)
  S3_BUCKET = os.environ.get("S3_BUCKET", None)

  if not AWS_ENDPOINT_URL:
    raise RuntimeError("Misconfiguration: AWS_ENDPOINT_URL must be set in the orchestrator")
  if not AWS_ACCESS_KEY_ID:
    raise RuntimeError("Misconfiguration: AWS_ACCESS_KEY_ID must be set in the orchestrator")
  if not AWS_SECRET_ACCESS_KEY:
    raise RuntimeError("Misconfiguration: AWS_SECRET_ACCESS_KEY must be set in the orchestrator")
  if not S3_BUCKET:
    raise RuntimeError("Misconfiguration: S3_BUCKET must be set in the orchestrator")

  submission_id = os.environ.get("SUBMISSION_ID")
  submission_data_url = os.environ.get("SUBMISSION_DATA_URL")
  tests = os.environ.get("TESTS")
  if tests is not None:
    tests = tests.split(",")

  FAB_API_URL = os.environ.get("FAB_API_URL")
  CLIENT_ID = os.environ.get("CLIENT_ID", 'fab-client-credentials')
  CLIENT_SECRET = os.environ.get("CLIENT_SECRET")
  TOKEN_URL = os.environ.get("TOKEN_URL", "https://keycloak.flatland.cloud/realms/flatland/protocol/openid-connect/token")
  PERCENTAGE_COMPLETE_THRESHOLD = os.environ.get("PERCENTAGE_COMPLETE_THRESHOLD", None)
  if PERCENTAGE_COMPLETE_THRESHOLD is not None:
    PERCENTAGE_COMPLETE_THRESHOLD = float(PERCENTAGE_COMPLETE_THRESHOLD)
  RUNNING_TIME_LIMIT = os.environ.get("RUNNING_TIME_LIMIT", None)
  if RUNNING_TIME_LIMIT is not None:
    RUNNING_TIME_LIMIT = float(RUNNING_TIME_LIMIT)
  WAIT_FOR_POD_TO_RUN_LIMIT = os.environ.get("WAIT_FOR_POD_TO_RUN_LIMIT", None)
  if WAIT_FOR_POD_TO_RUN_LIMIT is not None:
    WAIT_FOR_POD_TO_RUN_LIMIT = int(WAIT_FOR_POD_TO_RUN_LIMIT)
  WAIT_FOR_POD_TO_START_LIMIT = os.environ.get("WAIT_FOR_POD_TO_START_LIMIT", None)
  if WAIT_FOR_POD_TO_START_LIMIT is not None:
    WAIT_FOR_POD_TO_START_LIMIT = int(WAIT_FOR_POD_TO_START_LIMIT)

  orch_config = dict(
    submission_id=submission_id,
    kubernetes_namespace=os.environ.get("KUBERNETES_NAMESPACE", "fab-int"),
    active_deadline_seconds=int(os.getenv("ACTIVE_DEADLINE_SECONDS", "7200")),
    submissions_pvc=os.environ.get("SUBMISSIONS_PVC", "fab-int-submissions"),
    environments_pvc=os.environ.get("ENVIRONMENTS_PVC", "fab-int-data"),
    environments_zip=os.environ.get("ENVIRONMENTS_ZIP", "environments.zip"),
    k8s_resource_allocation=os.environ.get("K8S_RESOURCE_ALLOCATION",
                                           '{"requests": {"memory": "1Gi", "cpu": "1"}, "limits": {"memory": "2Gi", "cpu": "2"}}'),
    additional_submission_args=os.environ.get("ADDITIONAL_SUBMISSION_ARGS", None),
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
    wait_for_pod_to_start_limit=WAIT_FOR_POD_TO_START_LIMIT,
    wait_for_pod_to_run_limit=WAIT_FOR_POD_TO_RUN_LIMIT,
    submission_data_url=submission_data_url,
    tests=tests,
  )
  return orch_config


if __name__ == '__main__':
  main()
