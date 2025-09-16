# DefinitionsScenariosScenarioIdsGet200Response


## Properties

Name | Type | Description | Notes
------------ | ------------- | ------------- | -------------
**error** | [**ApiResponseError**](ApiResponseError.md) |  | [optional] 
**body** | [**List[DefinitionsScenariosScenarioIdsGet200ResponseAllOfBodyInner]**](DefinitionsScenariosScenarioIdsGet200ResponseAllOfBodyInner.md) |  | [optional] 

## Example

```python
from fab_clientlib.models.definitions_scenarios_scenario_ids_get200_response import DefinitionsScenariosScenarioIdsGet200Response

# TODO update the JSON string below
json = "{}"
# create an instance of DefinitionsScenariosScenarioIdsGet200Response from a JSON string
definitions_scenarios_scenario_ids_get200_response_instance = DefinitionsScenariosScenarioIdsGet200Response.from_json(json)
# print the JSON string representation of the object
print(DefinitionsScenariosScenarioIdsGet200Response.to_json())

# convert the object into a dict
definitions_scenarios_scenario_ids_get200_response_dict = definitions_scenarios_scenario_ids_get200_response_instance.to_dict()
# create an instance of DefinitionsScenariosScenarioIdsGet200Response from a dict
definitions_scenarios_scenario_ids_get200_response_from_dict = DefinitionsScenariosScenarioIdsGet200Response.from_dict(definitions_scenarios_scenario_ids_get200_response_dict)
```
[[Back to Model list]](../README.md#documentation-for-models) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to README]](../README.md)


