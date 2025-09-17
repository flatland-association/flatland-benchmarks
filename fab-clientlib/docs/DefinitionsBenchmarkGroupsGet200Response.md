# DefinitionsBenchmarkGroupsGet200Response


## Properties

Name | Type | Description | Notes
------------ | ------------- | ------------- | -------------
**error** | [**ApiResponseError**](ApiResponseError.md) |  | [optional] 
**body** | [**List[DefinitionsBenchmarkGroupsGet200ResponseAllOfBodyInner]**](DefinitionsBenchmarkGroupsGet200ResponseAllOfBodyInner.md) |  | [optional] 

## Example

```python
from fab_clientlib.models.definitions_benchmark_groups_get200_response import DefinitionsBenchmarkGroupsGet200Response

# TODO update the JSON string below
json = "{}"
# create an instance of DefinitionsBenchmarkGroupsGet200Response from a JSON string
definitions_benchmark_groups_get200_response_instance = DefinitionsBenchmarkGroupsGet200Response.from_json(json)
# print the JSON string representation of the object
print(DefinitionsBenchmarkGroupsGet200Response.to_json())

# convert the object into a dict
definitions_benchmark_groups_get200_response_dict = definitions_benchmark_groups_get200_response_instance.to_dict()
# create an instance of DefinitionsBenchmarkGroupsGet200Response from a dict
definitions_benchmark_groups_get200_response_from_dict = DefinitionsBenchmarkGroupsGet200Response.from_dict(definitions_benchmark_groups_get200_response_dict)
```
[[Back to Model list]](../README.md#documentation-for-models) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to README]](../README.md)


