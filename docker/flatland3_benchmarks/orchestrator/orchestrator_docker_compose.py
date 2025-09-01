# based on https://github.com/codalab/codabench/blob/develop/orchestrator/orchestrator.py
import asyncio
import logging
import os
import ssl
import subprocess
from io import BytesIO, TextIOWrapper
from typing import List, Optional

from celery import Celery
from celery.app.log import TaskFormatter
from celery.signals import after_setup_task_logger
from celery.utils.log import get_task_logger
from yaml import safe_load

from orchestrator_common import FlatlandBenchmarksOrchestrator

logger = get_task_logger(__name__)

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

DOCKERCOMPOSE_HOST_DIRECTORY = os.environ.get("DOCKERCOMPOSE_HOST_DIRECTORY", "/tmp/codabench/")

BENCHMARKING_NETWORK = os.environ.get("BENCHMARKING_NETWORK", None)
SUPPORTED_CLIENT_VERSION_RANGE = os.environ.get("SUPPORTED_CLIENT_VERSION_RANGE", ">=4.2.0")

FAB_API_URL = os.environ.get("FAB_API_URL")
CLIENT_ID = os.environ.get("CLIENT_ID")
CLIENT_SECRET = os.environ.get("CLIENT_SECRET")
TOKEN_URL = os.environ.get("TOKEN_URL")
BENCHMARK_ID = os.environ.get("BENCHMARK_ID")


# https://celery.school/custom-celery-task-logger
@after_setup_task_logger.connect
def setup_task_logger(logger, *args, **kwargs):
  for handler in logger.handlers:
    tf = TaskFormatter("[%(asctime)s][%(levelname)s][%(process)d][%(pathname)s:%(funcName)s:%(lineno)d] [%(task_name)s] - [%(task_id)s] - %(message)s")
    handler.setFormatter(tf)


TEST_IDS = safe_load(os.environ.get("TEST_IDS", "{}"))
REVERSE_TEST_IDS = {v: k for k, v in TEST_IDS.items()}


class DockerComposeFlatlandBenchmarksOrchestrator(FlatlandBenchmarksOrchestrator):

  def run_flatland(self, test_runner_evaluator_image, submission_id, submission_data_url, tests, aws_endpoint_url, aws_access_key_id, aws_secret_access_key,
                   s3_bucket, s3_upload_path_template, s3_upload_path_template_use_submission_id, **kwargs):
    if test_runner_evaluator_image is None:
      os.environ.get("TEST_RUNNER_EVALUATOR_IMAGE", None)
    docker_image = test_runner_evaluator_image
    logger.info(f"/ start task with submission_id={submission_id} with docker_image={docker_image} and submission_data_url={submission_data_url}")
    assert BENCHMARKING_NETWORK is not None
    assert docker_image is not None
    loop = asyncio.get_event_loop()
    evaluator_future = loop.create_future()
    submission_future = loop.create_future()
    evaluator_exec_args = [
      "sudo", "docker", "run",
      "--name", f"flatland3-evaluator-{submission_id}",
      "-e", "redis_ip=redis",
      "-e", f"AICROWD_SUBMISSION_ID={submission_id}",
    ]
    if aws_endpoint_url:
      evaluator_exec_args.extend(["-e", f"AWS_ENDPOINT_URL={aws_endpoint_url}"])
    if aws_access_key_id:
      evaluator_exec_args.extend(["-e", f"AWS_ACCESS_KEY_ID={aws_access_key_id}"])
    if aws_secret_access_key:
      evaluator_exec_args.extend(["-e", f"AWS_SECRET_ACCESS_KEY={aws_secret_access_key}"])
    if s3_bucket:
      evaluator_exec_args.extend(["-e", f"S3_BUCKET={s3_bucket}"])
    if s3_upload_path_template:
      evaluator_exec_args.extend(["-e", f"S3_UPLOAD_PATH_TEMPLATE={s3_upload_path_template}"])
    if s3_upload_path_template_use_submission_id:
      evaluator_exec_args.extend(["-e", f"S3_UPLOAD_PATH_TEMPLATE_USE_SUBMISSION_ID={s3_upload_path_template_use_submission_id}"])
    if SUPPORTED_CLIENT_VERSION_RANGE is not None:
      evaluator_exec_args.extend(["-e", f"SUPPORTED_CLIENT_VERSIONS={SUPPORTED_CLIENT_VERSION_RANGE}"])
    if tests is not None:
      test_names = [REVERSE_TEST_IDS[test_id] for test_id in tests]
      evaluator_exec_args.extend(["-e", f"TEST_ID_FILTER={','.join(test_names)}"])
    evaluator_exec_args.extend(["-e", f"AICROWD_IS_GRADING={True}"])
    evaluator_exec_args.extend([
      "-v", f"{DOCKERCOMPOSE_HOST_DIRECTORY}/evaluation/flatland3_benchmarks/evaluator/debug-environments/:/tmp/environments",
      "-e", "AICROWD_TESTS_FOLDER=/tmp/environments/",
      "--network", BENCHMARKING_NETWORK,
      docker_image,
    ])
    exec_with_logging(["sudo", "docker", "pull", docker_image])
    exec_with_logging(["sudo", "docker", "pull", submission_data_url])
    gathered_tasks = asyncio.gather(
      run_async_and_catch_output(evaluator_future, exec_args=evaluator_exec_args),
      run_async_and_catch_output(submission_future, exec_args=[
        "sudo", "docker", "run",
        "--name", f"flatland3-submission-{submission_id}",
        "-e", "redis_ip=redis",
        "-e", "AICROWD_TESTS_FOLDER=/tmp/environments/",
        "-e", f"AICROWD_SUBMISSION_ID={submission_id}",
        "-v", f"{DOCKERCOMPOSE_HOST_DIRECTORY}/evaluation/flatland3_benchmarks/evaluator/debug-environments/:/tmp/environments/",
        "--network", BENCHMARKING_NETWORK,
        submission_data_url,
      ])
    )
    loop.run_until_complete(gathered_tasks)
    ret_evaluator = evaluator_future.result()
    ret_evaluator["image_id"] = docker_image
    ret_submission = submission_future.result()
    ret_submission["image_id"] = submission_data_url
    ret = {"f3-evaluator": ret_evaluator, "f3-submission": ret_submission}
    logger.debug("Task with submission_id=%s got results from docker run: %s.", submission_id, ret)
    if ret_evaluator["job_status"] != "Complete" or ret_submission["job_status"] != "Complete":
      raise Exception(f"Evaluator or submission failed, aborting: {ret}")

    exec_with_logging(["sudo", "docker", "ps"])
    try:
      logger.info("/ Logs from container %s", f"flatland3-evaluator-{submission_id}")
      exec_with_logging(["sudo", "docker", "logs", f"flatland3-evaluator-{submission_id}", ])
      logger.info("\\ Logs from container %s", f"flatland3-evaluator-{submission_id}")
    except:
      logger.warning("Could not fetch logs from container %s", f"flatland3-evaluator-{submission_id}")
    try:
      logger.info("/ Logs from container %s", f"flatland3-submission-{submission_id}")
      exec_with_logging(["sudo", "docker", "logs", f"flatland3-submission-{submission_id}", ])
      logger.info("\\ Logs from container %s", f"flatland3-submission-{submission_id}")
    except:
      logger.warning("Could not fetch logs from container %s", f"flatland3-submission-{submission_id}")

    # logger.info(f"Get logs from containers...")
    # exec_with_logging(["sudo", "docker", "ps"])
    # try:
    #   logger.info("/ Logs from container %s", f"flatland3-evaluator-{submission_id}")
    #   stdo, stde = exec_with_logging(["sudo", "docker", "logs", f"flatland3-evaluator-{submission_id}", ], collect=True)
    #   stdo = "\n".join(stdo)
    #   file_name = S3_UPLOAD_PATH_TEMPLATE.format(submission_id) + "_evaluator_stdout.log"
    #   response = s3.put_object(Bucket=S3_BUCKET, Key=file_name, Body=stdo)
    #   logger.info("upload %s got response %s", file_name, response)
    #   stde = "\n".join(stde)
    #   file_name = S3_UPLOAD_PATH_TEMPLATE.format(submission_id) + "_evaluator_stderr.log"
    #   response = s3.put_object(Bucket=S3_BUCKET, Key=file_name, Body=stde)
    #   logger.info("upload %s got response %s", file_name, response)
    #   exec_with_logging(["sudo", "docker", "rm", f"flatland3-evaluator-{submission_id}", ])
    #   logger.info("\\ Logs from container %s", f"flatland3-evaluator-{submission_id}")
    # except Exception as e:
    #   logger.warning("Could not fetch logs from container %s", f"flatland3-evaluator-{submission_id}", exc_info=e)
    # try:
    #   logger.info("/ Logs from container %s", f"flatland3-submission-{submission_id}")
    #   stdo, stde = exec_with_logging(["sudo", "docker", "logs", f"flatland3-submission-{submission_id}", ], collect=True)
    #   stdo = "\n".join(stdo)
    #   file_name = S3_UPLOAD_PATH_TEMPLATE.format(submission_id) + "_submission_stdout.log"
    #   response = s3.put_object(Bucket=S3_BUCKET, Key=file_name, Body=stdo)
    #   logger.info("upload %s got response %s", file_name, response)
    #   stde = "\n".join(stde)
    #   file_name = S3_UPLOAD_PATH_TEMPLATE.format(submission_id) + "_submission_stderr.log"
    #   response = s3.put_object(Bucket=S3_BUCKET, Key=file_name, Body=stde)
    #   logger.info("upload %s got response %s", file_name, response)
    #   exec_with_logging(["sudo", "docker", "rm", f"flatland3-submission-{submission_id}", ])
    #   logger.info("\\ Logs from container %s", f"flatland3-submission-{submission_id}")
    # except Exception as e:
    #   logger.warning("Could not fetch logs from container %s", f"flatland3-submission-{submission_id}", exc_info=e)
    return ret


# N.B. name to be used by send_task
@app.task(name=os.environ.get("BENCHMARK_ID"), bind=True, soft_time_limit=10 * 60, time_limit=12 * 60)
def orchestrator(self,
                 submission_data_url: str,
                 tests: List[str] = None,
                 TEST_RUNNER_EVALUATOR_IMAGE="ghcr.io/flatland-association/fab-flatland-evaluator:latest",
                 AWS_ENDPOINT_URL=None,
                 AWS_ACCESS_KEY_ID=None,
                 AWS_SECRET_ACCESS_KEY=None,
                 S3_BUCKET=None,
                 S3_UPLOAD_PATH_TEMPLATE=None,
                 S3_UPLOAD_PATH_TEMPLATE_USE_SUBMISSION_ID=None,
                 **kwargs):
  submission_id = self.request.id
  return DockerComposeFlatlandBenchmarksOrchestrator(submission_id).orchestrator(
    submission_data_url=submission_data_url,
    tests=tests,
    test_runner_evaluator_image=TEST_RUNNER_EVALUATOR_IMAGE,
    aws_endpoint_url=AWS_ENDPOINT_URL,
    aws_access_key_id=AWS_ACCESS_KEY_ID,
    aws_secret_access_key=AWS_SECRET_ACCESS_KEY,
    s3_bucket=S3_BUCKET,
    s3_upload_path_template=S3_UPLOAD_PATH_TEMPLATE,
    s3_upload_path_template_use_submission_id=S3_UPLOAD_PATH_TEMPLATE_USE_SUBMISSION_ID,
    **kwargs
  )


# https://stackoverflow.com/questions/21953835/run-subprocess-and-print-output-to-logging
def exec_with_logging(exec_args: List[str], log_level_stdout=logging.DEBUG, log_level_stderr=logging.WARN, collect: bool = False):
  logger.debug(f"/ Start %s", exec_args)
  try:
    proc = subprocess.Popen(exec_args, stdout=subprocess.PIPE, stderr=subprocess.STDOUT)
    stdout, stderr = proc.communicate()
    stdo = log_subprocess_output(TextIOWrapper(BytesIO(stdout)), level=log_level_stdout, label=str(exec_args), collect=collect)
    stde = log_subprocess_output(TextIOWrapper(BytesIO(stderr)), level=log_level_stderr, label=str(exec_args), collect=collect)
    logger.debug("\\ End %s", exec_args)
    return stdo, stde
  except (OSError, subprocess.CalledProcessError) as exception:
    logger.error(stderr)
    raise RuntimeError(f"Failed to run {exec_args}. Stdout={stdout}. Stderr={stderr}") from exception


# https://stackoverflow.com/questions/21953835/run-subprocess-and-print-output-to-logging
def log_subprocess_output(pipe, level=logging.DEBUG, label="", collect: bool = False) -> Optional[List[str]]:
  s = []
  for line in pipe.readlines():
    logger.log(level, "[from subprocess %s] %s", label, line)
    if collect:
      s.append(line)
  if collect:
    return s
  return None


# based on https://github.com/codalab/codabench/blob/develop/orchestrator/orchestrator.py:_run_container_engine_cmd
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
