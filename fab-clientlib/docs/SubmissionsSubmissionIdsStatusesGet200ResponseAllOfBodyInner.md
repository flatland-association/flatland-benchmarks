# SubmissionsSubmissionIdsStatusesGet200ResponseAllOfBodyInner


## Properties

Name | Type | Description | Notes
------------ | ------------- | ------------- | -------------
**submission_id** | **str** | ID of submission. | [optional] 
**status** | **str** | Submission status. | [optional] 
**message** | **str** | Submission status message. | [optional] 
**timestamp** | **str** |  | [optional] 

## Example

```python
from fab_clientlib.models.submissions_submission_ids_statuses_get200_response_all_of_body_inner import SubmissionsSubmissionIdsStatusesGet200ResponseAllOfBodyInner

# TODO update the JSON string below
json = "{}"
# create an instance of SubmissionsSubmissionIdsStatusesGet200ResponseAllOfBodyInner from a JSON string
submissions_submission_ids_statuses_get200_response_all_of_body_inner_instance = SubmissionsSubmissionIdsStatusesGet200ResponseAllOfBodyInner.from_json(json)
# print the JSON string representation of the object
print(SubmissionsSubmissionIdsStatusesGet200ResponseAllOfBodyInner.to_json())

# convert the object into a dict
submissions_submission_ids_statuses_get200_response_all_of_body_inner_dict = submissions_submission_ids_statuses_get200_response_all_of_body_inner_instance.to_dict()
# create an instance of SubmissionsSubmissionIdsStatusesGet200ResponseAllOfBodyInner from a dict
submissions_submission_ids_statuses_get200_response_all_of_body_inner_from_dict = SubmissionsSubmissionIdsStatusesGet200ResponseAllOfBodyInner.from_dict(submissions_submission_ids_statuses_get200_response_all_of_body_inner_dict)
```
[[Back to Model list]](../README.md#documentation-for-models) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to README]](../README.md)


