# based on https://github.com/codalab/codabench/blob/develop/compute_worker/compute_worker.py
import asyncio
import logging
import os
import time

from celery import Celery

logger = logging.getLogger()

app = Celery(
  broker=os.environ.get('BROKER_URL'),
  backend=os.environ.get('REDIS_IP'),
)

HOST_DIRECTORY = os.environ.get("HOST_DIRECTORY", "/tmp/codabench/")
AWS_ENDPOINT_URL = os.environ.get("AWS_ENDPOINT_URL", None)
AWS_ACCESS_KEY_ID = os.environ.get("AWS_ACCESS_KEY_ID", None)
AWS_SECRET_ACCESS_KEY = os.environ.get("AWS_SECRET_ACCESS_KEY", None)
S3_BUCKET = os.environ.get("S3_BUCKET", None)
AICROWD_IS_GRADING = os.environ.get("AICROWD_IS_GRADING", None)

BENCHMARKING_NETWORK = os.environ.get("BENCHMARKING_NETWORK", None)


# TODO https://github.com/flatland-association/flatland-benchmarks/issues/27 start own redis for evaluator <-> submission communication? Split in flatland-repo?
# N.B. name to be used by send_task
@app.task(name="flatland3-evaluation", bind=True)
def the_task(self, docker_image: str, submission_image: str):
  task_id = self.request.id
  start_time = time.time()
  logger.info(f"/ start task with task_id={task_id} with docker_image={docker_image} and submission_image={submission_image}")
  assert BENCHMARKING_NETWORK is not None
  loop = asyncio.new_event_loop()
  evaluator_future = loop.create_future()
  submission_future = loop.create_future()
  evaluator_exec_args = [
    "docker", "run",
    "--rm",
    "-e", "redis_ip=redis",
    "-e", f"AICROWD_SUBMISSION_ID={task_id}",
  ]
  if AWS_ENDPOINT_URL:
    evaluator_exec_args.extend(["-e", f"AWS_ENDPOINT_URL={AWS_ENDPOINT_URL}"])
  if AWS_ACCESS_KEY_ID:
    evaluator_exec_args.extend(["-e", f"AWS_ACCESS_KEY_ID={AWS_ACCESS_KEY_ID}"])
  if AWS_SECRET_ACCESS_KEY:
    evaluator_exec_args.extend(["-e", f"AWS_SECRET_ACCESS_KEY={AWS_SECRET_ACCESS_KEY}"])
  if S3_BUCKET:
    evaluator_exec_args.extend(["-e", f"S3_BUCKET={S3_BUCKET}"])
  if AICROWD_IS_GRADING:
    evaluator_exec_args.extend(["-e", f"AICROWD_IS_GRADING={AICROWD_IS_GRADING}"])

  evaluator_exec_args.extend([
    "-v", f"{HOST_DIRECTORY}/evaluator/debug-environments/:/tmp/",
    "--network", BENCHMARKING_NETWORK,
    docker_image,
  ])
  gathered_tasks = asyncio.gather(
    run_async_and_catch_output(evaluator_future, exec_args=evaluator_exec_args),
    run_async_and_catch_output(submission_future, exec_args=[
      "docker", "run",
      "--rm",
      "-e", "redis_ip=redis",
      "-e", "AICROWD_TESTS_FOLDER=/tmp/debug-environments/",
      "-e", f"AICROWD_SUBMISSION_ID={task_id}",
      "-v", f"{HOST_DIRECTORY}/evaluator/debug-environments/:/tmp/debug-environments/",
      "--network", BENCHMARKING_NETWORK,
      submission_image,
    ]),
    loop=loop
  )
  loop.run_until_complete(gathered_tasks)
  duration = time.time() - start_time
  logger.info(f"\\ end task with task_id={task_id} with docker_image={docker_image} and submission_image={submission_image}. Took {duration} seconds.")
  return {"evaluator": evaluator_future.result(), "submission": submission_future.result()}


# based on https://github.com/codalab/codabench/blob/develop/compute_worker/compute_worker.py:_run_container_engine_cmd
# no live WebSocket communication
async def run_async_and_catch_output(future, exec_args):
  logger.info(f"Run async {exec_args}")
  proc = await  asyncio.create_subprocess_exec(
    *exec_args,
    stdout=asyncio.subprocess.PIPE,
    stderr=asyncio.subprocess.PIPE
  )
  stdout, stderr = await proc.communicate()
  # simulate interface as in k8s
  _ret = {}
  _ret["job_status"] = "Complete" if proc.returncode == 0 else proc.returncode
  _ret["image_id"] = ""
  _ret["log"] = stdout + stderr
  _ret["job"] = ""
  _ret["pod"] = ""
  future.set_result(_ret)
  logger.info(f"task rc=%s", proc.returncode)
  logger.debug(f"task stdout=%s", stdout)
  logger.debug(f"task stderr=%s", stderr)
  return _ret
