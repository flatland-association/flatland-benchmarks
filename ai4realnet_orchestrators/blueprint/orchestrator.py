# based on https://github.com/codalab/codabench/blob/develop/compute_worker/compute_worker.py
import logging
import os
from pathlib import Path
from typing import Dict
from typing import List

from celery import Celery

from ai4realnet_orchestrators.blueprint.test_runner_evaluator import test_runner_evaluator

logger = logging.getLogger(__name__)

app = Celery(
  broker=os.environ.get('BROKER_URL'),
  backend=os.environ.get('BACKEND_URL'),
)


class TaskExecutionError(Exception):
  def __init__(self, message: str, status: Dict):
    super().__init__(message)
    self.message = message
    self.status = status


# https://docs.celeryq.dev/en/stable/userguide/tasks.html#bound-tasks: A task being bound means the first argument to the task will always be the task instance (self).
# https://docs.celeryq.dev/en/stable/userguide/tasks.html#names: Every task must have a unique name.
@app.task(name="[INSERT HERE: @BenchmarkId]", bind=True)
def orchestrator(self, submission_data_url: str, tests: List[str] = None, **kwargs):
  # we use the submission_id as the unique id of the executing task.
  submission_id = self.request.id
  # we use the benchmark_id as the task's name (i.e. one task per benchmark). This ensures the Celery task is routed to the responsible orchestrator
  benchmark_id = orchestrator.name
  for test_id in tests:
    if test_id == "[INSERT HERE: @TestId]":
      filename = Path(f"{test_id}_{submission_id}.json")
      test_runner_evaluator(submission_id=submission_id, test_id=test_id, submission_data_url=submission_data_url, filename=filename)
      upload(submission_id=submission_id, test_id=test_id, filename=filename)
    elif test_id == "[INSERT HERE: @TestId]":
      pass
    else:
      raise TaskExecutionError(status={"orchestrator": "FAILED"}, message=f"Test {test_id} not implemented in {self}")

  return {
    "status": "SUCCESS",
    "message": "message"
  }


def upload(submission_id: str, test_id: str, filename: Path):
  # TODO authentication/authorization
  # TODO call REST api
  pass
