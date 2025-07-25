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

from fab_clientlib.models.results_submissions_submission_id_tests_test_ids_post_request_data_inner import ResultsSubmissionsSubmissionIdTestsTestIdsPostRequestDataInner

class TestResultsSubmissionsSubmissionIdTestsTestIdsPostRequestDataInner(unittest.TestCase):
    """ResultsSubmissionsSubmissionIdTestsTestIdsPostRequestDataInner unit test stubs"""

    def setUp(self):
        pass

    def tearDown(self):
        pass

    def make_instance(self, include_optional) -> ResultsSubmissionsSubmissionIdTestsTestIdsPostRequestDataInner:
        """Test ResultsSubmissionsSubmissionIdTestsTestIdsPostRequestDataInner
            include_optional is a boolean, when False only required
            params are included, when True both required and
            optional params are included """
        # uncomment below to create an instance of `ResultsSubmissionsSubmissionIdTestsTestIdsPostRequestDataInner`
        """
        model = ResultsSubmissionsSubmissionIdTestsTestIdsPostRequestDataInner()
        if include_optional:
            return ResultsSubmissionsSubmissionIdTestsTestIdsPostRequestDataInner(
                scenario_id = ''
            )
        else:
            return ResultsSubmissionsSubmissionIdTestsTestIdsPostRequestDataInner(
        )
        """

    def testResultsSubmissionsSubmissionIdTestsTestIdsPostRequestDataInner(self):
        """Test ResultsSubmissionsSubmissionIdTestsTestIdsPostRequestDataInner"""
        # inst_req_only = self.make_instance(include_optional=False)
        # inst_req_and_optional = self.make_instance(include_optional=True)

if __name__ == '__main__':
    unittest.main()
