# based on https://github.com/codalab/codabench/blob/develop/orchestrator/orchestrator.py
import logging
import tempfile
import time
import traceback
from abc import abstractmethod
from enum import Enum
from pathlib import Path
from typing import Dict, Optional
from typing import List

import boto3
from flatland.evaluators.trajectory_evaluator import TrajectoryEvaluator
from flatland.trajectories.trajectories import Trajectory
from oauthlib.oauth2 import BackendApplicationClient
from requests_oauthlib import OAuth2Session

from fab_clientlib import DefaultApi, ApiClient, Configuration, ResultsSubmissionsSubmissionIdTestsTestIdsPostRequest, \
  ResultsSubmissionsSubmissionIdTestsTestIdsPostRequestDataInner, SubmissionsSubmissionIdsStatusesPostRequest
from s3_utils import s3_utils, download_dir, S3_UPLOAD_ROOT

logger = logging.getLogger(__name__)


class Status(Enum):
  started = "STARTED"
  success = "SUCCESS"
  failure = "FAILURE"


class TaskExecutionError(Exception):
  def __init__(self, message: str, status: Dict):
    super().__init__(message)
    self.message = message
    self.status = status


class FlatlandBenchmarksOrchestrator:
  def __init__(self,
               submission_id: str,
               aws_endpoint_url: str,
               aws_access_key_id: str,
               aws_secret_access_key: str,
               s3_bucket: str,
               s3: boto3.session.Session.client = None,
               fab_api_url=None,
               client_id=None,
               client_secret=None,
               token_url=None,
               percentage_complete_threshold: float = None,
               running_time_limit: float = None,  # time limit for the submission container/pod running for one scenario (excluding pulling/initialization).
               **kwargs):
    self.submission_id = submission_id
    self.aws_endpoint_url = aws_endpoint_url
    self.aws_access_key_id = aws_access_key_id
    self.aws_secret_access_key = aws_secret_access_key

    self.s3 = s3
    if self.s3 is None:
      self.s3 = s3_utils.get_boto_client(aws_access_key_id, aws_secret_access_key, aws_endpoint_url)
    self.s3_bucket = s3_bucket
    self.fab_api_url = fab_api_url
    self.client_id = client_id
    self.client_secret = client_secret
    self.token_url = token_url
    self.percentage_complete_threshold = percentage_complete_threshold
    self.running_time_limit = running_time_limit

  def orchestrator(self,
                   submission_data_url: str,
                   tests: List[str] = None,
                   fab: DefaultApi = None,
                   **kwargs):
    """
    Run orchestrator for submission data URL (docker image) on the given tests and upload results to FAB.

    Parameters
    ----------
    submission_data_url
    tests
    fab
    kwargs

    Returns
    -------

    """
    submission_id = self.submission_id
    logger.info(f"// START task submission_id={submission_id} with submission_data_url={submission_data_url}.")
    _fab = self._backend_application_flow(fab)
    _fab.submissions_submission_ids_statuses_post([submission_id], SubmissionsSubmissionIdsStatusesPostRequest(status=Status.started.value))

    start_time = time.time()
    try:
      ret = self.run_flatland(submission_id, submission_data_url, tests, **kwargs)
    except BaseException as e:
      try:
        _fab = self._backend_application_flow(fab)
        _fab.submissions_submission_ids_statuses_post([submission_id], SubmissionsSubmissionIdsStatusesPostRequest(status=Status.failure.value))
      finally:
        raise e

    logger.info(f"// START uploading results for submission_id={submission_id} with submission_data_url={submission_data_url}.")
    try:
      _fab = self._backend_application_flow(fab)
      for test_id, scenarios in ret.items():
        for scenario_id, result in scenarios.items():
          logger.info(f"uploading results for submission_id={submission_id},test_id={test_id}, scenario_id={scenario_id}: {result}")
          _fab.results_submissions_submission_id_tests_test_ids_post(
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
      logger.info(
        f"\\\\ END uploading results for with submission_id={submission_id} with submission_data_url={submission_data_url}.")
      _fab.submissions_submission_ids_statuses_post([submission_id], SubmissionsSubmissionIdsStatusesPostRequest(status=Status.success.value))
      duration = time.time() - start_time
      logger.info(f"\\\\ END task submission_id={submission_id} with submission_data_url={submission_data_url}.  Took {duration:.2f} seconds.")
      return ret
    except BaseException as e:
      logger.error("Failed uploading results for with exception \"%s\"", e, exc_info=e)
      raise Exception(
        f"Failed uploading results for with exception \"{e}\". Stacktrace: {traceback.format_exception(e)}") from e

  def _backend_application_flow(self, fab: DefaultApi | None) -> DefaultApi:
    if fab is None:
      token = backend_application_flow(CLIENT_ID, CLIENT_SECRET, TOKEN_URL)
      fab = DefaultApi(ApiClient(configuration=Configuration(host=FAB_API_URL, access_token=token["access_token"])))
    return fab

  @abstractmethod
  def _run_submission(self,
                      test_id,
                      scenario_id,
                      submission_data_url,
                      pkl_path,
                      **kwargs):
    """
    Run the submission from submission data URL (docker image) for one scenario, which is at pkl path.

    Parameters
    ----------
    test_id
    scenario_id
    submission_data_url
    pkl_path
    kwargs

    Returns
    -------

    """
    raise NotImplementedError()

  def run_flatland(self, submission_id: str, submission_data_url: str, tests: Optional[List[str]], **kwargs) -> dict:
    """
    Run submission, download trajectory from S3, re-run with stored actions to verify rewards and return results.

    Parameters
    ----------
    submission_id
    submission_data_url
    tests
    kwargs

    Returns
    -------

    """
    try:

      if tests is None:
        tests = list(self.TEST_TO_SCENARIO_IDS.keys())

      logger.info(f"// START running submission submission_id={submission_id},tests={tests}")
      results = {test_id: {} for test_id in tests}
      for test_id in tests:
        mean_success_rate = 0
        for scenario_id in self.TEST_TO_SCENARIO_IDS[test_id]:
          pkl_path = self.load_scenario_data(scenario_id)
          prefix = f"{S3_UPLOAD_ROOT}{submission_id}/{test_id}/{scenario_id}"

          ret = self._run_submission(test_id, scenario_id, submission_data_url, pkl_path, **kwargs)
          scenario_running_time = ret["running_time"]
          if self.running_time_limit is not None and scenario_running_time > self.running_time_limit:
            logger.warning(
              f"\\\\ END running submission submission_id={submission_id},test_id={test_id}, scenario_id={scenario_id}. The scenario running time was exceeded : {scenario_running_time:.2f}s > {self.running_time_limit:.2f}s: {results[test_id][scenario_id]}")
            return results

          logger.info(f"// START evaluating submission submission_id={submission_id},test_id={test_id}, scenario_id={scenario_id}")
          with tempfile.TemporaryDirectory() as tmpdirname:
            logger.info(f"download_dir(prefix={prefix}, bucket={self.s3_bucket}, client={self.s3}, local={tmpdirname})")
            download_dir(prefix=prefix, bucket=self.s3_bucket, client=self.s3, local=tmpdirname)
            logger.info(list(Path(tmpdirname).rglob("**/*")))

            local_scenario_path = Path(tmpdirname) / S3_UPLOAD_ROOT / submission_id / test_id / scenario_id

            # TODO trajectory should be verified - got lost in a refactoring?
            normalized_reward, success_rate = self._extract_stats_from_trajectory(local_scenario_path, scenario_id)
            results[test_id][scenario_id] = {
              "normalized_reward": normalized_reward,
              "percentage_complete": success_rate
            }
            mean_success_rate += success_rate
        mean_success_rate /= len(self.TEST_TO_SCENARIO_IDS[test_id])
        if self.percentage_complete_threshold is not None and mean_success_rate < self.percentage_complete_threshold:
          logger.warning(
            f"\\\\ END running submission submission_id={submission_id},test_id={test_id}, scenario_id={scenario_id}. The mean percentage of done agents during the last Test ({len(tests)} environments) was too low: {success_rate} < {self.percentage_complete_threshold}: {results[test_id][scenario_id]}")
          return results

      logger.info(
        f"\\\\ END running submission submission_id={submission_id},test_id={test_id}, scenario_id={scenario_id}: {results[test_id][scenario_id]}")
      return results
    except BaseException as exception:
      logger.error(f"Failed task with submission_id={submission_id} with submission_data_url={submission_data_url}: {str(exception)}", exc_info=exception)
      raise RuntimeError(
        f"Failed task with submission_id={submission_id} with submission_data_url={submission_data_url}: {str(exception)}. Stacktrace: {traceback.format_exception(exception)}") from exception

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
