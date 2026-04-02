import uuid
from collections import defaultdict

from definitions.gen_benchmarks_common import gen_sql_scenario_field, gen_sql_test_benchmark_field, gen_sql_scenario, gen_sql_test, gen_sql_benchmark, \
  gen_sql_suite


def gen_flatland_sql(
  test_type='CLOSED',
  suite_id=None,
  benchmark_id="fd6dc299-9d3d-410d-a17c-338dc1cf3752",
  benchmark_name="Round 1",
  benchmark_description="",
  fields=None,
  suite_setup="COMPETITION",
  suite_name="Flatland 3 Benchmarks",
  suite_description='The Flatland 3 Benchmarks.',
  suite_contents='',
  num_levels_per_test=10,
  test_descriptions=None,
) -> dict:
  return gen_data(num_levels_per_test, suite_id, benchmark_id, benchmark_name, benchmark_description, fields, test_descriptions, test_type, suite_setup,
                  suite_name,
                  suite_description, suite_contents)


def gen_data(num_levels_per_test, suite_id, benchmark_id, benchmark_name, benchmark_description, fields, test_descriptions, test_type, suite_setup, suite_name,
             suite_description, suite_contents) -> dict:
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
    benchmark_field_id = str(uuid.uuid4())
    scenario_fields.append(scenario_field)
    test_fields.append(test_field)
    benchmark_fields.append(benchmark_field_id)

  for (key, agg_func), scenario_field, test_field, benchmark_field_id in zip(fields, scenario_fields, test_fields, benchmark_fields):
    field_definition = gen_sql_scenario_field(key, scenario_field, "scenario field description")
    field_definitions += field_definition

    field_definition = gen_sql_test_benchmark_field(benchmark_field_id, key, f'Benchmark score ({agg_func} of test scores)', agg_func)
    field_definitions += field_definition

    field_definition = gen_sql_test_benchmark_field(test_field, key, f'Test score ({agg_func} of scenario scores)', agg_func)
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

    for scenario_id, scenario_name, scenario_description in zip(scenario_ids_for_test, scenario_names, scenario_descriptions):
      scenario_definition = gen_sql_scenario(scenario_id, scenario_name, scenario_description, scenario_fields)
      scenario_definitions += scenario_definition

  test_names = [f'Test {i}' for i, _ in enumerate(test_ids)]
  scenario_ids_per_test = [scenario_ids[test_id] for test_id in test_ids]
  test_definitions = ""
  for test_name, test_description, test_id, scenario_ids_for_test in zip(test_names, test_descriptions, test_ids, scenario_ids_per_test):
    test_definitions += gen_sql_test(test_id, test_name, test_description, [test_field], scenario_ids_for_test, test_type)
  # benchmark_id = str(uuid.uuid4())
  benchmark_definitions = gen_sql_benchmark(benchmark_id, benchmark_name, benchmark_description, benchmark_fields, test_ids)
  print(field_definitions)
  print(scenario_definitions)
  print(test_definitions)
  print(benchmark_definitions)
  if suite_id is None:
    suite_id = str(uuid.uuid4())
  benchmark_ids = [benchmark_id]
  suite_definitions = gen_sql_suite(suite_id, suite_setup, suite_name, suite_description, suite_contents, benchmark_ids)

  print(suite_definitions)

  return {
    suite_id: {
      "ID": suite_id,
      "SUITE_NAME": suite_name,
      "SUITE_DESCRIPTION": suite_description,
      "SUITE_CONTENTS": suite_contents,
      "SUITE_SETUP": suite_setup,
      "benchmarks": {
        benchmark_id: {
          "ID": benchmark_id,
          "BENCHMARK_NAME": benchmark_name,
          "BENCHMARK_DESCRIPTION": benchmark_description,
          "BENCHMARK_FIELDS": {
            field_id: {
              "ID": field_id,
              "BENCHMARK_FIELD_NAME": key,
              "BENCHMARK_FIELD_DESCRIPTION": f'{'Primary' if (i == 0) else 'Secondary'} benchmark score ({agg_func} of corresponding test scores)',
              "BENCHMARK_AGG": agg_func,
              "BENCHMARK_AGG_FIELDS": key,

            } for i, (field_id, (key, agg_func)) in enumerate(zip(benchmark_fields, fields))
          },
          "tests": {
            test_id: {
              "ID": test_id,
              "TEST_NAME": test_name,
              "TEST_DESCRIPTION": test_description,
              "TEST_FIELDS": {
                field_id: {
                  "ID": field_id,
                  "TEST_FIELD_NAME": key,
                  "TEST_FIELD_DESCRIPTION": f"{'Primary' if (i == 0) else 'Secondary'} test score ({agg_func} of corresponding scenario scores)",
                  "TEST_AGG": agg_func,
                }
                for i, (field_id, (key, agg_func)) in enumerate(zip(test_fields, fields))
              },
              "TEST_AGG_FIELDS": key,
              "LOOP": "CLOSED",
              "scenarios": {
                scenario_id: {
                  "ID": scenario_id,
                  "SCENARIO_NAME": scenario_id,
                  "SCENARIO_DESCRIPTION": scenario_id,
                  "SCENARIO_FIELDS": {
                    field_id: {
                      "ID": field_id,
                      "SCENARIO_FIELD_NAME": key,
                      "SCENARIO_FIELD_DESCRIPTION": f"{'Primary' if (i == 0) else 'Secondary'} raw scenario score.",
                    }
                    for i, (field_id, (key, agg_func)) in enumerate(zip(scenario_fields, fields))
                  }
                }
                for scenario_id in scenario_ids[test_id]
              },
            }
            for test_name, test_description, test_id in zip(test_names, test_descriptions, test_ids)
          }
        }
      }
    }
  }
