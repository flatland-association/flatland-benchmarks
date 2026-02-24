# based on https://github.com/codalab/codabench/blob/develop/orchestrator/orchestrator.py
import logging
import os
import ssl
import time
from pathlib import Path
from typing import List

import yaml
from celery import Celery
from celery.app.log import TaskFormatter
from celery.signals import after_setup_task_logger
from kubernetes import client, config

from orchestrator_common import FlatlandBenchmarksOrchestrator, TaskExecutionError

logger = logging.getLogger(__name__)

KUBERNETES_NAMESPACE = os.environ.get("KUBERNETES_NAMESPACE", "fab-int")
AWS_ENDPOINT_URL = os.environ.get("AWS_ENDPOINT_URL", None)
AWS_ACCESS_KEY_ID = os.environ.get("AWS_ACCESS_KEY_ID", None)
AWS_SECRET_ACCESS_KEY = os.environ.get("AWS_SECRET_ACCESS_KEY", None)
S3_BUCKET = os.environ.get("S3_BUCKET", None)
ACTIVE_DEADLINE_SECONDS = os.getenv("ACTIVE_DEADLINE_SECONDS", 7200)
BENCHMARK_ID = os.environ.get("BENCHMARK_ID", "flatland3-evaluation")
SUBMISSIONS_PVC = os.environ.get("SUBMISSIONS_PVC", "fab-int-submissions")
S3_URL_ENVIRONMENTS_ZIP = os.environ.get("S3_URL_ENVIRONMENTS_ZIP", "s3://fab-data/flatland3/environments.zip")
PERCENTAGE_COMPLETE_THRESHOLD = os.environ.get("PERCENTAGE_COMPLETE_THRESHOLD", None)

app = Celery(
  broker=os.environ.get('BROKER_URL'),
  backend=os.environ.get('BACKEND_URL'),
  queue=os.environ.get("BENCHMARK_ID"),
  broker_use_ssl={
    'keyfile': os.environ.get("RABBITMQ_KEYFILE"),
    'certfile': os.environ.get("RABBITMQ_CERTFILE"),
    'ca_certs': os.environ.get("RABBITMQ_CA_CERTS"),
    'cert_reqs': ssl.CERT_REQUIRED
  }
)


# https://celery.school/custom-celery-task-logger
@after_setup_task_logger.connect
def setup_task_logger(logger, *args, **kwargs):
  for handler in logger.handlers:
    tf = TaskFormatter("[%(asctime)s][%(levelname)s][%(process)d][%(pathname)s:%(funcName)s:%(lineno)d] [%(task_name)s] - [%(task_id)s] - %(message)s")
    handler.setFormatter(tf)


class K8sFlatlandBenchmarksOrchestrator(FlatlandBenchmarksOrchestrator):

  # k8s implementation has s3 volume mapped into submission container under subpath - data is uploaded by s3fs in the background and needs to downloaded into orchestrator for evaluation
  def _run_submission(self,
                      test_id,
                      scenario_id,
                      submission_data_url,
                      pkl_path,
                      aws_endpoint_url: str = None,
                      aws_access_key_id: str = None,
                      aws_secret_access_key: str = None,
                      s3_bucket: str = None,
                      **kwargs):
    submission_id = self.submission_id
    core_api = kwargs["core_api"]
    batch_api = kwargs["batch_api"]

    logger.info(f"// START running submission submission_id={submission_id},test_id={test_id}, scenario_id={scenario_id}")

    submission_definition = yaml.safe_load(open(Path(__file__).parent / "submission_job.yaml"))
    metadata_name_ = submission_definition['metadata']['name']
    submission_definition["metadata"]["name"] = f"{metadata_name_}--{str(submission_id).lower()[:10]}--{str(scenario_id).lower()}"[:62].rstrip("-")
    label = f"{submission_id}-{scenario_id}"[:63].lower()
    submission_definition["metadata"]["labels"]["submission_id"] = label
    submission_definition["spec"]["template"]["spec"]["activeDeadlineSeconds"] = ACTIVE_DEADLINE_SECONDS
    submission_container_definition = submission_definition["spec"]["template"]["spec"]["containers"][0]
    submission_container_definition["image"] = submission_data_url
    submission_definition["spec"]["template"]["spec"]["volumes"][1]["persistentVolumeClaim"]["claimName"] = SUBMISSIONS_PVC

    # submission container container has not full pvc mounted, sees only /<submission_id> sub_path mounted as /data/ directly, so data-dir is /data/<test_id>/<scenario_id>:
    data_dir = f"/data/{test_id}/{scenario_id}"

    # https://kubernetes.io/docs/tasks/inject-data-application/define-command-argument-container/
    submission_container_definition["args"] = ["flatland-trajectory-generate-from-policy", "--data-dir", data_dir, "--env-path",
                                               f"/tmp/environments/{pkl_path}", "--ep-id", f"{scenario_id}"]
    additional_submission_args = os.environ.get("ADDITIONAL_SUBMISSION_ARGS", None)
    if additional_submission_args is not None:
      submission_container_definition["args"] += additional_submission_args.split(" ")

    sub_path = f"{submission_id}/"
    submission_container_definition["volumeMounts"][0]["subPath"] = sub_path

    submission_download_initcontainer_definition = submission_definition["spec"]["template"]["spec"]["initContainers"][0]
    submission_download_initcontainer_definition["env"].append({"name": "S3_URL_ENVIRONMENTS_ZIP", "value": S3_URL_ENVIRONMENTS_ZIP})

    submission_extractenvs_initcontainer_definition = submission_definition["spec"]["template"]["spec"]["initContainers"][1]
    if aws_endpoint_url:
      submission_download_initcontainer_definition["env"].append({"name": "AWS_ENDPOINT_URL", "value": aws_endpoint_url})
    if aws_access_key_id:
      submission_download_initcontainer_definition["env"].append({"name": "AWS_ACCESS_KEY_ID", "value": aws_access_key_id})
    if aws_secret_access_key:
      submission_download_initcontainer_definition["env"].append({"name": "AWS_SECRET_ACCESS_KEY", "value": aws_secret_access_key})
    # init container has full pvc mounted:
    submission_extractenvs_initcontainer_definition["env"].append({"name": "DATA_DIR", "value": f"/data/{submission_id}/{test_id}/{scenario_id}"})

    # print(json.dumps(submission_definition, indent=4))

    submission = client.V1Job(metadata=submission_definition["metadata"], spec=submission_definition["spec"])
    batch_api.create_namespaced_job(KUBERNETES_NAMESPACE, submission)
    all_done = False
    any_failed = False
    ret = {}
    while not all_done and not any_failed:
      time.sleep(1)
      jobs = batch_api.list_namespaced_job(namespace=KUBERNETES_NAMESPACE, label_selector=f"submission_id={label}")
      assert len(jobs.items) == 1
      all_done = True
      status = []
      for job in jobs.items:
        all_done = all_done and job.status.conditions is not None
        any_failed = any_failed or (job.status.conditions is not None and job.status.conditions[0].type != "Complete")

      if all_done or any_failed:
        for job in jobs.items:
          status.append(job.status.conditions[0].type)
          job_name = job.metadata.name
          pods = core_api.list_namespaced_pod(namespace=KUBERNETES_NAMESPACE, label_selector=f"job-name={job_name}")

          # backoff
          pod = pods.items[-1]
          log = core_api.read_namespaced_pod_log(pod.metadata.name, namespace=KUBERNETES_NAMESPACE)

          _ret = {
            "job_status": job.status.conditions[0].type,
            "image_id": pods.items[-1].status.container_statuses[0].image_id,
            "log": log,
            "job": job.to_dict(),
            "pod": pod.to_dict()
          }
          ret[metadata_name_] = _ret
    if any_failed:
      raise TaskExecutionError(
        f"Failed task with submission_id={submission_id} with submission_data_url={submission_data_url}.", ret)
    logger.info(f"\\\\ END running submission submission_id={submission_id},test_id={test_id}, scenario_id={scenario_id}: {ret}")
    return ret

  @staticmethod
  def load_scenario_data(scenario_id: str) -> str:
    # generated with definitions/flatland3_benchmarks/gen_dict.py
    return {
      "289394a5-aa51-446c-9b62-c25101643790": "Test_00/Level_0.pkl",
      "01dc6523-a236-4da6-8ca6-934d771fc82d": "Test_00/Level_1.pkl",
      "2148fd5e-6141-4fd6-bcae-a93a66c81e61": "Test_00/Level_2.pkl",
      "f5f140c5-b999-4134-9a0a-fde6f2cf1388": "Test_00/Level_3.pkl",
      "7a0d140a-1213-407f-a6b3-5640c5c0caa7": "Test_00/Level_4.pkl",
      "467626bb-4abe-4451-9cd7-f7b1cc5217b9": "Test_00/Level_5.pkl",
      "06b6b84f-b4ad-4446-943f-40911ed46354": "Test_00/Level_6.pkl",
      "12cbd8df-b29c-49e8-98f7-12eec20439ac": "Test_00/Level_7.pkl",
      "1610eb72-fa63-4880-8a21-9e760acc1586": "Test_00/Level_8.pkl",
      "da237c4f-1eba-487a-a630-305eac8fabf3": "Test_00/Level_9.pkl",
      "6e2215de-4299-4374-aeb2-ca84c3b159f9": "Test_01/Level_0.pkl",
      "9d6fbaa7-1ad1-46f1-aa9d-f9fcb32bdbbe": "Test_01/Level_1.pkl",
      "d1424cd1-ab8e-442a-9d45-5c6f9f5de7f7": "Test_01/Level_2.pkl",
      "46bf00c6-c331-4164-a4f9-8b192364af57": "Test_01/Level_3.pkl",
      "e28f3116-3f3f-4bb9-acfc-32fce83fd721": "Test_01/Level_4.pkl",
      "3c7e23be-1597-4e7a-b54c-fd1c641b43b6": "Test_01/Level_5.pkl",
      "6a53431f-3ba9-4040-bfd8-49cec2afc315": "Test_01/Level_6.pkl",
      "a8f16d64-e2d6-455c-8228-8472f698f9de": "Test_01/Level_7.pkl",
      "dcc09410-ac5f-4867-b406-05fd8f93a927": "Test_01/Level_8.pkl",
      "ed31ac93-49fa-47ee-94f5-0ace5f2a4d69": "Test_01/Level_9.pkl",
      "be14b4e1-2d73-4fca-8575-0934ef8694b3": "Test_02/Level_0.pkl",
      "3b053c18-660a-4a59-94c9-7fde88da9c46": "Test_02/Level_1.pkl",
      "46937ddf-e489-4544-bb44-23ac1b6ade0a": "Test_02/Level_2.pkl",
      "9b20e819-8eb9-47ce-bcf7-ca468d31b631": "Test_02/Level_3.pkl",
      "9a92f7b9-28d3-40ff-8669-45ddb83dea08": "Test_02/Level_4.pkl",
      "be689371-2b8b-42b6-9a27-c19a82651e27": "Test_02/Level_5.pkl",
      "3ff7e013-3ab7-493c-8a69-1abab2813a9c": "Test_02/Level_6.pkl",
      "82d014b2-1f71-4f4c-9545-5c73ac27f531": "Test_02/Level_7.pkl",
      "1b1e5bc3-b424-40fe-a143-5adb7104b2c3": "Test_02/Level_8.pkl",
      "bf67d71b-b3ce-45f3-aed7-0b36a9b6a576": "Test_02/Level_9.pkl",
      "f63e8714-b6a6-4aa4-9b5e-efe411781d8e": "Test_03/Level_0.pkl",
      "ce96cbd9-a84f-4a8c-b9aa-52d9f3743f7c": "Test_03/Level_1.pkl",
      "a6616e64-cd47-420c-bfa4-1815f08faae6": "Test_03/Level_2.pkl",
      "0ada9a98-2e98-4579-8654-577234ddacc7": "Test_03/Level_3.pkl",
      "6f6d5a01-0d22-429f-a791-e1d879aa2cad": "Test_03/Level_4.pkl",
      "c08c1a81-d0e1-4230-b653-d5710775a7f2": "Test_03/Level_5.pkl",
      "31e7455b-9018-4034-8a8d-8160439ed299": "Test_03/Level_6.pkl",
      "809111d2-dbbb-4746-a410-2962b2765568": "Test_03/Level_7.pkl",
      "4da5166a-393f-45d8-811c-2ed5f5047dd1": "Test_03/Level_8.pkl",
      "5284341e-01b7-4565-a5db-8372803aa749": "Test_03/Level_9.pkl",
      "bdae085e-143b-4427-bc44-332bbcb13a2f": "Test_04/Level_0.pkl",
      "edb4c75f-d9a3-4c4b-9288-cf850ac638b7": "Test_04/Level_1.pkl",
      "42f73a20-9f0b-4418-8125-9af3de6c30b6": "Test_04/Level_2.pkl",
      "cba8aa28-ac84-423f-b659-e00594f9a51a": "Test_04/Level_3.pkl",
      "ced3bed0-ca13-47d5-8212-e1b9610902cd": "Test_04/Level_4.pkl",
      "98695367-dd38-4f51-98cb-84ecaa1376c7": "Test_04/Level_5.pkl",
      "e6cc9f31-1dde-4bb0-8f46-a50f6ed974bc": "Test_04/Level_6.pkl",
      "931439bd-f1e4-4826-afcc-6ec57cfac218": "Test_04/Level_7.pkl",
      "18c4c31c-16bd-44b4-855b-d640b8a2a8d7": "Test_04/Level_8.pkl",
      "46111b17-f9f4-449f-b9cc-9c9e21b4bf4f": "Test_04/Level_9.pkl",
      "a1f76840-b65a-4fba-850e-62e6962e8cf3": "Test_05/Level_0.pkl",
      "7917b42b-46de-4513-88ae-bdbfa8dd4c44": "Test_05/Level_1.pkl",
      "b325d370-16ff-4885-accf-232bd90e27f9": "Test_05/Level_2.pkl",
      "ad99d767-9f1c-4a63-b93b-431ab53c90d1": "Test_05/Level_3.pkl",
      "d3ff288f-26f1-4a6a-8c6c-d4eeb6ffd7c1": "Test_05/Level_4.pkl",
      "eb54d12f-26ec-446d-b54f-d088cbf59aec": "Test_05/Level_5.pkl",
      "bf6f16a6-7bd8-46a4-a239-7600e19962ff": "Test_05/Level_6.pkl",
      "f16b235c-953b-485e-8bdb-f2467bc0e48b": "Test_05/Level_7.pkl",
      "31f36513-cc80-4e03-815b-e10128bebd7b": "Test_05/Level_8.pkl",
      "93aaab2b-b224-4331-991c-017536456904": "Test_05/Level_9.pkl",
      "dc4abadb-36de-446d-ab82-8284905f61fe": "Test_06/Level_0.pkl",
      "5bd0786e-8cdd-4a8f-8fd3-781bd453b0f8": "Test_06/Level_1.pkl",
      "9ccd5eb8-cfb7-4978-8eab-74b22f350856": "Test_06/Level_2.pkl",
      "643f87c4-fbd7-426d-8a37-489a32b989da": "Test_06/Level_3.pkl",
      "e2284e75-33c5-4ba8-a094-a7d98c7ba50d": "Test_06/Level_4.pkl",
      "2d24fb79-b9e9-49e5-a781-670b08800d6d": "Test_06/Level_5.pkl",
      "9838248b-9440-4edf-a737-0bb571a9dfb4": "Test_06/Level_6.pkl",
      "6639e91d-c96b-46ff-8ccf-09b02847abf3": "Test_06/Level_7.pkl",
      "6285df65-4c03-42bc-99d9-b56c646c1712": "Test_06/Level_8.pkl",
      "3f65387f-052a-4186-8c44-c957a7432631": "Test_06/Level_9.pkl",
      "d4746426-3158-48a0-bd9c-7d519aa0d0c1": "Test_07/Level_0.pkl",
      "3c57145c-5b00-42c2-b2bb-e0dafa95dc25": "Test_07/Level_1.pkl",
      "db2a7727-0600-4ccf-94d8-08439820296a": "Test_07/Level_2.pkl",
      "22bda67d-6126-4697-a2ad-55e54eef8268": "Test_07/Level_3.pkl",
      "dd4c3c50-7ebe-4613-ba3f-48cc8625fc1d": "Test_07/Level_4.pkl",
      "bbd8f606-cc5c-4a02-b59e-08bd6567b8b4": "Test_07/Level_5.pkl",
      "7aaef47c-7afa-4f3b-aba8-0699e62c62d5": "Test_07/Level_6.pkl",
      "a11e0c70-edb2-4589-b311-ff79c4b8d481": "Test_07/Level_7.pkl",
      "ef3e0e89-6262-4c4d-af58-a40e28b39d0a": "Test_07/Level_8.pkl",
      "7ea32c28-f50e-4829-b61e-2bfca9e96f50": "Test_07/Level_9.pkl",
      "e34dc827-57d0-4302-8afa-6ba124d0ed17": "Test_08/Level_0.pkl",
      "a618073a-00b8-4b64-b831-649ea1470e2a": "Test_08/Level_1.pkl",
      "be362322-0762-406c-a4b5-7de55c315432": "Test_08/Level_2.pkl",
      "fa7126ad-c252-4212-8db4-dcab5c0b768a": "Test_08/Level_3.pkl",
      "444ccd34-db33-44c7-97d6-95e58068d1d9": "Test_08/Level_4.pkl",
      "803e1f24-87ac-44fd-b6b6-735326fc6d28": "Test_08/Level_5.pkl",
      "2f4adf26-27e0-4f4a-9a04-02fe7b428aa9": "Test_08/Level_6.pkl",
      "bdc2096b-65dc-4a60-bb91-074e8f9652f3": "Test_08/Level_7.pkl",
      "e441abf3-d54a-42fa-bb90-7e57408511c4": "Test_08/Level_8.pkl",
      "fe65c3bc-55cc-4a9a-bfd4-78ad2b6f7e13": "Test_08/Level_9.pkl",
      "01ab5e33-30ef-423b-8f95-abcea8f3ce38": "Test_09/Level_0.pkl",
      "eed70e25-3940-469c-b7d8-ec80826108cd": "Test_09/Level_1.pkl",
      "c8353dd3-9c7d-44d6-a255-1e94d7fe6021": "Test_09/Level_2.pkl",
      "11d27167-2e2a-499c-a3ee-d19a033b95a1": "Test_09/Level_3.pkl",
      "d36802a3-89cb-4e05-bb3c-429e9942fe89": "Test_09/Level_4.pkl",
      "7183cea7-a755-4873-ba97-d35e461040db": "Test_09/Level_5.pkl",
      "260924ef-970e-423b-95fb-d6ada627113b": "Test_09/Level_6.pkl",
      "fccfb900-2b3b-46e2-a878-5c466d5e8e80": "Test_09/Level_7.pkl",
      "7e5fa86f-9a9b-4827-8876-6d73e296de43": "Test_09/Level_8.pkl",
      "d42ee599-bd9f-49a2-8d21-78826eaf1b24": "Test_09/Level_9.pkl",
      "f07c0a83-6a5b-4b38-8c46-18451a9cf704": "Test_10/Level_0.pkl",
      "213037ae-d645-41d8-8b84-e6c08b5837f1": "Test_10/Level_1.pkl",
      "b1635abf-3877-4ed9-ab6e-74e49d6c8a97": "Test_10/Level_2.pkl",
      "4b4c5137-0cf9-41f7-882e-462a57c9b642": "Test_10/Level_3.pkl",
      "0645d6af-042d-4466-8bbe-d3698478059c": "Test_10/Level_4.pkl",
      "8a65f839-4c2b-4a75-bb82-29c03c0527ed": "Test_10/Level_5.pkl",
      "477099b1-b31a-4475-8504-0ce6e7d21360": "Test_10/Level_6.pkl",
      "944fd888-2998-48bf-90cb-4f8cef185c60": "Test_10/Level_7.pkl",
      "39f1bb6a-2413-46c2-839d-a4da467cd4c4": "Test_10/Level_8.pkl",
      "cea4f99b-dabc-415a-9caf-08f123533365": "Test_10/Level_9.pkl",
      "6b023d2c-9c78-4375-b3d5-ab0dce2c7e69": "Test_11/Level_0.pkl",
      "eec908a1-7332-42ce-8fc1-c820cf705d0d": "Test_11/Level_1.pkl",
      "068e614b-0645-4d62-81ed-7605f4e12d51": "Test_11/Level_2.pkl",
      "4f5d8ec4-540e-436e-ab48-e126d3989486": "Test_11/Level_3.pkl",
      "2b0b0d44-f3f2-4948-9a3f-14d45aa05b75": "Test_11/Level_4.pkl",
      "8343d3cb-b482-40cb-9b72-d5d5716dea9b": "Test_11/Level_5.pkl",
      "0b159694-c6d4-4a7a-844f-a10418a16ad5": "Test_11/Level_6.pkl",
      "70320f0b-24a7-43d1-aba0-55f49dc19e43": "Test_11/Level_7.pkl",
      "f43ae5cd-0eca-4b3b-8233-d3838f8867a5": "Test_11/Level_8.pkl",
      "0be419aa-c9ee-45da-816d-769b1150b78d": "Test_11/Level_9.pkl",
      "edfaca88-562f-424f-a69e-f5d34c39f501": "Test_12/Level_0.pkl",
      "fac213e7-ab55-4fec-8a7e-19528d356c04": "Test_12/Level_1.pkl",
      "0d874b28-3b8b-438d-b30b-51883b73d38c": "Test_12/Level_2.pkl",
      "62fba050-1bbc-456b-8fce-25950cf0c7b3": "Test_12/Level_3.pkl",
      "e1632a99-02a1-445c-8ba1-3fa30cfb3c03": "Test_12/Level_4.pkl",
      "f31a6f8e-9a9a-45b2-ab31-1225b558dd9b": "Test_12/Level_5.pkl",
      "98703b4f-8cbe-414b-b157-138704c6b808": "Test_12/Level_6.pkl",
      "7e92ab49-e433-491b-a0b0-f30c020a91d0": "Test_12/Level_7.pkl",
      "38811b63-2470-4b50-b9ba-7d8e9a2a7880": "Test_12/Level_8.pkl",
      "3e97a630-d21a-4f42-a2cc-2e44446d0e78": "Test_12/Level_9.pkl",
      "e2c6c2a5-1a70-4168-a151-695d737a41fb": "Test_13/Level_0.pkl",
      "c76c17da-90fb-4d4b-95c0-ef24ae77e845": "Test_13/Level_1.pkl",
      "c8ddce49-631e-48a1-ab3a-f349a5c0ba4b": "Test_13/Level_2.pkl",
      "8acaa0c9-f725-4e25-8bb5-1c87ec8bcd6c": "Test_13/Level_3.pkl",
      "474c0fed-2475-4b52-87cc-d875283a79ae": "Test_13/Level_4.pkl",
      "791e2742-2d4a-44b4-9b2c-648ebcfc0d9d": "Test_13/Level_5.pkl",
      "511497fc-6658-4dff-b955-b6b92f261c80": "Test_13/Level_6.pkl",
      "a765eea1-88dd-4100-8136-45a08e3822a4": "Test_13/Level_7.pkl",
      "5875fa83-a91a-4ec7-b533-3fa12cfae8ff": "Test_13/Level_8.pkl",
      "f8b84f09-2460-44f7-9c25-ceab4a7a5ad3": "Test_13/Level_9.pkl",
      "cf3db404-f053-4582-bb24-f9e8c88f427e": "Test_14/Level_0.pkl",
      "768cdd29-0ab6-473e-aea1-b4f4e57ab2d0": "Test_14/Level_1.pkl",
      "f051290f-9807-4ed7-8c7b-72901877d25a": "Test_14/Level_2.pkl",
      "6d518914-2e6f-4e17-a33f-6c2264f8300b": "Test_14/Level_3.pkl",
      "c0e924e8-b91c-4e3a-8161-59b7d2eb5e11": "Test_14/Level_4.pkl",
      "2f87ca8c-f3ab-45fe-944a-ed8d9a48c264": "Test_14/Level_5.pkl",
      "a0ea19e2-e074-4f9b-bf67-55d05a37ab31": "Test_14/Level_6.pkl",
      "61840b63-3569-4751-95e0-6cc3f23909a8": "Test_14/Level_7.pkl",
      "85dbb9a5-52e2-4ed2-ac6e-0030ce5a85ef": "Test_14/Level_8.pkl",
      "14611e50-ef67-4833-9023-65f21e3208ef": "Test_14/Level_9.pkl"
    }[scenario_id]

  TEST_TO_SCENARIO_IDS = {
    "fc8f5fb1-4525-4b4f-a022-d3d7800097dc": [
      "289394a5-aa51-446c-9b62-c25101643790",
      "01dc6523-a236-4da6-8ca6-934d771fc82d",
      "2148fd5e-6141-4fd6-bcae-a93a66c81e61",
      "f5f140c5-b999-4134-9a0a-fde6f2cf1388",
      "7a0d140a-1213-407f-a6b3-5640c5c0caa7",
      "467626bb-4abe-4451-9cd7-f7b1cc5217b9",
      "06b6b84f-b4ad-4446-943f-40911ed46354",
      "12cbd8df-b29c-49e8-98f7-12eec20439ac",
      "1610eb72-fa63-4880-8a21-9e760acc1586",
      "da237c4f-1eba-487a-a630-305eac8fabf3"
    ],
    "a8639b18-9568-42d2-ba9c-88d0d3c1cede": [
      "6e2215de-4299-4374-aeb2-ca84c3b159f9",
      "9d6fbaa7-1ad1-46f1-aa9d-f9fcb32bdbbe",
      "d1424cd1-ab8e-442a-9d45-5c6f9f5de7f7",
      "46bf00c6-c331-4164-a4f9-8b192364af57",
      "e28f3116-3f3f-4bb9-acfc-32fce83fd721",
      "3c7e23be-1597-4e7a-b54c-fd1c641b43b6",
      "6a53431f-3ba9-4040-bfd8-49cec2afc315",
      "a8f16d64-e2d6-455c-8228-8472f698f9de",
      "dcc09410-ac5f-4867-b406-05fd8f93a927",
      "ed31ac93-49fa-47ee-94f5-0ace5f2a4d69"
    ],
    "254de248-0210-4bf9-a349-8f769c5280e2": [
      "be14b4e1-2d73-4fca-8575-0934ef8694b3",
      "3b053c18-660a-4a59-94c9-7fde88da9c46",
      "46937ddf-e489-4544-bb44-23ac1b6ade0a",
      "9b20e819-8eb9-47ce-bcf7-ca468d31b631",
      "9a92f7b9-28d3-40ff-8669-45ddb83dea08",
      "be689371-2b8b-42b6-9a27-c19a82651e27",
      "3ff7e013-3ab7-493c-8a69-1abab2813a9c",
      "82d014b2-1f71-4f4c-9545-5c73ac27f531",
      "1b1e5bc3-b424-40fe-a143-5adb7104b2c3",
      "bf67d71b-b3ce-45f3-aed7-0b36a9b6a576"
    ],
    "e3bf5a0f-4d6c-43be-9352-c630938b871c": [
      "f63e8714-b6a6-4aa4-9b5e-efe411781d8e",
      "ce96cbd9-a84f-4a8c-b9aa-52d9f3743f7c",
      "a6616e64-cd47-420c-bfa4-1815f08faae6",
      "0ada9a98-2e98-4579-8654-577234ddacc7",
      "6f6d5a01-0d22-429f-a791-e1d879aa2cad",
      "c08c1a81-d0e1-4230-b653-d5710775a7f2",
      "31e7455b-9018-4034-8a8d-8160439ed299",
      "809111d2-dbbb-4746-a410-2962b2765568",
      "4da5166a-393f-45d8-811c-2ed5f5047dd1",
      "5284341e-01b7-4565-a5db-8372803aa749"
    ],
    "8a17eb8e-14cb-463f-b687-2fff7e205a5e": [
      "bdae085e-143b-4427-bc44-332bbcb13a2f",
      "edb4c75f-d9a3-4c4b-9288-cf850ac638b7",
      "42f73a20-9f0b-4418-8125-9af3de6c30b6",
      "cba8aa28-ac84-423f-b659-e00594f9a51a",
      "ced3bed0-ca13-47d5-8212-e1b9610902cd",
      "98695367-dd38-4f51-98cb-84ecaa1376c7",
      "e6cc9f31-1dde-4bb0-8f46-a50f6ed974bc",
      "931439bd-f1e4-4826-afcc-6ec57cfac218",
      "18c4c31c-16bd-44b4-855b-d640b8a2a8d7",
      "46111b17-f9f4-449f-b9cc-9c9e21b4bf4f"
    ],
    "d6dc02b7-4683-4ef5-8632-9f9746e06c70": [
      "a1f76840-b65a-4fba-850e-62e6962e8cf3",
      "7917b42b-46de-4513-88ae-bdbfa8dd4c44",
      "b325d370-16ff-4885-accf-232bd90e27f9",
      "ad99d767-9f1c-4a63-b93b-431ab53c90d1",
      "d3ff288f-26f1-4a6a-8c6c-d4eeb6ffd7c1",
      "eb54d12f-26ec-446d-b54f-d088cbf59aec",
      "bf6f16a6-7bd8-46a4-a239-7600e19962ff",
      "f16b235c-953b-485e-8bdb-f2467bc0e48b",
      "31f36513-cc80-4e03-815b-e10128bebd7b",
      "93aaab2b-b224-4331-991c-017536456904"
    ],
    "6dac64f4-fe91-4cca-a04d-541160d7c72a": [
      "dc4abadb-36de-446d-ab82-8284905f61fe",
      "5bd0786e-8cdd-4a8f-8fd3-781bd453b0f8",
      "9ccd5eb8-cfb7-4978-8eab-74b22f350856",
      "643f87c4-fbd7-426d-8a37-489a32b989da",
      "e2284e75-33c5-4ba8-a094-a7d98c7ba50d",
      "2d24fb79-b9e9-49e5-a781-670b08800d6d",
      "9838248b-9440-4edf-a737-0bb571a9dfb4",
      "6639e91d-c96b-46ff-8ccf-09b02847abf3",
      "6285df65-4c03-42bc-99d9-b56c646c1712",
      "3f65387f-052a-4186-8c44-c957a7432631"
    ],
    "3beb68e9-464d-4fb9-962b-15552f1e5185": [
      "d4746426-3158-48a0-bd9c-7d519aa0d0c1",
      "3c57145c-5b00-42c2-b2bb-e0dafa95dc25",
      "db2a7727-0600-4ccf-94d8-08439820296a",
      "22bda67d-6126-4697-a2ad-55e54eef8268",
      "dd4c3c50-7ebe-4613-ba3f-48cc8625fc1d",
      "bbd8f606-cc5c-4a02-b59e-08bd6567b8b4",
      "7aaef47c-7afa-4f3b-aba8-0699e62c62d5",
      "a11e0c70-edb2-4589-b311-ff79c4b8d481",
      "ef3e0e89-6262-4c4d-af58-a40e28b39d0a",
      "7ea32c28-f50e-4829-b61e-2bfca9e96f50"
    ],
    "0036e4d8-ec52-4471-8639-ee410037e56e": [
      "e34dc827-57d0-4302-8afa-6ba124d0ed17",
      "a618073a-00b8-4b64-b831-649ea1470e2a",
      "be362322-0762-406c-a4b5-7de55c315432",
      "fa7126ad-c252-4212-8db4-dcab5c0b768a",
      "444ccd34-db33-44c7-97d6-95e58068d1d9",
      "803e1f24-87ac-44fd-b6b6-735326fc6d28",
      "2f4adf26-27e0-4f4a-9a04-02fe7b428aa9",
      "bdc2096b-65dc-4a60-bb91-074e8f9652f3",
      "e441abf3-d54a-42fa-bb90-7e57408511c4",
      "fe65c3bc-55cc-4a9a-bfd4-78ad2b6f7e13"
    ],
    "c69e9baf-6903-40a5-90ed-8a6ace77c20b": [
      "01ab5e33-30ef-423b-8f95-abcea8f3ce38",
      "eed70e25-3940-469c-b7d8-ec80826108cd",
      "c8353dd3-9c7d-44d6-a255-1e94d7fe6021",
      "11d27167-2e2a-499c-a3ee-d19a033b95a1",
      "d36802a3-89cb-4e05-bb3c-429e9942fe89",
      "7183cea7-a755-4873-ba97-d35e461040db",
      "260924ef-970e-423b-95fb-d6ada627113b",
      "fccfb900-2b3b-46e2-a878-5c466d5e8e80",
      "7e5fa86f-9a9b-4827-8876-6d73e296de43",
      "d42ee599-bd9f-49a2-8d21-78826eaf1b24"
    ],
    "21e4c84a-9595-4c83-9c7f-29d1d11be0af": [
      "f07c0a83-6a5b-4b38-8c46-18451a9cf704",
      "213037ae-d645-41d8-8b84-e6c08b5837f1",
      "b1635abf-3877-4ed9-ab6e-74e49d6c8a97",
      "4b4c5137-0cf9-41f7-882e-462a57c9b642",
      "0645d6af-042d-4466-8bbe-d3698478059c",
      "8a65f839-4c2b-4a75-bb82-29c03c0527ed",
      "477099b1-b31a-4475-8504-0ce6e7d21360",
      "944fd888-2998-48bf-90cb-4f8cef185c60",
      "39f1bb6a-2413-46c2-839d-a4da467cd4c4",
      "cea4f99b-dabc-415a-9caf-08f123533365"
    ],
    "dd8bdf82-4e0a-45c2-a3f7-5585007ef0ab": [
      "6b023d2c-9c78-4375-b3d5-ab0dce2c7e69",
      "eec908a1-7332-42ce-8fc1-c820cf705d0d",
      "068e614b-0645-4d62-81ed-7605f4e12d51",
      "4f5d8ec4-540e-436e-ab48-e126d3989486",
      "2b0b0d44-f3f2-4948-9a3f-14d45aa05b75",
      "8343d3cb-b482-40cb-9b72-d5d5716dea9b",
      "0b159694-c6d4-4a7a-844f-a10418a16ad5",
      "70320f0b-24a7-43d1-aba0-55f49dc19e43",
      "f43ae5cd-0eca-4b3b-8233-d3838f8867a5",
      "0be419aa-c9ee-45da-816d-769b1150b78d"
    ],
    "c04e6a19-af18-4676-b84a-a6bc84453e3d": [
      "edfaca88-562f-424f-a69e-f5d34c39f501",
      "fac213e7-ab55-4fec-8a7e-19528d356c04",
      "0d874b28-3b8b-438d-b30b-51883b73d38c",
      "62fba050-1bbc-456b-8fce-25950cf0c7b3",
      "e1632a99-02a1-445c-8ba1-3fa30cfb3c03",
      "f31a6f8e-9a9a-45b2-ab31-1225b558dd9b",
      "98703b4f-8cbe-414b-b157-138704c6b808",
      "7e92ab49-e433-491b-a0b0-f30c020a91d0",
      "38811b63-2470-4b50-b9ba-7d8e9a2a7880",
      "3e97a630-d21a-4f42-a2cc-2e44446d0e78"
    ],
    "02b447ec-4338-46e6-9634-05b74630388d": [
      "e2c6c2a5-1a70-4168-a151-695d737a41fb",
      "c76c17da-90fb-4d4b-95c0-ef24ae77e845",
      "c8ddce49-631e-48a1-ab3a-f349a5c0ba4b",
      "8acaa0c9-f725-4e25-8bb5-1c87ec8bcd6c",
      "474c0fed-2475-4b52-87cc-d875283a79ae",
      "791e2742-2d4a-44b4-9b2c-648ebcfc0d9d",
      "511497fc-6658-4dff-b955-b6b92f261c80",
      "a765eea1-88dd-4100-8136-45a08e3822a4",
      "5875fa83-a91a-4ec7-b533-3fa12cfae8ff",
      "f8b84f09-2460-44f7-9c25-ceab4a7a5ad3"
    ],
    "e47db3ae-700c-4bad-ae88-466ea5105b87": [
      "cf3db404-f053-4582-bb24-f9e8c88f427e",
      "768cdd29-0ab6-473e-aea1-b4f4e57ab2d0",
      "f051290f-9807-4ed7-8c7b-72901877d25a",
      "6d518914-2e6f-4e17-a33f-6c2264f8300b",
      "c0e924e8-b91c-4e3a-8161-59b7d2eb5e11",
      "2f87ca8c-f3ab-45fe-944a-ed8d9a48c264",
      "a0ea19e2-e074-4f9b-bf67-55d05a37ab31",
      "61840b63-3569-4751-95e0-6cc3f23909a8",
      "85dbb9a5-52e2-4ed2-ac6e-0030ce5a85ef",
      "14611e50-ef67-4833-9023-65f21e3208ef"
    ]
  }


# N.B. name to be used by send_task
@app.task(name=BENCHMARK_ID, bind=True)
def orchestrator(self, submission_data_url: str, tests: List[str] = None, **kwargs):
  submission_id = self.request.id
  config.load_incluster_config()
  # https://github.com/kubernetes-client/python/
  # https://github.com/kubernetes-client/python/blob/master/examples/in_cluster_config.py
  batch_api = client.BatchV1Api()
  core_api = client.CoreV1Api()
  if not AWS_ENDPOINT_URL:
    raise RuntimeError("Misconfiguration: AWS_ENDPOINT_URL must be set in the orchestrator")
  if not AWS_ACCESS_KEY_ID:
    raise RuntimeError("Misconfiguration: AWS_ACCESS_KEY_ID must be set in the orchestrator")
  if not AWS_SECRET_ACCESS_KEY:
    raise RuntimeError("Misconfiguration: AWS_SECRET_ACCESS_KEY must be set in the orchestrator")
  if not S3_BUCKET:
    raise RuntimeError("Misconfiguration: S3_BUCKET must be set in the orchestrator")

  submission_id = self.request.id
  return K8sFlatlandBenchmarksOrchestrator(submission_id).orchestrator(
    submission_data_url=submission_data_url,
    tests=tests,
    aws_endpoint_url=AWS_ENDPOINT_URL,
    aws_access_key_id=AWS_ACCESS_KEY_ID,
    aws_secret_access_key=AWS_SECRET_ACCESS_KEY,
    s3_bucket=S3_BUCKET,
    batch_api=batch_api,
    core_api=core_api,
    **kwargs
  )
