# coding: utf-8

"""
    FAB backend

    FAB backend API

    The version of the OpenAPI document: 0.0.0
    Generated by OpenAPI Generator (https://openapi-generator.tech)

    Do not edit the class manually.
"""  # noqa: E501

import unittest

from fab_clientlib.models.submissions_uuid_get200_response import SubmissionsUuidGet200Response


class TestSubmissionsUuidGet200Response(unittest.TestCase):
  """SubmissionsUuidGet200Response unit test stubs"""

  def setUp(self):
    pass

  def tearDown(self):
    pass

  def make_instance(self, include_optional) -> SubmissionsUuidGet200Response:
    """Test SubmissionsUuidGet200Response
        include_optional is a boolean, when False only required
        params are included, when True both required and
        optional params are included """
    # uncomment below to create an instance of `SubmissionsUuidGet200Response`
    """
    model = SubmissionsUuidGet200Response()
    if include_optional:
        return SubmissionsUuidGet200Response(
            error = fab_clientlib.models.api_response_error.ApiResponse_error(
                text = '', ),
            body = [
                fab_clientlib.models._submissions__uuid__get_200_response_all_of_body_inner._submissions__uuid__get_200_response_allOf_body_inner(
                    id = '',
                    benchmark_definition_id = '',
                    submitted_at = '',
                    submitted_by_username = '',
                    public = '',
                    scores = '',
                    rank = '', )
                ]
        )
    else:
        return SubmissionsUuidGet200Response(
    )
    """

  def testSubmissionsUuidGet200Response(self):
    """Test SubmissionsUuidGet200Response"""
    # inst_req_only = self.make_instance(include_optional=False)
    # inst_req_and_optional = self.make_instance(include_optional=True)


if __name__ == '__main__':
  unittest.main()
