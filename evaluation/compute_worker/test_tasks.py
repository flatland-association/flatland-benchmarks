from unittest.mock import Mock

from kubernetes.client import V1JobList

from tasks import run_evaluation


def test_tasks():
  core_api = Mock()
  batch_api = Mock()

  batch_api.list_namespaced_job.return_value = V1JobList(items=[])
  run_evaluation(task_id="1234", docker_image="fancy", submission_image="pancy", batch_api=batch_api, core_api=core_api)
