# ApiResponse


## Properties

Name | Type | Description | Notes
------------ | ------------- | ------------- | -------------
**error** | [**ApiResponseError**](ApiResponseError.md) |  | [optional] 

## Example

```python
from fab_clientlib.models.api_response import ApiResponse

# TODO update the JSON string below
json = "{}"
# create an instance of ApiResponse from a JSON string
api_response_instance = ApiResponse.from_json(json)
# print the JSON string representation of the object
print(ApiResponse.to_json())

# convert the object into a dict
api_response_dict = api_response_instance.to_dict()
# create an instance of ApiResponse from a dict
api_response_from_dict = ApiResponse.from_dict(api_response_dict)
```
[[Back to Model list]](../README.md#documentation-for-models) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to README]](../README.md)


