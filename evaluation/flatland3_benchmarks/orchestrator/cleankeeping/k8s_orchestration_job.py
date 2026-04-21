"""
Manual tests to verify k8s setup.
Takes credentials from env vars or .env file in the same folder as this script.
"""
import logging
import os
import uuid
from pathlib import Path

from dotenv import dotenv_values
from kubernetes import config
from orchestrator_job import trigger_orchestrator_job

_ENV_PATH = Path(__file__).resolve().parent / ".env"
_ENV_VARS = dotenv_values(_ENV_PATH)


def _require_config(name: str) -> str:
  """Return a required configuration value from environment or .env, with a clear error if missing."""
  value = os.getenv(name) or _ENV_VARS.get(name)
  if value is None:
    raise RuntimeError(
      f"Required configuration value '{name}' is not set. Please define it as an environment "
      f"variable or add it to `{_ENV_PATH}`."
    )
  return value


AWS_ENDPOINT_URL = _require_config("AWS_ENDPOINT_URL")
AWS_ACCESS_KEY_ID = _require_config("AWS_ACCESS_KEY_ID")
AWS_SECRET_ACCESS_KEY = _require_config("AWS_SECRET_ACCESS_KEY")
S3_BUCKET = _require_config("S3_BUCKET")
SUBMISSIONS_PVC = _require_config("SUBMISSIONS_PVC")
ENVIRONMENTS_PVC = _require_config("ENVIRONMENTS_PVC")
ENVIRONMENTS_ZIP = _require_config("ENVIRONMENTS_ZIP")
KUBERNETES_NAMESPACE = _require_config("KUBERNETES_NAMESPACE")
logging.basicConfig(encoding='utf-8', level=logging.INFO)


def test_trigger_orchestrator(
  submission_data_url="ghcr.io/flatland-association/flatland-baselines-random:latest",
  orchestrator_image="ghcr.io/flatland-association/fab-flatland3-benchmarks-orchestrator:587-decouple-queue-consumer",
):
  submission_id = str(uuid.uuid4())
  print(submission_id)
  config.load_kube_config()
  trigger_orchestrator_job(
    submission_id=submission_id,
    submission_data_url=submission_data_url,
    kubernetes_namespace=KUBERNETES_NAMESPACE
  )
