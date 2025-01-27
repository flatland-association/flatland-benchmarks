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

# TODO https://github.com/flatland-association/flatland-benchmarks/issues/27 should we set up an ad-hoc network? What about communication to rabbit?
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
    # TODO https://github.com/flatland-association/flatland-benchmarks/issues/27 workaround as volumes come from host - will depend on where submissions come from (zip-minio, git,....), establish convention for custom compute_workers...
    "-v", f"{HOST_DIRECTORY}/evaluator/debug-environments/:/tmp/",
    "--network", BENCHMARKING_NETWORK,
    docker_image,
  ]
  gathered_tasks = asyncio.gather(
    run_async_and_catch_output(evaluator_future, exec_args=evaluator_exec_args),
    run_async_and_catch_output(submission_future, exec_args=[
      "docker", "run",
      "--rm",
      "-e", "redis_ip=redis",
      # TODO https://github.com/flatland-association/flatland-benchmarks/issues/27 https://github.com/flatland-association/flatland-benchmarks/issues/27 should data be mounted or...?
      "-e", "AICROWD_TESTS_FOLDER=/tmp/debug-environments/",
      # TODO https://github.com/flatland-association/flatland-benchmarks/issues/27 workaround as volumes come from host - will depend on where submissions come from (zip-minio, git,....)
      "-v", f"{HOST_DIRECTORY}/evaluator/debug-environments/:/tmp/debug-environments/",
      # TODO https://github.com/flatland-association/flatland-benchmarks/issues/27 ensure no traffic going to the outside world.
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
