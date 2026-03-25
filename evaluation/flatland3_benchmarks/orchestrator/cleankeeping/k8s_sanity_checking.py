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

_ENV_PATH = Path(__file__).resolve().parent / ".env"
_ENV_VARS = dotenv_values(_ENV_PATH)


def _require_config(name: str) -> str:
  """Return a required configuration value from environment or .env, with a clear error if missing."""
  value = os.getenv(name) or _ENV_VARS.get(name)
  if value is None:
    raise RuntimeError(
      f"Required configuration value '{name}' is not set. Please define it as an environment "
      f"variable or add it to `{_ENV_PATH}`."
    )
  return value


AWS_ENDPOINT_URL = _require_config("AWS_ENDPOINT_URL")
AWS_ACCESS_KEY_ID = _require_config("AWS_ACCESS_KEY_ID")
AWS_SECRET_ACCESS_KEY = _require_config("AWS_SECRET_ACCESS_KEY")
S3_BUCKET = _require_config("S3_BUCKET")
SUBMISSIONS_PVC = _require_config("SUBMISSIONS_PVC")
S3_URL_ENVIRONMENTS_ZIP = _require_config("S3_URL_ENVIRONMENTS_ZIP")
KUBERNETES_NAMESPACE = _require_config("KUBERNETES_NAMESPACE")
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
    submissions_pvc=SUBMISSIONS_PVC,
    active_deadline_seconds=55,
    k8s_resource_allocation='{"requests": {"memory": "1Gi", "cpu": "1"}, "limits": {"memory": "2Gi", "cpu": "2"}}',
  )

  orchestrator._make_command = lambda *args, **kwargs: ["bash", "-c"]
  orchestrator._make_args = lambda *args, **kwargs: ["""
      swapoff -a
      # 2Gi
      head -c $((2 * 1024**3)) /dev/zero | tail > /dev/null
      """]

  with pytest.raises(TaskExecutionError) as exc_info:
    start_time = time.time()
    ret = orchestrator._run_submission(
      test_id,
      scenario_id,
      submission_data_url,
      pkl_path
    )
    print(ret)
  end_time = time.time()
  elapsed_time = end_time - start_time
  print(exc_info.value.message)
  assert "OOM" in exc_info.value.message
  # may fail the image needs to be pulled.
  assert elapsed_time < 30


def test_no_oom_respecting_memory_limit(submission_data_url="ghcr.io/flatland-association/flatland-baselines-random:latest",
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
    submissions_pvc=SUBMISSIONS_PVC,
    active_deadline_seconds=55,
    k8s_resource_allocation='{"requests": {"memory": "1Gi", "cpu": "1"}, "limits": {"memory": "2Gi", "cpu": "2"}}',
  )

  orchestrator._make_command = lambda *args, **kwargs: ["bash", "-c"]
  orchestrator._make_args = lambda *args, **kwargs: ["""
      swapoff -a
      # 2Gi - 50 Mi
      head -c $((2 * 1024**3 - 50 * 1024**2)) /dev/zero | tail > /dev/null
      """]

  start_time = time.time()
  orchestrator._run_submission(
    test_id,
    scenario_id,
    submission_data_url,
    pkl_path
  )
  end_time = time.time()
  elapsed_time = end_time - start_time

  # may fail the image needs to be pulled.
  assert elapsed_time < 30


def test_pull_failure_fail_fast(submission_data_url="ghcr.io/flatland-association/does-not-exist:latest",
                                test_id="fc8f5fb1-4525-4b4f-a022-d3d7800097dc",
                                scenario_id="289394a5-aa51-446c-9b62-c25101643790",
                                pkl_path="Test_00/Level_0.pkl",
                                active_deadline_seconds=55,
                                delta=5,
                                ):
  """
  Verify failure upon exceeding memory usage.
  """
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
    submissions_pvc=SUBMISSIONS_PVC,
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
                                                  running_time_limit=25
                                                  ):
  """
  Verify failure upon exceeding running time.
  """

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
    submissions_pvc=SUBMISSIONS_PVC,
    active_deadline_seconds=active_deadline_seconds,
    running_time_limit=running_time_limit,
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
  assert f"exceeded running time limit {running_time_limit}s" in exc_info.value.message

  assert running_time_limit + delta > elapsed_time > running_time_limit


def test_time_max_running_time_respected_succeeds(submission_data_url="ghcr.io/flatland-association/flatland-baselines-random:latest",
                                                  test_id="fc8f5fb1-4525-4b4f-a022-d3d7800097dc",
                                                  scenario_id="289394a5-aa51-446c-9b62-c25101643790",
                                                  pkl_path="Test_00/Level_0.pkl",
                                                  active_deadline_seconds=55,
                                                  # allow for some overhead (starting the pod)
                                                  upper_delta=10,
                                                  # allow for some overhead (running)
                                                  lower_delta=3,
                                                  running_time_limit=25
                                                  ):
  """
  Verify allocated time can be used effectively.
  """
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
    submissions_pvc=SUBMISSIONS_PVC,
    active_deadline_seconds=active_deadline_seconds,
    running_time_limit=running_time_limit,
  )
  orchestrator._make_command = lambda *args, **kwargs: ["bash", "-c"]

  orchestrator._make_args = lambda *args, **kwargs: [f""" sleep {running_time_limit - lower_delta} """]
  start_time = time.time()
  orchestrator._run_submission(
    test_id,
    scenario_id,
    submission_data_url,
    pkl_path
  )
  end_time = time.time()
  elapsed_time = end_time - start_time

  # may fail the image needs to be pulled.
  print(
    f"assert {elapsed_time}s in [{running_time_limit - lower_delta:.2f},{running_time_limit - lower_delta:.2f}] {running_time_limit:.2f}+{upper_delta:.2f}-{lower_delta:.2f}")
  assert running_time_limit + upper_delta > elapsed_time > running_time_limit - lower_delta


def test_time_max_memory_respected_succeeds(submission_data_url="ghcr.io/flatland-association/flatland-baselines-random:latest",
                                            test_id="fc8f5fb1-4525-4b4f-a022-d3d7800097dc",
                                            scenario_id="289394a5-aa51-446c-9b62-c25101643790",
                                            pkl_path="Test_00/Level_0.pkl",
                                            active_deadline_seconds=55,
                                            # allow for some overhead (starting the pod)
                                            upper_delta=10,
                                            # allow for some overhead (running)
                                            lower_delta=3,
                                            running_time_limit=25
                                            ):
  """
  Verify allocated memory can be used effectively.
  """
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
    submissions_pvc=SUBMISSIONS_PVC,
    active_deadline_seconds=active_deadline_seconds,
    running_time_limit=running_time_limit,
  )
  orchestrator._make_command = lambda *args, **kwargs: ["bash", "-c"]

  orchestrator._make_args = lambda *args, **kwargs: [f""" sleep {running_time_limit - lower_delta} """]
  start_time = time.time()
  orchestrator._run_submission(
    test_id,
    scenario_id,
    submission_data_url,
    pkl_path
  )
  end_time = time.time()
  elapsed_time = end_time - start_time

  # may fail the image needs to be pulled.
  print(
    f"assert {elapsed_time}s in [{running_time_limit - lower_delta:.2f},{running_time_limit - lower_delta:.2f}] {running_time_limit:.2f}+{upper_delta:.2f}-{lower_delta:.2f}")
  assert running_time_limit + upper_delta > elapsed_time > running_time_limit - lower_delta
