"""
Update benchmark definitions by editing KPIs_database_cards.csv.

In:
  - KPIs_database_cards.csv
Out (updating):
  - ai4realnet_definitions.json
  - ai4realnet_definitions.sql
  - V13.1__ai4realnet_example.sql
"""
import json
import uuid
from collections import defaultdict
from pathlib import Path

import pandas as pd

from definitions.gen_benchmarks_common import gen_sqls


def extract_ai4realnet_from_csv(csv):
  df = pd.read_csv(csv)  # , on_bad_lines="skip", )
  if False:
    df["BENCHMARK_AGG"] = "NANMEAN"
    df.to_csv(csv, index=False)

  data = defaultdict(lambda: {})

  for _, row in df.iterrows():
    suite = data[row["SUITE_ID"]]
    suite["ID"] = row["SUITE_ID"]
    suite["SUITE_NAME"] = row["SUITE_NAME"]
    suite["SUITE_DESCRIPTION"] = row["SUITE_DESCRIPTION"]
    suite["SUITE_SETUP"] = "CAMPAIGN"

    suite["benchmarks"] = suite.get("benchmarks", defaultdict(lambda: {}))
    benchmarks = suite["benchmarks"]
    benchmark = benchmarks[row["BENCHMARK_ID"]]
    benchmark["ID"] = row["ID"]
    benchmark["BENCHMARK_NAME"] = row["BENCHMARK_NAME"]
    benchmark["BENCHMARK_DESCRIPTION"] = row["BENCHMARK_NAME"]
    benchmark["BENCHMARK_FIELDS"] = benchmark.get("BENCHMARK_FIELDS", {})
    benchmark["BENCHMARK_FIELDS"][row["BENCHMARK_FIELD_ID"]] = {
      "ID": row["BENCHMARK_FIELD_ID"],
      "BENCHMARK_FIELD_NAME": row["BENCHMARK_FIELD_NAME"],
      "BENCHMARK_FIELD_DESCRIPTION": row["BENCHMARK_FIELD_DESCRIPTION"],
      "BENCHMARK_AGG": row["BENCHMARK_AGG"]
    }

    benchmark["tests"] = benchmark.get("tests", defaultdict(lambda: {}))
    tests = benchmark["tests"]
    test = tests[row["TEST_ID"]]
    test["ID"] = row["TEST_ID"]
    test["TEST_KPI"] = row["ID"]
    test["TEST_NAME"] = row["TEST_NAME"]
    test["TEST_DESCRIPTION"] = row["TEST_DESCRIPTION"]
    test["TEST_FIELDS"] = test.get("TEST_FIELDS", {})
    # row in csv describes which TEST_FIELD_NAME its first field maps to.
    test["TEST_FIELDS"][row["TEST_FIELD_ID"]] = {
      "ID": row["TEST_FIELD_ID"],
      "TEST_FIELD_NAME": row["TEST_FIELD_NAME"],
      "TEST_FIELD_DESCRIPTION": row["TEST_FIELD_DESCRIPTION"],
      "TEST_AGG": row["TEST_AGG"]
    }
    test["LOOP"] = SETUP_MAP[row["evaluation"]]
    test["QUEUE"] = row["domain"]

    test["scenarios"] = test.get("scenarios", defaultdict(lambda: {}))
    scenarios = test["scenarios"]
    scenario = scenarios[row["SCENARIO_ID"]]
    scenario["ID"] = row["SCENARIO_ID"]
    scenario["SCENARIO_NAME"] = row["SCENARIO_NAME"]
    scenario["SCENARIO_DESCRIPTION"] = row["SCENARIO_DESCRIPTION"]
    scenario["SCENARIO_FIELDS"] = scenario.get("SCENARIO_FIELDS", {})
    scenario["SCENARIO_FIELDS"][row["SCENARIO_FIELD_ID"]] = {
      "ID": row["SCENARIO_FIELD_ID"],
      "SCENARIO_FIELD_NAME": row["SCENARIO_FIELD_NAME"],
      "SCENARIO_FIELD_DESCRIPTION": row["SCENARIO_FIELD_DESCRIPTION"],
    }

  # TODO can we collect above already?
  for suite_id, suite in data.items():
    for benchmark_id, benchmark in suite["benchmarks"].items():
      benchmark_agg_fields = []
      for test_id, test in benchmark["tests"].items():
        test_agg_fields = None
        for scenario_id, scenario in test["scenarios"].items():
          if test_agg_fields is None:
            test_agg_fields = [sc["SCENARIO_FIELD_NAME"] for sc in scenario["SCENARIO_FIELDS"].values()]
          else:
            # verify all scenarios have the same keys
            assert test_agg_fields == [sc["SCENARIO_FIELD_NAME"] for sc in scenario["SCENARIO_FIELDS"].values()]
        test["TEST_AGG_FIELDS"] = test_agg_fields
        benchmark_agg_fields.append(test["TEST_AGG_FIELDS"][0])
      assert len(benchmark["BENCHMARK_FIELDS"].values()) == 1
      list(benchmark["BENCHMARK_FIELDS"].values())[0]["BENCHMARK_AGG_FIELDS"] = benchmark_agg_fields
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
  for suite_id, suite in data.items():
    for benchmark_id, benchmark in suite["benchmarks"].items():
      for test_id, test in benchmark["tests"].items():
        scenario_ids = [f"'{scenario['ID']}'" for scenario in test["scenarios"].values()]
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


def explode_row(csv, start_row: int, num_scenarios: int, additional_keys=None, primary_override=None):
  df = pd.read_csv(csv, index_col=[0])
  row = df.iloc[[start_row]]
  print(row)
  rows = []
  for i in range(num_scenarios):
    template = json.loads(json.dumps(row.to_dict('records')))[0]
    template["SCENARIO_NAME"] = template["SCENARIO_NAME"].replace("Scenario 1", f'Scenario {i:03d}')
    if i > 0:
      template["SCENARIO_ID"] = str(uuid.uuid4())
      template["SCENARIO_FIELD_ID"] = str(uuid.uuid4())
    if primary_override is not None:
      key, desc = primary_override
      template["SCENARIO_FIELD_NAME"] = key
      template["SCENARIO_FIELD_DESCRIPTION"] = desc
      template["TEST_FIELD_NAME"] = key
      template["BENCHMARK_FIELD_NAME"] = key
    rows.append(template)

    if additional_keys is not None:
      for key, desc in additional_keys:
        template = json.loads(json.dumps(template))
        template["SCENARIO_FIELD_ID"] = str(uuid.uuid4())
        template["SCENARIO_FIELD_NAME"] = key
        template["SCENARIO_FIELD_DESCRIPTION"] = desc
        rows.append(template)

  concat = pd.concat([df.iloc[:start_row], pd.DataFrame.from_records(rows), df.iloc[start_row + 1:]], ignore_index=True)
  return concat


def main(truncate_scenarios_docker_compose=2):
  if False:
    df = explode_row(csv="KPIs_database_cards.csv", start_row=40, num_scenarios=150,
                     primary_override=("punctuality", "Primary scenario score (raw values): punctuality"),
                     additional_keys=[("success_rate", "Secondary scenario score (raw values): success_rate")],
                     )
    df.to_csv("KPIs_database_cards.csv")
  if False:
    df = explode_row(csv="KPIs_database_cards.csv", start_row=364, num_scenarios=150,
                     primary_override=("network_impact_propagation", "Primary scenario score (raw values): network_impact_propagation"),
                     additional_keys=[
                       ("success_rate_1", "Secondary scenario score (raw values): success_rate scenario without malfunction"),
                       ("punctuality_1", "Secondary scenario score (raw values): punctuality scenario without malfunction"),
                       ("success_rate_2", "Secondary scenario score (raw values): success_rate scenario without malfunction"),
                       ("punctuality_2", "Secondary scenario score (raw values): punctuality scenario without malfunction"),
                     ],
                     )
    df.to_csv("KPIs_database_cards.csv")
  # download from https://flatlandassociation.sharepoint.com/:x:/s/FlatlandAssociation/EanEj4dEBHBDsGzo5WyygCsBIBH7jo502okMbMybT6Bx0g?e=6DotJy
  data = extract_ai4realnet_from_csv(csv="KPIs_database_cards.csv")
  orchestrator_code = ""
  for domain in ["Railway", "ATM", "Power Grid"]:
    orchestrator_code += gen_domain_orchestrator(data, domain)
  with Path("orchestrators.txt").open("w") as f:
    f.write(orchestrator_code)
  sql = gen_sqls(data)
  with Path("ai4realnet_definitions.json").open("w") as f:
    f.write(json.dumps(data, indent=4))
  with Path("ai4realnet_definitions.sql").open("w") as f:
    f.write(sql)

  for suite_id, suite in data.items():
    for benchmark_id, benchmark in suite["benchmarks"].items():
      for test_id, test in benchmark["tests"].items():
        for scenario_id in list(test["scenarios"].keys())[truncate_scenarios_docker_compose:]:
          del test["scenarios"][scenario_id]

  sql = gen_sqls(data)
  with Path("../../ts/backend/src/migration/data/V13.2__ai4realnet_example.sql").open("w", encoding="utf-8") as f:
    f.write(sql)


if __name__ == '__main__':
  main(truncate_scenarios_docker_compose=2)
