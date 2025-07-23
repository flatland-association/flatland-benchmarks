import re
import uuid
from collections import defaultdict

import pandas as pd

if __name__ == '__main__':

  if True:
    NUM_TESTS = 15
    NUM_LEVELS_PER_TEST = 10
    df_metadata = pd.read_csv("../../benchmarks/flatland3/metadata.csv.template")
    test_descriptions = [f"{v['n_agents']} agents,  {v['y_dim']}x{v['x_dim']}, 2 {v['n_cities']}" for k, v in
                         list(df_metadata.groupby("test_id").aggregate('first').iterrows())]
  else:
    NUM_TESTS = 2
    NUM_LEVELS_PER_TEST = 3
    test_descriptions = [['5 agents, 25x25, 2 cities, 2 seeds'] * NUM_TESTS]

  normalized_reward_scenario_field = str(uuid.uuid4())
  normalized_reward_test_field = str(uuid.uuid4())
  normalized_reward_benchmark_field = str(uuid.uuid4())
  percentage_complete_scenario_field = str(uuid.uuid4())
  percentage_complete_test_field = str(uuid.uuid4())
  percentage_complete_benchmark_field = str(uuid.uuid4())
  field_definitions = f"""INSERT INTO field_definitions
  (id, key, description, agg_func, agg_weights)
  VALUES
  ('{normalized_reward_scenario_field}', 'normalized_reward', 'Scenario score (raw values)', NULL, NULL),
  ('{normalized_reward_test_field}', 'normalized_reward', 'Test score (NANSUM of scenario scores)', 'NANSUM', NULL),
  ('{normalized_reward_benchmark_field}', 'normalized_reward', 'Benchmark score (NANSUM of test scores)', 'NANSUM', NULL),
  ('{percentage_complete_scenario_field}', 'percentage_complete', 'Scenario score (raw values)', NULL, NULL),
  ('{percentage_complete_test_field}', 'percentage_complete', 'Test score (NANMEAN of scenario scores)', 'NANMEAN', NULL),
  ('{percentage_complete_benchmark_field}', 'percentage_complete', 'Benchmark score (NANMEAN of test scores)', 'NANMEAN', NULL);
  """

  scenario_definitions = f"""INSERT INTO scenario_definitions
  (id, name, description, field_ids)
  VALUES
  """
  scenario_ids = defaultdict(lambda: [])
  for i in range(NUM_TESTS):
    for j in range(NUM_LEVELS_PER_TEST):
      scenario_id = str(uuid.uuid4())
      scenario_ids[i].append(scenario_id)
      scenario_definitions += f"""('{scenario_id}', 'Test {i} Level {j}', 'Test {i} Level {j}', array['{normalized_reward_scenario_field}','{percentage_complete_scenario_field}']::uuid[]),
"""

  scenario_definitions = re.sub(",\n$", ";", scenario_definitions)

  test_definitions = """INSERT INTO test_definitions
  (id, name, description, field_ids, scenario_ids, loop)
VALUES
"""
  test_ids = []
  for i, label in enumerate(test_descriptions):
    test_id = str(uuid.uuid4())
    test_ids.append(test_id)
    test_definitions += f"""('{test_id}', 'Test {i}', '{label}', array['{normalized_reward_test_field}','{percentage_complete_test_field}']::uuid[], array['{"', '".join(scenario_ids[i])}']::uuid[], 'CLOSED'),
"""
  test_definitions = re.sub(",\n$", ";", test_definitions)

  benchmark_id = str(uuid.uuid4())
  benchmark_group_id = str(uuid.uuid4())

  benchmark_definitions = f"""INSERT INTO benchmark_definitions
  (id, name, description, field_ids, test_ids)
VALUES
  ('{benchmark_id}', 'Round 1', 'Round 1', array['{normalized_reward_benchmark_field}','{percentage_complete_benchmark_field}']::uuid[], array['{"', '".join(test_ids)}']::uuid[]);


INSERT INTO benchmark_groups
  (id, setup, name, description, benchmark_ids)
VALUES
  ('{benchmark_group_id}', 'COMPETITION', 'Flatland 3 Benchmarks', 'The Flatland 3 Benchmarks.', array['{benchmark_id}']::uuid[]);"""

  print(field_definitions)
  print(scenario_definitions)
  print(test_definitions)
  print(benchmark_definitions)
