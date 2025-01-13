import asyncio
import os

from celery import Celery

app = Celery(
  broker=os.environ.get('BROKER_URL'),
  backend='redis://redis:6379',
)

HOST_DIRECTORY = os.environ.get("HOST_DIRECTORY", "/tmp/codabench/")


# docker run --rm -e redis_ip=redis -v /Users/che/workspaces/benchmarking/evaluation/evaluator/debug-environments/:/tmp/debug-environments/ --network evaluation_default evaluation-evaluator:latest bash run.sh
# docker run --rm -e redis_ip=redis -e AICROWD_TESTS_FOLDER=/tmp/debug-environments/ -v /Users/che/workspaces/benchmarking/evaluation/evaluator/debug-environments/:/tmp/debug-environments/ --network evaluation_default evaluation-submission:latest bash run.sh
# N.B. name to be used by send_task
@app.task(name="doit")
def the_task(docker_image: str, submission_image: str):
  loop = asyncio.new_event_loop()
  # TODO use compute_worker.py instead, which has most of the async spawning magic.
  future1 = loop.create_future()
  future2 = loop.create_future()
  gathered_tasks = asyncio.gather(
    run_async_and_catch_output(future1, exec_args=[
      "docker", "run",
      "--rm",
      "-e", "redis_ip=redis",
      # TODO workaround as volumes come from host - will depend on where submissions come from (zip-minio, git,....), establish convention for custom compute_workers...
      "-v", f"{HOST_DIRECTORY}/evaluator/debug-environments/:/tmp/",
      # TODO hacky: inject network name instead
      "--network", "evaluation_default",
      docker_image,
    ]),
    run_async_and_catch_output(future2, exec_args=[
      "docker", "run",
      "--rm",
      "-e", "redis_ip=redis",
      # TODO should data be mounted or...?
      "-e", "AICROWD_TESTS_FOLDER=/tmp/debug-environments/",
      # TODO workaround as volumes come from host - will depend on where submissions come from (zip-minio, git,....)
      "-v", f"{HOST_DIRECTORY}/evaluator/debug-environments/:/tmp/debug-environments/",
      # TODO allow only
      "--network", "evaluation_default",
      # TODO hacky: extract image creation to submission submodule, extract from message?
      submission_image,
    ]),
    loop=loop
  )
  loop.run_until_complete(gathered_tasks)
  print("loop completed")
  return (future1.result(), future2.result())


async def run_async_and_catch_output(future, exec_args):
  print(exec_args)
  proc = await  asyncio.create_subprocess_exec(
    *exec_args,
    stdout=asyncio.subprocess.PIPE,
    stderr=asyncio.subprocess.PIPE
  )
  print(exec_args)
  stdout, stderr = await proc.communicate()
  future.set_result((proc.returncode, stdout, stderr))
  print(f"task rc={proc.returncode}")
  print(f"task stdout={stdout}")
  print(f"task stderr={stderr}")
