import os

from kubernetes import client
from kubernetes import config
from kubernetes.client import V1PodList

KUBERNETES_NAMESPACE = os.environ.get("KUBERNETES_NAMESPACE", "fab-int")

if __name__ == '__main__':
  config.load_kube_config()
  batch_api = client.BatchV1Api()
  core_api = client.CoreV1Api()
  jobs = batch_api.list_namespaced_job(namespace=KUBERNETES_NAMESPACE)
  for job in jobs.items:
    args = ["kubectl", "-n", KUBERNETES_NAMESPACE, "get", "jobs.batch", job.metadata.name]
    print(f"{args}")
    print(job.status)
    try:
      pods: V1PodList = core_api.list_namespaced_pod(namespace=KUBERNETES_NAMESPACE, label_selector=f"job-name={job.metadata.name}")
      pod = pods.items[-1]
      print(core_api.read_namespaced_pod_log(pod.metadata.name, namespace=KUBERNETES_NAMESPACE))
    except:
      print("-> could not fetch logs")
