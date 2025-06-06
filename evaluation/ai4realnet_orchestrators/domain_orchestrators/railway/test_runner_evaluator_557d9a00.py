import logging
import os
from pathlib import Path

import pandas as pd
from fab_oauth_utils import backend_application_flow

from fab_exec_utils import exec_with_logging

# required only for docker in docker
HOST_DIRECTORY = os.environ.get("HOST_DIRECTORY")
DATA_VOLUME = os.environ.get("DATA_VOLUME")


def run_and_evaluate_test_557d9a00(submission_id: str, test_id: str, submission_data_url: str):
    """
    Run experiment and upload results.

    Parameters
    ----------
    submission_id: specifies the submission
    test_id: specifies the test to execute
    submission_data_url: reference to the prediction module to use
    """
    data_dir = f"/app/data/{test_id}/{submission_id}"
    Path(data_dir).mkdir(parents=True, exist_ok=False)
    Path(data_dir).chmod(0o777)

    exec_with_logging([
        "sudo", "docker", "run",
        "--rm",
        "-v", f"{DATA_VOLUME}:/app/data",
        "-v", f"{HOST_DIRECTORY}/ai4realnet_orchestrators/domain_orchestrators/railway/entrypoint.sh:/home/conda/run.sh",
        "ghcr.io/flatland-association/flatland-baselines:latest",
        "--data-dir", data_dir,
        "--policy-pkg", "flatland_baselines.deadlock_avoidance_heuristic.policy.deadlock_avoidance_policy", "--policy-cls", "DeadLockAvoidancePolicy",
        "--obs-builder-pkg", "flatland_baselines.deadlock_avoidance_heuristic.observation.full_env_observation", "--obs-builder-cls", "FullEnvObservation",
        "--ep-id", submission_id
    ], log_level_stdout=logging.DEBUG)

    client_id = os.environ.get("CLIENT_ID", 'fab-client-credentials')
    client_secret = os.environ.get("CLIENT_SECRET")
    token_url = os.environ.get("TOKEN_URL",
                               "https://keycloak.flatland.cloud/realms/netzgrafikeditor/protocol/openid-connect/token")  # TODO change to flatland realm
    token = backend_application_flow(client_id, client_secret, token_url)
    print(token)




    # run your experiment here and write results to "@TestId.json"
    df = pd.read_csv(f"/app/data/{test_id}/{submission_id}/event_logs/TrainMovementEvents.trains_arrived.tsv", sep="\t")
    print(df)
    assert len(df) == 1
    print(df.iloc[0])
    success_rate = df.iloc[0]["success_rate"]
    print(success_rate)

    # TODO POST result
