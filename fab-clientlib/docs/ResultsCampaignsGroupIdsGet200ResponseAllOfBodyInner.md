# ResultsCampaignsGroupIdsGet200ResponseAllOfBodyInner


## Properties

Name | Type | Description | Notes
------------ | ------------- | ------------- | -------------
**group_id** | **str** | ID of benchmark group. | [optional] 
**items** | [**List[ResultsCampaignsGroupIdsGet200ResponseAllOfBodyInnerItemsInner]**](ResultsCampaignsGroupIdsGet200ResponseAllOfBodyInnerItemsInner.md) |  | [optional] 

## Example

```python
from fab_clientlib.models.results_campaigns_group_ids_get200_response_all_of_body_inner import ResultsCampaignsGroupIdsGet200ResponseAllOfBodyInner

# TODO update the JSON string below
json = "{}"
# create an instance of ResultsCampaignsGroupIdsGet200ResponseAllOfBodyInner from a JSON string
results_campaigns_group_ids_get200_response_all_of_body_inner_instance = ResultsCampaignsGroupIdsGet200ResponseAllOfBodyInner.from_json(json)
# print the JSON string representation of the object
print(ResultsCampaignsGroupIdsGet200ResponseAllOfBodyInner.to_json())

# convert the object into a dict
results_campaigns_group_ids_get200_response_all_of_body_inner_dict = results_campaigns_group_ids_get200_response_all_of_body_inner_instance.to_dict()
# create an instance of ResultsCampaignsGroupIdsGet200ResponseAllOfBodyInner from a dict
results_campaigns_group_ids_get200_response_all_of_body_inner_from_dict = ResultsCampaignsGroupIdsGet200ResponseAllOfBodyInner.from_dict(results_campaigns_group_ids_get200_response_all_of_body_inner_dict)
```
[[Back to Model list]](../README.md#documentation-for-models) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to README]](../README.md)


