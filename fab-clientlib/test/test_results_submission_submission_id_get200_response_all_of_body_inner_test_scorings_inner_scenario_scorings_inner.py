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

from fab_clientlib.models.results_submission_submission_id_get200_response_all_of_body_inner_test_scorings_inner_scenario_scorings_inner import ResultsSubmissionSubmissionIdGet200ResponseAllOfBodyInnerTestScoringsInnerScenarioScoringsInner

class TestResultsSubmissionSubmissionIdGet200ResponseAllOfBodyInnerTestScoringsInnerScenarioScoringsInner(unittest.TestCase):
    """ResultsSubmissionSubmissionIdGet200ResponseAllOfBodyInnerTestScoringsInnerScenarioScoringsInner unit test stubs"""

    def setUp(self):
        pass

    def tearDown(self):
        pass

    def make_instance(self, include_optional) -> ResultsSubmissionSubmissionIdGet200ResponseAllOfBodyInnerTestScoringsInnerScenarioScoringsInner:
        """Test ResultsSubmissionSubmissionIdGet200ResponseAllOfBodyInnerTestScoringsInnerScenarioScoringsInner
            include_optional is a boolean, when False only required
            params are included, when True both required and
            optional params are included """
        # uncomment below to create an instance of `ResultsSubmissionSubmissionIdGet200ResponseAllOfBodyInnerTestScoringsInnerScenarioScoringsInner`
        """
        model = ResultsSubmissionSubmissionIdGet200ResponseAllOfBodyInnerTestScoringsInnerScenarioScoringsInner()
        if include_optional:
            return ResultsSubmissionSubmissionIdGet200ResponseAllOfBodyInnerTestScoringsInnerScenarioScoringsInner(
                scenario_id = '',
                scorings = None
            )
        else:
            return ResultsSubmissionSubmissionIdGet200ResponseAllOfBodyInnerTestScoringsInnerScenarioScoringsInner(
        )
        """

    def testResultsSubmissionSubmissionIdGet200ResponseAllOfBodyInnerTestScoringsInnerScenarioScoringsInner(self):
        """Test ResultsSubmissionSubmissionIdGet200ResponseAllOfBodyInnerTestScoringsInnerScenarioScoringsInner"""
        # inst_req_only = self.make_instance(include_optional=False)
        # inst_req_and_optional = self.make_instance(include_optional=True)

if __name__ == '__main__':
    unittest.main()
