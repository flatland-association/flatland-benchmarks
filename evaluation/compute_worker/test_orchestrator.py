from base64 import b64encode
from os import urandom

import mockito
import pytest
from kubernetes.client import V1JobList, V1Job, V1JobStatus, V1JobCondition, V1ObjectMeta, BatchV1Api, CoreV1Api, V1PodList, V1Pod, V1PodStatus, V1PodCondition, \
  V1ContainerStatus
from mockito import mock
from mockito import verify
from mockito import when

from orchestrator import run_evaluation, TaskExecutionError


def test_tasks_successful():
  core_api: CoreV1Api = mock()
  batch_api: BatchV1Api = mock()
  s3 = mock()

  job_eva = V1Job(status=V1JobStatus(conditions=[V1JobCondition(type="Complete", status="blup")]), metadata=V1ObjectMeta(name=f"f3-evaluator-1234"))
  job_subi = V1Job(status=V1JobStatus(conditions=[V1JobCondition(type="Complete", status="blup")]), metadata=V1ObjectMeta(name=f"f3-submission-1234"))
  when(batch_api).list_namespaced_job(namespace="fab-int", label_selector=f"task_id=1234").thenReturn(V1JobList(items=[
    job_eva,
    job_subi
  ]))
  pod_eva = V1Pod(metadata=V1ObjectMeta(name="eva"),
                  status=V1PodStatus(conditions=[V1PodCondition(type="Complete", status=V1PodStatus())], container_statuses=[
                    V1ContainerStatus(name="any", ready="any", restart_count="any", image="any", image_id="ghcr.io/eva")]))
  when(core_api).list_namespaced_pod(namespace="fab-int", label_selector=f"job-name=f3-evaluator-1234").thenReturn(V1PodList(items=[
    pod_eva
  ]))
  when(core_api).read_namespaced_pod_log("eva", namespace="fab-int").thenReturn("abcd")

  pod_subi = V1Pod(metadata=V1ObjectMeta(name="subi"),
                   status=V1PodStatus(conditions=[V1PodCondition(type="Complete", status=V1PodStatus())], container_statuses=[
                     V1ContainerStatus(name="any", ready="any", restart_count="any", image="any", image_id="ghcr.io/subi")]))
  when(core_api).list_namespaced_pod(namespace="fab-int", label_selector=f"job-name=f3-submission-1234").thenReturn(V1PodList(items=[
    pod_subi
  ]))
  when(core_api).read_namespaced_pod_log("subi", namespace="fab-int").thenReturn("abcd")

  m = mock()
  results_csv_bytes = b64encode(urandom(4))
  results_json_bytes = b64encode(urandom(4))
  when(m).read().thenReturn(results_csv_bytes, results_json_bytes)
  when(s3).get_object(Bucket=mockito.any(), Key=mockito.any()).thenReturn({"Body": m})

  ret = run_evaluation(task_id="1234", test_runner_evaluator_image="fancy", submission_image="pancy", batch_api=batch_api, core_api=core_api, s3=s3,
                       s3_upload_path_template="results/{}")

  verify(batch_api, times=1).list_namespaced_job(...)
  verify(core_api, times=1).list_namespaced_pod(namespace="fab-int", label_selector=f"job-name=f3-evaluator-1234")
  verify(core_api, times=1).read_namespaced_pod_log("eva", namespace="fab-int")
  verify(core_api, times=1).list_namespaced_pod(namespace="fab-int", label_selector=f"job-name=f3-submission-1234")
  verify(core_api, times=1).read_namespaced_pod_log("subi", namespace="fab-int")

  assert set(ret.keys()) == {"f3-evaluator", "f3-submission"}

  assert set(ret["f3-evaluator"].keys()) == {"job_status", "image_id", "log", "job", "pod", 'results.csv', 'results.json'}
  assert set(ret["f3-submission"].keys()) == {"job_status", "image_id", "log", "job", "pod"}

  assert ret["f3-evaluator"]["job_status"] == "Complete"
  assert ret["f3-submission"]["job_status"] == "Complete"

  assert ret["f3-evaluator"]["image_id"] == "ghcr.io/eva"
  assert ret["f3-submission"]["image_id"] == "ghcr.io/subi"

  assert ret["f3-evaluator"]["log"] == "abcd"
  assert ret["f3-submission"]["log"] == "abcd"

  assert ret["f3-evaluator"]["pod"] == pod_eva.to_dict()
  assert ret["f3-submission"]["pod"] == pod_subi.to_dict()

  assert ret["f3-evaluator"]["job"] == job_eva.to_dict()
  assert ret["f3-submission"]["job"] == job_subi.to_dict()

  assert ret["f3-evaluator"]["results.csv"] == results_csv_bytes.decode("utf-8")
  assert ret["f3-evaluator"]["results.json"] == results_json_bytes.decode("utf-8")

  mockito.unstub()


def test_tasks_failing():
  core_api: CoreV1Api = mock()
  batch_api: BatchV1Api = mock()
  s3 = mock()

  job_eva = V1Job(status=V1JobStatus(conditions=[V1JobCondition(type="Somethingelse", status="blup")]), metadata=V1ObjectMeta(name=f"f3-evaluator-1234"))
  job_subi = V1Job(status=V1JobStatus(conditions=[V1JobCondition(type="Complete", status="blup")]), metadata=V1ObjectMeta(name=f"f3-submission-1234"))
  when(batch_api).list_namespaced_job(namespace="fab-int", label_selector=f"task_id=1234").thenReturn(V1JobList(items=[
    job_eva,
    job_subi
  ]))
  pod_eva = V1Pod(metadata=V1ObjectMeta(name="eva"),
                  status=V1PodStatus(conditions=[V1PodCondition(type="Complete", status=V1PodStatus())], container_statuses=[
                    V1ContainerStatus(name="any", ready="any", restart_count="any", image="any", image_id="ghcr.io/eva")]))
  when(core_api).list_namespaced_pod(namespace="fab-int", label_selector=f"job-name=f3-evaluator-1234").thenReturn(V1PodList(items=[
    pod_eva
  ]))
  when(core_api).read_namespaced_pod_log("eva", namespace="fab-int").thenReturn("abcd")

  pod_subi = V1Pod(metadata=V1ObjectMeta(name="subi"),
                   status=V1PodStatus(conditions=[V1PodCondition(type="Complete", status=V1PodStatus())], container_statuses=[
                     V1ContainerStatus(name="any", ready="any", restart_count="any", image="any", image_id="ghcr.io/subi")]))
  when(core_api).list_namespaced_pod(namespace="fab-int", label_selector=f"job-name=f3-submission-1234").thenReturn(V1PodList(items=[
    pod_subi
  ]))
  when(core_api).read_namespaced_pod_log("subi", namespace="fab-int").thenReturn("abcd")

  with pytest.raises(TaskExecutionError) as exc_info:
    run_evaluation(task_id="1234", test_runner_evaluator_image="fancy", submission_image="pancy", batch_api=batch_api, core_api=core_api, s3=s3,
                   s3_upload_path_template="results/{}")

  assert exc_info.value.message.startswith(f"Failed task with task_id=1234 with docker_image=fancy and submission_image=pancy")
  ret = exc_info.value.status

  verify(batch_api, times=1).list_namespaced_job(...)
  verify(core_api, times=1).list_namespaced_pod(namespace="fab-int", label_selector=f"job-name=f3-evaluator-1234")
  verify(core_api, times=1).read_namespaced_pod_log("eva", namespace="fab-int")
  verify(core_api, times=1).list_namespaced_pod(namespace="fab-int", label_selector=f"job-name=f3-submission-1234")
  verify(core_api, times=1).read_namespaced_pod_log("subi", namespace="fab-int")

  assert set(ret.keys()) == {"f3-evaluator", "f3-submission"}

  assert set(ret["f3-evaluator"].keys()) == {"job_status", "image_id", "log", "job", "pod"}
  assert set(ret["f3-submission"].keys()) == {"job_status", "image_id", "log", "job", "pod"}

  assert ret["f3-evaluator"]["job_status"] == "Somethingelse"
  assert ret["f3-submission"]["job_status"] == "Complete"

  assert ret["f3-evaluator"]["image_id"] == "ghcr.io/eva"
  assert ret["f3-submission"]["image_id"] == "ghcr.io/subi"

  assert ret["f3-evaluator"]["log"] == "abcd"
  assert ret["f3-submission"]["log"] == "abcd"

  assert ret["f3-evaluator"]["pod"] == pod_eva.to_dict()
  assert ret["f3-submission"]["pod"] == pod_subi.to_dict()

  assert ret["f3-evaluator"]["job"] == job_eva.to_dict()
  assert ret["f3-submission"]["job"] == job_subi.to_dict()

  mockito.unstub()
