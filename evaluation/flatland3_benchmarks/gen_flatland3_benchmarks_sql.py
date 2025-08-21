import re
import uuid
from collections import defaultdict

import pandas as pd


def gen_ai4realnet_playground():
  test_type = 'CLOSED'

  NUM_TESTS = 1
  NUM_LEVELS_PER_TEST = 1
  test_descriptions = ['lorem ipsum'] * NUM_TESTS
  benchmark_group_id = "0ca46887-897a-463f-bf83-c6cd6269a976"
  # https://ai4realnet.eu/use-cases/
  benchmark_name = "Playground Electricity Network"
  benchmark_name = "Playground Air Traffic Management"
  benchmark_name = "Playground Railway (interactive)"
  test_type = 'CLOSED'
  test_type = 'INTERACTIVE'

  fields = [["normalized_reward", "NANSUM"], ["percentage_complete", "NANMEAN"]]

  gen_sql(NUM_LEVELS_PER_TEST, NUM_TESTS, benchmark_group_id, benchmark_name, fields, test_descriptions, test_type)


def gen_flatland3_benchmarks():
  test_type = 'CLOSED'

  NUM_TESTS = 15
  NUM_LEVELS_PER_TEST = 10
  df_metadata = pd.read_csv("../../benchmarks/flatland3/metadata.csv.template")
  test_descriptions = [f"{v['n_agents']} agents,  {v['y_dim']}x{v['x_dim']}, 2 {v['n_cities']}" for k, v in
                       list(df_metadata.groupby("test_id").aggregate('first').iterrows())]
  benchmark_group_id = None
  benchmark_name = "Round 1"
  fields = [["normalized_reward", "NANSUM"], ["percentage_complete", "NANMEAN"]]
  gen_sql(NUM_LEVELS_PER_TEST, NUM_TESTS, benchmark_group_id, benchmark_name, fields, test_descriptions, test_type)


def gen_sql(
  num_levels_per_test,
  num_tests,
  benchmark_group_id,
  benchmark_name,
  fields,
  test_descriptions,
  test_type
):
  field_definitions = ""
  scenario_fields = []
  test_fields = []
  benchmark_fields = []
  for key, agg_func in fields:
    scenario_field = str(uuid.uuid4())
    test_field = str(uuid.uuid4())
    benchmark_field = str(uuid.uuid4())
    scenario_fields.append(scenario_field)
    test_fields.append(test_field)
    benchmark_fields.append(benchmark_field)

    field_definitions += f"""INSERT INTO field_definitions
      (id, key, description, agg_func, agg_weights)
      VALUES
      ('{scenario_field}', '{key}', 'Scenario score (raw values)', NULL, NULL),
      ('{test_field}', '{key}', 'Test score ({agg_func} of scenario scores)', '{agg_func}', NULL),
      ('{benchmark_field}', '{key}', 'Benchmark score ({agg_func} of test scores)', '{agg_func}', NULL),

  """
  scenario_definitions = f"""INSERT INTO scenario_definitions
    (id, name, description, field_ids)
    VALUES
  """
  scenario_ids = defaultdict(lambda: [])
  for i in range(num_tests):
    for j in range(num_levels_per_test):
      scenario_id = str(uuid.uuid4())
      scenario_ids[i].append(scenario_id)
      scenario_definitions += f"""  ('{scenario_id}', 'Test {i} Level {j}', 'Test {i} Level {j}', array['{scenario_field.join("\', \'")}']::uuid[]),

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
    test_definitions += f"""  ('{test_id}', 'Test {i}', '{label}', array['{"\', \'".join(test_fields)}']::uuid[], array['{"', '".join(scenario_ids[i])}']::uuid[], '{test_type}'),

  """
  test_definitions = re.sub(",\n$", ";", test_definitions)
  benchmark_id = str(uuid.uuid4())
  benchmark_definitions = f"""INSERT INTO benchmark_definitions
    (id, name, description, field_ids, test_ids)
    VALUES
    ('{benchmark_id}', '{benchmark_name}', '{benchmark_name}', array['{"\', \'".join(benchmark_fields)}']::uuid[], array['{"', '".join(test_ids)}']::uuid[]);"""
  print(field_definitions)
  print(scenario_definitions)
  print(test_definitions)
  print(benchmark_definitions)
  if benchmark_group_id is None:
    benchmark_group_id = str(uuid.uuid4())
    benchmark_group_definitions = f""" INSERT INTO benchmark_groups
    (id, setup, name, description, benchmark_ids)
    VALUES
    ('{benchmark_group_id}', 'COMPETITION', 'Flatland 3 Benchmarks', 'The Flatland 3 Benchmarks.', array['{benchmark_id}']::uuid[]);"""

    print(benchmark_group_definitions)


if __name__ == '__main__':
  gen_ai4realnet_playground()
  gen_flatland3_benchmarks()
