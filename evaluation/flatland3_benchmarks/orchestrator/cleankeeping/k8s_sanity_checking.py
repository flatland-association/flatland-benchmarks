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
from mockito.mocking import mock

from orchestrator import K8sFlatlandBenchmarksOrchestrator
from orchestrator_common import TaskExecutionError, pretty_print_dict

_ENV_PATH = Path(__file__).resolve().parent / ".env"
_ENV_VARS = dotenv_values(_ENV_PATH)

# ecml2026
TEST_ID = '39ae35d8-4b0f-467f-9ec4-ee19c3558c7f'
SCENARIO_ID = "ee155de0-14f1-4bd7-8cc6-9100276758fa"
PKL_PATH = "level_0/level_0_scenario_1.pkl"


# # flatland3_benchmarks
# TEST_ID = "fc8f5fb1-4525-4b4f-a022-d3d7800097dc"
# SCENARIO_ID = "289394a5-aa51-446c-9b62-c25101643790"
# PKL_PATH = "Test_00/Level_0.pkl"


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
ENVIRONMENTS_PVC = _require_config("ENVIRONMENTS_PVC")
ENVIRONMENTS_ZIP = _require_config("ENVIRONMENTS_ZIP")
KUBERNETES_NAMESPACE = _require_config("KUBERNETES_NAMESPACE")
logging.basicConfig(encoding='utf-8', level=logging.INFO)


def test_success(
  # submission_data_url="ghcr.io/flatland-association/flatland-baselines-random:latest",
  submission_data_url="ghcr.io/flatland-association/flatland-baselines-forward-only-heuristic:latest",
  test_id=TEST_ID,
  scenario_id=SCENARIO_ID,
  pkl_path=PKL_PATH,
):
  config.load_kube_config()
  core_api = client.CoreV1Api()
  batch_api = client.BatchV1Api()
  submission_id = str(uuid.uuid4())
  print(submission_id)

  orchestrator = K8sFlatlandBenchmarksOrchestrator(
    submission_id=submission_id,
    batch_api=batch_api,
    core_api=core_api,
    kubernetes_namespace=KUBERNETES_NAMESPACE,
    aws_access_key_id=AWS_ACCESS_KEY_ID,
    aws_endpoint_url=AWS_ENDPOINT_URL,
    aws_secret_access_key=AWS_SECRET_ACCESS_KEY,
    s3_bucket=S3_BUCKET,
    environments_zip=ENVIRONMENTS_ZIP,
    environments_pvc=ENVIRONMENTS_PVC,
    submissions_pvc=SUBMISSIONS_PVC,
    active_deadline_seconds=55,
    k8s_resource_allocation='{"requests": {"memory": "1Gi", "cpu": "1"}, "limits": {"memory": "2Gi", "cpu": "2"}}',
  )

  start_time = time.time()
  ret, termination_cause = orchestrator._run_submission_scenario_container(
    test_id,
    scenario_id,
    submission_data_url,
    pkl_path
  )
  assert termination_cause is None
  end_time = time.time()
  elapsed_time = end_time - start_time

  pretty_print_dict(ret)
  assert elapsed_time < 500


def test_oom_fail_fast(submission_data_url="ghcr.io/flatland-association/flatland-baselines-random:latest",
                       test_id=TEST_ID,
                       scenario_id=SCENARIO_ID,
                       pkl_path=PKL_PATH,
                       ):
  config.load_kube_config()
  core_api = client.CoreV1Api()
  batch_api = client.BatchV1Api()
  submission_id = str(uuid.uuid4())
  print(submission_id)

  orchestrator = K8sFlatlandBenchmarksOrchestrator(
    submission_id=submission_id,
    batch_api=batch_api,
    core_api=core_api,
    kubernetes_namespace=KUBERNETES_NAMESPACE,
    aws_access_key_id=AWS_ACCESS_KEY_ID,
    aws_endpoint_url=AWS_ENDPOINT_URL,
    aws_secret_access_key=AWS_SECRET_ACCESS_KEY,
    s3_bucket=S3_BUCKET,
    environments_zip=ENVIRONMENTS_ZIP, environments_pvc=ENVIRONMENTS_PVC,
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
    ret = orchestrator._run_submission_scenario_container(
      test_id,
      scenario_id,
      submission_data_url,
      pkl_path
    )
    pretty_print_dict(ret)
  end_time = time.time()
  elapsed_time = end_time - start_time
  print(exc_info.value.message)
  assert exc_info.value.status["events"]["items"][-1]["reason"] == "PodOOMKilling"
  assert "OOM" in str(exc_info.value.status)

  assert exc_info.value.message.startswith(
    f"Failed task with submission_id={submission_id} with submission_data_url=ghcr.io/flatland-association/flatland-baselines-random:latest for test_id={test_id}, scenario_id={scenario_id}. Some tasks jobs failed: ['FailureTarget', 'Failed'].")
  assert "PodOOMKilling" in exc_info.value.message
  # may fail the image needs to be pulled.
  assert elapsed_time < 30


def test_no_oom_respecting_memory_limit(submission_data_url="ghcr.io/flatland-association/flatland-baselines-random:latest",
                                        test_id=TEST_ID,
                                        scenario_id=SCENARIO_ID,
                                        pkl_path=PKL_PATH,
                                        ):
  config.load_kube_config()
  core_api = client.CoreV1Api()
  batch_api = client.BatchV1Api()
  submission_id = str(uuid.uuid4())
  print(submission_id)

  orchestrator = K8sFlatlandBenchmarksOrchestrator(
    submission_id=submission_id,
    batch_api=batch_api,
    core_api=core_api,
    kubernetes_namespace=KUBERNETES_NAMESPACE,
    aws_access_key_id=AWS_ACCESS_KEY_ID,
    aws_endpoint_url=AWS_ENDPOINT_URL,
    aws_secret_access_key=AWS_SECRET_ACCESS_KEY,
    s3_bucket=S3_BUCKET,
    environments_zip=ENVIRONMENTS_ZIP, environments_pvc=ENVIRONMENTS_PVC,
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
  ret, termination_cause = orchestrator._run_submission_scenario_container(
    test_id,
    scenario_id,
    submission_data_url,
    pkl_path
  )
  end_time = time.time()
  elapsed_time = end_time - start_time
  pretty_print_dict(ret)

  assert termination_cause is None
  # may fail the image needs to be pulled.
  assert elapsed_time < 30


def test_pull_failure_active_deadline_fail_fast(submission_data_url="ghcr.io/flatland-association/does-not-exist:latest",
                                                test_id=TEST_ID,
                                                scenario_id=SCENARIO_ID,
                                                pkl_path=PKL_PATH,
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
  print(submission_id)

  orchestrator = K8sFlatlandBenchmarksOrchestrator(
    submission_id=submission_id,
    batch_api=batch_api,
    core_api=core_api,
    kubernetes_namespace=KUBERNETES_NAMESPACE,
    aws_access_key_id=AWS_ACCESS_KEY_ID,
    aws_endpoint_url=AWS_ENDPOINT_URL,
    aws_secret_access_key=AWS_SECRET_ACCESS_KEY,
    s3_bucket=S3_BUCKET,
    environments_zip=ENVIRONMENTS_ZIP, environments_pvc=ENVIRONMENTS_PVC,
    submissions_pvc=SUBMISSIONS_PVC,
    active_deadline_seconds=active_deadline_seconds,
  )
  with pytest.raises(TaskExecutionError) as exc_info:
    start_time = time.time()
    orchestrator._run_submission_scenario_container(
      test_id,
      scenario_id,
      submission_data_url,
      pkl_path
    )
  end_time = time.time()
  elapsed_time = end_time - start_time
  print(exc_info.value.message)
  assert "Job has reached the specified backoff limit" in str(exc_info.value.status)
  assert 'failed to pull and unpack image "ghcr.io/flatland-association/does-not-exist:latest"' in str(exc_info.value.status)
  assert 'failed to resolve reference "ghcr.io/flatland-association/does-not-exist:latest"' in str(exc_info.value.status)

  assert active_deadline_seconds + delta > elapsed_time > active_deadline_seconds


def test_pull_failure_start_time_fail_fast(submission_data_url="ghcr.io/flatland-association/does-not-exist:latest",
                                           test_id=TEST_ID,
                                           scenario_id=SCENARIO_ID,
                                           pkl_path=PKL_PATH,
                                           wait_for_pod_to_run_limit=20,
                                           delta=5,
                                           ):
  """
  Verify failure upon exceeding memory usage.
  """
  config.load_kube_config()
  core_api = client.CoreV1Api()
  batch_api = client.BatchV1Api()
  submission_id = str(uuid.uuid4())
  print(submission_id)

  orchestrator = K8sFlatlandBenchmarksOrchestrator(
    submission_id=submission_id,
    batch_api=batch_api,
    core_api=core_api,
    kubernetes_namespace=KUBERNETES_NAMESPACE,
    aws_access_key_id=AWS_ACCESS_KEY_ID,
    aws_endpoint_url=AWS_ENDPOINT_URL,
    aws_secret_access_key=AWS_SECRET_ACCESS_KEY,
    s3_bucket=S3_BUCKET,
    environments_zip=ENVIRONMENTS_ZIP, environments_pvc=ENVIRONMENTS_PVC,
    submissions_pvc=SUBMISSIONS_PVC,
    active_deadline_seconds=300,
    wait_for_pod_to_run_limit=wait_for_pod_to_run_limit
  )
  with pytest.raises(TaskExecutionError) as exc_info:
    start_time = time.time()
    orchestrator._run_submission_scenario_container(
      test_id,
      scenario_id,
      submission_data_url,
      pkl_path
    )
  end_time = time.time()
  elapsed_time = end_time - start_time
  print(exc_info.value.message)
  assert "exceeded start time limit 20s" in exc_info.value.message

  assert wait_for_pod_to_run_limit + delta > elapsed_time > wait_for_pod_to_run_limit


def test_max_running_time_exceeded_fail_fast(submission_data_url="ghcr.io/flatland-association/flatland-baselines-random:latest",
                                             test_id=TEST_ID,
                                             scenario_id=SCENARIO_ID,
                                             pkl_path=PKL_PATH,
                                             active_deadline_seconds=75,
                                             delta=10,
                                             running_time_limit=25,
                                             sleep=55
                                             ):
  """
  Verify failure upon exceeding running time.
  """

  config.load_kube_config()
  core_api = client.CoreV1Api()
  batch_api = client.BatchV1Api()
  submission_id = str(uuid.uuid4())
  print(submission_id)

  orchestrator = K8sFlatlandBenchmarksOrchestrator(
    submission_id=submission_id,
    batch_api=batch_api,
    core_api=core_api,
    kubernetes_namespace=KUBERNETES_NAMESPACE,
    aws_access_key_id=AWS_ACCESS_KEY_ID,
    aws_endpoint_url=AWS_ENDPOINT_URL,
    aws_secret_access_key=AWS_SECRET_ACCESS_KEY,
    s3_bucket=S3_BUCKET,
    environments_zip=ENVIRONMENTS_ZIP, environments_pvc=ENVIRONMENTS_PVC,
    submissions_pvc=SUBMISSIONS_PVC,
    active_deadline_seconds=active_deadline_seconds,
    running_time_limit=running_time_limit,
  )
  orchestrator._make_command = lambda *args, **kwargs: ["bash", "-c"]
  orchestrator._make_args = lambda *args, **kwargs: [f""" sleep {sleep} """]
  start_time = time.time()
  ret, termination_cause = orchestrator._run_submission_scenario_container(
    test_id,
    scenario_id,
    submission_data_url,
    pkl_path
  )
  end_time = time.time()
  elapsed_time = end_time - start_time
  assert termination_cause.startswith('Running time')
  assert f'exceeded running time limit {running_time_limit}.00s' in termination_cause
  assert sleep + delta > elapsed_time > running_time_limit


def test_max_total_running_time_exceeded_fail_fast(submission_data_url="ghcr.io/flatland-association/flatland-baselines-random:latest",
                                                   test_id=TEST_ID,
                                                   active_deadline_seconds=55,
                                                   delta=10,
                                                   total_running_time_limit=10,
                                                   running_time_limit=25,
                                                   ):
  """
  Verify failure upon exceeding total running time.
  """

  config.load_kube_config()
  core_api = client.CoreV1Api()
  batch_api = client.BatchV1Api()
  submission_id = str(uuid.uuid4())
  print(submission_id)

  orchestrator = K8sFlatlandBenchmarksOrchestrator(
    submission_id=submission_id,
    batch_api=batch_api,
    core_api=core_api,
    kubernetes_namespace=KUBERNETES_NAMESPACE,
    aws_access_key_id=AWS_ACCESS_KEY_ID,
    aws_endpoint_url=AWS_ENDPOINT_URL,
    aws_secret_access_key=AWS_SECRET_ACCESS_KEY,
    s3_bucket=S3_BUCKET,
    environments_zip=ENVIRONMENTS_ZIP, environments_pvc=ENVIRONMENTS_PVC,
    submissions_pvc=SUBMISSIONS_PVC,
    active_deadline_seconds=active_deadline_seconds,
    running_time_limit=running_time_limit,
    total_running_time_limit=total_running_time_limit,
  )

  orchestrator._extract_stats_from_trajectory = lambda *args, **kwargs: (0, 0)
  orchestrator._make_command = lambda *args, **kwargs: ["bash", "-c"]
  orchestrator._make_args = lambda *args, **kwargs: [""" sleep 20 """]

  start_time = time.time()
  ret, termination_cause = orchestrator.orchestrator(
    submission_data_url,
    [test_id],
    fab=mock()
  )
  end_time = time.time()
  elapsed_time = end_time - start_time
  pretty_print_dict(ret)

  assert termination_cause.startswith('Running time')
  assert f'exceeded total running time limit {total_running_time_limit}.00s' in termination_cause
  assert running_time_limit + delta > elapsed_time > running_time_limit


def test_max_running_time_respected_succeeds(submission_data_url="ghcr.io/flatland-association/flatland-baselines-random:latest",
                                             test_id=TEST_ID,
                                             scenario_id=SCENARIO_ID,
                                             pkl_path=PKL_PATH,
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
  print(submission_id)

  orchestrator = K8sFlatlandBenchmarksOrchestrator(
    submission_id=submission_id,
    batch_api=batch_api,
    core_api=core_api,
    kubernetes_namespace=KUBERNETES_NAMESPACE,
    aws_access_key_id=AWS_ACCESS_KEY_ID,
    aws_endpoint_url=AWS_ENDPOINT_URL,
    aws_secret_access_key=AWS_SECRET_ACCESS_KEY,
    s3_bucket=S3_BUCKET,
    environments_zip=ENVIRONMENTS_ZIP, environments_pvc=ENVIRONMENTS_PVC,
    submissions_pvc=SUBMISSIONS_PVC,
    active_deadline_seconds=active_deadline_seconds,
    running_time_limit=running_time_limit,
  )
  orchestrator._make_command = lambda *args, **kwargs: ["bash", "-c"]

  orchestrator._make_args = lambda *args, **kwargs: [f""" sleep {running_time_limit - lower_delta} """]
  start_time = time.time()
  orchestrator._run_submission_scenario_container(
    test_id,
    scenario_id,
    submission_data_url,
    pkl_path
  )
  end_time = time.time()
  elapsed_time = end_time - start_time

  # may fail the image needs to be pulled.
  print(
    f"assert {elapsed_time}s in [{running_time_limit - lower_delta:.2f},{running_time_limit + upper_delta:.2f}] {running_time_limit:.2f}+{upper_delta:.2f}-{lower_delta:.2f}")
  assert running_time_limit + upper_delta > elapsed_time > running_time_limit - lower_delta


def test_max_memory_respected_succeeds(submission_data_url="ghcr.io/flatland-association/flatland-baselines-random:latest",
                                       test_id=TEST_ID,
                                       scenario_id=SCENARIO_ID,
                                       pkl_path=PKL_PATH,
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
  print(submission_id)

  orchestrator = K8sFlatlandBenchmarksOrchestrator(
    submission_id=submission_id,
    batch_api=batch_api,
    core_api=core_api,
    kubernetes_namespace=KUBERNETES_NAMESPACE,
    aws_access_key_id=AWS_ACCESS_KEY_ID,
    aws_endpoint_url=AWS_ENDPOINT_URL,
    aws_secret_access_key=AWS_SECRET_ACCESS_KEY,
    s3_bucket=S3_BUCKET,
    environments_zip=ENVIRONMENTS_ZIP, environments_pvc=ENVIRONMENTS_PVC,
    submissions_pvc=SUBMISSIONS_PVC,
    active_deadline_seconds=active_deadline_seconds,
    running_time_limit=running_time_limit,
  )
  orchestrator._make_command = lambda *args, **kwargs: ["bash", "-c"]

  orchestrator._make_args = lambda *args, **kwargs: [f""" sleep {running_time_limit - lower_delta} """]
  start_time = time.time()
  orchestrator._run_submission_scenario_container(
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


def test_egress_fail_fast(submission_data_url="ghcr.io/flatland-association/flatland-baselines-random:latest",
                          test_id=TEST_ID,
                          scenario_id=SCENARIO_ID,
                          pkl_path=PKL_PATH,
                          ):
  config.load_kube_config()
  core_api = client.CoreV1Api()
  batch_api = client.BatchV1Api()
  submission_id = str(uuid.uuid4())
  print(submission_id)

  orchestrator = K8sFlatlandBenchmarksOrchestrator(
    submission_id=submission_id,
    batch_api=batch_api,
    core_api=core_api,
    kubernetes_namespace=KUBERNETES_NAMESPACE,
    aws_access_key_id=AWS_ACCESS_KEY_ID,
    aws_endpoint_url=AWS_ENDPOINT_URL,
    aws_secret_access_key=AWS_SECRET_ACCESS_KEY,
    s3_bucket=S3_BUCKET,
    environments_zip=ENVIRONMENTS_ZIP,
    environments_pvc=ENVIRONMENTS_PVC,
    submissions_pvc=SUBMISSIONS_PVC,
    active_deadline_seconds=55,
    k8s_resource_allocation='{"requests": {"memory": "1Gi", "cpu": "1"}, "limits": {"memory": "2Gi", "cpu": "2"}}',
  )

  orchestrator._make_command = lambda *args, **kwargs: ["bash", "-c"]
  orchestrator._make_args = lambda *args, **kwargs: ["""
      sleep 2
      wget https://google.com
      """]

  with pytest.raises(TaskExecutionError) as exc_info:
    start_time = time.time()
    ret = orchestrator._run_submission_scenario_container(
      test_id,
      scenario_id,
      submission_data_url,
      pkl_path
    )
    pretty_print_dict(ret)
  end_time = time.time()
  elapsed_time = end_time - start_time
  print(exc_info.value.message)
  assert "wget: unable to resolve host address ‘google.com’" in str(exc_info.value.status)
  # may fail the image needs to be pulled.
  assert elapsed_time < 30


def test_service_account_hardening(submission_data_url="ghcr.io/flatland-association/flatland-baselines-random:latest",
                                   test_id=TEST_ID,
                                   scenario_id=SCENARIO_ID,
                                   pkl_path=PKL_PATH,
                                   ):
  config.load_kube_config()
  core_api = client.CoreV1Api()
  batch_api = client.BatchV1Api()
  submission_id = str(uuid.uuid4())
  print(submission_id)

  orchestrator = K8sFlatlandBenchmarksOrchestrator(
    submission_id=submission_id,
    batch_api=batch_api,
    core_api=core_api,
    kubernetes_namespace=KUBERNETES_NAMESPACE,
    aws_access_key_id=AWS_ACCESS_KEY_ID,
    aws_endpoint_url=AWS_ENDPOINT_URL,
    aws_secret_access_key=AWS_SECRET_ACCESS_KEY,
    s3_bucket=S3_BUCKET,
    environments_zip=ENVIRONMENTS_ZIP,
    environments_pvc=ENVIRONMENTS_PVC,
    submissions_pvc=SUBMISSIONS_PVC,
    active_deadline_seconds=55,
    k8s_resource_allocation='{"requests": {"memory": "1Gi", "cpu": "1"}, "limits": {"memory": "2Gi", "cpu": "2"}}',
  )

  orchestrator._make_command = lambda *args, **kwargs: ["bash", "-c"]
  orchestrator._make_args = lambda *args, **kwargs: ["""
      set -euxo
      sleep 2
      wget -v -t 1 --timeout=5 https://${KUBERNETES_SERVICE_HOST}:${KUBERNETES_SERVICE_PORT}/apis/apps/v1 \
      --ca-certificate /var/run/secrets/kubernetes.io/serviceaccount/ca.crt \
      --header "Authorization: Bearer $(cat /var/run/secrets/kubernetes.io/serviceaccount/token)"
      """]

  with pytest.raises(TaskExecutionError) as exc_info:
    start_time = time.time()
    ret = orchestrator._run_submission_scenario_container(
      test_id,
      scenario_id,
      submission_data_url,
      pkl_path
    )
    pretty_print_dict(ret)
  end_time = time.time()
  elapsed_time = end_time - start_time
  print(exc_info.value.message)
  assert "Giving up." in str(exc_info.value.status)
  assert "Failed to open cert /var/run/secrets/kubernetes.io/serviceaccount/ca.crt: (-64)." in str(exc_info.value.status)
  # may fail the image needs to be pulled.
  assert elapsed_time < 30
