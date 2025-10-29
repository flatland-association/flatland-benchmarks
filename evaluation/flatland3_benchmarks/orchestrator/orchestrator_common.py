# based on https://github.com/codalab/codabench/blob/develop/orchestrator/orchestrator.py
import logging
import os
import time
import traceback
from abc import abstractmethod
from typing import Dict
from typing import List

import celery.exceptions
from flatland.trajectories.trajectories import Trajectory
from oauthlib.oauth2 import BackendApplicationClient
from requests_oauthlib import OAuth2Session

from fab_clientlib import DefaultApi, ApiClient, Configuration, ResultsSubmissionsSubmissionIdTestsTestIdsPostRequest, \
  ResultsSubmissionsSubmissionIdTestsTestIdsPostRequestDataInner

logger = logging.getLogger(__name__)

FAB_API_URL = os.environ.get("FAB_API_URL")
CLIENT_ID = os.environ.get("CLIENT_ID", 'fab-client-credentials')
CLIENT_SECRET = os.environ.get("CLIENT_SECRET")
TOKEN_URL = os.environ.get("TOKEN_URL", "https://keycloak.flatland.cloud/realms/flatland/protocol/openid-connect/token")


class TaskExecutionError(Exception):
  def __init__(self, message: str, status: Dict):
    super().__init__(message)
    self.message = message
    self.status = status


# TODO all 150 scenarios
TEST_TO_SCENARIO_IDS = {
  '4ecdb9f4-e2ff-41ff-9857-abe649c19c50': ['d99f4d35-aec5-41c1-a7b0-64f78b35d7ef', '04d618b8-84df-406b-b803-d516c7425537', ],
  '5206f2ee-d0a9-405b-8da3-93625e169811': ['6f3ad83c-3312-4ab3-9740-cbce80feea91', 'f954a860-e963-431e-a09d-5b1040948f2d',
                                           'f92bfe0c-5347-4d89-bc17-b6f86d514ef8']
}


class FlatlandBenchmarksOrchestrator:
  def __init__(self, submission_id: str):
    self.submission_id = submission_id

  def orchestrator(self, submission_data_url: str, tests: List[str] = None, aws_endpoint_url=None, aws_access_key_id=None, aws_secret_access_key=None,
                   s3_bucket=None, s3=None, fab: DefaultApi = None, **kwargs):
    submission_id = self.submission_id

    try:
      start_time = time.time()

      if aws_endpoint_url is None:
        aws_endpoint_url = os.environ.get("AWS_ENDPOINT_URL", None)
      if aws_access_key_id is None:
        aws_access_key_id = os.environ.get("AWS_ACCESS_KEY_ID", None)
      if aws_secret_access_key is None:
        aws_secret_access_key = os.environ.get("AWS_SECRET_ACCESS_KEY", None)
      if s3_bucket is None:
        s3_bucket = os.environ.get("S3_BUCKET", None)
      ret = self.run_flatland(submission_id, submission_data_url, tests, aws_endpoint_url, aws_access_key_id, aws_secret_access_key, s3_bucket, **kwargs)

      duration = time.time() - start_time
      logger.info(
        f"\\ end task with submission_id={submission_id} with submission_data_url={submission_data_url}. Took {duration:.2f} seconds.")

      if fab is None:
        token = backend_application_flow(CLIENT_ID, CLIENT_SECRET, TOKEN_URL)
        print("token")
        print(token)
        fab = DefaultApi(ApiClient(configuration=Configuration(host=FAB_API_URL, access_token=token["access_token"])))

      for test_id, scenarios in ret.items():
        for scenario_id, result in scenarios.items():
          print(f"uploading results for submission_id={submission_id},test_id={test_id}, scenario_id={scenario_id}: {result}")

          fab.results_submissions_submission_id_tests_test_ids_post(
            submission_id=submission_id,
            test_ids=[test_id],
            results_submissions_submission_id_tests_test_ids_post_request=ResultsSubmissionsSubmissionIdTestsTestIdsPostRequest(
              data=[
                ResultsSubmissionsSubmissionIdTestsTestIdsPostRequestDataInner(
                  scenario_id=scenario_id,
                  scores=result,
                )
              ]
            ),
          )
      return ret

    except celery.exceptions.SoftTimeLimitExceeded as e:
      logger.error("Hit %s - getting logs from containers", e)
      raise e
    except BaseException as e:
      logger.error("Failed get results from S3 and uploading to FAB with exception \"%s\"", e, exc_info=e)
      raise Exception(
        f"Failed get results from S3 and uploading to FAB with exception \"{e}\". Stacktrace: {traceback.format_exception(e)}") from e

  @abstractmethod
  def run_flatland(self, submission_id, submission_data_url, tests, aws_endpoint_url, aws_access_key_id, aws_secret_access_key, s3_bucket, **kwargs):
    raise NotImplementedError()

  def _extract_stats_from_trajectory(self, data_dir, scenario_id):
    # TODO we should evaluate the trajectory and not trust the trajectory from the submission!

    trajectory = Trajectory(data_dir=data_dir, ep_id=scenario_id)
    trajectory.load()
    rail_env = trajectory.restore_episode()
    df_trains_arrived = trajectory.trains_arrived
    logger.info(f"trains arrived: {df_trains_arrived}")
    assert len(df_trains_arrived) == 1
    logger.info(f"trains arrived: {df_trains_arrived.iloc[0]}")
    success_rate = df_trains_arrived.iloc[0]["success_rate"]
    logger.info(f"success rate: {success_rate}")
    df_trains_rewards_dones_infos = trajectory.trains_rewards_dones_infos
    logger.info(f"trains dones infos: {trajectory.trains_rewards_dones_infos}")
    num_agents = df_trains_rewards_dones_infos["agent_id"].max() + 1
    logger.info(f"num_agents: {num_agents}")
    agent_scores = df_trains_rewards_dones_infos["reward"].to_list()
    logger.info(f"agent_scores: {agent_scores}")
    total_rewards = sum(agent_scores)
    normalized_reward = total_rewards / (rail_env._max_episode_steps * rail_env.get_num_agents()) + 1
    return normalized_reward, success_rate


def backend_application_flow(
  client_id='fab',
  client_secret='top-secret',
  token_url='http://localhost:8081/realms/flatland/protocol/openid-connect/token'
):
  """
  Resource Owner Client Credentials Grant Type (grant_type=client_credentials) flow aka. Backend Application Flow.
  https://requests-oauthlib.readthedocs.io/en/latest/oauth2_workflow.html#backend-application-flow
  """
  # Create OAuth session
  client = BackendApplicationClient(client_id=client_id)
  oauth = OAuth2Session(client=client)
  # After user authorization, fetch token
  token = oauth.fetch_token(
    token_url,
    client_id=client_id,
    client_secret=client_secret,
  )
  return token
