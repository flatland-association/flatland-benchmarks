import os
import uuid

from celery import Celery

app = Celery(
  broker=os.environ.get('BROKER_URL', "pyamqp://user:bitnami@localhost:5672"),
  backend='redis://localhost:6379',
)

if __name__ == '__main__':
  task_id = str(uuid.uuid4())
  print(f"/ Start simulate submission from portal for task_id={task_id}.....")
  ret = app.send_task(
    'flatland3-evaluation',
    task_id=task_id,
    kwargs={"docker_image": "ghcr.io/flatland-association/fab-flatland-evaluator:latest",
            "submission_image": "ghcr.io/flatland-association/fab-flatland-submission-template:latest"
            },
  ).get(timeout=120)
  print(ret)
  all_completed = all([s["job_status"] == "Complete" for s in ret.values()])

  assert all_completed, ret
  print(
    f"\\ End simulate submission from portal for task_id={task_id}: {[(k, v['job_status'], v['image_id'], v['log']) for k, v in ret.items()]}")
