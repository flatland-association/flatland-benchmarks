INSERT INTO suites
  (id, setup, name, description, contents, benchmark_ids)
VALUES ('6240c685-0fb4-481e-9404-47a570632227', 'COMPETITION', '[BETA] Railway Competition 2026', 'Lorem ipsum',
        '{"introduction": "<p><b>In this competition we want to find out how to efficiently manage dense traffic on a complex railway network with unforeseen events.</b></p><p>This competition tackles a real-world problem faced by many transportation companies around the world: the vehicle rescheduling problem (VRSP). It aims to identify novel solutions and advance existing approaches for dynamic railway rescheduling to take a step towards real-time rescheduling demands of future railway networks. Your contribution to this challenge might influence how modern traffic management systems are implemented.</p><p>This competition is part of the <a href=\"https://ai4realnet.eu/\">AI4REALNET project</a> (AI for REAL-world NETwork operation).</p>", "tabs": [{"title": "What is Flatland?", "text": "<p><a href=\"https://github.com/flatland-association/flatland-rl\">Flatland</a> is an open-source framework for developing and comparing Multi-Agent Reinforcement Learning algorithms in little (or ridiculously large!) grid-worlds. Check out the extensive <a href=\"https://flatland-association.github.io/flatland-book/intro.html\">documentation on GitHub</a> or the <a href=\"https://arxiv.org/abs/2012.05893\">paper on arXiv</a>.</p>"}, {"title": "Competition Procedure", "text": "<p>The competition consists of a warm-up round for participants to familiarize themselves with the Flatland environment and the competition setup. After that, the proper competition starts with new and more complex environments to tackle.</p><p><b>Warm-up round:</b> November 10th, 2025 - November 28th, 2025</p><p><b>Proper competition:</b> December 1st, 2025 - January 23rd, 2026</p>"}, {"title": "Prizes", "text": "There will be a paper written on the competition and the best teams and their solutions will be included. The paper is meant to be published and presented at a relevant conference, e.g. NeurIPS."}, {"title": "Rules", "text": "<p><b>General:</b> In the following, Participant refers to a single person or a participating team. By signing up for this competition, Participants agree to the rules of the competition. Anyone registered as Participant has the right to participate in the competition and participants are allowed to form teams.</p><p><b>Daily Submission Cap:</b> Each Participant may submit up to 5 solutions per day.</p><p><b>Runtime Limitation:</b> The evaluation of a solution will be stopped if double the timesteps of the latest scheduled arrival elapsed during a scenario, or if the evaluation lasts longer than 4 hours. The scores for all completed scenarios up to that point will be counted toward to competition.</p><p><b>Open Source:</b> Participants must open source their submissions in order to qualify for prizes.</p><p>Evaluation Procedure: Submissions are initially scored automatically and shown on the leaderboard. Top-performing entries are subjected to a secondary human review to resolve any ties and ensure robustness of the scoring methodology.</p>"}, {"title": "Contact", "text": "<p>Join the competition on our Revolt server: tba</p><p>Get in touch with us by e-mail <a href=\"mailto:competition@flatland-association.org\">competition@flatland-association.org</a></p>"}]}',
        array['c85d5fc2-15da-4a62-8e14-28d1261c29bd']::uuid[]) ON CONFLICT(id) DO
UPDATE SET setup=EXCLUDED.setup, name =EXCLUDED.name, description=EXCLUDED.description, benchmark_ids=EXCLUDED.benchmark_ids;

INSERT INTO benchmarks
  (id, name, description, field_ids, test_ids)
VALUES ('c85d5fc2-15da-4a62-8e14-28d1261c29bd', '[BETA] Railway Competition 2026', '[BETA] Railway Competition 2026',
        array['695aa2ce-9de1-40f0-bbdb-534482b5a44d', '124eb391-adce-40c9-bf93-c5725cb92ccb']::uuid[], array['d4dd100a-016c-4332-b711-926ea7d2c0c3',
        '12e03a34-d11b-4635-bf9f-b6d0f7003a66', 'edb50f48-d579-4994-afcd-08e106d375cb', '7f277294-de87-463b-a526-35b70c0bf693',
        '678cdb1e-86c4-42a7-9c0d-0073a80faaf0']::uuid[]) ON CONFLICT(id) DO
UPDATE SET name=EXCLUDED.name, description=EXCLUDED.description, field_ids=EXCLUDED.field_ids, test_ids=EXCLUDED.test_ids;

INSERT INTO fields
  (id, key, description, agg_func, agg_fields)
VALUES ('695aa2ce-9de1-40f0-bbdb-534482b5a44d', 'normalized_reward', 'Primary benchmark score (NANSUM of corresponding test scores)', 'NANSUM',
        '"normalized_reward"') ON CONFLICT(id) DO
UPDATE SET key =EXCLUDED.key, description=EXCLUDED.description, agg_func=EXCLUDED.agg_func, agg_weights=EXCLUDED.agg_weights;

INSERT INTO fields
  (id, key, description, agg_func, agg_fields)
VALUES ('124eb391-adce-40c9-bf93-c5725cb92ccb', 'percentage_complete', 'Secondary benchmark score (NANMEAN of corresponding test scores)', 'NANMEAN',
        '"percentage_complete"') ON CONFLICT(id) DO
UPDATE SET key =EXCLUDED.key, description=EXCLUDED.description, agg_func=EXCLUDED.agg_func, agg_weights=EXCLUDED.agg_weights;

INSERT INTO tests
  (id, name, description, field_ids, scenario_ids, loop, queue)
VALUES ('d4dd100a-016c-4332-b711-926ea7d2c0c3', 'Test 0', 'Test 0: 7 agents,  30x30, 2', array['425fbb2f-1c33-44f5-a3cf-1ead9a7935bb',
        '0422d549-cd91-42d9-948a-97f71880450a']::uuid[], array['ff0c3bb2-cfac-480c-a1f2-91966787cf05']::uuid[], 'CLOSED', NULL) ON CONFLICT(id) DO
UPDATE SET name=EXCLUDED.name, description=EXCLUDED.description, field_ids=EXCLUDED.field_ids, scenario_ids=EXCLUDED.scenario_ids, loop=EXCLUDED.loop, queue=EXCLUDED.queue;

INSERT INTO fields
  (id, key, description, agg_func, agg_fields)
VALUES ('425fbb2f-1c33-44f5-a3cf-1ead9a7935bb', 'normalized_reward', 'Primary test score (NANSUM of corresponding scenario scores)', 'NANSUM',
        '"percentage_complete"') ON CONFLICT(id) DO
UPDATE SET key =EXCLUDED.key, description=EXCLUDED.description, agg_func=EXCLUDED.agg_func, agg_weights=EXCLUDED.agg_weights;

INSERT INTO fields
  (id, key, description, agg_func, agg_fields)
VALUES ('0422d549-cd91-42d9-948a-97f71880450a', 'percentage_complete', 'Secondary test score (NANMEAN of corresponding scenario scores)', 'NANMEAN',
        '"percentage_complete"') ON CONFLICT(id) DO
UPDATE SET key =EXCLUDED.key, description=EXCLUDED.description, agg_func=EXCLUDED.agg_func, agg_weights=EXCLUDED.agg_weights;

INSERT INTO scenarios
  (id, name, description, field_ids)
VALUES ('ff0c3bb2-cfac-480c-a1f2-91966787cf05', 'ff0c3bb2-cfac-480c-a1f2-91966787cf05', 'ff0c3bb2-cfac-480c-a1f2-91966787cf05',
        array['0cce49e1-dc6a-455c-87f4-fc858ec2d2e7', 'd8181c95-f1a3-4b01-b0ac-dfc5b6cfe38e']::uuid[]) ON CONFLICT(id) DO
UPDATE SET name=EXCLUDED.name, description=EXCLUDED.description, field_ids=EXCLUDED.field_ids;

INSERT INTO fields
  (id, key, description, agg_func, agg_weights)
VALUES ('0cce49e1-dc6a-455c-87f4-fc858ec2d2e7', 'normalized_reward', 'Primary raw scenario score.', NULL, NULL) ON CONFLICT(id) DO
UPDATE SET key =EXCLUDED.key, description=EXCLUDED.description, agg_func=EXCLUDED.agg_func, agg_weights=EXCLUDED.agg_weights;

INSERT INTO fields
  (id, key, description, agg_func, agg_weights)
VALUES ('d8181c95-f1a3-4b01-b0ac-dfc5b6cfe38e', 'percentage_complete', 'Secondary raw scenario score.', NULL, NULL) ON CONFLICT(id) DO
UPDATE SET key =EXCLUDED.key, description=EXCLUDED.description, agg_func=EXCLUDED.agg_func, agg_weights=EXCLUDED.agg_weights;

INSERT INTO tests
  (id, name, description, field_ids, scenario_ids, loop, queue)
VALUES ('12e03a34-d11b-4635-bf9f-b6d0f7003a66', 'Test 1', 'Test 1: 7 agents,  30x30, 2', array['425fbb2f-1c33-44f5-a3cf-1ead9a7935bb',
        '0422d549-cd91-42d9-948a-97f71880450a']::uuid[], array['c3e9e8ca-123d-4335-be18-14c0513449f6']::uuid[], 'CLOSED', NULL) ON CONFLICT(id) DO
UPDATE SET name=EXCLUDED.name, description=EXCLUDED.description, field_ids=EXCLUDED.field_ids, scenario_ids=EXCLUDED.scenario_ids, loop=EXCLUDED.loop, queue=EXCLUDED.queue;

INSERT INTO fields
  (id, key, description, agg_func, agg_fields)
VALUES ('425fbb2f-1c33-44f5-a3cf-1ead9a7935bb', 'normalized_reward', 'Primary test score (NANSUM of corresponding scenario scores)', 'NANSUM',
        '"percentage_complete"') ON CONFLICT(id) DO
UPDATE SET key =EXCLUDED.key, description=EXCLUDED.description, agg_func=EXCLUDED.agg_func, agg_weights=EXCLUDED.agg_weights;

INSERT INTO fields
  (id, key, description, agg_func, agg_fields)
VALUES ('0422d549-cd91-42d9-948a-97f71880450a', 'percentage_complete', 'Secondary test score (NANMEAN of corresponding scenario scores)', 'NANMEAN',
        '"percentage_complete"') ON CONFLICT(id) DO
UPDATE SET key =EXCLUDED.key, description=EXCLUDED.description, agg_func=EXCLUDED.agg_func, agg_weights=EXCLUDED.agg_weights;

INSERT INTO scenarios
  (id, name, description, field_ids)
VALUES ('c3e9e8ca-123d-4335-be18-14c0513449f6', 'c3e9e8ca-123d-4335-be18-14c0513449f6', 'c3e9e8ca-123d-4335-be18-14c0513449f6',
        array['0cce49e1-dc6a-455c-87f4-fc858ec2d2e7', 'd8181c95-f1a3-4b01-b0ac-dfc5b6cfe38e']::uuid[]) ON CONFLICT(id) DO
UPDATE SET name=EXCLUDED.name, description=EXCLUDED.description, field_ids=EXCLUDED.field_ids;

INSERT INTO fields
  (id, key, description, agg_func, agg_weights)
VALUES ('0cce49e1-dc6a-455c-87f4-fc858ec2d2e7', 'normalized_reward', 'Primary raw scenario score.', NULL, NULL) ON CONFLICT(id) DO
UPDATE SET key =EXCLUDED.key, description=EXCLUDED.description, agg_func=EXCLUDED.agg_func, agg_weights=EXCLUDED.agg_weights;

INSERT INTO fields
  (id, key, description, agg_func, agg_weights)
VALUES ('d8181c95-f1a3-4b01-b0ac-dfc5b6cfe38e', 'percentage_complete', 'Secondary raw scenario score.', NULL, NULL) ON CONFLICT(id) DO
UPDATE SET key =EXCLUDED.key, description=EXCLUDED.description, agg_func=EXCLUDED.agg_func, agg_weights=EXCLUDED.agg_weights;

INSERT INTO tests
  (id, name, description, field_ids, scenario_ids, loop, queue)
VALUES ('edb50f48-d579-4994-afcd-08e106d375cb', 'Test 2', 'Test 2: 7 agents,  30x30, 2', array['425fbb2f-1c33-44f5-a3cf-1ead9a7935bb',
        '0422d549-cd91-42d9-948a-97f71880450a']::uuid[], array['ee616a1c-3583-438c-86ec-b2b2b4e0ce22']::uuid[], 'CLOSED', NULL) ON CONFLICT(id) DO
UPDATE SET name=EXCLUDED.name, description=EXCLUDED.description, field_ids=EXCLUDED.field_ids, scenario_ids=EXCLUDED.scenario_ids, loop=EXCLUDED.loop, queue=EXCLUDED.queue;

INSERT INTO fields
  (id, key, description, agg_func, agg_fields)
VALUES ('425fbb2f-1c33-44f5-a3cf-1ead9a7935bb', 'normalized_reward', 'Primary test score (NANSUM of corresponding scenario scores)', 'NANSUM',
        '"percentage_complete"') ON CONFLICT(id) DO
UPDATE SET key =EXCLUDED.key, description=EXCLUDED.description, agg_func=EXCLUDED.agg_func, agg_weights=EXCLUDED.agg_weights;

INSERT INTO fields
  (id, key, description, agg_func, agg_fields)
VALUES ('0422d549-cd91-42d9-948a-97f71880450a', 'percentage_complete', 'Secondary test score (NANMEAN of corresponding scenario scores)', 'NANMEAN',
        '"percentage_complete"') ON CONFLICT(id) DO
UPDATE SET key =EXCLUDED.key, description=EXCLUDED.description, agg_func=EXCLUDED.agg_func, agg_weights=EXCLUDED.agg_weights;

INSERT INTO scenarios
  (id, name, description, field_ids)
VALUES ('ee616a1c-3583-438c-86ec-b2b2b4e0ce22', 'ee616a1c-3583-438c-86ec-b2b2b4e0ce22', 'ee616a1c-3583-438c-86ec-b2b2b4e0ce22',
        array['0cce49e1-dc6a-455c-87f4-fc858ec2d2e7', 'd8181c95-f1a3-4b01-b0ac-dfc5b6cfe38e']::uuid[]) ON CONFLICT(id) DO
UPDATE SET name=EXCLUDED.name, description=EXCLUDED.description, field_ids=EXCLUDED.field_ids;

INSERT INTO fields
  (id, key, description, agg_func, agg_weights)
VALUES ('0cce49e1-dc6a-455c-87f4-fc858ec2d2e7', 'normalized_reward', 'Primary raw scenario score.', NULL, NULL) ON CONFLICT(id) DO
UPDATE SET key =EXCLUDED.key, description=EXCLUDED.description, agg_func=EXCLUDED.agg_func, agg_weights=EXCLUDED.agg_weights;

INSERT INTO fields
  (id, key, description, agg_func, agg_weights)
VALUES ('d8181c95-f1a3-4b01-b0ac-dfc5b6cfe38e', 'percentage_complete', 'Secondary raw scenario score.', NULL, NULL) ON CONFLICT(id) DO
UPDATE SET key =EXCLUDED.key, description=EXCLUDED.description, agg_func=EXCLUDED.agg_func, agg_weights=EXCLUDED.agg_weights;

INSERT INTO tests
  (id, name, description, field_ids, scenario_ids, loop, queue)
VALUES ('7f277294-de87-463b-a526-35b70c0bf693', 'Test 3', 'Test 3: 7 agents,  30x30, 2', array['425fbb2f-1c33-44f5-a3cf-1ead9a7935bb',
        '0422d549-cd91-42d9-948a-97f71880450a']::uuid[], array['3af83068-1e6d-45ce-979f-bddaf130d6ed']::uuid[], 'CLOSED', NULL) ON CONFLICT(id) DO
UPDATE SET name=EXCLUDED.name, description=EXCLUDED.description, field_ids=EXCLUDED.field_ids, scenario_ids=EXCLUDED.scenario_ids, loop=EXCLUDED.loop, queue=EXCLUDED.queue;

INSERT INTO fields
  (id, key, description, agg_func, agg_fields)
VALUES ('425fbb2f-1c33-44f5-a3cf-1ead9a7935bb', 'normalized_reward', 'Primary test score (NANSUM of corresponding scenario scores)', 'NANSUM',
        '"percentage_complete"') ON CONFLICT(id) DO
UPDATE SET key =EXCLUDED.key, description=EXCLUDED.description, agg_func=EXCLUDED.agg_func, agg_weights=EXCLUDED.agg_weights;

INSERT INTO fields
  (id, key, description, agg_func, agg_fields)
VALUES ('0422d549-cd91-42d9-948a-97f71880450a', 'percentage_complete', 'Secondary test score (NANMEAN of corresponding scenario scores)', 'NANMEAN',
        '"percentage_complete"') ON CONFLICT(id) DO
UPDATE SET key =EXCLUDED.key, description=EXCLUDED.description, agg_func=EXCLUDED.agg_func, agg_weights=EXCLUDED.agg_weights;

INSERT INTO scenarios
  (id, name, description, field_ids)
VALUES ('3af83068-1e6d-45ce-979f-bddaf130d6ed', '3af83068-1e6d-45ce-979f-bddaf130d6ed', '3af83068-1e6d-45ce-979f-bddaf130d6ed',
        array['0cce49e1-dc6a-455c-87f4-fc858ec2d2e7', 'd8181c95-f1a3-4b01-b0ac-dfc5b6cfe38e']::uuid[]) ON CONFLICT(id) DO
UPDATE SET name=EXCLUDED.name, description=EXCLUDED.description, field_ids=EXCLUDED.field_ids;

INSERT INTO fields
  (id, key, description, agg_func, agg_weights)
VALUES ('0cce49e1-dc6a-455c-87f4-fc858ec2d2e7', 'normalized_reward', 'Primary raw scenario score.', NULL, NULL) ON CONFLICT(id) DO
UPDATE SET key =EXCLUDED.key, description=EXCLUDED.description, agg_func=EXCLUDED.agg_func, agg_weights=EXCLUDED.agg_weights;

INSERT INTO fields
  (id, key, description, agg_func, agg_weights)
VALUES ('d8181c95-f1a3-4b01-b0ac-dfc5b6cfe38e', 'percentage_complete', 'Secondary raw scenario score.', NULL, NULL) ON CONFLICT(id) DO
UPDATE SET key =EXCLUDED.key, description=EXCLUDED.description, agg_func=EXCLUDED.agg_func, agg_weights=EXCLUDED.agg_weights;

INSERT INTO tests
  (id, name, description, field_ids, scenario_ids, loop, queue)
VALUES ('678cdb1e-86c4-42a7-9c0d-0073a80faaf0', 'Test 4', 'Test 4: 7 agents,  30x30, 2', array['425fbb2f-1c33-44f5-a3cf-1ead9a7935bb',
        '0422d549-cd91-42d9-948a-97f71880450a']::uuid[], array['f61e6d16-5975-461d-ad99-1c70d0cec2ec']::uuid[], 'CLOSED', NULL) ON CONFLICT(id) DO
UPDATE SET name=EXCLUDED.name, description=EXCLUDED.description, field_ids=EXCLUDED.field_ids, scenario_ids=EXCLUDED.scenario_ids, loop=EXCLUDED.loop, queue=EXCLUDED.queue;

INSERT INTO fields
  (id, key, description, agg_func, agg_fields)
VALUES ('425fbb2f-1c33-44f5-a3cf-1ead9a7935bb', 'normalized_reward', 'Primary test score (NANSUM of corresponding scenario scores)', 'NANSUM',
        '"percentage_complete"') ON CONFLICT(id) DO
UPDATE SET key =EXCLUDED.key, description=EXCLUDED.description, agg_func=EXCLUDED.agg_func, agg_weights=EXCLUDED.agg_weights;

INSERT INTO fields
  (id, key, description, agg_func, agg_fields)
VALUES ('0422d549-cd91-42d9-948a-97f71880450a', 'percentage_complete', 'Secondary test score (NANMEAN of corresponding scenario scores)', 'NANMEAN',
        '"percentage_complete"') ON CONFLICT(id) DO
UPDATE SET key =EXCLUDED.key, description=EXCLUDED.description, agg_func=EXCLUDED.agg_func, agg_weights=EXCLUDED.agg_weights;

INSERT INTO scenarios
  (id, name, description, field_ids)
VALUES ('f61e6d16-5975-461d-ad99-1c70d0cec2ec', 'f61e6d16-5975-461d-ad99-1c70d0cec2ec', 'f61e6d16-5975-461d-ad99-1c70d0cec2ec',
        array['0cce49e1-dc6a-455c-87f4-fc858ec2d2e7', 'd8181c95-f1a3-4b01-b0ac-dfc5b6cfe38e']::uuid[]) ON CONFLICT(id) DO
UPDATE SET name=EXCLUDED.name, description=EXCLUDED.description, field_ids=EXCLUDED.field_ids;

INSERT INTO fields
  (id, key, description, agg_func, agg_weights)
VALUES ('0cce49e1-dc6a-455c-87f4-fc858ec2d2e7', 'normalized_reward', 'Primary raw scenario score.', NULL, NULL) ON CONFLICT(id) DO
UPDATE SET key =EXCLUDED.key, description=EXCLUDED.description, agg_func=EXCLUDED.agg_func, agg_weights=EXCLUDED.agg_weights;

INSERT INTO fields
  (id, key, description, agg_func, agg_weights)
VALUES ('d8181c95-f1a3-4b01-b0ac-dfc5b6cfe38e', 'percentage_complete', 'Secondary raw scenario score.', NULL, NULL) ON CONFLICT(id) DO
UPDATE SET key =EXCLUDED.key, description=EXCLUDED.description, agg_func=EXCLUDED.agg_func, agg_weights=EXCLUDED.agg_weights;

