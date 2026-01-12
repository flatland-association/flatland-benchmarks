import json


def gen_sql_test_benchmark_field(test_or_benchmark_field, key, field_description, agg_func, agg_fields=None):
  if agg_fields is None:
    agg_fields = "NULL"
  else:
    agg_fields = f"'{json.dumps(agg_fields)}'"
  return f"""INSERT INTO fields
        (id, key, description, agg_func, agg_fields)
        VALUES ('{test_or_benchmark_field}', '{key}', '{field_description}', '{agg_func}', {agg_fields})
        ON CONFLICT(id) DO UPDATE SET key=EXCLUDED.key, description=EXCLUDED.description, agg_func=EXCLUDED.agg_func, agg_weights=EXCLUDED.agg_weights;

"""


def gen_sql_scenario_field(key, scenario_field, scenario_field_description):
  return f"""INSERT INTO fields
        (id, key, description, agg_func, agg_weights)
        VALUES ('{scenario_field}', '{key}', '{scenario_field_description}', NULL, NULL)
        ON CONFLICT(id) DO UPDATE SET key=EXCLUDED.key, description=EXCLUDED.description, agg_func=EXCLUDED.agg_func, agg_weights=EXCLUDED.agg_weights;

"""


def gen_sql_scenario(scenario_id, scenario_name, scenario_description, scenario_fields):
  return f"""INSERT INTO scenarios
    (id, name, description, field_ids)
    VALUES ('{scenario_id}', '{escape_sql_string(scenario_name)[:1024]}', '{escape_sql_string(scenario_description)[:1024]}', array['{"\', \'".join(scenario_fields)}']::uuid[])
    ON CONFLICT(id) DO UPDATE SET name=EXCLUDED.name, description=EXCLUDED.description, field_ids=EXCLUDED.field_ids;

"""


def gen_sql_test(test_id, test_name, test_description, test_fields, scenario_ids_for_test, test_type, queue: str = None):
  queue_ = "NULL" if queue is None else f"'{queue.replace(' ', '')}'"
  return f"""INSERT INTO tests
    (id, name, description, field_ids, scenario_ids, loop, queue)
    VALUES ('{test_id}', '{test_name}', '{escape_sql_string(test_description)}', array['{"\', \'".join(test_fields)}']::uuid[], array['{"', '".join(scenario_ids_for_test)}']::uuid[], '{test_type}', {queue_})
    ON CONFLICT(id) DO UPDATE SET name=EXCLUDED.name, description=EXCLUDED.description, field_ids=EXCLUDED.field_ids, scenario_ids=EXCLUDED.scenario_ids, loop=EXCLUDED.loop, queue=EXCLUDED.queue;

"""


def gen_sql_benchmark(benchmark_id, benchmark_name, benchmark_description, benchmark_fields, test_ids):
  return f"""INSERT INTO benchmarks
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
    sql += gen_sql_suite(suite_id, suite["SUITE_SETUP"], suite["SUITE_NAME"], suite["SUITE_DESCRIPTION"], suite.get("SUITE_CONTENTS", "{}"),
                         list(suite["benchmarks"].keys()))

    for benchmark_id, benchmark in suite["benchmarks"].items():
      sql += gen_sql_benchmark(benchmark_id, benchmark["BENCHMARK_NAME"], benchmark["BENCHMARK_DESCRIPTION"],
                               [benchmark_field["ID"] for benchmark_field in benchmark["BENCHMARK_FIELDS"].values()],
                               list(benchmark["tests"].keys()))
      for benchmark_field in benchmark["BENCHMARK_FIELDS"].values():
        sql += gen_sql_test_benchmark_field(benchmark_field["ID"], benchmark_field["BENCHMARK_FIELD_NAME"],
                                            benchmark_field["BENCHMARK_FIELD_DESCRIPTION"], benchmark_field["BENCHMARK_AGG"],
                                            benchmark_field["BENCHMARK_AGG_FIELDS"])

      for test_id, test in benchmark["tests"].items():
        sql += gen_sql_test(test["ID"], test["TEST_NAME"], test["TEST_DESCRIPTION"], [field_id for field_id in test["TEST_FIELDS"].keys()],
                            [scenario["ID"] for scenario in test["scenarios"].values()],
                            test["LOOP"], test.get("QUEUE", None))
        for test_field in test["TEST_FIELDS"].values():
          sql += gen_sql_test_benchmark_field(test_field["ID"], test_field["TEST_FIELD_NAME"], test_field["TEST_FIELD_DESCRIPTION"],
                                              test_field["TEST_AGG"], test["TEST_AGG_FIELDS"])
        for scenario in test["scenarios"].values():
          sql += gen_sql_scenario(scenario["ID"], scenario["SCENARIO_NAME"], scenario["SCENARIO_DESCRIPTION"],
                                  [field["ID"] for field in scenario["SCENARIO_FIELDS"].values()])
          for field in scenario["SCENARIO_FIELDS"].values():
            sql += gen_sql_scenario_field(field["SCENARIO_FIELD_NAME"], field["ID"], field["SCENARIO_FIELD_DESCRIPTION"])
  return sql

# csv: one row per field of the definition
#
# data model:
# - definition references its fields and child definitions
# - field has name and knows agg_func and (agg_weights) and agg_fields (by name) of the children values
# convention:
# - by default scenario, test, benchmark have key primary
# - railway may have keys [punctuality, success_rate] resp. [network_impact_propagation] at scenario level, test level only has [punctuality], [successrate]
#
# Example:
#
# benchmark '3b1bdca6-ed90-4938-bd63-fd657aa7dcd7', 'Effectiveness'
# |       -> field '33c1f8a3-5764-44cc-988b-0f9a53b7f4a1', 'primary', 'Benchmark score (MEAN of test scores)', 'NANMEAN', '["primary", "primary", "primary", "punctuality", "primary", "primary", "primary", "primary"]')
# |- test 'aba10b3f-0d5c-4f90-aec4-69460bbb098b', 'KPI-AF-008: Assistant alert accuracy (P...
# |   ...
# |- test '98ceb866-5479-47e6-a735-81292de8ca65', 'KPI-PF-026: Punctuality (Railway)'
#    |    -> field '1de0f52c-ae47-4847-9148-97b8568952d3', 'punctuality', 'Test score (MEAN of scenario scores)', 'MEAN', NULL, NULL
#    |    -> field '------------------------------------', 'success_rate', 'Test score (MEAN of scenario scores)', 'MEAN', NULL, NULL
#    |- scenario '5a60713d-01f2-4d32-9867-21904629e254', 'Scenario 000 - Punctuality measures the percentage of trains arriving at thei....
#    |    -> field 'c2a66425-186d-423b-b002-391c091b33c6', 'punctuality', 'Primary scenario score (raw values): punctuality', NULL, NULL)
#    |    -> field 'f56b119f-719d-4601-94ff-e511b2aaeeed', 'success_rate', 'Secondary scenario score (raw values): success_rate', NULL, NULL
#    |- scenario '0db72a40-43e8-477b-89b3-a7bd1224660a'
#         -> field 'f0f478d6-436e-476f-be79-33d8c34f20c1'
#         -> field 'a5c6d789-0c00-413d-b689-862806dd9b56'
#
# N.B. in order to have '------------------------------------', we'd have to add row in csv for the corresponding test referencing the underlying
