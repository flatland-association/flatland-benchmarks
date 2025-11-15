import json
import uuid
from collections import defaultdict
from pathlib import Path

import pandas as pd

from definitions.gen_benchmarks_common import gen_sql_scenario_field, gen_sql_test_benchmark_field, gen_sql_scenario, gen_sql_test, gen_sql_benchmark, \
  gen_sql_suite
from definitions.gen_benchmarks_common import gen_sqls


def gen_ai4realnet_playground():
  test_type = 'CLOSED'

  NUM_LEVELS_PER_BENCHMARK = 1
  num_levels_per_test = 1
  test_descriptions = ['lorem ipsum'] * NUM_LEVELS_PER_BENCHMARK
  suite_id = "0ca46887-897a-463f-bf83-c6cd6269a976"
  # https://ai4realnet.eu/use-cases/
  benchmark_name = "Playground Electricity Network"
  benchmark_name = "Playground Air Traffic Management"
  benchmark_name = "Playground Railway (interactive)"
  test_type = 'CLOSED'
  test_type = 'INTERACTIVE'
  benchmark_description = ""

  fields = [["normalized_reward", "NANSUM"], ["percentage_complete", "NANMEAN"]]
  suite_setup = ""
  suite_name = ""
  suite_description = ""
  suite_contents = ""

  gen_data(num_levels_per_test, suite_id, benchmark_name, benchmark_description, fields, test_descriptions, test_type, suite_setup, suite_name,
           suite_description, suite_contents)


def gen_flatland3_benchmarks(
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
  csv_template="../../benchmarks/flatland3/metadata.csv.template",
) -> dict:
  df_metadata = pd.read_csv(csv_template)
  test_descriptions = [f"Test {i}: {v['n_agents']} agents,  {v['y_dim']}x{v['x_dim']}, {v['n_cities']}" for i, (k, v) in
                       enumerate(list(df_metadata.groupby("test_id").aggregate('first').iterrows()))]

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


def main(truncate_benchmarks_docker_compose: int = 1, truncate_tests_docker_compose: int = 1, truncate_scenarios_docker_compose: int = 1):
  data = gen_flatland3_benchmarks(
    test_type='CLOSED',
    suite_id="24ab2336-a407-4329-b781-d71846250e24",
    benchmark_id="fd6dc299-9d3d-410d-a17c-338dc1cf3752",
    benchmark_name="Warm-up round",
    benchmark_description="The warm-up round runs from November 10th, 2025 - November 28th, 2025",
    fields=[["normalized_reward", "NANSUM"], ["percentage_complete", "NANMEAN"]],
    suite_setup="COMPETITION",
    suite_name="Real-World Baselines Challenge",
    suite_description='Towards Real-Time Train Rescheduling: Multi-Agent Reinforcement Learning and Operations Research for Dynamic Train Rescheduling under Stochastic Perturbations',
    suite_contents='{"introduction":"<p><b>In this competition we want to find out how to efficiently manage dense traffic on a complex railway network with unforeseen events.</b></p><p>This competition tackles a real-world problem faced by many transportation companies around the world: the vehicle rescheduling problem (VRSP). It aims to identify novel solutions and advance existing approaches for dynamic railway rescheduling to take a step towards real-time rescheduling demands of future railway networks. Your contribution to this challenge might influence how modern traffic management systems are implemented.</p><p>This competition is part of the <a href=\\"https://ai4realnet.eu/\\">AI4REALNET project</a> (AI for REAL-world NETwork operation).</p>","tabs":[{"title":"What is Flatland?","text":"<p><a href=\\"https://github.com/flatland-association/flatland-rl\\">Flatland</a> is an open-source framework for developing and comparing Multi-Agent Reinforcement Learning algorithms in little (or ridiculously large!) grid-worlds. Check out the extensive <a href=\\"https://flatland-association.github.io/flatland-book/intro.html\\">documentation on GitHub</a> or the <a href=\\"https://arxiv.org/abs/2012.05893\\">paper on arXiv</a>.</p>"},{"title":"Competition Procedure","text":"<p>The competition consists of a warm-up round for participants to familiarize themselves with the Flatland environment and the competition setup. After that, the proper competition starts with new and more complex environments to tackle.</p><p><b>Warm-up round:</b> November 10th, 2025 - November 28th, 2025</p><p><b>Proper competition:</b> December 1st, 2025 - January 23rd, 2026</p>"},{"title":"Prizes","text":"There will be a paper written on the competition and the best teams and their solutions will be included. The paper is meant to be published and presented at a relevant conference, e.g. NeurIPS."},{"title":"Rules","text":"<p><b>General:</b> In the following, Participant refers to a single person or a participating team. By signing up for this competition, Participants agree to the rules of the competition. Anyone registered as Participant has the right to participate in the competition and participants are allowed to form teams.</p><p><b>Daily Submission Cap:</b> Each Participant may submit up to 5 solutions per day.</p><p><b>Runtime Limitation:</b> The evaluation of a solution will be stopped if double the timesteps of the latest scheduled arrival elapsed during a scenario, or if the evaluation lasts longer than 4 hours. The scores for all completed scenarios up to that point will be counted toward to competition.</p><p><b>Open Source:</b> Participants must open source their submissions in order to qualify for prizes.</p><p>Evaluation Procedure: Submissions are initially scored automatically and shown on the leaderboard. Top-performing entries are subjected to a secondary human review to resolve any ties and ensure robustness of the scoring methodology.</p>"},{"title":"Contact","text":"<p>Join the competition on our Revolt server: tba</p><p>Get in touch with us by e-mail <a href=\\"mailto:competition@flatland-association.org\\">competition@flatland-association.org</a></p>"}]}',
    num_levels_per_test=10,
    csv_template="../../benchmarks/flatland3/metadata.csv.template",
  )
  print(data)
  sql = gen_sqls(data)
  with Path("fab3_definitions.json").open("w") as f:
    f.write(json.dumps(data, indent=4))
  with Path("fab3_definitions.sql").open("w") as f:
    f.write(sql)

  for suite_id, suite in data.items():
    for benchmark_id in list(suite["benchmarks"].keys())[truncate_benchmarks_docker_compose:]:
      del suite["benchmarks"][benchmark_id]

    for benchmark_id, benchmark in list(suite["benchmarks"].items()):
      for test_id in list(benchmark["tests"].keys())[truncate_tests_docker_compose:]:
        del benchmark["tests"][test_id]
      for test_id, test in benchmark["tests"].items():
        for scenario_id in list(test["scenarios"].keys())[truncate_scenarios_docker_compose:]:
          del test["scenarios"][scenario_id]

  sql = gen_sqls(data)
  with Path("../../ts/backend/src/migration/data/V13.1__realworldbaselines_example.sql").open("w", encoding="utf-8") as f:
    f.write(sql)


if __name__ == '__main__':
  main()
