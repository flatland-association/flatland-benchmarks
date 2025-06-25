# ResultsSubmissionSubmissionIdTestsTestIdGet200Response


## Properties

 Name      | Type                                                                                                                                                            | Description | Notes      
-----------|-----------------------------------------------------------------------------------------------------------------------------------------------------------------|-------------|------------
 **error** | [**ApiResponseError**](ApiResponseError.md)                                                                                                                     |             | [optional] 
 **body**  | [**ResultsSubmissionSubmissionIdGet200ResponseAllOfBodyInnerTestScoringsInner**](ResultsSubmissionSubmissionIdGet200ResponseAllOfBodyInnerTestScoringsInner.md) |             | [optional] 

## Example

```python
from fab_clientlib.models.results_submission_submission_id_tests_test_id_get200_response import ResultsSubmissionSubmissionIdTestsTestIdGet200Response

# TODO update the JSON string below
json = "{}"
# create an instance of ResultsSubmissionSubmissionIdTestsTestIdGet200Response from a JSON string
results_submission_submission_id_tests_test_id_get200_response_instance = ResultsSubmissionSubmissionIdTestsTestIdGet200Response.from_json(json)
# print the JSON string representation of the object
print(ResultsSubmissionSubmissionIdTestsTestIdGet200Response.to_json())

# convert the object into a dict
results_submission_submission_id_tests_test_id_get200_response_dict = results_submission_submission_id_tests_test_id_get200_response_instance.to_dict()
# create an instance of ResultsSubmissionSubmissionIdTestsTestIdGet200Response from a dict
results_submission_submission_id_tests_test_id_get200_response_from_dict = ResultsSubmissionSubmissionIdTestsTestIdGet200Response.from_dict(results_submission_submission_id_tests_test_id_get200_response_dict)
```
[[Back to Model list]](../README.md#documentation-for-models) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to README]](../README.md)


