import json
from collections import defaultdict
from pathlib import Path

from definitions.benchmarks.flatland_common import gen_flatland_sql
from definitions.gen_benchmarks_common import gen_sqls


def main(truncate_benchmarks_docker_compose: int = 1, truncate_tests_docker_compose: int = 1, truncate_scenarios_docker_compose: int = 1):
  suite_id = '6240c685-0fb4-481e-9404-47a570632227'
  benchmark_id = "c85d5fc2-15da-4a62-8e14-28d1261c29bd"
  test_descriptions = [f"Level {i + 1}" for i in range(6)]
  data = gen_flatland_sql(
    test_type='CLOSED',
    suite_id=suite_id,
    benchmark_id=benchmark_id,
    benchmark_name="Real-World Baselines Challenge",
    benchmark_description="AI4REALNET Railway Competition 2026",
    fields=[["normalized_reward", "NANSUM"], ["percentage_complete", "NANMEAN"]],
    suite_setup="COMPETITION",
    suite_name="Real-World Baselines Challenge",
    suite_description='Dynamic Train Rescheduling under Stochastic Perturbations with Multi-Agent Reinforcement Learning and Operations Research',
    suite_contents=json.dumps({
      'introduction': '<p><b>In this competition we want to find out how to efficiently manage dense traffic on a complex railway network with unforeseen events.</b></p><p>This competition tackles a real-world problem faced by many transportation companies around the world: the vehicle rescheduling problem (VRSP). It aims to identify novel solutions and advance existing approaches for dynamic railway rescheduling to take a step towards real-time rescheduling demands of future railway networks. Your contribution to this challenge might influence how modern traffic management systems are implemented.</p><p>This competition is part of the <a href="https://ai4realnet.eu/" target="_blank">AI4REALNET project</a> (AI for REAL-world NETwork operation).</p>',
      'tabs': [{'title': 'What is Flatland?',
                'text': '<p><a href="https://github.com/flatland-association/flatland-rl" target="_blank">Flatland</a> is an open-source framework for developing and comparing Multi-Agent Reinforcement Learning and Operations Research algorithms in little (or ridiculously large!) grid-worlds. Check out the extensive <a href="https://flatland-association.github.io/flatland-book/intro.html" target="_blank">documentation on GitHub</a> or the <a href="https://arxiv.org/abs/2012.05893" target="_blank">paper on arXiv</a>.</p>'},
               {'title': 'Competition Procedure',
                'text': '<p>The competition consists of two separate tracks, with one dedicated to Reinforcement Learning and one for Operations Research and algorithmic solutions. The competition runs as a <a href="https://ecmlpkdd.org/2026/" target= "_blank">Discovery Challenge at the ECML conference</a>.</p><p><b>Competition start:</b> May 4th, 2026</p><p><b>Competition end:</b> June 8th, 2026 (AoE)</p><p><b>Winner announcement:</b> June 15th, 2026</p><p><b>ECML conference:</b> September 7th, 2026 - September 11th, 2026</p>'},
               {'title': 'Prizes',
                'text': 'There will be a paper written on the competition for the <a href="https://ecmlpkdd.org/2026/" target= "_blank">ECML conference</a> and the best teams and their solutions will be included. Furthermore, these teams get to present their solutions in the dedicated workshop at the conference.'},
               {'title': 'Rules',
                'text': '<p><b>General:</b> In the following, Participant refers to a single person or a participating team. By taking part in this competition, Participants agree to the rules of the competition. Anyone has the right to participate in the competition and participants are allowed to form teams.</p><p><b>Daily Submission Cap:</b> Each Participant may submit up to 5 solutions per day.</p><p><b>Runtime Limitation:</b> The evaluation of a solution will be stopped if a scenario takes longer than 30 minutes or if the overall runtime exceeds 4 hours. The scores for all completed scenarios up to that point will be counted toward to competition.</p><p><b>Open Source:</b> Participants must open source their submissions in order to qualify for prizes.</p><p><b>Evaluation Procedure:</b> Submissions are initially scored automatically and shown on the leaderboard. Top-performing entries are subjected to a secondary human review to resolve any ties and ensure robustness of the scoring methodology.</p><p><b>RL track eligibility:</b> Submissions to the RL track must show evidence of successful training and learning on the <b>Flat</b>land environments.</p>'},
               {'title': 'Contact',
                'text': '<p>Get in touch with us by e-mail <a href="mailto:competition@flatland-association.org">competition@flatland-association.org</a></p>'}]}
    ),
    num_levels_per_test=5,
    test_descriptions=test_descriptions,

  )
  print(data)
  sql = gen_sqls(data)
  with Path("ecml2026.json").open("w") as f:
    f.write(json.dumps(data, indent=4))
  with Path("ecml2026.sql").open("w") as f:
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
  with Path("../../../ts/backend/src/migration/data/V13.6__competition.sql").open("w", encoding="utf-8") as f:
    f.write(sql)

  scenario_data = {}
  TEST_TO_SCENARIO_IDS = defaultdict(list)

  for i, (test_id, test) in enumerate(data[suite_id]["benchmarks"][benchmark_id]['tests'].items()):
    for j, (scenario_id, scenario) in enumerate(test["scenarios"].items()):
      scenario_data[scenario_id] = f"level_{i + 1 :01d}/level_{i + 1 :01d}_scenario_{j + 1:01d}.pkl"
      TEST_TO_SCENARIO_IDS[test_id].append(scenario_id)
  print(json.dumps(scenario_data, indent=4))
  print(json.dumps(TEST_TO_SCENARIO_IDS, indent=4))


if __name__ == '__main__':
  main(truncate_benchmarks_docker_compose=9999,
       truncate_tests_docker_compose=9999,
       truncate_scenarios_docker_compose=9999, )
