# based on https://github.com/codalab/codabench/blob/develop/compute_worker/compute_worker.py
import json
import logging
import os
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

app = Celery(
  broker=os.environ.get('BROKER_URL'),
  backend=f"redis://{REDIS_IP}:6379",
)


class TaskExecutionError(Exception):
  def __init__(self, message: str, status: Dict):
    super().__init__(message)
    self.message = message
    self.status = status


# TODO https://github.com/flatland-association/flatland-benchmarks/issues/27 start own redis for evaluator <-> submission communication? Split in flatland-repo?
# N.B. name to be used by send_task
@app.task(name="flatland3-evaluation", bind=True)
def the_task(self, docker_image: str, submission_image: str, tests: List[str] = None, **kwargs):
  task_id = self.request.id
  config.load_incluster_config()
  # https://github.com/kubernetes-client/python/
  # https://github.com/kubernetes-client/python/blob/master/examples/in_cluster_config.py
  batch_api = client.BatchV1Api()
  core_api = client.CoreV1Api()
  if not AWS_ENDPOINT_URL:
    return RuntimeError("Misconfiguration: AWS_ENDPOINT_URL must be set in the compute worker")
  if not AWS_ACCESS_KEY_ID:
    return RuntimeError("Misconfiguration: AWS_ACCESS_KEY_ID must be set in the compute worker")
  if not AWS_SECRET_ACCESS_KEY:
    return RuntimeError("Misconfiguration: AWS_SECRET_ACCESS_KEY must be set in the compute worker")
  if not S3_BUCKET:
    return RuntimeError("Misconfiguration: S3_BUCKET must be set in the compute worker")
  if not S3_UPLOAD_PATH_TEMPLATE:
    return RuntimeError("Misconfiguration: S3_UPLOAD_PATH_TEMPLATE must be set in the compute worker")
  if not S3_UPLOAD_PATH_TEMPLATE_USE_SUBMISSION_ID:
    return RuntimeError("Misconfiguration: S3_UPLOAD_PATH_TEMPLATE_USE_SUBMISSION_ID must be set to true in the compute worker")
  s3 = boto3.client(
    's3',
    # https://docs.weka.io/additional-protocols/s3/s3-examples-using-boto3
    endpoint_url=AWS_ENDPOINT_URL,
    aws_access_key_id=AWS_ACCESS_KEY_ID,
    aws_secret_access_key=AWS_SECRET_ACCESS_KEY
  )
  return run_evaluation(task_id=task_id, docker_image=docker_image, submission_image=submission_image, batch_api=batch_api, core_api=core_api, s3=s3,
                        s3_upload_path_template=S3_UPLOAD_PATH_TEMPLATE, tests=tests)


def run_evaluation(task_id: str, docker_image: str, submission_image: str, batch_api: BatchV1Api, core_api: CoreV1Api, s3, s3_upload_path_template: str,
                   tests: List[str] = None):
  start_time = time.time()
  logger.info(f"/ start task with task_id={task_id} with docker_image={docker_image} and submission_image={submission_image}")

  evaluator_definition = yaml.safe_load(open(Path(__file__).parent / "evaluator_job.yaml"))
  evaluator_definition["metadata"]["name"] = f"{evaluator_definition['metadata']['name']}-{task_id}"
  evaluator_definition["metadata"]["labels"]["task_id"] = task_id
  evaluator_container_definition = evaluator_definition["spec"]["template"]["spec"]["containers"][0]
  evaluator_container_definition["image"] = docker_image
  evaluator_container_definition["env"].append({"name": "AICROWD_SUBMISSION_ID", "value": task_id})
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
  submission_definition["metadata"]["name"] = f"{submission_definition['metadata']['name']}-{task_id}"
  submission_definition["metadata"]["labels"]["task_id"] = task_id
  submission_definition["spec"]["template"]["spec"]["activeDeadlineSeconds"] = ACTIVE_DEADLINE_SECONDS
  submission_container_definition = submission_definition["spec"]["template"]["spec"]["containers"][0]
  submission_container_definition["image"] = submission_image
  submission_container_definition["env"].append({"name": "AICROWD_SUBMISSION_ID", "value": task_id})
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
    jobs = batch_api.list_namespaced_job(namespace=KUBERNETES_NAMESPACE, label_selector=f"task_id={task_id}")
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

  ret["f3-evaluator"] = ret[f"f3-evaluator-{task_id}"]
  ret["f3-submission"] = ret[f"f3-submission-{task_id}"]
  del ret[f"f3-evaluator-{task_id}"]
  del ret[f"f3-submission-{task_id}"]

  if any_failed:
    duration = time.time() - start_time
    raise TaskExecutionError(
      f"Failed task with task_id={task_id} with docker_image={docker_image} and submission_image={submission_image}. Took {duration} seconds.", ret)

  logger.debug("Task with task_id=%s got results from k8s: %s.", task_id, ret)

  logger.info("Get results files from S3 under %s...", AWS_ENDPOINT_URL)
  obj = s3.get_object(Bucket=S3_BUCKET, Key=s3_upload_path_template.format(task_id) + ".csv")
  ret["f3-evaluator"]["results.csv"] = obj['Body'].read().decode("utf-8")
  obj = s3.get_object(Bucket=S3_BUCKET, Key=s3_upload_path_template.format(task_id) + ".json")
  ret["f3-evaluator"]["results.json"] = obj['Body'].read().decode("utf-8")

  logger.info("Upload logs to S3 under %s...", AWS_ENDPOINT_URL)
  response = s3.put_object(Bucket=S3_BUCKET, Key=s3_upload_path_template.format(task_id) + "_evaluator.log", Body=ret["f3-evaluator"]["log"])
  logger.debug("upload response %s", response)
  response = s3.put_object(Bucket=S3_BUCKET, Key=s3_upload_path_template.format(task_id) + "_submission.log", Body=ret["f3-submission"]["log"])
  logger.debug("upload response %s", response)

  all_completed = all([s == "Complete" for s in status])
  logger.info("done %s, all_completed=%s", status, all_completed)
  duration = time.time() - start_time
  logger.debug(ret)
  logger.info(f"\\ end task with task_id={task_id} with docker_image={docker_image} and submission_image={submission_image}. Took {duration} seconds.")
  return ret


# TODO https://github.com/flatland-association/flatland-benchmarks/issues/82 automated integration test against deployed FAB...
def main():
  task_id = str(uuid.uuid4())
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
    task_id=task_id,
    submission_image="ghcr.io/flatland-association/flatland-benchmarks-f3-starterkit:latest",
    docker_image="ghcr.io/flatland-association/fab-flatland-evaluator:latest",
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
