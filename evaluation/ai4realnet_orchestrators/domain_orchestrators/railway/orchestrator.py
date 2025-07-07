# based on https://github.com/codalab/codabench/blob/develop/compute_worker/compute_worker.py
import logging
import os
import ssl
import traceback
from typing import Dict
from typing import List

from celery import Celery

from .test_runner_evaluator_557d9a00 import run_and_evaluate_test_557d9a00

logger = logging.getLogger(__name__)

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


class TaskExecutionError(Exception):
  def __init__(self, message: str, status: Dict):
    super().__init__(message)
    self.message = message
    self.status = status


# https://docs.celeryq.dev/en/stable/userguide/tasks.html#bound-tasks: A task being bound means the first argument to the task will always be the task instance (self).
# https://docs.celeryq.dev/en/stable/userguide/tasks.html#names: Every task must have a unique name.
@app.task(name=os.environ.get("BENCHMARK_ID"), bind=True)
def orchestrator(self, submission_data_url: str, tests: List[str] = None, **kwargs):
  try:
    # we use the submission_id as the unique id of the executing task.
    submission_id = self.request.id
    # we use the benchmark_id as the task's name and queue name (i.e. one task per benchmark). This ensures the Celery task is routed to the responsible orchestrator
    benchmark_id = orchestrator.name
    logger.info(f"Queue/task {benchmark_id} received submission {submission_id} with submission_data_url={submission_data_url} for tests={tests}")
    for test_id in tests:
      if test_id == "557d9a00-7e6d-410b-9bca-a017ca7fe3aa":
        run_and_evaluate_test_557d9a00(submission_id=submission_id, test_id=test_id, submission_data_url=submission_data_url)
      elif test_id == "[INSERT HERE: @TestId]":
        pass
      else:
        raise TaskExecutionError(status={"orchestrator": "FAILED"}, message=f"Test {test_id} not implemented in {self}")

    return {
      "status": "SUCCESS",
      "message": "message"
    }
  except BaseException as e:
    raise Exception(f"{e} with tb {traceback.format_exc()}")
