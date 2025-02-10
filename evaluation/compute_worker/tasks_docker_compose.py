# based on https://github.com/codalab/codabench/blob/develop/compute_worker/compute_worker.py
import asyncio
import logging
import os
import subprocess
import time
from io import BytesIO, TextIOWrapper
from typing import List

import boto3
import celery.exceptions
from celery import Celery
from celery.app.log import TaskFormatter
from celery.signals import after_setup_task_logger
from celery.utils.log import get_task_logger

logger = get_task_logger(__name__)

app = Celery(
  broker=os.environ.get('BROKER_URL'),
  backend=os.environ.get('REDIS_IP'),
)

HOST_DIRECTORY = os.environ.get("HOST_DIRECTORY", "/tmp/codabench/")
AWS_ENDPOINT_URL = os.environ.get("AWS_ENDPOINT_URL", None)
AWS_ACCESS_KEY_ID = os.environ.get("AWS_ACCESS_KEY_ID", None)
AWS_SECRET_ACCESS_KEY = os.environ.get("AWS_SECRET_ACCESS_KEY", None)
S3_BUCKET = os.environ.get("S3_BUCKET", None)
S3_UPLOAD_PATH_TEMPLATE = os.getenv("S3_UPLOAD_PATH_TEMPLATE", None)
S3_UPLOAD_PATH_TEMPLATE_USE_SUBMISSION_ID = os.getenv("S3_UPLOAD_PATH_TEMPLATE_USE_SUBMISSION_ID", None)

BENCHMARKING_NETWORK = os.environ.get("BENCHMARKING_NETWORK", None)
SUPPORTED_CLIENT_VERSIONS = os.environ.get("SUPPORTED_CLIENT_VERSIONS", "4.0.3,4.0.3.dev23+gaa5df390")


# https://celery.school/custom-celery-task-logger
@after_setup_task_logger.connect
def setup_task_logger(logger, *args, **kwargs):
  for handler in logger.handlers:
    tf = TaskFormatter("[%(asctime)s][%(levelname)s][%(process)d][%(pathname)s:%(funcName)s:%(lineno)d] [%(task_name)s] - [%(task_id)s] - %(message)s")
    handler.setFormatter(tf)


# N.B. name to be used by send_task
@app.task(name="flatland3-evaluation", bind=True, soft_time_limit=10 * 60, time_limit=12 * 60)
def the_task(self, docker_image: str, submission_image: str, tests: List[str] = None, **kwargs):
  task_id = self.request.id

  try:
    start_time = time.time()
    logger.info(f"/ start task with task_id={task_id} with docker_image={docker_image} and submission_image={submission_image}")
    assert BENCHMARKING_NETWORK is not None

    loop = asyncio.get_event_loop()
    evaluator_future = loop.create_future()
    submission_future = loop.create_future()
    evaluator_exec_args = [
      "sudo", "docker", "run",
      "--name", f"flatland3-evaluator-{task_id}",
      "-e", "redis_ip=redis",
      "-e", f"AICROWD_SUBMISSION_ID={task_id}",
    ]
    if AWS_ENDPOINT_URL:
      evaluator_exec_args.extend(["-e", f"AWS_ENDPOINT_URL={AWS_ENDPOINT_URL}"])
    if AWS_ACCESS_KEY_ID:
      evaluator_exec_args.extend(["-e", f"AWS_ACCESS_KEY_ID={AWS_ACCESS_KEY_ID}"])
    if AWS_SECRET_ACCESS_KEY:
      evaluator_exec_args.extend(["-e", f"AWS_SECRET_ACCESS_KEY={AWS_SECRET_ACCESS_KEY}"])
    if S3_BUCKET:
      evaluator_exec_args.extend(["-e", f"S3_BUCKET={S3_BUCKET}"])
    if S3_UPLOAD_PATH_TEMPLATE:
      evaluator_exec_args.extend(["-e", f"S3_UPLOAD_PATH_TEMPLATE={S3_UPLOAD_PATH_TEMPLATE}"])
    if S3_UPLOAD_PATH_TEMPLATE_USE_SUBMISSION_ID:
      evaluator_exec_args.extend(["-e", f"S3_UPLOAD_PATH_TEMPLATE_USE_SUBMISSION_ID={S3_UPLOAD_PATH_TEMPLATE_USE_SUBMISSION_ID}"])
    if SUPPORTED_CLIENT_VERSIONS is not None:
      evaluator_exec_args.extend(["-e", f"SUPPORTED_CLIENT_VERSIONS={SUPPORTED_CLIENT_VERSIONS}"])
    if tests is not None:
      evaluator_exec_args.extend(["-e", f"TEST_ID_FILTER={','.join(tests)}"])
    evaluator_exec_args.extend(["-e", f"AICROWD_IS_GRADING={True}"])

    evaluator_exec_args.extend([
      "-v", f"{HOST_DIRECTORY}/evaluator/debug-environments/:/tmp/environments",
      "-e", "AICROWD_TESTS_FOLDER=/tmp/environments/",
      "--network", BENCHMARKING_NETWORK,
      docker_image,
    ])

    exec_with_logging(["sudo", "docker", "pull", docker_image])
    exec_with_logging(["sudo", "docker", "pull", submission_image])

    gathered_tasks = asyncio.gather(
      run_async_and_catch_output(evaluator_future, exec_args=evaluator_exec_args),
      run_async_and_catch_output(submission_future, exec_args=[
        "sudo", "docker", "run",
        "--name", f"flatland3-submission-{task_id}",
        "-e", "redis_ip=redis",
        "-e", "AICROWD_TESTS_FOLDER=/tmp/environments/",
        "-e", f"AICROWD_SUBMISSION_ID={task_id}",
        "-v", f"{HOST_DIRECTORY}/evaluator/debug-environments/:/tmp/environments/",
        "--network", BENCHMARKING_NETWORK,
        submission_image,
      ])
    )
    loop.run_until_complete(gathered_tasks)
    duration = time.time() - start_time
    logger.info(f"\\ end task with task_id={task_id} with docker_image={docker_image} and submission_image={submission_image}. Took {duration:.2f} seconds.")

    ret_evaluator = evaluator_future.result()
    ret_evaluator["image_id"] = docker_image
    ret_submission = submission_future.result()
    ret_submission["image_id"] = submission_image
    ret = {"f3-evaluator": ret_evaluator, "f3-submission": ret_submission}
    logger.debug("Task with task_id=%s got results from docker run: %s.", task_id, ret)

    if ret_evaluator["job_status"] != "Complete" or ret_submission["job_status"] != "Complete":
      raise Exception(f"Evaluator or submission failed, aborting: {ret}")

    logger.info("Get results files from S3 under %s...", AWS_ENDPOINT_URL)
    s3 = boto3.client(
      's3',
      # https://docs.weka.io/additional-protocols/s3/s3-examples-using-boto3
      endpoint_url=AWS_ENDPOINT_URL,
      aws_access_key_id=AWS_ACCESS_KEY_ID,
      aws_secret_access_key=AWS_SECRET_ACCESS_KEY
    )
    obj = s3.get_object(Bucket=S3_BUCKET, Key=S3_UPLOAD_PATH_TEMPLATE.format(task_id) + ".csv")
    ret_evaluator["results.csv"] = obj['Body'].read().decode("utf-8")
    obj = s3.get_object(Bucket=S3_BUCKET, Key=S3_UPLOAD_PATH_TEMPLATE.format(task_id) + ".json")
    ret_evaluator["results.json"] = obj['Body'].read().decode("utf-8")

    logger.info(f"Get logs from containers...")
    exec_with_logging(["sudo", "docker", "ps"])
    try:
      logger.info("/ Logs from container %s", f"flatland3-evaluator-{task_id}")
      exec_with_logging(["sudo", "docker", "logs", f"flatland3-evaluator-{task_id}", ])
      exec_with_logging(["sudo", "docker", "rm", f"flatland3-evaluator-{task_id}", ])
      logger.info("\\ Logs from container %s", f"flatland3-evaluator-{task_id}")
    except:
      logger.warning("Could not fetch logs from container %s", f"flatland3-evaluator-{task_id}")
    try:
      logger.warning("/ Logs from container %s", f"flatland3-submission-{task_id}")
      exec_with_logging(["sudo", "docker", "logs", f"flatland3-submission-{task_id}", ])
      exec_with_logging(["sudo", "docker", "rm", f"flatland3-submission-{task_id}", ])
      logger.warning("\\ Logs from container %s", f"flatland3-submission-{task_id}")
    except:
      logger.warning("Could not fetch logs from container %s", f"flatland3-submission-{task_id}")
    return ret

  except celery.exceptions.SoftTimeLimitExceeded as e:
    logger.info("Hit %s - getting logs from containers", e)
    exec_with_logging(["sudo", "docker", "ps"])
    try:
      logger.info("/ Logs from container %s", f"flatland3-evaluator-{task_id}")
      exec_with_logging(["sudo", "docker", "logs", f"flatland3-evaluator-{task_id}", ])
      logger.info("\\ Logs from container %s", f"flatland3-evaluator-{task_id}")
    except:
      logger.warning("Could not fetch logs from container %s", f"flatland3-evaluator-{task_id}")
    try:
      logger.warning("/ Logs from container %s", f"flatland3-submission-{task_id}")
      exec_with_logging(["sudo", "docker", "logs", f"flatland3-submission-{task_id}", ])
      logger.warning("\\ Logs from container %s", f"flatland3-submission-{task_id}")
    except:
      logger.warning("Could not fetch logs from container %s", f"flatland3-submission-{task_id}")
    raise e


# https://stackoverflow.com/questions/21953835/run-subprocess-and-print-output-to-logging
def exec_with_logging(exec_args: List[str]):
  logger.debug(f"/ Start %s", exec_args)
  try:
    proc = subprocess.Popen(exec_args, stdout=subprocess.PIPE, stderr=subprocess.STDOUT)
    stdout, stderr = proc.communicate()
    log_subprocess_output(TextIOWrapper(BytesIO(stdout)), level=logging.INFO, label=str(exec_args))
    log_subprocess_output(TextIOWrapper(BytesIO(stderr)), level=logging.WARN, label=str(exec_args))
  except (OSError, subprocess.CalledProcessError) as exception:
    logger.error(stderr)
    raise RuntimeError(f"Failed to run {exec_args}. Stdout={stdout}. Stderr={stderr}") from exception
  logger.debug("\\ End %s", exec_args)


# https://stackoverflow.com/questions/21953835/run-subprocess-and-print-output-to-logging
def log_subprocess_output(pipe, level=logging.DEBUG, label=""):
  for line in pipe.readlines():
    logger.log(level, "[from subprocess %s] %s", label, line)


# based on https://github.com/codalab/codabench/blob/develop/compute_worker/compute_worker.py:_run_container_engine_cmd
# no live WebSocket communication
async def run_async_and_catch_output(future, exec_args):
  logger.info(f"/ Start run async %s", exec_args)
  # TODO pipe to logger as well
  proc = await  asyncio.create_subprocess_exec(
    *exec_args,
    stdout=asyncio.subprocess.PIPE,
    stderr=asyncio.subprocess.PIPE
  )
  stdout, stderr = await proc.communicate()
  # simulate interface as in k8s
  _ret = {}
  _ret["job_status"] = "Complete" if proc.returncode == 0 else proc.returncode
  _ret["image_id"] = ""
  _ret["log"] = stdout + stderr
  _ret["job"] = ""
  _ret["pod"] = ""
  future.set_result(_ret)
  logger.info(f"task rc=%s (for %s)", proc.returncode, exec_args)
  logger.debug(f"task stdout=%s", stdout)
  logger.debug(f"task stderr=%s", stderr)
  logger.info(f"\\ End run async %s", exec_args)
  if proc.returncode != 0:
    raise Exception(f"Failed execution {exec_args}")


# https://superfastpython.com/asyncio-gather-cancel-all-if-one-fails/
async def run_all_fail_fast(*group):
  gathered_tasks = asyncio.gather(*group)
  try:
    # wait for the group of tasks to complete
    await gathered_tasks
  except Exception as e:
    # report failure
    logger.error(f'A task failed with: {e}, canceling all tasks')
    # cancel all tasks
    cancel_all_tasks()
    # wait a while
    await asyncio.sleep(2)
    raise e


# cancel all tasks except the current task
def cancel_all_tasks():
  # get all running tasks
  tasks = asyncio.all_tasks()
  # get the current task
  current = asyncio.current_task()
  # remove current task from all tasks
  tasks.remove(current)
  # cancel all remaining running tasks
  for task in tasks:
    task.cancel()
