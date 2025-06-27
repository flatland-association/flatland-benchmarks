# SubmissionsPost200Response


## Properties

Name | Type | Description | Notes
------------ | ------------- | ------------- | -------------
**error** | [**ApiResponseError**](ApiResponseError.md) |  | [optional] 
**body** | [**SubmissionsPost200ResponseAllOfBody**](SubmissionsPost200ResponseAllOfBody.md) |  | [optional] 

## Example

```python
from fab_clientlib.models.submissions_post200_response import SubmissionsPost200Response

# TODO update the JSON string below
json = "{}"
# create an instance of SubmissionsPost200Response from a JSON string
submissions_post200_response_instance = SubmissionsPost200Response.from_json(json)
# print the JSON string representation of the object
print(SubmissionsPost200Response.to_json())

# convert the object into a dict
submissions_post200_response_dict = submissions_post200_response_instance.to_dict()
# create an instance of SubmissionsPost200Response from a dict
submissions_post200_response_from_dict = SubmissionsPost200Response.from_dict(submissions_post200_response_dict)
```
[[Back to Model list]](../README.md#documentation-for-models) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to README]](../README.md)


