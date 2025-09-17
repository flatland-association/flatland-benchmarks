# ResultsSubmissionsSubmissionIdScenariosScenarioIdsGet200Response


## Properties

Name | Type | Description | Notes
------------ | ------------- | ------------- | -------------
**error** | [**ApiResponseError**](ApiResponseError.md) |  | [optional] 
**body** | [**List[ResultsSubmissionsSubmissionIdsGet200ResponseAllOfBodyInnerTestScoringsInnerScenarioScoringsInner]**](ResultsSubmissionsSubmissionIdsGet200ResponseAllOfBodyInnerTestScoringsInnerScenarioScoringsInner.md) |  | [optional] 

## Example

```python
from fab_clientlib.models.results_submissions_submission_id_scenarios_scenario_ids_get200_response import ResultsSubmissionsSubmissionIdScenariosScenarioIdsGet200Response

# TODO update the JSON string below
json = "{}"
# create an instance of ResultsSubmissionsSubmissionIdScenariosScenarioIdsGet200Response from a JSON string
results_submissions_submission_id_scenarios_scenario_ids_get200_response_instance = ResultsSubmissionsSubmissionIdScenariosScenarioIdsGet200Response.from_json(json)
# print the JSON string representation of the object
print(ResultsSubmissionsSubmissionIdScenariosScenarioIdsGet200Response.to_json())

# convert the object into a dict
results_submissions_submission_id_scenarios_scenario_ids_get200_response_dict = results_submissions_submission_id_scenarios_scenario_ids_get200_response_instance.to_dict()
# create an instance of ResultsSubmissionsSubmissionIdScenariosScenarioIdsGet200Response from a dict
results_submissions_submission_id_scenarios_scenario_ids_get200_response_from_dict = ResultsSubmissionsSubmissionIdScenariosScenarioIdsGet200Response.from_dict(results_submissions_submission_id_scenarios_scenario_ids_get200_response_dict)
```
[[Back to Model list]](../README.md#documentation-for-models) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to README]](../README.md)


