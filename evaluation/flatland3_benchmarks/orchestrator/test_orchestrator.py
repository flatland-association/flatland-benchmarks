import mockito
import pytest
from kubernetes.client import V1JobList, V1Job, V1JobStatus, V1JobCondition, V1ObjectMeta, BatchV1Api, CoreV1Api, V1PodList, V1Pod, V1PodStatus, V1PodCondition, \
  V1ContainerStatus
from mockito import mock
from mockito import verify
from mockito import when

from orchestrator import TaskExecutionError, K8sFlatlandBenchmarksOrchestrator


def test_tasks_successful():
  core_api: CoreV1Api = mock()
  batch_api: BatchV1Api = mock()

  job_subi = V1Job(status=V1JobStatus(conditions=[V1JobCondition(type="Complete", status="blup")]), metadata=V1ObjectMeta(name=f"f3-submission-1234"))
  when(batch_api).list_namespaced_job(namespace="fab-int", label_selector=f"submission_id=1234-66").thenReturn(
    V1JobList(items=[job_subi]))

  pod_subi = V1Pod(metadata=V1ObjectMeta(name="subi"),
                   status=V1PodStatus(conditions=[V1PodCondition(type="Complete", status=V1PodStatus())], container_statuses=[
                     V1ContainerStatus(name="any", ready="any", restart_count="any", image="any", image_id="ghcr.io/subi")]))
  when(core_api).list_namespaced_pod(namespace="fab-int", label_selector=f"job-name=f3-submission-1234").thenReturn(V1PodList(items=[
    pod_subi
  ]))
  when(core_api).read_namespaced_pod_log("subi", namespace="fab-int").thenReturn("abcd")

  ret = K8sFlatlandBenchmarksOrchestrator(submission_id="1234")._run_submission(
    test_id="55",
    scenario_id="66",
    submission_data_url="pancy",
    pkl_path="55/66",
    batch_api=batch_api, core_api=core_api
  )

  verify(batch_api, times=1).list_namespaced_job(...)
  verify(core_api, times=1).list_namespaced_pod(namespace="fab-int", label_selector=f"job-name=f3-submission-1234")
  verify(core_api, times=1).read_namespaced_pod_log("subi", namespace="fab-int")

  assert set(ret.keys()) == {"f3-sub"}
  assert set(ret["f3-sub"].keys()) == {"job_status", "image_id", "log", "job", "pod"}
  assert ret["f3-sub"]["job_status"] == "Complete"
  assert ret["f3-sub"]["image_id"] == "ghcr.io/subi"
  assert ret["f3-sub"]["log"] == "abcd"
  assert ret["f3-sub"]["pod"] == pod_subi.to_dict()
  assert ret["f3-sub"]["job"] == job_subi.to_dict()
  mockito.unstub()


def test_tasks_failing():
  core_api: CoreV1Api = mock()
  batch_api: BatchV1Api = mock()

  job_subi = V1Job(status=V1JobStatus(conditions=[V1JobCondition(type="Somethingelse", status="blup")]), metadata=V1ObjectMeta(name=f"f3-submission-1234"))
  when(batch_api).list_namespaced_job(namespace="fab-int", label_selector=f"submission_id=1234-66").thenReturn(
    V1JobList(items=[job_subi]))

  pod_subi = V1Pod(metadata=V1ObjectMeta(name="subi"),
                   status=V1PodStatus(conditions=[V1PodCondition(type="Complete", status=V1PodStatus())], container_statuses=[
                     V1ContainerStatus(name="any", ready="any", restart_count="any", image="any", image_id="ghcr.io/subi")]))
  when(core_api).list_namespaced_pod(namespace="fab-int", label_selector=f"job-name=f3-submission-1234").thenReturn(V1PodList(items=[
    pod_subi
  ]))
  when(core_api).read_namespaced_pod_log("subi", namespace="fab-int").thenReturn("abcd")

  with pytest.raises(TaskExecutionError) as exc_info:
    K8sFlatlandBenchmarksOrchestrator(submission_id="1234")._run_submission(
      test_id="55",
      scenario_id="66",
      submission_data_url="pancy",
      pkl_path="55/66",
      batch_api=batch_api, core_api=core_api)

  assert exc_info.value.message == 'Failed task with submission_id=1234 with submission_data_url=pancy.'
  ret = exc_info.value.status

  verify(batch_api, times=1).list_namespaced_job(...)
  verify(core_api, times=1).list_namespaced_pod(namespace="fab-int", label_selector=f"job-name=f3-submission-1234")
  verify(core_api, times=1).read_namespaced_pod_log("subi", namespace="fab-int")

  assert set(ret.keys()) == {"f3-sub"}
  assert set(ret["f3-sub"].keys()) == {"job_status", "image_id", "log", "job", "pod"}
  assert ret["f3-sub"]["job_status"] == "Somethingelse"
  assert ret["f3-sub"]["image_id"] == "ghcr.io/subi"
  assert ret["f3-sub"]["log"] == "abcd"
  assert ret["f3-sub"]["pod"] == pod_subi.to_dict()
  assert ret["f3-sub"]["job"] == job_subi.to_dict()
  mockito.unstub()
