"""
Trigger N submissions via FAB API.
"""
from pathlib import Path
from uuid import UUID

from dotenv import dotenv_values

from fab_clientlib import DefaultApi, ApiClient, Configuration, SubmissionsPostRequest
from orchestrator_common import backend_application_flow

_ENV_PATH = Path(__file__).resolve().parent / ".env.prod"
_ENV_VARS = dotenv_values(_ENV_PATH)
if __name__ == '__main__':
  N = 2

  benchmark_id = 'c85d5fc2-15da-4a62-8e14-28d1261c29bd'
  test_ids = ['39ae35d8-4b0f-467f-9ec4-ee19c3558c7f',
              '774bf9d6-7bd6-41da-925a-230658d481ec',
              '6670be1d-9fc0-48c8-9bc9-fc889f56d615',
              'f3aefb9c-a79e-413a-b73c-f46c794855c1',
              '68ade1f2-301f-4d8d-b9d6-f3110b6e7587',
              'd49091c0-793b-401b-a0c8-12df1361deef',
              '86225a96-492d-474b-aa80-de166b005e42'
              ]
  # submission_data_url = "ghcr.io/flatland-association/flatland-baselines-forward-only-heuristic:latest"
  submission_data_url = "ghcr.io/flatland-association/flatland-baselines-deadlock-avoidance-heuristic-intermediate:v4.2.5"

  token = backend_application_flow(_ENV_VARS.get("CLIENT_ID"), _ENV_VARS.get("CLIENT_SECRET"), _ENV_VARS.get("TOKEN_URL"))
  print("token")
  print(token)
  fab = DefaultApi(ApiClient(configuration=Configuration(host=_ENV_VARS.get("FAB_API_URL"), access_token=token["access_token"])))

  for _ in range(N):
    submission = fab.submissions_post(
      SubmissionsPostRequest(name="fancy", benchmark_id=benchmark_id, submission_data_url=submission_data_url, code_repository="",
                             test_ids=[UUID(test_id) for test_id in test_ids])
    )
    print(submission.body.id)
