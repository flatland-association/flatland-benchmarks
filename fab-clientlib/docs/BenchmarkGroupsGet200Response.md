# BenchmarkGroupsGet200Response


## Properties

Name | Type | Description | Notes
------------ | ------------- | ------------- | -------------
**error** | [**ApiResponseError**](ApiResponseError.md) |  | [optional] 
**body** | [**List[BenchmarkGroupsGet200ResponseAllOfBodyInner]**](BenchmarkGroupsGet200ResponseAllOfBodyInner.md) |  | [optional] 

## Example

```python
from fab_clientlib.models.benchmark_groups_get200_response import BenchmarkGroupsGet200Response

# TODO update the JSON string below
json = "{}"
# create an instance of BenchmarkGroupsGet200Response from a JSON string
benchmark_groups_get200_response_instance = BenchmarkGroupsGet200Response.from_json(json)
# print the JSON string representation of the object
print(BenchmarkGroupsGet200Response.to_json())

# convert the object into a dict
benchmark_groups_get200_response_dict = benchmark_groups_get200_response_instance.to_dict()
# create an instance of BenchmarkGroupsGet200Response from a dict
benchmark_groups_get200_response_from_dict = BenchmarkGroupsGet200Response.from_dict(benchmark_groups_get200_response_dict)
```
[[Back to Model list]](../README.md#documentation-for-models) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to README]](../README.md)


