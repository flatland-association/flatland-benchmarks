import logging
import os
import time
import uuid

import pytest
from fab_clientlib import ResultsSubmissionsSubmissionIdTestsTestIdPostRequest, ResultsSubmissionsSubmissionIdTestsTestIdPostRequestDataInner
from testcontainers.compose import DockerCompose

from fab_clientlib.api.default_api import DefaultApi
from fab_clientlib.api_client import ApiClient
from fab_clientlib.configuration import Configuration
from fab_clientlib.models.submissions_post_request import SubmissionsPostRequest
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
    basic = DockerCompose(context=".", compose_file_name="../evaluation/docker-compose.yml", profiles=["full"], build=True)
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

        task_id = str(uuid.uuid4())
        yield task_id

        # TODO workaround for testcontainers not supporting streaming to logger
        start_time = time.time()
        logger.info("/ start get docker compose logs")
        stdout, stderr = basic.get_logs()
        logger.info("stdout from docker compose")
        logger.info(stdout)
        print(stdout)
        logger.warning("stderr from docker compose")
        logger.warning(stderr)
        print(stderr)
        duration = time.time() - start_time
        logger.info(f"\\ end get docker compose logs. Took {duration:.2f} seconds.")

        start_time = time.time()
        logger.info("/ start docker compose down")
        basic.stop()
        duration = time.time() - start_time
        logger.info(f"\\ end docker down. Took {duration:.2f} seconds.")
    except Exception as e:
        print("An exception occurred during running docker compose:")
        print(e)
        stdout, stderr = basic.get_logs()
        print(stdout)
        print(stderr)
        raise e


# GET /health/live
@pytest.mark.usefixtures("test_containers_fixture")
def test_health_live_get():
    token = backend_application_flow(
        client_id='fab-client-credentials',
        client_secret='top-secret',
        token_url='http://localhost:8081/realms/flatland/protocol/openid-connect/token',
    )
    fab = DefaultApi(ApiClient(configuration=Configuration(host="http://localhost:8000", access_token=token["access_token"])))
    response = fab.health_live_get()
    assert response.body.status == "UP"
    assert len(response.body.checks) == 2
    assert response.body.checks[0].name == "SqlService"
    assert response.body.checks[0].status == "UP"
    assert response.body.checks[1].name == "CeleryService"
    assert response.body.checks[1].status == "UP"


# POST /submissions
# GET /results/submission/{submission_id}/tests/{test_id}
@pytest.mark.usefixtures("test_containers_fixture")
def test_submissions_post():
    benchmark_id = '20ccc7c1-034c-4880-8946-bffc3fed1359'
    test_id = '557d9a00-7e6d-410b-9bca-a017ca7fe3aa'

    results = [
        ('1ae61e4f-201b-4e97-a399-5c33fb75c57e', '557d9a00-7e6d-410b-9bca-a017ca7fe3aa', 'db5eaa85-3304-4804-b76f-14d23adb5d4c', 'primary', 100),
        ('1ae61e4f-201b-4e97-a399-5c33fb75c57e', '557d9a00-7e6d-410b-9bca-a017ca7fe3aa', 'db5eaa85-3304-4804-b76f-14d23adb5d4c', 'secondary', 1.0),
        ('564ebb54-48f0-4837-8066-b10bb832af9d', '557d9a00-7e6d-410b-9bca-a017ca7fe3aa', 'db5eaa85-3304-4804-b76f-14d23adb5d4c', 'primary', 101),
        ('564ebb54-48f0-4837-8066-b10bb832af9d', '557d9a00-7e6d-410b-9bca-a017ca7fe3aa', 'db5eaa85-3304-4804-b76f-14d23adb5d4c', 'secondary', 0.8)
    ]

    token = backend_application_flow(
        client_id='fab-client-credentials',
        client_secret='top-secret',
        token_url='http://localhost:8081/realms/flatland/protocol/openid-connect/token',
    )
    print(token)
    fab = DefaultApi(ApiClient(configuration=Configuration(host="http://localhost:8000", access_token=token["access_token"])))
    posted_submission = fab.submissions_post(SubmissionsPostRequest(
        name="fancy",
        benchmark_definition_id=benchmark_id,
        submission_data_url="ghcr.io/flatland-association/flatland-benchmarks-f3-starterkit:latest",
        code_repository="https://github.com/you-name-it",
        test_definition_ids=[test_id],  # TODO mandatory despite optional in swagger.json, use UUIDs
        # https://github.com/OpenAPITools/openapi-generator/issues/19485
        # https://github.com/openAPITools/openapi-generator-pip
    ))
    print(posted_submission)
    submission_id = posted_submission.body.id
    submissions = fab.submissions_uuid_get(uuid=submission_id)
    print(submissions)
    assert submissions.body[0].id == submission_id
    assert submissions.body[0].benchmark_definition_id == benchmark_id
    assert submissions.body[0].submitted_by_username == "service-account-fab-client-credentials"

    fab.results_submissions_submission_id_tests_test_id_post(
        submission_id=submission_id,
        test_id=test_id,
        results_submissions_submission_id_tests_test_id_post_request=ResultsSubmissionsSubmissionIdTestsTestIdPostRequest(
            data=[ResultsSubmissionsSubmissionIdTestsTestIdPostRequestDataInner(
                scenario_id=scenario_id,
                additional_properties={key: value}
            ) for scenario_id, test_id, submission_id, key, value in results]
        )
    )

    test_results = fab.results_submissions_submission_id_tests_test_id_get(
        submission_id=submission_id,
        test_id=test_id)
    print("results_uploaded")
    print(test_results.body)
    assert test_results.body.scenario_scorings[0].scorings["primary"]["score"] == 100
    assert test_results.body.scenario_scorings[0].scorings["secondary"]["score"] == 1.0
    assert test_results.body.scenario_scorings[1].scorings["primary"]["score"] == 101
    assert test_results.body.scenario_scorings[1].scorings["secondary"]["score"] == 0.8
    assert test_results.body.scorings["primary"]["score"] == 201
    assert test_results.body.scorings["secondary"]["score"] == 1.8

    submission_results = fab.results_submissions_submission_id_get(
        submission_id=submission_id,
    )
    assert len(submission_results.body) == 1
    assert submission_results.body[0].submission_id == submission_id
    assert len(submission_results.body[0].scorings) == 2
    assert submission_results.body[0].scorings["primary"]["score"] == 201
    assert submission_results.body[0].scorings["secondary"]["score"] == 1.8
    assert len(submission_results.body[0].test_scorings) == 1
    assert len(submission_results.body[0].test_scorings[0].scenario_scorings) == 2
    assert submission_results.body[0].test_scorings[0].scenario_scorings[0].scorings["primary"]["score"] == 100
    assert submission_results.body[0].test_scorings[0].scenario_scorings[0].scorings["secondary"]["score"] == 1.0
    assert submission_results.body[0].test_scorings[0].scenario_scorings[1].scorings["primary"]["score"] == 101
    assert submission_results.body[0].test_scorings[0].scenario_scorings[1].scorings["secondary"]["score"] == 0.8


# GET /submissions/
@pytest.mark.usefixtures("test_containers_fixture")
def test_submissions_get():
    token = backend_application_flow(
        client_id='fab-client-credentials',
        client_secret='top-secret',
        token_url='http://localhost:8081/realms/flatland/protocol/openid-connect/token',
    )
    fab = DefaultApi(ApiClient(configuration=Configuration(host="http://localhost:8000", access_token=token["access_token"])))
    response = fab.submissions_get(benchmark="20ccc7c1-034c-4880-8946-bffc3fed1359")
    assert len(response.body) == 1
    assert response.body[0].id == "db5eaa85-3304-4804-b76f-14d23adb5d4c"
    assert response.body[0].benchmark_definition_id == "20ccc7c1-034c-4880-8946-bffc3fed1359"
    assert response.body[0].status == "SUCCESS"
    assert response.body[0].published == True


# GET /submissions/{submission_id}
@pytest.mark.usefixtures("test_containers_fixture")
def test_submissions_uuid_get():
    token = backend_application_flow(
        client_id='fab-client-credentials',
        client_secret='top-secret',
        token_url='http://localhost:8081/realms/flatland/protocol/openid-connect/token',
    )
    fab = DefaultApi(ApiClient(configuration=Configuration(host="http://localhost:8000", access_token=token["access_token"])))
    response = fab.submissions_uuid_get(uuid="db5eaa85-3304-4804-b76f-14d23adb5d4c")
    assert len(response.body) == 1
    assert response.body[0].id == "db5eaa85-3304-4804-b76f-14d23adb5d4c"
    assert response.body[0].benchmark_definition_id == "20ccc7c1-034c-4880-8946-bffc3fed1359"
    assert response.body[0].test_definition_ids == ["557d9a00-7e6d-410b-9bca-a017ca7fe3aa"]
    assert response.body[0].status == "SUCCESS"
    assert response.body[0].published == True
