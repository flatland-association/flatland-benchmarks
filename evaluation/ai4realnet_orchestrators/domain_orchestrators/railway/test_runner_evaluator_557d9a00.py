import logging
import os
from pathlib import Path
from fab_oauth_utils import backend_application_flow

from fab_exec_utils import exec_with_logging

# required only for docker in docker
HOST_DIRECTORY = os.environ.get("HOST_DIRECTORY")


def run_and_evaluate_test_557d9a00(submission_id: str, test_id: str, submission_data_url: str):
    """
    Run experiment and upload results.

    Parameters
    ----------
    submission_id: specifies the submission
    test_id: specifies the test to execute
    submission_data_url: reference to the prediction module to use
    """

    exec_with_logging([
        "sudo", "docker", "run",
        "-v", f"{HOST_DIRECTORY}/data:/app/data",
        "-v", f"{HOST_DIRECTORY}/ai4realnet_orchestrators/domain_orchestrators/railway/entrypoint.sh:/home/conda/run.sh",
        "ghcr.io/flatland-association/flatland-baselines:latest",
        "--data-dir", "/app/data",
        "--policy-pkg", "flatland_baselines.deadlock_avoidance_heuristic.policy.deadlock_avoidance_policy", "--policy-cls", "DeadLockAvoidancePolicy",
        "--obs-builder-pkg", "flatland_baselines.deadlock_avoidance_heuristic.observation.full_env_observation", "--obs-builder-cls", "FullEnvObservation",
        "--ep-id", "ABCD"
    ], log_level_stdout=logging.DEBUG)

    client_id = os.environ.get("CLIENT_ID", 'fab-client-credentials')
    client_secret = os.environ.get("CLIENT_SECRET")
    token_url = os.environ.get("TOKEN_URL",
                               "https://keycloak.flatland.cloud/realms/netzgrafikeditor/protocol/openid-connect/token")  # TODO change to flatland realm
    token = backend_application_flow(client_id, client_secret, token_url)
    print(token)

    with Path("/app/data/output.txt").open("r") as f:
        print(f"read:{f.read()}")

    # TODO POST result

    # run your experiment here and write results to "@TestId.json"
    if False:
        df = pd.read_csv("./data/event_logs/TrainMovementEvents.trains_arrived.tsv", sep="\t")
        assert len(df) == 1
        print(df.iloc[0])
        success_rate = df.iloc[0]["success_rate"]
        print(success_rate)
