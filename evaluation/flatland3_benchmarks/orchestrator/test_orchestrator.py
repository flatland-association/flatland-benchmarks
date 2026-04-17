import mockito
import pytest
from kubernetes.client import V1JobList, V1Job, V1JobStatus, V1JobCondition, V1ObjectMeta, BatchV1Api, CoreV1Api, V1PodList, V1Pod, V1PodStatus, V1PodCondition, \
  V1ContainerStatus, V1NamespaceList
from mockito import mock
from mockito import verify
from mockito import when

from fab_clientlib import SubmissionsSubmissionIdsStatusesPostRequest
from orchestrator import TaskExecutionError, K8sFlatlandBenchmarksOrchestrator
from orchestrator_common import Status


def test_tasks_successful():
  core_api: CoreV1Api = mock()
  batch_api: BatchV1Api = mock()

  job_subi = V1Job(status=V1JobStatus(conditions=[V1JobCondition(type="Complete", status="blup")]), metadata=V1ObjectMeta(name=f"f3-sub--1234--66"))
  when(batch_api).list_namespaced_job(namespace="fab-int", label_selector=f"submission_id=1234,test_id=55,scenario_id=66").thenReturn(
    V1JobList(items=[job_subi]))

  pod_subi = V1Pod(metadata=V1ObjectMeta(name="subi"),
                   status=V1PodStatus(conditions=[V1PodCondition(type="Complete", status=V1PodStatus())], container_statuses=[
                     V1ContainerStatus(name="any", ready="any", restart_count="any", image="any", image_id="ghcr.io/subi")]))
  when(core_api).list_namespaced_pod(namespace="fab-int", label_selector=f"job-name=f3-sub--1234--66").thenReturn(V1PodList(items=[
    pod_subi
  ]))
  when(core_api).read_namespaced_pod_log("subi", namespace="fab-int").thenReturn("abcd")

  ret = K8sFlatlandBenchmarksOrchestrator(
    submission_id="1234",
    batch_api=batch_api,
    core_api=core_api,
    aws_endpoint_url=None,
    aws_access_key_id='ignore-me',
    aws_secret_access_key='ignore-me',
    s3_bucket=None,
    kubernetes_namespace="fab-int",
    active_deadline_seconds=7200,
    submissions_pvc="fab-int-submissions",
    environments_pvc="fab-int-data",
    environments_zip="flatland3/environments.zip",
  )._run_submission(
    test_id="55",
    scenario_id="66",
    submission_data_url="pancy",
    pkl_path="55/66",
  )

  verify(batch_api, times=1).list_namespaced_job(...)
  verify(core_api, times=1).list_namespaced_pod(namespace="fab-int", label_selector=f"job-name=f3-sub--1234--66")
  verify(core_api, times=1).read_namespaced_pod_log("subi", namespace="fab-int")
  verify(core_api, times=1).list_namespaced_event('fab-int', field_selector='involvedObject.name=subi')

  assert set(ret.keys()) == {"job_status", "image_id", "log", "events", "job", "pod", "pod_status", "running_time"}
  assert ret["job_status"] == "Complete"
  assert ret["image_id"] == "ghcr.io/subi"
  assert ret["log"] == "abcd"
  assert ret["pod"] == pod_subi.to_dict()
  assert ret["job"] == job_subi.to_dict()
  mockito.unstub()


def test_tasks_failing():
  core_api: CoreV1Api = mock()
  batch_api: BatchV1Api = mock()

  job_subi = V1Job(status=V1JobStatus(conditions=[V1JobCondition(type="Somethingelse", status="blup")]), metadata=V1ObjectMeta(name=f"f3-sub--1234--66"))
  when(batch_api).list_namespaced_job(namespace="fab-int", label_selector=f"submission_id=1234,test_id=55,scenario_id=66").thenReturn(
    V1JobList(items=[job_subi]))

  pod_subi = V1Pod(metadata=V1ObjectMeta(name="subi"),
                   status=V1PodStatus(conditions=[V1PodCondition(type="Complete", status=V1PodStatus())], container_statuses=[
                     V1ContainerStatus(name="any", ready="any", restart_count="any", image="any", image_id="ghcr.io/subi")]))
  when(core_api).list_namespaced_pod(namespace="fab-int", label_selector=f"job-name=f3-sub--1234--66").thenReturn(V1PodList(items=[
    pod_subi
  ]))
  when(core_api).read_namespaced_pod_log("subi", namespace="fab-int").thenReturn("abcd")
  when(core_api).list_namespaced_event("fab-int", field_selector=f'involvedObject.name=subi').thenReturn(V1NamespaceList(items=[]))

  with pytest.raises(TaskExecutionError) as exc_info:
    K8sFlatlandBenchmarksOrchestrator(
      submission_id="1234",
      batch_api=batch_api,
      core_api=core_api,
      aws_endpoint_url=None,
      aws_access_key_id='ignore-me',
      aws_secret_access_key='ignore-me',
      s3_bucket=None,
      kubernetes_namespace="fab-int",
      active_deadline_seconds=7200,
      submissions_pvc="fab-int-submissions",
      environments_pvc="fab-int-data",
      environments_zip="flatland3/environments.zip",
    )._run_submission(
      test_id="55",
      scenario_id="66",
      submission_data_url="pancy",
      pkl_path="55/66",
    )

  assert exc_info.value.message.startswith('Failed task with submission_id=1234 with submission_data_url=pancy.')
  ret = exc_info.value.status

  verify(batch_api, times=1).list_namespaced_job(...)
  verify(core_api, times=1).list_namespaced_pod(namespace="fab-int", label_selector=f"job-name=f3-sub--1234--66")
  verify(core_api, times=1).read_namespaced_pod_log("subi", namespace="fab-int")
  verify(core_api, times=1).list_namespaced_event('fab-int', field_selector='involvedObject.name=subi')

  assert set(ret.keys()) == {"job_status", "image_id", "log", "job", "pod", "pod_status", "running_time", "events"}
  assert ret["job_status"] == "Somethingelse"
  assert ret["image_id"] == "ghcr.io/subi"
  assert ret["log"] == "abcd"
  assert ret["pod"] == pod_subi.to_dict()
  assert ret["job"] == job_subi.to_dict()
  mockito.unstub()


def test_make_submission_definition():
  submission_definition = K8sFlatlandBenchmarksOrchestrator(
    submission_id="1234",
    batch_api=None,
    core_api=None,
    aws_endpoint_url=None,
    aws_access_key_id='ignore-me',
    aws_secret_access_key='ignore-me',
    s3_bucket=None,
    kubernetes_namespace="fab-int",
    active_deadline_seconds=888,
    submissions_pvc="fab-int-submissions",
    environments_pvc="fab-int-data",
    environments_zip="flatland3/environments.zip",
    k8s_resource_allocation='{"requests": {"memory": "22Gi", "cpu": "33"}, "limits": {"memory": "44Gi", "cpu": "55"}}',
    additional_submission_args="--yeah",
  )._make_submission_definition(submission_data_url="ghcr.io/subi", test_id="55", scenario_id="66", pkl_path="test99/scenario00.pkl")

  assert len(submission_definition["metadata"]["labels"]) == 3
  assert submission_definition["metadata"]["labels"]["submission_id"] == "1234"
  assert submission_definition["metadata"]["labels"]["test_id"] == "55"
  assert submission_definition["metadata"]["labels"]["scenario_id"] == "66"
  spec = submission_definition["spec"]["template"]["spec"]
  assert spec["activeDeadlineSeconds"] == 888
  assert len(spec["containers"]) == 1
  container = spec["containers"][0]
  assert container["image"] == "ghcr.io/subi"
  assert container["resources"] == {
    "requests": {"memory": "22Gi", "cpu": "33"},
    "limits": {"memory": "44Gi", "cpu": "55"}
  }
  assert len(container["volumeMounts"]) == 2
  assert container["volumeMounts"][0]["name"] == "pvc-submissions"
  assert container["volumeMounts"][0]["mountPath"] == "/data"
  assert container["volumeMounts"][0]["subPath"] == "1234/"
  assert container["volumeMounts"][1]["name"] == "environments"
  assert container["volumeMounts"][1]["mountPath"] == "/tmp/environments"


def test_submission_status_general_failure_reported():
  orchestrator = K8sFlatlandBenchmarksOrchestrator(
    submission_id="1234",
    batch_api=None,
    core_api=None,
    aws_endpoint_url=None,
    aws_access_key_id='ignore-me',
    aws_secret_access_key='ignore-me',
    s3_bucket=None,
    kubernetes_namespace="fab-int",
    active_deadline_seconds=7200,
    submissions_pvc="fab-int-submissions",
    environments_pvc="fab-int-data",
    environments_zip="flatland3/environments.zip",
  )

  def _fail(*args, **kwargs):
    raise Exception()

  orchestrator._run_submission = _fail
  fab = mock()
  with pytest.raises(Exception):
    orchestrator.orchestrator(submission_data_url="funny", fab=fab)

  verify(fab, times=1).submissions_submission_ids_statuses_post(["1234"],
                                                                SubmissionsSubmissionIdsStatusesPostRequest(status=Status.started.value, message=None))
  verify(fab, times=1).submissions_submission_ids_statuses_post(["1234"], SubmissionsSubmissionIdsStatusesPostRequest(status=Status.started.value,
                                                                                                                      message='test fc8f5fb1-4525-4b4f-a022-d3d7800097dc - scenario 289394a5-aa51-446c-9b62-c25101643790'))
  verify(fab, times=1).submissions_submission_ids_statuses_post(["1234"], SubmissionsSubmissionIdsStatusesPostRequest(status=Status.failure.value,
                                                                                                                      message="General failure."))


def test_submission_status_specific_failure_reported():
  orchestrator = K8sFlatlandBenchmarksOrchestrator(
    submission_id="1234",
    batch_api=None,
    core_api=None,
    aws_endpoint_url=None,
    aws_access_key_id='ignore-me',
    aws_secret_access_key='ignore-me',
    s3_bucket=None,
    kubernetes_namespace="fab-int",
    active_deadline_seconds=7200,
    submissions_pvc="fab-int-submissions",
    environments_pvc="fab-int-data",
    environments_zip="flatland3/environments.zip",
  )

  def _fail(*args, **kwargs):
    raise TaskExecutionError("Specific failure message.", None)

  orchestrator._run_submission = _fail
  fab = mock()
  with pytest.raises(Exception):
    orchestrator.orchestrator(submission_data_url="funny", fab=fab)

  verify(fab, times=1).submissions_submission_ids_statuses_post(["1234"],
                                                                SubmissionsSubmissionIdsStatusesPostRequest(status=Status.started.value, message=None))
  verify(fab, times=1).submissions_submission_ids_statuses_post(["1234"], SubmissionsSubmissionIdsStatusesPostRequest(status=Status.started.value,
                                                                                                                      message='test fc8f5fb1-4525-4b4f-a022-d3d7800097dc - scenario 289394a5-aa51-446c-9b62-c25101643790'))
  verify(fab, times=1).submissions_submission_ids_statuses_post(["1234"], SubmissionsSubmissionIdsStatusesPostRequest(status=Status.failure.value,
                                                                                                                      message="Specific failure message."))


def test_submission_status_success_reported():
  orchestrator = K8sFlatlandBenchmarksOrchestrator(
    submission_id="1234",
    batch_api=None,
    core_api=None,
    aws_endpoint_url=None,
    aws_access_key_id='ignore-me',
    aws_secret_access_key='ignore-me',
    s3_bucket=None,
    kubernetes_namespace="fab-int",
    active_deadline_seconds=7200,
    submissions_pvc="fab-int-submissions",
    environments_pvc="fab-int-data",
    environments_zip="flatland3/environments.zip",
  )
  orchestrator._run_submission = lambda *args, **kwargs: {"running_time": 33}
  client = mock()
  orchestrator.s3 = client
  when(client).list_objects_v2(Bucket=None, Prefix=any).thenReturn({'Contents': None})
  orchestrator._extract_stats_from_trajectory = lambda *args, **kwargs: (0.11, 0.22)
  fab = mock()
  orchestrator.orchestrator(submission_data_url="funny", fab=fab)
  verify(fab, times=1).submissions_submission_ids_statuses_post(["1234"],
                                                                SubmissionsSubmissionIdsStatusesPostRequest(status=Status.started.value, message=None))
  verify(fab, times=1).submissions_submission_ids_statuses_post(["1234"], SubmissionsSubmissionIdsStatusesPostRequest(status=Status.started.value,
                                                                                                                      message='test fc8f5fb1-4525-4b4f-a022-d3d7800097dc - scenario 289394a5-aa51-446c-9b62-c25101643790'))
  verify(fab, times=1).submissions_submission_ids_statuses_post(["1234"],
                                                                SubmissionsSubmissionIdsStatusesPostRequest(status=Status.success.value, message=None))
