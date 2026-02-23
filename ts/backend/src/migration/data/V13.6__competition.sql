INSERT INTO suites
  (id, setup, name, description, contents, benchmark_ids)
VALUES ('6240c685-0fb4-481e-9404-47a570632227', 'COMPETITION', 'Real-World Baselines Challenge',
        'Towards Real-Time Train Rescheduling: Multi-Agent Reinforcement Learning and Operations Research for Dynamic Train Rescheduling under Stochastic Perturbations',
        '{"introduction":"<p><b>In this competition we want to find out how to efficiently manage dense traffic on a complex railway network with unforeseen events.</b></p><p>This competition tackles a real-world problem faced by many transportation companies around the world: the vehicle rescheduling problem (VRSP). It aims to identify novel solutions and advance existing approaches for dynamic railway rescheduling to take a step towards real-time rescheduling demands of future railway networks. Your contribution to this challenge might influence how modern traffic management systems are implemented.</p><p>This competition is part of the <a href=\"https://ai4realnet.eu/\">AI4REALNET project</a> (AI for REAL-world NETwork operation).</p>","tabs":[{"title":"What is Flatland?","text":"<p><a href=\"https://github.com/flatland-association/flatland-rl\">Flatland</a> is an open-source framework for developing and comparing Multi-Agent Reinforcement Learning algorithms in little (or ridiculously large!) grid-worlds. Check out the extensive <a href=\"https://flatland-association.github.io/flatland-book/intro.html\">documentation on GitHub</a> or the <a href=\"https://arxiv.org/abs/2012.05893\">paper on arXiv</a>.</p>"},{"title":"Competition Procedure","text":"<p>The competition consists of a warm-up round for participants to familiarize themselves with the Flatland environment and the competition setup. After that, the proper competition starts with new and more complex environments to tackle.</p><p><b>Warm-up round:</b> November 10th, 2025 - November 28th, 2025</p><p><b>Proper competition:</b> December 1st, 2025 - January 23rd, 2026</p>"},{"title":"Prizes","text":"There will be a paper written on the competition and the best teams and their solutions will be included. The paper is meant to be published and presented at a relevant conference, e.g. NeurIPS."},{"title":"Rules","text":"<p><b>General:</b> In the following, Participant refers to a single person or a participating team. By signing up for this competition, Participants agree to the rules of the competition. Anyone registered as Participant has the right to participate in the competition and participants are allowed to form teams.</p><p><b>Daily Submission Cap:</b> Each Participant may submit up to 5 solutions per day.</p><p><b>Runtime Limitation:</b> The evaluation of a solution will be stopped if double the timesteps of the latest scheduled arrival elapsed during a scenario, or if the evaluation lasts longer than 4 hours. The scores for all completed scenarios up to that point will be counted toward to competition.</p><p><b>Open Source:</b> Participants must open source their submissions in order to qualify for prizes.</p><p>Evaluation Procedure: Submissions are initially scored automatically and shown on the leaderboard. Top-performing entries are subjected to a secondary human review to resolve any ties and ensure robustness of the scoring methodology.</p>"},{"title":"Contact","text":"<p>Join the competition on our Revolt server: tba</p><p>Get in touch with us by e-mail <a href=\"mailto:competition@flatland-association.org\">competition@flatland-association.org</a></p>"}]}',
        array['c85d5fc2-15da-4a62-8e14-28d1261c29bd']::uuid[]) ON CONFLICT(id) DO
UPDATE SET setup=EXCLUDED.setup, name =EXCLUDED.name, description=EXCLUDED.description, benchmark_ids=EXCLUDED.benchmark_ids;

INSERT INTO benchmarks
  (id, name, description, field_ids, test_ids)
VALUES ('c85d5fc2-15da-4a62-8e14-28d1261c29bd', 'Railway competition', 'The warm-up round runs from November 10th, 2025 - November 28th, 2025',
        array['a2a20282-a423-4478-907b-ee51b602c8b3', '5eb94715-3faa-4e1a-972e-d75c263e9f17']::uuid[], array['2a085b24-4cde-428a-977f-4771a25bfc3c',
        'b3cde510-701e-440c-931d-8c1c032f8d9d', 'c2e24c50-a4e2-48c3-8cb8-fe46ff245802', '44ea4b29-37d2-4c04-98a2-8f758173c2ab',
        'fbe1bb82-848c-4e65-9c9d-88e1e351265d']::uuid[]) ON CONFLICT(id) DO
UPDATE SET name=EXCLUDED.name, description=EXCLUDED.description, field_ids=EXCLUDED.field_ids, test_ids=EXCLUDED.test_ids;

INSERT INTO fields
  (id, key, description, agg_func, agg_fields)
VALUES ('a2a20282-a423-4478-907b-ee51b602c8b3', 'normalized_reward', 'Primary benchmark score (NANSUM of corresponding test scores)', 'NANSUM',
        '"normalized_reward"') ON CONFLICT(id) DO
UPDATE SET key =EXCLUDED.key, description=EXCLUDED.description, agg_func=EXCLUDED.agg_func, agg_weights=EXCLUDED.agg_weights;

INSERT INTO fields
  (id, key, description, agg_func, agg_fields)
VALUES ('5eb94715-3faa-4e1a-972e-d75c263e9f17', 'percentage_complete', 'Secondary benchmark score (NANMEAN of corresponding test scores)', 'NANMEAN',
        '"percentage_complete"') ON CONFLICT(id) DO
UPDATE SET key =EXCLUDED.key, description=EXCLUDED.description, agg_func=EXCLUDED.agg_func, agg_weights=EXCLUDED.agg_weights;

INSERT INTO tests
  (id, name, description, field_ids, scenario_ids, loop, queue)
VALUES ('2a085b24-4cde-428a-977f-4771a25bfc3c', 'Test 0', 'Test 0: 7 agents,  30x30, 2', array['f3160df2-1a3a-4564-8349-b6931cf1291c',
        '6af22676-c8e0-4ed0-992c-3dad9b4c449b']::uuid[], array['046c6f42-a713-4b3d-94df-99c23753a682']::uuid[], 'CLOSED', NULL) ON CONFLICT(id) DO
UPDATE SET name=EXCLUDED.name, description=EXCLUDED.description, field_ids=EXCLUDED.field_ids, scenario_ids=EXCLUDED.scenario_ids, loop=EXCLUDED.loop, queue=EXCLUDED.queue;

INSERT INTO fields
  (id, key, description, agg_func, agg_fields)
VALUES ('f3160df2-1a3a-4564-8349-b6931cf1291c', 'normalized_reward', 'Primary test score (NANSUM of corresponding scenario scores)', 'NANSUM',
        '"percentage_complete"') ON CONFLICT(id) DO
UPDATE SET key =EXCLUDED.key, description=EXCLUDED.description, agg_func=EXCLUDED.agg_func, agg_weights=EXCLUDED.agg_weights;

INSERT INTO fields
  (id, key, description, agg_func, agg_fields)
VALUES ('6af22676-c8e0-4ed0-992c-3dad9b4c449b', 'percentage_complete', 'Secondary test score (NANMEAN of corresponding scenario scores)', 'NANMEAN',
        '"percentage_complete"') ON CONFLICT(id) DO
UPDATE SET key =EXCLUDED.key, description=EXCLUDED.description, agg_func=EXCLUDED.agg_func, agg_weights=EXCLUDED.agg_weights;

INSERT INTO scenarios
  (id, name, description, field_ids)
VALUES ('046c6f42-a713-4b3d-94df-99c23753a682', '046c6f42-a713-4b3d-94df-99c23753a682', '046c6f42-a713-4b3d-94df-99c23753a682',
        array['89672c24-54f0-4acc-a0c8-8b32d76880af', 'f17cec1e-29c8-4b62-8240-99d97b0405f2']::uuid[]) ON CONFLICT(id) DO
UPDATE SET name=EXCLUDED.name, description=EXCLUDED.description, field_ids=EXCLUDED.field_ids;

INSERT INTO fields
  (id, key, description, agg_func, agg_weights)
VALUES ('89672c24-54f0-4acc-a0c8-8b32d76880af', 'normalized_reward', 'Primary raw scenario score.', NULL, NULL) ON CONFLICT(id) DO
UPDATE SET key =EXCLUDED.key, description=EXCLUDED.description, agg_func=EXCLUDED.agg_func, agg_weights=EXCLUDED.agg_weights;

INSERT INTO fields
  (id, key, description, agg_func, agg_weights)
VALUES ('f17cec1e-29c8-4b62-8240-99d97b0405f2', 'percentage_complete', 'Secondary raw scenario score.', NULL, NULL) ON CONFLICT(id) DO
UPDATE SET key =EXCLUDED.key, description=EXCLUDED.description, agg_func=EXCLUDED.agg_func, agg_weights=EXCLUDED.agg_weights;

INSERT INTO tests
  (id, name, description, field_ids, scenario_ids, loop, queue)
VALUES ('b3cde510-701e-440c-931d-8c1c032f8d9d', 'Test 1', 'Test 1: 7 agents,  30x30, 2', array['f3160df2-1a3a-4564-8349-b6931cf1291c',
        '6af22676-c8e0-4ed0-992c-3dad9b4c449b']::uuid[], array['d2ca9404-f38c-4f01-873a-4e33baf09620']::uuid[], 'CLOSED', NULL) ON CONFLICT(id) DO
UPDATE SET name=EXCLUDED.name, description=EXCLUDED.description, field_ids=EXCLUDED.field_ids, scenario_ids=EXCLUDED.scenario_ids, loop=EXCLUDED.loop, queue=EXCLUDED.queue;

INSERT INTO fields
  (id, key, description, agg_func, agg_fields)
VALUES ('f3160df2-1a3a-4564-8349-b6931cf1291c', 'normalized_reward', 'Primary test score (NANSUM of corresponding scenario scores)', 'NANSUM',
        '"percentage_complete"') ON CONFLICT(id) DO
UPDATE SET key =EXCLUDED.key, description=EXCLUDED.description, agg_func=EXCLUDED.agg_func, agg_weights=EXCLUDED.agg_weights;

INSERT INTO fields
  (id, key, description, agg_func, agg_fields)
VALUES ('6af22676-c8e0-4ed0-992c-3dad9b4c449b', 'percentage_complete', 'Secondary test score (NANMEAN of corresponding scenario scores)', 'NANMEAN',
        '"percentage_complete"') ON CONFLICT(id) DO
UPDATE SET key =EXCLUDED.key, description=EXCLUDED.description, agg_func=EXCLUDED.agg_func, agg_weights=EXCLUDED.agg_weights;

INSERT INTO scenarios
  (id, name, description, field_ids)
VALUES ('d2ca9404-f38c-4f01-873a-4e33baf09620', 'd2ca9404-f38c-4f01-873a-4e33baf09620', 'd2ca9404-f38c-4f01-873a-4e33baf09620',
        array['89672c24-54f0-4acc-a0c8-8b32d76880af', 'f17cec1e-29c8-4b62-8240-99d97b0405f2']::uuid[]) ON CONFLICT(id) DO
UPDATE SET name=EXCLUDED.name, description=EXCLUDED.description, field_ids=EXCLUDED.field_ids;

INSERT INTO fields
  (id, key, description, agg_func, agg_weights)
VALUES ('89672c24-54f0-4acc-a0c8-8b32d76880af', 'normalized_reward', 'Primary raw scenario score.', NULL, NULL) ON CONFLICT(id) DO
UPDATE SET key =EXCLUDED.key, description=EXCLUDED.description, agg_func=EXCLUDED.agg_func, agg_weights=EXCLUDED.agg_weights;

INSERT INTO fields
  (id, key, description, agg_func, agg_weights)
VALUES ('f17cec1e-29c8-4b62-8240-99d97b0405f2', 'percentage_complete', 'Secondary raw scenario score.', NULL, NULL) ON CONFLICT(id) DO
UPDATE SET key =EXCLUDED.key, description=EXCLUDED.description, agg_func=EXCLUDED.agg_func, agg_weights=EXCLUDED.agg_weights;

INSERT INTO tests
  (id, name, description, field_ids, scenario_ids, loop, queue)
VALUES ('c2e24c50-a4e2-48c3-8cb8-fe46ff245802', 'Test 2', 'Test 2: 7 agents,  30x30, 2', array['f3160df2-1a3a-4564-8349-b6931cf1291c',
        '6af22676-c8e0-4ed0-992c-3dad9b4c449b']::uuid[], array['31fb82ac-fae2-4a78-9148-5a9fe93716c7']::uuid[], 'CLOSED', NULL) ON CONFLICT(id) DO
UPDATE SET name=EXCLUDED.name, description=EXCLUDED.description, field_ids=EXCLUDED.field_ids, scenario_ids=EXCLUDED.scenario_ids, loop=EXCLUDED.loop, queue=EXCLUDED.queue;

INSERT INTO fields
  (id, key, description, agg_func, agg_fields)
VALUES ('f3160df2-1a3a-4564-8349-b6931cf1291c', 'normalized_reward', 'Primary test score (NANSUM of corresponding scenario scores)', 'NANSUM',
        '"percentage_complete"') ON CONFLICT(id) DO
UPDATE SET key =EXCLUDED.key, description=EXCLUDED.description, agg_func=EXCLUDED.agg_func, agg_weights=EXCLUDED.agg_weights;

INSERT INTO fields
  (id, key, description, agg_func, agg_fields)
VALUES ('6af22676-c8e0-4ed0-992c-3dad9b4c449b', 'percentage_complete', 'Secondary test score (NANMEAN of corresponding scenario scores)', 'NANMEAN',
        '"percentage_complete"') ON CONFLICT(id) DO
UPDATE SET key =EXCLUDED.key, description=EXCLUDED.description, agg_func=EXCLUDED.agg_func, agg_weights=EXCLUDED.agg_weights;

INSERT INTO scenarios
  (id, name, description, field_ids)
VALUES ('31fb82ac-fae2-4a78-9148-5a9fe93716c7', '31fb82ac-fae2-4a78-9148-5a9fe93716c7', '31fb82ac-fae2-4a78-9148-5a9fe93716c7',
        array['89672c24-54f0-4acc-a0c8-8b32d76880af', 'f17cec1e-29c8-4b62-8240-99d97b0405f2']::uuid[]) ON CONFLICT(id) DO
UPDATE SET name=EXCLUDED.name, description=EXCLUDED.description, field_ids=EXCLUDED.field_ids;

INSERT INTO fields
  (id, key, description, agg_func, agg_weights)
VALUES ('89672c24-54f0-4acc-a0c8-8b32d76880af', 'normalized_reward', 'Primary raw scenario score.', NULL, NULL) ON CONFLICT(id) DO
UPDATE SET key =EXCLUDED.key, description=EXCLUDED.description, agg_func=EXCLUDED.agg_func, agg_weights=EXCLUDED.agg_weights;

INSERT INTO fields
  (id, key, description, agg_func, agg_weights)
VALUES ('f17cec1e-29c8-4b62-8240-99d97b0405f2', 'percentage_complete', 'Secondary raw scenario score.', NULL, NULL) ON CONFLICT(id) DO
UPDATE SET key =EXCLUDED.key, description=EXCLUDED.description, agg_func=EXCLUDED.agg_func, agg_weights=EXCLUDED.agg_weights;

INSERT INTO tests
  (id, name, description, field_ids, scenario_ids, loop, queue)
VALUES ('44ea4b29-37d2-4c04-98a2-8f758173c2ab', 'Test 3', 'Test 3: 7 agents,  30x30, 2', array['f3160df2-1a3a-4564-8349-b6931cf1291c',
        '6af22676-c8e0-4ed0-992c-3dad9b4c449b']::uuid[], array['666f08ab-8a2d-41fc-adbe-9644796e439f']::uuid[], 'CLOSED', NULL) ON CONFLICT(id) DO
UPDATE SET name=EXCLUDED.name, description=EXCLUDED.description, field_ids=EXCLUDED.field_ids, scenario_ids=EXCLUDED.scenario_ids, loop=EXCLUDED.loop, queue=EXCLUDED.queue;

INSERT INTO fields
  (id, key, description, agg_func, agg_fields)
VALUES ('f3160df2-1a3a-4564-8349-b6931cf1291c', 'normalized_reward', 'Primary test score (NANSUM of corresponding scenario scores)', 'NANSUM',
        '"percentage_complete"') ON CONFLICT(id) DO
UPDATE SET key =EXCLUDED.key, description=EXCLUDED.description, agg_func=EXCLUDED.agg_func, agg_weights=EXCLUDED.agg_weights;

INSERT INTO fields
  (id, key, description, agg_func, agg_fields)
VALUES ('6af22676-c8e0-4ed0-992c-3dad9b4c449b', 'percentage_complete', 'Secondary test score (NANMEAN of corresponding scenario scores)', 'NANMEAN',
        '"percentage_complete"') ON CONFLICT(id) DO
UPDATE SET key =EXCLUDED.key, description=EXCLUDED.description, agg_func=EXCLUDED.agg_func, agg_weights=EXCLUDED.agg_weights;

INSERT INTO scenarios
  (id, name, description, field_ids)
VALUES ('666f08ab-8a2d-41fc-adbe-9644796e439f', '666f08ab-8a2d-41fc-adbe-9644796e439f', '666f08ab-8a2d-41fc-adbe-9644796e439f',
        array['89672c24-54f0-4acc-a0c8-8b32d76880af', 'f17cec1e-29c8-4b62-8240-99d97b0405f2']::uuid[]) ON CONFLICT(id) DO
UPDATE SET name=EXCLUDED.name, description=EXCLUDED.description, field_ids=EXCLUDED.field_ids;

INSERT INTO fields
  (id, key, description, agg_func, agg_weights)
VALUES ('89672c24-54f0-4acc-a0c8-8b32d76880af', 'normalized_reward', 'Primary raw scenario score.', NULL, NULL) ON CONFLICT(id) DO
UPDATE SET key =EXCLUDED.key, description=EXCLUDED.description, agg_func=EXCLUDED.agg_func, agg_weights=EXCLUDED.agg_weights;

INSERT INTO fields
  (id, key, description, agg_func, agg_weights)
VALUES ('f17cec1e-29c8-4b62-8240-99d97b0405f2', 'percentage_complete', 'Secondary raw scenario score.', NULL, NULL) ON CONFLICT(id) DO
UPDATE SET key =EXCLUDED.key, description=EXCLUDED.description, agg_func=EXCLUDED.agg_func, agg_weights=EXCLUDED.agg_weights;

INSERT INTO tests
  (id, name, description, field_ids, scenario_ids, loop, queue)
VALUES ('fbe1bb82-848c-4e65-9c9d-88e1e351265d', 'Test 4', 'Test 4: 7 agents,  30x30, 2', array['f3160df2-1a3a-4564-8349-b6931cf1291c',
        '6af22676-c8e0-4ed0-992c-3dad9b4c449b']::uuid[], array['66755e67-1cc8-4898-ad44-704c3e49eec6']::uuid[], 'CLOSED', NULL) ON CONFLICT(id) DO
UPDATE SET name=EXCLUDED.name, description=EXCLUDED.description, field_ids=EXCLUDED.field_ids, scenario_ids=EXCLUDED.scenario_ids, loop=EXCLUDED.loop, queue=EXCLUDED.queue;

INSERT INTO fields
  (id, key, description, agg_func, agg_fields)
VALUES ('f3160df2-1a3a-4564-8349-b6931cf1291c', 'normalized_reward', 'Primary test score (NANSUM of corresponding scenario scores)', 'NANSUM',
        '"percentage_complete"') ON CONFLICT(id) DO
UPDATE SET key =EXCLUDED.key, description=EXCLUDED.description, agg_func=EXCLUDED.agg_func, agg_weights=EXCLUDED.agg_weights;

INSERT INTO fields
  (id, key, description, agg_func, agg_fields)
VALUES ('6af22676-c8e0-4ed0-992c-3dad9b4c449b', 'percentage_complete', 'Secondary test score (NANMEAN of corresponding scenario scores)', 'NANMEAN',
        '"percentage_complete"') ON CONFLICT(id) DO
UPDATE SET key =EXCLUDED.key, description=EXCLUDED.description, agg_func=EXCLUDED.agg_func, agg_weights=EXCLUDED.agg_weights;

INSERT INTO scenarios
  (id, name, description, field_ids)
VALUES ('66755e67-1cc8-4898-ad44-704c3e49eec6', '66755e67-1cc8-4898-ad44-704c3e49eec6', '66755e67-1cc8-4898-ad44-704c3e49eec6',
        array['89672c24-54f0-4acc-a0c8-8b32d76880af', 'f17cec1e-29c8-4b62-8240-99d97b0405f2']::uuid[]) ON CONFLICT(id) DO
UPDATE SET name=EXCLUDED.name, description=EXCLUDED.description, field_ids=EXCLUDED.field_ids;

INSERT INTO fields
  (id, key, description, agg_func, agg_weights)
VALUES ('89672c24-54f0-4acc-a0c8-8b32d76880af', 'normalized_reward', 'Primary raw scenario score.', NULL, NULL) ON CONFLICT(id) DO
UPDATE SET key =EXCLUDED.key, description=EXCLUDED.description, agg_func=EXCLUDED.agg_func, agg_weights=EXCLUDED.agg_weights;

INSERT INTO fields
  (id, key, description, agg_func, agg_weights)
VALUES ('f17cec1e-29c8-4b62-8240-99d97b0405f2', 'percentage_complete', 'Secondary raw scenario score.', NULL, NULL) ON CONFLICT(id) DO
UPDATE SET key =EXCLUDED.key, description=EXCLUDED.description, agg_func=EXCLUDED.agg_func, agg_weights=EXCLUDED.agg_weights;

