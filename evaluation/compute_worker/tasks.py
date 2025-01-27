# based on https://github.com/codalab/codabench/blob/develop/compute_worker/compute_worker.py
import logging
import os
import time
import uuid

import yaml
from celery import Celery
from kubernetes import client, config

logger = logging.getLogger()

app = Celery(
  broker=os.environ.get('BROKER_URL'),
  backend=os.environ.get('REDIS_IP'),
)

KUBERNETES_NAMESPACE = os.environ.get("KUBERNETES_NAMESPACE", "nge-int")


# TODO https://github.com/flatland-association/flatland-benchmarks/issues/27 start own redis for evaluator <-> submission communication? Split in flatland-repo?
# N.B. name to be used by send_task
@app.task(name="flatland3-evaluation", bind=True)
def the_task(self, docker_image: str, submission_image: str):
  task_id = self.request.id
  config.load_incluster_config()
  return run_evaluation(task_id=task_id, docker_image=docker_image, submission_image=submission_image)


def run_evaluation(task_id: str, docker_image: str, submission_image: str):
  start_time = time.time()
  logger.info(f"/ start task with task_id={task_id} with docker_image={docker_image} and submission_image={submission_image}")

  # https://github.com/kubernetes-client/python/
  # https://github.com/kubernetes-client/python/blob/master/examples/in_cluster_config.py

  batch_api = client.BatchV1Api()
  core_api = client.CoreV1Api()

  evaluator_definition = yaml.safe_load(open("evaluator_job.yaml"))
  evaluator_definition["metadata"]["name"] = f"{evaluator_definition['metadata']['name']}-{task_id}"
  evaluator_definition["metadata"]["labels"]["task_id"] = task_id
  evaluator_definition["spec"]["template"]["spec"]["containers"][0]["image"] = docker_image
  evaluator = client.V1Job(metadata=evaluator_definition["metadata"], spec=evaluator_definition["spec"])
  batch_api.create_namespaced_job(KUBERNETES_NAMESPACE, evaluator)

  submission_definition = yaml.safe_load(open("submission_job.yaml"))
  submission_definition["metadata"]["name"] = f"{submission_definition['metadata']['name']}-{task_id}"
  submission_definition["metadata"]["labels"]["task_id"] = task_id
  submission_definition["spec"]["template"]["spec"]["containers"][0]["image"] = submission_image
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
        _ret["job"] = job
        _ret["pod"] = pod
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
