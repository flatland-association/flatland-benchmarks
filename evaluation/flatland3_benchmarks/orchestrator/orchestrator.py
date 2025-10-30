# based on https://github.com/codalab/codabench/blob/develop/orchestrator/orchestrator.py
import logging
import os
import ssl
import tempfile
import time
from pathlib import Path
from typing import List

import yaml
from celery import Celery
from kubernetes import client, config

from orchestrator_common import FlatlandBenchmarksOrchestrator, TaskExecutionError, TEST_TO_SCENARIO_IDS
from s3_utils import s3_utils, download_dir

logger = logging.getLogger(__name__)

KUBERNETES_NAMESPACE = os.environ.get("KUBERNETES_NAMESPACE", "fab-int")
AWS_ENDPOINT_URL = os.environ.get("AWS_ENDPOINT_URL", None)
AWS_ACCESS_KEY_ID = os.environ.get("AWS_ACCESS_KEY_ID", None)
AWS_SECRET_ACCESS_KEY = os.environ.get("AWS_SECRET_ACCESS_KEY", None)
S3_BUCKET = os.environ.get("S3_BUCKET", None)
ACTIVE_DEADLINE_SECONDS = os.getenv("ACTIVE_DEADLINE_SECONDS", 7200)
BENCHMARK_ID = os.environ.get("BENCHMARK_ID", "flatland3-evaluation")

app = Celery(
  broker=os.environ.get('BROKER_URL'),
  backend=os.environ.get('BACKEND_URL'),
  queue=os.environ.get("BENCHMARK_ID"),
  broker_use_ssl={
    'keyfile': os.environ.get("RABBITMQ_KEYFILE"),
    'certfile': os.environ.get("RABBITMQ_CERTFILE"),
    'ca_certs': os.environ.get("RABBITMQ_CA_CERTS"),
    'cert_reqs': ssl.CERT_REQUIRED
  }
)


class K8sFlatlandBenchmarksOrchestrator(FlatlandBenchmarksOrchestrator):

  def run_flatland(self, submission_id, submission_data_url, tests, aws_endpoint_url, aws_access_key_id, aws_secret_access_key, s3_bucket, s3, **kwargs):
    if tests is None:
      tests = list(TEST_TO_SCENARIO_IDS.keys())

    results = {test_id: {} for test_id in tests}
    for test_id in tests:
      for scenario_id in TEST_TO_SCENARIO_IDS[test_id]:
        pkl_path = self.load_scenario_data(scenario_id)
        prefix = f"{submission_id}/{scenario_id}"
        core_api = kwargs["core_api"]
        batch_api = kwargs["batch_api"]

        self._run_submission(submission_id, test_id, scenario_id, submission_data_url, pkl_path,
                             core_api, batch_api, aws_access_key_id, aws_endpoint_url, aws_secret_access_key, )

        logger.info(f"// START evaluating submission submission_id={submission_id},test_id={test_id}, scenario_id={scenario_id}")
        with tempfile.TemporaryDirectory() as tmpdirname:
          if s3 is None:
            s3 = s3_utils.get_boto_client(aws_access_key_id, aws_secret_access_key, aws_endpoint_url)
          download_dir(prefix=prefix, bucket=s3_bucket, client=s3, local=tmpdirname)

          normalized_reward, success_rate = self._extract_stats_from_trajectory(Path(tmpdirname) / submission_id / scenario_id, scenario_id)
          results[test_id][scenario_id] = {
            "normalized_reward": normalized_reward,
            "percentage_complete": success_rate
          }
        logger.info(f"\\\\ END running submission submission_id={submission_id},test_id={test_id}, scenario_id={scenario_id}: {results[test_id][scenario_id]}")
    return results

  def _run_submission(self, submission_id, test_id, scenario_id, submission_data_url, pkl_path, core_api, batch_api,
                      aws_access_key_id=None, aws_endpoint_url=None, aws_secret_access_key=None,
                      ):
    prefix = f"{submission_id}/{scenario_id}"
    logger.info(f"// START running submission submission_id={submission_id},test_id={test_id}, scenario_id={scenario_id}")

    submission_definition = yaml.safe_load(open(Path(__file__).parent / "submission_job.yaml"))
    metadata_name_ = submission_definition['metadata']['name']
    submission_definition["metadata"]["name"] = f"{metadata_name_}--{prefix.replace("/", "--")}"[:62]
    label = f"{submission_id}-{scenario_id}"[:63].lower()
    submission_definition["metadata"]["labels"]["submission_id"] = label
    submission_definition["spec"]["template"]["spec"]["activeDeadlineSeconds"] = ACTIVE_DEADLINE_SECONDS
    submission_container_definition = submission_definition["spec"]["template"]["spec"]["containers"][0]
    submission_container_definition["image"] = submission_data_url
    submission_container_definition["command"] = ["bash", "entrypoint_generic.sh",
                                                  f"flatland-trajectory-generate-from-policy --data-dir /data/ --policy-pkg tests.trajectories.test_trajectories --policy-cls RandomPolicy --obs-builder-pkg flatland.core.env_observation_builder --obs-builder-cls DummyObservationBuilder --callbacks-pkg flatland.callbacks.generate_movie_callbacks --callbacks-cls GenerateMovieCallbacks --env-path /tmp/environments/{pkl_path} --ep-id {scenario_id}"]
    submission_container_definition["volumeMounts"][0]["subPath"] = prefix
    submission_download_initcontainer_definition = submission_definition["spec"]["template"]["spec"]["initContainers"][0]
    submission_extractenvs_initcontainer_definition = submission_definition["spec"]["template"]["spec"]["initContainers"][1]
    if aws_endpoint_url:
      submission_download_initcontainer_definition["env"].append({"name": "AWS_ENDPOINT_URL", "value": aws_endpoint_url})
    if aws_access_key_id:
      submission_download_initcontainer_definition["env"].append({"name": "AWS_ACCESS_KEY_ID", "value": aws_access_key_id})
    if aws_secret_access_key:
      submission_download_initcontainer_definition["env"].append({"name": "AWS_SECRET_ACCESS_KEY", "value": aws_secret_access_key})
    submission_extractenvs_initcontainer_definition["env"].append({"name": "PREFIX", "value": prefix})
    submission = client.V1Job(metadata=submission_definition["metadata"], spec=submission_definition["spec"])
    batch_api.create_namespaced_job(KUBERNETES_NAMESPACE, submission)
    all_done = False
    any_failed = False
    ret = {}
    while not all_done and not any_failed:
      time.sleep(1)
      # print(".")
      jobs = batch_api.list_namespaced_job(namespace=KUBERNETES_NAMESPACE, label_selector=f"submission_id={label}")
      assert len(jobs.items) == 1
      all_done = True
      status = []
      for job in jobs.items:
        all_done = all_done and job.status.conditions is not None
        any_failed = any_failed or (job.status.conditions is not None and job.status.conditions[0].type != "Complete")

      if all_done or any_failed:
        for job in jobs.items:
          status.append(job.status.conditions[0].type)
          job_name = job.metadata.name
          pods = core_api.list_namespaced_pod(namespace=KUBERNETES_NAMESPACE, label_selector=f"job-name={job_name}")

          # backoff
          pod = pods.items[-1]
          log = core_api.read_namespaced_pod_log(pod.metadata.name, namespace=KUBERNETES_NAMESPACE)

          _ret = {
            "job_status": job.status.conditions[0].type,
            "image_id": pods.items[-1].status.container_statuses[0].image_id,
            "log": log,
            "job": job.to_dict(),
            "pod": pod.to_dict()
          }
          ret[metadata_name_] = _ret
    if any_failed:
      raise TaskExecutionError(
        f"Failed task with submission_id={submission_id} with submission_data_url={submission_data_url}.", ret)
    logger.info(f"\\\\ END running submission submission_id={submission_id},test_id={test_id}, scenario_id={scenario_id}: {ret}")
    return ret

  @staticmethod
  def load_scenario_data(scenario_id: str) -> str:
    # TODO all 150 scenarios
    # return {
    #   # test 4ecdb9f4-e2ff-41ff-9857-abe649c19c50_
    #   'd99f4d35-aec5-41c1-a7b0-64f78b35d7ef': "Test_00/Level_0.pkl",
    #   '04d618b8-84df-406b-b803-d516c7425537': "Test_00/Level_1.pkl",
    #
    #   # test 5206f2ee-d0a9-405b-8da3-93625e169811:
    #   '6f3ad83c-3312-4ab3-9740-cbce80feea91': "Test_01/Level_0.pkl",
    #   'f954a860-e963-431e-a09d-5b1040948f2d': "Test_01/Level_1.pkl",
    #   'f92bfe0c-5347-4d89-bc17-b6f86d514ef8': "Test_01/Level_2.pkl",
    # }[scenario_id]
    # debug environments:
    return {
      # test 4ecdb9f4-e2ff-41ff-9857-abe649c19c50_
      'd99f4d35-aec5-41c1-a7b0-64f78b35d7ef': "Test_0/Level_0.pkl",
      '04d618b8-84df-406b-b803-d516c7425537': "Test_0/Level_1.pkl",

      # test 5206f2ee-d0a9-405b-8da3-93625e169811:
      '6f3ad83c-3312-4ab3-9740-cbce80feea91': "Test_1/Level_0.pkl",
      'f954a860-e963-431e-a09d-5b1040948f2d': "Test_1/Level_1.pkl",
      'f92bfe0c-5347-4d89-bc17-b6f86d514ef8': "Test_1/Level_2.pkl",
    }[scenario_id]


# N.B. name to be used by send_task
@app.task(name=BENCHMARK_ID, bind=True)
def orchestrator(self, submission_data_url: str, tests: List[str] = None, **kwargs):
  submission_id = self.request.id
  config.load_incluster_config()
  # https://github.com/kubernetes-client/python/
  # https://github.com/kubernetes-client/python/blob/master/examples/in_cluster_config.py
  batch_api = client.BatchV1Api()
  core_api = client.CoreV1Api()
  if not AWS_ENDPOINT_URL:
    raise RuntimeError("Misconfiguration: AWS_ENDPOINT_URL must be set in the orchestrator")
  if not AWS_ACCESS_KEY_ID:
    raise RuntimeError("Misconfiguration: AWS_ACCESS_KEY_ID must be set in the orchestrator")
  if not AWS_SECRET_ACCESS_KEY:
    raise RuntimeError("Misconfiguration: AWS_SECRET_ACCESS_KEY must be set in the orchestrator")
  if not S3_BUCKET:
    raise RuntimeError("Misconfiguration: S3_BUCKET must be set in the orchestrator")

  submission_id = self.request.id
  return K8sFlatlandBenchmarksOrchestrator(submission_id).orchestrator(
    submission_data_url=submission_data_url,
    tests=tests,
    aws_endpoint_url=AWS_ENDPOINT_URL,
    aws_access_key_id=AWS_ACCESS_KEY_ID,
    aws_secret_access_key=AWS_SECRET_ACCESS_KEY,
    s3_bucket=S3_BUCKET,
    batch_api=batch_api,
    core_api=core_api,
    **kwargs
  )
