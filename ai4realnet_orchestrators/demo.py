from fab_clientlib.api.default_api import DefaultApi
from fab_clientlib.api_client import ApiClient
from fab_clientlib.configuration import Configuration
from fab_clientlib.models.submissions_post_request import SubmissionsPostRequest
from fab_oauth_utils import backend_application_flow


def main():
  token = backend_application_flow(
    client_id='fab',
    client_secret='top-secret',
    token_url='http://localhost:8081/realms/netzgrafikeditor/protocol/openid-connect/token'
  )
  fab = DefaultApi(ApiClient(configuration=Configuration(host="http://localhost:8000", access_token=token["access_token"])))
  result = fab.submissions_post(SubmissionsPostRequest(
    name="fancy",
    benchmark=1,  # TODO uuid
    submission_image="https://you-name-it.org",
    code_repository="https://github.com/you-name-it",
    tests=[],  # TODO mandatory despite optional in swagger.json
    # https://github.com/OpenAPITools/openapi-generator/issues/19485
    # https://github.com/openAPITools/openapi-generator-pip
  ))
  print(result)
  # TODO get submissions


if __name__ == '__main__':
  main()
