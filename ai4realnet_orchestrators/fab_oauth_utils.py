from oauthlib.oauth2 import BackendApplicationClient
from requests_oauthlib import OAuth2Session


def backend_application_flow(
  client_id='fab',
  client_secret='top-secret',
  token_url='http://localhost:8081/realms/netzgrafikeditor/protocol/openid-connect/token'
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


if __name__ == '__main__':
  # InsecureTransportError: (insecure_transport) OAuth 2 MUST utilize https.
  # https://stackoverflow.com/questions/51209475/set-a-secure-https-connection-for-oauth2-on-python#54215305
  token = backend_application_flow(
    client_id='fab-client-credentials',
    client_secret='top-secret',
    token_url='http://localhost:8081/realms/netzgrafikeditor/protocol/openid-connect/token',
  )
  print(token)
