# ResultsSubmissionsSubmissionIdTestsTestIdsGet200ResponseAllOfBodyInner


## Properties

Name | Type | Description | Notes
------------ | ------------- | ------------- | -------------
**test_id** | **str** | ID of test. | [optional] 
**scorings** | **object** | Dictionary of test scores. | [optional] 
**scenario_scorings** | [**List[ResultsSubmissionsSubmissionIdsGet200ResponseAllOfBodyInnerTestScoringsInnerScenarioScoringsInner]**](ResultsSubmissionsSubmissionIdsGet200ResponseAllOfBodyInnerTestScoringsInnerScenarioScoringsInner.md) |  | [optional] 

## Example

```python
from fab_clientlib.models.results_submissions_submission_id_tests_test_ids_get200_response_all_of_body_inner import ResultsSubmissionsSubmissionIdTestsTestIdsGet200ResponseAllOfBodyInner

# TODO update the JSON string below
json = "{}"
# create an instance of ResultsSubmissionsSubmissionIdTestsTestIdsGet200ResponseAllOfBodyInner from a JSON string
results_submissions_submission_id_tests_test_ids_get200_response_all_of_body_inner_instance = ResultsSubmissionsSubmissionIdTestsTestIdsGet200ResponseAllOfBodyInner.from_json(json)
# print the JSON string representation of the object
print(ResultsSubmissionsSubmissionIdTestsTestIdsGet200ResponseAllOfBodyInner.to_json())

# convert the object into a dict
results_submissions_submission_id_tests_test_ids_get200_response_all_of_body_inner_dict = results_submissions_submission_id_tests_test_ids_get200_response_all_of_body_inner_instance.to_dict()
# create an instance of ResultsSubmissionsSubmissionIdTestsTestIdsGet200ResponseAllOfBodyInner from a dict
results_submissions_submission_id_tests_test_ids_get200_response_all_of_body_inner_from_dict = ResultsSubmissionsSubmissionIdTestsTestIdsGet200ResponseAllOfBodyInner.from_dict(results_submissions_submission_id_tests_test_ids_get200_response_all_of_body_inner_dict)
```
[[Back to Model list]](../README.md#documentation-for-models) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to README]](../README.md)


