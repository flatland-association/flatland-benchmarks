"""
Manual tests to verify k8s setup.
Takes credentials from env vars or .env file in the same folder as this script.
"""
import json
import logging
import uuid
from pathlib import Path

from dotenv import dotenv_values
from kubernetes import config

from orchestration_job import trigger_orchestrator_job, _load_orchestration_config

_ENV_PATH = Path(__file__).resolve().parent / ".env"
_ENV_VARS = dotenv_values(_ENV_PATH)

logging.basicConfig(encoding='utf-8', level=logging.INFO)


def test_trigger_orchestrator(
  submission_data_url="ghcr.io/flatland-association/flatland-baselines-random:latest",
  orchestrator_image="ghcr.io/flatland-association/fab-flatland3-benchmarks-orchestrator:587-decouple-queue-consumer",
):
  _ENV_VARS["SUBMISSION_ID"] = str(uuid.uuid4())
  _ENV_VARS["SUBMISSION_DATA_URL"] = submission_data_url
  _ENV_VARS["ORCHESTRATOR_IMAGE"] = orchestrator_image

  orch_config = _load_orchestration_config(_ENV_VARS)

  print(json.dumps(orch_config, indent=2))
  config.load_kube_config()
  trigger_orchestrator_job(orch_config)


if __name__ == '__main__':
  test_trigger_orchestrator()
