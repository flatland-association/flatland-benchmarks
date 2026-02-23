# based on https://github.com/codalab/codabench/blob/develop/orchestrator/orchestrator.py
import asyncio
import logging
import os
import shutil
import ssl
import subprocess
from io import BytesIO, TextIOWrapper
from pathlib import Path
from typing import List, Optional

import boto3
from celery import Celery
from celery.app.log import TaskFormatter
from celery.signals import after_setup_task_logger
from celery.utils.log import get_task_logger

from orchestrator_common import FlatlandBenchmarksOrchestrator
from s3_utils import S3_BUCKET, S3_UPLOAD_ROOT, s3_utils

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

# required only for docker in docker
DATA_VOLUME = os.environ.get("DATA_VOLUME")
SCENARIOS_VOLUME = os.environ.get("SCENARIOS_VOLUME")
SUDO = os.environ.get("SUDO", "true").lower() == "true"

DATA_VOLUME_MOUNTPATH = os.environ.get("DATA_VOLUME_MOUNTPATH", "/app/data")
SCENARIOS_VOLUME_MOUNTPATH = os.environ.get("SCENARIOS_VOLUME_MOUNTPATH", "/app/scenarios")
RAILWAY_ORCHESTRATOR_RUN_LOCAL = os.environ.get("RAILWAY_ORCHESTRATOR_RUN_LOCAL", False)


# https://celery.school/custom-celery-task-logger
@after_setup_task_logger.connect
def setup_task_logger(logger, *args, **kwargs):
  for handler in logger.handlers:
    tf = TaskFormatter("[%(asctime)s][%(levelname)s][%(process)d][%(pathname)s:%(funcName)s:%(lineno)d] [%(task_name)s] - [%(task_id)s] - %(message)s")
    handler.setFormatter(tf)


class DockerComposeFlatlandBenchmarksOrchestrator(FlatlandBenchmarksOrchestrator):
  def exec(self, generate_policy_args: List[str], test_id: str, scenario_id: str, submission_id: str, subdir: str, submission_data_url: str):
    # --data-dir must exist -- TODO fix in flatland-rl instead
    args = ["docker", "run", "--rm", "-v", f"{DATA_VOLUME}:/vol", "alpine:latest", "mkdir", "-p", f"/vol/{subdir}"]
    exec_with_logging(args if not SUDO else ["sudo"] + args)
    args = ["docker", "run", "--rm", "-v", f"{DATA_VOLUME}:/vol", "alpine:latest", "chmod", "-R", "a=rwx",
            f"/vol/{submission_id}/{test_id}/{scenario_id}"]
    exec_with_logging(args if not SUDO else ["sudo"] + args)

    # update image
    args = ["docker", "pull", submission_data_url, ]
    exec_with_logging(args if not SUDO else ["sudo"] + args)
    args = [
             "docker", "run",
             # "--rm",
             "-v", f"{DATA_VOLUME}:{DATA_VOLUME_MOUNTPATH}",
             "-v", f"{SCENARIOS_VOLUME}:{SCENARIOS_VOLUME_MOUNTPATH}",
             # Don't allow subprocesses to raise privileges, see https://github.com/codalab/codabench/blob/43e01d4bc3de26e8339ddb1463eef7d960ddb3af/compute_worker/compute_worker.py#L520
             "--security-opt=no-new-privileges",
             # Don't buffer python output, so we don't lose any
             "-e", "PYTHONUNBUFFERED=1",
             # for integration tests with localhost http
             "-e", "OAUTHLIB_INSECURE_TRANSPORT=1",
             submission_data_url,
             "flatland-trajectory-generate-from-policy",
           ] + generate_policy_args
    exec_with_logging(args if not SUDO else ["sudo"] + args, log_level_stdout=logging.DEBUG)

    args = ["docker", "run", "--rm", "-v", f"{DATA_VOLUME}:/vol", "alpine:latest", "chmod", "-R", "a=rwx",
            f"/vol/{submission_id}/{test_id}/{scenario_id}"]
    exec_with_logging(args if not SUDO else ["sudo"] + args)

  # docker implementation has volume mapped into submission container - data is uploaded to S3 by orchestrator
  def run_flatland(self, submission_id, submission_data_url, tests, aws_endpoint_url, aws_access_key_id, aws_secret_access_key, s3_bucket, s3, **kwargs):
    try:
      if tests is None:
        tests = list(self.TEST_TO_SCENARIO_IDS.keys())

      results = {test_id: {} for test_id in tests}
      for test_id in tests:
        for scenario_id in self.TEST_TO_SCENARIO_IDS[test_id]:
          logger.info(f"// START running submission submission_id={submission_id},test_id={test_id}, scenario_id={scenario_id}")
          env_path = self.load_scenario_data(scenario_id)

          data_dir = f"{DATA_VOLUME_MOUNTPATH}/{submission_id}/{test_id}/{scenario_id}"
          generate_policy_args = [
            "--data-dir", data_dir,
            "--ep-id", scenario_id,
            "--env-path", f"{SCENARIOS_VOLUME_MOUNTPATH}/{env_path}",
            "--snapshot-interval", "10",
            # TODO old debug-environments have np_random not persisted, so pass seed to have envs behave deterministically. Should do this everywhere or assume envs are reset?
            "--seed", "1001"
          ]
          self.exec(generate_policy_args, test_id, scenario_id, submission_id, f"{submission_id}/{test_id}/{scenario_id}", submission_data_url)

          logger.info(f"\\\\ END running submission submission_id={submission_id},test_id={test_id}, scenario_id={scenario_id}")

          logger.info(f"// START evaluating submission submission_id={submission_id},test_id={test_id}, scenario_id={scenario_id}")

          normalized_reward, success_rate = self._extract_stats_from_trajectory(Path(data_dir), scenario_id)

          self.upload_and_empty_local(test_id, submission_id, scenario_id, aws_endpoint_url, aws_access_key_id, aws_secret_access_key, s3_bucket, s3)

          results[test_id][scenario_id] = {
            "normalized_reward": normalized_reward,
            "percentage_complete": success_rate
          }
          logger.info(
            f"\\\\ END evaluating submission submission_id={submission_id},test_id={test_id}, scenario_id={scenario_id}: {results[test_id][scenario_id]}")
      return results
    except BaseException as exception:
      logger.error(f"Failed task with submission_id={submission_id} with submission_data_url={submission_data_url}: {str(exception)}")
      raise RuntimeError(f"Failed task with submission_id={submission_id} with submission_data_url={submission_data_url}: {str(exception)}") from exception

  def upload_and_empty_local(self, test_id: str, submission_id: str, scenario_id: str, aws_endpoint_url: str, aws_access_key_id: str,
                             aws_secret_access_key: str, s3_bucket: str,
                             s3: boto3.session.Session.client):
    data_volume = Path(DATA_VOLUME_MOUNTPATH)
    scenario_folder = data_volume / submission_id / test_id / scenario_id
    logger.info(f"Uploading {scenario_folder} to s3 {S3_BUCKET}/{S3_UPLOAD_ROOT}{scenario_folder.relative_to(data_volume)}")
    for f in scenario_folder.rglob("**/*"):
      if f.is_dir():
        continue
      relative_upload_key = str(f.relative_to(data_volume))
      if s3 is None:
        s3 = s3_utils.get_boto_client(aws_access_key_id, aws_secret_access_key, aws_endpoint_url)
      s3_utils.upload_to_s3(f, relative_upload_key, s3_bucket=s3_bucket, s3=s3)
    logger.info(f"Deleting {scenario_folder} after uploading s3 {S3_BUCKET}/{S3_UPLOAD_ROOT}/{scenario_folder.relative_to(data_volume)}")
    # a bit hacky: in test_containers_railway, /app/data is mounted as root.
    for d in scenario_folder.iterdir():
      shutil.rmtree(d)

  @staticmethod
  def load_scenario_data(scenario_id: str) -> str:
    return {
      # debug environments:
      'd99f4d35-aec5-41c1-a7b0-64f78b35d7ef': "Test_0/Level_0.pkl",
      '04d618b8-84df-406b-b803-d516c7425537': "Test_0/Level_1.pkl",
      '6f3ad83c-3312-4ab3-9740-cbce80feea91': "Test_1/Level_0.pkl",
      'f954a860-e963-431e-a09d-5b1040948f2d': "Test_1/Level_1.pkl",
      'f92bfe0c-5347-4d89-bc17-b6f86d514ef8': "Test_1/Level_2.pkl",

      # railway competition:
      "046c6f42-a713-4b3d-94df-99c23753a682": "scene_1/scene_1_initial.pkl",
      "d2ca9404-f38c-4f01-873a-4e33baf09620": "scene_2/scene_2_initial.pkl",
      "31fb82ac-fae2-4a78-9148-5a9fe93716c7": "scene_3/scene_3_initial.pkl",
      "666f08ab-8a2d-41fc-adbe-9644796e439f": "scene_4/scene_4_initial.pkl",
      "66755e67-1cc8-4898-ad44-704c3e49eec6": "scene_5/scene_5_initial.pkl",
    }[scenario_id]

  TEST_TO_SCENARIO_IDS = {
    # debug environments:
    '4ecdb9f4-e2ff-41ff-9857-abe649c19c50': [
      'd99f4d35-aec5-41c1-a7b0-64f78b35d7ef',
      '04d618b8-84df-406b-b803-d516c7425537',
    ],
    '5206f2ee-d0a9-405b-8da3-93625e169811': [
      '6f3ad83c-3312-4ab3-9740-cbce80feea91',
      'f954a860-e963-431e-a09d-5b1040948f2d',
      'f92bfe0c-5347-4d89-bc17-b6f86d514ef8',
    ],

    # railway competition:
    "2a085b24-4cde-428a-977f-4771a25bfc3c": [
      "046c6f42-a713-4b3d-94df-99c23753a682"
    ],
    "b3cde510-701e-440c-931d-8c1c032f8d9d": [
      "d2ca9404-f38c-4f01-873a-4e33baf09620"
    ],
    "c2e24c50-a4e2-48c3-8cb8-fe46ff245802": [
      "31fb82ac-fae2-4a78-9148-5a9fe93716c7"
    ],
    "44ea4b29-37d2-4c04-98a2-8f758173c2ab": [
      "666f08ab-8a2d-41fc-adbe-9644796e439f"
    ],
    "fbe1bb82-848c-4e65-9c9d-88e1e351265d": [
      "66755e67-1cc8-4898-ad44-704c3e49eec6"
    ]
  }


# N.B. name to be used by send_task
@app.task(name=os.environ.get("BENCHMARK_ID"), bind=True, soft_time_limit=10 * 60, time_limit=12 * 60)
def orchestrator(self,
                 submission_data_url: str,
                 tests: List[str] = None,
                 aws_endpoint_url=None,
                 aws_access_key_id=None,
                 aws_secret_access_key=None,
                 s3_bucket=None,
                 **kwargs):
  submission_id = self.request.id
  return DockerComposeFlatlandBenchmarksOrchestrator(submission_id).orchestrator(
    submission_data_url=submission_data_url,
    tests=tests,
    aws_endpoint_url=aws_endpoint_url,
    aws_access_key_id=aws_access_key_id,
    aws_secret_access_key=aws_secret_access_key,
    s3_bucket=s3_bucket,
    **kwargs
  )


# https://stackoverflow.com/questions/21953835/run-subprocess-and-print-output-to-logging
def exec_with_logging(exec_args: List[str], log_level_stdout=logging.INFO, log_level_stderr=logging.INFO, collect: bool = False):
  logger.info(f"/ Start %s", exec_args)
  try:
    proc = subprocess.Popen(exec_args, stdout=subprocess.PIPE, stderr=subprocess.STDOUT)
    stdout, stderr = proc.communicate()
    stdo = log_subprocess_output(TextIOWrapper(BytesIO(stdout)), level=log_level_stdout, label=str(exec_args), collect=collect)
    stde = log_subprocess_output(TextIOWrapper(BytesIO(stderr)), level=log_level_stderr, label=str(exec_args), collect=collect)
    logger.info("\\ End %s", exec_args)
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
