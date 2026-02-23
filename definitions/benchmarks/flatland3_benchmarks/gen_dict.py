import json
from collections import defaultdict
from pathlib import Path

if __name__ == '__main__':
  with Path("fab3_definitions.json").open("r") as f:
    data = json.load(f)
  scenario_data = {}
  TEST_TO_SCENARIO_IDS = defaultdict(list)
  for i, (test_id, test) in enumerate(data['24ab2336-a407-4329-b781-d71846250e24']["benchmarks"]['fd6dc299-9d3d-410d-a17c-338dc1cf3752']['tests'].items()):
    for j, (scenario_id, scenario) in enumerate(test["scenarios"].items()):
      scenario_data[scenario_id] = f"Test_{i:02d}/Level_{j}.pkl"
      TEST_TO_SCENARIO_IDS[test_id].append(scenario_id)
  print(json.dumps(scenario_data, indent=4))
  print(json.dumps(TEST_TO_SCENARIO_IDS, indent=4))
