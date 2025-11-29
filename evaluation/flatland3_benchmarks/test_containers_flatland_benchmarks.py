import logging
import os
import tempfile
import time
import uuid
from typing import List, Optional

import boto3
import pytest
from celery import Celery
from dotenv import dotenv_values
from oauthlib.oauth2 import BackendApplicationClient
from requests_oauthlib import OAuth2Session
from testcontainers.compose import DockerCompose

import s3_utils
from fab_clientlib import DefaultApi, ApiClient, Configuration
from orchestrator_docker_compose import DockerComposeFlatlandBenchmarksOrchestrator
from s3_utils import download_dir

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


def run_task(benchmark_id: str, submission_id: str, submission_data_url: str, tests: Optional[List[str]] = None, **kwargs):
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
  "tests,expected_test_ids,expected_total_simulation_count,expected_primary_scenario_scores,expected_primary_test_scores,expected_secondary_scenario_scores,expected_secondary_test_scores",
  [
    (None, ["4ecdb9f4-e2ff-41ff-9857-abe649c19c50", "5206f2ee-d0a9-405b-8da3-93625e169811"], 5, [[1, 1], [1, 1, 1]], [2, 3], [[1, 1], [1, 1, 1]], [1, 1]),
    (["4ecdb9f4-e2ff-41ff-9857-abe649c19c50", "5206f2ee-d0a9-405b-8da3-93625e169811"],
     ["4ecdb9f4-e2ff-41ff-9857-abe649c19c50", "5206f2ee-d0a9-405b-8da3-93625e169811"], 5, [[1, 1], [1, 1, 1]], [2, 3], [[1, 1], [1, 1, 1]], [1, 1]),
    (["4ecdb9f4-e2ff-41ff-9857-abe649c19c50"], ["4ecdb9f4-e2ff-41ff-9857-abe649c19c50"], 2, [[1, 1]], [2], [[1, 1]], [1]),
    (["5206f2ee-d0a9-405b-8da3-93625e169811"], ["5206f2ee-d0a9-405b-8da3-93625e169811"], 3, [[1, 1, 1]], [3], [[1, 1, 1]], [1])
  ],
  ids=[
    "all",
    "Test_0,Test_1",
    "Test0",
    "Test1"
  ]
)
def test_successful_run(expected_total_simulation_count, expected_test_ids, tests: List[str], expected_primary_scenario_scores: List[List[float]],
                        expected_primary_test_scores: List[float], expected_secondary_scenario_scores: List[List[float]],
                        expected_secondary_test_scores: List[float]):
  submission_id = str(uuid.uuid4())
  config = dotenv_values("../../.env")

  ret = run_task('f669fb8d-80ac-4ba7-8875-0a33ed5d30b9', submission_id,
                 # use deterministic baselines
                 submission_data_url="ghcr.io/flatland-association/flatland-baselines-deadlock-avoidance-heuristic:latest",
                 tests=tests, **config)
  assert set(ret.keys()) == set(expected_test_ids)

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

  for test_id in expected_test_ids:
    for scenario_id in DockerComposeFlatlandBenchmarksOrchestrator.TEST_TO_SCENARIO_IDS[test_id]:
      prefix = f"{s3_utils.S3_UPLOAD_ROOT}/{submission_id}/{test_id}/{scenario_id}".replace("//", "/")
      print(f"Checking results present in S3 for test {test_id}, scenario {scenario_id} of submission {submission_id} ")
      with tempfile.TemporaryDirectory() as tmp_dir_name:
        download_dir(prefix=prefix, bucket=s3_bucket, client=s3, local=tmp_dir_name)

  token = backend_application_flow(
    client_id='fab-client-credentials',
    client_secret='top-secret',
    token_url='http://localhost:8081/realms/flatland/protocol/openid-connect/token',
  )
  fab = DefaultApi(ApiClient(configuration=Configuration(host="http://localhost:8000", access_token=token["access_token"])))

  fab.submissions_submission_ids_patch(submission_ids=[uuid.UUID(submission_id)])

  for test_id, primary_scenario_scores, primary_test_score, secondary_scenario_scores, secondary_test_score in (
    zip(expected_test_ids, expected_primary_scenario_scores, expected_primary_test_scores, expected_secondary_scenario_scores, expected_secondary_test_scores)):
    print(f"Checking results for test {test_id} of submission {submission_id} ")
    test_results = fab.results_submissions_submission_id_tests_test_ids_get(
      submission_id=uuid.UUID(submission_id),
      test_ids=[uuid.UUID(test_id)])
    print(test_results)
    for i in range(len(primary_scenario_scores)):
      assert test_results.body[0].scenario_scorings[i].scorings[0].field_key == "normalized_reward"
      assert test_results.body[0].scenario_scorings[i].scorings[0].score == primary_scenario_scores[i]
      assert test_results.body[0].scenario_scorings[i].scorings[1].field_key == "percentage_complete"
      assert test_results.body[0].scenario_scorings[i].scorings[1].score == secondary_scenario_scores[i]
    assert test_results.body[0].scorings[0].field_key == "punctuality"
    assert test_results.body[0].scorings[0].score == primary_test_score
    assert test_results.body[0].scorings[1].field_key == "mean_percentage_complete"
    assert test_results.body[0].scorings[1].score == secondary_test_score


@pytest.mark.usefixtures("test_containers_fixture")
def test_failing_run():
  submission_id = str(uuid.uuid4())
  with pytest.raises(Exception) as exc_info:
    run_task('f669fb8d-80ac-4ba7-8875-0a33ed5d30b9', submission_id, "asdfasdf")
    assert str(exc_info.value).startswith(f"Failed execution ['sudo', 'docker', 'run', '--name', 'flatland3-submission-{submission_id}'")


def backend_application_flow(
  client_id='fab',
  client_secret='top-secret',
  token_url='http://localhost:8081/realms/flatland/protocol/openid-connect/token'
):
  """
  Resource Owner Client Credentials Grant Type (grant_type=client_credentials) flow aka. Backend Application Flow.
  https://requests-oauthlib.readthedocs.io/en/latest/oauth2_workflow.html#backend-application-flow
  """
  # Create OAuth session
  client = BackendApplicationClient(client_id=client_id)
  oauth = OAuth2Session(client=client)
  # After user authorization, fetch token
  token = oauth.fetch_token(
    token_url,
    client_id=client_id,
    client_secret=client_secret,
  )
  return token
