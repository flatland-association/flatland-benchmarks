# TestsIdsGet200Response


## Properties

Name | Type | Description | Notes
------------ | ------------- | ------------- | -------------
**error** | [**ApiResponseError**](ApiResponseError.md) |  | [optional] 
**body** | [**List[TestsIdsGet200ResponseAllOfBodyInner]**](TestsIdsGet200ResponseAllOfBodyInner.md) |  | [optional] 

## Example

```python
from fab_clientlib.models.tests_ids_get200_response import TestsIdsGet200Response

# TODO update the JSON string below
json = "{}"
# create an instance of TestsIdsGet200Response from a JSON string
tests_ids_get200_response_instance = TestsIdsGet200Response.from_json(json)
# print the JSON string representation of the object
print(TestsIdsGet200Response.to_json())

# convert the object into a dict
tests_ids_get200_response_dict = tests_ids_get200_response_instance.to_dict()
# create an instance of TestsIdsGet200Response from a dict
tests_ids_get200_response_from_dict = TestsIdsGet200Response.from_dict(tests_ids_get200_response_dict)
```
[[Back to Model list]](../README.md#documentation-for-models) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to README]](../README.md)


