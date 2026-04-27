# based on https://github.com/codalab/codabench/blob/develop/orchestrator/orchestrator.py
import json
import logging

from orchestration_job import trigger_orchestrator_job, _load_orchestration_config

logger = logging.getLogger(__name__)
# based on https://github.com/codalab/codabench/blob/develop/orchestrator/orchestrator.py
import os
import ssl
from typing import List

from celery import Celery
from celery.app.log import TaskFormatter
from celery.signals import after_setup_task_logger
from kubernetes import config

BENCHMARK_ID = os.environ.get("BENCHMARK_ID", "flatland3-evaluation")
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


# https://celery.school/custom-celery-task-logger
@after_setup_task_logger.connect
def setup_task_logger(logger, *args, **kwargs):
  for handler in logger.handlers:
    tf = TaskFormatter("[%(asctime)s][%(levelname)s][%(process)d][%(pathname)s:%(funcName)s:%(lineno)d] [%(task_name)s] - [%(task_id)s] - %(message)s")
    handler.setFormatter(tf)


# N.B. name to be used by send_task
@app.task(name=BENCHMARK_ID, bind=True)
def queue_consumer(self, submission_data_url: str, tests: List[str] = None, **kwargs):
  submission_id = self.request.id
  logger.info(f"// START received message for submission_id={submission_id},tests={tests}")
  config.load_incluster_config()
  _vars = {}
  _vars["SUBMISSION_ID"] = submission_id
  _vars["SUBMISSION_DATA_URL"] = submission_data_url
  if tests is not None:
    # pass on to orchestration job as comma-separated env var
    _vars["TESTS"] = ",".join(tests)

  orch_config = _load_orchestration_config(_vars)
  logger.info(f"// vars for submission_id={submission_id}: :\n{json.dumps(orch_config, indent=2)}")
  try:
    trigger_orchestrator_job(orch_config)
  except Exception as e:
    logger.info(f"\\ FAILED received message for submission_id={submission_id}")
    raise e
  logger.info(f"\\ END received message for submission_id={submission_id}")
