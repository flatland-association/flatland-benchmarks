import json
import logging
import time
import uuid
from io import StringIO
from typing import List

import boto3
import pandas as pd
import pytest
import redis
from celery import Celery
from dotenv import dotenv_values
from testcontainers.compose import DockerCompose

TRACE = 5
logger = logging.getLogger(__name__)

# set to True if docker-compose-demo.yml is already up and running
ATTENDED = False


@pytest.fixture(scope="module")
def test_containers_fixture():
  if ATTENDED:
    yield
    return

  global basic

  start_time = time.time()
  basic = DockerCompose(context=".", compose_file_name="docker-compose-demo.yml")
  logger.info("/ start docker compose down")
  basic.stop()
  duration = time.time() - start_time
  logger.info(f"\\ end docker compose down. Took {duration:.2f} seconds.")
  start_time = time.time()
  logger.info("/ start docker compose up")
  basic.start()
  duration = time.time() - start_time
  logger.info(f"\\ end docker compose up. Took {duration:.2f} seconds.")

  task_id = str(uuid.uuid4())
  yield task_id

  # TODO workaround for testcontainers not supporting streaming to logger
  start_time = time.time()
  logger.info("/ start get docker compose logs")
  stdout, stderr = basic.get_logs()
  logger.info("stdout from docker compose")
  logger.info(stdout)
  logger.warning("stderr from docker compose")
  logger.warning(stderr)
  duration = time.time() - start_time
  logger.info(f"\\ end get docker compose logs. Took {duration:.2f} seconds.")

  start_time = time.time()
  logger.info("/ start docker compose down")
  basic.stop()
  duration = time.time() - start_time
  logger.info(f"\\ end docker down. Took {duration:.2f} seconds.")


def run_task(task_id: str, submission_image: str, tests: List[str]):
  start_time = time.time()
  app = Celery(
    broker="pyamqp://localhost:5672",
    backend='redis://localhost:6379',
  )
  logger.info(f"/ Start simulate submission from portal for task_id={task_id}.....")
  ret = app.send_task(
    'flatland3-evaluation',
    task_id=task_id,
    kwargs={
      "docker_image": "ghcr.io/flatland-association/fab-flatland-evaluator:latest",
      "submission_image": submission_image,
      "tests": tests
    },
  ).get()
  logger.info(ret)
  duration = time.time() - start_time
  logger.info(
    f"\\ End simulate submission from portal for task_id={task_id}. Took {duration} seconds: {[(k, v['job_status'], v['image_id'], v['log']) for k, v in ret.items()]}")
  return ret


@pytest.mark.usefixtures("test_containers_fixture")
@pytest.mark.parametrize(
  "tests,expected_total_simulation_count",
  [(None, 5), (["Test_0", "Test_1"], 5), (["Test_0"], 2), (["Test_1"], 3)],
  ids=["all", "Test_0,Test_1", "Test0", "Test1"]
)
def test_succesful_run(expected_total_simulation_count, tests: List[str]):
  task_id = str(uuid.uuid4())
  ret = run_task(task_id, "ghcr.io/flatland-association/flatland-benchmarks-f3-starterkit:latest", tests=tests)

  for k, v in ret.items():
    logger.log(TRACE, "Got %s", (k, v['job_status'], v['image_id'], v['log']))

  all_completed = all([s["job_status"] == "Complete" for s in ret.values()])
  assert all_completed, ret

  # check Celery direct return value
  assert set(ret.keys()) == {"f3-evaluator", "f3-submission"}

  assert set(ret["f3-evaluator"].keys()) == {"job_status", "image_id", "log", "job", "pod", "results.csv", "results.json"}
  assert set(ret["f3-submission"].keys()) == {"job_status", "image_id", "log", "job", "pod"}

  assert ret["f3-evaluator"]["job_status"] == "Complete"
  assert ret["f3-submission"]["job_status"] == "Complete"

  assert ret["f3-evaluator"]["image_id"] == "ghcr.io/flatland-association/fab-flatland-evaluator:latest"
  assert ret["f3-submission"]["image_id"] == "ghcr.io/flatland-association/flatland-benchmarks-f3-starterkit:latest"

  assert "end evaluator/run.sh" in str(ret["f3-evaluator"]["log"])
  assert "end submission_template/run.sh" in str(ret["f3-submission"]["log"])

  res_df = pd.read_csv(StringIO(ret["f3-evaluator"]["results.csv"]))
  logger.debug(res_df)
  res_json = json.loads(ret["f3-evaluator"]["results.json"])
  logger.debug(res_json)

  # check Celery return value from redis
  r = redis.Redis(host='localhost', port=6379, db=0)
  res = r.get(f"celery-task-meta-{task_id}")
  res = json.loads(res.decode("utf-8"))

  scenarios_run = res_df.loc[res_df['controller_inference_time_max'].notna()]
  tests_with_some_steps = set(scenarios_run["test_id"])
  # Due to non-determinism of agent and early stopping ("The mean percentage of done agents during the last Test (2 environments) was too low: 0.100 < 0.25"), we cannot check the number of scenarios or tests run
  if tests is not None:
    assert len(tests_with_some_steps.difference(tests)) == 0, (tests_with_some_steps, tests)

  assert res["status"] == "SUCCESS"
  assert res["task_id"] == task_id
  ret = res["result"]
  assert set(ret.keys()) == {"f3-evaluator", "f3-submission"}

  assert set(ret["f3-evaluator"].keys()) == {"job_status", "image_id", "log", "job", "pod", "results.csv", "results.json"}
  assert set(ret["f3-submission"].keys()) == {"job_status", "image_id", "log", "job", "pod"}

  assert ret["f3-evaluator"]["job_status"] == "Complete"
  assert ret["f3-submission"]["job_status"] == "Complete"

  assert ret["f3-evaluator"]["image_id"] == "ghcr.io/flatland-association/fab-flatland-evaluator:latest"
  assert ret["f3-submission"]["image_id"] == "ghcr.io/flatland-association/flatland-benchmarks-f3-starterkit:latest"

  assert "end evaluator/run.sh" in str(ret["f3-evaluator"]["log"])
  assert "end submission_template/run.sh" in str(ret["f3-submission"]["log"])

  res_df = pd.read_csv(StringIO(ret["f3-evaluator"]["results.csv"]))
  logger.debug(res_df)
  res_json = json.loads(ret["f3-evaluator"]["results.json"])
  logger.debug(res_json)

  assert res_json["total_simulation_count"] == expected_total_simulation_count
  assert res_json["simulation_count"] == len(scenarios_run)

  logger.info("Download results from S3")
  config = dotenv_values(".env")
  s3 = boto3.client(
    's3',
    # https://docs.weka.io/additional-protocols/s3/s3-examples-using-boto3
    endpoint_url=f'http://localhost:{config["MINIO_PORT"]}',
    aws_access_key_id=config["MINIO_ROOT_USER"],
    aws_secret_access_key=config["MINIO_ROOT_PASSWORD"]
  )
  objects = set([s["Key"] for s in s3.list_objects(Bucket=config["S3_BUCKET"])['Contents']])
  assert objects.issuperset({f'results/{task_id}.csv', f'results/{task_id}.json'}), objects


@pytest.mark.usefixtures("test_containers_fixture")
def test_failing_run():
  task_id = str(uuid.uuid4())
  with pytest.raises(Exception) as exc_info:
    run_task(task_id, "asdfasdf")
    assert str(exc_info.value).startswith(f"Failed execution ['sudo', 'docker', 'run', '--name', 'flatland3-submission-{task_id}'")
