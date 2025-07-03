# ResultsSubmissionsSubmissionIdsGet200ResponseAllOfBodyInnerTestScoringsInner


## Properties

Name | Type | Description | Notes
------------ | ------------- | ------------- | -------------
**test_id** | **str** | ID of test. | [optional] 
**scorings** | **object** | Dictionary of test scores. | [optional] 
**scenario_scorings** | [**List[ResultsSubmissionsSubmissionIdsGet200ResponseAllOfBodyInnerTestScoringsInnerScenarioScoringsInner]**](ResultsSubmissionsSubmissionIdsGet200ResponseAllOfBodyInnerTestScoringsInnerScenarioScoringsInner.md) |  | [optional] 

## Example

```python
from fab_clientlib.models.results_submissions_submission_ids_get200_response_all_of_body_inner_test_scorings_inner import ResultsSubmissionsSubmissionIdsGet200ResponseAllOfBodyInnerTestScoringsInner

# TODO update the JSON string below
json = "{}"
# create an instance of ResultsSubmissionsSubmissionIdsGet200ResponseAllOfBodyInnerTestScoringsInner from a JSON string
results_submissions_submission_ids_get200_response_all_of_body_inner_test_scorings_inner_instance = ResultsSubmissionsSubmissionIdsGet200ResponseAllOfBodyInnerTestScoringsInner.from_json(json)
# print the JSON string representation of the object
print(ResultsSubmissionsSubmissionIdsGet200ResponseAllOfBodyInnerTestScoringsInner.to_json())

# convert the object into a dict
results_submissions_submission_ids_get200_response_all_of_body_inner_test_scorings_inner_dict = results_submissions_submission_ids_get200_response_all_of_body_inner_test_scorings_inner_instance.to_dict()
# create an instance of ResultsSubmissionsSubmissionIdsGet200ResponseAllOfBodyInnerTestScoringsInner from a dict
results_submissions_submission_ids_get200_response_all_of_body_inner_test_scorings_inner_from_dict = ResultsSubmissionsSubmissionIdsGet200ResponseAllOfBodyInnerTestScoringsInner.from_dict(results_submissions_submission_ids_get200_response_all_of_body_inner_test_scorings_inner_dict)
```
[[Back to Model list]](../README.md#documentation-for-models) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to README]](../README.md)


