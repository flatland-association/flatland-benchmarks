# DefinitionsBenchmarksIdsGet200Response


## Properties

Name | Type | Description | Notes
------------ | ------------- | ------------- | -------------
**error** | [**ApiResponseError**](ApiResponseError.md) |  | [optional] 
**body** | [**List[DefinitionsBenchmarksIdsGet200ResponseAllOfBodyInner]**](DefinitionsBenchmarksIdsGet200ResponseAllOfBodyInner.md) |  | [optional] 

## Example

```python
from fab_clientlib.models.definitions_benchmarks_ids_get200_response import DefinitionsBenchmarksIdsGet200Response

# TODO update the JSON string below
json = "{}"
# create an instance of DefinitionsBenchmarksIdsGet200Response from a JSON string
definitions_benchmarks_ids_get200_response_instance = DefinitionsBenchmarksIdsGet200Response.from_json(json)
# print the JSON string representation of the object
print(DefinitionsBenchmarksIdsGet200Response.to_json())

# convert the object into a dict
definitions_benchmarks_ids_get200_response_dict = definitions_benchmarks_ids_get200_response_instance.to_dict()
# create an instance of DefinitionsBenchmarksIdsGet200Response from a dict
definitions_benchmarks_ids_get200_response_from_dict = DefinitionsBenchmarksIdsGet200Response.from_dict(definitions_benchmarks_ids_get200_response_dict)
```
[[Back to Model list]](../README.md#documentation-for-models) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to README]](../README.md)


