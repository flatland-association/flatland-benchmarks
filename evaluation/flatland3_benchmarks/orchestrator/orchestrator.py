# based on https://github.com/codalab/codabench/blob/develop/orchestrator/orchestrator.py
import logging
import os
import ssl
import time
from pathlib import Path
from typing import List

import yaml
from celery import Celery
from kubernetes import client, config

from orchestrator_common import FlatlandBenchmarksOrchestrator, TaskExecutionError

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
SUPPORTED_CLIENT_VERSIONS_RANGE = os.environ.get("SUPPORTED_CLIENT_VERSION_RANGE", ">=4.2.0")
TEST_RUNNER_EVALUATOR_IMAGE = os.environ.get("EVALUATOR_IMAGE", "ghcr.io/flatland-association/fab-flatland3-benchmarks-evaluator:latest")
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

  def run_flatland(self, test_runner_evaluator_image, submission_id, submission_data_url, tests, aws_endpoint_url, aws_access_key_id, aws_secret_access_key,
                   s3_bucket, s3_upload_path_template, s3_upload_path_template_use_submission_id, **kwargs):

    core_api = kwargs["core_api"]
    batch_api = kwargs["batch_api"]

    evaluator_definition = yaml.safe_load(open(Path(__file__).parent / "evaluator_job.yaml"))
    evaluator_definition["metadata"]["name"] = f"{evaluator_definition['metadata']['name']}-{submission_id}"
    evaluator_definition["metadata"]["labels"]["submission_id"] = submission_id
    evaluator_container_definition = evaluator_definition["spec"]["template"]["spec"]["containers"][0]
    evaluator_container_definition["image"] = test_runner_evaluator_image
    evaluator_container_definition["env"].append({"name": "AICROWD_SUBMISSION_ID", "value": submission_id})
    evaluator_container_definition["env"].append({"name": "redis_ip", "value": REDIS_IP})
    evaluator_definition["spec"]["template"]["spec"]["activeDeadlineSeconds"] = ACTIVE_DEADLINE_SECONDS

    evaluator_download_init_container_definition = evaluator_definition["spec"]["template"]["spec"]["initContainers"][0]

    if aws_endpoint_url:
      evaluator_container_definition["env"].append({"name": "AWS_ENDPOINT_URL", "value": aws_endpoint_url})
      evaluator_download_init_container_definition["env"].append({"name": "AWS_ENDPOINT_URL", "value": aws_endpoint_url})
    if aws_access_key_id:
      evaluator_container_definition["env"].append({"name": "AWS_ACCESS_KEY_ID", "value": aws_access_key_id})
      evaluator_download_init_container_definition["env"].append({"name": "AWS_ACCESS_KEY_ID", "value": aws_access_key_id})
    if aws_secret_access_key:
      evaluator_container_definition["env"].append({"name": "AWS_SECRET_ACCESS_KEY", "value": aws_secret_access_key})
      evaluator_download_init_container_definition["env"].append({"name": "AWS_SECRET_ACCESS_KEY", "value": aws_secret_access_key})
    if s3_bucket:
      evaluator_container_definition["env"].append({"name": "S3_BUCKET", "value": s3_bucket})
    if s3_upload_path_template:
      evaluator_container_definition["env"].append({"name": "S3_UPLOAD_PATH_TEMPLATE", "value": s3_upload_path_template})
    if s3_upload_path_template_use_submission_id:
      evaluator_container_definition["env"].append({"name": "S3_UPLOAD_PATH_TEMPLATE_USE_SUBMISSION_ID", "value": s3_upload_path_template_use_submission_id})
    if SUPPORTED_CLIENT_VERSIONS_RANGE is not None:
      evaluator_container_definition["env"].append({"name": "SUPPORTED_CLIENT_VERSION_RANGE", "value": SUPPORTED_CLIENT_VERSIONS_RANGE})
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
    if aws_endpoint_url:
      submission_download_initcontainer_definition["env"].append({"name": "AWS_ENDPOINT_URL", "value": aws_endpoint_url})
    if aws_access_key_id:
      submission_download_initcontainer_definition["env"].append({"name": "AWS_ACCESS_KEY_ID", "value": aws_access_key_id})
    if aws_secret_access_key:
      submission_download_initcontainer_definition["env"].append({"name": "AWS_SECRET_ACCESS_KEY", "value": aws_secret_access_key})

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
      raise TaskExecutionError(
        f"Failed task with submission_id={submission_id} with docker_image={test_runner_evaluator_image} and submission_data_url={submission_data_url}.", ret)
    return ret


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

  submission_id = self.request.id
  return K8sFlatlandBenchmarksOrchestrator(submission_id).orchestrator(
    submission_data_url=submission_data_url,
    tests=tests,
    test_runner_evaluator_image=TEST_RUNNER_EVALUATOR_IMAGE,
    aws_endpoint_url=AWS_ENDPOINT_URL,
    aws_access_key_id=AWS_ACCESS_KEY_ID,
    aws_secret_access_key=AWS_SECRET_ACCESS_KEY,
    s3_bucket=S3_BUCKET,
    s3_upload_path_template=S3_UPLOAD_PATH_TEMPLATE,
    s3_upload_path_template_use_submission_id=S3_UPLOAD_PATH_TEMPLATE_USE_SUBMISSION_ID,
    batch_api=batch_api,
    core_api=core_api,
    **kwargs
  )
