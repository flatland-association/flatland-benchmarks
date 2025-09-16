# Scoring


## Properties

Name | Type | Description | Notes
------------ | ------------- | ------------- | -------------
**field_id** | **str** | ID of field definition. | [optional] 
**field_key** | **str** | Key of field. | [optional] 
**score** | **float** | Numerical score. | [optional] 
**rank** | **float** | Item&#39;s rank in category. | [optional] 
**highest** | **float** | Highest score in category. | [optional] 
**lowest** | **float** | Lowest score in category. | [optional] 

## Example

```python
from fab_clientlib.models.scoring import Scoring

# TODO update the JSON string below
json = "{}"
# create an instance of Scoring from a JSON string
scoring_instance = Scoring.from_json(json)
# print the JSON string representation of the object
print(Scoring.to_json())

# convert the object into a dict
scoring_dict = scoring_instance.to_dict()
# create an instance of Scoring from a dict
scoring_from_dict = Scoring.from_dict(scoring_dict)
```
[[Back to Model list]](../README.md#documentation-for-models) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to README]](../README.md)


