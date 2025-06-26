# SubmissionsUuidGet200ResponseAllOfBodyInner


## Properties

Name | Type | Description | Notes
------------ | ------------- | ------------- | -------------
**id** | **str** |  | [optional] 
**benchmark_definition_id** | **str** |  | [optional] 
**submitted_at** | **str** |  | [optional] 
**submitted_by_username** | **str** |  | [optional] 
**public** | **str** |  | [optional] 
**scores** | **str** |  | [optional] 
**rank** | **str** |  | [optional] 

## Example

```python
from fab_clientlib.models.submissions_uuid_get200_response_all_of_body_inner import SubmissionsUuidGet200ResponseAllOfBodyInner

# TODO update the JSON string below
json = "{}"
# create an instance of SubmissionsUuidGet200ResponseAllOfBodyInner from a JSON string
submissions_uuid_get200_response_all_of_body_inner_instance = SubmissionsUuidGet200ResponseAllOfBodyInner.from_json(json)
# print the JSON string representation of the object
print(SubmissionsUuidGet200ResponseAllOfBodyInner.to_json())

# convert the object into a dict
submissions_uuid_get200_response_all_of_body_inner_dict = submissions_uuid_get200_response_all_of_body_inner_instance.to_dict()
# create an instance of SubmissionsUuidGet200ResponseAllOfBodyInner from a dict
submissions_uuid_get200_response_all_of_body_inner_from_dict = SubmissionsUuidGet200ResponseAllOfBodyInner.from_dict(submissions_uuid_get200_response_all_of_body_inner_dict)
```
[[Back to Model list]](../README.md#documentation-for-models) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to README]](../README.md)


