import logging
import time

from celery import Celery
from oauthlib.oauth2 import BackendApplicationClient
from requests_oauthlib import OAuth2Session

TRACE = 5
logger = logging.getLogger(__name__)


def wait_for_completion(submission_id: str):
  start_time = time.time()
  app = Celery(
    broker="amqp://localhost:5672",
    backend="rpc://",
  )
  logger.info(f"/ Start waiting for submission from portal for submission_id={submission_id}.....")
  time.sleep(3)
  inspect = app.control.inspect()
  while True:
    logger.info(inspect.active().values())
    active = [e2 for e in inspect.active().values() for e2 in e]
    logger.info(active)
    if len(active) > 0:
      seconds = 5
      time.sleep(seconds)
    else:
      break
  duration = time.time() - start_time
  logger.info(
    f"\\ End waiting for submission from portal for submission_id={submission_id}. Took {duration} seconds.")


def backend_application_flow(
  client_id='fab',
  client_secret='top-secret',
  token_url='http://localhost:8081/realms/flatland/protocol/openid-connect/token'
):
  """
  Resource Owner Client Credentials Grant Type (grant_type=client_credentials) flow aka. Backend Application Flow.
  https://requests-oauthlib.readthedocs.io/en/latest/oauth2_workflow.html#backend-application-flow
  """
  # Create OAuth session
  client = BackendApplicationClient(client_id=client_id)
  oauth = OAuth2Session(client=client)
  # After user authorization, fetch token
  token = oauth.fetch_token(
    token_url,
    client_id=client_id,
    client_secret=client_secret,
  )
  return token
