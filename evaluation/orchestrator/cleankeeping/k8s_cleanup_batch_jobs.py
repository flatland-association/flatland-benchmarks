import os
import subprocess

from kubernetes import client
from kubernetes import config

KUBERNETES_NAMESPACE = os.environ.get("KUBERNETES_NAMESPACE", "fab-int")

if __name__ == '__main__':
  dry_run = False
  config.load_kube_config()
  batch_api = client.BatchV1Api()
  jobs = batch_api.list_namespaced_job(namespace=KUBERNETES_NAMESPACE)
  for job in jobs.items:
    args = ["kubectl", "-n", KUBERNETES_NAMESPACE, "delete", "jobs.batch", job.metadata.name]
    print(f"{args}")
    if not dry_run:
      subprocess.call(args)
