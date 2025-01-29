import json
import logging
import subprocess
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

    logger.info(f"Getting logs from containers")
    subprocess.call(["docker", "ps", "--all"])
    try:
        logger.info("/ Logs from container %s", f"flatland3-evaluator-{task_id}")
        subprocess.call(["docker", "logs", f"flatland3-evaluator-{task_id}", ])
        subprocess.call(["docker", "stop", f"flatland3-evaluator-{task_id}", ])
        subprocess.call(["docker", "rm", f"flatland3-evaluator-{task_id}", ])
        logger.info("\\ Logs from container %s", f"flatland3-evaluator-{task_id}")
    except:
        logger.warning("Could not fetch logs from container %s", f"flatland3-evaluator-{task_id}")
    try:
        logger.warning("/ Logs from container %s", f"flatland3-submission-{task_id}")
        subprocess.call(["docker", "logs", f"flatland3-submission-{task_id}", ])
        subprocess.call(["docker", "stop", f"flatland3-submission-{task_id}", ])
        subprocess.call(["docker", "rm", f"flatland3-submission-{task_id}", ])
        logger.warning("\\ Logs from container %s", f"flatland3-submission-{task_id}")
    except:
        logger.warning("Could not fetch logs from container %s", f"flatland3-submission-{task_id}")

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
    assert set(ret.keys()) == {"evaluator", "submission"}

    assert set(ret["evaluator"].keys()) == {"job_status", "image_id", "log", "job", "pod", "results.csv", "results.json"}
    assert set(ret["submission"].keys()) == {"job_status", "image_id", "log", "job", "pod"}

    assert ret["evaluator"]["job_status"] == "Complete"
    assert ret["submission"]["job_status"] == "Complete"

    assert ret["evaluator"]["image_id"] == "ghcr.io/flatland-association/fab-flatland-evaluator:latest"
    assert ret["submission"]["image_id"] == "ghcr.io/flatland-association/fab-flatland-submission-template:latest"

    assert "end evaluator/run.sh" in str(ret["evaluator"]["log"])
    assert "end submission_template/run.sh" in str(ret["submission"]["log"])

    res_df = pd.read_csv(StringIO(ret["evaluator"]["results.csv"]))
    print(res_df)
    res_json = json.loads(ret["evaluator"]["results.json"])
    print(res_json)

    # check Celery return value from redis
    r = redis.Redis(host='localhost', port=6379, db=0)
    res = r.get(f"celery-task-meta-{task_id}")
    res = json.loads(res.decode("utf-8"))

    assert res["status"] == "SUCCESS"
    assert res["task_id"] == task_id
    ret = res["result"]
    assert set(ret.keys()) == {"evaluator", "submission"}

    assert set(ret["evaluator"].keys()) == {"job_status", "image_id", "log", "job", "pod", "results.csv", "results.json"}
    assert set(ret["submission"].keys()) == {"job_status", "image_id", "log", "job", "pod"}

    assert ret["evaluator"]["job_status"] == "Complete"
    assert ret["submission"]["job_status"] == "Complete"

    assert ret["evaluator"]["image_id"] == "ghcr.io/flatland-association/fab-flatland-evaluator:latest"
    assert ret["submission"]["image_id"] == "ghcr.io/flatland-association/fab-flatland-submission-template:latest"

    assert "end evaluator/run.sh" in str(ret["evaluator"]["log"])
    assert "end submission_template/run.sh" in str(ret["submission"]["log"])

    res_df = pd.read_csv(StringIO(ret["evaluator"]["results.csv"]))
    print(res_df)
    res_json = json.loads(ret["evaluator"]["results.json"])
    print(res_json)
