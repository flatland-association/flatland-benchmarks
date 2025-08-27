import json
import re
import uuid
from collections import defaultdict
from pathlib import Path

import pandas as pd


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


def gen_sql_test_benchmark_field(test_or_benchmark_field, key, agg_func):
  field_definition = f"""INSERT INTO field_definitions
        (id, key, description, agg_func, agg_weights)
        VALUES
        ('{test_or_benchmark_field}', '{key}', 'Benchmark score ({agg_func} of test scores)', '{agg_func}', NULL);

"""
  return field_definition


def gen_sql_scenario_field(key, scenario_field):
  field_definition = f"""INSERT INTO field_definitions
        (id, key, description, agg_func, agg_weights)
        VALUES
        ('{scenario_field}', '{key}', 'Scenario score (raw values)', NULL, NULL);

"""
  return field_definition


def gen_sql_scenario(scenario_ids_for_test, scenario_names, scenario_descriptions, scenario_fields):
  scenario_definition = f"""INSERT INTO scenario_definitions
    (id, name, description, field_ids)
    VALUES
"""
  for scenario_id, scenario_name, scenario_description in zip(scenario_ids_for_test, scenario_names, scenario_descriptions):
    scenario_definition += f"""  ('{scenario_id}', '{scenario_name}', '{escape_sql_string(scenario_description)}', array['{"\', \'".join(scenario_fields)}']::uuid[]),

"""
  scenario_definition = re.sub(",\n$", ";\n", scenario_definition)
  return scenario_definition


def gen_sql_test(test_ids, test_names, test_descriptions, test_fields, scenario_ids_per_test, test_type, queue=None):
  test_definitions = """INSERT INTO test_definitions
    (id, name, description, field_ids, scenario_ids, loop, queue)
    VALUES
  """
  queue_ = "NULL" if queue is None else f"'{queue}'"
  for test_name, test_description, test_id, scenario_ids_for_test in zip(test_names, test_descriptions, test_ids, scenario_ids_per_test):
    test_definitions += f"""  ('{test_id}', '{test_name}', '{escape_sql_string(test_description)}', array['{"\', \'".join(test_fields)}']::uuid[], array['{"', '".join(scenario_ids_for_test)}']::uuid[], '{test_type}', {queue_}),

"""
  test_definitions = re.sub(",\n$", ";\n", test_definitions)
  return test_definitions


def gen_sql_benchmark(benchmark_id, benchmark_name, benchmark_fields, test_ids):
  benchmark_definitions = f"""INSERT INTO benchmark_definitions
    (id, name, description, field_ids, test_ids)
    VALUES
    ('{benchmark_id}', '{benchmark_name}', '{benchmark_name}', array['{"\', \'".join(benchmark_fields)}']::uuid[], array['{"', '".join(test_ids)}']::uuid[]);

"""
  return benchmark_definitions


def gen_sql_benchmark_group(benchmark_group_id, benchmark_group_setup, benchmark_group_name, benchmark_group_description, benchmark_ids):
  benchmark_group_definitions = f""" INSERT INTO benchmark_groups
    (id, setup, name, description, benchmark_ids)
    VALUES
    ('{benchmark_group_id}', '{benchmark_group_setup}', '{benchmark_group_name}', '{benchmark_group_description}', array['{"', '".join(benchmark_ids)}']::uuid[]);

"""
  return benchmark_group_definitions


def escape_sql_string(s):
  return s.replace("\n", "<br/>").replace("'", "''")


def extract_ai4realnet_from_csv(csv):
  df = pd.read_csv(csv)  # , on_bad_lines="skip", )

  data = defaultdict(lambda: {})

  for _, row in df.iterrows():
    benchmark_group = data[row["BENCHMARK_GROUP_ID"]]
    benchmark_group["ID"] = row["BENCHMARK_GROUP_ID"]
    benchmark_group["BENCHMARK_GROUP_NAME"] = row["BENCHMARK_GROUP_NAME"]
    benchmark_group["BENCHMARK_GROUP_DESCRIPTION"] = row["BENCHMARK_GROUP_DESCRIPTION"]

    benchmark_group["benchmarks"] = benchmark_group.get("benchmarks", defaultdict(lambda: {}))
    benchmarks = benchmark_group["benchmarks"]
    benchmark = benchmarks[row["BENCHMARK_ID"]]
    benchmark["ID"] = row["BENCHMARK_ID"]
    benchmark["BENCHMARK_NAME"] = row["BENCHMARK_NAME"]
    benchmark["BENCHMARK_DESCRIPTION"] = row["BENCHMARK_DESCRIPTION"]
    benchmark["BENCHMARK_FIELD_ID"] = row["BENCHMARK_FIELD_ID"]
    benchmark["BENCHMARK_FIELD_NAME"] = row["BENCHMARK_FIELD_NAME"]
    benchmark["BENCHMARK_FIELD_DESCRIPTION"] = row["BENCHMARK_FIELD_DESCRIPTION"]
    benchmark["BENCHMARK_AGG"] = row["BENCHMARK_AGG"]

    benchmark["tests"] = benchmark.get("tests", defaultdict(lambda: {}))
    tests = benchmark["tests"]
    test = tests[row["TEST_ID"]]
    test["ID"] = row["TEST_ID"]
    test["TEST_NAME"] = row["TEST_NAME"]
    test["TEST_DESCRIPTION"] = row["TEST_DESCRIPTION"]
    test["TEST_FIELD_ID"] = row["TEST_FIELD_ID"]
    test["TEST_FIELD_NAME"] = row["TEST_FIELD_NAME"]
    test["TEST_FIELD_DESCRIPTION"] = row["TEST_FIELD_DESCRIPTION"]
    test["TEST_AGG"] = row["TEST_AGG"]
    test["LOOP"] = SETUP_MAP[row["evaluation"]]
    test["QUEUE"] = row["domain"]

    test["scenarios"] = test.get("scenarios", defaultdict(lambda: {}))
    scenarios = test["scenarios"]
    scenario = scenarios[row["SCENARIO_ID"]]
    scenario["ID"] = row["SCENARIO_ID"]
    scenario["SCENARIO_NAME"] = row["SCENARIO_NAME"]
    scenario["SCENARIO_DESCRIPTION"] = row["SCENARIO_DESCRIPTION"]
    scenario["SCENARIO_FIELD_ID"] = row["SCENARIO_FIELD_ID"]
    scenario["SCENARIO_FIELD_NAME"] = row["SCENARIO_FIELD_NAME"]
    scenario["SCENARIO_FIELD_DESCRIPTION"] = row["SCENARIO_FIELD_DESCRIPTION"]
    scenario["_source"] = json.loads(row.to_json())

  # print(json.dumps(data, indent=4))
  return data


SETUP_MAP = {
  'semi-automated evaluation': 'INTERACTIVE',
  'fully automated evaluation': 'CLOSED',
  'special evaluation setup': 'OFFLINE',
}


def gen_sqls(data):
  sql = ""
  for benchmark_group_id, benchmark_group in data.items():
    sql += gen_sql_benchmark_group(benchmark_group_id, 'CAMPAIGN', benchmark_group["BENCHMARK_GROUP_NAME"], benchmark_group["BENCHMARK_GROUP_DESCRIPTION"],
                                   list(benchmark_group["benchmarks"].keys()))

    for benchmark_id, benchmark in benchmark_group["benchmarks"].items():
      sql += gen_sql_benchmark(benchmark_id, benchmark["BENCHMARK_NAME"], [benchmark["BENCHMARK_FIELD_ID"]], list(benchmark["tests"].keys()))
      sql += gen_sql_test_benchmark_field(benchmark["BENCHMARK_FIELD_ID"], benchmark["BENCHMARK_FIELD_NAME"], benchmark["BENCHMARK_AGG"])

      for test_id, test in benchmark["tests"].items():
        sql += gen_sql_test([test["ID"]], [test["TEST_NAME"]], [test["TEST_DESCRIPTION"]], [test["TEST_FIELD_ID"]], [list(test["scenarios"].keys())],
                            test["LOOP"], test.get("QUEUE", None))
        sql += gen_sql_test_benchmark_field(test["TEST_FIELD_ID"], test["TEST_FIELD_NAME"], test["TEST_AGG"])
        for scenario_id, scenario in test["scenarios"].items():
          sql += gen_sql_scenario([scenario["ID"]], [scenario["SCENARIO_FIELD_NAME"]], [scenario["SCENARIO_DESCRIPTION"]], [scenario["SCENARIO_FIELD_ID"]])
          sql += gen_sql_scenario_field(scenario["SCENARIO_FIELD_NAME"], scenario["SCENARIO_FIELD_ID"])

  print(sql)

  with Path("/Users/che/workspaces/benchmarking/ts/backend/src/migration/data/V8.1__ai4realnet_example.sql").open("w") as f:
    f.write(sql)
  print(json.dumps(data, indent=4))


if __name__ == '__main__':
  # gen_ai4realnet_playground()
  # gen_flatland3_benchmarks()
  data = extract_ai4realnet_from_csv(csv="/Users/che/workspaces/benchmarking/evaluation/ai4realnet/KPIs_database_cards.csv")

  gen_sqls(data)
  # TODO separate/extract common ai4realnet/benchmarks and add test
  # TODO gen orchestrator code as well
  # TODO make upsert https://neon.com/postgresql/postgresql-tutorial/postgresql-upsert
