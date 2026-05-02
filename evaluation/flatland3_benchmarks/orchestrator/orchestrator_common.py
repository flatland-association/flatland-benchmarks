# based on https://github.com/codalab/codabench/blob/develop/orchestrator/orchestrator.py
import json
import logging
import tempfile
import time
import traceback
import uuid
from abc import abstractmethod
from datetime import date, datetime
from enum import Enum
from pathlib import Path
from typing import Dict, Optional, Any, Tuple
from typing import List

import boto3
from flatland.envs.rewards import Rewards
from flatland.evaluators.trajectory_evaluator import TrajectoryEvaluator
from flatland.trajectories.trajectories import Trajectory
from flatland.utils.cli_utils import resolve_type
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
  def __init__(self, message: str, status: Dict = None):
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
               total_running_time_limit: float = None,
               # summed time limit for the submission container/pod running a scenario (excluding pulling/initialization).
               additional_submission_args: str = None,
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
    self.total_running_time_limit = total_running_time_limit
    self.additional_submission_args = additional_submission_args

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
    # as a last resort, strip whitespace in the orchestrator
    submission_data_url = submission_data_url.lstrip().rstrip()
    try:
      submission_id = self.submission_id
      logger.info(f"// START task submission_id={submission_id} with submission_data_url={submission_data_url}.")
      _fab = self._post_submission_status_started(fab, submission_data_url, submission_id)

      start_time = time.time()
      results, termination_cause = self.run_submission(submission_id, submission_data_url, tests, fab=fab, **kwargs)
      duration = time.time() - start_time
      logger.info(f"\\\\ END task submission_id={submission_id} with submission_data_url={submission_data_url}.  Took {duration:.2f} seconds.")
      return results, termination_cause

    except Exception as submission_error:
      try:
        # log evaluation failures here with stacktrace and re-raise finally
        logging.error(
          f"\\\\ FAILURE running submission submission_id={submission_id},tests={tests}, submission_data_url={submission_data_url}. Stacktrace: {'\n'.join(traceback.format_exception(submission_error))}",
          exc_info=submission_error)
        if isinstance(submission_error, TaskExecutionError):
          try:
            submission_error_status = submission_error.status
            log = None
            try:
              log = pretty_dumps_log(submission_error_status["log"]) if submission_error_status is not None and "log" in submission_error_status else None
            except Exception as e:
              logger.warning(f"Could not dump log from {log}", exc_info=e)
            logger.error(
              f"\\\\ FAILURE running submission submission_id={submission_id},tests={tests}, submission_data_url={submission_data_url}.\nStatus: {pretty_dumps_dict(submission_error.status)}.\nLog: {log}",
              exc_info=submission_error)
          except Exception as logging_error:
            logger.error(f"Could not log status {str(submission_error.status)}", exc_info=logging_error)
          self._post_submission_status_failed_with_specific_failure(fab, submission_data_url, submission_error, submission_id)
        else:
          self._post_submission_status_failed_with_general_failure(fab, submission_data_url, submission_id)
      finally:
        raise submission_error

  def _post_submission_status_failed_with_specific_failure(self, fab: DefaultApi | None, submission_data_url: str, submission_error: TaskExecutionError,
                                                           submission_id: str):
    try:
      _fab = self._backend_application_flow(fab)
      _fab.submissions_submission_ids_statuses_post([submission_id],
                                                    SubmissionsSubmissionIdsStatusesPostRequest(status=Status.failure.value,
                                                                                                message=str(submission_error.message)))
    except Exception as status_post_failure:
      logger.warning(f"Could not post specific FAILURE for submission_id={submission_id} with submission_data_url={submission_data_url} ",
                     exc_info=status_post_failure)
      self._post_submission_status_failed_with_general_failure(_fab, submission_data_url, submission_id)

  def _post_submission_status_started(self, fab: DefaultApi | None, submission_data_url: str, submission_id: str) -> DefaultApi:
    try:
      _fab = self._backend_application_flow(fab)
      _fab.submissions_submission_ids_statuses_post([submission_id], SubmissionsSubmissionIdsStatusesPostRequest(status=Status.started.value))
    except Exception as status_post_failure:
      logger.warning(f"Could not post STARTED for submission_id={submission_id} with submission_data_url={submission_data_url} ",
                     exc_info=status_post_failure)
    return _fab

  def _post_submission_status_failed_with_general_failure(self, fab: DefaultApi, submission_data_url: str, submission_id: str):
    try:
      _fab = self._backend_application_flow(fab)
      _fab.submissions_submission_ids_statuses_post([submission_id],
                                                    SubmissionsSubmissionIdsStatusesPostRequest(status=Status.failure.value,
                                                                                                message="General failure."))
    except Exception as status_post_failure:
      logger.warning(f"Could not post general FAILURE for submission_id={submission_id} with submission_data_url={submission_data_url} ",
                     exc_info=status_post_failure)

  def _upload_results_for_submission(self, fab: DefaultApi | None, results: dict, submission_id: str) -> DefaultApi:
    try:
      _fab = self._backend_application_flow(fab)
      for test_id, scenarios in results.items():
        for scenario_id, result in scenarios.items():
          logger.info(
            f"uploading results for submission_id={submission_id},test_id={test_id},scenario_id={scenario_id},env_path={self.load_scenario_data(scenario_id)}: {result}")
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
    except BaseException as e:
      logger.error(f"Failed uploading results for with exception {str(e)}. Stacktrace: {traceback.format_exception(e)}", exc_info=e)
      raise TaskExecutionError(f"Failed uploading results for with exception.", results)

  def _backend_application_flow(self, fab: DefaultApi | None) -> DefaultApi:
    if fab is None:
      token = backend_application_flow(self.client_id, self.client_secret, self.token_url)
      fab = DefaultApi(ApiClient(configuration=Configuration(host=self.fab_api_url, access_token=token["access_token"])))
    return fab

  @abstractmethod
  def _run_submission_scenario_container(self,
                                         test_id,
                                         scenario_id,
                                         submission_data_url,
                                         pkl_path,
                                         **kwargs) -> Tuple[dict, Optional[str]]:
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

  def run_submission(self, submission_id: str, submission_data_url: str, tests: Optional[List[str]], fab: DefaultApi, **kwargs) -> Tuple[dict, Optional[str]]:
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
    results
    """
    if tests is None:
      # TODO fallback to all tests - needs splitting of the orchestrator or enhanced configuration, one per benchmark
      raise TaskExecutionError("Failed running submission_id={submission_id},tests={tests} as not tests passed.", )

    logger.info(f"// START running submission submission_id={submission_id},tests={tests}")
    results = {test_id: {} for test_id in tests}
    summed_scenario_running_time = 0
    termination_cause = None
    for test_id in tests:
      test_results, success_rate_of_test, summed_scenario_running_time, termination_cause = self._run_submission_test(fab, submission_data_url, submission_id,
                                                                                                                      summed_scenario_running_time,
                                                                                                                      test_id, **kwargs)
      if termination_cause is not None:
        break
      results[test_id] = test_results
      mean_success_rate_of_test = 0
      if len(test_results) > 0:
        mean_success_rate_of_test = (sum(success_rate_of_test) / len(success_rate_of_test))
      if self.percentage_complete_threshold is not None and mean_success_rate_of_test < self.percentage_complete_threshold:
        termination_cause = f"The mean percentage of done agents during the last test {test_id} ({len(self.TEST_TO_SCENARIO_IDS[test_id])} environments) was too low: {mean_success_rate_of_test} < {self.percentage_complete_threshold}"
        logger.warning(
          f"\\\\ END running submission submission_id={submission_id},test_id={test_id}. Termination cause: {termination_cause}. {results[test_id]}")
        break
    logger.warning(
      f"\\\\ END running submission submission_id={submission_id},tests={tests}. Termination cause: {termination_cause}.")
    logger.info(f"// START uploading results for submission_id={submission_id} with submission_data_url={submission_data_url}.")
    _fab = self._backend_application_flow(fab)
    self._upload_results_for_submission(fab, results=results, submission_id=submission_id)
    logger.info(
      f"\\\\ END uploading results for with submission_id={submission_id} with submission_data_url={submission_data_url}.")
    try:
      _fab = self._backend_application_flow(fab)
      _fab.submissions_submission_ids_statuses_post([submission_id],
                                                    SubmissionsSubmissionIdsStatusesPostRequest(status=Status.success.value, message=str(
                                                      termination_cause) if termination_cause is not None else None))
    except Exception as status_post_failure:
      logger.warning(f"Could not post SUCCESS for submission_id={submission_id} with submission_data_url={submission_data_url} ", exc_info=status_post_failure)
    logger.info(
      f"\\\\ END running submission submission_id={submission_id}")
    return results, termination_cause

  def _run_submission_test(self, fab: DefaultApi, submission_data_url: str, submission_id: str,
                           summed_scenario_running_time: int, test_id: str, **kwargs) -> Tuple[dict, List[float], float, Optional[str]]:
    """
    Run submission for single test
    Parameters
    ----------
    fab
    submission_data_url
    submission_id
    summed_scenario_running_time
    test_id
    kwargs
      passed on to `_run_submission_container_for_scenario`

    Returns
    -------
    test_results, mean_success_rate_of_test, termination_cause: Tuple[dict,List[float],float, Optional[str]]
    """
    success_rate_of_test = []
    test_results = {}
    termination_cause = None
    first_test = summed_scenario_running_time == 0
    for i, scenario_id in enumerate(self.TEST_TO_SCENARIO_IDS[test_id]):
      self._post_started(fab, scenario_id, submission_data_url, submission_id, test_id, f"Run submission env_path={self.load_scenario_data(scenario_id)} ")

      pkl_path = self.load_scenario_data(scenario_id)
      ret, termination_cause = self._run_submission_scenario_container(test_id, scenario_id, submission_data_url, pkl_path, **kwargs)
      if termination_cause is not None:
        logger.warning(
          f"\\\\ END running submission submission_id={submission_id},test_id={test_id},scenario_id={scenario_id},env_path={self.load_scenario_data(scenario_id)}. {termination_cause}")
        break
      scenario_running_time = ret["running_time"]
      summed_scenario_running_time += scenario_running_time
      logger.info(
        f"\\\\ END running submission submission_id={submission_id},test_id={test_id},scenario_id={scenario_id},env_path={self.load_scenario_data(scenario_id)}. Took: {scenario_running_time}")

      if self.running_time_limit is not None and scenario_running_time > self.running_time_limit:
        termination_cause = f"The scenario running time was exceeded during evaluation of test_id={test_id}, scenario_id={scenario_id}: {scenario_running_time:.2f}s > {self.running_time_limit:.2f}s."
        logger.warning(
          f"\\\\ END running submission submission_id={submission_id},test_id={test_id},scenario_id={scenario_id},env_path={self.load_scenario_data(scenario_id)}. {termination_cause}")
        break
      if self.total_running_time_limit is not None and summed_scenario_running_time > self.total_running_time_limit:
        termination_cause = f"Running time {summed_scenario_running_time:.2f}s exceeded total running time limit {self.total_running_time_limit:.2f}s during evaluation of test_id={test_id}, scenario_id={scenario_id}."
        logger.warning(
          f"\\\\ END running submission submission_id={submission_id},test_id={test_id},scenario_id={scenario_id},env_path={self.load_scenario_data(scenario_id)}. {termination_cause}")
        break

      self._post_started(fab, scenario_id, submission_data_url, submission_id, test_id, f"Run evaluation env_path={self.load_scenario_data(scenario_id)} ")
      logger.info(
        f"// START evaluating submission submission_id={submission_id},test_id={test_id},scenario_id={scenario_id},env_path={self.load_scenario_data(scenario_id)}")
      prefix = f"{S3_UPLOAD_ROOT}{submission_id}/{test_id}/{scenario_id}"
      evaluation_start_time = time.time()
      scenario_results, success_rate, flatland_version = self._evaluate_scenario_results_on_s3_locally(prefix, scenario_id, submission_id, test_id)
      success_rate_of_test.append(success_rate)
      logger.info(
        f"\\\\ END evaluating submission submission_id={submission_id},test_id={test_id},scenario_id={scenario_id},env_path={self.load_scenario_data(scenario_id)}. Took {time.time() - evaluation_start_time:.2f}s.")
      test_results[scenario_id] = scenario_results
      if first_test and i == 0:
        self._post_started(fab, scenario_id, submission_data_url, submission_id, test_id, f"Found Flatland version={flatland_version}. ")

    return test_results, success_rate_of_test, summed_scenario_running_time, termination_cause

  def _post_started(self, fab: DefaultApi, scenario_id, submission_data_url: str, submission_id: str, test_id: str, prefix=""):
    try:
      _fab = self._backend_application_flow(fab)
      _fab.submissions_submission_ids_statuses_post([submission_id],
                                                    SubmissionsSubmissionIdsStatusesPostRequest(status=Status.started.value,
                                                                                                message=f"{prefix}test {test_id} - scenario {scenario_id}"))
    except Exception as status_post_failure:
      logger.warning(
        f"Could not post STARTED for submission_id={submission_id} with submission_data_url={submission_data_url} for test_id={test_id}, scenario_id={scenario_id}",
        exc_info=status_post_failure)

  def _evaluate_scenario_results_on_s3_locally(self, prefix: str, scenario_id, submission_id: str, test_id: str) -> tuple[Any, dict[str, float | Any]]:
    """
    Download trajectory from S3 and evaluate locally. Results are taken from the controlled local evaluation.

    Parameters
    ----------
    prefix
    scenario_id
    submission_id
    test_id

    Returns
    -------

    """
    with tempfile.TemporaryDirectory() as tmpdirname:
      logger.info(f"download_dir(prefix={prefix}, bucket={self.s3_bucket}, client={self.s3}, local={tmpdirname})")
      download_dir(prefix=prefix, bucket=self.s3_bucket, client=self.s3, local=tmpdirname)
      logger.info(list(Path(tmpdirname).rglob("**/*")))

      local_scenario_path = Path(tmpdirname) / S3_UPLOAD_ROOT / submission_id / test_id / scenario_id

      normalized_reward, success_rate = self._extract_stats_from_trajectory(local_scenario_path, scenario_id)
      scenario_results = {
        "normalized_reward": normalized_reward,
        "percentage_complete": success_rate
      }
      p = local_scenario_path / "print-flatland-version.log"
      flatland_version = None
      try:
        with p.open("r") as f:
          flatland_version = f.read()
          logger.info(f"Detected Flatland version {flatland_version}")
      except Exception as e:
        logger.warning(f"Could not read {p}.", exc_info=e)
    return scenario_results, success_rate, flatland_version

  def _extract_stats_from_trajectory(self, data_dir, scenario_id):
    rewards = None
    if self.additional_submission_args is not None:

      argv = self.additional_submission_args.split(" ")
      if "--rewards" in argv:
        rewards = resolve_type(argv[argv.index("--rewards") + 1])()

    normalized_reward, success_rate = self._extract_stats_from_trajectory_(data_dir, rewards, scenario_id)
    return normalized_reward, success_rate

  @staticmethod
  def _extract_stats_from_trajectory_(data_dir: Path, rewards: Rewards, scenario_id: str) -> Tuple[float, float]:
    trajectory = Trajectory.load_existing(data_dir=data_dir, ep_id=scenario_id)
    TrajectoryEvaluator(trajectory).evaluate(tqdm_kwargs={"disable": True}, rewards=rewards)
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
    normalized_reward = rail_env.rewards.normalize(*agent_scores, num_agents=num_agents, max_episode_steps=rail_env._max_episode_steps)
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


# https://stackoverflow.com/questions/36588126/uuid-is-not-json-serializable
class DictEncoder(json.JSONEncoder):
  def default(self, obj):
    if isinstance(obj, uuid.UUID):
      # if the obj is uuid, we simply return the value of uuid
      return obj.hex
    if isinstance(obj, (datetime, date)):
      return obj.isoformat()
    return json.JSONEncoder.default(self, obj)


def pretty_print_dict(d):
  print(json.dumps(d, indent=4, cls=DictEncoder))
  if d is not None and "log" in d:
    print(pretty_dumps_log(d["log"]))


def pretty_dumps_log(log: str):
  return "\n".join(log.split("\\n"))


def pretty_dumps_dict(d):
  return json.dumps(d, indent=4, cls=DictEncoder)
