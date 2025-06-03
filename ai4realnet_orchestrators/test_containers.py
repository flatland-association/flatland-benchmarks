import logging
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

# set to True if docker-compose-demo.yml is already up and running
ATTENDED = False


@pytest.fixture(scope="module")
def test_containers_fixture():
  if ATTENDED:
    yield
    return

  global basic

  start_time = time.time()
  basic = DockerCompose(context=".", compose_file_name="../evaluation/docker-compose-demo.yml", profiles=["full"], build=True)
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
  result = fab.submissions_post(SubmissionsPostRequest(
    name="fancy",
    benchmark='1',  # TODO uuid
    submission_data_url="ghcr.io/flatland-association/flatland-benchmarks-f3-starterkit:latest",  # TODO use submission_data_url
    code_repository="https://github.com/you-name-it",
    tests=[1, 2],  # TODO mandatory despite optional in swagger.json
    # https://github.com/OpenAPITools/openapi-generator/issues/19485
    # https://github.com/openAPITools/openapi-generator-pip
  ))
  print(result)

  # TODO get submissions
  # TODO extract to repo,
  # TODO post results ?
  #  - integration celery task -> orchestrator -> test -> assert on log or on post?

  # TODO interface flatland with TrajectoryAPI
  # TODO split test runner and test evaluator

  # TODO extract orchestrator interface, possibly als test runner and test evaluator? and add UT
