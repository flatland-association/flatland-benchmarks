# based on https://github.com/codalab/codabench/blob/develop/orchestrator/orchestrator.py
import json
import logging
import os
import ssl
import time
import uuid
from io import StringIO
from pathlib import Path
from typing import Dict
from typing import List

import boto3
import pandas as pd
import yaml
from celery import Celery
from kubernetes import client, config
from kubernetes.client import BatchV1Api, CoreV1Api

from fab_clientlib import DefaultApi, ApiClient, Configuration, ResultsSubmissionsSubmissionIdTestsTestIdsPostRequest, \
  ResultsSubmissionsSubmissionIdTestsTestIdsPostRequestDataInner
from fab_oauth_utils import backend_application_flow

logger = logging.getLogger(__name__)

KUBERNETES_NAMESPACE = os.environ.get("KUBERNETES_NAMESPACE", "fab-int")
REDIS_IP = os.environ.get('REDIS_IP', KUBERNETES_NAMESPACE + "-redis-master")
AWS_ENDPOINT_URL = os.environ.get("AWS_ENDPOINT_URL", None)
AWS_ACCESS_KEY_ID = os.environ.get("AWS_ACCESS_KEY_ID", None)
AWS_SECRET_ACCESS_KEY = os.environ.get("AWS_SECRET_ACCESS_KEY", None)
S3_BUCKET = os.environ.get("S3_BUCKET", None)
S3_UPLOAD_PATH_TEMPLATE = os.getenv("S3_UPLOAD_PATH_TEMPLATE", None)
S3_UPLOAD_PATH_TEMPLATE_USE_SUBMISSION_ID = os.getenv("S3_UPLOAD_PATH_TEMPLATE_USE_SUBMISSION_ID", None)
ACTIVE_DEADLINE_SECONDS = os.getenv("ACTIVE_DEADLINE_SECONDS", 7200)
SUPPORTED_CLIENT_VERSIONS = os.environ.get("SUPPORTED_CLIENT_VERSIONS", "4.0.3")
TEST_RUNNER_EVALUATOR_IMAGE = os.environ.get("EVALUATOR_IMAGE", "ghcr.io/flatland-association/fab-flatland-evaluator:latest")
BENCHMARK_ID = os.environ.get("BENCHMARK_ID", "flatland3-evaluation")

FAB_API_URL = os.environ.get("FAB_API_URL")
CLIENT_ID = os.environ.get("CLIENT_ID", 'fab-client-credentials')
CLIENT_SECRET = os.environ.get("CLIENT_SECRET")
TOKEN_URL = os.environ.get("TOKEN_URL", "https://keycloak.flatland.cloud/realms/flatland/protocol/openid-connect/token")

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


class TaskExecutionError(Exception):
  def __init__(self, message: str, status: Dict):
    super().__init__(message)
    self.message = message
    self.status = status


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
  if not S3_UPLOAD_PATH_TEMPLATE:
    raise RuntimeError("Misconfiguration: S3_UPLOAD_PATH_TEMPLATE must be set in the orchestrator")
  if not S3_UPLOAD_PATH_TEMPLATE_USE_SUBMISSION_ID:
    raise RuntimeError("Misconfiguration: S3_UPLOAD_PATH_TEMPLATE_USE_SUBMISSION_ID must be set to true in the orchestrator")
  if not TEST_RUNNER_EVALUATOR_IMAGE:
    raise RuntimeError("Misconfiguration: EVALUATOR_IMAGE must be set to true in the orchestrator")
  s3 = boto3.client(
    's3',
    # https://docs.weka.io/additional-protocols/s3/s3-examples-using-boto3
    endpoint_url=AWS_ENDPOINT_URL,
    aws_access_key_id=AWS_ACCESS_KEY_ID,
    aws_secret_access_key=AWS_SECRET_ACCESS_KEY
  )
  return run_evaluation(submission_id=submission_id, test_runner_evaluator_image=TEST_RUNNER_EVALUATOR_IMAGE, submission_data_url=submission_data_url,
                        batch_api=batch_api,
                        core_api=core_api, s3=s3,
                        s3_upload_path_template=S3_UPLOAD_PATH_TEMPLATE, tests=tests)


def run_evaluation(submission_id: str, test_runner_evaluator_image: str, submission_data_url: str, batch_api: BatchV1Api, core_api: CoreV1Api, s3,
                   s3_upload_path_template: str,
                   tests: List[str] = None, fab: DefaultApi = None):
  start_time = time.time()
  logger.info(f"/ start task with submission_id={submission_id} with docker_image={test_runner_evaluator_image} and submission_data_url={submission_data_url}")

  evaluator_definition = yaml.safe_load(open(Path(__file__).parent / "evaluator_job.yaml"))
  evaluator_definition["metadata"]["name"] = f"{evaluator_definition['metadata']['name']}-{submission_id}"
  evaluator_definition["metadata"]["labels"]["submission_id"] = submission_id
  evaluator_container_definition = evaluator_definition["spec"]["template"]["spec"]["containers"][0]
  evaluator_container_definition["image"] = test_runner_evaluator_image
  evaluator_container_definition["env"].append({"name": "AICROWD_SUBMISSION_ID", "value": submission_id})
  evaluator_container_definition["env"].append({"name": "redis_ip", "value": REDIS_IP})
  evaluator_definition["spec"]["template"]["spec"]["activeDeadlineSeconds"] = ACTIVE_DEADLINE_SECONDS

  evaluator_download_init_container_definition = evaluator_definition["spec"]["template"]["spec"]["initContainers"][0]

  if AWS_ENDPOINT_URL:
    evaluator_container_definition["env"].append({"name": "AWS_ENDPOINT_URL", "value": AWS_ENDPOINT_URL})
    evaluator_download_init_container_definition["env"].append({"name": "AWS_ENDPOINT_URL", "value": AWS_ENDPOINT_URL})
  if AWS_ACCESS_KEY_ID:
    evaluator_container_definition["env"].append({"name": "AWS_ACCESS_KEY_ID", "value": AWS_ACCESS_KEY_ID})
    evaluator_download_init_container_definition["env"].append({"name": "AWS_ACCESS_KEY_ID", "value": AWS_ACCESS_KEY_ID})
  if AWS_SECRET_ACCESS_KEY:
    evaluator_container_definition["env"].append({"name": "AWS_SECRET_ACCESS_KEY", "value": AWS_SECRET_ACCESS_KEY})
    evaluator_download_init_container_definition["env"].append({"name": "AWS_SECRET_ACCESS_KEY", "value": AWS_SECRET_ACCESS_KEY})
  if S3_BUCKET:
    evaluator_container_definition["env"].append({"name": "S3_BUCKET", "value": S3_BUCKET})
  if s3_upload_path_template:
    evaluator_container_definition["env"].append({"name": "S3_UPLOAD_PATH_TEMPLATE", "value": s3_upload_path_template})
  if S3_UPLOAD_PATH_TEMPLATE_USE_SUBMISSION_ID:
    evaluator_container_definition["env"].append({"name": "S3_UPLOAD_PATH_TEMPLATE_USE_SUBMISSION_ID", "value": S3_UPLOAD_PATH_TEMPLATE_USE_SUBMISSION_ID})
  if SUPPORTED_CLIENT_VERSIONS is not None:
    evaluator_container_definition["env"].append({"name": "SUPPORTED_CLIENT_VERSIONS", "value": SUPPORTED_CLIENT_VERSIONS})
  evaluator_container_definition["env"].append({"name": "AICROWD_IS_GRADING", "value": "True"})
  if tests is not None:
    evaluator_container_definition["env"].append({"name": "TEST_ID_FILTER", "value": ','.join(tests)})

  evaluator = client.V1Job(metadata=evaluator_definition["metadata"], spec=evaluator_definition["spec"])
  batch_api.create_namespaced_job(KUBERNETES_NAMESPACE, evaluator)

  submission_definition = yaml.safe_load(open(Path(__file__).parent / "submission_job.yaml"))
  submission_definition["metadata"]["name"] = f"{submission_definition['metadata']['name']}-{submission_id}"
  submission_definition["metadata"]["labels"]["submission_id"] = submission_id
  submission_definition["spec"]["template"]["spec"]["activeDeadlineSeconds"] = ACTIVE_DEADLINE_SECONDS
  submission_container_definition = submission_definition["spec"]["template"]["spec"]["containers"][0]
  submission_container_definition["image"] = submission_data_url
  submission_container_definition["env"].append({"name": "AICROWD_SUBMISSION_ID", "value": submission_id})
  submission_container_definition["env"].append({"name": "redis_ip", "value": REDIS_IP})
  submission_download_initcontainer_definition = submission_definition["spec"]["template"]["spec"]["initContainers"][0]
  if AWS_ENDPOINT_URL:
    submission_download_initcontainer_definition["env"].append({"name": "AWS_ENDPOINT_URL", "value": AWS_ENDPOINT_URL})
  if AWS_ACCESS_KEY_ID:
    submission_download_initcontainer_definition["env"].append({"name": "AWS_ACCESS_KEY_ID", "value": AWS_ACCESS_KEY_ID})
  if AWS_SECRET_ACCESS_KEY:
    submission_download_initcontainer_definition["env"].append({"name": "AWS_SECRET_ACCESS_KEY", "value": AWS_SECRET_ACCESS_KEY})

  submission = client.V1Job(metadata=submission_definition["metadata"], spec=submission_definition["spec"])
  batch_api.create_namespaced_job(KUBERNETES_NAMESPACE, submission)

  all_done = False
  any_failed = False
  ret = {}
  status = []
  while not all_done and not any_failed:
    time.sleep(1)
    print(".")
    jobs = batch_api.list_namespaced_job(namespace=KUBERNETES_NAMESPACE, label_selector=f"submission_id={submission_id}")
    assert len(jobs.items) == 2
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
        assert len(pods.items) == 1
        pod = pods.items[0]
        log = core_api.read_namespaced_pod_log(pod.metadata.name, namespace=KUBERNETES_NAMESPACE)

        _ret = {
          "job_status": job.status.conditions[0].type,
          "image_id": pod.status.container_statuses[0].image_id,
          "log": log,
          "job": job.to_dict(),
          "pod": pod.to_dict()
        }
        ret[job_name] = _ret

  ret["f3-evaluator"] = ret[f"f3-evaluator-{submission_id}"]
  ret["f3-submission"] = ret[f"f3-submission-{submission_id}"]
  del ret[f"f3-evaluator-{submission_id}"]
  del ret[f"f3-submission-{submission_id}"]

  if any_failed:
    duration = time.time() - start_time
    raise TaskExecutionError(
      f"Failed task with submission_id={submission_id} with docker_image={test_runner_evaluator_image} and submission_data_url={submission_data_url}. Took {duration} seconds.",
      ret)

  logger.debug("Task with submission_id=%s got results from k8s: %s.", submission_id, ret)

  logger.info("Get results files from S3 under %s...", AWS_ENDPOINT_URL)
  obj = s3.get_object(Bucket=S3_BUCKET, Key=s3_upload_path_template.format(submission_id) + ".csv")
  ret["f3-evaluator"]["results.csv"] = obj['Body'].read().decode("utf-8")
  obj = s3.get_object(Bucket=S3_BUCKET, Key=s3_upload_path_template.format(submission_id) + ".json")
  ret["f3-evaluator"]["results.json"] = obj['Body'].read().decode("utf-8")

  logger.info("Upload logs to S3 under %s...", AWS_ENDPOINT_URL)
  response = s3.put_object(Bucket=S3_BUCKET, Key=s3_upload_path_template.format(submission_id) + "_evaluator.log", Body=ret["f3-evaluator"]["log"])
  logger.debug("upload response %s", response)
  response = s3.put_object(Bucket=S3_BUCKET, Key=s3_upload_path_template.format(submission_id) + "_submission.log", Body=ret["f3-submission"]["log"])
  logger.debug("upload response %s", response)

  all_completed = all([s == "Complete" for s in status])
  logger.info("done %s, all_completed=%s", status, all_completed)
  duration = time.time() - start_time
  logger.debug(ret)

  if fab is None:

    token = backend_application_flow(CLIENT_ID, CLIENT_SECRET, TOKEN_URL)
    print(token)

    fab = DefaultApi(ApiClient(configuration=Configuration(host=FAB_API_URL, access_token=token["access_token"])))

  # TODO refactor code shared with orchestrator_docker_compose.py
  # TODO upload only requested tests
  df_metadata = pd.read_csv(StringIO("""test_id,env_id,n_agents,x_dim,y_dim,n_cities,max_rail_pairs_in_city,n_envs_run,seed,grid_mode,max_rails_between_cities,malfunction_duration_min,malfunction_duration_max,malfunction_interval,speed_ratios,fab_benchmark_id,fab_test_id,fab_scenario_id
Test_0,Level_0,5,25,25,2,2,2,1,False,2,20,50,0,{1.0: 1.0},f669fb8d-80ac-4ba7-8875-0a33ed5d30b9,4ecdb9f4-e2ff-41ff-9857-abe649c19c50,d99f4d35-aec5-41c1-a7b0-64f78b35d7ef
Test_0,Level_1,5,25,25,2,2,2,2,False,2,20,50,250,{1.0: 1.0},f669fb8d-80ac-4ba7-8875-0a33ed5d30b9,4ecdb9f4-e2ff-41ff-9857-abe649c19c50,04d618b8-84df-406b-b803-d516c7425537
Test_1,Level_0,2,30,30,3,2,3,1,False,2,20,50,0,{1.0: 1.0},f669fb8d-80ac-4ba7-8875-0a33ed5d30b9,5206f2ee-d0a9-405b-8da3-93625e169811,6f3ad83c-3312-4ab3-9740-cbce80feea91
Test_1,Level_1,2,30,30,3,2,3,2,False,2,20,50,300,{1.0: 1.0},f669fb8d-80ac-4ba7-8875-0a33ed5d30b9,5206f2ee-d0a9-405b-8da3-93625e169811,f954a860-e963-431e-a09d-5b1040948f2d
Test_1,Level_2,2,30,30,3,2,3,4,False,2,20,50,600,{1.0: 1.0},f669fb8d-80ac-4ba7-8875-0a33ed5d30b9,5206f2ee-d0a9-405b-8da3-93625e169811,f92bfe0c-5347-4d89-bc17-b6f86d514ef8"""))
  print("metadata.csv")
  print(df_metadata)
  for _, row in df_metadata.iterrows():
    # could also be sent at once, but this way we get continuous updates
    fab.results_submissions_submission_id_tests_test_ids_post(
      submission_id=submission_id,
      test_ids=[row["fab_test_id"]],
      results_submissions_submission_id_tests_test_ids_post_request=ResultsSubmissionsSubmissionIdTestsTestIdsPostRequest(
        data=[
          ResultsSubmissionsSubmissionIdTestsTestIdsPostRequestDataInner(
            scenario_id=row["fab_scenario_id"],
            # TODO hard-coded
            # TODO use better names than primary and secondary -> e.g. rewards and success_rate
            additional_properties={"primary": "55"},
          )
        ]
      ),
    )

  logger.info(
    f"\\ end task with submission_id={submission_id} with docker_image={test_runner_evaluator_image} and submission_data_url={submission_data_url}. Took {duration} seconds.")


  return ret


# TODO https://github.com/flatland-association/flatland-benchmarks/issues/82 automated integration test against deployed FAB...
def main():
  submission_id = str(uuid.uuid4())
  print(f"submission_id={submission_id}")
  config.load_kube_config()
  batch_api = client.BatchV1Api()
  core_api = client.CoreV1Api()
  s3 = boto3.client(
    's3',
    # https://docs.weka.io/additional-protocols/s3/s3-examples-using-boto3
    endpoint_url=AWS_ENDPOINT_URL,
    aws_access_key_id=AWS_ACCESS_KEY_ID,
    aws_secret_access_key=AWS_SECRET_ACCESS_KEY
  )
  ret = run_evaluation(
    batch_api=batch_api,
    core_api=core_api,
    submission_id=submission_id,
    submission_data_url="ghcr.io/flatland-association/flatland-benchmarks-f3-starterkit:latest",
    test_runner_evaluator_image="ghcr.io/flatland-association/fab-flatland-evaluator:latest",
    s3_upload_path_template="results/{}",
    s3=s3
  )
  assert set(ret.keys()) == {"f3-evaluator", "f3-submission"}
  assert set(ret["f3-evaluator"].keys()) == {"job_status", "image_id", "log", "job", "pod", "results.csv", "results.json"}
  assert set(ret["f3-submission"].keys()) == {"job_status", "image_id", "log", "job", "pod"}
  assert ret["f3-evaluator"]["job_status"] == "Complete"
  assert ret["f3-submission"]["job_status"] == "Complete"
  assert ret["f3-evaluator"]["image_id"].startswith("ghcr.io/flatland-association/fab-flatland-evaluator")
  assert ret["f3-submission"]["image_id"].startswith("ghcr.io/flatland-association/flatland-benchmarks-f3-starterkit")
  assert "end evaluator/run.sh" in str(ret["f3-evaluator"]["log"])
  assert "end submission_template/run.sh" in str(ret["f3-submission"]["log"])
  res_df = pd.read_csv(StringIO(ret["f3-evaluator"]["results.csv"]))
  print(res_df)
  res_json = json.loads(ret["f3-evaluator"]["results.json"])
  print(res_json)


if __name__ == '__main__':
  main()
