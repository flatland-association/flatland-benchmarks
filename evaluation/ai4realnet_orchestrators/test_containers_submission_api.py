import logging
import os
import time
import uuid

import pytest
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
  # set env var ATTENDED to True if docker-compose-demo.yml is already up and running
  if os.environ.get("ATTENDED", False):
    yield
    return

  global basic

  start_time = time.time()
  basic = DockerCompose(context=".", compose_file_name="../docker-compose-demo.yml", profiles=["full"], build=True)
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


@pytest.mark.usefixtures("test_containers_fixture")
def test_start_submission():
  token = backend_application_flow(
    client_id='fab-client-credentials',
    client_secret='top-secret',
    token_url='http://localhost:8081/realms/netzgrafikeditor/protocol/openid-connect/token',
  )
  print(token)
  fab = DefaultApi(ApiClient(configuration=Configuration(host="http://localhost:8000", access_token=token["access_token"])))
  posted_submission = fab.submissions_post(SubmissionsPostRequest(
    name="fancy",
    benchmark_definition_id='20ccc7c1-034c-4880-8946-bffc3fed1359',
    submission_data_url="ghcr.io/flatland-association/flatland-benchmarks-f3-starterkit:latest",
    code_repository="https://github.com/you-name-it",
    test_definition_ids=['557d9a00-7e6d-410b-9bca-a017ca7fe3aa'],  # TODO mandatory despite optional in swagger.json, use UUIDs
    # https://github.com/OpenAPITools/openapi-generator/issues/19485
    # https://github.com/openAPITools/openapi-generator-pip
  ))
  print(posted_submission)
  submissions = fab.submissions_uuid_get(uuid=posted_submission.body.id)
  print(submissions)
  assert submissions.body[0].id == posted_submission.body.id
  assert submissions.body[0].benchmark_definition_id == '20ccc7c1-034c-4880-8946-bffc3fed1359'
  assert submissions.body[0].submitted_by_username == "service-account-fab-client-credentials"

  # TODO extract to repo,
  # TODO post results ?
  #  - integration celery task -> orchestrator -> test -> assert on log or on post?
  #  - own docker compose
  # TODO add integration test
