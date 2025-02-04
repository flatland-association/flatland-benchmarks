# based on https://github.com/codalab/codabench/blob/develop/compute_worker/compute_worker.py
import json
import logging
import os
import tarfile
import tempfile
import time
import uuid
from io import StringIO
from pathlib import Path

import kubernetes
import pandas as pd
import yaml
from celery import Celery
from kubernetes import client, config
from kubernetes.client import BatchV1Api, CoreV1Api

logger = logging.getLogger(__name__)

KUBERNETES_NAMESPACE = os.environ.get("KUBERNETES_NAMESPACE", "fab-int")
REDIS_IP = os.environ.get('REDIS_IP', KUBERNETES_NAMESPACE + "-redis-master")
KUBERNETES_PVC = os.environ.get('KUBERNETES_PVC', KUBERNETES_NAMESPACE + "-results")
AWS_ENDPOINT_URL = os.environ.get("AWS_ENDPOINT_URL", None)
AWS_ACCESS_KEY_ID = os.environ.get("AWS_ACCESS_KEY_ID", None)
AWS_SECRET_ACCESS_KEY = os.environ.get("AWS_SECRET_ACCESS_KEY", None)
S3_BUCKET = os.environ.get("S3_BUCKET", None)

app = Celery(
  broker=os.environ.get('BROKER_URL'),
  backend=REDIS_IP,
)

# TODO https://github.com/flatland-association/flatland-benchmarks/issues/27 start own redis for evaluator <-> submission communication? Split in flatland-repo?
# N.B. name to be used by send_task
@app.task(name="flatland3-evaluation", bind=True)
def the_task(self, docker_image: str, submission_image: str, **kwargs):
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

  evaluator_definition = yaml.safe_load(open(Path(__file__).parent / "evaluator_job.yaml"))
  evaluator_definition["metadata"]["name"] = f"{evaluator_definition['metadata']['name']}-{task_id}"
  evaluator_definition["metadata"]["labels"]["task_id"] = task_id
  evaluator_container_definition = evaluator_definition["spec"]["template"]["spec"]["containers"][0]
  evaluator_container_definition["image"] = docker_image
  evaluator_container_definition["env"].append({"name": "AICROWD_SUBMISSION_ID", "value": task_id})
  evaluator_container_definition["env"].append({"name": "redis_ip", "value": REDIS_IP})
  evaluator_definition["spec"]["template"]["spec"]["volumes"][2]["persistentVolumeClaim"]["claimName"] = KUBERNETES_PVC

  if AWS_ENDPOINT_URL:
    evaluator_container_definition["env"].append({"name": "AWS_ENDPOINT_URL", "value": AWS_ENDPOINT_URL})
  if AWS_ACCESS_KEY_ID:
    evaluator_container_definition["env"].append({"name": "AWS_ACCESS_KEY_ID", "value": AWS_ACCESS_KEY_ID})
  if AWS_SECRET_ACCESS_KEY:
    evaluator_container_definition["env"].append({"name": "AWS_SECRET_ACCESS_KEY", "value": AWS_SECRET_ACCESS_KEY})
  if S3_BUCKET:
    evaluator_container_definition["env"].append({"name": "S3_BUCKET", "value": S3_BUCKET})
  evaluator_container_definition["env"].append({"name": "AICROWD_IS_GRADING", "value": "True"})


  evaluator = client.V1Job(metadata=evaluator_definition["metadata"], spec=evaluator_definition["spec"])
  batch_api.create_namespaced_job(KUBERNETES_NAMESPACE, evaluator)

  submission_definition = yaml.safe_load(open(Path(__file__).parent / "submission_job.yaml"))
  submission_definition["metadata"]["name"] = f"{submission_definition['metadata']['name']}-{task_id}"
  submission_definition["metadata"]["labels"]["task_id"] = task_id
  submission_container_definition = submission_definition["spec"]["template"]["spec"]["containers"][0]
  submission_container_definition["image"] = submission_image
  submission_container_definition["env"].append({"name": "AICROWD_SUBMISSION_ID", "value": task_id})
  submission_container_definition["env"].append({"name": "redis_ip", "value": REDIS_IP})
  submission = client.V1Job(metadata=submission_definition["metadata"], spec=submission_definition["spec"])
  batch_api.create_namespaced_job(KUBERNETES_NAMESPACE, submission)

  done = False
  ret = {}
  while not done:
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
    time.sleep(1)

  retriever_definition = yaml.safe_load(open(Path(__file__).parent / "retriever_pod.yaml"))
  retriever_definition["metadata"]["name"] = f"f3-retriever-{task_id}"
  retriever = client.V1Pod(metadata=retriever_definition["metadata"], spec=retriever_definition["spec"])

  core_api.create_namespaced_pod(KUBERNETES_NAMESPACE, retriever)
  while True:
    resp = core_api.read_namespaced_pod(name=f"f3-retriever-{task_id}", namespace=KUBERNETES_NAMESPACE)
    if resp.status.phase != 'Pending':
      break
    time.sleep(1)
  k8s_copy_file_from_pod(namespace=KUBERNETES_NAMESPACE, pod_name=f"f3-retriever-{task_id}", source_file=f"/data/", dest_path=f"/tmp/results-{task_id}")
  k8s_copy_file_from_pod(namespace=KUBERNETES_NAMESPACE, pod_name=f"f3-retriever-{task_id}", source_file=f"/data/", dest_path=f"/tmp/results-{task_id}")
  core_api.delete_namespaced_pod(namespace=KUBERNETES_NAMESPACE, name=f"f3-retriever-{task_id}")

  ret["f3-evaluator"] = ret[f"f3-evaluator-{TASK_ID}"]
  ret["f3-submission"] = ret[f"f3-submission-{TASK_ID}"]
  del ret[f"f3-evaluator-{TASK_ID}"]
  del ret[f"f3-submission-{TASK_ID}"]

  ret["f3-evaluator"]["results.csv"] = open(f"/tmp/results-{task_id}/data/results-{task_id}.csv").read()
  ret["f3-evaluator"]["results.json"] = open(f"/tmp/results-{task_id}/data/results-{task_id}.json").read()

  all_completed = all([s == "Complete" for s in status])
  print(f"done {status}, all_completed={all_completed}")
  duration = time.time() - start_time
  print(ret)
  logger.info(f"\\ end task with task_id={task_id} with docker_image={docker_image} and submission_image={submission_image}. Took {duration} seconds.")
  return ret


# source: https://github.com/kubernetes-client/python/issues/476
def k8s_copy_file_from_pod(namespace: str, pod_name: str, source_file: str, dest_path: str):
  exec_command = ['/bin/sh', '-c', f'cd {Path(source_file).parent}; tar czf - {Path(source_file).name}']
  with tempfile.TemporaryFile() as buff:
    resp = kubernetes.stream.stream(kubernetes.client.CoreV1Api().connect_get_namespaced_pod_exec, pod_name, namespace,
                                    command=exec_command,
                                    binary=True,
                                    stderr=True, stdin=True,
                                    stdout=True, tty=False,
                                    _preload_content=False)
    while resp.is_open():
      resp.update(timeout=1)
      if resp.peek_stdout():
        out = resp.read_stdout()
        logging.info(f"got {len(out)} bytes")
        buff.write(out)
      if resp.peek_stderr():
        logging.warning(f"STDERR: {resp.read_stderr().decode('utf-8')}")
    resp.close()
    buff.flush()
    buff.seek(0)
    with tarfile.open(fileobj=buff, mode='r:gz') as tar:
      subdir_and_files = [
        tarinfo for tarinfo in tar.getmembers()
      ]
      tar.extractall(path=dest_path, members=subdir_and_files)


# TODO https://github.com/flatland-association/flatland-benchmarks/issues/82 automated integration test against deployed FAB...
if __name__ == '__main__':
  TASK_ID = str(uuid.uuid4())
  config.load_kube_config()
  batch_api = client.BatchV1Api()
  core_api = client.CoreV1Api()
  ret = run_evaluation(
    batch_api=batch_api,
    core_api=core_api,
    task_id=TASK_ID,
    submission_image="ghcr.io/flatland-association/fab-flatland-submission-template:latest",
    docker_image="ghcr.io/flatland-association/fab-flatland-evaluator:latest",
  )

  assert set(ret.keys()) == {"f3-evaluator", "f3-submission"}

  assert set(ret["f3-evaluator"].keys()) == {"job_status", "image_id", "log", "job", "pod", "results.csv", "results.json"}
  assert set(ret["f3-submission"].keys()) == {"job_status", "image_id", "log", "job", "pod"}

  assert ret["f3-evaluator"]["job_status"] == "Complete"
  assert ret["f3-submission"]["job_status"] == "Complete"

  assert ret["f3-evaluator"]["image_id"].startswith("ghcr.io/flatland-association/fab-flatland-evaluator")
  assert ret["f3-submission"]["image_id"].startswith("ghcr.io/flatland-association/fab-flatland-submission-template")

  assert "end evaluator/run.sh" in str(ret["f3-evaluator"]["log"])
  assert "end submission_template/run.sh" in str(ret["f3-submission"]["log"])

  res_df = pd.read_csv(StringIO(ret["f3-evaluator"]["results.csv"]))
  print(res_df)
  res_json = json.loads(ret["f3-evaluator"]["results.json"])
  print(res_json)
