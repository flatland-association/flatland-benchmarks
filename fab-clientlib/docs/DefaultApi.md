# fab_clientlib.DefaultApi

All URIs are relative to *http://localhost*

Method | HTTP request | Description
------------- | ------------- | -------------
[**benchmark_groups_get**](DefaultApi.md#benchmark_groups_get) | **GET** /benchmark-groups | 
[**benchmark_groups_group_ids_get**](DefaultApi.md#benchmark_groups_group_ids_get) | **GET** /benchmark-groups/{group_ids} | 
[**definitions_benchmarks_benchmark_ids_get**](DefaultApi.md#definitions_benchmarks_benchmark_ids_get) | **GET** /definitions/benchmarks/{benchmark_ids} | 
[**definitions_benchmarks_get**](DefaultApi.md#definitions_benchmarks_get) | **GET** /definitions/benchmarks/ | 
[**definitions_tests_test_ids_get**](DefaultApi.md#definitions_tests_test_ids_get) | **GET** /definitions/tests/{test_ids} | 
[**health_live_get**](DefaultApi.md#health_live_get) | **GET** /health/live | 
[**results_benchmarks_benchmark_id_tests_test_ids_get**](DefaultApi.md#results_benchmarks_benchmark_id_tests_test_ids_get) | **GET** /results/benchmarks/{benchmark_id}/tests/{test_ids} | 
[**results_benchmarks_benchmark_ids_get**](DefaultApi.md#results_benchmarks_benchmark_ids_get) | **GET** /results/benchmarks/{benchmark_ids} | 
[**results_campaign_items_benchmark_ids_get**](DefaultApi.md#results_campaign_items_benchmark_ids_get) | **GET** /results/campaign-items/{benchmark_ids} | 
[**results_campaigns_group_ids_get**](DefaultApi.md#results_campaigns_group_ids_get) | **GET** /results/campaigns/{group_ids} | 
[**results_submissions_submission_id_scenario_scenario_ids_get**](DefaultApi.md#results_submissions_submission_id_scenario_scenario_ids_get) | **GET** /results/submissions/{submission_id}/scenario/{scenario_ids} | 
[**results_submissions_submission_id_tests_test_ids_get**](DefaultApi.md#results_submissions_submission_id_tests_test_ids_get) | **GET** /results/submissions/{submission_id}/tests/{test_ids} | 
[**results_submissions_submission_id_tests_test_ids_post**](DefaultApi.md#results_submissions_submission_id_tests_test_ids_post) | **POST** /results/submissions/{submission_id}/tests/{test_ids} | 
[**results_submissions_submission_ids_get**](DefaultApi.md#results_submissions_submission_ids_get) | **GET** /results/submissions/{submission_ids} | 
[**submissions_get**](DefaultApi.md#submissions_get) | **GET** /submissions | 
[**submissions_post**](DefaultApi.md#submissions_post) | **POST** /submissions | 
[**submissions_submission_ids_get**](DefaultApi.md#submissions_submission_ids_get) | **GET** /submissions/{submission_ids} | 
[**submissions_submission_ids_patch**](DefaultApi.md#submissions_submission_ids_patch) | **PATCH** /submissions/{submission_ids} | 


# **benchmark_groups_get**
> BenchmarkGroupsGet200Response benchmark_groups_get()

Lists benchmark-groups.

### Example


```python
import fab_clientlib
from fab_clientlib.models.benchmark_groups_get200_response import BenchmarkGroupsGet200Response
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
        api_response = api_instance.benchmark_groups_get()
        print("The response of DefaultApi->benchmark_groups_get:\n")
        pprint(api_response)
    except Exception as e:
        print("Exception when calling DefaultApi->benchmark_groups_get: %s\n" % e)
```



### Parameters

This endpoint does not need any parameter.

### Return type

[**BenchmarkGroupsGet200Response**](BenchmarkGroupsGet200Response.md)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

### HTTP response details

| Status code | Description | Response headers |
|-------------|-------------|------------------|
**200** | List of benchmark-groups. |  -  |

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **benchmark_groups_group_ids_get**
> BenchmarkGroupsGet200Response benchmark_groups_group_ids_get(group_ids)

Returns benchmark-groups with ID in `group_id`.

### Example


```python
import fab_clientlib
from fab_clientlib.models.benchmark_groups_get200_response import BenchmarkGroupsGet200Response
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
    group_ids = ['group_ids_example'] # List[str] | Comma-separated list of IDs.

    try:
        api_response = api_instance.benchmark_groups_group_ids_get(group_ids)
        print("The response of DefaultApi->benchmark_groups_group_ids_get:\n")
        pprint(api_response)
    except Exception as e:
        print("Exception when calling DefaultApi->benchmark_groups_group_ids_get: %s\n" % e)
```



### Parameters


Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **group_ids** | [**List[str]**](str.md)| Comma-separated list of IDs. | 

### Return type

[**BenchmarkGroupsGet200Response**](BenchmarkGroupsGet200Response.md)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

### HTTP response details

| Status code | Description | Response headers |
|-------------|-------------|------------------|
**200** | Requested benchmark-groups. |  -  |

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **definitions_benchmarks_benchmark_ids_get**
> DefinitionsBenchmarksGet200Response definitions_benchmarks_benchmark_ids_get(benchmark_ids)

Returns tests with ID in `ids`.

### Example

* OAuth Authentication (oauth2):

```python
import fab_clientlib
from fab_clientlib.models.definitions_benchmarks_get200_response import DefinitionsBenchmarksGet200Response
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
    benchmark_ids = ['benchmark_ids_example'] # List[str] | Comma-separated list of IDs.

    try:
        api_response = api_instance.definitions_benchmarks_benchmark_ids_get(benchmark_ids)
        print("The response of DefaultApi->definitions_benchmarks_benchmark_ids_get:\n")
        pprint(api_response)
    except Exception as e:
        print("Exception when calling DefaultApi->definitions_benchmarks_benchmark_ids_get: %s\n" % e)
```



### Parameters


Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **benchmark_ids** | [**List[str]**](str.md)| Comma-separated list of IDs. | 

### Return type

[**DefinitionsBenchmarksGet200Response**](DefinitionsBenchmarksGet200Response.md)

### Authorization

[oauth2](../README.md#oauth2)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

### HTTP response details

| Status code | Description | Response headers |
|-------------|-------------|------------------|
**200** | Requested benchmarks. |  -  |

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **definitions_benchmarks_get**
> DefinitionsBenchmarksGet200Response definitions_benchmarks_get()

Returns benchmarks.

### Example

* OAuth Authentication (oauth2):

```python
import fab_clientlib
from fab_clientlib.models.definitions_benchmarks_get200_response import DefinitionsBenchmarksGet200Response
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

    try:
        api_response = api_instance.definitions_benchmarks_get()
        print("The response of DefaultApi->definitions_benchmarks_get:\n")
        pprint(api_response)
    except Exception as e:
        print("Exception when calling DefaultApi->definitions_benchmarks_get: %s\n" % e)
```



### Parameters

This endpoint does not need any parameter.

### Return type

[**DefinitionsBenchmarksGet200Response**](DefinitionsBenchmarksGet200Response.md)

### Authorization

[oauth2](../README.md#oauth2)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

### HTTP response details

| Status code | Description | Response headers |
|-------------|-------------|------------------|
**200** | Benchmarks. |  -  |

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **definitions_tests_test_ids_get**
> DefinitionsTestsTestIdsGet200Response definitions_tests_test_ids_get(test_ids)

Returns tests with ID in `ids`.

### Example

* OAuth Authentication (oauth2):

```python
import fab_clientlib
from fab_clientlib.models.definitions_tests_test_ids_get200_response import DefinitionsTestsTestIdsGet200Response
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
    test_ids = ['test_ids_example'] # List[str] | Comma-separated list of IDs.

    try:
        api_response = api_instance.definitions_tests_test_ids_get(test_ids)
        print("The response of DefaultApi->definitions_tests_test_ids_get:\n")
        pprint(api_response)
    except Exception as e:
        print("Exception when calling DefaultApi->definitions_tests_test_ids_get: %s\n" % e)
```



### Parameters


Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **test_ids** | [**List[str]**](str.md)| Comma-separated list of IDs. | 

### Return type

[**DefinitionsTestsTestIdsGet200Response**](DefinitionsTestsTestIdsGet200Response.md)

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

# **results_benchmarks_benchmark_id_tests_test_ids_get**
> ResultsBenchmarksBenchmarkIdsGet200Response results_benchmarks_benchmark_id_tests_test_ids_get(benchmark_id, test_ids)

Get test leaderboard.

### Example

* OAuth Authentication (oauth2):

```python
import fab_clientlib
from fab_clientlib.models.results_benchmarks_benchmark_ids_get200_response import ResultsBenchmarksBenchmarkIdsGet200Response
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
    test_ids = ['test_ids_example'] # List[str] | Comma-separated list of test IDs.

    try:
        api_response = api_instance.results_benchmarks_benchmark_id_tests_test_ids_get(benchmark_id, test_ids)
        print("The response of DefaultApi->results_benchmarks_benchmark_id_tests_test_ids_get:\n")
        pprint(api_response)
    except Exception as e:
        print("Exception when calling DefaultApi->results_benchmarks_benchmark_id_tests_test_ids_get: %s\n" % e)
```



### Parameters


Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **benchmark_id** | **str**| Benchmark ID. | 
 **test_ids** | [**List[str]**](str.md)| Comma-separated list of test IDs. | 

### Return type

[**ResultsBenchmarksBenchmarkIdsGet200Response**](ResultsBenchmarksBenchmarkIdsGet200Response.md)

### Authorization

[oauth2](../README.md#oauth2)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

### HTTP response details

| Status code | Description | Response headers |
|-------------|-------------|------------------|
**200** | test leaderboard. |  -  |

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **results_benchmarks_benchmark_ids_get**
> ResultsBenchmarksBenchmarkIdsGet200Response results_benchmarks_benchmark_ids_get(benchmark_ids)

Get benchmark leaderboard.

### Example

* OAuth Authentication (oauth2):

```python
import fab_clientlib
from fab_clientlib.models.results_benchmarks_benchmark_ids_get200_response import ResultsBenchmarksBenchmarkIdsGet200Response
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
    benchmark_ids = ['benchmark_ids_example'] # List[str] | Comma-separated list of benchmark IDs.

    try:
        api_response = api_instance.results_benchmarks_benchmark_ids_get(benchmark_ids)
        print("The response of DefaultApi->results_benchmarks_benchmark_ids_get:\n")
        pprint(api_response)
    except Exception as e:
        print("Exception when calling DefaultApi->results_benchmarks_benchmark_ids_get: %s\n" % e)
```



### Parameters


Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **benchmark_ids** | [**List[str]**](str.md)| Comma-separated list of benchmark IDs. | 

### Return type

[**ResultsBenchmarksBenchmarkIdsGet200Response**](ResultsBenchmarksBenchmarkIdsGet200Response.md)

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

# **results_campaign_items_benchmark_ids_get**
> ResultsCampaignItemsBenchmarkIdsGet200Response results_campaign_items_benchmark_ids_get(benchmark_ids)

Returns campaign-item overviews (i.e. all tests in benchmark with score of top submission per test).

### Example

* OAuth Authentication (oauth2):

```python
import fab_clientlib
from fab_clientlib.models.results_campaign_items_benchmark_ids_get200_response import ResultsCampaignItemsBenchmarkIdsGet200Response
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
    benchmark_ids = ['benchmark_ids_example'] # List[str] | Comma-separated list of benchmark IDs.

    try:
        api_response = api_instance.results_campaign_items_benchmark_ids_get(benchmark_ids)
        print("The response of DefaultApi->results_campaign_items_benchmark_ids_get:\n")
        pprint(api_response)
    except Exception as e:
        print("Exception when calling DefaultApi->results_campaign_items_benchmark_ids_get: %s\n" % e)
```



### Parameters


Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **benchmark_ids** | [**List[str]**](str.md)| Comma-separated list of benchmark IDs. | 

### Return type

[**ResultsCampaignItemsBenchmarkIdsGet200Response**](ResultsCampaignItemsBenchmarkIdsGet200Response.md)

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

# **results_campaigns_group_ids_get**
> ResultsCampaignsGroupIdsGet200Response results_campaigns_group_ids_get(group_ids)

Returns campaign overviews (i.e. all benchmarks in the group with score aggregated from their top submission per test).

### Example

* OAuth Authentication (oauth2):

```python
import fab_clientlib
from fab_clientlib.models.results_campaigns_group_ids_get200_response import ResultsCampaignsGroupIdsGet200Response
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
    group_ids = ['group_ids_example'] # List[str] | Comma-separated list of IDs.

    try:
        api_response = api_instance.results_campaigns_group_ids_get(group_ids)
        print("The response of DefaultApi->results_campaigns_group_ids_get:\n")
        pprint(api_response)
    except Exception as e:
        print("Exception when calling DefaultApi->results_campaigns_group_ids_get: %s\n" % e)
```



### Parameters


Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **group_ids** | [**List[str]**](str.md)| Comma-separated list of IDs. | 

### Return type

[**ResultsCampaignsGroupIdsGet200Response**](ResultsCampaignsGroupIdsGet200Response.md)

### Authorization

[oauth2](../README.md#oauth2)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

### HTTP response details

| Status code | Description | Response headers |
|-------------|-------------|------------------|
**200** | Campaign leaderboard. |  -  |

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **results_submissions_submission_id_scenario_scenario_ids_get**
> ResultsSubmissionsSubmissionIdScenarioScenarioIdsGet200Response results_submissions_submission_id_scenario_scenario_ids_get(submission_id, scenario_ids)

Get submission results for specific scenario.

### Example

* OAuth Authentication (oauth2):

```python
import fab_clientlib
from fab_clientlib.models.results_submissions_submission_id_scenario_scenario_ids_get200_response import ResultsSubmissionsSubmissionIdScenarioScenarioIdsGet200Response
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
    scenario_ids = ['scenario_ids_example'] # List[str] | Comma-separated list of scenario IDs.

    try:
        api_response = api_instance.results_submissions_submission_id_scenario_scenario_ids_get(submission_id, scenario_ids)
        print("The response of DefaultApi->results_submissions_submission_id_scenario_scenario_ids_get:\n")
        pprint(api_response)
    except Exception as e:
        print("Exception when calling DefaultApi->results_submissions_submission_id_scenario_scenario_ids_get: %s\n" % e)
```



### Parameters


Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **submission_id** | **str**| Submission ID. | 
 **scenario_ids** | [**List[str]**](str.md)| Comma-separated list of scenario IDs. | 

### Return type

[**ResultsSubmissionsSubmissionIdScenarioScenarioIdsGet200Response**](ResultsSubmissionsSubmissionIdScenarioScenarioIdsGet200Response.md)

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

# **results_submissions_submission_id_tests_test_ids_get**
> ResultsSubmissionsSubmissionIdTestsTestIdsGet200Response results_submissions_submission_id_tests_test_ids_get(submission_id, test_ids)

Get submission results aggregated by test.

### Example

* OAuth Authentication (oauth2):

```python
import fab_clientlib
from fab_clientlib.models.results_submissions_submission_id_tests_test_ids_get200_response import ResultsSubmissionsSubmissionIdTestsTestIdsGet200Response
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
    test_ids = ['test_ids_example'] # List[str] | Comma-separated list of Test IDs.

    try:
        api_response = api_instance.results_submissions_submission_id_tests_test_ids_get(submission_id, test_ids)
        print("The response of DefaultApi->results_submissions_submission_id_tests_test_ids_get:\n")
        pprint(api_response)
    except Exception as e:
        print("Exception when calling DefaultApi->results_submissions_submission_id_tests_test_ids_get: %s\n" % e)
```



### Parameters


Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **submission_id** | **str**| Submission ID. | 
 **test_ids** | [**List[str]**](str.md)| Comma-separated list of Test IDs. | 

### Return type

[**ResultsSubmissionsSubmissionIdTestsTestIdsGet200Response**](ResultsSubmissionsSubmissionIdTestsTestIdsGet200Response.md)

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

# **results_submissions_submission_id_tests_test_ids_post**
> ApiResponse results_submissions_submission_id_tests_test_ids_post(submission_id, test_ids, results_submissions_submission_id_tests_test_ids_post_request)

Inserts test results

### Example

* OAuth Authentication (oauth2):

```python
import fab_clientlib
from fab_clientlib.models.api_response import ApiResponse
from fab_clientlib.models.results_submissions_submission_id_tests_test_ids_post_request import ResultsSubmissionsSubmissionIdTestsTestIdsPostRequest
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
    test_ids = ['test_ids_example'] # List[str] | Comma-separated list of test IDs.
    results_submissions_submission_id_tests_test_ids_post_request = fab_clientlib.ResultsSubmissionsSubmissionIdTestsTestIdsPostRequest() # ResultsSubmissionsSubmissionIdTestsTestIdsPostRequest | 

    try:
        api_response = api_instance.results_submissions_submission_id_tests_test_ids_post(submission_id, test_ids, results_submissions_submission_id_tests_test_ids_post_request)
        print("The response of DefaultApi->results_submissions_submission_id_tests_test_ids_post:\n")
        pprint(api_response)
    except Exception as e:
        print("Exception when calling DefaultApi->results_submissions_submission_id_tests_test_ids_post: %s\n" % e)
```



### Parameters


Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **submission_id** | **str**| Submission ID. | 
 **test_ids** | [**List[str]**](str.md)| Comma-separated list of test IDs. | 
 **results_submissions_submission_id_tests_test_ids_post_request** | [**ResultsSubmissionsSubmissionIdTestsTestIdsPostRequest**](ResultsSubmissionsSubmissionIdTestsTestIdsPostRequest.md)|  | 

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
**201** | All results inserted. |  -  |
**400** | Some results could not be inserted, transaction aborted. |  -  |

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **results_submissions_submission_ids_get**
> ResultsSubmissionsSubmissionIdsGet200Response results_submissions_submission_ids_get(submission_ids)

Get aggregated submission overall results.

### Example

* OAuth Authentication (oauth2):

```python
import fab_clientlib
from fab_clientlib.models.results_submissions_submission_ids_get200_response import ResultsSubmissionsSubmissionIdsGet200Response
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
    submission_ids = ['submission_ids_example'] # List[str] | Comma-separated list of submission IDs.

    try:
        api_response = api_instance.results_submissions_submission_ids_get(submission_ids)
        print("The response of DefaultApi->results_submissions_submission_ids_get:\n")
        pprint(api_response)
    except Exception as e:
        print("Exception when calling DefaultApi->results_submissions_submission_ids_get: %s\n" % e)
```



### Parameters


Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **submission_ids** | [**List[str]**](str.md)| Comma-separated list of submission IDs. | 

### Return type

[**ResultsSubmissionsSubmissionIdsGet200Response**](ResultsSubmissionsSubmissionIdsGet200Response.md)

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

# **submissions_get**
> SubmissionsGet200Response submissions_get(benchmark_ids=benchmark_ids, submitted_by=submitted_by)

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
    benchmark_ids = ['benchmark_ids_example'] # List[str] | Filter submissions by benchmark. (optional)
    submitted_by = 'submitted_by_example' # str | Filter submissions by user. If this equals the authenticated user, un-published submissions will be listed too. (optional)

    try:
        api_response = api_instance.submissions_get(benchmark_ids=benchmark_ids, submitted_by=submitted_by)
        print("The response of DefaultApi->submissions_get:\n")
        pprint(api_response)
    except Exception as e:
        print("Exception when calling DefaultApi->submissions_get: %s\n" % e)
```



### Parameters


Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **benchmark_ids** | [**List[str]**](str.md)| Filter submissions by benchmark. | [optional] 
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

# **submissions_submission_ids_get**
> SubmissionsGet200Response submissions_submission_ids_get(submission_ids)

Get submissions.

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
    submission_ids = ['submission_ids_example'] # List[str] | Comma-separated list of submission IDs.

    try:
        api_response = api_instance.submissions_submission_ids_get(submission_ids)
        print("The response of DefaultApi->submissions_submission_ids_get:\n")
        pprint(api_response)
    except Exception as e:
        print("Exception when calling DefaultApi->submissions_submission_ids_get: %s\n" % e)
```



### Parameters


Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **submission_ids** | [**List[str]**](str.md)| Comma-separated list of submission IDs. | 

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

# **submissions_submission_ids_patch**
> SubmissionsGet200Response submissions_submission_ids_patch(submission_ids)

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
    submission_ids = ['submission_ids_example'] # List[str] | Comma-separated list of IDs.

    try:
        api_response = api_instance.submissions_submission_ids_patch(submission_ids)
        print("The response of DefaultApi->submissions_submission_ids_patch:\n")
        pprint(api_response)
    except Exception as e:
        print("Exception when calling DefaultApi->submissions_submission_ids_patch: %s\n" % e)
```



### Parameters


Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **submission_ids** | [**List[str]**](str.md)| Comma-separated list of IDs. | 

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
**200** | Published submission. |  -  |

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

