import uuid

import pytest

from test_containers_flatland_benchmarks import run_task, test_containers_fixture

@pytest.mark.usefixtures("test_containers_fixture")
def test_railway():
  submission_id = str(uuid.uuid4())
  run_task('20ccc7c1-034c-4880-8946-bffc3fed1359', submission_id, "asdfasdf", tests=["557d9a00-7e6d-410b-9bca-a017ca7fe3aa"])
