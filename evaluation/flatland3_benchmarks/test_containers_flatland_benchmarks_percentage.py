import logging
import os
import time
import uuid
from typing import List

import pytest
from testcontainers.compose import DockerCompose

from fab_clientlib import DefaultApi, ApiClient, Configuration, SubmissionsPostRequest
from test_util.container_helpers import wait_for_completion, backend_application_flow

TRACE = 5
logger = logging.getLogger(__name__)


@pytest.fixture(scope="module")
def test_containers_fixture_percentage_complete():
  # set env var ATTENDED to True if docker-compose.yml is already up and running
  if os.environ.get("ATTENDED", "False").lower() == "true":
    yield
    return

  global basic

  start_time = time.time()

  basic = DockerCompose(context="../..", profiles=["full"], env_file=".env.test.percentagecomplete")
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


@pytest.mark.usefixtures("test_containers_fixture_percentage_complete")
@pytest.mark.parametrize(
  "tests,expected_test_ids,expected_primary_scenario_scores,expected_primary_test_scores,expected_secondary_scenario_scores,expected_secondary_test_scores",
  [
    (["4ecdb9f4-e2ff-41ff-9857-abe649c19c50", "5206f2ee-d0a9-405b-8da3-93625e169811"],
     ["4ecdb9f4-e2ff-41ff-9857-abe649c19c50", "5206f2ee-d0a9-405b-8da3-93625e169811"], [[0.6653061224489796, 1], [None, None, None]],
     [1.6653061224489796, None],
     [[0, 1], [None, None, None]], [0.5, None]),
  ],
  ids=[
    "Test_0,Test_1",
  ]
)
def test_percentage_complete(expected_test_ids, tests: List[str], expected_primary_scenario_scores: List[List[float]],
                             expected_primary_test_scores: List[float],
                             expected_secondary_scenario_scores: List[List[float]], expected_secondary_test_scores: List[float]):
  benchmark_id = 'f669fb8d-80ac-4ba7-8875-0a33ed5d30b9'

  token = backend_application_flow(
    client_id='fab-client-credentials',
    client_secret='top-secret',
    token_url='http://localhost:8081/realms/flatland/protocol/openid-connect/token',
  )
  fab = DefaultApi(ApiClient(configuration=Configuration(host="http://localhost:8000", access_token=token["access_token"])))
  res = fab.submissions_post(
    SubmissionsPostRequest(
      benchmark_id=benchmark_id,
      name="flatland-baselines-deadlock-avoidance-heuristic",
      submission_data_url="ghcr.io/flatland-association/flatland-baselines-deadlock-avoidance-heuristic:latest",
      test_ids=tests
    )
  )
  submission_id = str(res.body.id)

  wait_for_completion(submission_id)

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
