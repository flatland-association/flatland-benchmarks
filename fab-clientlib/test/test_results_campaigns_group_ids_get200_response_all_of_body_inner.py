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

from fab_clientlib.models.results_campaigns_group_ids_get200_response_all_of_body_inner import ResultsCampaignsGroupIdsGet200ResponseAllOfBodyInner

class TestResultsCampaignsGroupIdsGet200ResponseAllOfBodyInner(unittest.TestCase):
    """ResultsCampaignsGroupIdsGet200ResponseAllOfBodyInner unit test stubs"""

    def setUp(self):
        pass

    def tearDown(self):
        pass

    def make_instance(self, include_optional) -> ResultsCampaignsGroupIdsGet200ResponseAllOfBodyInner:
        """Test ResultsCampaignsGroupIdsGet200ResponseAllOfBodyInner
            include_optional is a boolean, when False only required
            params are included, when True both required and
            optional params are included """
        # uncomment below to create an instance of `ResultsCampaignsGroupIdsGet200ResponseAllOfBodyInner`
        """
        model = ResultsCampaignsGroupIdsGet200ResponseAllOfBodyInner()
        if include_optional:
            return ResultsCampaignsGroupIdsGet200ResponseAllOfBodyInner(
                group_id = '',
                items = [
                    fab_clientlib.models._results_campaign_items__benchmark_ids__get_200_response_all_of_body_inner._results_campaign_items__benchmark_ids__get_200_response_allOf_body_inner(
                        benchmark_id = '', 
                        items = [
                            fab_clientlib.models._results_campaign_items__benchmark_ids__get_200_response_all_of_body_inner_items_inner._results_campaign_items__benchmark_ids__get_200_response_allOf_body_inner_items_inner(
                                test_id = '', 
                                scorings = fab_clientlib.models.scorings.scorings(), 
                                submission_id = '', )
                            ], )
                    ],
                scorings = None
            )
        else:
            return ResultsCampaignsGroupIdsGet200ResponseAllOfBodyInner(
        )
        """

    def testResultsCampaignsGroupIdsGet200ResponseAllOfBodyInner(self):
        """Test ResultsCampaignsGroupIdsGet200ResponseAllOfBodyInner"""
        # inst_req_only = self.make_instance(include_optional=False)
        # inst_req_and_optional = self.make_instance(include_optional=True)

if __name__ == '__main__':
    unittest.main()
