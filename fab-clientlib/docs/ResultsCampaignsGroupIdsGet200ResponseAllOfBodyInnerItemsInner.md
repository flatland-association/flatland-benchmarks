# ResultsCampaignsGroupIdsGet200ResponseAllOfBodyInnerItemsInner


## Properties

Name | Type | Description | Notes
------------ | ------------- | ------------- | -------------
**benchmark_id** | **str** | ID of benchmark. | [optional] 
**items** | [**List[ResultsCampaignItemsBenchmarkIdsGet200ResponseAllOfBodyInnerItemsInner]**](ResultsCampaignItemsBenchmarkIdsGet200ResponseAllOfBodyInnerItemsInner.md) |  | [optional] 
**scorings** | [**List[Scoring]**](Scoring.md) | Campaign item scores. | [optional] 

## Example

```python
from fab_clientlib.models.results_campaigns_group_ids_get200_response_all_of_body_inner_items_inner import ResultsCampaignsGroupIdsGet200ResponseAllOfBodyInnerItemsInner

# TODO update the JSON string below
json = "{}"
# create an instance of ResultsCampaignsGroupIdsGet200ResponseAllOfBodyInnerItemsInner from a JSON string
results_campaigns_group_ids_get200_response_all_of_body_inner_items_inner_instance = ResultsCampaignsGroupIdsGet200ResponseAllOfBodyInnerItemsInner.from_json(json)
# print the JSON string representation of the object
print(ResultsCampaignsGroupIdsGet200ResponseAllOfBodyInnerItemsInner.to_json())

# convert the object into a dict
results_campaigns_group_ids_get200_response_all_of_body_inner_items_inner_dict = results_campaigns_group_ids_get200_response_all_of_body_inner_items_inner_instance.to_dict()
# create an instance of ResultsCampaignsGroupIdsGet200ResponseAllOfBodyInnerItemsInner from a dict
results_campaigns_group_ids_get200_response_all_of_body_inner_items_inner_from_dict = ResultsCampaignsGroupIdsGet200ResponseAllOfBodyInnerItemsInner.from_dict(results_campaigns_group_ids_get200_response_all_of_body_inner_items_inner_dict)
```
[[Back to Model list]](../README.md#documentation-for-models) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to README]](../README.md)


