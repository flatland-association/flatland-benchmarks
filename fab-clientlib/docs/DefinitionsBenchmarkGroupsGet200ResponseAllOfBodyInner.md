# DefinitionsBenchmarkGroupsGet200ResponseAllOfBodyInner


## Properties

Name | Type | Description | Notes
------------ | ------------- | ------------- | -------------
**id** | **str** | ID of benchmark-group. | [optional] 
**name** | **str** |  | [optional] 
**description** | **str** |  | [optional] 
**setup** | **str** |  | [optional] 
**benchmark_ids** | **List[str]** |  | [optional] 

## Example

```python
from fab_clientlib.models.definitions_benchmark_groups_get200_response_all_of_body_inner import DefinitionsBenchmarkGroupsGet200ResponseAllOfBodyInner

# TODO update the JSON string below
json = "{}"
# create an instance of DefinitionsBenchmarkGroupsGet200ResponseAllOfBodyInner from a JSON string
definitions_benchmark_groups_get200_response_all_of_body_inner_instance = DefinitionsBenchmarkGroupsGet200ResponseAllOfBodyInner.from_json(json)
# print the JSON string representation of the object
print(DefinitionsBenchmarkGroupsGet200ResponseAllOfBodyInner.to_json())

# convert the object into a dict
definitions_benchmark_groups_get200_response_all_of_body_inner_dict = definitions_benchmark_groups_get200_response_all_of_body_inner_instance.to_dict()
# create an instance of DefinitionsBenchmarkGroupsGet200ResponseAllOfBodyInner from a dict
definitions_benchmark_groups_get200_response_all_of_body_inner_from_dict = DefinitionsBenchmarkGroupsGet200ResponseAllOfBodyInner.from_dict(definitions_benchmark_groups_get200_response_all_of_body_inner_dict)
```
[[Back to Model list]](../README.md#documentation-for-models) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to README]](../README.md)


