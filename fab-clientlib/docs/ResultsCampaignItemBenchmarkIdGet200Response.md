# ResultsCampaignItemBenchmarkIdGet200Response


## Properties

Name | Type | Description | Notes
------------ | ------------- | ------------- | -------------
**error** | [**ApiResponseError**](ApiResponseError.md) |  | [optional] 
**body** | [**List[ResultsCampaignItemBenchmarkIdGet200ResponseAllOfBodyInner]**](ResultsCampaignItemBenchmarkIdGet200ResponseAllOfBodyInner.md) |  | [optional] 

## Example

```python
from fab_clientlib.models.results_campaign_item_benchmark_id_get200_response import ResultsCampaignItemBenchmarkIdGet200Response

# TODO update the JSON string below
json = "{}"
# create an instance of ResultsCampaignItemBenchmarkIdGet200Response from a JSON string
results_campaign_item_benchmark_id_get200_response_instance = ResultsCampaignItemBenchmarkIdGet200Response.from_json(json)
# print the JSON string representation of the object
print(ResultsCampaignItemBenchmarkIdGet200Response.to_json())

# convert the object into a dict
results_campaign_item_benchmark_id_get200_response_dict = results_campaign_item_benchmark_id_get200_response_instance.to_dict()
# create an instance of ResultsCampaignItemBenchmarkIdGet200Response from a dict
results_campaign_item_benchmark_id_get200_response_from_dict = ResultsCampaignItemBenchmarkIdGet200Response.from_dict(results_campaign_item_benchmark_id_get200_response_dict)
```
[[Back to Model list]](../README.md#documentation-for-models) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to README]](../README.md)


