# ResultsSubmissionSubmissionIdGet200ResponseAllOfBodyInnerTestScoringsInner


## Properties

Name | Type | Description | Notes
------------ | ------------- | ------------- | -------------
**test_id** | **str** | ID of test. | [optional] 
**scorings** | **object** | Dictionary of test scores. | [optional] 
**scenario_scorings** | [**List[ResultsSubmissionSubmissionIdGet200ResponseAllOfBodyInnerTestScoringsInnerScenarioScoringsInner]**](ResultsSubmissionSubmissionIdGet200ResponseAllOfBodyInnerTestScoringsInnerScenarioScoringsInner.md) |  | [optional] 

## Example

```python
from fab_clientlib.models.results_submission_submission_id_get200_response_all_of_body_inner_test_scorings_inner import ResultsSubmissionSubmissionIdGet200ResponseAllOfBodyInnerTestScoringsInner

# TODO update the JSON string below
json = "{}"
# create an instance of ResultsSubmissionSubmissionIdGet200ResponseAllOfBodyInnerTestScoringsInner from a JSON string
results_submission_submission_id_get200_response_all_of_body_inner_test_scorings_inner_instance = ResultsSubmissionSubmissionIdGet200ResponseAllOfBodyInnerTestScoringsInner.from_json(json)
# print the JSON string representation of the object
print(ResultsSubmissionSubmissionIdGet200ResponseAllOfBodyInnerTestScoringsInner.to_json())

# convert the object into a dict
results_submission_submission_id_get200_response_all_of_body_inner_test_scorings_inner_dict = results_submission_submission_id_get200_response_all_of_body_inner_test_scorings_inner_instance.to_dict()
# create an instance of ResultsSubmissionSubmissionIdGet200ResponseAllOfBodyInnerTestScoringsInner from a dict
results_submission_submission_id_get200_response_all_of_body_inner_test_scorings_inner_from_dict = ResultsSubmissionSubmissionIdGet200ResponseAllOfBodyInnerTestScoringsInner.from_dict(results_submission_submission_id_get200_response_all_of_body_inner_test_scorings_inner_dict)
```
[[Back to Model list]](../README.md#documentation-for-models) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to README]](../README.md)


