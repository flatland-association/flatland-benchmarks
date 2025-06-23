import uuid

import pytest

from evaluation.ai4realnet_orchestrators.fab_oauth_utils import backend_application_flow
from fab_clientlib import DefaultApi, Configuration, ApiClient
from test_containers_flatland_benchmarks import run_task, test_containers_fixture


@pytest.mark.usefixtures("test_containers_fixture")
def test_railway():
  benchmark_id = '20ccc7c1-034c-4880-8946-bffc3fed1359'  # Celery: queue name = task name
  submission_id = str(uuid.uuid4())  # Celery: task ID
  test_id = "557d9a00-7e6d-410b-9bca-a017ca7fe3aa"  # Celery: passed in "tests" key of kwargs when Celery task is submitted
  submission_data_url = "ghcr.io/flatland-association/flatland-baselines:latest"  # Celery: passed in "submission_data_url" key of kwargs when Celery task is submitted

  run_task(benchmark_id, submission_id, submission_data_url, tests=[test_id])

  token = backend_application_flow(
    client_id='fab-client-credentials',
    client_secret='top-secret',
    token_url='http://localhost:8081/realms/netzgrafikeditor/protocol/openid-connect/token',
  )
  print(token)
  fab = DefaultApi(ApiClient(configuration=Configuration(host="http://localhost:8000", access_token=token["access_token"])))

  test_results = fab.results_submission_submission_id_tests_test_id_get(
    submission_id=submission_id,
    test_id=test_id)
  print("results_uploaded")
  print(test_results)
  assert test_results.body.scenario_scorings[0].scorings["primary"]["score"] == 100
  assert test_results.body.scenario_scorings[0].scorings["secondary"]["score"] == 1.0
  assert test_results.body.scenario_scorings[1].scorings["primary"]["score"] == 100
  assert test_results.body.scenario_scorings[1].scorings["secondary"]["score"] == 0.8
  assert test_results.body.scorings["primary"]["score"] == 200
  assert test_results.body.scorings["secondary"]["score"] == 1.8
