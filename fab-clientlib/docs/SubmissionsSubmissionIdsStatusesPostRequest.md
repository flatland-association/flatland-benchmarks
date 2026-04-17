# SubmissionsSubmissionIdsStatusesPostRequest


## Properties

Name | Type | Description | Notes
------------ | ------------- | ------------- | -------------
**status** | **str** | New submission status. | 
**message** | **str** | Submission status message. | [optional] 

## Example

```python
from fab_clientlib.models.submissions_submission_ids_statuses_post_request import SubmissionsSubmissionIdsStatusesPostRequest

# TODO update the JSON string below
json = "{}"
# create an instance of SubmissionsSubmissionIdsStatusesPostRequest from a JSON string
submissions_submission_ids_statuses_post_request_instance = SubmissionsSubmissionIdsStatusesPostRequest.from_json(json)
# print the JSON string representation of the object
print(SubmissionsSubmissionIdsStatusesPostRequest.to_json())

# convert the object into a dict
submissions_submission_ids_statuses_post_request_dict = submissions_submission_ids_statuses_post_request_instance.to_dict()
# create an instance of SubmissionsSubmissionIdsStatusesPostRequest from a dict
submissions_submission_ids_statuses_post_request_from_dict = SubmissionsSubmissionIdsStatusesPostRequest.from_dict(submissions_submission_ids_statuses_post_request_dict)
```
[[Back to Model list]](../README.md#documentation-for-models) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to README]](../README.md)


