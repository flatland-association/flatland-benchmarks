import uuid

import pytest

from test_containers_flatland_benchmarks import run_task, test_containers_fixture


@pytest.mark.usefixtures("test_containers_fixture")
def test_railway():
  submission_id = str(uuid.uuid4())
  run_task('1', submission_id, "asdfasdf", tests=["1"])
