def gen_sql_test_benchmark_field(test_or_benchmark_field, key, field_description, agg_func):
  return f"""INSERT INTO field_definitions
        (id, key, description, agg_func, agg_weights)
        VALUES ('{test_or_benchmark_field}', '{key}', '{field_description}', '{agg_func}', NULL)
        ON CONFLICT(id) DO UPDATE SET key=EXCLUDED.key, description=EXCLUDED.description, agg_func=EXCLUDED.agg_func, agg_weights=EXCLUDED.agg_weights;

"""


def gen_sql_scenario_field(key, scenario_field, scenario_field_description):
  return f"""INSERT INTO field_definitions
        (id, key, description, agg_func, agg_weights)
        VALUES ('{scenario_field}', '{key}', '{scenario_field_description}', NULL, NULL)
        ON CONFLICT(id) DO UPDATE SET key=EXCLUDED.key, description=EXCLUDED.description, agg_func=EXCLUDED.agg_func, agg_weights=EXCLUDED.agg_weights;

"""


def gen_sql_scenario(scenario_id, scenario_name, scenario_description, scenario_fields):
  return f"""INSERT INTO scenario_definitions
    (id, name, description, field_ids)
    VALUES ('{scenario_id}', '{escape_sql_string(scenario_name)[:1024]}', '{escape_sql_string(scenario_description)[:1024]}', array['{"\', \'".join(scenario_fields)}']::uuid[])
    ON CONFLICT(id) DO UPDATE SET name=EXCLUDED.name, description=EXCLUDED.description, field_ids=EXCLUDED.field_ids;

"""


def gen_sql_test(test_id, test_name, test_description, test_fields, scenario_ids_for_test, test_type, queue: str = None):
  queue_ = "NULL" if queue is None else f"'{queue.replace(' ', '')}'"
  return f"""INSERT INTO test_definitions
    (id, name, description, field_ids, scenario_ids, loop, queue)
    VALUES ('{test_id}', '{test_name}', '{escape_sql_string(test_description)}', array['{"\', \'".join(test_fields)}']::uuid[], array['{"', '".join(scenario_ids_for_test)}']::uuid[], '{test_type}', {queue_})
    ON CONFLICT(id) DO UPDATE SET name=EXCLUDED.name, description=EXCLUDED.description, field_ids=EXCLUDED.field_ids, scenario_ids=EXCLUDED.scenario_ids, loop=EXCLUDED.loop, queue=EXCLUDED.queue;

"""


def gen_sql_benchmark(benchmark_id, benchmark_name, benchmark_description, benchmark_fields, test_ids):
  return f"""INSERT INTO benchmark_definitions
    (id, name, description, field_ids, test_ids)
    VALUES ('{benchmark_id}', '{benchmark_name}', '{benchmark_description}', array['{"\', \'".join(benchmark_fields)}']::uuid[], array['{"', '".join(test_ids)}']::uuid[])
    ON CONFLICT(id) DO UPDATE SET name=EXCLUDED.name, description=EXCLUDED.description, field_ids=EXCLUDED.field_ids, test_ids=EXCLUDED.test_ids;

"""


def gen_sql_suite(suite_id, suite_setup, suite_name, suite_description, suite_contents, benchmark_ids):
  return f""" INSERT INTO suites
    (id, setup, name, description, contents, benchmark_ids)
    VALUES ('{suite_id}', '{suite_setup}', '{suite_name}', '{suite_description}', '{suite_contents}', array['{"', '".join(benchmark_ids)}']::uuid[])
    ON CONFLICT(id) DO UPDATE SET setup=EXCLUDED.setup, name=EXCLUDED.name, description=EXCLUDED.description, benchmark_ids=EXCLUDED.benchmark_ids;

"""


def escape_sql_string(s):
  return s.replace("\n", "<br/>").replace("'", "''")


def gen_sqls(data) -> str:
  sql = ""
  for suite_id, suite in data.items():
    sql += gen_sql_suite(suite_id, suite["SUITE_SETUP"], suite["SUITE_NAME"], suite["SUITE_DESCRIPTION"], suite.get("SUITE_CONTENTS", ""),
                         list(suite["benchmarks"].keys()))

    for benchmark_id, benchmark in suite["benchmarks"].items():
      sql += gen_sql_benchmark(benchmark_id, benchmark["BENCHMARK_NAME"], benchmark["BENCHMARK_DESCRIPTION"],
                               [benchmark_field["ID"] for benchmark_field in benchmark["BENCHMARK_FIELDS"].values()],
                               list(benchmark["tests"].keys()))
      for benchmark_field in benchmark["BENCHMARK_FIELDS"].values():
        sql += gen_sql_test_benchmark_field(benchmark_field["ID"], benchmark_field["BENCHMARK_FIELD_NAME"],
                                            benchmark_field["BENCHMARK_FIELD_DESCRIPTION"], benchmark_field["BENCHMARK_AGG"])

      for test_id, test in benchmark["tests"].items():
        sql += gen_sql_test(test["ID"], test["TEST_NAME"], test["TEST_DESCRIPTION"], [field_id for field_id in test["TEST_FIELDS"].keys()],
                            [scenario["ID"] for scenario in test["scenarios"].values()],
                            test["LOOP"], test.get("QUEUE", None))
        for test_field in test["TEST_FIELDS"].values():
          sql += gen_sql_test_benchmark_field(test_field["ID"], test_field["TEST_FIELD_NAME"], test_field["TEST_FIELD_DESCRIPTION"],
                                              test_field["TEST_AGG"])
        for scenario in test["scenarios"].values():
          sql += gen_sql_scenario(scenario["ID"], scenario["SCENARIO_NAME"], scenario["SCENARIO_DESCRIPTION"],
                                  [field["ID"] for field in scenario["SCENARIO_FIELDS"].values()])
          for field in scenario["SCENARIO_FIELDS"].values():
            sql += gen_sql_scenario_field(field["SCENARIO_FIELD_NAME"], field["ID"], field["SCENARIO_FIELD_DESCRIPTION"])

  return sql
