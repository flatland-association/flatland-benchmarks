import json
import uuid

import pytest
import redis
from celery import Celery
from testcontainers.compose import DockerCompose


@pytest.fixture
def setup_class():
    global basic

    basic = DockerCompose(context=".", compose_file_name="docker-compose-demo.yml")
    print("/ start docker compose up")
    basic.start()
    print("\\ end docker compose")
    yield
    stdout, stderr = basic.get_logs()
    print("stdout from docker compose")
    print(stdout)
    print("stderr from docker compose")
    print(stderr)
    print("/ start docker compose down")
    basic.stop()
    print("\\ end docker down")


@pytest.mark.usefixtures("setup_class")
def test_succesful_run():
    app = Celery(
        broker="pyamqp://localhost:5672",
        backend='redis://localhost:6379',
    )
    task_id = str(uuid.uuid4())
    print(f"/ Start simulate submission from portal for task_id={task_id}.....")
    ret = app.send_task(
        'flatland3-evaluation',
        task_id=task_id,
        kwargs={
            "docker_image": "ghcr.io/flatland-association/fab-flatland-evaluator:latest",
            "submission_image": "ghcr.io/flatland-association/fab-flatland-submission-template:latest"
        },
    ).get(timeout=120)
    print(ret)
    all_completed = all([s["job_status"] == "Complete" for s in ret.values()])

    assert all_completed, ret
    print(
        f"\\ End simulate submission from portal for task_id={task_id}: {[(k, v['job_status'], v['image_id'], v['log']) for k, v in ret.items()]}")

    assert set(ret.keys()) == {"evaluator", "submission"}

    assert set(ret["evaluator"].keys()) == {"job_status", "image_id", "log", "job", "pod"}
    assert set(ret["submission"].keys()) == {"job_status", "image_id", "log", "job", "pod"}

    assert ret["evaluator"]["job_status"] == "Complete"
    assert ret["submission"]["job_status"] == "Complete"

    assert ret["evaluator"]["image_id"] == "ghcr.io/flatland-association/fab-flatland-evaluator:latest"
    assert ret["submission"]["image_id"] == "ghcr.io/flatland-association/fab-flatland-submission-template:latest"

    assert "end evaluator/run.sh" in str(ret["evaluator"]["log"])
    assert "end submission_template/run.sh" in str(ret["submission"]["log"])

    r = redis.Redis(host='localhost', port=6379, db=0)
    res = r.get(f"celery-task-meta-{task_id}")
    res = json.loads(res.decode("utf-8"))

    assert res["status"] == "SUCCESS"
    assert res["task_id"] == task_id
    ret = res["result"]
    assert set(ret.keys()) == {"evaluator", "submission"}

    assert set(ret["evaluator"].keys()) == {"job_status", "image_id", "log", "job", "pod"}
    assert set(ret["submission"].keys()) == {"job_status", "image_id", "log", "job", "pod"}

    assert ret["evaluator"]["job_status"] == "Complete"
    assert ret["submission"]["job_status"] == "Complete"

    assert ret["evaluator"]["image_id"] == "ghcr.io/flatland-association/fab-flatland-evaluator:latest"
    assert ret["submission"]["image_id"] == "ghcr.io/flatland-association/fab-flatland-submission-template:latest"

    assert "end evaluator/run.sh" in str(ret["evaluator"]["log"])
    assert "end submission_template/run.sh" in str(ret["submission"]["log"])
