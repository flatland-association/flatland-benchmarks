import json
from pathlib import Path
from uuid import uuid4

import pandas as pd


def main():
  # '0ca46887-897a-463f-bf83-c6cd6269a976', 'CAMPAIGN', 'Beta Validation Campaign', 'The beta validation campaign runs until 30.11.2025'
  BENCHMARK_GROUP_ID = '0ca46887-897a-463f-bf83-c6cd6269a976'
  with Path("KPIs_database_cards.json").open() as f:
    data = json.loads(f.read())
    print(json.dumps(data, indent=4))
  objectives = {}
  for d in data:
    objectives[d["objective"]] = str(uuid4())
  records = []
  for d in data:
    for domain in d["domain"]:
      record = json.loads(json.dumps(d))
      record["ID"] += f" ({domain})"
      record["title"] += f" ({domain})"
      record["domains"] = record["domain"]
      record["domain"] = domain

      record["BENCHMARK_GROUP_ID"] = BENCHMARK_GROUP_ID
      record["BENCHMARK_ID"] = objectives[d["objective"]]
      record["TEST_ID"] = str(uuid4())
      record["SCENARIO_ID"] = str(uuid4())

      records.append(record)
  df = pd.DataFrame.from_records(records)
  print(df)
  print(df.to_csv())
  with Path("KPIs_database_cards.csv").open("w") as f:
    f.write(df.to_csv())


if __name__ == '__main__':
  main()
