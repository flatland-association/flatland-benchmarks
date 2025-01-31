import os

from kubernetes import client
from kubernetes import config

KUBERNETES_NAMESPACE = os.environ.get("KUBERNETES_NAMESPACE", "nge-int")

if __name__ == '__main__':
  config.load_kube_config()
  batch_api = client.BatchV1Api()
  jobs = batch_api.list_namespaced_job(namespace=KUBERNETES_NAMESPACE)
  for job in jobs.items:
    print(f"kubectl -n {KUBERNETES_NAMESPACE} delete jobs.batch {job.metadata.name}")
