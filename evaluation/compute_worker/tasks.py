# based on https://github.com/codalab/codabench/blob/develop/compute_worker/compute_worker.py
import logging
import os
import time
import uuid

import yaml
from celery import Celery
from kubernetes import client, config
from kubernetes.client import BatchV1Api, CoreV1Api

logger = logging.getLogger()

app = Celery(
  broker=os.environ.get('BROKER_URL'),
  backend=os.environ.get('REDIS_IP'),
)

KUBERNETES_NAMESPACE = os.environ.get("KUBERNETES_NAMESPACE", "nge-int")
AWS_ENDPOINT_URL = os.environ.get("AWS_ENDPOINT_URL", None)
AWS_ACCESS_KEY_ID = os.environ.get("AWS_ACCESS_KEY_ID", None)
AWS_SECRET_ACCESS_KEY = os.environ.get("AWS_SECRET_ACCESS_KEY", None)
S3_BUCKET = os.environ.get("S3_BUCKET", None)
AICROWD_IS_GRADING = os.environ.get("AICROWD_IS_GRADING", None)


# TODO https://github.com/flatland-association/flatland-benchmarks/issues/27 start own redis for evaluator <-> submission communication? Split in flatland-repo?
# N.B. name to be used by send_task
@app.task(name="flatland3-evaluation", bind=True)
def the_task(self, docker_image: str, submission_image: str):
  task_id = self.request.id
  config.load_incluster_config()
  # https://github.com/kubernetes-client/python/
  # https://github.com/kubernetes-client/python/blob/master/examples/in_cluster_config.py
  batch_api = client.BatchV1Api()
  core_api = client.CoreV1Api()
  return run_evaluation(task_id=task_id, docker_image=docker_image, submission_image=submission_image, batch_api=batch_api, core_api=core_api)


def run_evaluation(task_id: str, docker_image: str, submission_image: str, batch_api: BatchV1Api, core_api: CoreV1Api):
  start_time = time.time()
  logger.info(f"/ start task with task_id={task_id} with docker_image={docker_image} and submission_image={submission_image}")

  evaluator_definition = yaml.safe_load(open("evaluator_job.yaml"))
  evaluator_definition["metadata"]["name"] = f"{evaluator_definition['metadata']['name']}-{task_id}"
  evaluator_definition["metadata"]["labels"]["task_id"] = task_id
  evaluator_container_definition = evaluator_definition["spec"]["template"]["spec"]["containers"][0]
  evaluator_container_definition["image"] = docker_image
  evaluator_container_definition["env"].append({"name": "AICROWD_SUBMISSION_ID", "value": task_id})

  if AWS_ENDPOINT_URL:
    evaluator_container_definition["env"].append({"name": "AWS_ENDPOINT_URL", "value": AWS_ENDPOINT_URL})
  if AWS_ACCESS_KEY_ID:
    evaluator_container_definition["env"].append({"name": "AWS_ACCESS_KEY_ID", "value": AWS_ACCESS_KEY_ID})
  if AWS_SECRET_ACCESS_KEY:
    evaluator_container_definition["env"].append({"name": "AWS_SECRET_ACCESS_KEY", "value": AWS_SECRET_ACCESS_KEY})
  if S3_BUCKET:
    evaluator_container_definition["env"].append({"name": "S3_BUCKET", "value": S3_BUCKET})
  if AICROWD_IS_GRADING:
    evaluator_container_definition["env"].append({"name": "AICROWD_IS_GRADING", "value": AICROWD_IS_GRADING})
  evaluator = client.V1Job(metadata=evaluator_definition["metadata"], spec=evaluator_definition["spec"])
  batch_api.create_namespaced_job(KUBERNETES_NAMESPACE, evaluator)

  submission_definition = yaml.safe_load(open("submission_job.yaml"))
  submission_definition["metadata"]["name"] = f"{submission_definition['metadata']['name']}-{task_id}"
  submission_definition["metadata"]["labels"]["task_id"] = task_id
  submission_container_definition = submission_definition["spec"]["template"]["spec"]["containers"][0]
  submission_container_definition["image"] = submission_image
  submission_container_definition["env"].append({"name": "AICROWD_SUBMISSION_ID", "value": task_id})
  submission = client.V1Job(metadata=submission_definition["metadata"], spec=submission_definition["spec"])
  batch_api.create_namespaced_job(KUBERNETES_NAMESPACE, submission)

  done = False
  ret = {}
  while not done:
    print(".")
    jobs = batch_api.list_namespaced_job(namespace=KUBERNETES_NAMESPACE, label_selector=f"task_id={task_id}")
    assert len(jobs.items) == 2
    done = True
    status = []

    for job in jobs.items:
      done = done and job.status.conditions is not None

    if done:
      for job in jobs.items:
        status.append(job.status.conditions[0].type)
        job_name = job.metadata.name
        pods = core_api.list_namespaced_pod(namespace=KUBERNETES_NAMESPACE, label_selector=f"job-name={job_name}")
        assert len(pods.items) == 1
        pod = pods.items[0]
        log = core_api.read_namespaced_pod_log(pod.metadata.name, namespace=KUBERNETES_NAMESPACE)

        _ret = {}
        _ret["job_status"] = job.status.conditions[0].type
        _ret["image_id"] = pod.status.container_statuses[0].image_id
        _ret["log"] = log
        _ret["job"] = job.to_dict()
        _ret["pod"] = pod.to_dict()
        ret[job_name] = _ret

  all_completed = all([s == "Complete" for s in status])
  print(f"done {status}, all_completed={all_completed}")
  duration = time.time() - start_time
  print(ret)
  logger.info(f"\\ end task with task_id={task_id} with docker_image={docker_image} and submission_image={submission_image}. Took {duration} seconds.")
  return ret


if __name__ == '__main__':
  TASK_ID = str(uuid.uuid4())
  config.load_kube_config()
  run_evaluation(
    task_id=TASK_ID,
    submission_image="ghcr.io/flatland-association/fab-flatland-submission-template:latest",
    docker_image="ghcr.io/flatland-association/fab-flatland-evaluator:latest",
  )
