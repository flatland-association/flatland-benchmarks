# DefinitionsSuitesGet200ResponseAllOfBodyInner


## Properties

Name | Type | Description | Notes
------------ | ------------- | ------------- | -------------
**id** | **str** | ID of suite. | [optional] 
**name** | **str** |  | [optional] 
**description** | **str** |  | [optional] 
**contents** | **object** | Additional textual contents for page. | [optional] 
**setup** | **str** |  | [optional] 
**benchmark_ids** | **List[str]** |  | [optional] 

## Example

```python
from fab_clientlib.models.definitions_suites_get200_response_all_of_body_inner import DefinitionsSuitesGet200ResponseAllOfBodyInner

# TODO update the JSON string below
json = "{}"
# create an instance of DefinitionsSuitesGet200ResponseAllOfBodyInner from a JSON string
definitions_suites_get200_response_all_of_body_inner_instance = DefinitionsSuitesGet200ResponseAllOfBodyInner.from_json(json)
# print the JSON string representation of the object
print(DefinitionsSuitesGet200ResponseAllOfBodyInner.to_json())

# convert the object into a dict
definitions_suites_get200_response_all_of_body_inner_dict = definitions_suites_get200_response_all_of_body_inner_instance.to_dict()
# create an instance of DefinitionsSuitesGet200ResponseAllOfBodyInner from a dict
definitions_suites_get200_response_all_of_body_inner_from_dict = DefinitionsSuitesGet200ResponseAllOfBodyInner.from_dict(definitions_suites_get200_response_all_of_body_inner_dict)
```
[[Back to Model list]](../README.md#documentation-for-models) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to README]](../README.md)


