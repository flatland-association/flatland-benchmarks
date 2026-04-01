# SubmissionsSubmissionIdsPatchRequest


## Properties

Name | Type | Description | Notes
------------ | ------------- | ------------- | -------------
**name** | **str** | Display name of submission. | [optional] 
**code_repository** | **str** | URL of submission code repository. | [optional] 
**published** | **bool** | Whether submission is published. | [optional] 

## Example

```python
from fab_clientlib.models.submissions_submission_ids_patch_request import SubmissionsSubmissionIdsPatchRequest

# TODO update the JSON string below
json = "{}"
# create an instance of SubmissionsSubmissionIdsPatchRequest from a JSON string
submissions_submission_ids_patch_request_instance = SubmissionsSubmissionIdsPatchRequest.from_json(json)
# print the JSON string representation of the object
print(SubmissionsSubmissionIdsPatchRequest.to_json())

# convert the object into a dict
submissions_submission_ids_patch_request_dict = submissions_submission_ids_patch_request_instance.to_dict()
# create an instance of SubmissionsSubmissionIdsPatchRequest from a dict
submissions_submission_ids_patch_request_from_dict = SubmissionsSubmissionIdsPatchRequest.from_dict(submissions_submission_ids_patch_request_dict)
```
[[Back to Model list]](../README.md#documentation-for-models) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to README]](../README.md)


