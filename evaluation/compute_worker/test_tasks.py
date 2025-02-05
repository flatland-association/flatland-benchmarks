import builtins
import os
import tarfile
from pathlib import Path

import kubernetes
import mockito
from kubernetes.client import V1JobList, V1Job, V1JobStatus, V1JobCondition, V1ObjectMeta, BatchV1Api, CoreV1Api, V1PodList, V1Pod, V1PodStatus, V1PodCondition, \
  V1ContainerStatus
from mockito import mock
from mockito import verify
from mockito import when

import tasks
from tasks import run_evaluation


def test_tasks_successful():
  core_api: CoreV1Api = mock()
  batch_api: BatchV1Api = mock()

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

  when(core_api).read_namespaced_pod(name=f"f3-retriever-1234", namespace="fab-int").thenReturn(V1Pod(status=V1PodStatus(phase="Succeeded")))
  when(core_api).connect_get_namespaced_pod_exec().thenReturn("")

  m = mock()
  when(m).is_open().thenReturn(True, False)
  when(m).peek_stdout().thenReturn(True, False)
  when(m).read_stdout().thenReturn(os.urandom(4), os.urandom(4))
  when(m).__enter__().thenReturn(None)
  when(kubernetes.stream).stream(mockito.any(), mockito.any(), mockito.any(), command=['/bin/sh', '-c', 'cd /; tar czf - data'], binary=True, stderr=True,
                                 stdin=True, stdout=True, tty=False, _preload_content=False).thenReturn(m)
  tar: tarfile.TarFile = mock(tarfile.TarFile)
  when(tar).__enter__().thenReturn(tar)
  when(tar).__exit__(mockito.any(), mockito.any(), mockito.any())
  when(tar).getmembers().thenReturn([])
  when(tar).extractall(path=mockito.any(), members=mockito.any()).thenReturn([])
  when(tarfile).open(fileobj=mockito.any(), mode=mockito.any()).thenReturn(tar)
  f = mock()
  when(f).read().thenReturn("lakjshdfljk")
  builtins_open = builtins.open
  when(builtins).open('/tmp/results-1234/data/results-1234.csv').thenReturn(f)
  when(builtins).open('/tmp/results-1234/data/results-1234.json').thenReturn(f)
  when(builtins).open(Path(tasks.__file__).parent / "evaluator_job.yaml").thenReturn(builtins_open(Path(tasks.__file__).parent / "evaluator_job.yaml"))
  when(builtins).open(Path(tasks.__file__).parent / "submission_job.yaml").thenReturn(builtins_open(Path(tasks.__file__).parent / "submission_job.yaml"))
  when(builtins).open(Path(tasks.__file__).parent / "retriever_pod.yaml").thenReturn(builtins_open(Path(tasks.__file__).parent / "retriever_pod.yaml"))

  ret = run_evaluation(task_id="1234", docker_image="fancy", submission_image="pancy", batch_api=batch_api, core_api=core_api)

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
  mockito.unstub()
