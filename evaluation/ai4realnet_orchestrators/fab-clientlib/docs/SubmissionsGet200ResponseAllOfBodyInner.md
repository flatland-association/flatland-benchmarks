# SubmissionsGet200ResponseAllOfBodyInner

## Properties

 Name                      | Type    | Description | Notes      
---------------------------|---------|-------------|------------
 **id**                    | **str** |             | [optional] 
 **uuid**                  | **str** |             | [optional] 
 **name**                  | **str** |             | [optional] 
 **benchmark**             | **str** |             | [optional] 
 **submitted_at**          | **str** |             | [optional] 
 **submitted_by_username** | **str** |             | [optional] 
 **public**                | **str** |             | [optional] 
 **scores**                | **str** |             | [optional] 
 **rank**                  | **str** |             | [optional] 

## Example

```python
from fab_clientlib.models.submissions_get200_response_all_of_body_inner import SubmissionsGet200ResponseAllOfBodyInner

# TODO update the JSON string below
json = "{}"
# create an instance of SubmissionsGet200ResponseAllOfBodyInner from a JSON string
submissions_get200_response_all_of_body_inner_instance = SubmissionsGet200ResponseAllOfBodyInner.from_json(json)
# print the JSON string representation of the object
print(SubmissionsGet200ResponseAllOfBodyInner.to_json())

# convert the object into a dict
submissions_get200_response_all_of_body_inner_dict = submissions_get200_response_all_of_body_inner_instance.to_dict()
# create an instance of SubmissionsGet200ResponseAllOfBodyInner from a dict
submissions_get200_response_all_of_body_inner_from_dict = SubmissionsGet200ResponseAllOfBodyInner.from_dict(submissions_get200_response_all_of_body_inner_dict)
```

[[Back to Model list]](../README.md#documentation-for-models) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to README]](../README.md)


