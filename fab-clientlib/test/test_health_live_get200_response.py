# coding: utf-8

"""
    FAB Client Lib

    Python client lib to access Flatland Association Benchmarks / AI4REALNET Campaign Hub Backend API, generated with openapi-generator

    The version of the OpenAPI document: 0.0.0
    Contact: contact@flatland-association.org
    Generated by OpenAPI Generator (https://openapi-generator.tech)

    Do not edit the class manually.
"""  # noqa: E501


import unittest

from fab_clientlib.models.health_live_get200_response import HealthLiveGet200Response

class TestHealthLiveGet200Response(unittest.TestCase):
    """HealthLiveGet200Response unit test stubs"""

    def setUp(self):
        pass

    def tearDown(self):
        pass

    def make_instance(self, include_optional) -> HealthLiveGet200Response:
        """Test HealthLiveGet200Response
            include_optional is a boolean, when False only required
            params are included, when True both required and
            optional params are included """
        # uncomment below to create an instance of `HealthLiveGet200Response`
        """
        model = HealthLiveGet200Response()
        if include_optional:
            return HealthLiveGet200Response(
                error = fab_clientlib.models.api_response_error.ApiResponse_error(
                    text = '', ),
                body = fab_clientlib.models._health_live_get_200_response_all_of_body._health_live_get_200_response_allOf_body(
                    status = '', 
                    checks = [
                        fab_clientlib.models._health_live_get_200_response_all_of_body_checks_inner._health_live_get_200_response_allOf_body_checks_inner(
                            name = '', 
                            status = '', 
                            data = '', )
                        ], )
            )
        else:
            return HealthLiveGet200Response(
        )
        """

    def testHealthLiveGet200Response(self):
        """Test HealthLiveGet200Response"""
        # inst_req_only = self.make_instance(include_optional=False)
        # inst_req_and_optional = self.make_instance(include_optional=True)

if __name__ == '__main__':
    unittest.main()
