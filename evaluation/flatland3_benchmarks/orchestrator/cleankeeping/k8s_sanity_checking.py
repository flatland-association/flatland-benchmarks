"""
Manual tests to verify k8s setup.
Takes credentials from env vars or .env file in the same folder as this script.
"""
import logging
import os
import time
import uuid
from pathlib import Path

import pytest
from dotenv import dotenv_values
from kubernetes import client
from kubernetes import config

from orchestrator import K8sFlatlandBenchmarksOrchestrator
from orchestrator_common import TaskExecutionError

AWS_ENDPOINT_URL = os.getenv(" AWS_ENDPOINT_URL", None) or dotenv_values(Path(__file__).resolve().parent / ".env")["AWS_ENDPOINT_URL"]
AWS_ACCESS_KEY_ID = os.getenv("AWS_ACCESS_KEY_ID", None) or dotenv_values(Path(__file__).resolve().parent / ".env")["AWS_ACCESS_KEY_ID"]
AWS_SECRET_ACCESS_KEY = os.getenv("AWS_SECRET_ACCESS_KEY", None) or dotenv_values(Path(__file__).resolve().parent / ".env")["AWS_SECRET_ACCESS_KEY"]
S3_BUCKET = os.getenv("S3_BUCKET", None) or dotenv_values(Path(__file__).resolve().parent / ".env")["S3_BUCKET"]
S3_URL_ENVIRONMENTS_ZIP = os.getenv("S3_URL_ENVIRONMENTS_ZIP", None) or dotenv_values(Path(__file__).resolve().parent / ".env")["S3_URL_ENVIRONMENTS_ZIP"]
KUBERNETES_NAMESPACE = os.getenv("KUBERNETES_NAMESPACE", None) or dotenv_values(Path(__file__).resolve().parent / ".env")["KUBERNETES_NAMESPACE"]
logging.basicConfig(encoding='utf-8', level=logging.INFO)


def test_oom_fail_fast(submission_data_url="ghcr.io/flatland-association/flatland-baselines-random:latest",
                       test_id="fc8f5fb1-4525-4b4f-a022-d3d7800097dc",
                       scenario_id="289394a5-aa51-446c-9b62-c25101643790",
                       pkl_path="Test_00/Level_0.pkl",
                       ):
  config.load_kube_config()
  core_api = client.CoreV1Api()
  batch_api = client.BatchV1Api()
  submission_id = str(uuid.uuid4())

  orchestrator = K8sFlatlandBenchmarksOrchestrator(
    submission_id=submission_id,
    batch_api=batch_api,
    core_api=core_api,
    kubernetes_namespace=KUBERNETES_NAMESPACE,
    aws_access_key_id=AWS_ACCESS_KEY_ID,
    aws_endpoint_url=AWS_ENDPOINT_URL,
    aws_secret_access_key=AWS_SECRET_ACCESS_KEY,
    s3_bucket=S3_BUCKET,
    s3_url_environments_zip=S3_URL_ENVIRONMENTS_ZIP,
    submissions_pvc=S3_BUCKET,
    active_deadline_seconds=55,
  )

  orchestrator._make_command = lambda *args, **kwargs: ["bash", "-c"]
  orchestrator._make_args = lambda *args, **kwargs: ["""
  pip install numpy
  python -c 'import numpy as np; print(np.ones((10000000000,)))'
      """]

  with pytest.raises(TaskExecutionError) as exc_info:
    start_time = time.time()
    orchestrator._run_submission(
      test_id,
      scenario_id,
      submission_data_url,
      pkl_path
    )
  end_time = time.time()
  elapsed_time = end_time - start_time
  print(exc_info.value.message)
  assert "OOM" in exc_info.value.message
  # may fail the image needs to be pulled.
  assert elapsed_time < 30


def test_pull_failure_fail_fast(submission_data_url="ghcr.io/flatland-association/does-not-exist:latest",
                                test_id="fc8f5fb1-4525-4b4f-a022-d3d7800097dc",
                                scenario_id="289394a5-aa51-446c-9b62-c25101643790",
                                pkl_path="Test_00/Level_0.pkl",
                                active_deadline_seconds=55,
                                delta=5,
                                ):
  config.load_kube_config()
  core_api = client.CoreV1Api()
  batch_api = client.BatchV1Api()
  submission_id = str(uuid.uuid4())

  orchestrator = K8sFlatlandBenchmarksOrchestrator(
    submission_id=submission_id,
    batch_api=batch_api,
    core_api=core_api,
    kubernetes_namespace=KUBERNETES_NAMESPACE,
    aws_access_key_id=AWS_ACCESS_KEY_ID,
    aws_endpoint_url=AWS_ENDPOINT_URL,
    aws_secret_access_key=AWS_SECRET_ACCESS_KEY,
    s3_bucket=S3_BUCKET,
    s3_url_environments_zip=S3_URL_ENVIRONMENTS_ZIP,
    submissions_pvc=S3_BUCKET,
    active_deadline_seconds=active_deadline_seconds,
  )
  with pytest.raises(TaskExecutionError) as exc_info:
    start_time = time.time()
    orchestrator._run_submission(
      test_id,
      scenario_id,
      submission_data_url,
      pkl_path
    )
  end_time = time.time()
  elapsed_time = end_time - start_time
  print(exc_info.value.message)
  assert "Job has reached the specified backoff limit" in exc_info.value.message
  assert 'failed to pull and unpack image "ghcr.io/flatland-association/does-not-exist:latest"' in exc_info.value.message
  assert 'failed to resolve reference "ghcr.io/flatland-association/does-not-exist:latest"' in exc_info.value.message

  assert active_deadline_seconds + delta > elapsed_time > active_deadline_seconds


def test_time_max_running_time_exceeded_fail_fast(submission_data_url="ghcr.io/flatland-association/flatland-baselines-random:latest",
                                                  test_id="fc8f5fb1-4525-4b4f-a022-d3d7800097dc",
                                                  scenario_id="289394a5-aa51-446c-9b62-c25101643790",
                                                  pkl_path="Test_00/Level_0.pkl",
                                                  active_deadline_seconds=55,
                                                  delta=10,
                                                  max_running_time=25
                                                  ):
  config.load_kube_config()
  core_api = client.CoreV1Api()
  batch_api = client.BatchV1Api()
  submission_id = str(uuid.uuid4())

  orchestrator = K8sFlatlandBenchmarksOrchestrator(
    submission_id=submission_id,
    batch_api=batch_api,
    core_api=core_api,
    kubernetes_namespace=KUBERNETES_NAMESPACE,
    aws_access_key_id=AWS_ACCESS_KEY_ID,
    aws_endpoint_url=AWS_ENDPOINT_URL,
    aws_secret_access_key=AWS_SECRET_ACCESS_KEY,
    s3_bucket=S3_BUCKET,
    s3_url_environments_zip=S3_URL_ENVIRONMENTS_ZIP,
    submissions_pvc=S3_BUCKET,
    active_deadline_seconds=active_deadline_seconds,
    max_running_time=max_running_time,
  )
  orchestrator._make_command = lambda *args, **kwargs: ["bash", "-c"]
  orchestrator._make_args = lambda *args, **kwargs: [""" sleep 55 """]
  with pytest.raises(TaskExecutionError) as exc_info:
    start_time = time.time()
    orchestrator._run_submission(
      test_id,
      scenario_id,
      submission_data_url,
      pkl_path
    )
  end_time = time.time()
  elapsed_time = end_time - start_time
  print(exc_info.value.message)
  assert f"exceeded max running time {max_running_time}s" in exc_info.value.message

  assert max_running_time + delta > elapsed_time > max_running_time
