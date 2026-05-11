"""
List jobs of last 24h and their status.
"""
import datetime
import time
from pathlib import Path
from uuid import UUID

from dotenv import dotenv_values
from kubernetes import config, client
from kubernetes.client import V1JobList, V1Job, V1JobStatus, V1ObjectMeta

from fab_clientlib import DefaultApi, ApiClient, Configuration
from orchestrator_common import backend_application_flow

# _ENV_PATH = Path(__file__).resolve().parent.parent / ".env"
_ENV_PATH = Path(__file__).resolve().parent.parent / ".env.prod"
_ENV_VARS = dotenv_values(_ENV_PATH)

if __name__ == '__main__':
  after = datetime.datetime.now(datetime.timezone.utc) - datetime.timedelta(hours=24)
  print(after)
  only_active = True

  config.load_kube_config()
  batch_api = client.BatchV1Api()
  core_api = client.CoreV1Api()

  while True:
    print(f"====================================== {_ENV_PATH.name}")
    jobs: V1JobList = batch_api.list_namespaced_job(namespace=_ENV_VARS.get("KUBERNETES_NAMESPACE"))
    submission_ids = {}
    items = jobs.items
    items.sort(key=lambda x: x.metadata.creation_timestamp)
    for job in items:
      job: V1Job = job
      status: V1JobStatus = job.status
      metadata: V1ObjectMeta = job.metadata
      creation_timestamp = metadata.creation_timestamp

      if 'orchestration' in metadata.labels and creation_timestamp >= after:

        if not only_active or status.active:
          submission_ids[metadata.labels["orchestration"]] = job

    token = backend_application_flow(_ENV_VARS.get("CLIENT_ID"), _ENV_VARS.get("CLIENT_SECRET"), _ENV_VARS.get("TOKEN_URL"))

    for submission_id, job in submission_ids.items():
      fab = DefaultApi(ApiClient(configuration=Configuration(host=_ENV_VARS.get("FAB_API_URL"), access_token=token["access_token"])))
      statuses = fab.submissions_submission_ids_statuses_get(submission_ids=[UUID(submission_id)], )

      job_status: V1JobStatus = job.status
      print(
        f"{job.metadata.name}: started at {job.metadata.creation_timestamp}, conditions={[c.type for c in job_status.conditions] if job_status.conditions is not None else None} ")
      print(f"   {submission_id}: [{statuses.body[-1].timestamp}] {statuses.body[-1].status} {statuses.body[-1].message}")
      print(f"   {submission_id}: [{statuses.body[0].timestamp}] {statuses.body[0].status} {statuses.body[0].message}")
      results = fab.results_submissions_submission_ids_get(submission_ids=[submission_id], )

      for scoring in results.body[0].scorings:
        print(f"   {scoring.field_key} {scoring.score}")
    time.sleep(5)
