"""
Manual tests to verify k8s setup.
Takes credentials from env vars or .env file in the same folder as this script.
"""
import logging
import uuid
from pathlib import Path

from dotenv import dotenv_values
from kubernetes import config

from fab_clientlib import DefaultApi, ApiClient, Configuration, SubmissionsPostRequest
from orchestration_job import trigger_orchestrator_job, _load_orchestration_config
from orchestrator_common import pretty_print_dict, backend_application_flow

_ENV_PATH = Path(__file__).resolve().parent / ".env"
_ENV_VARS = dotenv_values(_ENV_PATH)

logging.basicConfig(encoding='utf-8', level=logging.INFO)


def test_trigger_orchestrator(
  submission_data_url="ghcr.io/flatland-association/flatland-baselines-random:latest",
  orchestrator_image="ghcr.io/flatland-association/fab-flatland3-benchmarks-orchestrator:587-decouple-queue-consumer",
  # flatland3_benchmarks
  benchmark_id="fd6dc299-9d3d-410d-a17c-338dc1cf3752",
  test_ids=['fc8f5fb1-4525-4b4f-a022-d3d7800097dc'],

  # #ecml2026
  # benchmark_id='c85d5fc2-15da-4a62-8e14-28d1261c29bd',
  # test_ids=['774bf9d6-7bd6-41da-925a-230658d481ec',
  #           # '6670be1d-9fc0-48c8-9bc9-fc889f56d615', 'f3aefb9c-a79e-413a-b73c-f46c794855c1', '68ade1f2-301f-4d8d-b9d6-f3110b6e7587',
  #           # 'd49091c0-793b-401b-a0c8-12df1361deef', '86225a96-492d-474b-aa80-de166b005e42'
  #           ],
):
  _ENV_VARS["SUBMISSION_ID"] = "ignore"
  _ENV_VARS["SUBMISSION_DATA_URL"] = submission_data_url
  _ENV_VARS["ORCHESTRATOR_IMAGE"] = orchestrator_image

  orch_config = _load_orchestration_config(_ENV_VARS)

  token = backend_application_flow(orch_config["client_id"], orch_config["client_secret"], orch_config["token_url"])
  print("token")
  print(token)
  fab = DefaultApi(ApiClient(configuration=Configuration(host=orch_config["fab_api_url"], access_token=token["access_token"])))
  res = fab.submissions_skip_enqueue_post(
    SubmissionsPostRequest(name="fancy", benchmark_id=benchmark_id, submission_data_url=submission_data_url, code_repository="", test_ids=test_ids)
  )
  orch_config["submission_id"] = str(res.body.id)
  orch_config["tests"] = ",".join(test_ids)

  pretty_print_dict(orch_config)
  config.load_kube_config()
  trigger_orchestrator_job(orch_config)


if __name__ == '__main__':
  test_trigger_orchestrator()
