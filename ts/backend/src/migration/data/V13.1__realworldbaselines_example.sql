 INSERT INTO suites
    (id, setup, name, description, contents, benchmark_ids)
    VALUES ('24ab2336-a407-4329-b781-d71846250e24', 'COMPETITION', 'Real-World Baselines Challenge', 'Towards Real-Time Train Rescheduling: Multi-Agent Reinforcement Learning and Operations Research for Dynamic Train Rescheduling under Stochastic Perturbations', '{"introduction":"<p><b>In this competition we want to find out how to efficiently manage dense traffic on a complex railway network with unforeseen events.</b></p><p>This competition tackles a real-world problem faced by many transportation companies around the world: the vehicle rescheduling problem (VRSP). It aims to identify novel solutions and advance existing approaches for dynamic railway rescheduling to take a step towards real-time rescheduling demands of future railway networks. Your contribution to this challenge might influence how modern traffic management systems are implemented.</p><p>This competition is part of the <a href=\"https://ai4realnet.eu/\">AI4REALNET project</a> (AI for REAL-world NETwork operation).</p>","tabs":[{"title":"What is Flatland?","text":"<p><a href=\"https://github.com/flatland-association/flatland-rl\">Flatland</a> is an open-source framework for developing and comparing Multi-Agent Reinforcement Learning algorithms in little (or ridiculously large!) grid-worlds. Check out the extensive <a href=\"https://flatland-association.github.io/flatland-book/intro.html\">documentation on GitHub</a> or the <a href=\"https://arxiv.org/abs/2012.05893\">paper on arXiv</a>.</p>"},{"title":"Competition Procedure","text":"<p>The competition consists of a warm-up round for participants to familiarize themselves with the Flatland environment and the competition setup. After that, the proper competition starts with new and more complex environments to tackle.</p><p><b>Warm-up round:</b> November 10th, 2025 - November 28th, 2025</p><p><b>Proper competition:</b> December 1st, 2025 - January 23rd, 2026</p>"},{"title":"Prizes","text":"There will be a paper written on the competition and the best teams and their solutions will be included. The paper is meant to be published and presented at a relevant conference, e.g. NeurIPS."},{"title":"Rules","text":"<p><b>General:</b> In the following, Participant refers to a single person or a participating team. By signing up for this competition, Participants agree to the rules of the competition. Anyone registered as Participant has the right to participate in the competition and participants are allowed to form teams.</p><p><b>Daily Submission Cap:</b> Each Participant may submit up to 5 solutions per day.</p><p><b>Runtime Limitation:</b> The evaluation of a solution will be stopped if double the timesteps of the latest scheduled arrival elapsed during a scenario, or if the evaluation lasts longer than 4 hours. The scores for all completed scenarios up to that point will be counted toward to competition.</p><p><b>Open Source:</b> Participants must open source their submissions in order to qualify for prizes.</p><p>Evaluation Procedure: Submissions are initially scored automatically and shown on the leaderboard. Top-performing entries are subjected to a secondary human review to resolve any ties and ensure robustness of the scoring methodology.</p>"},{"title":"Contact","text":"<p>Join the competition on our Revolt server: tba</p><p>Get in touch with us by e-mail <a href=\"mailto:competition@flatland-association.org\">competition@flatland-association.org</a></p>"}]}', array['fd6dc299-9d3d-410d-a17c-338dc1cf3752']::uuid[])
    ON CONFLICT(id) DO UPDATE SET setup=EXCLUDED.setup, name=EXCLUDED.name, description=EXCLUDED.description, benchmark_ids=EXCLUDED.benchmark_ids;

INSERT INTO benchmarks
    (id, name, description, field_ids, test_ids)
    VALUES ('fd6dc299-9d3d-410d-a17c-338dc1cf3752', 'Warm-up round', 'The warm-up round runs from November 10th, 2025 - November 28th, 2025', array['1ab7fefc-1aaf-4013-8375-784639e588d7', 'aea8e0e3-f73c-482f-ae25-47d3b37d525e']::uuid[], array['b87e0bd6-4231-47da-9cde-044c0092fcd2']::uuid[])
    ON CONFLICT(id) DO UPDATE SET name=EXCLUDED.name, description=EXCLUDED.description, field_ids=EXCLUDED.field_ids, test_ids=EXCLUDED.test_ids;

INSERT INTO fields
        (id, key, description, agg_func, agg_weights)
        VALUES ('1ab7fefc-1aaf-4013-8375-784639e588d7', 'normalized_reward', 'Primary benchmark score (NANSUM of corresponding test scores)', 'NANSUM', NULL)
        ON CONFLICT(id) DO UPDATE SET key=EXCLUDED.key, description=EXCLUDED.description, agg_func=EXCLUDED.agg_func, agg_weights=EXCLUDED.agg_weights;

INSERT INTO fields
        (id, key, description, agg_func, agg_weights)
        VALUES ('aea8e0e3-f73c-482f-ae25-47d3b37d525e', 'percentage_complete', 'Secondary benchmark score (NANMEAN of corresponding test scores)', 'NANMEAN', NULL)
        ON CONFLICT(id) DO UPDATE SET key=EXCLUDED.key, description=EXCLUDED.description, agg_func=EXCLUDED.agg_func, agg_weights=EXCLUDED.agg_weights;

INSERT INTO tests
    (id, name, description, field_ids, scenario_ids, loop, queue)
    VALUES ('b87e0bd6-4231-47da-9cde-044c0092fcd2', 'Test 0', 'Test 0: 7 agents,  30x30, 2', array['1c808fc7-e2e5-46a1-8826-e695e7f91e5f', 'bd52f64e-08b6-4405-8df5-bba7c401c377']::uuid[], array['caecac0f-62d0-41d6-8719-df11b84ed61b']::uuid[], 'CLOSED', NULL)
    ON CONFLICT(id) DO UPDATE SET name=EXCLUDED.name, description=EXCLUDED.description, field_ids=EXCLUDED.field_ids, scenario_ids=EXCLUDED.scenario_ids, loop=EXCLUDED.loop, queue=EXCLUDED.queue;

INSERT INTO fields
        (id, key, description, agg_func, agg_weights)
        VALUES ('1c808fc7-e2e5-46a1-8826-e695e7f91e5f', 'normalized_reward', 'Primary test score (NANSUM of corresponding scenario scores)', 'NANSUM', NULL)
        ON CONFLICT(id) DO UPDATE SET key=EXCLUDED.key, description=EXCLUDED.description, agg_func=EXCLUDED.agg_func, agg_weights=EXCLUDED.agg_weights;

INSERT INTO fields
        (id, key, description, agg_func, agg_weights)
        VALUES ('bd52f64e-08b6-4405-8df5-bba7c401c377', 'percentage_complete', 'Secondary test score (NANMEAN of corresponding scenario scores)', 'NANMEAN', NULL)
        ON CONFLICT(id) DO UPDATE SET key=EXCLUDED.key, description=EXCLUDED.description, agg_func=EXCLUDED.agg_func, agg_weights=EXCLUDED.agg_weights;

INSERT INTO scenarios
    (id, name, description, field_ids)
    VALUES ('caecac0f-62d0-41d6-8719-df11b84ed61b', 'caecac0f-62d0-41d6-8719-df11b84ed61b', 'caecac0f-62d0-41d6-8719-df11b84ed61b', array['ef3ee130-59ce-4d63-8a36-06caa9a31749', '5aff3b22-8835-4730-be76-627b41f8534d']::uuid[])
    ON CONFLICT(id) DO UPDATE SET name=EXCLUDED.name, description=EXCLUDED.description, field_ids=EXCLUDED.field_ids;

INSERT INTO fields
        (id, key, description, agg_func, agg_weights)
        VALUES ('ef3ee130-59ce-4d63-8a36-06caa9a31749', 'normalized_reward', 'Primary raw scenario score.', NULL, NULL)
        ON CONFLICT(id) DO UPDATE SET key=EXCLUDED.key, description=EXCLUDED.description, agg_func=EXCLUDED.agg_func, agg_weights=EXCLUDED.agg_weights;

INSERT INTO fields
        (id, key, description, agg_func, agg_weights)
        VALUES ('5aff3b22-8835-4730-be76-627b41f8534d', 'percentage_complete', 'Secondary raw scenario score.', NULL, NULL)
        ON CONFLICT(id) DO UPDATE SET key=EXCLUDED.key, description=EXCLUDED.description, agg_func=EXCLUDED.agg_func, agg_weights=EXCLUDED.agg_weights;

