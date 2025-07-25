import json
import logging
import os
import time
import uuid
from io import StringIO
from typing import List

import boto3
import pandas as pd
import pytest
from celery import Celery
from dotenv import dotenv_values
from testcontainers.compose import DockerCompose

from fab_clientlib import DefaultApi, ApiClient, Configuration
from fab_oauth_utils import backend_application_flow

TRACE = 5
logger = logging.getLogger(__name__)


@pytest.fixture(scope="module")
def test_containers_fixture():
  # set env var ATTENDED to True if docker-compose.yml is already up and running
  if os.environ.get("ATTENDED", "False").lower() == "true":
    yield
    return

  global basic

  start_time = time.time()

  basic = DockerCompose(context="../..", profiles=["full"])
  logger.info("/ start docker compose down")
  basic.stop()
  duration = time.time() - start_time
  logger.info(f"\\ end docker compose down. Took {duration:.2f} seconds.")
  start_time = time.time()
  logger.info("/ start docker compose up")
  try:
    basic.start()
    duration = time.time() - start_time
    logger.info(f"\\ end docker compose up. Took {duration:.2f} seconds.")

    submission_id = str(uuid.uuid4())
    yield submission_id

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
  except BaseException as e:
    print("An exception occurred during running docker compose:")
    print(e)
    stdout, stderr = basic.get_logs()
    print(stdout)
    print(stderr)
    raise e


def run_task(benchmark_id: str, submission_id: str, submission_data_url: str, tests: List[str], **kwargs):
  start_time = time.time()
  app = Celery(
    broker="amqp://localhost:5672",
    backend="rpc://",
  )
  logger.info(f"/ Start simulate submission from portal for submission_id={submission_id}.....")

  ret = app.send_task(
    benchmark_id,
    task_id=submission_id,
    kwargs={
      "submission_data_url": submission_data_url,
      "tests": tests,
      **kwargs
    },
    queue=benchmark_id,
  ).get()
  logger.info(ret)
  duration = time.time() - start_time
  logger.info(
    f"\\ End simulate submission from portal for submission_id={submission_id}. Took {duration} seconds.")
  return ret


@pytest.mark.usefixtures("test_containers_fixture")
@pytest.mark.parametrize(
  "tests,expected_total_simulation_count,expected_primary_scenario_scores,expected_primary_test_scores,expected_secondary_scenario_scores,expected_secondary_test_scores",
  [
    (None, 5, [[1, 1], [1, 1, 1]], [2, 3], [[1, 1], [1, 1, 1]], [1, 1]),
    (["4ecdb9f4-e2ff-41ff-9857-abe649c19c50", "5206f2ee-d0a9-405b-8da3-93625e169811"], 5, [[1, 1], [1, 1, 1]], [2, 3], [[1, 1], [1, 1, 1]], [1, 1]),
    (["4ecdb9f4-e2ff-41ff-9857-abe649c19c50"], 2, [[1, 1], [None, None, None]], [2, 0], [[1, 1], [None, None, None]], [1, None]),
    (["5206f2ee-d0a9-405b-8da3-93625e169811"], 3, [[None, None], [1, 1, 1]], [0, 3], [[None, None], [1, 1, 1]], [None, 1])
  ],
  ids=[
    "all",
    "Test_0,Test_1",
    "Test0",
    "Test1"
  ]
)
def test_succesful_run(expected_total_simulation_count, tests: List[str], expected_primary_scenario_scores: List[List[float]],
                       expected_primary_test_scores: List[float], expected_secondary_scenario_scores: List[List[float]],
                       expected_secondary_test_scores: List[float]):
  submission_id = str(uuid.uuid4())
  config = dotenv_values("../../.env")

  ret = run_task('f669fb8d-80ac-4ba7-8875-0a33ed5d30b9', submission_id,
                 # use deterministic baselines
                 submission_data_url="ghcr.io/flatland-association/flatland-baselines:latest",
                 tests=tests, **config)

  logger.info(f"{[(k, v['job_status'], v['image_id'], v['log']) for k, v in ret.items()]}")

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
  assert ret["f3-submission"]["image_id"] == "ghcr.io/flatland-association/flatland-baselines:latest"

  assert "end evaluator/run.sh" in str(ret["f3-evaluator"]["log"])
  assert "end submission_template/run.sh" in str(ret["f3-submission"]["log"])

  res_df = pd.read_csv(StringIO(ret["f3-evaluator"]["results.csv"]))
  logger.debug(res_df)
  res_json = json.loads(ret["f3-evaluator"]["results.json"])
  logger.debug(res_json)

  assert res_json["simulation_count"] == expected_total_simulation_count

  scenarios_run = res_df.loc[res_df['controller_inference_time_max'].notna()]
  tests_with_some_steps = set(scenarios_run["fab_test_id"])
  # Due to non-determinism of agent and early stopping ("The mean percentage of done agents during the last Test (2 environments) was too low: 0.100 < 0.25"), we cannot check the number of scenarios or tests run
  if tests is not None:
    assert len(tests_with_some_steps.difference(tests)) == 0, (tests_with_some_steps, tests)

  logger.info("Download results from S3")

  aws_endpoint_url = config["AWS_ENDPOINT_URL"]
  s3 = boto3.client(
    's3',
    # https://docs.weka.io/additional-protocols/s3/s3-examples-using-boto3
    # N.B. evaluator uploads from within docker network, we're accessing MinIO container from the host network.
    endpoint_url=aws_endpoint_url.replace("minio", "localhost"),
    aws_access_key_id=config["AWS_ACCESS_KEY_ID"],
    aws_secret_access_key=config["AWS_SECRET_ACCESS_KEY"]
  )
  s3_bucket = config["S3_BUCKET"]

  logger.info("Get results files from S3 under %s...", aws_endpoint_url)
  obj = s3.get_object(Bucket=s3_bucket, Key=f'results/{submission_id}.csv', )
  results_csv = obj['Body'].read().decode("utf-8")
  df = pd.read_csv(StringIO(results_csv))
  print(df)
  obj = s3.get_object(Bucket=s3_bucket, Key=f'results/{submission_id}.json', )
  results_json = obj['Body'].read().decode("utf-8")
  data = json.loads(results_json)
  print(data)

  token = backend_application_flow(
    client_id='fab-client-credentials',
    client_secret='top-secret',
    token_url='http://localhost:8081/realms/flatland/protocol/openid-connect/token',
  )
  print(token)
  fab = DefaultApi(ApiClient(configuration=Configuration(host="http://localhost:8000", access_token=token["access_token"])))

  fab.submissions_submission_ids_patch(submission_ids=[submission_id])

  test_ids = {
    "Test_0": "4ecdb9f4-e2ff-41ff-9857-abe649c19c50",
    "Test_1": "5206f2ee-d0a9-405b-8da3-93625e169811"
  }

  for (test_name, test_id), primary_scenario_scores, primary_test_score, secondary_scenario_scores, secondary_test_score in (
    zip(test_ids.items(), expected_primary_scenario_scores, expected_primary_test_scores, expected_secondary_scenario_scores, expected_secondary_test_scores)):
    test_results = fab.results_submissions_submission_id_tests_test_ids_get(
      submission_id=submission_id,
      test_ids=[test_id])
    print("results_uploaded")
    print(test_results)
    for i in range(len(primary_scenario_scores)):
      assert test_results.body.scenario_scorings[i].scorings["normalized_reward"]["score"] == primary_scenario_scores[i]
      assert test_results.body.scenario_scorings[i].scorings["percentage_complete"]["score"] == secondary_scenario_scores[i]
    assert test_results.body.scorings["sum_normalized_reward"]["score"] == primary_test_score
    assert test_results.body.scorings["mean_percentage_complete"]["score"] == secondary_test_score


@pytest.mark.usefixtures("test_containers_fixture")
def test_failing_run():
  submission_id = str(uuid.uuid4())
  with pytest.raises(Exception) as exc_info:
    run_task('f669fb8d-80ac-4ba7-8875-0a33ed5d30b9', submission_id, "asdfasdf")
    assert str(exc_info.value).startswith(f"Failed execution ['sudo', 'docker', 'run', '--name', 'flatland3-submission-{submission_id}'")
