INSERT INTO suites
  (id, setup, name, description, contents, benchmark_ids)
VALUES ('6240c685-0fb4-481e-9404-47a570632227', 'COMPETITION', 'Real-World Baselines Challenge',
        'Dynamic Train Rescheduling under Stochastic Perturbations with Multi-Agent Reinforcement Learning and Operations Research',
        '{"introduction": "<p><b>In this competition we want to find out how to efficiently manage dense traffic on a complex railway network with unforeseen events.</b></p><p>This competition tackles a real-world problem faced by many transportation companies around the world: the vehicle rescheduling problem (VRSP). It aims to identify novel solutions and advance existing approaches for dynamic railway rescheduling to take a step towards real-time rescheduling demands of future railway networks. Your contribution to this challenge might influence how modern traffic management systems are implemented.</p><p>This competition is part of the <a href=\"https://ai4realnet.eu/\" target=\"_blank\">AI4REALNET project</a> (AI for REAL-world NETwork operation).</p>", "tabs": [{"title": "What is Flatland?", "text": "<p><a href=\"https://github.com/flatland-association/flatland-rl\" target=\"_blank\">Flatland</a> is an open-source framework for developing and comparing Multi-Agent Reinforcement Learning and Operations Research algorithms in little (or ridiculously large!) grid-worlds. Check out the extensive <a href=\"https://flatland-association.github.io/flatland-book/intro.html\" target=\"_blank\">documentation on GitHub</a> or the <a href=\"https://arxiv.org/abs/2012.05893\" target=\"_blank\">paper on arXiv</a>.</p>"}, {"title": "Competition Procedure", "text": "<p>The competition consists of two separate tracks, with one dedicated to Reinforcement Learning and one for Operations Research and algorithmic solutions. The competition runs as a <a href=\"https://ecmlpkdd.org/2026/\" target= \"_blank\">Discovery Challenge at the ECML conference</a>.</p><p></p><p><b>Competition start:</b> May 4th, 2026</p><p><b>Competition end:</b> June 8th, 2026 (AoE)</p>p><b>Winner announcement:</b> June 15th, 2026</p>p><b>ECML conference:</b> September 7th, 2026 - September 11th, 2026</p>"}, {"title": "Prizes", "text": "There will be a paper written on the competition for the <a href=\"https://ecmlpkdd.org/2026/\" target= \"_blank\">ECML conference</a> and the best teams and their solutions will be included. Furthermore, these teams get to present their solutions in the dedicated workshop at the conference."}, {"title": "Rules", "text": "<p><b>General:</b> In the following, Participant refers to a single person or a participating team. By taking part in this competition, Participants agree to the rules of the competition. Anyone has the right to participate in the competition and participants are allowed to form teams.</p><p><b>Daily Submission Cap:</b> Each Participant may submit up to 5 solutions per day.</p><p><b>Runtime Limitation:</b> The evaluation of a solution will be stopped if a scenario takes longer than 30 minutes or if the overall runtime exceeds 4 hours. The scores for all completed scenarios up to that point will be counted toward to competition.</p><p><b>Open Source:</b> Participants must open source their submissions in order to qualify for prizes.</p><p><b>Evaluation Procedure:</b> Submissions are initially scored automatically and shown on the leaderboard. Top-performing entries are subjected to a secondary human review to resolve any ties and ensure robustness of the scoring methodology.</p><p><b>RL track eligibility:</b> Submissions to the RL track must show evidence of successful training and learning on the <b>Flat</b>land environments.</p>"}, {"title": "Contact", "text": "<p>Get in touch with us by e-mail <a href=\"mailto:competition@flatland-association.org\">competition@flatland-association.org</a></p>"}]}',
        array['c85d5fc2-15da-4a62-8e14-28d1261c29bd']::uuid[]) ON CONFLICT(id) DO
UPDATE SET setup=EXCLUDED.setup, name =EXCLUDED.name, description=EXCLUDED.description, contents=EXCLUDED.contents, benchmark_ids=EXCLUDED.benchmark_ids;

INSERT INTO benchmarks
  (id, name, description, field_ids, test_ids)
VALUES ('c85d5fc2-15da-4a62-8e14-28d1261c29bd', 'Real-World Baselines Challenge', 'AI4REALNET Railway Competition 2026',
        array['ba23a9d1-05a6-4f2a-9d58-878f6fa6917f', '021d12e1-5d56-4716-a2d1-f8f63790fd6c']::uuid[], array['774bf9d6-7bd6-41da-925a-230658d481ec',
        '6670be1d-9fc0-48c8-9bc9-fc889f56d615', 'f3aefb9c-a79e-413a-b73c-f46c794855c1', '68ade1f2-301f-4d8d-b9d6-f3110b6e7587',
        'd49091c0-793b-401b-a0c8-12df1361deef', '86225a96-492d-474b-aa80-de166b005e42']::uuid[]) ON CONFLICT(id) DO
UPDATE SET name=EXCLUDED.name, description=EXCLUDED.description, field_ids=EXCLUDED.field_ids, test_ids=EXCLUDED.test_ids;

INSERT INTO fields
  (id, key, description, agg_func, agg_fields)
VALUES ('ba23a9d1-05a6-4f2a-9d58-878f6fa6917f', 'normalized_reward', 'Primary benchmark score (NANSUM of corresponding test scores)', 'NANSUM',
        '"normalized_reward"') ON CONFLICT(id) DO
UPDATE SET key =EXCLUDED.key, description=EXCLUDED.description, agg_func=EXCLUDED.agg_func, agg_weights=EXCLUDED.agg_weights;

INSERT INTO fields
  (id, key, description, agg_func, agg_fields)
VALUES ('021d12e1-5d56-4716-a2d1-f8f63790fd6c', 'percentage_complete', 'Secondary benchmark score (NANMEAN of corresponding test scores)', 'NANMEAN',
        '"percentage_complete"') ON CONFLICT(id) DO
UPDATE SET key =EXCLUDED.key, description=EXCLUDED.description, agg_func=EXCLUDED.agg_func, agg_weights=EXCLUDED.agg_weights;

INSERT INTO tests
  (id, name, description, field_ids, scenario_ids, loop, queue)
VALUES ('774bf9d6-7bd6-41da-925a-230658d481ec', 'Test 0', 'Level 1', array['75f7ebf7-e79e-4f2c-bb78-c51f996fc5c9',
        '7bbb3f10-1a1f-4c69-b882-6ed2b84d1e85']::uuid[], array['5eea815c-7500-42ff-b763-9012fae3ba0a', '0ca69b1b-5aa2-4e32-8829-fbd876c175e9',
        'ec4d780e-7249-4d62-b124-7e3f7f38a441', 'eb690e1f-6b01-4311-98af-195863693775', 'bc398385-b9bc-4f08-91e2-9b70cba8e54f']::uuid[], 'CLOSED',
        NULL) ON CONFLICT(id) DO
UPDATE SET name=EXCLUDED.name, description=EXCLUDED.description, field_ids=EXCLUDED.field_ids, scenario_ids=EXCLUDED.scenario_ids, loop=EXCLUDED.loop, queue=EXCLUDED.queue;

INSERT INTO fields
  (id, key, description, agg_func, agg_fields)
VALUES ('75f7ebf7-e79e-4f2c-bb78-c51f996fc5c9', 'normalized_reward', 'Primary test score (NANSUM of corresponding scenario scores)', 'NANSUM',
        '"percentage_complete"') ON CONFLICT(id) DO
UPDATE SET key =EXCLUDED.key, description=EXCLUDED.description, agg_func=EXCLUDED.agg_func, agg_weights=EXCLUDED.agg_weights;

INSERT INTO fields
  (id, key, description, agg_func, agg_fields)
VALUES ('7bbb3f10-1a1f-4c69-b882-6ed2b84d1e85', 'percentage_complete', 'Secondary test score (NANMEAN of corresponding scenario scores)', 'NANMEAN',
        '"percentage_complete"') ON CONFLICT(id) DO
UPDATE SET key =EXCLUDED.key, description=EXCLUDED.description, agg_func=EXCLUDED.agg_func, agg_weights=EXCLUDED.agg_weights;

INSERT INTO scenarios
  (id, name, description, field_ids)
VALUES ('5eea815c-7500-42ff-b763-9012fae3ba0a', '5eea815c-7500-42ff-b763-9012fae3ba0a', '5eea815c-7500-42ff-b763-9012fae3ba0a',
        array['9900f111-abbb-44d4-b022-3a1d9e2efded', '758acf5a-498d-40db-9a8b-39adf47b5d28']::uuid[]) ON CONFLICT(id) DO
UPDATE SET name=EXCLUDED.name, description=EXCLUDED.description, field_ids=EXCLUDED.field_ids;

INSERT INTO fields
  (id, key, description, agg_func, agg_weights)
VALUES ('9900f111-abbb-44d4-b022-3a1d9e2efded', 'normalized_reward', 'Primary raw scenario score.', NULL, NULL) ON CONFLICT(id) DO
UPDATE SET key =EXCLUDED.key, description=EXCLUDED.description, agg_func=EXCLUDED.agg_func, agg_weights=EXCLUDED.agg_weights;

INSERT INTO fields
  (id, key, description, agg_func, agg_weights)
VALUES ('758acf5a-498d-40db-9a8b-39adf47b5d28', 'percentage_complete', 'Secondary raw scenario score.', NULL, NULL) ON CONFLICT(id) DO
UPDATE SET key =EXCLUDED.key, description=EXCLUDED.description, agg_func=EXCLUDED.agg_func, agg_weights=EXCLUDED.agg_weights;

INSERT INTO scenarios
  (id, name, description, field_ids)
VALUES ('0ca69b1b-5aa2-4e32-8829-fbd876c175e9', '0ca69b1b-5aa2-4e32-8829-fbd876c175e9', '0ca69b1b-5aa2-4e32-8829-fbd876c175e9',
        array['9900f111-abbb-44d4-b022-3a1d9e2efded', '758acf5a-498d-40db-9a8b-39adf47b5d28']::uuid[]) ON CONFLICT(id) DO
UPDATE SET name=EXCLUDED.name, description=EXCLUDED.description, field_ids=EXCLUDED.field_ids;

INSERT INTO fields
  (id, key, description, agg_func, agg_weights)
VALUES ('9900f111-abbb-44d4-b022-3a1d9e2efded', 'normalized_reward', 'Primary raw scenario score.', NULL, NULL) ON CONFLICT(id) DO
UPDATE SET key =EXCLUDED.key, description=EXCLUDED.description, agg_func=EXCLUDED.agg_func, agg_weights=EXCLUDED.agg_weights;

INSERT INTO fields
  (id, key, description, agg_func, agg_weights)
VALUES ('758acf5a-498d-40db-9a8b-39adf47b5d28', 'percentage_complete', 'Secondary raw scenario score.', NULL, NULL) ON CONFLICT(id) DO
UPDATE SET key =EXCLUDED.key, description=EXCLUDED.description, agg_func=EXCLUDED.agg_func, agg_weights=EXCLUDED.agg_weights;

INSERT INTO scenarios
  (id, name, description, field_ids)
VALUES ('ec4d780e-7249-4d62-b124-7e3f7f38a441', 'ec4d780e-7249-4d62-b124-7e3f7f38a441', 'ec4d780e-7249-4d62-b124-7e3f7f38a441',
        array['9900f111-abbb-44d4-b022-3a1d9e2efded', '758acf5a-498d-40db-9a8b-39adf47b5d28']::uuid[]) ON CONFLICT(id) DO
UPDATE SET name=EXCLUDED.name, description=EXCLUDED.description, field_ids=EXCLUDED.field_ids;

INSERT INTO fields
  (id, key, description, agg_func, agg_weights)
VALUES ('9900f111-abbb-44d4-b022-3a1d9e2efded', 'normalized_reward', 'Primary raw scenario score.', NULL, NULL) ON CONFLICT(id) DO
UPDATE SET key =EXCLUDED.key, description=EXCLUDED.description, agg_func=EXCLUDED.agg_func, agg_weights=EXCLUDED.agg_weights;

INSERT INTO fields
  (id, key, description, agg_func, agg_weights)
VALUES ('758acf5a-498d-40db-9a8b-39adf47b5d28', 'percentage_complete', 'Secondary raw scenario score.', NULL, NULL) ON CONFLICT(id) DO
UPDATE SET key =EXCLUDED.key, description=EXCLUDED.description, agg_func=EXCLUDED.agg_func, agg_weights=EXCLUDED.agg_weights;

INSERT INTO scenarios
  (id, name, description, field_ids)
VALUES ('eb690e1f-6b01-4311-98af-195863693775', 'eb690e1f-6b01-4311-98af-195863693775', 'eb690e1f-6b01-4311-98af-195863693775',
        array['9900f111-abbb-44d4-b022-3a1d9e2efded', '758acf5a-498d-40db-9a8b-39adf47b5d28']::uuid[]) ON CONFLICT(id) DO
UPDATE SET name=EXCLUDED.name, description=EXCLUDED.description, field_ids=EXCLUDED.field_ids;

INSERT INTO fields
  (id, key, description, agg_func, agg_weights)
VALUES ('9900f111-abbb-44d4-b022-3a1d9e2efded', 'normalized_reward', 'Primary raw scenario score.', NULL, NULL) ON CONFLICT(id) DO
UPDATE SET key =EXCLUDED.key, description=EXCLUDED.description, agg_func=EXCLUDED.agg_func, agg_weights=EXCLUDED.agg_weights;

INSERT INTO fields
  (id, key, description, agg_func, agg_weights)
VALUES ('758acf5a-498d-40db-9a8b-39adf47b5d28', 'percentage_complete', 'Secondary raw scenario score.', NULL, NULL) ON CONFLICT(id) DO
UPDATE SET key =EXCLUDED.key, description=EXCLUDED.description, agg_func=EXCLUDED.agg_func, agg_weights=EXCLUDED.agg_weights;

INSERT INTO scenarios
  (id, name, description, field_ids)
VALUES ('bc398385-b9bc-4f08-91e2-9b70cba8e54f', 'bc398385-b9bc-4f08-91e2-9b70cba8e54f', 'bc398385-b9bc-4f08-91e2-9b70cba8e54f',
        array['9900f111-abbb-44d4-b022-3a1d9e2efded', '758acf5a-498d-40db-9a8b-39adf47b5d28']::uuid[]) ON CONFLICT(id) DO
UPDATE SET name=EXCLUDED.name, description=EXCLUDED.description, field_ids=EXCLUDED.field_ids;

INSERT INTO fields
  (id, key, description, agg_func, agg_weights)
VALUES ('9900f111-abbb-44d4-b022-3a1d9e2efded', 'normalized_reward', 'Primary raw scenario score.', NULL, NULL) ON CONFLICT(id) DO
UPDATE SET key =EXCLUDED.key, description=EXCLUDED.description, agg_func=EXCLUDED.agg_func, agg_weights=EXCLUDED.agg_weights;

INSERT INTO fields
  (id, key, description, agg_func, agg_weights)
VALUES ('758acf5a-498d-40db-9a8b-39adf47b5d28', 'percentage_complete', 'Secondary raw scenario score.', NULL, NULL) ON CONFLICT(id) DO
UPDATE SET key =EXCLUDED.key, description=EXCLUDED.description, agg_func=EXCLUDED.agg_func, agg_weights=EXCLUDED.agg_weights;

INSERT INTO tests
  (id, name, description, field_ids, scenario_ids, loop, queue)
VALUES ('6670be1d-9fc0-48c8-9bc9-fc889f56d615', 'Test 1', 'Level 2', array['75f7ebf7-e79e-4f2c-bb78-c51f996fc5c9',
        '7bbb3f10-1a1f-4c69-b882-6ed2b84d1e85']::uuid[], array['f1bff6c2-297d-4e01-aae1-e6f33a03f708', 'eeea37a7-dfbf-4c40-b851-289458f61a7a',
        'e2ff0d91-a5da-4888-ae8e-b5805c38bd8a', '403e469b-7508-4bb7-9b97-5585b4bf30da', 'ec203d8a-774e-423c-a19d-7b8d39a284c2']::uuid[], 'CLOSED',
        NULL) ON CONFLICT(id) DO
UPDATE SET name=EXCLUDED.name, description=EXCLUDED.description, field_ids=EXCLUDED.field_ids, scenario_ids=EXCLUDED.scenario_ids, loop=EXCLUDED.loop, queue=EXCLUDED.queue;

INSERT INTO fields
  (id, key, description, agg_func, agg_fields)
VALUES ('75f7ebf7-e79e-4f2c-bb78-c51f996fc5c9', 'normalized_reward', 'Primary test score (NANSUM of corresponding scenario scores)', 'NANSUM',
        '"percentage_complete"') ON CONFLICT(id) DO
UPDATE SET key =EXCLUDED.key, description=EXCLUDED.description, agg_func=EXCLUDED.agg_func, agg_weights=EXCLUDED.agg_weights;

INSERT INTO fields
  (id, key, description, agg_func, agg_fields)
VALUES ('7bbb3f10-1a1f-4c69-b882-6ed2b84d1e85', 'percentage_complete', 'Secondary test score (NANMEAN of corresponding scenario scores)', 'NANMEAN',
        '"percentage_complete"') ON CONFLICT(id) DO
UPDATE SET key =EXCLUDED.key, description=EXCLUDED.description, agg_func=EXCLUDED.agg_func, agg_weights=EXCLUDED.agg_weights;

INSERT INTO scenarios
  (id, name, description, field_ids)
VALUES ('f1bff6c2-297d-4e01-aae1-e6f33a03f708', 'f1bff6c2-297d-4e01-aae1-e6f33a03f708', 'f1bff6c2-297d-4e01-aae1-e6f33a03f708',
        array['9900f111-abbb-44d4-b022-3a1d9e2efded', '758acf5a-498d-40db-9a8b-39adf47b5d28']::uuid[]) ON CONFLICT(id) DO
UPDATE SET name=EXCLUDED.name, description=EXCLUDED.description, field_ids=EXCLUDED.field_ids;

INSERT INTO fields
  (id, key, description, agg_func, agg_weights)
VALUES ('9900f111-abbb-44d4-b022-3a1d9e2efded', 'normalized_reward', 'Primary raw scenario score.', NULL, NULL) ON CONFLICT(id) DO
UPDATE SET key =EXCLUDED.key, description=EXCLUDED.description, agg_func=EXCLUDED.agg_func, agg_weights=EXCLUDED.agg_weights;

INSERT INTO fields
  (id, key, description, agg_func, agg_weights)
VALUES ('758acf5a-498d-40db-9a8b-39adf47b5d28', 'percentage_complete', 'Secondary raw scenario score.', NULL, NULL) ON CONFLICT(id) DO
UPDATE SET key =EXCLUDED.key, description=EXCLUDED.description, agg_func=EXCLUDED.agg_func, agg_weights=EXCLUDED.agg_weights;

INSERT INTO scenarios
  (id, name, description, field_ids)
VALUES ('eeea37a7-dfbf-4c40-b851-289458f61a7a', 'eeea37a7-dfbf-4c40-b851-289458f61a7a', 'eeea37a7-dfbf-4c40-b851-289458f61a7a',
        array['9900f111-abbb-44d4-b022-3a1d9e2efded', '758acf5a-498d-40db-9a8b-39adf47b5d28']::uuid[]) ON CONFLICT(id) DO
UPDATE SET name=EXCLUDED.name, description=EXCLUDED.description, field_ids=EXCLUDED.field_ids;

INSERT INTO fields
  (id, key, description, agg_func, agg_weights)
VALUES ('9900f111-abbb-44d4-b022-3a1d9e2efded', 'normalized_reward', 'Primary raw scenario score.', NULL, NULL) ON CONFLICT(id) DO
UPDATE SET key =EXCLUDED.key, description=EXCLUDED.description, agg_func=EXCLUDED.agg_func, agg_weights=EXCLUDED.agg_weights;

INSERT INTO fields
  (id, key, description, agg_func, agg_weights)
VALUES ('758acf5a-498d-40db-9a8b-39adf47b5d28', 'percentage_complete', 'Secondary raw scenario score.', NULL, NULL) ON CONFLICT(id) DO
UPDATE SET key =EXCLUDED.key, description=EXCLUDED.description, agg_func=EXCLUDED.agg_func, agg_weights=EXCLUDED.agg_weights;

INSERT INTO scenarios
  (id, name, description, field_ids)
VALUES ('e2ff0d91-a5da-4888-ae8e-b5805c38bd8a', 'e2ff0d91-a5da-4888-ae8e-b5805c38bd8a', 'e2ff0d91-a5da-4888-ae8e-b5805c38bd8a',
        array['9900f111-abbb-44d4-b022-3a1d9e2efded', '758acf5a-498d-40db-9a8b-39adf47b5d28']::uuid[]) ON CONFLICT(id) DO
UPDATE SET name=EXCLUDED.name, description=EXCLUDED.description, field_ids=EXCLUDED.field_ids;

INSERT INTO fields
  (id, key, description, agg_func, agg_weights)
VALUES ('9900f111-abbb-44d4-b022-3a1d9e2efded', 'normalized_reward', 'Primary raw scenario score.', NULL, NULL) ON CONFLICT(id) DO
UPDATE SET key =EXCLUDED.key, description=EXCLUDED.description, agg_func=EXCLUDED.agg_func, agg_weights=EXCLUDED.agg_weights;

INSERT INTO fields
  (id, key, description, agg_func, agg_weights)
VALUES ('758acf5a-498d-40db-9a8b-39adf47b5d28', 'percentage_complete', 'Secondary raw scenario score.', NULL, NULL) ON CONFLICT(id) DO
UPDATE SET key =EXCLUDED.key, description=EXCLUDED.description, agg_func=EXCLUDED.agg_func, agg_weights=EXCLUDED.agg_weights;

INSERT INTO scenarios
  (id, name, description, field_ids)
VALUES ('403e469b-7508-4bb7-9b97-5585b4bf30da', '403e469b-7508-4bb7-9b97-5585b4bf30da', '403e469b-7508-4bb7-9b97-5585b4bf30da',
        array['9900f111-abbb-44d4-b022-3a1d9e2efded', '758acf5a-498d-40db-9a8b-39adf47b5d28']::uuid[]) ON CONFLICT(id) DO
UPDATE SET name=EXCLUDED.name, description=EXCLUDED.description, field_ids=EXCLUDED.field_ids;

INSERT INTO fields
  (id, key, description, agg_func, agg_weights)
VALUES ('9900f111-abbb-44d4-b022-3a1d9e2efded', 'normalized_reward', 'Primary raw scenario score.', NULL, NULL) ON CONFLICT(id) DO
UPDATE SET key =EXCLUDED.key, description=EXCLUDED.description, agg_func=EXCLUDED.agg_func, agg_weights=EXCLUDED.agg_weights;

INSERT INTO fields
  (id, key, description, agg_func, agg_weights)
VALUES ('758acf5a-498d-40db-9a8b-39adf47b5d28', 'percentage_complete', 'Secondary raw scenario score.', NULL, NULL) ON CONFLICT(id) DO
UPDATE SET key =EXCLUDED.key, description=EXCLUDED.description, agg_func=EXCLUDED.agg_func, agg_weights=EXCLUDED.agg_weights;

INSERT INTO scenarios
  (id, name, description, field_ids)
VALUES ('ec203d8a-774e-423c-a19d-7b8d39a284c2', 'ec203d8a-774e-423c-a19d-7b8d39a284c2', 'ec203d8a-774e-423c-a19d-7b8d39a284c2',
        array['9900f111-abbb-44d4-b022-3a1d9e2efded', '758acf5a-498d-40db-9a8b-39adf47b5d28']::uuid[]) ON CONFLICT(id) DO
UPDATE SET name=EXCLUDED.name, description=EXCLUDED.description, field_ids=EXCLUDED.field_ids;

INSERT INTO fields
  (id, key, description, agg_func, agg_weights)
VALUES ('9900f111-abbb-44d4-b022-3a1d9e2efded', 'normalized_reward', 'Primary raw scenario score.', NULL, NULL) ON CONFLICT(id) DO
UPDATE SET key =EXCLUDED.key, description=EXCLUDED.description, agg_func=EXCLUDED.agg_func, agg_weights=EXCLUDED.agg_weights;

INSERT INTO fields
  (id, key, description, agg_func, agg_weights)
VALUES ('758acf5a-498d-40db-9a8b-39adf47b5d28', 'percentage_complete', 'Secondary raw scenario score.', NULL, NULL) ON CONFLICT(id) DO
UPDATE SET key =EXCLUDED.key, description=EXCLUDED.description, agg_func=EXCLUDED.agg_func, agg_weights=EXCLUDED.agg_weights;

INSERT INTO tests
  (id, name, description, field_ids, scenario_ids, loop, queue)
VALUES ('f3aefb9c-a79e-413a-b73c-f46c794855c1', 'Test 2', 'Level 3', array['75f7ebf7-e79e-4f2c-bb78-c51f996fc5c9',
        '7bbb3f10-1a1f-4c69-b882-6ed2b84d1e85']::uuid[], array['4b4d5e9f-4753-449c-96e7-f7e477e3e38a', 'cee79764-bfbd-4e8e-a93d-434495926f63',
        'f5c3b066-c86b-47ff-a674-ddfcf9a2e308', '4df80fd3-eb95-457b-b0f3-d2b6925d0024', '0eb1e6e6-245d-4f41-89e9-155d54271c62']::uuid[], 'CLOSED',
        NULL) ON CONFLICT(id) DO
UPDATE SET name=EXCLUDED.name, description=EXCLUDED.description, field_ids=EXCLUDED.field_ids, scenario_ids=EXCLUDED.scenario_ids, loop=EXCLUDED.loop, queue=EXCLUDED.queue;

INSERT INTO fields
  (id, key, description, agg_func, agg_fields)
VALUES ('75f7ebf7-e79e-4f2c-bb78-c51f996fc5c9', 'normalized_reward', 'Primary test score (NANSUM of corresponding scenario scores)', 'NANSUM',
        '"percentage_complete"') ON CONFLICT(id) DO
UPDATE SET key =EXCLUDED.key, description=EXCLUDED.description, agg_func=EXCLUDED.agg_func, agg_weights=EXCLUDED.agg_weights;

INSERT INTO fields
  (id, key, description, agg_func, agg_fields)
VALUES ('7bbb3f10-1a1f-4c69-b882-6ed2b84d1e85', 'percentage_complete', 'Secondary test score (NANMEAN of corresponding scenario scores)', 'NANMEAN',
        '"percentage_complete"') ON CONFLICT(id) DO
UPDATE SET key =EXCLUDED.key, description=EXCLUDED.description, agg_func=EXCLUDED.agg_func, agg_weights=EXCLUDED.agg_weights;

INSERT INTO scenarios
  (id, name, description, field_ids)
VALUES ('4b4d5e9f-4753-449c-96e7-f7e477e3e38a', '4b4d5e9f-4753-449c-96e7-f7e477e3e38a', '4b4d5e9f-4753-449c-96e7-f7e477e3e38a',
        array['9900f111-abbb-44d4-b022-3a1d9e2efded', '758acf5a-498d-40db-9a8b-39adf47b5d28']::uuid[]) ON CONFLICT(id) DO
UPDATE SET name=EXCLUDED.name, description=EXCLUDED.description, field_ids=EXCLUDED.field_ids;

INSERT INTO fields
  (id, key, description, agg_func, agg_weights)
VALUES ('9900f111-abbb-44d4-b022-3a1d9e2efded', 'normalized_reward', 'Primary raw scenario score.', NULL, NULL) ON CONFLICT(id) DO
UPDATE SET key =EXCLUDED.key, description=EXCLUDED.description, agg_func=EXCLUDED.agg_func, agg_weights=EXCLUDED.agg_weights;

INSERT INTO fields
  (id, key, description, agg_func, agg_weights)
VALUES ('758acf5a-498d-40db-9a8b-39adf47b5d28', 'percentage_complete', 'Secondary raw scenario score.', NULL, NULL) ON CONFLICT(id) DO
UPDATE SET key =EXCLUDED.key, description=EXCLUDED.description, agg_func=EXCLUDED.agg_func, agg_weights=EXCLUDED.agg_weights;

INSERT INTO scenarios
  (id, name, description, field_ids)
VALUES ('cee79764-bfbd-4e8e-a93d-434495926f63', 'cee79764-bfbd-4e8e-a93d-434495926f63', 'cee79764-bfbd-4e8e-a93d-434495926f63',
        array['9900f111-abbb-44d4-b022-3a1d9e2efded', '758acf5a-498d-40db-9a8b-39adf47b5d28']::uuid[]) ON CONFLICT(id) DO
UPDATE SET name=EXCLUDED.name, description=EXCLUDED.description, field_ids=EXCLUDED.field_ids;

INSERT INTO fields
  (id, key, description, agg_func, agg_weights)
VALUES ('9900f111-abbb-44d4-b022-3a1d9e2efded', 'normalized_reward', 'Primary raw scenario score.', NULL, NULL) ON CONFLICT(id) DO
UPDATE SET key =EXCLUDED.key, description=EXCLUDED.description, agg_func=EXCLUDED.agg_func, agg_weights=EXCLUDED.agg_weights;

INSERT INTO fields
  (id, key, description, agg_func, agg_weights)
VALUES ('758acf5a-498d-40db-9a8b-39adf47b5d28', 'percentage_complete', 'Secondary raw scenario score.', NULL, NULL) ON CONFLICT(id) DO
UPDATE SET key =EXCLUDED.key, description=EXCLUDED.description, agg_func=EXCLUDED.agg_func, agg_weights=EXCLUDED.agg_weights;

INSERT INTO scenarios
  (id, name, description, field_ids)
VALUES ('f5c3b066-c86b-47ff-a674-ddfcf9a2e308', 'f5c3b066-c86b-47ff-a674-ddfcf9a2e308', 'f5c3b066-c86b-47ff-a674-ddfcf9a2e308',
        array['9900f111-abbb-44d4-b022-3a1d9e2efded', '758acf5a-498d-40db-9a8b-39adf47b5d28']::uuid[]) ON CONFLICT(id) DO
UPDATE SET name=EXCLUDED.name, description=EXCLUDED.description, field_ids=EXCLUDED.field_ids;

INSERT INTO fields
  (id, key, description, agg_func, agg_weights)
VALUES ('9900f111-abbb-44d4-b022-3a1d9e2efded', 'normalized_reward', 'Primary raw scenario score.', NULL, NULL) ON CONFLICT(id) DO
UPDATE SET key =EXCLUDED.key, description=EXCLUDED.description, agg_func=EXCLUDED.agg_func, agg_weights=EXCLUDED.agg_weights;

INSERT INTO fields
  (id, key, description, agg_func, agg_weights)
VALUES ('758acf5a-498d-40db-9a8b-39adf47b5d28', 'percentage_complete', 'Secondary raw scenario score.', NULL, NULL) ON CONFLICT(id) DO
UPDATE SET key =EXCLUDED.key, description=EXCLUDED.description, agg_func=EXCLUDED.agg_func, agg_weights=EXCLUDED.agg_weights;

INSERT INTO scenarios
  (id, name, description, field_ids)
VALUES ('4df80fd3-eb95-457b-b0f3-d2b6925d0024', '4df80fd3-eb95-457b-b0f3-d2b6925d0024', '4df80fd3-eb95-457b-b0f3-d2b6925d0024',
        array['9900f111-abbb-44d4-b022-3a1d9e2efded', '758acf5a-498d-40db-9a8b-39adf47b5d28']::uuid[]) ON CONFLICT(id) DO
UPDATE SET name=EXCLUDED.name, description=EXCLUDED.description, field_ids=EXCLUDED.field_ids;

INSERT INTO fields
  (id, key, description, agg_func, agg_weights)
VALUES ('9900f111-abbb-44d4-b022-3a1d9e2efded', 'normalized_reward', 'Primary raw scenario score.', NULL, NULL) ON CONFLICT(id) DO
UPDATE SET key =EXCLUDED.key, description=EXCLUDED.description, agg_func=EXCLUDED.agg_func, agg_weights=EXCLUDED.agg_weights;

INSERT INTO fields
  (id, key, description, agg_func, agg_weights)
VALUES ('758acf5a-498d-40db-9a8b-39adf47b5d28', 'percentage_complete', 'Secondary raw scenario score.', NULL, NULL) ON CONFLICT(id) DO
UPDATE SET key =EXCLUDED.key, description=EXCLUDED.description, agg_func=EXCLUDED.agg_func, agg_weights=EXCLUDED.agg_weights;

INSERT INTO scenarios
  (id, name, description, field_ids)
VALUES ('0eb1e6e6-245d-4f41-89e9-155d54271c62', '0eb1e6e6-245d-4f41-89e9-155d54271c62', '0eb1e6e6-245d-4f41-89e9-155d54271c62',
        array['9900f111-abbb-44d4-b022-3a1d9e2efded', '758acf5a-498d-40db-9a8b-39adf47b5d28']::uuid[]) ON CONFLICT(id) DO
UPDATE SET name=EXCLUDED.name, description=EXCLUDED.description, field_ids=EXCLUDED.field_ids;

INSERT INTO fields
  (id, key, description, agg_func, agg_weights)
VALUES ('9900f111-abbb-44d4-b022-3a1d9e2efded', 'normalized_reward', 'Primary raw scenario score.', NULL, NULL) ON CONFLICT(id) DO
UPDATE SET key =EXCLUDED.key, description=EXCLUDED.description, agg_func=EXCLUDED.agg_func, agg_weights=EXCLUDED.agg_weights;

INSERT INTO fields
  (id, key, description, agg_func, agg_weights)
VALUES ('758acf5a-498d-40db-9a8b-39adf47b5d28', 'percentage_complete', 'Secondary raw scenario score.', NULL, NULL) ON CONFLICT(id) DO
UPDATE SET key =EXCLUDED.key, description=EXCLUDED.description, agg_func=EXCLUDED.agg_func, agg_weights=EXCLUDED.agg_weights;

INSERT INTO tests
  (id, name, description, field_ids, scenario_ids, loop, queue)
VALUES ('68ade1f2-301f-4d8d-b9d6-f3110b6e7587', 'Test 3', 'Level 4', array['75f7ebf7-e79e-4f2c-bb78-c51f996fc5c9',
        '7bbb3f10-1a1f-4c69-b882-6ed2b84d1e85']::uuid[], array['0e2cce95-4a55-440e-b723-e58ab5fcb34a', '85e1179b-1744-4af9-9925-a81387f10bb4',
        'a1addd20-c309-4145-a59c-975e971d58d4', 'e913d595-79d3-4fea-866b-a39ac33a29f2', '53238550-c049-476c-90b5-ccb174e99460']::uuid[], 'CLOSED',
        NULL) ON CONFLICT(id) DO
UPDATE SET name=EXCLUDED.name, description=EXCLUDED.description, field_ids=EXCLUDED.field_ids, scenario_ids=EXCLUDED.scenario_ids, loop=EXCLUDED.loop, queue=EXCLUDED.queue;

INSERT INTO fields
  (id, key, description, agg_func, agg_fields)
VALUES ('75f7ebf7-e79e-4f2c-bb78-c51f996fc5c9', 'normalized_reward', 'Primary test score (NANSUM of corresponding scenario scores)', 'NANSUM',
        '"percentage_complete"') ON CONFLICT(id) DO
UPDATE SET key =EXCLUDED.key, description=EXCLUDED.description, agg_func=EXCLUDED.agg_func, agg_weights=EXCLUDED.agg_weights;

INSERT INTO fields
  (id, key, description, agg_func, agg_fields)
VALUES ('7bbb3f10-1a1f-4c69-b882-6ed2b84d1e85', 'percentage_complete', 'Secondary test score (NANMEAN of corresponding scenario scores)', 'NANMEAN',
        '"percentage_complete"') ON CONFLICT(id) DO
UPDATE SET key =EXCLUDED.key, description=EXCLUDED.description, agg_func=EXCLUDED.agg_func, agg_weights=EXCLUDED.agg_weights;

INSERT INTO scenarios
  (id, name, description, field_ids)
VALUES ('0e2cce95-4a55-440e-b723-e58ab5fcb34a', '0e2cce95-4a55-440e-b723-e58ab5fcb34a', '0e2cce95-4a55-440e-b723-e58ab5fcb34a',
        array['9900f111-abbb-44d4-b022-3a1d9e2efded', '758acf5a-498d-40db-9a8b-39adf47b5d28']::uuid[]) ON CONFLICT(id) DO
UPDATE SET name=EXCLUDED.name, description=EXCLUDED.description, field_ids=EXCLUDED.field_ids;

INSERT INTO fields
  (id, key, description, agg_func, agg_weights)
VALUES ('9900f111-abbb-44d4-b022-3a1d9e2efded', 'normalized_reward', 'Primary raw scenario score.', NULL, NULL) ON CONFLICT(id) DO
UPDATE SET key =EXCLUDED.key, description=EXCLUDED.description, agg_func=EXCLUDED.agg_func, agg_weights=EXCLUDED.agg_weights;

INSERT INTO fields
  (id, key, description, agg_func, agg_weights)
VALUES ('758acf5a-498d-40db-9a8b-39adf47b5d28', 'percentage_complete', 'Secondary raw scenario score.', NULL, NULL) ON CONFLICT(id) DO
UPDATE SET key =EXCLUDED.key, description=EXCLUDED.description, agg_func=EXCLUDED.agg_func, agg_weights=EXCLUDED.agg_weights;

INSERT INTO scenarios
  (id, name, description, field_ids)
VALUES ('85e1179b-1744-4af9-9925-a81387f10bb4', '85e1179b-1744-4af9-9925-a81387f10bb4', '85e1179b-1744-4af9-9925-a81387f10bb4',
        array['9900f111-abbb-44d4-b022-3a1d9e2efded', '758acf5a-498d-40db-9a8b-39adf47b5d28']::uuid[]) ON CONFLICT(id) DO
UPDATE SET name=EXCLUDED.name, description=EXCLUDED.description, field_ids=EXCLUDED.field_ids;

INSERT INTO fields
  (id, key, description, agg_func, agg_weights)
VALUES ('9900f111-abbb-44d4-b022-3a1d9e2efded', 'normalized_reward', 'Primary raw scenario score.', NULL, NULL) ON CONFLICT(id) DO
UPDATE SET key =EXCLUDED.key, description=EXCLUDED.description, agg_func=EXCLUDED.agg_func, agg_weights=EXCLUDED.agg_weights;

INSERT INTO fields
  (id, key, description, agg_func, agg_weights)
VALUES ('758acf5a-498d-40db-9a8b-39adf47b5d28', 'percentage_complete', 'Secondary raw scenario score.', NULL, NULL) ON CONFLICT(id) DO
UPDATE SET key =EXCLUDED.key, description=EXCLUDED.description, agg_func=EXCLUDED.agg_func, agg_weights=EXCLUDED.agg_weights;

INSERT INTO scenarios
  (id, name, description, field_ids)
VALUES ('a1addd20-c309-4145-a59c-975e971d58d4', 'a1addd20-c309-4145-a59c-975e971d58d4', 'a1addd20-c309-4145-a59c-975e971d58d4',
        array['9900f111-abbb-44d4-b022-3a1d9e2efded', '758acf5a-498d-40db-9a8b-39adf47b5d28']::uuid[]) ON CONFLICT(id) DO
UPDATE SET name=EXCLUDED.name, description=EXCLUDED.description, field_ids=EXCLUDED.field_ids;

INSERT INTO fields
  (id, key, description, agg_func, agg_weights)
VALUES ('9900f111-abbb-44d4-b022-3a1d9e2efded', 'normalized_reward', 'Primary raw scenario score.', NULL, NULL) ON CONFLICT(id) DO
UPDATE SET key =EXCLUDED.key, description=EXCLUDED.description, agg_func=EXCLUDED.agg_func, agg_weights=EXCLUDED.agg_weights;

INSERT INTO fields
  (id, key, description, agg_func, agg_weights)
VALUES ('758acf5a-498d-40db-9a8b-39adf47b5d28', 'percentage_complete', 'Secondary raw scenario score.', NULL, NULL) ON CONFLICT(id) DO
UPDATE SET key =EXCLUDED.key, description=EXCLUDED.description, agg_func=EXCLUDED.agg_func, agg_weights=EXCLUDED.agg_weights;

INSERT INTO scenarios
  (id, name, description, field_ids)
VALUES ('e913d595-79d3-4fea-866b-a39ac33a29f2', 'e913d595-79d3-4fea-866b-a39ac33a29f2', 'e913d595-79d3-4fea-866b-a39ac33a29f2',
        array['9900f111-abbb-44d4-b022-3a1d9e2efded', '758acf5a-498d-40db-9a8b-39adf47b5d28']::uuid[]) ON CONFLICT(id) DO
UPDATE SET name=EXCLUDED.name, description=EXCLUDED.description, field_ids=EXCLUDED.field_ids;

INSERT INTO fields
  (id, key, description, agg_func, agg_weights)
VALUES ('9900f111-abbb-44d4-b022-3a1d9e2efded', 'normalized_reward', 'Primary raw scenario score.', NULL, NULL) ON CONFLICT(id) DO
UPDATE SET key =EXCLUDED.key, description=EXCLUDED.description, agg_func=EXCLUDED.agg_func, agg_weights=EXCLUDED.agg_weights;

INSERT INTO fields
  (id, key, description, agg_func, agg_weights)
VALUES ('758acf5a-498d-40db-9a8b-39adf47b5d28', 'percentage_complete', 'Secondary raw scenario score.', NULL, NULL) ON CONFLICT(id) DO
UPDATE SET key =EXCLUDED.key, description=EXCLUDED.description, agg_func=EXCLUDED.agg_func, agg_weights=EXCLUDED.agg_weights;

INSERT INTO scenarios
  (id, name, description, field_ids)
VALUES ('53238550-c049-476c-90b5-ccb174e99460', '53238550-c049-476c-90b5-ccb174e99460', '53238550-c049-476c-90b5-ccb174e99460',
        array['9900f111-abbb-44d4-b022-3a1d9e2efded', '758acf5a-498d-40db-9a8b-39adf47b5d28']::uuid[]) ON CONFLICT(id) DO
UPDATE SET name=EXCLUDED.name, description=EXCLUDED.description, field_ids=EXCLUDED.field_ids;

INSERT INTO fields
  (id, key, description, agg_func, agg_weights)
VALUES ('9900f111-abbb-44d4-b022-3a1d9e2efded', 'normalized_reward', 'Primary raw scenario score.', NULL, NULL) ON CONFLICT(id) DO
UPDATE SET key =EXCLUDED.key, description=EXCLUDED.description, agg_func=EXCLUDED.agg_func, agg_weights=EXCLUDED.agg_weights;

INSERT INTO fields
  (id, key, description, agg_func, agg_weights)
VALUES ('758acf5a-498d-40db-9a8b-39adf47b5d28', 'percentage_complete', 'Secondary raw scenario score.', NULL, NULL) ON CONFLICT(id) DO
UPDATE SET key =EXCLUDED.key, description=EXCLUDED.description, agg_func=EXCLUDED.agg_func, agg_weights=EXCLUDED.agg_weights;

INSERT INTO tests
  (id, name, description, field_ids, scenario_ids, loop, queue)
VALUES ('d49091c0-793b-401b-a0c8-12df1361deef', 'Test 4', 'Level 5', array['75f7ebf7-e79e-4f2c-bb78-c51f996fc5c9',
        '7bbb3f10-1a1f-4c69-b882-6ed2b84d1e85']::uuid[], array['9eee4486-fdf0-4873-80bb-777886ed9ca0', '4111f401-142b-471d-a06d-f839b43dfc5c',
        'e2bd8e53-bd5b-4af1-b9ef-48942467d831', '2bb9d4f9-d96c-490c-ba6e-33226b6a4017', 'aabe8141-e045-4e30-87be-6ccf95818b87']::uuid[], 'CLOSED',
        NULL) ON CONFLICT(id) DO
UPDATE SET name=EXCLUDED.name, description=EXCLUDED.description, field_ids=EXCLUDED.field_ids, scenario_ids=EXCLUDED.scenario_ids, loop=EXCLUDED.loop, queue=EXCLUDED.queue;

INSERT INTO fields
  (id, key, description, agg_func, agg_fields)
VALUES ('75f7ebf7-e79e-4f2c-bb78-c51f996fc5c9', 'normalized_reward', 'Primary test score (NANSUM of corresponding scenario scores)', 'NANSUM',
        '"percentage_complete"') ON CONFLICT(id) DO
UPDATE SET key =EXCLUDED.key, description=EXCLUDED.description, agg_func=EXCLUDED.agg_func, agg_weights=EXCLUDED.agg_weights;

INSERT INTO fields
  (id, key, description, agg_func, agg_fields)
VALUES ('7bbb3f10-1a1f-4c69-b882-6ed2b84d1e85', 'percentage_complete', 'Secondary test score (NANMEAN of corresponding scenario scores)', 'NANMEAN',
        '"percentage_complete"') ON CONFLICT(id) DO
UPDATE SET key =EXCLUDED.key, description=EXCLUDED.description, agg_func=EXCLUDED.agg_func, agg_weights=EXCLUDED.agg_weights;

INSERT INTO scenarios
  (id, name, description, field_ids)
VALUES ('9eee4486-fdf0-4873-80bb-777886ed9ca0', '9eee4486-fdf0-4873-80bb-777886ed9ca0', '9eee4486-fdf0-4873-80bb-777886ed9ca0',
        array['9900f111-abbb-44d4-b022-3a1d9e2efded', '758acf5a-498d-40db-9a8b-39adf47b5d28']::uuid[]) ON CONFLICT(id) DO
UPDATE SET name=EXCLUDED.name, description=EXCLUDED.description, field_ids=EXCLUDED.field_ids;

INSERT INTO fields
  (id, key, description, agg_func, agg_weights)
VALUES ('9900f111-abbb-44d4-b022-3a1d9e2efded', 'normalized_reward', 'Primary raw scenario score.', NULL, NULL) ON CONFLICT(id) DO
UPDATE SET key =EXCLUDED.key, description=EXCLUDED.description, agg_func=EXCLUDED.agg_func, agg_weights=EXCLUDED.agg_weights;

INSERT INTO fields
  (id, key, description, agg_func, agg_weights)
VALUES ('758acf5a-498d-40db-9a8b-39adf47b5d28', 'percentage_complete', 'Secondary raw scenario score.', NULL, NULL) ON CONFLICT(id) DO
UPDATE SET key =EXCLUDED.key, description=EXCLUDED.description, agg_func=EXCLUDED.agg_func, agg_weights=EXCLUDED.agg_weights;

INSERT INTO scenarios
  (id, name, description, field_ids)
VALUES ('4111f401-142b-471d-a06d-f839b43dfc5c', '4111f401-142b-471d-a06d-f839b43dfc5c', '4111f401-142b-471d-a06d-f839b43dfc5c',
        array['9900f111-abbb-44d4-b022-3a1d9e2efded', '758acf5a-498d-40db-9a8b-39adf47b5d28']::uuid[]) ON CONFLICT(id) DO
UPDATE SET name=EXCLUDED.name, description=EXCLUDED.description, field_ids=EXCLUDED.field_ids;

INSERT INTO fields
  (id, key, description, agg_func, agg_weights)
VALUES ('9900f111-abbb-44d4-b022-3a1d9e2efded', 'normalized_reward', 'Primary raw scenario score.', NULL, NULL) ON CONFLICT(id) DO
UPDATE SET key =EXCLUDED.key, description=EXCLUDED.description, agg_func=EXCLUDED.agg_func, agg_weights=EXCLUDED.agg_weights;

INSERT INTO fields
  (id, key, description, agg_func, agg_weights)
VALUES ('758acf5a-498d-40db-9a8b-39adf47b5d28', 'percentage_complete', 'Secondary raw scenario score.', NULL, NULL) ON CONFLICT(id) DO
UPDATE SET key =EXCLUDED.key, description=EXCLUDED.description, agg_func=EXCLUDED.agg_func, agg_weights=EXCLUDED.agg_weights;

INSERT INTO scenarios
  (id, name, description, field_ids)
VALUES ('e2bd8e53-bd5b-4af1-b9ef-48942467d831', 'e2bd8e53-bd5b-4af1-b9ef-48942467d831', 'e2bd8e53-bd5b-4af1-b9ef-48942467d831',
        array['9900f111-abbb-44d4-b022-3a1d9e2efded', '758acf5a-498d-40db-9a8b-39adf47b5d28']::uuid[]) ON CONFLICT(id) DO
UPDATE SET name=EXCLUDED.name, description=EXCLUDED.description, field_ids=EXCLUDED.field_ids;

INSERT INTO fields
  (id, key, description, agg_func, agg_weights)
VALUES ('9900f111-abbb-44d4-b022-3a1d9e2efded', 'normalized_reward', 'Primary raw scenario score.', NULL, NULL) ON CONFLICT(id) DO
UPDATE SET key =EXCLUDED.key, description=EXCLUDED.description, agg_func=EXCLUDED.agg_func, agg_weights=EXCLUDED.agg_weights;

INSERT INTO fields
  (id, key, description, agg_func, agg_weights)
VALUES ('758acf5a-498d-40db-9a8b-39adf47b5d28', 'percentage_complete', 'Secondary raw scenario score.', NULL, NULL) ON CONFLICT(id) DO
UPDATE SET key =EXCLUDED.key, description=EXCLUDED.description, agg_func=EXCLUDED.agg_func, agg_weights=EXCLUDED.agg_weights;

INSERT INTO scenarios
  (id, name, description, field_ids)
VALUES ('2bb9d4f9-d96c-490c-ba6e-33226b6a4017', '2bb9d4f9-d96c-490c-ba6e-33226b6a4017', '2bb9d4f9-d96c-490c-ba6e-33226b6a4017',
        array['9900f111-abbb-44d4-b022-3a1d9e2efded', '758acf5a-498d-40db-9a8b-39adf47b5d28']::uuid[]) ON CONFLICT(id) DO
UPDATE SET name=EXCLUDED.name, description=EXCLUDED.description, field_ids=EXCLUDED.field_ids;

INSERT INTO fields
  (id, key, description, agg_func, agg_weights)
VALUES ('9900f111-abbb-44d4-b022-3a1d9e2efded', 'normalized_reward', 'Primary raw scenario score.', NULL, NULL) ON CONFLICT(id) DO
UPDATE SET key =EXCLUDED.key, description=EXCLUDED.description, agg_func=EXCLUDED.agg_func, agg_weights=EXCLUDED.agg_weights;

INSERT INTO fields
  (id, key, description, agg_func, agg_weights)
VALUES ('758acf5a-498d-40db-9a8b-39adf47b5d28', 'percentage_complete', 'Secondary raw scenario score.', NULL, NULL) ON CONFLICT(id) DO
UPDATE SET key =EXCLUDED.key, description=EXCLUDED.description, agg_func=EXCLUDED.agg_func, agg_weights=EXCLUDED.agg_weights;

INSERT INTO scenarios
  (id, name, description, field_ids)
VALUES ('aabe8141-e045-4e30-87be-6ccf95818b87', 'aabe8141-e045-4e30-87be-6ccf95818b87', 'aabe8141-e045-4e30-87be-6ccf95818b87',
        array['9900f111-abbb-44d4-b022-3a1d9e2efded', '758acf5a-498d-40db-9a8b-39adf47b5d28']::uuid[]) ON CONFLICT(id) DO
UPDATE SET name=EXCLUDED.name, description=EXCLUDED.description, field_ids=EXCLUDED.field_ids;

INSERT INTO fields
  (id, key, description, agg_func, agg_weights)
VALUES ('9900f111-abbb-44d4-b022-3a1d9e2efded', 'normalized_reward', 'Primary raw scenario score.', NULL, NULL) ON CONFLICT(id) DO
UPDATE SET key =EXCLUDED.key, description=EXCLUDED.description, agg_func=EXCLUDED.agg_func, agg_weights=EXCLUDED.agg_weights;

INSERT INTO fields
  (id, key, description, agg_func, agg_weights)
VALUES ('758acf5a-498d-40db-9a8b-39adf47b5d28', 'percentage_complete', 'Secondary raw scenario score.', NULL, NULL) ON CONFLICT(id) DO
UPDATE SET key =EXCLUDED.key, description=EXCLUDED.description, agg_func=EXCLUDED.agg_func, agg_weights=EXCLUDED.agg_weights;

INSERT INTO tests
  (id, name, description, field_ids, scenario_ids, loop, queue)
VALUES ('86225a96-492d-474b-aa80-de166b005e42', 'Test 5', 'Level 6', array['75f7ebf7-e79e-4f2c-bb78-c51f996fc5c9',
        '7bbb3f10-1a1f-4c69-b882-6ed2b84d1e85']::uuid[], array['103776ff-57d0-43aa-b483-507724926969', 'e5ddeaea-06d8-4a5e-aa86-8ac85bf7d397',
        '18a62336-218a-4cd8-a297-16afdbd6c546', 'fbf5049b-332d-4e3a-aad7-f3a369ce91bb', '7d5e9c8d-ce87-48f3-b793-83489fca8ca0']::uuid[], 'CLOSED',
        NULL) ON CONFLICT(id) DO
UPDATE SET name=EXCLUDED.name, description=EXCLUDED.description, field_ids=EXCLUDED.field_ids, scenario_ids=EXCLUDED.scenario_ids, loop=EXCLUDED.loop, queue=EXCLUDED.queue;

INSERT INTO fields
  (id, key, description, agg_func, agg_fields)
VALUES ('75f7ebf7-e79e-4f2c-bb78-c51f996fc5c9', 'normalized_reward', 'Primary test score (NANSUM of corresponding scenario scores)', 'NANSUM',
        '"percentage_complete"') ON CONFLICT(id) DO
UPDATE SET key =EXCLUDED.key, description=EXCLUDED.description, agg_func=EXCLUDED.agg_func, agg_weights=EXCLUDED.agg_weights;

INSERT INTO fields
  (id, key, description, agg_func, agg_fields)
VALUES ('7bbb3f10-1a1f-4c69-b882-6ed2b84d1e85', 'percentage_complete', 'Secondary test score (NANMEAN of corresponding scenario scores)', 'NANMEAN',
        '"percentage_complete"') ON CONFLICT(id) DO
UPDATE SET key =EXCLUDED.key, description=EXCLUDED.description, agg_func=EXCLUDED.agg_func, agg_weights=EXCLUDED.agg_weights;

INSERT INTO scenarios
  (id, name, description, field_ids)
VALUES ('103776ff-57d0-43aa-b483-507724926969', '103776ff-57d0-43aa-b483-507724926969', '103776ff-57d0-43aa-b483-507724926969',
        array['9900f111-abbb-44d4-b022-3a1d9e2efded', '758acf5a-498d-40db-9a8b-39adf47b5d28']::uuid[]) ON CONFLICT(id) DO
UPDATE SET name=EXCLUDED.name, description=EXCLUDED.description, field_ids=EXCLUDED.field_ids;

INSERT INTO fields
  (id, key, description, agg_func, agg_weights)
VALUES ('9900f111-abbb-44d4-b022-3a1d9e2efded', 'normalized_reward', 'Primary raw scenario score.', NULL, NULL) ON CONFLICT(id) DO
UPDATE SET key =EXCLUDED.key, description=EXCLUDED.description, agg_func=EXCLUDED.agg_func, agg_weights=EXCLUDED.agg_weights;

INSERT INTO fields
  (id, key, description, agg_func, agg_weights)
VALUES ('758acf5a-498d-40db-9a8b-39adf47b5d28', 'percentage_complete', 'Secondary raw scenario score.', NULL, NULL) ON CONFLICT(id) DO
UPDATE SET key =EXCLUDED.key, description=EXCLUDED.description, agg_func=EXCLUDED.agg_func, agg_weights=EXCLUDED.agg_weights;

INSERT INTO scenarios
  (id, name, description, field_ids)
VALUES ('e5ddeaea-06d8-4a5e-aa86-8ac85bf7d397', 'e5ddeaea-06d8-4a5e-aa86-8ac85bf7d397', 'e5ddeaea-06d8-4a5e-aa86-8ac85bf7d397',
        array['9900f111-abbb-44d4-b022-3a1d9e2efded', '758acf5a-498d-40db-9a8b-39adf47b5d28']::uuid[]) ON CONFLICT(id) DO
UPDATE SET name=EXCLUDED.name, description=EXCLUDED.description, field_ids=EXCLUDED.field_ids;

INSERT INTO fields
  (id, key, description, agg_func, agg_weights)
VALUES ('9900f111-abbb-44d4-b022-3a1d9e2efded', 'normalized_reward', 'Primary raw scenario score.', NULL, NULL) ON CONFLICT(id) DO
UPDATE SET key =EXCLUDED.key, description=EXCLUDED.description, agg_func=EXCLUDED.agg_func, agg_weights=EXCLUDED.agg_weights;

INSERT INTO fields
  (id, key, description, agg_func, agg_weights)
VALUES ('758acf5a-498d-40db-9a8b-39adf47b5d28', 'percentage_complete', 'Secondary raw scenario score.', NULL, NULL) ON CONFLICT(id) DO
UPDATE SET key =EXCLUDED.key, description=EXCLUDED.description, agg_func=EXCLUDED.agg_func, agg_weights=EXCLUDED.agg_weights;

INSERT INTO scenarios
  (id, name, description, field_ids)
VALUES ('18a62336-218a-4cd8-a297-16afdbd6c546', '18a62336-218a-4cd8-a297-16afdbd6c546', '18a62336-218a-4cd8-a297-16afdbd6c546',
        array['9900f111-abbb-44d4-b022-3a1d9e2efded', '758acf5a-498d-40db-9a8b-39adf47b5d28']::uuid[]) ON CONFLICT(id) DO
UPDATE SET name=EXCLUDED.name, description=EXCLUDED.description, field_ids=EXCLUDED.field_ids;

INSERT INTO fields
  (id, key, description, agg_func, agg_weights)
VALUES ('9900f111-abbb-44d4-b022-3a1d9e2efded', 'normalized_reward', 'Primary raw scenario score.', NULL, NULL) ON CONFLICT(id) DO
UPDATE SET key =EXCLUDED.key, description=EXCLUDED.description, agg_func=EXCLUDED.agg_func, agg_weights=EXCLUDED.agg_weights;

INSERT INTO fields
  (id, key, description, agg_func, agg_weights)
VALUES ('758acf5a-498d-40db-9a8b-39adf47b5d28', 'percentage_complete', 'Secondary raw scenario score.', NULL, NULL) ON CONFLICT(id) DO
UPDATE SET key =EXCLUDED.key, description=EXCLUDED.description, agg_func=EXCLUDED.agg_func, agg_weights=EXCLUDED.agg_weights;

INSERT INTO scenarios
  (id, name, description, field_ids)
VALUES ('fbf5049b-332d-4e3a-aad7-f3a369ce91bb', 'fbf5049b-332d-4e3a-aad7-f3a369ce91bb', 'fbf5049b-332d-4e3a-aad7-f3a369ce91bb',
        array['9900f111-abbb-44d4-b022-3a1d9e2efded', '758acf5a-498d-40db-9a8b-39adf47b5d28']::uuid[]) ON CONFLICT(id) DO
UPDATE SET name=EXCLUDED.name, description=EXCLUDED.description, field_ids=EXCLUDED.field_ids;

INSERT INTO fields
  (id, key, description, agg_func, agg_weights)
VALUES ('9900f111-abbb-44d4-b022-3a1d9e2efded', 'normalized_reward', 'Primary raw scenario score.', NULL, NULL) ON CONFLICT(id) DO
UPDATE SET key =EXCLUDED.key, description=EXCLUDED.description, agg_func=EXCLUDED.agg_func, agg_weights=EXCLUDED.agg_weights;

INSERT INTO fields
  (id, key, description, agg_func, agg_weights)
VALUES ('758acf5a-498d-40db-9a8b-39adf47b5d28', 'percentage_complete', 'Secondary raw scenario score.', NULL, NULL) ON CONFLICT(id) DO
UPDATE SET key =EXCLUDED.key, description=EXCLUDED.description, agg_func=EXCLUDED.agg_func, agg_weights=EXCLUDED.agg_weights;

INSERT INTO scenarios
  (id, name, description, field_ids)
VALUES ('7d5e9c8d-ce87-48f3-b793-83489fca8ca0', '7d5e9c8d-ce87-48f3-b793-83489fca8ca0', '7d5e9c8d-ce87-48f3-b793-83489fca8ca0',
        array['9900f111-abbb-44d4-b022-3a1d9e2efded', '758acf5a-498d-40db-9a8b-39adf47b5d28']::uuid[]) ON CONFLICT(id) DO
UPDATE SET name=EXCLUDED.name, description=EXCLUDED.description, field_ids=EXCLUDED.field_ids;

INSERT INTO fields
  (id, key, description, agg_func, agg_weights)
VALUES ('9900f111-abbb-44d4-b022-3a1d9e2efded', 'normalized_reward', 'Primary raw scenario score.', NULL, NULL) ON CONFLICT(id) DO
UPDATE SET key =EXCLUDED.key, description=EXCLUDED.description, agg_func=EXCLUDED.agg_func, agg_weights=EXCLUDED.agg_weights;

INSERT INTO fields
  (id, key, description, agg_func, agg_weights)
VALUES ('758acf5a-498d-40db-9a8b-39adf47b5d28', 'percentage_complete', 'Secondary raw scenario score.', NULL, NULL) ON CONFLICT(id) DO
UPDATE SET key =EXCLUDED.key, description=EXCLUDED.description, agg_func=EXCLUDED.agg_func, agg_weights=EXCLUDED.agg_weights;

