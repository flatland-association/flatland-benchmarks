# HealthLiveGet200Response


## Properties

Name | Type | Description | Notes
------------ | ------------- | ------------- | -------------
**error** | [**ApiResponseError**](ApiResponseError.md) |  | [optional] 
**body** | [**HealthLiveGet200ResponseAllOfBody**](HealthLiveGet200ResponseAllOfBody.md) |  | [optional] 
**checks** | [**List[HealthLiveGet200ResponseAllOfChecksInner]**](HealthLiveGet200ResponseAllOfChecksInner.md) |  | [optional] 

## Example

```python
from fab_clientlib.models.health_live_get200_response import HealthLiveGet200Response

# TODO update the JSON string below
json = "{}"
# create an instance of HealthLiveGet200Response from a JSON string
health_live_get200_response_instance = HealthLiveGet200Response.from_json(json)
# print the JSON string representation of the object
print(HealthLiveGet200Response.to_json())

# convert the object into a dict
health_live_get200_response_dict = health_live_get200_response_instance.to_dict()
# create an instance of HealthLiveGet200Response from a dict
health_live_get200_response_from_dict = HealthLiveGet200Response.from_dict(health_live_get200_response_dict)
```
[[Back to Model list]](../README.md#documentation-for-models) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to README]](../README.md)


