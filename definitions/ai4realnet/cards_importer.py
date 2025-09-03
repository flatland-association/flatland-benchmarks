import json
from pathlib import Path
from uuid import uuid4

import pandas as pd


def main():
  BENCHMARK_GROUP_ID = '0ca46887-897a-463f-bf83-c6cd6269a977'
  BENCHMARK_GROUP_NAME = 'Beta Validation Campaign'
  BENCHMARK_GROUP_DESCRIPTION = 'The beta validation campaign runs until 30.11.2025'
  agg_func = "MEAN"

  with Path("KPIs_database_cards.json").open() as f:
    data = json.loads(f.read())
    print(json.dumps(data, indent=4))
  objectives = {}
  for d in data:
    objectives[d["objective"]] = str(uuid4())

  fields_tests = {}

  records = []
  for d in data:
    for domain in d["domain"]:
      record = json.loads(json.dumps(d))

      record["domains"] = record["domain"]
      record["domain"] = domain

      record["BENCHMARK_GROUP_ID"] = BENCHMARK_GROUP_ID
      record["BENCHMARK_GROUP_NAME"] = BENCHMARK_GROUP_NAME
      record["BENCHMARK_GROUP_DESCRIPTION"] = BENCHMARK_GROUP_DESCRIPTION
      record["BENCHMARK_ID"] = objectives[d["objective"]]
      record["BENCHMARK_NAME"] = record["objective"]
      record["BENCHMARK_DESCRIPTION"] = record["objectiveDescription"]
      record["BENCHMARK_FIELD_ID"] = fields_tests.setdefault(record["BENCHMARK_ID"], str(uuid4()))
      record["BENCHMARK_FIELD_NAME"] = f'primary'
      record["BENCHMARK_FIELD_DESCRIPTION"] = f'Benchmark score ({agg_func} of test scores)'
      record["BENCHMARK_AGG"] = agg_func
      record["TEST_ID"] = fields_tests.setdefault(record["ID"] + domain, str(uuid4()))
      record["TEST_NAME"] = f"{record['ID']}: {record['title']} ({domain})"
      record["TEST_DESCRIPTION"] = record['description']
      record["TEST_FIELD_ID"] = fields_tests.setdefault(record["TEST_ID"], str(uuid4()))
      record["TEST_FIELD_NAME"] = f'primary'
      record["TEST_FIELD_DESCRIPTION"] = f'Test score ({agg_func} of scenario scores)'
      record["TEST_AGG"] = agg_func
      record["SCENARIO_ID"] = str(uuid4())
      record["SCENARIO_NAME"] = f"Scenario 1 - {record['TEST_DESCRIPTION']}"
      record["SCENARIO_DESCRIPTION"] = record['objectiveDescription']
      record["SCENARIO_FIELD_ID"] = fields_tests.setdefault(record["SCENARIO_ID"], str(uuid4()))
      record["SCENARIO_FIELD_NAME"] = 'primary'
      record["SCENARIO_FIELD_DESCRIPTION"] = 'Scenario score (raw values)'

      records.append(record)
  df = pd.DataFrame.from_records(records)
  print(df)
  print(df.to_csv())
  with Path("KPIs_database_cards.csv").open("w") as f:
    f.write(df.to_csv())


if __name__ == '__main__':
  main()
