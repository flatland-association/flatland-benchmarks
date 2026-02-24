# based on https://github.com/codalab/codabench/blob/develop/orchestrator/orchestrator.py
import logging
import os
import tempfile
import time
import traceback
from abc import abstractmethod
from pathlib import Path
from typing import Dict, Optional
from typing import List

import boto3
from flatland.evaluators.trajectory_evaluator import TrajectoryEvaluator
from flatland.trajectories.trajectories import Trajectory
from oauthlib.oauth2 import BackendApplicationClient
from requests_oauthlib import OAuth2Session

from fab_clientlib import DefaultApi, ApiClient, Configuration, ResultsSubmissionsSubmissionIdTestsTestIdsPostRequest, \
  ResultsSubmissionsSubmissionIdTestsTestIdsPostRequestDataInner
from s3_utils import s3_utils, download_dir, S3_UPLOAD_ROOT

logger = logging.getLogger(__name__)

FAB_API_URL = os.environ.get("FAB_API_URL")
CLIENT_ID = os.environ.get("CLIENT_ID", 'fab-client-credentials')
CLIENT_SECRET = os.environ.get("CLIENT_SECRET")
TOKEN_URL = os.environ.get("TOKEN_URL", "https://keycloak.flatland.cloud/realms/flatland/protocol/openid-connect/token")
PERCENTAGE_COMPLETE_THRESHOLD = os.environ.get("PERCENTAGE_COMPLETE_THRESHOLD", None)


class TaskExecutionError(Exception):
  def __init__(self, message: str, status: Dict):
    super().__init__(message)
    self.message = message
    self.status = status


class FlatlandBenchmarksOrchestrator:
  def __init__(self, submission_id: str):
    self.submission_id = submission_id

  def orchestrator(self,
                   submission_data_url: str,
                   tests: List[str] = None,
                   aws_endpoint_url=None,
                   aws_access_key_id=None,
                   aws_secret_access_key=None,
                   s3_bucket=None,
                   s3=None,
                   fab: DefaultApi = None,
                   **kwargs):
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

      ret = self.run_flatland(submission_id, submission_data_url, tests, aws_endpoint_url, aws_access_key_id, aws_secret_access_key, s3_bucket, s3, **kwargs)

    except BaseException as e:
      logger.error("Failed get results from S3 and uploading to FAB with exception \"%s\"", e, exc_info=e)
      raise Exception(
        f"Failed get results from S3 and uploading to FAB with exception \"{e}\". Stacktrace: {traceback.format_exception(e)}") from e

    try:
      if fab is None:
        token = backend_application_flow(CLIENT_ID, CLIENT_SECRET, TOKEN_URL)
        print("token")
        print(token)
        fab = DefaultApi(ApiClient(configuration=Configuration(host=FAB_API_URL, access_token=token["access_token"])))


      for test_id, scenarios in ret.items():
        for scenario_id, result in scenarios.items():
          logger.info(f"uploading results for submission_id={submission_id},test_id={test_id}, scenario_id={scenario_id}: {result}")
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
      duration = time.time() - start_time
      logger.info(
        f"\\ end task with submission_id={submission_id} with submission_data_url={submission_data_url}. Took {duration:.2f} seconds.")
      return ret
    except BaseException as e:
      logger.error("Failed get results from S3 and uploading to FAB with exception \"%s\"", e, exc_info=e)
      raise Exception(
        f"Failed get results from S3 and uploading to FAB with exception \"{e}\". Stacktrace: {traceback.format_exception(e)}") from e

  @abstractmethod
  def _run_submission(self,
                      test_id,
                      scenario_id,
                      submission_data_url,
                      pkl_path,
                      aws_endpoint_url: str,
                      aws_access_key_id: str,
                      aws_secret_access_key: str,
                      s3_bucket: str,
                      **kwargs):
    raise NotImplementedError()

  def run_flatland(self, submission_id: str, submission_data_url: str, tests: Optional[List[str]], aws_endpoint_url: str, aws_access_key_id: str,
                   aws_secret_access_key: str, s3_bucket: str, s3: Optional[boto3.session.Session.client], **kwargs):
    try:
      if tests is None:
        tests = list(self.TEST_TO_SCENARIO_IDS.keys())

      results = {test_id: {} for test_id in tests}
      for test_id in tests:
        mean_success_rate = 0
        for scenario_id in self.TEST_TO_SCENARIO_IDS[test_id]:
          pkl_path = self.load_scenario_data(scenario_id)
          prefix = f"{S3_UPLOAD_ROOT}{submission_id}/{test_id}/{scenario_id}"

          self._run_submission(test_id, scenario_id, submission_data_url, pkl_path, aws_endpoint_url, aws_access_key_id, aws_secret_access_key, s3_bucket,
                               submission_id=submission_id, **kwargs)

          logger.info(f"// START evaluating submission submission_id={submission_id},test_id={test_id}, scenario_id={scenario_id}")
          with tempfile.TemporaryDirectory() as tmpdirname:
            if s3 is None:
              s3 = s3_utils.get_boto_client(aws_access_key_id, aws_secret_access_key, aws_endpoint_url)

            logger.info(f"download_dir(prefix={prefix}, bucket={s3_bucket}, client={s3}, local={tmpdirname})")
            download_dir(prefix=prefix, bucket=s3_bucket, client=s3, local=tmpdirname)
            logger.info(list(Path(tmpdirname).rglob("**/*")))

            normalized_reward, success_rate = self._extract_stats_from_trajectory(Path(tmpdirname) / S3_UPLOAD_ROOT / submission_id / test_id / scenario_id,
                                                                                  scenario_id)
            results[test_id][scenario_id] = {
              "normalized_reward": normalized_reward,
              "percentage_complete": success_rate
            }
            mean_success_rate += success_rate
        mean_success_rate /= len(self.TEST_TO_SCENARIO_IDS[test_id])
        if PERCENTAGE_COMPLETE_THRESHOLD is not None and success_rate < float(PERCENTAGE_COMPLETE_THRESHOLD):
          logger.warning(
            f"\\\\ END running submission submission_id={submission_id},test_id={test_id}, scenario_id={scenario_id}. The mean percentage of done agents during the last Test ({len(tests)} environments) was too low: {success_rate} < {PERCENTAGE_COMPLETE_THRESHOLD}: {results[test_id][scenario_id]}")
          return results

      logger.info(
        f"\\\\ END running submission submission_id={submission_id},test_id={test_id}, scenario_id={scenario_id}: {results[test_id][scenario_id]}")
      return results
    except BaseException as exception:
      logger.error(f"Failed task with submission_id={submission_id} with submission_data_url={submission_data_url}: {str(exception)}")
      raise RuntimeError(f"Failed task with submission_id={submission_id} with submission_data_url={submission_data_url}: {str(exception)}") from exception

  def _extract_stats_from_trajectory(self, data_dir, scenario_id):
    trajectory = Trajectory.load_existing(data_dir=data_dir, ep_id=scenario_id)
    TrajectoryEvaluator(trajectory).evaluate(tqdm_kwargs={"disable": True})
    rail_env = trajectory.load_env()
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
    logger.debug(f"agent_scores: {agent_scores[:10]}...")
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
