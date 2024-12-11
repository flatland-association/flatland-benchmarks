import asyncio
import os

from celery import Celery

app = Celery(
  broker=os.environ.get('BROKER_URL'),
  backend='redis://redis:6379',
)

HOST_DIRECTORY = os.environ.get("HOST_DIRECTORY", "/tmp/codabench/")


# N.B. name to be used by send_task
@app.task(name="doit")
def the_task(docker_image: str):
  loop = asyncio.new_event_loop()
  # TODO use compute_worker.py instead, which has most of the async spawning magic.
  future1 = loop.create_future()
  future2 = loop.create_future()
  gathered_tasks = asyncio.gather(
    run_hello_world(future1, exec_args=["docker", "run",
                                        "--rm",
                                        "-e", "redis_ip=redis",
                                        # TODO workaround as volumes come from host - will depend on where submissions come from (zip-minio, git,....)
                                        "-v", f"{HOST_DIRECTORY}/evaluator/evaluator.py:/tmp/evaluator.py",
                                        "-v", f"{HOST_DIRECTORY}/evaluator/debug-environments/:/tmp/debug-environments/",
                                        # TODO hacky: inject network name instead
                                        "--network", "evaluation_default",
                                        # TODO hacky: image might not be built yet
                                        docker_image,
                                        # TODO bad coupling/design smell evaluator.py defined in flatland-starter-kit module, where should the information
                                        "bash", "-c", "python /tmp/evaluator.py"
                                        ]),
    run_hello_world(future2, exec_args=["docker", "run",
                                        "--rm",
                                        "-e", "redis_ip=redis",
                                        "-e", "AICROWD_TESTS_FOLDER=/tmp/debug-environments/",
                                        # TODO workaround as volumes come from host - will depend on where submissions come from (zip-minio, git,....)
                                        "-v", f"{HOST_DIRECTORY}/evaluator-kit/evaluator.py:/tmp/evaluator.py",
                                        "-v", f"{HOST_DIRECTORY}/evaluator/debug-environments/:/tmp/debug-environments/",
                                        # TODO hacky: inject network name instead
                                        "--network", "evaluation_default",
                                        # TODO hacky: extract image creation to submission submodule, extract from message?
                                        "evaluation-submission:latest",
                                        "bash", "run.sh"
                                        ]),
    loop=loop
  )
  loop.run_until_complete(gathered_tasks)
  return (future1.result(), future2.result())


async def run_hello_world(future, exec_args):
  print(exec_args)
  proc = await  asyncio.create_subprocess_exec(
    *exec_args,
    stdout=asyncio.subprocess.PIPE,
    stderr=asyncio.subprocess.PIPE
  )
  print(exec_args)
  stdout, stderr = await proc.communicate()
  future.set_result((proc.returncode, stdout, stderr))
