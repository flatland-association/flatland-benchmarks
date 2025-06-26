# ApiResponseError


## Properties

Name | Type | Description | Notes
------------ | ------------- | ------------- | -------------
**text** | **str** |  | [optional] 

## Example

```python
from fab_clientlib.models.api_response_error import ApiResponseError

# TODO update the JSON string below
json = "{}"
# create an instance of ApiResponseError from a JSON string
api_response_error_instance = ApiResponseError.from_json(json)
# print the JSON string representation of the object
print(ApiResponseError.to_json())

# convert the object into a dict
api_response_error_dict = api_response_error_instance.to_dict()
# create an instance of ApiResponseError from a dict
api_response_error_from_dict = ApiResponseError.from_dict(api_response_error_dict)
```
[[Back to Model list]](../README.md#documentation-for-models) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to README]](../README.md)


