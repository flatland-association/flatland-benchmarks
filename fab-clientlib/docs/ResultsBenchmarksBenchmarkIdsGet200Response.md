# ResultsBenchmarksBenchmarkIdsGet200Response


## Properties

Name | Type | Description | Notes
------------ | ------------- | ------------- | -------------
**error** | [**ApiResponseError**](ApiResponseError.md) |  | [optional] 
**body** | [**List[ResultsBenchmarksBenchmarkIdsGet200ResponseAllOfBodyInner]**](ResultsBenchmarksBenchmarkIdsGet200ResponseAllOfBodyInner.md) |  | [optional] 

## Example

```python
from fab_clientlib.models.results_benchmarks_benchmark_ids_get200_response import ResultsBenchmarksBenchmarkIdsGet200Response

# TODO update the JSON string below
json = "{}"
# create an instance of ResultsBenchmarksBenchmarkIdsGet200Response from a JSON string
results_benchmarks_benchmark_ids_get200_response_instance = ResultsBenchmarksBenchmarkIdsGet200Response.from_json(json)
# print the JSON string representation of the object
print(ResultsBenchmarksBenchmarkIdsGet200Response.to_json())

# convert the object into a dict
results_benchmarks_benchmark_ids_get200_response_dict = results_benchmarks_benchmark_ids_get200_response_instance.to_dict()
# create an instance of ResultsBenchmarksBenchmarkIdsGet200Response from a dict
results_benchmarks_benchmark_ids_get200_response_from_dict = ResultsBenchmarksBenchmarkIdsGet200Response.from_dict(results_benchmarks_benchmark_ids_get200_response_dict)
```
[[Back to Model list]](../README.md#documentation-for-models) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to README]](../README.md)


