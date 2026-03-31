# SubmissionsSubmissionIdsStatusesGet200Response


## Properties

Name | Type | Description | Notes
------------ | ------------- | ------------- | -------------
**error** | [**ApiResponseError**](ApiResponseError.md) |  | [optional] 
**body** | [**List[SubmissionsSubmissionIdsStatusesGet200ResponseAllOfBodyInner]**](SubmissionsSubmissionIdsStatusesGet200ResponseAllOfBodyInner.md) |  | [optional] 

## Example

```python
from fab_clientlib.models.submissions_submission_ids_statuses_get200_response import SubmissionsSubmissionIdsStatusesGet200Response

# TODO update the JSON string below
json = "{}"
# create an instance of SubmissionsSubmissionIdsStatusesGet200Response from a JSON string
submissions_submission_ids_statuses_get200_response_instance = SubmissionsSubmissionIdsStatusesGet200Response.from_json(json)
# print the JSON string representation of the object
print(SubmissionsSubmissionIdsStatusesGet200Response.to_json())

# convert the object into a dict
submissions_submission_ids_statuses_get200_response_dict = submissions_submission_ids_statuses_get200_response_instance.to_dict()
# create an instance of SubmissionsSubmissionIdsStatusesGet200Response from a dict
submissions_submission_ids_statuses_get200_response_from_dict = SubmissionsSubmissionIdsStatusesGet200Response.from_dict(submissions_submission_ids_statuses_get200_response_dict)
```
[[Back to Model list]](../README.md#documentation-for-models) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to README]](../README.md)


