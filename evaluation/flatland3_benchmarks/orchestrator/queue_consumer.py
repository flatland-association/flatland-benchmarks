# based on https://github.com/codalab/codabench/blob/develop/orchestrator/orchestrator.py
import logging

from orchestrator_job import trigger_orchestrator_job

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
  config.load_incluster_config()
  trigger_orchestrator_job(submission_id=submission_id, submission_data_url=submission_data_url, tests=tests, **kwargs)
