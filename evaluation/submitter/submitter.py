import os
import uuid

from celery import Celery

app = Celery(
  broker=os.environ.get('BROKER_URL'),
  backend='redis://localhost:6379',
)

if __name__ == '__main__':
  task_id = str(uuid.uuid4())
  print(f"/ Start simulate submission from portal for task_id={task_id}.....")
  ((rc, stdout, stderr), (rc2, stdout2, stderr2)) = app.send_task(

    'flatland3-evaluation',
    task_id=task_id,
    kwargs={"docker_image": "ghcr.io/flatland-association/fab-flatland-evaluator:latest",
            "submission_image": "ghcr.io/flatland-association/fab-flatland-submission-template:latest"
            },
  ).get(timeout=10)
  assert rc == 0, (rc, stdout, stderr, rc2, stdout2, stderr2)
  print(
    f"\\ End simulate submission from portal for task_id={task_id}: rc={rc}, stdout={stdout}, stderr={stderr}, rc2={rc2}, stdout2={stdout2}, stderr2={stderr2}")
