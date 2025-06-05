# based on https://github.com/codalab/codabench/blob/develop/compute_worker/compute_worker.py
import logging
import os
from pathlib import Path
from typing import Dict
from typing import List
from uuid import uuid4

import pandas as pd
from celery import Celery

from fab_oauth_utils import backend_application_flow

logger = logging.getLogger(__name__)

app = Celery(
    broker=os.environ.get('BROKER_URL'),
    backend=os.environ.get('BACKEND_URL'),
    queue=os.environ.get("BENCHMARK_ID"),
)


class TaskExecutionError(Exception):
    def __init__(self, message: str, status: Dict):
        super().__init__(message)
        self.message = message
        self.status = status


# https://docs.celeryq.dev/en/stable/userguide/tasks.html#bound-tasks: A task being bound means the first argument to the task will always be the task instance (self).
# https://docs.celeryq.dev/en/stable/userguide/tasks.html#names: Every task must have a unique name.
@app.task(name=os.environ.get("BENCHMARK_ID"), bind=True)
def orchestrator(self, submission_data_url: str, tests: List[str] = None, **kwargs):
    # we use the submission_id as the unique id of the executing task.
    submission_id = self.request.id
    # we use the benchmark_id as the task's name and queue name (i.e. one task per benchmark). This ensures the Celery task is routed to the responsible orchestrator
    benchmark_id = orchestrator.name
    for test_id in tests:
        if test_id == "1":
            filename = Path(f"{test_id}_{submission_id}.json")
            test_runner(submission_id=submission_id, test_id=test_id, submission_data_url=submission_data_url, filename=filename)
            test_evaluator(submission_id=submission_id, test_id=test_id, filename=filename)
        elif test_id == "[INSERT HERE: @TestId]":
            pass
        else:
            raise TaskExecutionError(status={"orchestrator": "FAILED"}, message=f"Test {test_id} not implemented in {self}")

    return {
        "status": "SUCCESS",
        "message": "message"
    }


def test_runner(submission_id: str, test_id: str, submission_data_url: str, filename: Path):
    """
    Run a test and write output to a file "@SubmissionId_@TestId.json".

    Parameters
    ----------
    submission_id
    test_id
    submission_data_url
    filename

    """
    # run your experiment here and write results to "@TestId.json"
    # TODO docker run -v ./data:/tmp -v ./entrypoint.sh:/home/conda/run.sh ghcr.io/flatland-association/flatland-baselines:latest --data-dir /tmp --policy-pkg flatland_baselines.deadlock_avoidance_heuristic.policy.deadlock_avoidance_policy --policy-cls DeadLockAvoidancePolicy --obs-builder-pkg flatland_baselines.deadlock_avoidance_heuristic.observation.full_env_observation --obs-builder-cls FullEnvObservation --ep-id ABCD
    pass


def test_evaluator(submission_id: str, test_id: str, filename: Path):
    """
    Load test output from file "@SubmissionId_@TestId.json", evaluate and upload to hub.

    Parameters
    ----------
    submission_id
    test_id
    filename

    Returns
    -------

    """

    client_id = os.environ.get("CLIENT_ID", 'fab-client-credentials')
    client_secret = os.environ.get("CLIENT_SECRET")
    token_url = os.environ.get("TOKEN_URL",
                               "https://keycloak.flatland.cloud/realms/netzgrafikeditor/protocol/openid-connect/token")  # TODO change to flatland realm
    token = backend_application_flow(client_id, client_secret, token_url)
    print(token)

    # run your experiment here and write results to "@TestId.json"
    if False:
        df = pd.read_csv("./data/event_logs/TrainMovementEvents.trains_arrived.tsv", sep="\t")
        assert len(df) == 1
        print(df.iloc[0])
        success_rate = df.iloc[0]["success_rate"]
        print(success_rate)
