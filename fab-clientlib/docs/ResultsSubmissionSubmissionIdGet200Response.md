# ResultsSubmissionSubmissionIdGet200Response


## Properties

Name | Type | Description | Notes
------------ | ------------- | ------------- | -------------
**error** | [**ApiResponseError**](ApiResponseError.md) |  | [optional] 
**body** | [**List[ResultsSubmissionSubmissionIdGet200ResponseAllOfBodyInner]**](ResultsSubmissionSubmissionIdGet200ResponseAllOfBodyInner.md) |  | [optional] 

## Example

```python
from fab_clientlib.models.results_submission_submission_id_get200_response import ResultsSubmissionSubmissionIdGet200Response

# TODO update the JSON string below
json = "{}"
# create an instance of ResultsSubmissionSubmissionIdGet200Response from a JSON string
results_submission_submission_id_get200_response_instance = ResultsSubmissionSubmissionIdGet200Response.from_json(json)
# print the JSON string representation of the object
print(ResultsSubmissionSubmissionIdGet200Response.to_json())

# convert the object into a dict
results_submission_submission_id_get200_response_dict = results_submission_submission_id_get200_response_instance.to_dict()
# create an instance of ResultsSubmissionSubmissionIdGet200Response from a dict
results_submission_submission_id_get200_response_from_dict = ResultsSubmissionSubmissionIdGet200Response.from_dict(results_submission_submission_id_get200_response_dict)
```
[[Back to Model list]](../README.md#documentation-for-models) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to README]](../README.md)


