# BenchmarkGroupsGet200ResponseAllOfBodyInner


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
from fab_clientlib.models.benchmark_groups_get200_response_all_of_body_inner import BenchmarkGroupsGet200ResponseAllOfBodyInner

# TODO update the JSON string below
json = "{}"
# create an instance of BenchmarkGroupsGet200ResponseAllOfBodyInner from a JSON string
benchmark_groups_get200_response_all_of_body_inner_instance = BenchmarkGroupsGet200ResponseAllOfBodyInner.from_json(json)
# print the JSON string representation of the object
print(BenchmarkGroupsGet200ResponseAllOfBodyInner.to_json())

# convert the object into a dict
benchmark_groups_get200_response_all_of_body_inner_dict = benchmark_groups_get200_response_all_of_body_inner_instance.to_dict()
# create an instance of BenchmarkGroupsGet200ResponseAllOfBodyInner from a dict
benchmark_groups_get200_response_all_of_body_inner_from_dict = BenchmarkGroupsGet200ResponseAllOfBodyInner.from_dict(benchmark_groups_get200_response_all_of_body_inner_dict)
```
[[Back to Model list]](../README.md#documentation-for-models) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to README]](../README.md)


