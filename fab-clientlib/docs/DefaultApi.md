# fab_clientlib.DefaultApi

All URIs are relative to *http://localhost*

Method | HTTP request | Description
------------- | ------------- | -------------
[**health_live_get**](DefaultApi.md#health_live_get) | **GET** /health/live | 
[**results_benchmarks_benchmark_id_get**](DefaultApi.md#results_benchmarks_benchmark_id_get) | **GET** /results/benchmarks/{benchmark_id} | 
[**results_campaign_items_benchmark_id_get**](DefaultApi.md#results_campaign_items_benchmark_id_get) | **GET** /results/campaign-items/{benchmark_id} | 
[**results_campaign_items_benchmark_id_tests_test_id_get**](DefaultApi.md#results_campaign_items_benchmark_id_tests_test_id_get) | **GET** /results/campaign-items/{benchmark_id}/tests/{test_id} | 
[**results_submissions_submission_id_get**](DefaultApi.md#results_submissions_submission_id_get) | **GET** /results/submissions/{submission_id} | 
[**results_submissions_submission_id_tests_test_id_get**](DefaultApi.md#results_submissions_submission_id_tests_test_id_get) | **GET** /results/submissions/{submission_id}/tests/{test_id} | 
[**results_submissions_submission_id_tests_test_id_post**](DefaultApi.md#results_submissions_submission_id_tests_test_id_post) | **POST** /results/submissions/{submission_id}/tests/{test_id} | 
[**results_submissions_submission_id_tests_test_id_scenario_scenario_id_get**](DefaultApi.md#results_submissions_submission_id_tests_test_id_scenario_scenario_id_get) | **GET** /results/submissions/{submission_id}/tests/{test_id}/scenario/{scenario_id} | 
[**submissions_get**](DefaultApi.md#submissions_get) | **GET** /submissions | 
[**submissions_post**](DefaultApi.md#submissions_post) | **POST** /submissions | 
[**submissions_uuid_get**](DefaultApi.md#submissions_uuid_get) | **GET** /submissions/{uuid} | 
[**tests_ids_get**](DefaultApi.md#tests_ids_get) | **GET** /tests/{ids} | 


# **health_live_get**
> HealthLiveGet200Response health_live_get()

Returns liveness.

### Example


```python
import fab_clientlib
from fab_clientlib.models.health_live_get200_response import HealthLiveGet200Response
from fab_clientlib.rest import ApiException
from pprint import pprint

# Defining the host is optional and defaults to http://localhost
# See configuration.py for a list of all supported configuration parameters.
configuration = fab_clientlib.Configuration(
    host = "http://localhost"
)


# Enter a context with an instance of the API client
with fab_clientlib.ApiClient(configuration) as api_client:
    # Create an instance of the API class
    api_instance = fab_clientlib.DefaultApi(api_client)

    try:
        api_response = api_instance.health_live_get()
        print("The response of DefaultApi->health_live_get:\n")
        pprint(api_response)
    except Exception as e:
        print("Exception when calling DefaultApi->health_live_get: %s\n" % e)
```



### Parameters

This endpoint does not need any parameter.

### Return type

[**HealthLiveGet200Response**](HealthLiveGet200Response.md)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

### HTTP response details

| Status code | Description | Response headers |
|-------------|-------------|------------------|
**200** | Live |  -  |

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **results_benchmarks_benchmark_id_get**
> ResultsBenchmarksBenchmarkIdGet200Response results_benchmarks_benchmark_id_get(benchmark_id)

Get benchmark leaderboard.

### Example

* OAuth Authentication (oauth2):

```python
import fab_clientlib
from fab_clientlib.models.results_benchmarks_benchmark_id_get200_response import ResultsBenchmarksBenchmarkIdGet200Response
from fab_clientlib.rest import ApiException
from pprint import pprint

# Defining the host is optional and defaults to http://localhost
# See configuration.py for a list of all supported configuration parameters.
configuration = fab_clientlib.Configuration(
    host = "http://localhost"
)

# The client must configure the authentication and authorization parameters
# in accordance with the API server security policy.
# Examples for each auth method are provided below, use the example that
# satisfies your auth use case.

configuration.access_token = os.environ["ACCESS_TOKEN"]

# Enter a context with an instance of the API client
with fab_clientlib.ApiClient(configuration) as api_client:
    # Create an instance of the API class
    api_instance = fab_clientlib.DefaultApi(api_client)
    benchmark_id = 'benchmark_id_example' # str | Benchmark ID.

    try:
        api_response = api_instance.results_benchmarks_benchmark_id_get(benchmark_id)
        print("The response of DefaultApi->results_benchmarks_benchmark_id_get:\n")
        pprint(api_response)
    except Exception as e:
        print("Exception when calling DefaultApi->results_benchmarks_benchmark_id_get: %s\n" % e)
```



### Parameters


Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **benchmark_id** | **str**| Benchmark ID. | 

### Return type

[**ResultsBenchmarksBenchmarkIdGet200Response**](ResultsBenchmarksBenchmarkIdGet200Response.md)

### Authorization

[oauth2](../README.md#oauth2)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

### HTTP response details

| Status code | Description | Response headers |
|-------------|-------------|------------------|
**200** | Benchmark leaderboard. |  -  |

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **results_campaign_items_benchmark_id_get**
> ResultsCampaignItemsBenchmarkIdGet200Response results_campaign_items_benchmark_id_get(benchmark_id)

Get campaign item leaderboard.

### Example

* OAuth Authentication (oauth2):

```python
import fab_clientlib
from fab_clientlib.models.results_campaign_items_benchmark_id_get200_response import ResultsCampaignItemsBenchmarkIdGet200Response
from fab_clientlib.rest import ApiException
from pprint import pprint

# Defining the host is optional and defaults to http://localhost
# See configuration.py for a list of all supported configuration parameters.
configuration = fab_clientlib.Configuration(
    host = "http://localhost"
)

# The client must configure the authentication and authorization parameters
# in accordance with the API server security policy.
# Examples for each auth method are provided below, use the example that
# satisfies your auth use case.

configuration.access_token = os.environ["ACCESS_TOKEN"]

# Enter a context with an instance of the API client
with fab_clientlib.ApiClient(configuration) as api_client:
    # Create an instance of the API class
    api_instance = fab_clientlib.DefaultApi(api_client)
    benchmark_id = 'benchmark_id_example' # str | Benchmark ID.

    try:
        api_response = api_instance.results_campaign_items_benchmark_id_get(benchmark_id)
        print("The response of DefaultApi->results_campaign_items_benchmark_id_get:\n")
        pprint(api_response)
    except Exception as e:
        print("Exception when calling DefaultApi->results_campaign_items_benchmark_id_get: %s\n" % e)
```



### Parameters


Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **benchmark_id** | **str**| Benchmark ID. | 

### Return type

[**ResultsCampaignItemsBenchmarkIdGet200Response**](ResultsCampaignItemsBenchmarkIdGet200Response.md)

### Authorization

[oauth2](../README.md#oauth2)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

### HTTP response details

| Status code | Description | Response headers |
|-------------|-------------|------------------|
**200** | Campaign item leaderboard. |  -  |

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **results_campaign_items_benchmark_id_tests_test_id_get**
> ResultsBenchmarksBenchmarkIdGet200Response results_campaign_items_benchmark_id_tests_test_id_get(benchmark_id, test_id)

Get campaign item test leaderboard.

### Example

* OAuth Authentication (oauth2):

```python
import fab_clientlib
from fab_clientlib.models.results_benchmarks_benchmark_id_get200_response import ResultsBenchmarksBenchmarkIdGet200Response
from fab_clientlib.rest import ApiException
from pprint import pprint

# Defining the host is optional and defaults to http://localhost
# See configuration.py for a list of all supported configuration parameters.
configuration = fab_clientlib.Configuration(
    host = "http://localhost"
)

# The client must configure the authentication and authorization parameters
# in accordance with the API server security policy.
# Examples for each auth method are provided below, use the example that
# satisfies your auth use case.

configuration.access_token = os.environ["ACCESS_TOKEN"]

# Enter a context with an instance of the API client
with fab_clientlib.ApiClient(configuration) as api_client:
    # Create an instance of the API class
    api_instance = fab_clientlib.DefaultApi(api_client)
    benchmark_id = 'benchmark_id_example' # str | Benchmark ID.
    test_id = 'test_id_example' # str | Test ID.

    try:
        api_response = api_instance.results_campaign_items_benchmark_id_tests_test_id_get(benchmark_id, test_id)
        print("The response of DefaultApi->results_campaign_items_benchmark_id_tests_test_id_get:\n")
        pprint(api_response)
    except Exception as e:
        print("Exception when calling DefaultApi->results_campaign_items_benchmark_id_tests_test_id_get: %s\n" % e)
```



### Parameters


Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **benchmark_id** | **str**| Benchmark ID. | 
 **test_id** | **str**| Test ID. | 

### Return type

[**ResultsBenchmarksBenchmarkIdGet200Response**](ResultsBenchmarksBenchmarkIdGet200Response.md)

### Authorization

[oauth2](../README.md#oauth2)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

### HTTP response details

| Status code | Description | Response headers |
|-------------|-------------|------------------|
**200** | campaign item test leaderboard. |  -  |

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **results_submissions_submission_id_get**
> ResultsSubmissionsSubmissionIdGet200Response results_submissions_submission_id_get(submission_id)

Get aggregated submission overall results.

### Example

* OAuth Authentication (oauth2):

```python
import fab_clientlib
from fab_clientlib.models.results_submissions_submission_id_get200_response import ResultsSubmissionsSubmissionIdGet200Response
from fab_clientlib.rest import ApiException
from pprint import pprint

# Defining the host is optional and defaults to http://localhost
# See configuration.py for a list of all supported configuration parameters.
configuration = fab_clientlib.Configuration(
    host = "http://localhost"
)

# The client must configure the authentication and authorization parameters
# in accordance with the API server security policy.
# Examples for each auth method are provided below, use the example that
# satisfies your auth use case.

configuration.access_token = os.environ["ACCESS_TOKEN"]

# Enter a context with an instance of the API client
with fab_clientlib.ApiClient(configuration) as api_client:
    # Create an instance of the API class
    api_instance = fab_clientlib.DefaultApi(api_client)
    submission_id = 'submission_id_example' # str | Submission ID.

    try:
        api_response = api_instance.results_submissions_submission_id_get(submission_id)
        print("The response of DefaultApi->results_submissions_submission_id_get:\n")
        pprint(api_response)
    except Exception as e:
        print("Exception when calling DefaultApi->results_submissions_submission_id_get: %s\n" % e)
```



### Parameters


Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **submission_id** | **str**| Submission ID. | 

### Return type

[**ResultsSubmissionsSubmissionIdGet200Response**](ResultsSubmissionsSubmissionIdGet200Response.md)

### Authorization

[oauth2](../README.md#oauth2)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

### HTTP response details

| Status code | Description | Response headers |
|-------------|-------------|------------------|
**200** | Aggregated submission overall results. |  -  |

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **results_submissions_submission_id_tests_test_id_get**
> ResultsSubmissionsSubmissionIdTestsTestIdGet200Response results_submissions_submission_id_tests_test_id_get(submission_id, test_id)

Get submission results aggregated by test.

### Example

* OAuth Authentication (oauth2):

```python
import fab_clientlib
from fab_clientlib.models.results_submissions_submission_id_tests_test_id_get200_response import ResultsSubmissionsSubmissionIdTestsTestIdGet200Response
from fab_clientlib.rest import ApiException
from pprint import pprint

# Defining the host is optional and defaults to http://localhost
# See configuration.py for a list of all supported configuration parameters.
configuration = fab_clientlib.Configuration(
    host = "http://localhost"
)

# The client must configure the authentication and authorization parameters
# in accordance with the API server security policy.
# Examples for each auth method are provided below, use the example that
# satisfies your auth use case.

configuration.access_token = os.environ["ACCESS_TOKEN"]

# Enter a context with an instance of the API client
with fab_clientlib.ApiClient(configuration) as api_client:
    # Create an instance of the API class
    api_instance = fab_clientlib.DefaultApi(api_client)
    submission_id = 'submission_id_example' # str | Submission ID.
    test_id = 'test_id_example' # str | Test ID.

    try:
        api_response = api_instance.results_submissions_submission_id_tests_test_id_get(submission_id, test_id)
        print("The response of DefaultApi->results_submissions_submission_id_tests_test_id_get:\n")
        pprint(api_response)
    except Exception as e:
        print("Exception when calling DefaultApi->results_submissions_submission_id_tests_test_id_get: %s\n" % e)
```



### Parameters


Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **submission_id** | **str**| Submission ID. | 
 **test_id** | **str**| Test ID. | 

### Return type

[**ResultsSubmissionsSubmissionIdTestsTestIdGet200Response**](ResultsSubmissionsSubmissionIdTestsTestIdGet200Response.md)

### Authorization

[oauth2](../README.md#oauth2)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

### HTTP response details

| Status code | Description | Response headers |
|-------------|-------------|------------------|
**200** | Submission results aggregated by test. |  -  |

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **results_submissions_submission_id_tests_test_id_post**
> ApiResponse results_submissions_submission_id_tests_test_id_post(submission_id, test_id, results_submissions_submission_id_tests_test_id_post_request)

Inserts test results

### Example

* OAuth Authentication (oauth2):

```python
import fab_clientlib
from fab_clientlib.models.api_response import ApiResponse
from fab_clientlib.models.results_submissions_submission_id_tests_test_id_post_request import ResultsSubmissionsSubmissionIdTestsTestIdPostRequest
from fab_clientlib.rest import ApiException
from pprint import pprint

# Defining the host is optional and defaults to http://localhost
# See configuration.py for a list of all supported configuration parameters.
configuration = fab_clientlib.Configuration(
    host = "http://localhost"
)

# The client must configure the authentication and authorization parameters
# in accordance with the API server security policy.
# Examples for each auth method are provided below, use the example that
# satisfies your auth use case.

configuration.access_token = os.environ["ACCESS_TOKEN"]

# Enter a context with an instance of the API client
with fab_clientlib.ApiClient(configuration) as api_client:
    # Create an instance of the API class
    api_instance = fab_clientlib.DefaultApi(api_client)
    submission_id = 'submission_id_example' # str | Submission ID.
    test_id = 'test_id_example' # str | Test ID.
    results_submissions_submission_id_tests_test_id_post_request = fab_clientlib.ResultsSubmissionsSubmissionIdTestsTestIdPostRequest() # ResultsSubmissionsSubmissionIdTestsTestIdPostRequest | 

    try:
        api_response = api_instance.results_submissions_submission_id_tests_test_id_post(submission_id, test_id, results_submissions_submission_id_tests_test_id_post_request)
        print("The response of DefaultApi->results_submissions_submission_id_tests_test_id_post:\n")
        pprint(api_response)
    except Exception as e:
        print("Exception when calling DefaultApi->results_submissions_submission_id_tests_test_id_post: %s\n" % e)
```



### Parameters


Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **submission_id** | **str**| Submission ID. | 
 **test_id** | **str**| Test ID. | 
 **results_submissions_submission_id_tests_test_id_post_request** | [**ResultsSubmissionsSubmissionIdTestsTestIdPostRequest**](ResultsSubmissionsSubmissionIdTestsTestIdPostRequest.md)|  | 

### Return type

[**ApiResponse**](ApiResponse.md)

### Authorization

[oauth2](../README.md#oauth2)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

### HTTP response details

| Status code | Description | Response headers |
|-------------|-------------|------------------|
**200** | All results inserted. |  -  |
**400** | Some results could not be inserted, transaction aborted. |  -  |

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **results_submissions_submission_id_tests_test_id_scenario_scenario_id_get**
> ResultsSubmissionsSubmissionIdTestsTestIdScenarioScenarioIdGet200Response results_submissions_submission_id_tests_test_id_scenario_scenario_id_get(submission_id, test_id, scenario_id)

Get submission results for specific scenario.

### Example

* OAuth Authentication (oauth2):

```python
import fab_clientlib
from fab_clientlib.models.results_submissions_submission_id_tests_test_id_scenario_scenario_id_get200_response import ResultsSubmissionsSubmissionIdTestsTestIdScenarioScenarioIdGet200Response
from fab_clientlib.rest import ApiException
from pprint import pprint

# Defining the host is optional and defaults to http://localhost
# See configuration.py for a list of all supported configuration parameters.
configuration = fab_clientlib.Configuration(
    host = "http://localhost"
)

# The client must configure the authentication and authorization parameters
# in accordance with the API server security policy.
# Examples for each auth method are provided below, use the example that
# satisfies your auth use case.

configuration.access_token = os.environ["ACCESS_TOKEN"]

# Enter a context with an instance of the API client
with fab_clientlib.ApiClient(configuration) as api_client:
    # Create an instance of the API class
    api_instance = fab_clientlib.DefaultApi(api_client)
    submission_id = 'submission_id_example' # str | Submission ID.
    test_id = 'test_id_example' # str | Test ID.
    scenario_id = 'scenario_id_example' # str | Scenario ID.

    try:
        api_response = api_instance.results_submissions_submission_id_tests_test_id_scenario_scenario_id_get(submission_id, test_id, scenario_id)
        print("The response of DefaultApi->results_submissions_submission_id_tests_test_id_scenario_scenario_id_get:\n")
        pprint(api_response)
    except Exception as e:
        print("Exception when calling DefaultApi->results_submissions_submission_id_tests_test_id_scenario_scenario_id_get: %s\n" % e)
```



### Parameters


Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **submission_id** | **str**| Submission ID. | 
 **test_id** | **str**| Test ID. | 
 **scenario_id** | **str**| Scenario ID. | 

### Return type

[**ResultsSubmissionsSubmissionIdTestsTestIdScenarioScenarioIdGet200Response**](ResultsSubmissionsSubmissionIdTestsTestIdScenarioScenarioIdGet200Response.md)

### Authorization

[oauth2](../README.md#oauth2)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

### HTTP response details

| Status code | Description | Response headers |
|-------------|-------------|------------------|
**200** | Submission results for specific scenario. |  -  |

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **submissions_get**
> SubmissionsGet200Response submissions_get(benchmark=benchmark, submitted_by=submitted_by)

Lists all published submissions.

### Example

* OAuth Authentication (oauth2):

```python
import fab_clientlib
from fab_clientlib.models.submissions_get200_response import SubmissionsGet200Response
from fab_clientlib.rest import ApiException
from pprint import pprint

# Defining the host is optional and defaults to http://localhost
# See configuration.py for a list of all supported configuration parameters.
configuration = fab_clientlib.Configuration(
    host = "http://localhost"
)

# The client must configure the authentication and authorization parameters
# in accordance with the API server security policy.
# Examples for each auth method are provided below, use the example that
# satisfies your auth use case.

configuration.access_token = os.environ["ACCESS_TOKEN"]

# Enter a context with an instance of the API client
with fab_clientlib.ApiClient(configuration) as api_client:
    # Create an instance of the API class
    api_instance = fab_clientlib.DefaultApi(api_client)
    benchmark = 'benchmark_example' # str | Filter submissions by benchmark. (optional)
    submitted_by = 'submitted_by_example' # str | Filter submissions by user. If this equals the authenticated user, un-published submissions will be listed too. (optional)

    try:
        api_response = api_instance.submissions_get(benchmark=benchmark, submitted_by=submitted_by)
        print("The response of DefaultApi->submissions_get:\n")
        pprint(api_response)
    except Exception as e:
        print("Exception when calling DefaultApi->submissions_get: %s\n" % e)
```



### Parameters


Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **benchmark** | **str**| Filter submissions by benchmark. | [optional] 
 **submitted_by** | **str**| Filter submissions by user. If this equals the authenticated user, un-published submissions will be listed too. | [optional] 

### Return type

[**SubmissionsGet200Response**](SubmissionsGet200Response.md)

### Authorization

[oauth2](../README.md#oauth2)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

### HTTP response details

| Status code | Description | Response headers |
|-------------|-------------|------------------|
**200** | Requested submissions. |  -  |

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **submissions_post**
> SubmissionsPost200Response submissions_post(submissions_post_request)

Inserts new submission.

### Example

* OAuth Authentication (oauth2):

```python
import fab_clientlib
from fab_clientlib.models.submissions_post200_response import SubmissionsPost200Response
from fab_clientlib.models.submissions_post_request import SubmissionsPostRequest
from fab_clientlib.rest import ApiException
from pprint import pprint

# Defining the host is optional and defaults to http://localhost
# See configuration.py for a list of all supported configuration parameters.
configuration = fab_clientlib.Configuration(
    host = "http://localhost"
)

# The client must configure the authentication and authorization parameters
# in accordance with the API server security policy.
# Examples for each auth method are provided below, use the example that
# satisfies your auth use case.

configuration.access_token = os.environ["ACCESS_TOKEN"]

# Enter a context with an instance of the API client
with fab_clientlib.ApiClient(configuration) as api_client:
    # Create an instance of the API class
    api_instance = fab_clientlib.DefaultApi(api_client)
    submissions_post_request = fab_clientlib.SubmissionsPostRequest() # SubmissionsPostRequest | 

    try:
        api_response = api_instance.submissions_post(submissions_post_request)
        print("The response of DefaultApi->submissions_post:\n")
        pprint(api_response)
    except Exception as e:
        print("Exception when calling DefaultApi->submissions_post: %s\n" % e)
```



### Parameters


Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **submissions_post_request** | [**SubmissionsPostRequest**](SubmissionsPostRequest.md)|  | 

### Return type

[**SubmissionsPost200Response**](SubmissionsPost200Response.md)

### Authorization

[oauth2](../README.md#oauth2)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

### HTTP response details

| Status code | Description | Response headers |
|-------------|-------------|------------------|
**200** | Created. |  -  |

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **submissions_uuid_get**
> SubmissionsGet200Response submissions_uuid_get(uuid)

### Example

* OAuth Authentication (oauth2):

```python
import fab_clientlib
from fab_clientlib.models.submissions_get200_response import SubmissionsGet200Response
from fab_clientlib.rest import ApiException
from pprint import pprint

# Defining the host is optional and defaults to http://localhost
# See configuration.py for a list of all supported configuration parameters.
configuration = fab_clientlib.Configuration(
    host = "http://localhost"
)

# The client must configure the authentication and authorization parameters
# in accordance with the API server security policy.
# Examples for each auth method are provided below, use the example that
# satisfies your auth use case.

configuration.access_token = os.environ["ACCESS_TOKEN"]

# Enter a context with an instance of the API client
with fab_clientlib.ApiClient(configuration) as api_client:
    # Create an instance of the API class
    api_instance = fab_clientlib.DefaultApi(api_client)
    uuid = 'uuid_example' # str | The submission ID

    try:
        api_response = api_instance.submissions_uuid_get(uuid)
        print("The response of DefaultApi->submissions_uuid_get:\n")
        pprint(api_response)
    except Exception as e:
        print("Exception when calling DefaultApi->submissions_uuid_get: %s\n" % e)
```



### Parameters


Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **uuid** | **str**| The submission ID | 

### Return type

[**SubmissionsGet200Response**](SubmissionsGet200Response.md)

### Authorization

[oauth2](../README.md#oauth2)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

### HTTP response details

| Status code | Description | Response headers |
|-------------|-------------|------------------|
**200** | Requested submissions. |  -  |

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **tests_ids_get**
> TestsIdsGet200Response tests_ids_get(ids)

Returns tests with ID in `ids`.

### Example

* OAuth Authentication (oauth2):

```python
import fab_clientlib
from fab_clientlib.models.tests_ids_get200_response import TestsIdsGet200Response
from fab_clientlib.rest import ApiException
from pprint import pprint

# Defining the host is optional and defaults to http://localhost
# See configuration.py for a list of all supported configuration parameters.
configuration = fab_clientlib.Configuration(
    host = "http://localhost"
)

# The client must configure the authentication and authorization parameters
# in accordance with the API server security policy.
# Examples for each auth method are provided below, use the example that
# satisfies your auth use case.

configuration.access_token = os.environ["ACCESS_TOKEN"]

# Enter a context with an instance of the API client
with fab_clientlib.ApiClient(configuration) as api_client:
    # Create an instance of the API class
    api_instance = fab_clientlib.DefaultApi(api_client)
    ids = [56] # List[int] | Comma-separated list of IDs.

    try:
        api_response = api_instance.tests_ids_get(ids)
        print("The response of DefaultApi->tests_ids_get:\n")
        pprint(api_response)
    except Exception as e:
        print("Exception when calling DefaultApi->tests_ids_get: %s\n" % e)
```



### Parameters


Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **ids** | [**List[int]**](int.md)| Comma-separated list of IDs. | 

### Return type

[**TestsIdsGet200Response**](TestsIdsGet200Response.md)

### Authorization

[oauth2](../README.md#oauth2)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

### HTTP response details

| Status code | Description | Response headers |
|-------------|-------------|------------------|
**200** | Requested tests. |  -  |

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

