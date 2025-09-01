# based on https://github.com/codalab/codabench/blob/develop/orchestrator/orchestrator.py
import json
import logging
import os
import time
from abc import abstractmethod
from io import StringIO
from typing import Dict
from typing import List

import boto3
import celery.exceptions
import numpy as np
import pandas as pd

from fab_clientlib import DefaultApi, ApiClient, Configuration, ResultsSubmissionsSubmissionIdTestsTestIdsPostRequest, \
  ResultsSubmissionsSubmissionIdTestsTestIdsPostRequestDataInner
from fab_oauth_utils import backend_application_flow

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
                   test_runner_evaluator_image="ghcr.io/flatland-association/fab-flatland3-benchmarks-evaluator:latest",
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
      ret = self.run_flatland(test_runner_evaluator_image, submission_id, submission_data_url, tests, aws_endpoint_url, aws_access_key_id,
                              aws_secret_access_key, s3_bucket, s3_upload_path_template, s3_upload_path_template_use_submission_id, **kwargs)

      duration = time.time() - start_time
      logger.info(
        f"\\ end task with submission_id={submission_id} with docker_image={test_runner_evaluator_image} and submission_data_url={submission_data_url}. Took {duration:.2f} seconds.")

      logger.info("Get results files from S3 under %s...", aws_endpoint_url)
      if s3 is None:
        s3 = boto3.client(
          's3',
          # https://docs.weka.io/additional-protocols/s3/s3-examples-using-boto3
          endpoint_url=aws_endpoint_url,
          aws_access_key_id=aws_access_key_id,
          aws_secret_access_key=aws_secret_access_key
        )
      obj = s3.get_object(Bucket=s3_bucket, Key=s3_upload_path_template.format(submission_id) + ".csv")
      ret["f3-evaluator"]["results.csv"] = obj['Body'].read().decode("utf-8")
      obj = s3.get_object(Bucket=s3_bucket, Key=s3_upload_path_template.format(submission_id) + ".json")
      ret["f3-evaluator"]["results.json"] = obj['Body'].read().decode("utf-8")

      print("results.csv")
      df_results = pd.read_csv(StringIO(ret["f3-evaluator"]["results.csv"]))
      print(df_results)
      print("results.json")
      json_results = json.loads(ret["f3-evaluator"]["results.json"])
      print(json_results)

      if fab is None:
        token = backend_application_flow(CLIENT_ID, CLIENT_SECRET, TOKEN_URL)
        print("token")
        print(token)
        fab = DefaultApi(ApiClient(configuration=Configuration(host=FAB_API_URL, access_token=token["access_token"])))

      for _, row in df_results.iterrows():
        print("uploading results for row:")
        print(row)
        if np.isnan(row["normalized_reward"]):
          print("skipping")
          continue
        fab.results_submissions_submission_id_tests_test_ids_post(
          submission_id=submission_id,
          test_ids=[row["fab_test_id"]],
          results_submissions_submission_id_tests_test_ids_post_request=ResultsSubmissionsSubmissionIdTestsTestIdsPostRequest(
            data=[
              ResultsSubmissionsSubmissionIdTestsTestIdsPostRequestDataInner(
                scenario_id=row["fab_scenario_id"],
                additional_properties={
                  "normalized_reward": row["normalized_reward"],
                  "percentage_complete": row["percentage_complete"]
                },
              )
            ]
          ),
        )
      return ret

    except celery.exceptions.SoftTimeLimitExceeded as e:
      logger.info("Hit %s - getting logs from containers", e)
    raise e

  @abstractmethod
  def run_flatland(self, test_runner_evaluator_image, submission_id, submission_data_url, tests, aws_endpoint_url, aws_access_key_id, aws_secret_access_key,
                   s3_bucket, s3_upload_path_template, s3_upload_path_template_use_submission_id, **kwargs):
    raise NotImplementedError()
