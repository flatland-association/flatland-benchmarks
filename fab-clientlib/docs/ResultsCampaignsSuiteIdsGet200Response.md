# ResultsCampaignsSuiteIdsGet200Response


## Properties

Name | Type | Description | Notes
------------ | ------------- | ------------- | -------------
**error** | [**ApiResponseError**](ApiResponseError.md) |  | [optional] 
**body** | [**List[ResultsCampaignsSuiteIdsGet200ResponseAllOfBodyInner]**](ResultsCampaignsSuiteIdsGet200ResponseAllOfBodyInner.md) |  | [optional] 

## Example

```python
from fab_clientlib.models.results_campaigns_suite_ids_get200_response import ResultsCampaignsSuiteIdsGet200Response

# TODO update the JSON string below
json = "{}"
# create an instance of ResultsCampaignsSuiteIdsGet200Response from a JSON string
results_campaigns_suite_ids_get200_response_instance = ResultsCampaignsSuiteIdsGet200Response.from_json(json)
# print the JSON string representation of the object
print(ResultsCampaignsSuiteIdsGet200Response.to_json())

# convert the object into a dict
results_campaigns_suite_ids_get200_response_dict = results_campaigns_suite_ids_get200_response_instance.to_dict()
# create an instance of ResultsCampaignsSuiteIdsGet200Response from a dict
results_campaigns_suite_ids_get200_response_from_dict = ResultsCampaignsSuiteIdsGet200Response.from_dict(results_campaigns_suite_ids_get200_response_dict)
```
[[Back to Model list]](../README.md#documentation-for-models) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to README]](../README.md)


