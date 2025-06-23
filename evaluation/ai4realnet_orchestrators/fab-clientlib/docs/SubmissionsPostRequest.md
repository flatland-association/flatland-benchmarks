# SubmissionsPostRequest


## Properties

Name | Type | Description | Notes
------------ | ------------- | ------------- | -------------
**name** | **str** | Display name of submission. | [optional] 
**benchmark_definition_id** | **str** | ID of benchmark this submission belongs to. | [optional] 
**submission_data_url** | **str** | URL of submission executable image. | [optional] 
**code_repository** | **str** | URL of submission code repository. | [optional] 
**test_definition_ids** | **List[str]** | IDs of tests to run. | [optional] 

## Example

```python
from fab_clientlib.models.submissions_post_request import SubmissionsPostRequest

# TODO update the JSON string below
json = "{}"
# create an instance of SubmissionsPostRequest from a JSON string
submissions_post_request_instance = SubmissionsPostRequest.from_json(json)
# print the JSON string representation of the object
print(SubmissionsPostRequest.to_json())

# convert the object into a dict
submissions_post_request_dict = submissions_post_request_instance.to_dict()
# create an instance of SubmissionsPostRequest from a dict
submissions_post_request_from_dict = SubmissionsPostRequest.from_dict(submissions_post_request_dict)
```
[[Back to Model list]](../README.md#documentation-for-models) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to README]](../README.md)


