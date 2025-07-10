# based on https://github.com/codalab/codabench/blob/develop/orchestrator/orchestrator.py
import asyncio
import json
import logging
import os
import ssl
import subprocess
import time
from io import BytesIO, TextIOWrapper, StringIO
from typing import List, Optional

import boto3
import celery.exceptions
import pandas as pd
from celery import Celery
from celery.app.log import TaskFormatter
from celery.signals import after_setup_task_logger
from celery.utils.log import get_task_logger

from fab_clientlib import ApiClient, DefaultApi, Configuration, ResultsSubmissionsSubmissionIdTestsTestIdsPostRequest, \
  ResultsSubmissionsSubmissionIdTestsTestIdsPostRequestDataInner
from fab_oauth_utils import backend_application_flow

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
SUPPORTED_CLIENT_VERSIONS = os.environ.get("SUPPORTED_CLIENT_VERSIONS", "4.0.3,4.0.4,4.1.0")

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


# TODO extract test runnner and share between docker compose and k8s implementation?
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

  try:
    start_time = time.time()

    if AWS_ENDPOINT_URL is None:
      AWS_ENDPOINT_URL = os.environ.get("AWS_ENDPOINT_URL", None)
    if AWS_ACCESS_KEY_ID is None:
      AWS_ACCESS_KEY_ID = os.environ.get("AWS_ACCESS_KEY_ID", None)
    if AWS_SECRET_ACCESS_KEY is None:
      AWS_SECRET_ACCESS_KEY = os.environ.get("AWS_SECRET_ACCESS_KEY", None)
    if S3_BUCKET is None:
      S3_BUCKET = os.environ.get("S3_BUCKET", None)
    if S3_UPLOAD_PATH_TEMPLATE is None:
      S3_UPLOAD_PATH_TEMPLATE = os.environ.get("S3_UPLOAD_PATH_TEMPLATE", None)
    if S3_UPLOAD_PATH_TEMPLATE_USE_SUBMISSION_ID is None:
      S3_UPLOAD_PATH_TEMPLATE_USE_SUBMISSION_ID = os.environ.get("S3_UPLOAD_PATH_TEMPLATE_USE_SUBMISSION_ID", None)
    if TEST_RUNNER_EVALUATOR_IMAGE is None:
      os.environ.get("TEST_RUNNER_EVALUATOR_IMAGE", None)

    docker_image = TEST_RUNNER_EVALUATOR_IMAGE
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
    duration = time.time() - start_time
    logger.info(
      f"\\ end task with submission_id={submission_id} with docker_image={docker_image} and submission_data_url={submission_data_url}. Took {duration:.2f} seconds.")

    ret_evaluator = evaluator_future.result()
    ret_evaluator["image_id"] = docker_image
    ret_submission = submission_future.result()
    ret_submission["image_id"] = submission_data_url
    ret = {"f3-evaluator": ret_evaluator, "f3-submission": ret_submission}
    logger.debug("Task with submission_id=%s got results from docker run: %s.", submission_id, ret)

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
    obj = s3.get_object(Bucket=S3_BUCKET, Key=S3_UPLOAD_PATH_TEMPLATE.format(submission_id) + ".csv")
    ret_evaluator["results.csv"] = obj['Body'].read().decode("utf-8")
    obj = s3.get_object(Bucket=S3_BUCKET, Key=S3_UPLOAD_PATH_TEMPLATE.format(submission_id) + ".json")
    ret_evaluator["results.json"] = obj['Body'].read().decode("utf-8")

    logger.info(f"Get logs from containers...")
    exec_with_logging(["sudo", "docker", "ps"])
    try:
      logger.info("/ Logs from container %s", f"flatland3-evaluator-{submission_id}")
      stdo, stde = exec_with_logging(["sudo", "docker", "logs", f"flatland3-evaluator-{submission_id}", ], collect=True)
      stdo = "\n".join(stdo)
      file_name = S3_UPLOAD_PATH_TEMPLATE.format(submission_id) + "_evaluator_stdout.log"
      response = s3.put_object(Bucket=S3_BUCKET, Key=file_name, Body=stdo)
      logger.info("upload %s got response %s", file_name, response)
      stde = "\n".join(stde)
      file_name = S3_UPLOAD_PATH_TEMPLATE.format(submission_id) + "_evaluator_stderr.log"
      response = s3.put_object(Bucket=S3_BUCKET, Key=file_name, Body=stde)
      logger.info("upload %s got response %s", file_name, response)
      exec_with_logging(["sudo", "docker", "rm", f"flatland3-evaluator-{submission_id}", ])
      logger.info("\\ Logs from container %s", f"flatland3-evaluator-{submission_id}")
    except Exception as e:
      logger.warning("Could not fetch logs from container %s", f"flatland3-evaluator-{submission_id}", exc_info=e)
    try:
      logger.info("/ Logs from container %s", f"flatland3-submission-{submission_id}")
      stdo, stde = exec_with_logging(["sudo", "docker", "logs", f"flatland3-submission-{submission_id}", ], collect=True)
      stdo = "\n".join(stdo)
      file_name = S3_UPLOAD_PATH_TEMPLATE.format(submission_id) + "_submission_stdout.log"
      response = s3.put_object(Bucket=S3_BUCKET, Key=file_name, Body=stdo)
      logger.info("upload %s got response %s", file_name, response)
      stde = "\n".join(stde)
      file_name = S3_UPLOAD_PATH_TEMPLATE.format(submission_id) + "_submission_stderr.log"
      response = s3.put_object(Bucket=S3_BUCKET, Key=file_name, Body=stde)
      logger.info("upload %s got response %s", file_name, response)
      exec_with_logging(["sudo", "docker", "rm", f"flatland3-submission-{submission_id}", ])
      logger.info("\\ Logs from container %s", f"flatland3-submission-{submission_id}")
    except Exception as e:
      logger.warning("Could not fetch logs from container %s", f"flatland3-submission-{submission_id}", exc_info=e)

    token = backend_application_flow(CLIENT_ID, CLIENT_SECRET, TOKEN_URL)
    print("token")
    print(token)

    # TODO mount metadata.csv into orchestrator or extend evaluator with this part
    # TODO upload data
    # TODO generalize to rolled out benchmarks
    # df_metadata = pd.read_csv(f"{DOCKERCOMPOSE_HOST_DIRECTORY}/evaluation/flatland3_benchmarks/evaluator/debug-environments/metadata.csv")
    df_metadata = pd.read_csv(StringIO("""test_id,env_id,n_agents,x_dim,y_dim,n_cities,max_rail_pairs_in_city,n_envs_run,seed,grid_mode,max_rails_between_cities,malfunction_duration_min,malfunction_duration_max,malfunction_interval,speed_ratios,fab_benchmark_id,fab_test_id,fab_scenario_id
Test_0,Level_0,5,25,25,2,2,2,1,False,2,20,50,0,{1.0: 1.0},f669fb8d-80ac-4ba7-8875-0a33ed5d30b9,4ecdb9f4-e2ff-41ff-9857-abe649c19c50,d99f4d35-aec5-41c1-a7b0-64f78b35d7ef
Test_0,Level_1,5,25,25,2,2,2,2,False,2,20,50,250,{1.0: 1.0},f669fb8d-80ac-4ba7-8875-0a33ed5d30b9,4ecdb9f4-e2ff-41ff-9857-abe649c19c50,04d618b8-84df-406b-b803-d516c7425537
Test_1,Level_0,2,30,30,3,2,3,1,False,2,20,50,0,{1.0: 1.0},f669fb8d-80ac-4ba7-8875-0a33ed5d30b9,5206f2ee-d0a9-405b-8da3-93625e169811,6f3ad83c-3312-4ab3-9740-cbce80feea91
Test_1,Level_1,2,30,30,3,2,3,2,False,2,20,50,300,{1.0: 1.0},f669fb8d-80ac-4ba7-8875-0a33ed5d30b9,5206f2ee-d0a9-405b-8da3-93625e169811,f954a860-e963-431e-a09d-5b1040948f2d
Test_1,Level_2,2,30,30,3,2,3,4,False,2,20,50,600,{1.0: 1.0},f669fb8d-80ac-4ba7-8875-0a33ed5d30b9,5206f2ee-d0a9-405b-8da3-93625e169811,f92bfe0c-5347-4d89-bc17-b6f86d514ef8"""))
    print("metadata.csv")
    print(df_metadata)

    print("results.csv")
    df_results = pd.read_csv(StringIO(ret_evaluator["results.csv"]))
    print(df_results)
    print("results.json")
    json_results = json.loads(ret_evaluator["results.json"])
    print(json_results)

    fab = DefaultApi(ApiClient(configuration=Configuration(host=FAB_API_URL, access_token=token["access_token"])))

    # TODO upload only requested tests
    for _, row in df_metadata.iterrows():
      # could also be sent at once, but this way we get continuous updates
      fab.results_submissions_submission_id_tests_test_ids_post(
        submission_id=submission_id,
        test_ids=[row["fab_test_id"]],
        results_submissions_submission_id_tests_test_ids_post_request=ResultsSubmissionsSubmissionIdTestsTestIdsPostRequest(
          data=[
            ResultsSubmissionsSubmissionIdTestsTestIdsPostRequestDataInner(
              scenario_id=row["fab_scenario_id"],
              # TODO hard-coded
              # TODO use better names than primary and secondary -> e.g. rewards and success_rate
              additional_properties={"primary": "55"},
            )
          ]
        ),
      )
    return ret

  except celery.exceptions.SoftTimeLimitExceeded as e:
    logger.info("Hit %s - getting logs from containers", e)
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
    raise e


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
