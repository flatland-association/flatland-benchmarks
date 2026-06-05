"""
Manual tests to verify k8s setup.
Takes credentials from env vars or .env file in the same folder as this script.
"""
import logging
import uuid
from pathlib import Path
from uuid import UUID

import pytest
from dotenv import dotenv_values
from kubernetes import config

from fab_clientlib import DefaultApi, ApiClient, Configuration, SubmissionsPostRequest, SubmissionsSubmissionIdsPatchRequest
from orchestration_job import trigger_orchestrator_job, _load_orchestration_config
from orchestrator_common import pretty_print_dict, backend_application_flow

# _ENV_PATH = Path(__file__).resolve().parent / ".env"
_ENV_PATH = Path(__file__).resolve().parent / ".env.prod"
_ENV_VARS = dotenv_values(_ENV_PATH)

logging.basicConfig(encoding='utf-8', level=logging.INFO)


@pytest.mark.parametrize("submission_data_url,test_id,expected", [
  ("ghcr.io/manuschn/ecml2026-test:ppo-fto-test-latest", 'd49091c0-793b-401b-a0c8-12df1361deef', {},),
  # ("ghcr.io/flatland-association/flatland-baselines-deadlock-avoidance-heuristic:latest", 'd49091c0-793b-401b-a0c8-12df1361deef', {},),
  # ("ghcr.io/flatland-association/flatland-baselines-deadlock-avoidance-heuristic:latest", '86225a96-492d-474b-aa80-de166b005e42', {},),
])
def test_trigger_orchestrator(
  submission_data_url,
  test_id,
  expected,
  # submission_data_url = ,
  # cleanup-logging-2
  # # flatland3_benchmarks
  # benchmark_id="fd6dc299-9d3d-410d-a17c-338dc1cf3752",
  # test_ids=['fc8f5fb1-4525-4b4f-a022-d3d7800097dc'],

  # ecml2026
  benchmark_id='c85d5fc2-15da-4a62-8e14-28d1261c29bd',

):
  if test_id is None:
    test_ids = ['39ae35d8-4b0f-467f-9ec4-ee19c3558c7f',
                '774bf9d6-7bd6-41da-925a-230658d481ec',
                '6670be1d-9fc0-48c8-9bc9-fc889f56d615',
                'f3aefb9c-a79e-413a-b73c-f46c794855c1',
                '68ade1f2-301f-4d8d-b9d6-f3110b6e7587',
                'd49091c0-793b-401b-a0c8-12df1361deef',
                '86225a96-492d-474b-aa80-de166b005e42'
                ]
  else:
    test_ids = [test_id]
  _ENV_VARS["SUBMISSION_ID"] = "ignore"
  _ENV_VARS["SUBMISSION_DATA_URL"] = submission_data_url

  orch_config = _load_orchestration_config(_ENV_VARS)

  token = backend_application_flow(orch_config["client_id"], orch_config["client_secret"], orch_config["token_url"])
  print("token")
  print(token)
  fab = DefaultApi(ApiClient(configuration=Configuration(host=orch_config["fab_api_url"], access_token=token["access_token"])))
  submission = fab.submissions_skip_enqueue_post(
    SubmissionsPostRequest(name="fancy", benchmark_id=benchmark_id, submission_data_url=submission_data_url, code_repository="",
                           test_ids=[UUID(test_id) for test_id in test_ids])
  )
  pretty_print_dict(submission.to_dict())
  submission_id = submission.body.id
  orch_config["submission_id"] = str(submission_id)
  orch_config["tests"] = ",".join(test_ids)

  pretty_print_dict(orch_config)
  config.load_kube_config()
  trigger_orchestrator_job(orch_config)

  statuses = fab.submissions_submission_ids_statuses_get(submission_ids=[submission_id])
  pretty_print_dict(statuses.to_dict())
  print(test_ids)

  assert statuses.body[0].status == "SUCCESS"
  # assert statuses.body[0].message is None

  results = fab.results_submissions_submission_ids_get(submission_ids=[submission_id])
  pretty_print_dict(results.to_dict())
  fab.submissions_submission_ids_patch(submission_ids=[uuid.UUID(submission_id)],
                                       submissions_submission_ids_patch_request=SubmissionsSubmissionIdsPatchRequest.from_dict({"published": True}))
