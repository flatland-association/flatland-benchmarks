import re


def gen_sql_test_benchmark_field(test_or_benchmark_field, key, agg_func):
  return f"""INSERT INTO field_definitions
        (id, key, description, agg_func, agg_weights)
        VALUES
        ('{test_or_benchmark_field}', '{key}', 'Benchmark score ({agg_func} of test scores)', '{agg_func}', NULL);

"""


def gen_sql_scenario_field(key, scenario_field):
  return f"""INSERT INTO field_definitions
        (id, key, description, agg_func, agg_weights)
        VALUES
        ('{scenario_field}', '{key}', 'Scenario score (raw values)', NULL, NULL);

"""


def gen_sql_scenario(scenario_id, scenario_name, scenario_description, scenario_fields):
  scenario_definition = f"""INSERT INTO scenario_definitions
    (id, name, description, field_ids)
    VALUES
  ('{scenario_id}', '{scenario_name}', '{escape_sql_string(scenario_description)}', array['{"\', \'".join(scenario_fields)}']::uuid[]),

"""
  scenario_definition = re.sub(",\n$", ";\n", scenario_definition)
  return scenario_definition


def gen_sql_test(test_id, test_name, test_description, test_fields, scenario_ids_for_test, test_type, queue=None):
  queue_ = "NULL" if queue is None else f"'{queue}'"
  test_definitions = f"""INSERT INTO test_definitions
    (id, name, description, field_ids, scenario_ids, loop, queue)
    VALUES
    ('{test_id}', '{test_name}', '{escape_sql_string(test_description)}', array['{"\', \'".join(test_fields)}']::uuid[], array['{"', '".join(scenario_ids_for_test)}']::uuid[], '{test_type}', {queue_}),

"""
  test_definitions = re.sub(",\n$", ";\n", test_definitions)
  return test_definitions


def gen_sql_benchmark(benchmark_id, benchmark_name, benchmark_fields, test_ids):
  return f"""INSERT INTO benchmark_definitions
    (id, name, description, field_ids, test_ids)
    VALUES
    ('{benchmark_id}', '{benchmark_name}', '{benchmark_name}', array['{"\', \'".join(benchmark_fields)}']::uuid[], array['{"', '".join(test_ids)}']::uuid[]);

"""


def gen_sql_benchmark_group(benchmark_group_id, benchmark_group_setup, benchmark_group_name, benchmark_group_description, benchmark_ids):
  return f""" INSERT INTO benchmark_groups
    (id, setup, name, description, benchmark_ids)
    VALUES
    ('{benchmark_group_id}', '{benchmark_group_setup}', '{benchmark_group_name}', '{benchmark_group_description}', array['{"', '".join(benchmark_ids)}']::uuid[]);

"""


def escape_sql_string(s):
  return s.replace("\n", "<br/>").replace("'", "''")


def gen_sqls(data) -> str:
  sql = ""
  for benchmark_group_id, benchmark_group in data.items():
    sql += gen_sql_benchmark_group(benchmark_group_id, 'CAMPAIGN', benchmark_group["BENCHMARK_GROUP_NAME"], benchmark_group["BENCHMARK_GROUP_DESCRIPTION"],
                                   list(benchmark_group["benchmarks"].keys()))

    for benchmark_id, benchmark in benchmark_group["benchmarks"].items():
      sql += gen_sql_benchmark(benchmark_id, benchmark["BENCHMARK_NAME"], [benchmark["BENCHMARK_FIELD_ID"]], list(benchmark["tests"].keys()))
      sql += gen_sql_test_benchmark_field(benchmark["BENCHMARK_FIELD_ID"], benchmark["BENCHMARK_FIELD_NAME"], benchmark["BENCHMARK_AGG"])

      for test_id, test in benchmark["tests"].items():
        sql += gen_sql_test(test["ID"], test["TEST_NAME"], test["TEST_DESCRIPTION"], [test["TEST_FIELD_ID"]], list(test["scenarios"].keys()),
                            test["LOOP"], test.get("QUEUE", None))
        sql += gen_sql_test_benchmark_field(test["TEST_FIELD_ID"], test["TEST_FIELD_NAME"], test["TEST_AGG"])
        for scenario_id, scenario in test["scenarios"].items():
          sql += gen_sql_scenario(scenario["ID"], scenario["SCENARIO_FIELD_NAME"], scenario["SCENARIO_DESCRIPTION"], [scenario["SCENARIO_FIELD_ID"]])
          sql += gen_sql_scenario_field(scenario["SCENARIO_FIELD_NAME"], scenario["SCENARIO_FIELD_ID"])

  return sql
