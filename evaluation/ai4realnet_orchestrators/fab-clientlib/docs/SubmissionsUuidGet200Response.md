# SubmissionsUuidGet200Response

## Properties

 Name      | Type                                                                                                    | Description | Notes      
-----------|---------------------------------------------------------------------------------------------------------|-------------|------------
 **error** | [**ApiResponseError**](ApiResponseError.md)                                                             |             | [optional] 
 **body**  | [**List[SubmissionsUuidGet200ResponseAllOfBodyInner]**](SubmissionsUuidGet200ResponseAllOfBodyInner.md) |             | [optional] 

## Example

```python
from fab_clientlib.models.submissions_uuid_get200_response import SubmissionsUuidGet200Response

# TODO update the JSON string below
json = "{}"
# create an instance of SubmissionsUuidGet200Response from a JSON string
submissions_uuid_get200_response_instance = SubmissionsUuidGet200Response.from_json(json)
# print the JSON string representation of the object
print(SubmissionsUuidGet200Response.to_json())

# convert the object into a dict
submissions_uuid_get200_response_dict = submissions_uuid_get200_response_instance.to_dict()
# create an instance of SubmissionsUuidGet200Response from a dict
submissions_uuid_get200_response_from_dict = SubmissionsUuidGet200Response.from_dict(submissions_uuid_get200_response_dict)
```

[[Back to Model list]](../README.md#documentation-for-models) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to README]](../README.md)


