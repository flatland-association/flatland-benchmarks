import json
import logging
import uuid
from io import StringIO

import pandas as pd
import pytest
import redis
from celery import Celery
from testcontainers.compose import DockerCompose

logger = logging.getLogger(__name__)

@pytest.fixture
def test_containers_fixture():
    global basic

    basic = DockerCompose(context=".", compose_file_name="docker-compose-demo.yml")
    logger.info("/ start docker compose up")
    basic.start()
    logger.info("\\ end docker compose")

    task_id = str(uuid.uuid4())
    yield task_id

    stdout, stderr = basic.get_logs()
    logger.info("stdout from docker compose")
    logger.info(stdout)
    logger.error("stderr from docker compose")
    logger.error(stderr)

    logger.info("/ start docker compose down")
    basic.stop()
    logger.info("\\ end docker down")


@pytest.mark.usefixtures("test_containers_fixture")
def test_succesful_run(test_containers_fixture: str):
    task_id = test_containers_fixture
    app = Celery(
        broker="pyamqp://localhost:5672",
        backend='redis://localhost:6379',
    )
    logger.info(f"/ Start simulate submission from portal for task_id={task_id}.....")
    ret = app.send_task(
        'flatland3-evaluation',
        task_id=task_id,
        kwargs={
            "docker_image": "ghcr.io/flatland-association/fab-flatland-evaluator:latest",
            "submission_image": "ghcr.io/flatland-association/fab-flatland-submission-template:latest"
        },
    ).get()
    logger.info(ret)
    all_completed = all([s["job_status"] == "Complete" for s in ret.values()])

    assert all_completed, ret
    logger.info(
        f"\\ End simulate submission from portal for task_id={task_id}: {[(k, v['job_status'], v['image_id'], v['log']) for k, v in ret.items()]}")

    # check Celery direct return value
    assert set(ret.keys()) == {"f3-evaluator", "f3-submission"}

    assert set(ret["f3-evaluator"].keys()) == {"job_status", "image_id", "log", "job", "pod", "results.csv", "results.json"}
    assert set(ret["f3-submission"].keys()) == {"job_status", "image_id", "log", "job", "pod"}

    assert ret["f3-evaluator"]["job_status"] == "Complete"
    assert ret["f3-submission"]["job_status"] == "Complete"

    assert ret["f3-evaluator"]["image_id"] == "ghcr.io/flatland-association/fab-flatland-evaluator:latest"
    assert ret["f3-submission"]["image_id"] == "ghcr.io/flatland-association/fab-flatland-submission-template:latest"

    assert "end evaluator/run.sh" in str(ret["f3-evaluator"]["log"])
    assert "end submission_template/run.sh" in str(ret["f3-submission"]["log"])

    res_df = pd.read_csv(StringIO(ret["f3-evaluator"]["results.csv"]))
    print(res_df)
    res_json = json.loads(ret["f3-evaluator"]["results.json"])
    print(res_json)

    # check Celery return value from redis
    r = redis.Redis(host='localhost', port=6379, db=0)
    res = r.get(f"celery-task-meta-{task_id}")
    res = json.loads(res.decode("utf-8"))

    assert res["status"] == "SUCCESS"
    assert res["task_id"] == task_id
    ret = res["result"]
    assert set(ret.keys()) == {"f3-evaluator", "f3-submission"}

    assert set(ret["f3-evaluator"].keys()) == {"job_status", "image_id", "log", "job", "pod", "results.csv", "results.json"}
    assert set(ret["f3-submission"].keys()) == {"job_status", "image_id", "log", "job", "pod"}

    assert ret["f3-evaluator"]["job_status"] == "Complete"
    assert ret["f3-submission"]["job_status"] == "Complete"

    assert ret["f3-evaluator"]["image_id"] == "ghcr.io/flatland-association/fab-flatland-evaluator:latest"
    assert ret["f3-submission"]["image_id"] == "ghcr.io/flatland-association/fab-flatland-submission-template:latest"

    assert "end evaluator/run.sh" in str(ret["f3-evaluator"]["log"])
    assert "end submission_template/run.sh" in str(ret["f3-submission"]["log"])

    res_df = pd.read_csv(StringIO(ret["f3-evaluator"]["results.csv"]))
    print(res_df)
    res_json = json.loads(ret["f3-evaluator"]["results.json"])
    print(res_json)
