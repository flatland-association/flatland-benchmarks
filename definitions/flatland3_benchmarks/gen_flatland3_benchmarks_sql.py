import uuid
from collections import defaultdict

import pandas as pd

from definitions.gen_benchmarks_common import gen_sql_scenario_field, gen_sql_test_benchmark_field, gen_sql_scenario, gen_sql_test, gen_sql_benchmark, \
  gen_sql_benchmark_group


def gen_ai4realnet_playground():
  test_type = 'CLOSED'

  NUM_BENCHMARKS = 1
  NUM_LEVELS_PER_BENCHMARK = 1
  test_descriptions = ['lorem ipsum'] * NUM_BENCHMARKS
  benchmark_group_id = "0ca46887-897a-463f-bf83-c6cd6269a976"
  # https://ai4realnet.eu/use-cases/
  benchmark_name = "Playground Electricity Network"
  benchmark_name = "Playground Air Traffic Management"
  benchmark_name = "Playground Railway (interactive)"
  test_type = 'CLOSED'
  test_type = 'INTERACTIVE'

  fields = [["normalized_reward", "NANSUM"], ["percentage_complete", "NANMEAN"]]

  gen_sql(NUM_LEVELS_PER_BENCHMARK, benchmark_group_id, benchmark_name, fields, test_descriptions, test_type)


def gen_flatland3_benchmarks():
  test_type = 'CLOSED'

  NUM_BENCHMARKS = 15
  NUM_LEVELS_PER_BENCHMARK = 10
  df_metadata = pd.read_csv("../../benchmarks/flatland3/metadata.csv.template")
  test_descriptions = [f"{v['n_agents']} agents,  {v['y_dim']}x{v['x_dim']}, 2 {v['n_cities']}" for k, v in
                       list(df_metadata.groupby("test_id").aggregate('first').iterrows())]
  benchmark_group_id = None
  benchmark_name = "Round 1"
  fields = [["normalized_reward", "NANSUM"], ["percentage_complete", "NANMEAN"]]
  gen_sql(NUM_LEVELS_PER_BENCHMARK, benchmark_group_id, benchmark_name, fields, test_descriptions, test_type)


def gen_sql(num_levels_per_test, benchmark_group_id, benchmark_name, fields, test_descriptions, test_type):
  field_definitions = ""

  test_ids = []
  for _ in test_descriptions:
    test_id = str(uuid.uuid4())
    test_ids.append(test_id)

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

  for (key, agg_func), scenario_field, test_field, benchmark_field in zip(fields, scenario_fields, test_fields, benchmark_fields):
    field_definition = gen_sql_scenario_field(key, scenario_field)
    field_definitions += field_definition

    field_definition = gen_sql_test_benchmark_field(benchmark_field, key, agg_func)
    field_definitions += field_definition

    field_definition = gen_sql_test_benchmark_field(test_field, key, agg_func)
    field_definitions += field_definition

  scenario_ids = defaultdict(lambda: [])
  for i, test_id in enumerate(test_ids):
    for j in range(num_levels_per_test):
      scenario_id = str(uuid.uuid4())
      scenario_ids[test_id].append(scenario_id)

  scenario_definitions = ""

  for i, test_id in enumerate(test_ids):
    scenario_ids_for_test = scenario_ids[test_id]
    scenario_names = [f'Test {i} Level {j}' for j, scenario_id in enumerate(scenario_ids_for_test)]
    scenario_descriptions = [f'Test {i} Level {j}' for j, scenario_id in enumerate(scenario_ids_for_test)]

    scenario_definition = gen_sql_scenario(scenario_ids_for_test, scenario_names, scenario_descriptions, scenario_fields)
    scenario_definitions += scenario_definition

  test_names = [f'Test {i}' for i, _ in enumerate(test_ids)]
  scenario_ids_per_test = [scenario_ids[test_id] for test_id in test_ids]

  test_definitions = gen_sql_test(test_ids, test_names, test_descriptions, test_fields, scenario_ids_per_test, test_type)
  benchmark_id = str(uuid.uuid4())
  benchmark_definitions = gen_sql_benchmark(benchmark_id, benchmark_name, benchmark_fields, test_ids)
  print(field_definitions)
  print(scenario_definitions)
  print(test_definitions)
  print(benchmark_definitions)
  if benchmark_group_id is None:
    benchmark_group_id = str(uuid.uuid4())
    benchmark_ids = [benchmark_id]
    benchmark_group_setup = "COMPETITION"
    benchmark_group_name = "Flatland 3 Benchmarks"
    benchmark_group_description = 'The Flatland 3 Benchmarks.'

    benchmark_group_definitions = gen_sql_benchmark_group(benchmark_group_id, benchmark_group_setup, benchmark_group_name, benchmark_group_description,
                                                          benchmark_ids)

    print(benchmark_group_definitions)

  return {
    "benchmarks": [{
      "id": benchmark_id,
      "name": benchmark_name,
      "fields": benchmark_fields,
      "tests": [{
        "id": test_id,
        # "name": "",
        "fields": test_fields,
        "scenarios": [{
          "id": scenario_id,
          # name
          "fields": scenario_fields,
        } for scenario_id in scenario_ids[test_id]]

      } for test_id in test_ids]
    }]
  }


if __name__ == '__main__':
  # gen_ai4realnet_playground()
  gen_flatland3_benchmarks()

  # TODO add tests for common
  # TODO gen orchestrator code as well
  # TODO make upsert https://neon.com/postgresql/postgresql-tutorial/postgresql-upsert
  # TODO update orchestraotor for domain queue
