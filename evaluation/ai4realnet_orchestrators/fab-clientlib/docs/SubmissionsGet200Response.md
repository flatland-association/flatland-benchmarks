# SubmissionsGet200Response


## Properties

Name | Type | Description | Notes
------------ | ------------- | ------------- | -------------
**error** | [**ApiResponseError**](ApiResponseError.md) |  | [optional] 
**body** | [**List[SubmissionsGet200ResponseAllOfBodyInner]**](SubmissionsGet200ResponseAllOfBodyInner.md) |  | [optional] 

## Example

```python
from fab_clientlib.models.submissions_get200_response import SubmissionsGet200Response

# TODO update the JSON string below
json = "{}"
# create an instance of SubmissionsGet200Response from a JSON string
submissions_get200_response_instance = SubmissionsGet200Response.from_json(json)
# print the JSON string representation of the object
print(SubmissionsGet200Response.to_json())

# convert the object into a dict
submissions_get200_response_dict = submissions_get200_response_instance.to_dict()
# create an instance of SubmissionsGet200Response from a dict
submissions_get200_response_from_dict = SubmissionsGet200Response.from_dict(submissions_get200_response_dict)
```
[[Back to Model list]](../README.md#documentation-for-models) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to README]](../README.md)


