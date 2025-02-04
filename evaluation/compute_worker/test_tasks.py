from kubernetes.client import V1JobList, V1Job, V1JobStatus, V1JobCondition, V1ObjectMeta, BatchV1Api, CoreV1Api, V1PodList, V1Pod, V1PodStatus, V1PodCondition, \
  V1ContainerStatus
from mockito import mock
from mockito import verify
from mockito import when

from tasks import run_evaluation


def test_tasks_successful():
    core_api: CoreV1Api = mock()
    batch_api: BatchV1Api = mock()

    job_eva = V1Job(status=V1JobStatus(conditions=[V1JobCondition(type="Complete", status="blup")]), metadata=V1ObjectMeta(name="eva"))
    job_subi = V1Job(status=V1JobStatus(conditions=[V1JobCondition(type="Complete", status="blup")]), metadata=V1ObjectMeta(name="subi"))
    when(batch_api).list_namespaced_job(namespace="fab-int", label_selector=f"task_id=1234").thenReturn(V1JobList(items=[
        job_eva,
        job_subi
    ]))
    pod_eva = V1Pod(metadata=V1ObjectMeta(name="eva"),
                    status=V1PodStatus(conditions=[V1PodCondition(type="Complete", status=V1PodStatus())], container_statuses=[
                        V1ContainerStatus(name="any", ready="any", restart_count="any", image="any", image_id="ghcr.io/eva")]))
    when(core_api).list_namespaced_pod(namespace="fab-int", label_selector=f"job-name=eva").thenReturn(V1PodList(items=[
        pod_eva
    ]))
    when(core_api).read_namespaced_pod_log("eva", namespace="fab-int").thenReturn("abcd")

    pod_subi = V1Pod(metadata=V1ObjectMeta(name="subi"),
                     status=V1PodStatus(conditions=[V1PodCondition(type="Complete", status=V1PodStatus())], container_statuses=[
                         V1ContainerStatus(name="any", ready="any", restart_count="any", image="any", image_id="ghcr.io/subi")]))
    when(core_api).list_namespaced_pod(namespace="fab-int", label_selector=f"job-name=subi").thenReturn(V1PodList(items=[
        pod_subi
    ]))
    when(core_api).read_namespaced_pod_log("subi", namespace="fab-int").thenReturn("abcd")

    ret = run_evaluation(task_id="1234", docker_image="fancy", submission_image="pancy", batch_api=batch_api, core_api=core_api)

    verify(batch_api, times=1).list_namespaced_job(...)
    verify(core_api, times=1).list_namespaced_pod(namespace="fab-int", label_selector=f"job-name=eva")
    verify(core_api, times=1).read_namespaced_pod_log("eva", namespace="fab-int")
    verify(core_api, times=1).list_namespaced_pod(namespace="fab-int", label_selector=f"job-name=subi")
    verify(core_api, times=1).read_namespaced_pod_log("subi", namespace="fab-int")

    assert set(ret.keys()) == {"eva", "subi"}

    assert set(ret["eva"].keys()) == {"job_status", "image_id", "log", "job", "pod"}
    assert set(ret["subi"].keys()) == {"job_status", "image_id", "log", "job", "pod"}

    assert ret["eva"]["job_status"] == "Complete"
    assert ret["subi"]["job_status"] == "Complete"

    assert ret["eva"]["image_id"] == "ghcr.io/eva"
    assert ret["subi"]["image_id"] == "ghcr.io/subi"

    assert ret["eva"]["log"] == "abcd"
    assert ret["subi"]["log"] == "abcd"

    assert ret["eva"]["pod"] == pod_eva.to_dict()
    assert ret["subi"]["pod"] == pod_subi.to_dict()

    assert ret["eva"]["job"] == job_eva.to_dict()
    assert ret["subi"]["job"] == job_subi.to_dict()
