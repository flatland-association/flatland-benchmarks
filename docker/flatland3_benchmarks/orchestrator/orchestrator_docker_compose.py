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

from celery import Celery
from celery.app.log import TaskFormatter
from celery.signals import after_setup_task_logger
from celery.utils.log import get_task_logger

from orchestrator_common import FlatlandBenchmarksOrchestrator, TEST_TO_SCENARIO_IDS
from s3_utils import S3_BUCKET, AI4REALNET_S3_UPLOAD_ROOT, s3_utils

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
             "--entrypoint", "/bin/bash",
             # Don't allow subprocesses to raise privileges, see https://github.com/codalab/codabench/blob/43e01d4bc3de26e8339ddb1463eef7d960ddb3af/compute_worker/compute_worker.py#L520
             "--security-opt=no-new-privileges",
             # Don't buffer python output, so we don't lose any
             "-e", "PYTHONUNBUFFERED=1",
             # for integration tests with localhost http
             "-e", "OAUTHLIB_INSECURE_TRANSPORT=1",
             submission_data_url,
             # TODO get rid of hard-coded path in flatland-baselines
             "/home/conda/entrypoint_generic.sh", "flatland-trajectory-generate-from-policy",
           ] + generate_policy_args
    exec_with_logging(args if not SUDO else ["sudo"] + args, log_level_stdout=logging.DEBUG)

    args = ["docker", "run", "--rm", "-v", f"{DATA_VOLUME}:/vol", "alpine:latest", "chmod", "-R", "a=rwx",
            f"/vol/{submission_id}/{test_id}/{scenario_id}"]
    exec_with_logging(args if not SUDO else ["sudo"] + args)

  def run_flatland(self, submission_id, submission_data_url, tests, aws_endpoint_url, aws_access_key_id, aws_secret_access_key, s3_bucket, **kwargs):
    try:
      if tests is None:
        tests = list(TEST_TO_SCENARIO_IDS.keys())

      results = {test_id: {} for test_id in tests}
      for test_id in tests:
        for scenario_id in TEST_TO_SCENARIO_IDS[test_id]:
          logger.info(f"// START running submission submission_id={submission_id},test_id={test_id}, scenario_id={scenario_id}")
          env_path = self.load_scenario_data(scenario_id)

          data_dir = f"{DATA_VOLUME_MOUNTPATH}/{submission_id}/{test_id}/{scenario_id}"
          generate_policy_args = [
            "--data-dir", data_dir,
            "--policy-pkg", "flatland_baselines.deadlock_avoidance_heuristic.policy.deadlock_avoidance_policy", "--policy-cls", "DeadLockAvoidancePolicy",
            "--obs-builder-pkg", "flatland_baselines.deadlock_avoidance_heuristic.observation.full_env_observation", "--obs-builder-cls", "FullEnvObservation",
            "--ep-id", scenario_id,
            "--env-path", f"{SCENARIOS_VOLUME_MOUNTPATH}/{env_path}",
            "--snapshot-interval", "10",
            "--seed", "1001"
          ]
          self.exec(generate_policy_args, test_id, scenario_id, submission_id, f"{submission_id}/{test_id}/{scenario_id}", submission_data_url)

          logger.info(f"\\\\ END running submission submission_id={submission_id},test_id={test_id}, scenario_id={scenario_id}")

          # TODO how to inject model into call?
          logger.info(f"// START evaluating submission submission_id={submission_id},test_id={test_id}, scenario_id={scenario_id}")

          normalized_reward, success_rate = self._extract_stats_from_trajectory(data_dir, scenario_id)

          self.upload_and_empty_local(test_id, submission_id, scenario_id)

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

  def upload_and_empty_local(self, test_id: str, submission_id: str, scenario_id: str):
    data_volume = Path(DATA_VOLUME_MOUNTPATH)
    scenario_folder = data_volume / submission_id / test_id / scenario_id
    logger.info(f"Uploading {scenario_folder} to s3 {S3_BUCKET}/{AI4REALNET_S3_UPLOAD_ROOT}{scenario_folder.relative_to(data_volume)}")
    for f in scenario_folder.rglob("**/*"):
      if f.is_dir():
        continue
      relative_upload_key = str(f.relative_to(data_volume))
      s3_utils.upload_to_s3(f, relative_upload_key)
    logger.info(f"Deleting {scenario_folder} after uploading s3 {S3_BUCKET}/{AI4REALNET_S3_UPLOAD_ROOT}/{scenario_folder.relative_to(data_volume)}")
    # a bit hacky: in test_containers_railway, /app/data is mounted as root.
    for d in scenario_folder.iterdir():
      shutil.rmtree(d)

  # debug environments
  @staticmethod
  def load_scenario_data(scenario_id: str) -> str:
    return {
      # test 4ecdb9f4-e2ff-41ff-9857-abe649c19c50_
      'd99f4d35-aec5-41c1-a7b0-64f78b35d7ef': "Test_0/Level_0.pkl",
      '04d618b8-84df-406b-b803-d516c7425537': "Test_0/Level_1.pkl",

      # test 5206f2ee-d0a9-405b-8da3-93625e169811:
      '6f3ad83c-3312-4ab3-9740-cbce80feea91': "Test_1/Level_0.pkl",
      'f954a860-e963-431e-a09d-5b1040948f2d': "Test_1/Level_1.pkl",
      'f92bfe0c-5347-4d89-bc17-b6f86d514ef8': "Test_1/Level_2.pkl",
    }[scenario_id]


# N.B. name to be used by send_task
@app.task(name=os.environ.get("BENCHMARK_ID"), bind=True, soft_time_limit=10 * 60, time_limit=12 * 60)
def orchestrator(self,
                 submission_data_url: str,
                 tests: List[str] = None,
                 AWS_ENDPOINT_URL=None,
                 AWS_ACCESS_KEY_ID=None,
                 AWS_SECRET_ACCESS_KEY=None,
                 S3_BUCKET=None,
                 **kwargs):
  submission_id = self.request.id
  return DockerComposeFlatlandBenchmarksOrchestrator(submission_id).orchestrator(submission_data_url=submission_data_url, tests=tests,
                                                                                 aws_endpoint_url=AWS_ENDPOINT_URL, aws_access_key_id=AWS_ACCESS_KEY_ID,
                                                                                 aws_secret_access_key=AWS_SECRET_ACCESS_KEY, s3_bucket=S3_BUCKET, **kwargs)


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
