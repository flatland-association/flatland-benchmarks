import logging
import os
import time
import uuid
from subprocess import CalledProcessError
from typing import Callable, Generator

import pytest
from testcontainers.compose import DockerCompose

logger = logging.getLogger(__name__)


def _print_output(stdout: str, stderr: str) -> None:
  print(f"stdout: {stdout}")
  print(f"stderr: {stderr}")


def _dump_compose_logs(basic: DockerCompose) -> None:
  try:
    stdout, stderr = basic.get_logs()
    _print_output(stdout, stderr)
  except Exception as e:
    print(f"Could not get logs from docker compose: {e}")


def _test_containers_generator(request: pytest.FixtureRequest, context: str) -> Generator[str, None, None]:
  """Plain generator with the fixture's actual logic, kept separate from @pytest.fixture so it's directly unit-testable."""

  # set env var ATTENDED to True if docker-compose.yml is already up and running
  if os.environ.get("ATTENDED", "False").lower() == "true":
    yield
    return

  # test modules may set a module-level ENV_FILE to pass to DockerCompose's env_file
  env_file = getattr(request.module, "ENV_FILE", None)
  basic = DockerCompose(context=context, profiles=["full"], env_file=env_file, build=True)

  try:
    start_time = time.time()
    logger.info("/ start docker compose down")
    basic.stop()
    duration = time.time() - start_time
    logger.info(f"\\ end docker compose down. Took {duration:.2f} seconds.")
    start_time = time.time()
    logger.info("/ start docker compose up")
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
  except CalledProcessError as e:
    print(f"Failure: {e}")
    _print_output(e.stdout.decode(errors="ignore"), e.stderr.decode(errors="ignore"))
    _dump_compose_logs(basic)
    raise e
  except BaseException as e:
    print(f"An exception occurred during running docker compose: {e}")
    _dump_compose_logs(basic)
    raise e


def make_test_containers_fixture(context: str) -> Callable[[pytest.FixtureRequest], Generator[str, None, None]]:
  """Build a module-scoped pytest fixture that brings up the docker-compose stack rooted at `context`."""

  @pytest.fixture(scope="module")
  def test_containers_fixture(request: pytest.FixtureRequest) -> Generator[str, None, None]:
    yield from _test_containers_generator(request, context)

  return test_containers_fixture
