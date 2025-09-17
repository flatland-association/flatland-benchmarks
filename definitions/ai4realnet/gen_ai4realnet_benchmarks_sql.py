import json
from collections import defaultdict
from pathlib import Path

import pandas as pd

from definitions.gen_benchmarks_common import gen_sqls


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
    test["TEST_KPI"] = row["ID"]
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
  return data


SETUP_MAP = {
  'semi-automated evaluation': 'INTERACTIVE',
  'fully automated evaluation': 'CLOSED',
  'special evaluation setup': 'OFFLINE',
}


def sanitize_string_for_python_name(s: str):
  return s.replace('-', '_').replace(' ', '_')

def gen_domain_orchestrator(data, domain):
  s = f"""
{domain.lower().replace(' ', '_')}_orchestrator = Orchestrator(
    test_runners={{
"""
  for benchmark_group_id, benchmark_group in data.items():
    for benchmark_id, benchmark in benchmark_group["benchmarks"].items():
      for test_id, test in benchmark["tests"].items():
        scenario_ids = [f"'{scenario_id}'" for scenario_id in test["scenarios"].keys()]
        if test["QUEUE"] == domain:
          s += f"""
        # {test['TEST_NAME']}
        "{test_id}": TestRunner_{sanitize_string_for_python_name(test['TEST_KPI'])}_{sanitize_string_for_python_name(test['QUEUE'])}(
            test_id="{test_id}", scenario_ids=[{', '.join(scenario_ids)}], benchmark_id="{benchmark_id}"
        ),
"""
  s += f"""
    }}
)
"""
  return s


if __name__ == '__main__':
  # download from from https://flatlandassociation.sharepoint.com/:x:/s/FlatlandAssociation/EanEj4dEBHBDsGzo5WyygCsBIBH7jo502okMbMybT6Bx0g?e=6DotJy
  data = extract_ai4realnet_from_csv(csv="KPIs_database_cards.csv")

  orchestrator_code = ""
  for domain in ["Railway", "ATM", "Power Grid"]:
    orchestrator_code += gen_domain_orchestrator(data, domain)

  with Path("orchestrators.txt").open("w") as f:
    f.write(orchestrator_code)

  sql = gen_sqls(data)
  with Path("V9.1__ai4realnet_example.json").open("w") as f:
    f.write(json.dumps(data, indent=4))

  with Path("../../ts/backend/src/migration/data/V9.1__ai4realnet_example.sql").open("w") as f:
    f.write(sql)
