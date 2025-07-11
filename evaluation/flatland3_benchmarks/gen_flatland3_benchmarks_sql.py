import re
import uuid
from collections import defaultdict

if __name__ == '__main__':

  NUM_TESTS = 2
  NUM_LEVELS_PER_TEST = 3

  scenario_field = str(uuid.uuid4())
  test_field = str(uuid.uuid4())
  benchmark_field = str(uuid.uuid4())
  field_definitions = f"""INSERT INTO field_definitions
  (id, key, description, agg_func, agg_weights)
  VALUES
  ('{scenario_field}', 'primary', 'Scenario score (raw values)', NULL, NULL),
  ('{test_field}', 'primary', 'Test score (NANSUM of scenario scores)', 'NANSUM', NULL),
  ('{benchmark_field}', 'primary', 'Benchmark score (NANSUM of test scores)', 'NANSUM', NULL);
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
      scenario_definitions += f"""('{scenario_id}', 'Test {i} Level {j}', 'Test {i} Level {j}', array['{scenario_field}']::uuid[]),
"""

  scenario_definitions = re.sub(",\n$", ";", scenario_definitions)

  test_definitions = """INSERT INTO test_definitions
  (id, name, description, field_ids, scenario_ids, loop)
VALUES
"""
  test_ids = []
  for i in range(NUM_TESTS):
    test_id = str(uuid.uuid4())
    test_ids.append(test_id)
    test_definitions += f"""('{test_id}', 'Test {i}', '5 agents, 25x25, 2 cities, 2 seeds', array['{test_field}']::uuid[], array['{"', '".join(scenario_ids[i])}']::uuid[], 'CLOSED'),
"""
  test_definitions = re.sub(",\n$", ";", test_definitions)

  benchmark_id = str(uuid.uuid4())
  benchmark_group_id = str(uuid.uuid4())

  benchmark_definitions = f"""INSERT INTO benchmark_definitions
  (id, name, description, field_ids, test_ids)
VALUES
  ('{benchmark_id}', 'Round 1', 'Round 1', array['{benchmark_field}']::uuid[], array['{"', '".join(test_ids)}']::uuid[]);


INSERT INTO benchmark_groups
  (id, setup, name, description, benchmark_ids)
VALUES
  ('{benchmark_group_id}', 'COMPETITION', 'Flatland 3 Benchmarks', 'The Flatland 3 Benchmarks.', array['{benchmark_id}']::uuid[]);"""

  print(field_definitions)
  print(scenario_definitions)
  print(test_definitions)
  print(benchmark_definitions)
