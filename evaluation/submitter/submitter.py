import os

from celery import Celery

app = Celery(
  broker=os.environ.get('BROKER_URL'),
  backend='redis://localhost:6379',
)

if __name__ == '__main__':
  print("/ Start simulate submission from portal.....")
  ((rc, stdout, stderr), (rc2, stdout2, stderr2)) = app.send_task(
    'doit',
    # TODO build docker image
    # TODO pass submission image as well - currently hard-coded to this same value
    kwargs={"docker_image": "evaluation-evaluator:latest",
            "submission_image": "evaluation-submission:latest"
            },
  ).get(timeout=10)
  assert rc == 0, (rc, stdout, stderr, rc2, stdout2, stderr2)
  print(f"\\ End simulate submission from portal: rc={rc}, stdout={stdout}, stderr={stderr}, rc2={rc2}, stdout2={stdout2}, stderr2={stderr2}")
