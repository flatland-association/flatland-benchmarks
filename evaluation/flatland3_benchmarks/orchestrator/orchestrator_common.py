# based on https://github.com/codalab/codabench/blob/develop/orchestrator/orchestrator.py
import logging
import os
import time
import traceback
from abc import abstractmethod
from typing import Dict
from typing import List

import celery.exceptions
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
                   s3_upload_path_template=None,
                   s3_upload_path_template_use_submission_id=None,
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
      if s3_upload_path_template is None:
        s3_upload_path_template = os.environ.get("S3_UPLOAD_PATH_TEMPLATE", None)
      if s3_upload_path_template_use_submission_id is None:
        s3_upload_path_template_use_submission_id = os.environ.get("S3_UPLOAD_PATH_TEMPLATE_USE_SUBMISSION_ID", None)
      ret = self.run_flatland(submission_id, submission_data_url, tests, aws_endpoint_url, aws_access_key_id, aws_secret_access_key, s3_bucket,
                              s3_upload_path_template, s3_upload_path_template_use_submission_id, **kwargs)

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
      logger.error("Hit %s - get results from S3 and uploading to FAB", e)
      raise Exception(f"Hit {e} - get results from S3 and uploading to FAB: {traceback.format_exception(e)}") from e

  @abstractmethod
  def run_flatland(self, submission_id, submission_data_url, tests, aws_endpoint_url, aws_access_key_id, aws_secret_access_key, s3_bucket,
                   s3_upload_path_template, s3_upload_path_template_use_submission_id, **kwargs):
    raise NotImplementedError()


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
