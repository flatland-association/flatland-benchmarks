# ResultsSubmissionSubmissionIdGet200ResponseAllOfBodyInner


## Properties

Name | Type | Description | Notes
------------ | ------------- | ------------- | -------------
**submission_id** | **str** | ID of submission. | [optional] 
**scorings** | **object** | Dictionary of submission scores. | [optional] 
**test_scorings** | [**List[ResultsSubmissionSubmissionIdGet200ResponseAllOfBodyInnerTestScoringsInner]**](ResultsSubmissionSubmissionIdGet200ResponseAllOfBodyInnerTestScoringsInner.md) |  | [optional] 

## Example

```python
from fab_clientlib.models.results_submission_submission_id_get200_response_all_of_body_inner import ResultsSubmissionSubmissionIdGet200ResponseAllOfBodyInner

# TODO update the JSON string below
json = "{}"
# create an instance of ResultsSubmissionSubmissionIdGet200ResponseAllOfBodyInner from a JSON string
results_submission_submission_id_get200_response_all_of_body_inner_instance = ResultsSubmissionSubmissionIdGet200ResponseAllOfBodyInner.from_json(json)
# print the JSON string representation of the object
print(ResultsSubmissionSubmissionIdGet200ResponseAllOfBodyInner.to_json())

# convert the object into a dict
results_submission_submission_id_get200_response_all_of_body_inner_dict = results_submission_submission_id_get200_response_all_of_body_inner_instance.to_dict()
# create an instance of ResultsSubmissionSubmissionIdGet200ResponseAllOfBodyInner from a dict
results_submission_submission_id_get200_response_all_of_body_inner_from_dict = ResultsSubmissionSubmissionIdGet200ResponseAllOfBodyInner.from_dict(results_submission_submission_id_get200_response_all_of_body_inner_dict)
```
[[Back to Model list]](../README.md#documentation-for-models) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to README]](../README.md)


