import json
from collections import defaultdict
from pathlib import Path

from definitions.flatland3_benchmarks.gen_flatland3_benchmarks_sql import gen_flatland3_benchmarks
from definitions.gen_benchmarks_common import gen_sqls


def main(truncate_benchmarks_docker_compose: int = 1, truncate_tests_docker_compose: int = 1, truncate_scenarios_docker_compose: int = 1):
  suite_id = '6240c685-0fb4-481e-9404-47a570632227'
  benchmark_id = "c85d5fc2-15da-4a62-8e14-28d1261c29bd"
  data = gen_flatland3_benchmarks(
    test_type='CLOSED',
    suite_id=suite_id,
    benchmark_id=benchmark_id,
    benchmark_name="Railway competition",
    benchmark_description="The warm-up round runs from November 10th, 2025 - November 28th, 2025",
    fields=[["normalized_reward", "NANSUM"], ["percentage_complete", "NANMEAN"]],
    suite_setup="COMPETITION",
    suite_name="Real-World Baselines Challenge",
    suite_description='Towards Real-Time Train Rescheduling: Multi-Agent Reinforcement Learning and Operations Research for Dynamic Train Rescheduling under Stochastic Perturbations',
    suite_contents='{"introduction":"<p><b>In this competition we want to find out how to efficiently manage dense traffic on a complex railway network with unforeseen events.</b></p><p>This competition tackles a real-world problem faced by many transportation companies around the world: the vehicle rescheduling problem (VRSP). It aims to identify novel solutions and advance existing approaches for dynamic railway rescheduling to take a step towards real-time rescheduling demands of future railway networks. Your contribution to this challenge might influence how modern traffic management systems are implemented.</p><p>This competition is part of the <a href=\\"https://ai4realnet.eu/\\">AI4REALNET project</a> (AI for REAL-world NETwork operation).</p>","tabs":[{"title":"What is Flatland?","text":"<p><a href=\\"https://github.com/flatland-association/flatland-rl\\">Flatland</a> is an open-source framework for developing and comparing Multi-Agent Reinforcement Learning algorithms in little (or ridiculously large!) grid-worlds. Check out the extensive <a href=\\"https://flatland-association.github.io/flatland-book/intro.html\\">documentation on GitHub</a> or the <a href=\\"https://arxiv.org/abs/2012.05893\\">paper on arXiv</a>.</p>"},{"title":"Competition Procedure","text":"<p>The competition consists of a warm-up round for participants to familiarize themselves with the Flatland environment and the competition setup. After that, the proper competition starts with new and more complex environments to tackle.</p><p><b>Warm-up round:</b> November 10th, 2025 - November 28th, 2025</p><p><b>Proper competition:</b> December 1st, 2025 - January 23rd, 2026</p>"},{"title":"Prizes","text":"There will be a paper written on the competition and the best teams and their solutions will be included. The paper is meant to be published and presented at a relevant conference, e.g. NeurIPS."},{"title":"Rules","text":"<p><b>General:</b> In the following, Participant refers to a single person or a participating team. By signing up for this competition, Participants agree to the rules of the competition. Anyone registered as Participant has the right to participate in the competition and participants are allowed to form teams.</p><p><b>Daily Submission Cap:</b> Each Participant may submit up to 5 solutions per day.</p><p><b>Runtime Limitation:</b> The evaluation of a solution will be stopped if double the timesteps of the latest scheduled arrival elapsed during a scenario, or if the evaluation lasts longer than 4 hours. The scores for all completed scenarios up to that point will be counted toward to competition.</p><p><b>Open Source:</b> Participants must open source their submissions in order to qualify for prizes.</p><p>Evaluation Procedure: Submissions are initially scored automatically and shown on the leaderboard. Top-performing entries are subjected to a secondary human review to resolve any ties and ensure robustness of the scoring methodology.</p>"},{"title":"Contact","text":"<p>Join the competition on our Revolt server: tba</p><p>Get in touch with us by e-mail <a href=\\"mailto:competition@flatland-association.org\\">competition@flatland-association.org</a></p>"}]}',
    num_levels_per_test=1,
    csv_template="../../benchmarks/competition/metadata.csv",

  )
  print(data)
  sql = gen_sqls(data)
  with Path("competition_definitions.json").open("w") as f:
    f.write(json.dumps(data, indent=4))
  with Path("competition_definitions.sql").open("w") as f:
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
  with Path("../../ts/backend/src/migration/data/V13.1__copmetition.sql").open("w", encoding="utf-8") as f:
    f.write(sql)

  scenario_data = {}
  TEST_TO_SCENARIO_IDS = defaultdict(list)

  for i, (test_id, test) in enumerate(data[suite_id]["benchmarks"][benchmark_id]['tests'].items()):
    for j, (scenario_id, scenario) in enumerate(test["scenarios"].items()):
      scenario_data[scenario_id] = f"scene_{i:01d}/scene_{i:01d}_initial.pkl"
      TEST_TO_SCENARIO_IDS[test_id].append(scenario_id)
  print(json.dumps(scenario_data, indent=4))
  print(json.dumps(TEST_TO_SCENARIO_IDS, indent=4))


if __name__ == '__main__':
  main(truncate_benchmarks_docker_compose=9999,
       truncate_tests_docker_compose=9999,
       truncate_scenarios_docker_compose=9999, )
