 INSERT INTO suites
    (id, setup, name, description, contents, benchmark_ids)
    VALUES ('24ab2336-a407-4329-b781-d71846250e24', 'COMPETITION', 'Real-World Baselines Challenge', 'Towards Real-Time Train Rescheduling: Multi-Agent Reinforcement Learning and Operations Research for Dynamic Train Rescheduling under Stochastic Perturbations', '{"introduction":"<p><b>In this competition we want to find out how to efficiently manage dense traffic on a complex railway network with unforeseen events.</b></p><p>This competition tackles a real-world problem faced by many transportation companies around the world: the vehicle rescheduling problem (VRSP). It aims to identify novel solutions and advance existing approaches for dynamic railway rescheduling to take a step towards real-time rescheduling demands of future railway networks. Your contribution to this challenge might influence how modern traffic management systems are implemented.</p><p>This competition is part of the <a href=\"https://ai4realnet.eu/\">AI4REALNET project</a> (AI for REAL-world NETwork operation).</p>","tabs":[{"title":"What is Flatland?","text":"<p><a href=\"https://github.com/flatland-association/flatland-rl\">Flatland</a> is an open-source framework for developing and comparing Multi-Agent Reinforcement Learning algorithms in little (or ridiculously large!) grid-worlds. Check out the extensive <a href=\"https://flatland-association.github.io/flatland-book/intro.html\">documentation on GitHub</a> or the <a href=\"https://arxiv.org/abs/2012.05893\">paper on arXiv</a>.</p>"},{"title":"Competition Procedure","text":"<p>The competition consists of a warm-up round for participants to familiarize themselves with the Flatland environment and the competition setup. After that, the proper competition starts with new and more complex environments to tackle.</p><p><b>Warm-up round:</b> November 10th, 2025 - November 28th, 2025</p><p><b>Proper competition:</b> December 1st, 2025 - January 23rd, 2026</p>"},{"title":"Prizes","text":"There will be a paper written on the competition and the best teams and their solutions will be included. The paper is meant to be published and presented at a relevant conference, e.g. NeurIPS."},{"title":"Rules","text":"<p><b>General:</b> In the following, Participant refers to a single person or a participating team. By signing up for this competition, Participants agree to the rules of the competition. Anyone registered as Participant has the right to participate in the competition and participants are allowed to form teams.</p><p><b>Daily Submission Cap:</b> Each Participant may submit up to 5 solutions per day.</p><p><b>Runtime Limitation:</b> The evaluation of a solution will be stopped if double the timesteps of the latest scheduled arrival elapsed during a scenario, or if the evaluation lasts longer than 4 hours. The scores for all completed scenarios up to that point will be counted toward to competition.</p><p><b>Open Source:</b> Participants must open source their submissions in order to qualify for prizes.</p><p>Evaluation Procedure: Submissions are initially scored automatically and shown on the leaderboard. Top-performing entries are subjected to a secondary human review to resolve any ties and ensure robustness of the scoring methodology.</p>"},{"title":"Contact","text":"<p>Join the competition on our Revolt server: tba</p><p>Get in touch with us by e-mail <a href=\"mailto:competition@flatland-association.org\">competition@flatland-association.org</a></p>"}]}', array['fd6dc299-9d3d-410d-a17c-338dc1cf3752']::uuid[])
    ON CONFLICT(id) DO UPDATE SET setup=EXCLUDED.setup, name=EXCLUDED.name, description=EXCLUDED.description, benchmark_ids=EXCLUDED.benchmark_ids;

INSERT INTO benchmarks
    (id, name, description, field_ids, test_ids)
    VALUES ('fd6dc299-9d3d-410d-a17c-338dc1cf3752', 'Warm-up round', 'The warm-up round runs from November 10th, 2025 - November 28th, 2025', array['38dcca23-35af-4cf0-992f-31a89fb16ac1', '69839a45-1043-4568-aad5-ed843524dd8c']::uuid[], array['fc8f5fb1-4525-4b4f-a022-d3d7800097dc', 'a8639b18-9568-42d2-ba9c-88d0d3c1cede', '254de248-0210-4bf9-a349-8f769c5280e2', 'e3bf5a0f-4d6c-43be-9352-c630938b871c', '8a17eb8e-14cb-463f-b687-2fff7e205a5e', 'd6dc02b7-4683-4ef5-8632-9f9746e06c70', '6dac64f4-fe91-4cca-a04d-541160d7c72a', '3beb68e9-464d-4fb9-962b-15552f1e5185', '0036e4d8-ec52-4471-8639-ee410037e56e', 'c69e9baf-6903-40a5-90ed-8a6ace77c20b', '21e4c84a-9595-4c83-9c7f-29d1d11be0af', 'dd8bdf82-4e0a-45c2-a3f7-5585007ef0ab', 'c04e6a19-af18-4676-b84a-a6bc84453e3d', '02b447ec-4338-46e6-9634-05b74630388d', 'e47db3ae-700c-4bad-ae88-466ea5105b87']::uuid[])
    ON CONFLICT(id) DO UPDATE SET name=EXCLUDED.name, description=EXCLUDED.description, field_ids=EXCLUDED.field_ids, test_ids=EXCLUDED.test_ids;

INSERT INTO fields
        (id, key, description, agg_func, agg_weights)
        VALUES ('38dcca23-35af-4cf0-992f-31a89fb16ac1', 'normalized_reward', 'Primary benchmark score (NANSUM of corresponding test scores)', 'NANSUM', NULL)
        ON CONFLICT(id) DO UPDATE SET key=EXCLUDED.key, description=EXCLUDED.description, agg_func=EXCLUDED.agg_func, agg_weights=EXCLUDED.agg_weights;

INSERT INTO fields
        (id, key, description, agg_func, agg_weights)
        VALUES ('69839a45-1043-4568-aad5-ed843524dd8c', 'percentage_complete', 'Secondary benchmark score (NANMEAN of corresponding test scores)', 'NANMEAN', NULL)
        ON CONFLICT(id) DO UPDATE SET key=EXCLUDED.key, description=EXCLUDED.description, agg_func=EXCLUDED.agg_func, agg_weights=EXCLUDED.agg_weights;

INSERT INTO tests
    (id, name, description, field_ids, scenario_ids, loop, queue)
    VALUES ('fc8f5fb1-4525-4b4f-a022-d3d7800097dc', 'Test 0', 'Test 0: 7 agents,  30x30, 2', array['d1acf912-f71d-4ded-832c-e89cd272a0cc', 'd077454a-bba5-4798-90ed-4919d6f26e8b']::uuid[], array['289394a5-aa51-446c-9b62-c25101643790', '01dc6523-a236-4da6-8ca6-934d771fc82d', '2148fd5e-6141-4fd6-bcae-a93a66c81e61', 'f5f140c5-b999-4134-9a0a-fde6f2cf1388', '7a0d140a-1213-407f-a6b3-5640c5c0caa7', '467626bb-4abe-4451-9cd7-f7b1cc5217b9', '06b6b84f-b4ad-4446-943f-40911ed46354', '12cbd8df-b29c-49e8-98f7-12eec20439ac', '1610eb72-fa63-4880-8a21-9e760acc1586', 'da237c4f-1eba-487a-a630-305eac8fabf3']::uuid[], 'CLOSED', NULL)
    ON CONFLICT(id) DO UPDATE SET name=EXCLUDED.name, description=EXCLUDED.description, field_ids=EXCLUDED.field_ids, scenario_ids=EXCLUDED.scenario_ids, loop=EXCLUDED.loop, queue=EXCLUDED.queue;

INSERT INTO fields
        (id, key, description, agg_func, agg_weights)
        VALUES ('d1acf912-f71d-4ded-832c-e89cd272a0cc', 'normalized_reward', 'Primary test score (NANSUM of corresponding scenario scores)', 'NANSUM', NULL)
        ON CONFLICT(id) DO UPDATE SET key=EXCLUDED.key, description=EXCLUDED.description, agg_func=EXCLUDED.agg_func, agg_weights=EXCLUDED.agg_weights;

INSERT INTO fields
        (id, key, description, agg_func, agg_weights)
        VALUES ('d077454a-bba5-4798-90ed-4919d6f26e8b', 'percentage_complete', 'Secondary test score (NANMEAN of corresponding scenario scores)', 'NANMEAN', NULL)
        ON CONFLICT(id) DO UPDATE SET key=EXCLUDED.key, description=EXCLUDED.description, agg_func=EXCLUDED.agg_func, agg_weights=EXCLUDED.agg_weights;

INSERT INTO scenarios
    (id, name, description, field_ids)
    VALUES ('289394a5-aa51-446c-9b62-c25101643790', '289394a5-aa51-446c-9b62-c25101643790', '289394a5-aa51-446c-9b62-c25101643790', array['19d07c00-6f34-4e32-9c5e-50a8a46f1c90', '176b73f7-02ae-49ea-8d1d-f1214fb0bd5d']::uuid[])
    ON CONFLICT(id) DO UPDATE SET name=EXCLUDED.name, description=EXCLUDED.description, field_ids=EXCLUDED.field_ids;

INSERT INTO fields
        (id, key, description, agg_func, agg_weights)
        VALUES ('19d07c00-6f34-4e32-9c5e-50a8a46f1c90', 'normalized_reward', 'Primary raw scenario score.', NULL, NULL)
        ON CONFLICT(id) DO UPDATE SET key=EXCLUDED.key, description=EXCLUDED.description, agg_func=EXCLUDED.agg_func, agg_weights=EXCLUDED.agg_weights;

INSERT INTO fields
        (id, key, description, agg_func, agg_weights)
        VALUES ('176b73f7-02ae-49ea-8d1d-f1214fb0bd5d', 'percentage_complete', 'Secondary raw scenario score.', NULL, NULL)
        ON CONFLICT(id) DO UPDATE SET key=EXCLUDED.key, description=EXCLUDED.description, agg_func=EXCLUDED.agg_func, agg_weights=EXCLUDED.agg_weights;

INSERT INTO scenarios
    (id, name, description, field_ids)
    VALUES ('01dc6523-a236-4da6-8ca6-934d771fc82d', '01dc6523-a236-4da6-8ca6-934d771fc82d', '01dc6523-a236-4da6-8ca6-934d771fc82d', array['19d07c00-6f34-4e32-9c5e-50a8a46f1c90', '176b73f7-02ae-49ea-8d1d-f1214fb0bd5d']::uuid[])
    ON CONFLICT(id) DO UPDATE SET name=EXCLUDED.name, description=EXCLUDED.description, field_ids=EXCLUDED.field_ids;

INSERT INTO fields
        (id, key, description, agg_func, agg_weights)
        VALUES ('19d07c00-6f34-4e32-9c5e-50a8a46f1c90', 'normalized_reward', 'Primary raw scenario score.', NULL, NULL)
        ON CONFLICT(id) DO UPDATE SET key=EXCLUDED.key, description=EXCLUDED.description, agg_func=EXCLUDED.agg_func, agg_weights=EXCLUDED.agg_weights;

INSERT INTO fields
        (id, key, description, agg_func, agg_weights)
        VALUES ('176b73f7-02ae-49ea-8d1d-f1214fb0bd5d', 'percentage_complete', 'Secondary raw scenario score.', NULL, NULL)
        ON CONFLICT(id) DO UPDATE SET key=EXCLUDED.key, description=EXCLUDED.description, agg_func=EXCLUDED.agg_func, agg_weights=EXCLUDED.agg_weights;

INSERT INTO scenarios
    (id, name, description, field_ids)
    VALUES ('2148fd5e-6141-4fd6-bcae-a93a66c81e61', '2148fd5e-6141-4fd6-bcae-a93a66c81e61', '2148fd5e-6141-4fd6-bcae-a93a66c81e61', array['19d07c00-6f34-4e32-9c5e-50a8a46f1c90', '176b73f7-02ae-49ea-8d1d-f1214fb0bd5d']::uuid[])
    ON CONFLICT(id) DO UPDATE SET name=EXCLUDED.name, description=EXCLUDED.description, field_ids=EXCLUDED.field_ids;

INSERT INTO fields
        (id, key, description, agg_func, agg_weights)
        VALUES ('19d07c00-6f34-4e32-9c5e-50a8a46f1c90', 'normalized_reward', 'Primary raw scenario score.', NULL, NULL)
        ON CONFLICT(id) DO UPDATE SET key=EXCLUDED.key, description=EXCLUDED.description, agg_func=EXCLUDED.agg_func, agg_weights=EXCLUDED.agg_weights;

INSERT INTO fields
        (id, key, description, agg_func, agg_weights)
        VALUES ('176b73f7-02ae-49ea-8d1d-f1214fb0bd5d', 'percentage_complete', 'Secondary raw scenario score.', NULL, NULL)
        ON CONFLICT(id) DO UPDATE SET key=EXCLUDED.key, description=EXCLUDED.description, agg_func=EXCLUDED.agg_func, agg_weights=EXCLUDED.agg_weights;

INSERT INTO scenarios
    (id, name, description, field_ids)
    VALUES ('f5f140c5-b999-4134-9a0a-fde6f2cf1388', 'f5f140c5-b999-4134-9a0a-fde6f2cf1388', 'f5f140c5-b999-4134-9a0a-fde6f2cf1388', array['19d07c00-6f34-4e32-9c5e-50a8a46f1c90', '176b73f7-02ae-49ea-8d1d-f1214fb0bd5d']::uuid[])
    ON CONFLICT(id) DO UPDATE SET name=EXCLUDED.name, description=EXCLUDED.description, field_ids=EXCLUDED.field_ids;

INSERT INTO fields
        (id, key, description, agg_func, agg_weights)
        VALUES ('19d07c00-6f34-4e32-9c5e-50a8a46f1c90', 'normalized_reward', 'Primary raw scenario score.', NULL, NULL)
        ON CONFLICT(id) DO UPDATE SET key=EXCLUDED.key, description=EXCLUDED.description, agg_func=EXCLUDED.agg_func, agg_weights=EXCLUDED.agg_weights;

INSERT INTO fields
        (id, key, description, agg_func, agg_weights)
        VALUES ('176b73f7-02ae-49ea-8d1d-f1214fb0bd5d', 'percentage_complete', 'Secondary raw scenario score.', NULL, NULL)
        ON CONFLICT(id) DO UPDATE SET key=EXCLUDED.key, description=EXCLUDED.description, agg_func=EXCLUDED.agg_func, agg_weights=EXCLUDED.agg_weights;

INSERT INTO scenarios
    (id, name, description, field_ids)
    VALUES ('7a0d140a-1213-407f-a6b3-5640c5c0caa7', '7a0d140a-1213-407f-a6b3-5640c5c0caa7', '7a0d140a-1213-407f-a6b3-5640c5c0caa7', array['19d07c00-6f34-4e32-9c5e-50a8a46f1c90', '176b73f7-02ae-49ea-8d1d-f1214fb0bd5d']::uuid[])
    ON CONFLICT(id) DO UPDATE SET name=EXCLUDED.name, description=EXCLUDED.description, field_ids=EXCLUDED.field_ids;

INSERT INTO fields
        (id, key, description, agg_func, agg_weights)
        VALUES ('19d07c00-6f34-4e32-9c5e-50a8a46f1c90', 'normalized_reward', 'Primary raw scenario score.', NULL, NULL)
        ON CONFLICT(id) DO UPDATE SET key=EXCLUDED.key, description=EXCLUDED.description, agg_func=EXCLUDED.agg_func, agg_weights=EXCLUDED.agg_weights;

INSERT INTO fields
        (id, key, description, agg_func, agg_weights)
        VALUES ('176b73f7-02ae-49ea-8d1d-f1214fb0bd5d', 'percentage_complete', 'Secondary raw scenario score.', NULL, NULL)
        ON CONFLICT(id) DO UPDATE SET key=EXCLUDED.key, description=EXCLUDED.description, agg_func=EXCLUDED.agg_func, agg_weights=EXCLUDED.agg_weights;

INSERT INTO scenarios
    (id, name, description, field_ids)
    VALUES ('467626bb-4abe-4451-9cd7-f7b1cc5217b9', '467626bb-4abe-4451-9cd7-f7b1cc5217b9', '467626bb-4abe-4451-9cd7-f7b1cc5217b9', array['19d07c00-6f34-4e32-9c5e-50a8a46f1c90', '176b73f7-02ae-49ea-8d1d-f1214fb0bd5d']::uuid[])
    ON CONFLICT(id) DO UPDATE SET name=EXCLUDED.name, description=EXCLUDED.description, field_ids=EXCLUDED.field_ids;

INSERT INTO fields
        (id, key, description, agg_func, agg_weights)
        VALUES ('19d07c00-6f34-4e32-9c5e-50a8a46f1c90', 'normalized_reward', 'Primary raw scenario score.', NULL, NULL)
        ON CONFLICT(id) DO UPDATE SET key=EXCLUDED.key, description=EXCLUDED.description, agg_func=EXCLUDED.agg_func, agg_weights=EXCLUDED.agg_weights;

INSERT INTO fields
        (id, key, description, agg_func, agg_weights)
        VALUES ('176b73f7-02ae-49ea-8d1d-f1214fb0bd5d', 'percentage_complete', 'Secondary raw scenario score.', NULL, NULL)
        ON CONFLICT(id) DO UPDATE SET key=EXCLUDED.key, description=EXCLUDED.description, agg_func=EXCLUDED.agg_func, agg_weights=EXCLUDED.agg_weights;

INSERT INTO scenarios
    (id, name, description, field_ids)
    VALUES ('06b6b84f-b4ad-4446-943f-40911ed46354', '06b6b84f-b4ad-4446-943f-40911ed46354', '06b6b84f-b4ad-4446-943f-40911ed46354', array['19d07c00-6f34-4e32-9c5e-50a8a46f1c90', '176b73f7-02ae-49ea-8d1d-f1214fb0bd5d']::uuid[])
    ON CONFLICT(id) DO UPDATE SET name=EXCLUDED.name, description=EXCLUDED.description, field_ids=EXCLUDED.field_ids;

INSERT INTO fields
        (id, key, description, agg_func, agg_weights)
        VALUES ('19d07c00-6f34-4e32-9c5e-50a8a46f1c90', 'normalized_reward', 'Primary raw scenario score.', NULL, NULL)
        ON CONFLICT(id) DO UPDATE SET key=EXCLUDED.key, description=EXCLUDED.description, agg_func=EXCLUDED.agg_func, agg_weights=EXCLUDED.agg_weights;

INSERT INTO fields
        (id, key, description, agg_func, agg_weights)
        VALUES ('176b73f7-02ae-49ea-8d1d-f1214fb0bd5d', 'percentage_complete', 'Secondary raw scenario score.', NULL, NULL)
        ON CONFLICT(id) DO UPDATE SET key=EXCLUDED.key, description=EXCLUDED.description, agg_func=EXCLUDED.agg_func, agg_weights=EXCLUDED.agg_weights;

INSERT INTO scenarios
    (id, name, description, field_ids)
    VALUES ('12cbd8df-b29c-49e8-98f7-12eec20439ac', '12cbd8df-b29c-49e8-98f7-12eec20439ac', '12cbd8df-b29c-49e8-98f7-12eec20439ac', array['19d07c00-6f34-4e32-9c5e-50a8a46f1c90', '176b73f7-02ae-49ea-8d1d-f1214fb0bd5d']::uuid[])
    ON CONFLICT(id) DO UPDATE SET name=EXCLUDED.name, description=EXCLUDED.description, field_ids=EXCLUDED.field_ids;

INSERT INTO fields
        (id, key, description, agg_func, agg_weights)
        VALUES ('19d07c00-6f34-4e32-9c5e-50a8a46f1c90', 'normalized_reward', 'Primary raw scenario score.', NULL, NULL)
        ON CONFLICT(id) DO UPDATE SET key=EXCLUDED.key, description=EXCLUDED.description, agg_func=EXCLUDED.agg_func, agg_weights=EXCLUDED.agg_weights;

INSERT INTO fields
        (id, key, description, agg_func, agg_weights)
        VALUES ('176b73f7-02ae-49ea-8d1d-f1214fb0bd5d', 'percentage_complete', 'Secondary raw scenario score.', NULL, NULL)
        ON CONFLICT(id) DO UPDATE SET key=EXCLUDED.key, description=EXCLUDED.description, agg_func=EXCLUDED.agg_func, agg_weights=EXCLUDED.agg_weights;

INSERT INTO scenarios
    (id, name, description, field_ids)
    VALUES ('1610eb72-fa63-4880-8a21-9e760acc1586', '1610eb72-fa63-4880-8a21-9e760acc1586', '1610eb72-fa63-4880-8a21-9e760acc1586', array['19d07c00-6f34-4e32-9c5e-50a8a46f1c90', '176b73f7-02ae-49ea-8d1d-f1214fb0bd5d']::uuid[])
    ON CONFLICT(id) DO UPDATE SET name=EXCLUDED.name, description=EXCLUDED.description, field_ids=EXCLUDED.field_ids;

INSERT INTO fields
        (id, key, description, agg_func, agg_weights)
        VALUES ('19d07c00-6f34-4e32-9c5e-50a8a46f1c90', 'normalized_reward', 'Primary raw scenario score.', NULL, NULL)
        ON CONFLICT(id) DO UPDATE SET key=EXCLUDED.key, description=EXCLUDED.description, agg_func=EXCLUDED.agg_func, agg_weights=EXCLUDED.agg_weights;

INSERT INTO fields
        (id, key, description, agg_func, agg_weights)
        VALUES ('176b73f7-02ae-49ea-8d1d-f1214fb0bd5d', 'percentage_complete', 'Secondary raw scenario score.', NULL, NULL)
        ON CONFLICT(id) DO UPDATE SET key=EXCLUDED.key, description=EXCLUDED.description, agg_func=EXCLUDED.agg_func, agg_weights=EXCLUDED.agg_weights;

INSERT INTO scenarios
    (id, name, description, field_ids)
    VALUES ('da237c4f-1eba-487a-a630-305eac8fabf3', 'da237c4f-1eba-487a-a630-305eac8fabf3', 'da237c4f-1eba-487a-a630-305eac8fabf3', array['19d07c00-6f34-4e32-9c5e-50a8a46f1c90', '176b73f7-02ae-49ea-8d1d-f1214fb0bd5d']::uuid[])
    ON CONFLICT(id) DO UPDATE SET name=EXCLUDED.name, description=EXCLUDED.description, field_ids=EXCLUDED.field_ids;

INSERT INTO fields
        (id, key, description, agg_func, agg_weights)
        VALUES ('19d07c00-6f34-4e32-9c5e-50a8a46f1c90', 'normalized_reward', 'Primary raw scenario score.', NULL, NULL)
        ON CONFLICT(id) DO UPDATE SET key=EXCLUDED.key, description=EXCLUDED.description, agg_func=EXCLUDED.agg_func, agg_weights=EXCLUDED.agg_weights;

INSERT INTO fields
        (id, key, description, agg_func, agg_weights)
        VALUES ('176b73f7-02ae-49ea-8d1d-f1214fb0bd5d', 'percentage_complete', 'Secondary raw scenario score.', NULL, NULL)
        ON CONFLICT(id) DO UPDATE SET key=EXCLUDED.key, description=EXCLUDED.description, agg_func=EXCLUDED.agg_func, agg_weights=EXCLUDED.agg_weights;

INSERT INTO tests
    (id, name, description, field_ids, scenario_ids, loop, queue)
    VALUES ('a8639b18-9568-42d2-ba9c-88d0d3c1cede', 'Test 1', 'Test 1: 7 agents,  30x30, 2', array['d1acf912-f71d-4ded-832c-e89cd272a0cc', 'd077454a-bba5-4798-90ed-4919d6f26e8b']::uuid[], array['6e2215de-4299-4374-aeb2-ca84c3b159f9', '9d6fbaa7-1ad1-46f1-aa9d-f9fcb32bdbbe', 'd1424cd1-ab8e-442a-9d45-5c6f9f5de7f7', '46bf00c6-c331-4164-a4f9-8b192364af57', 'e28f3116-3f3f-4bb9-acfc-32fce83fd721', '3c7e23be-1597-4e7a-b54c-fd1c641b43b6', '6a53431f-3ba9-4040-bfd8-49cec2afc315', 'a8f16d64-e2d6-455c-8228-8472f698f9de', 'dcc09410-ac5f-4867-b406-05fd8f93a927', 'ed31ac93-49fa-47ee-94f5-0ace5f2a4d69']::uuid[], 'CLOSED', NULL)
    ON CONFLICT(id) DO UPDATE SET name=EXCLUDED.name, description=EXCLUDED.description, field_ids=EXCLUDED.field_ids, scenario_ids=EXCLUDED.scenario_ids, loop=EXCLUDED.loop, queue=EXCLUDED.queue;

INSERT INTO fields
        (id, key, description, agg_func, agg_weights)
        VALUES ('d1acf912-f71d-4ded-832c-e89cd272a0cc', 'normalized_reward', 'Primary test score (NANSUM of corresponding scenario scores)', 'NANSUM', NULL)
        ON CONFLICT(id) DO UPDATE SET key=EXCLUDED.key, description=EXCLUDED.description, agg_func=EXCLUDED.agg_func, agg_weights=EXCLUDED.agg_weights;

INSERT INTO fields
        (id, key, description, agg_func, agg_weights)
        VALUES ('d077454a-bba5-4798-90ed-4919d6f26e8b', 'percentage_complete', 'Secondary test score (NANMEAN of corresponding scenario scores)', 'NANMEAN', NULL)
        ON CONFLICT(id) DO UPDATE SET key=EXCLUDED.key, description=EXCLUDED.description, agg_func=EXCLUDED.agg_func, agg_weights=EXCLUDED.agg_weights;

INSERT INTO scenarios
    (id, name, description, field_ids)
    VALUES ('6e2215de-4299-4374-aeb2-ca84c3b159f9', '6e2215de-4299-4374-aeb2-ca84c3b159f9', '6e2215de-4299-4374-aeb2-ca84c3b159f9', array['19d07c00-6f34-4e32-9c5e-50a8a46f1c90', '176b73f7-02ae-49ea-8d1d-f1214fb0bd5d']::uuid[])
    ON CONFLICT(id) DO UPDATE SET name=EXCLUDED.name, description=EXCLUDED.description, field_ids=EXCLUDED.field_ids;

INSERT INTO fields
        (id, key, description, agg_func, agg_weights)
        VALUES ('19d07c00-6f34-4e32-9c5e-50a8a46f1c90', 'normalized_reward', 'Primary raw scenario score.', NULL, NULL)
        ON CONFLICT(id) DO UPDATE SET key=EXCLUDED.key, description=EXCLUDED.description, agg_func=EXCLUDED.agg_func, agg_weights=EXCLUDED.agg_weights;

INSERT INTO fields
        (id, key, description, agg_func, agg_weights)
        VALUES ('176b73f7-02ae-49ea-8d1d-f1214fb0bd5d', 'percentage_complete', 'Secondary raw scenario score.', NULL, NULL)
        ON CONFLICT(id) DO UPDATE SET key=EXCLUDED.key, description=EXCLUDED.description, agg_func=EXCLUDED.agg_func, agg_weights=EXCLUDED.agg_weights;

INSERT INTO scenarios
    (id, name, description, field_ids)
    VALUES ('9d6fbaa7-1ad1-46f1-aa9d-f9fcb32bdbbe', '9d6fbaa7-1ad1-46f1-aa9d-f9fcb32bdbbe', '9d6fbaa7-1ad1-46f1-aa9d-f9fcb32bdbbe', array['19d07c00-6f34-4e32-9c5e-50a8a46f1c90', '176b73f7-02ae-49ea-8d1d-f1214fb0bd5d']::uuid[])
    ON CONFLICT(id) DO UPDATE SET name=EXCLUDED.name, description=EXCLUDED.description, field_ids=EXCLUDED.field_ids;

INSERT INTO fields
        (id, key, description, agg_func, agg_weights)
        VALUES ('19d07c00-6f34-4e32-9c5e-50a8a46f1c90', 'normalized_reward', 'Primary raw scenario score.', NULL, NULL)
        ON CONFLICT(id) DO UPDATE SET key=EXCLUDED.key, description=EXCLUDED.description, agg_func=EXCLUDED.agg_func, agg_weights=EXCLUDED.agg_weights;

INSERT INTO fields
        (id, key, description, agg_func, agg_weights)
        VALUES ('176b73f7-02ae-49ea-8d1d-f1214fb0bd5d', 'percentage_complete', 'Secondary raw scenario score.', NULL, NULL)
        ON CONFLICT(id) DO UPDATE SET key=EXCLUDED.key, description=EXCLUDED.description, agg_func=EXCLUDED.agg_func, agg_weights=EXCLUDED.agg_weights;

INSERT INTO scenarios
    (id, name, description, field_ids)
    VALUES ('d1424cd1-ab8e-442a-9d45-5c6f9f5de7f7', 'd1424cd1-ab8e-442a-9d45-5c6f9f5de7f7', 'd1424cd1-ab8e-442a-9d45-5c6f9f5de7f7', array['19d07c00-6f34-4e32-9c5e-50a8a46f1c90', '176b73f7-02ae-49ea-8d1d-f1214fb0bd5d']::uuid[])
    ON CONFLICT(id) DO UPDATE SET name=EXCLUDED.name, description=EXCLUDED.description, field_ids=EXCLUDED.field_ids;

INSERT INTO fields
        (id, key, description, agg_func, agg_weights)
        VALUES ('19d07c00-6f34-4e32-9c5e-50a8a46f1c90', 'normalized_reward', 'Primary raw scenario score.', NULL, NULL)
        ON CONFLICT(id) DO UPDATE SET key=EXCLUDED.key, description=EXCLUDED.description, agg_func=EXCLUDED.agg_func, agg_weights=EXCLUDED.agg_weights;

INSERT INTO fields
        (id, key, description, agg_func, agg_weights)
        VALUES ('176b73f7-02ae-49ea-8d1d-f1214fb0bd5d', 'percentage_complete', 'Secondary raw scenario score.', NULL, NULL)
        ON CONFLICT(id) DO UPDATE SET key=EXCLUDED.key, description=EXCLUDED.description, agg_func=EXCLUDED.agg_func, agg_weights=EXCLUDED.agg_weights;

INSERT INTO scenarios
    (id, name, description, field_ids)
    VALUES ('46bf00c6-c331-4164-a4f9-8b192364af57', '46bf00c6-c331-4164-a4f9-8b192364af57', '46bf00c6-c331-4164-a4f9-8b192364af57', array['19d07c00-6f34-4e32-9c5e-50a8a46f1c90', '176b73f7-02ae-49ea-8d1d-f1214fb0bd5d']::uuid[])
    ON CONFLICT(id) DO UPDATE SET name=EXCLUDED.name, description=EXCLUDED.description, field_ids=EXCLUDED.field_ids;

INSERT INTO fields
        (id, key, description, agg_func, agg_weights)
        VALUES ('19d07c00-6f34-4e32-9c5e-50a8a46f1c90', 'normalized_reward', 'Primary raw scenario score.', NULL, NULL)
        ON CONFLICT(id) DO UPDATE SET key=EXCLUDED.key, description=EXCLUDED.description, agg_func=EXCLUDED.agg_func, agg_weights=EXCLUDED.agg_weights;

INSERT INTO fields
        (id, key, description, agg_func, agg_weights)
        VALUES ('176b73f7-02ae-49ea-8d1d-f1214fb0bd5d', 'percentage_complete', 'Secondary raw scenario score.', NULL, NULL)
        ON CONFLICT(id) DO UPDATE SET key=EXCLUDED.key, description=EXCLUDED.description, agg_func=EXCLUDED.agg_func, agg_weights=EXCLUDED.agg_weights;

INSERT INTO scenarios
    (id, name, description, field_ids)
    VALUES ('e28f3116-3f3f-4bb9-acfc-32fce83fd721', 'e28f3116-3f3f-4bb9-acfc-32fce83fd721', 'e28f3116-3f3f-4bb9-acfc-32fce83fd721', array['19d07c00-6f34-4e32-9c5e-50a8a46f1c90', '176b73f7-02ae-49ea-8d1d-f1214fb0bd5d']::uuid[])
    ON CONFLICT(id) DO UPDATE SET name=EXCLUDED.name, description=EXCLUDED.description, field_ids=EXCLUDED.field_ids;

INSERT INTO fields
        (id, key, description, agg_func, agg_weights)
        VALUES ('19d07c00-6f34-4e32-9c5e-50a8a46f1c90', 'normalized_reward', 'Primary raw scenario score.', NULL, NULL)
        ON CONFLICT(id) DO UPDATE SET key=EXCLUDED.key, description=EXCLUDED.description, agg_func=EXCLUDED.agg_func, agg_weights=EXCLUDED.agg_weights;

INSERT INTO fields
        (id, key, description, agg_func, agg_weights)
        VALUES ('176b73f7-02ae-49ea-8d1d-f1214fb0bd5d', 'percentage_complete', 'Secondary raw scenario score.', NULL, NULL)
        ON CONFLICT(id) DO UPDATE SET key=EXCLUDED.key, description=EXCLUDED.description, agg_func=EXCLUDED.agg_func, agg_weights=EXCLUDED.agg_weights;

INSERT INTO scenarios
    (id, name, description, field_ids)
    VALUES ('3c7e23be-1597-4e7a-b54c-fd1c641b43b6', '3c7e23be-1597-4e7a-b54c-fd1c641b43b6', '3c7e23be-1597-4e7a-b54c-fd1c641b43b6', array['19d07c00-6f34-4e32-9c5e-50a8a46f1c90', '176b73f7-02ae-49ea-8d1d-f1214fb0bd5d']::uuid[])
    ON CONFLICT(id) DO UPDATE SET name=EXCLUDED.name, description=EXCLUDED.description, field_ids=EXCLUDED.field_ids;

INSERT INTO fields
        (id, key, description, agg_func, agg_weights)
        VALUES ('19d07c00-6f34-4e32-9c5e-50a8a46f1c90', 'normalized_reward', 'Primary raw scenario score.', NULL, NULL)
        ON CONFLICT(id) DO UPDATE SET key=EXCLUDED.key, description=EXCLUDED.description, agg_func=EXCLUDED.agg_func, agg_weights=EXCLUDED.agg_weights;

INSERT INTO fields
        (id, key, description, agg_func, agg_weights)
        VALUES ('176b73f7-02ae-49ea-8d1d-f1214fb0bd5d', 'percentage_complete', 'Secondary raw scenario score.', NULL, NULL)
        ON CONFLICT(id) DO UPDATE SET key=EXCLUDED.key, description=EXCLUDED.description, agg_func=EXCLUDED.agg_func, agg_weights=EXCLUDED.agg_weights;

INSERT INTO scenarios
    (id, name, description, field_ids)
    VALUES ('6a53431f-3ba9-4040-bfd8-49cec2afc315', '6a53431f-3ba9-4040-bfd8-49cec2afc315', '6a53431f-3ba9-4040-bfd8-49cec2afc315', array['19d07c00-6f34-4e32-9c5e-50a8a46f1c90', '176b73f7-02ae-49ea-8d1d-f1214fb0bd5d']::uuid[])
    ON CONFLICT(id) DO UPDATE SET name=EXCLUDED.name, description=EXCLUDED.description, field_ids=EXCLUDED.field_ids;

INSERT INTO fields
        (id, key, description, agg_func, agg_weights)
        VALUES ('19d07c00-6f34-4e32-9c5e-50a8a46f1c90', 'normalized_reward', 'Primary raw scenario score.', NULL, NULL)
        ON CONFLICT(id) DO UPDATE SET key=EXCLUDED.key, description=EXCLUDED.description, agg_func=EXCLUDED.agg_func, agg_weights=EXCLUDED.agg_weights;

INSERT INTO fields
        (id, key, description, agg_func, agg_weights)
        VALUES ('176b73f7-02ae-49ea-8d1d-f1214fb0bd5d', 'percentage_complete', 'Secondary raw scenario score.', NULL, NULL)
        ON CONFLICT(id) DO UPDATE SET key=EXCLUDED.key, description=EXCLUDED.description, agg_func=EXCLUDED.agg_func, agg_weights=EXCLUDED.agg_weights;

INSERT INTO scenarios
    (id, name, description, field_ids)
    VALUES ('a8f16d64-e2d6-455c-8228-8472f698f9de', 'a8f16d64-e2d6-455c-8228-8472f698f9de', 'a8f16d64-e2d6-455c-8228-8472f698f9de', array['19d07c00-6f34-4e32-9c5e-50a8a46f1c90', '176b73f7-02ae-49ea-8d1d-f1214fb0bd5d']::uuid[])
    ON CONFLICT(id) DO UPDATE SET name=EXCLUDED.name, description=EXCLUDED.description, field_ids=EXCLUDED.field_ids;

INSERT INTO fields
        (id, key, description, agg_func, agg_weights)
        VALUES ('19d07c00-6f34-4e32-9c5e-50a8a46f1c90', 'normalized_reward', 'Primary raw scenario score.', NULL, NULL)
        ON CONFLICT(id) DO UPDATE SET key=EXCLUDED.key, description=EXCLUDED.description, agg_func=EXCLUDED.agg_func, agg_weights=EXCLUDED.agg_weights;

INSERT INTO fields
        (id, key, description, agg_func, agg_weights)
        VALUES ('176b73f7-02ae-49ea-8d1d-f1214fb0bd5d', 'percentage_complete', 'Secondary raw scenario score.', NULL, NULL)
        ON CONFLICT(id) DO UPDATE SET key=EXCLUDED.key, description=EXCLUDED.description, agg_func=EXCLUDED.agg_func, agg_weights=EXCLUDED.agg_weights;

INSERT INTO scenarios
    (id, name, description, field_ids)
    VALUES ('dcc09410-ac5f-4867-b406-05fd8f93a927', 'dcc09410-ac5f-4867-b406-05fd8f93a927', 'dcc09410-ac5f-4867-b406-05fd8f93a927', array['19d07c00-6f34-4e32-9c5e-50a8a46f1c90', '176b73f7-02ae-49ea-8d1d-f1214fb0bd5d']::uuid[])
    ON CONFLICT(id) DO UPDATE SET name=EXCLUDED.name, description=EXCLUDED.description, field_ids=EXCLUDED.field_ids;

INSERT INTO fields
        (id, key, description, agg_func, agg_weights)
        VALUES ('19d07c00-6f34-4e32-9c5e-50a8a46f1c90', 'normalized_reward', 'Primary raw scenario score.', NULL, NULL)
        ON CONFLICT(id) DO UPDATE SET key=EXCLUDED.key, description=EXCLUDED.description, agg_func=EXCLUDED.agg_func, agg_weights=EXCLUDED.agg_weights;

INSERT INTO fields
        (id, key, description, agg_func, agg_weights)
        VALUES ('176b73f7-02ae-49ea-8d1d-f1214fb0bd5d', 'percentage_complete', 'Secondary raw scenario score.', NULL, NULL)
        ON CONFLICT(id) DO UPDATE SET key=EXCLUDED.key, description=EXCLUDED.description, agg_func=EXCLUDED.agg_func, agg_weights=EXCLUDED.agg_weights;

INSERT INTO scenarios
    (id, name, description, field_ids)
    VALUES ('ed31ac93-49fa-47ee-94f5-0ace5f2a4d69', 'ed31ac93-49fa-47ee-94f5-0ace5f2a4d69', 'ed31ac93-49fa-47ee-94f5-0ace5f2a4d69', array['19d07c00-6f34-4e32-9c5e-50a8a46f1c90', '176b73f7-02ae-49ea-8d1d-f1214fb0bd5d']::uuid[])
    ON CONFLICT(id) DO UPDATE SET name=EXCLUDED.name, description=EXCLUDED.description, field_ids=EXCLUDED.field_ids;

INSERT INTO fields
        (id, key, description, agg_func, agg_weights)
        VALUES ('19d07c00-6f34-4e32-9c5e-50a8a46f1c90', 'normalized_reward', 'Primary raw scenario score.', NULL, NULL)
        ON CONFLICT(id) DO UPDATE SET key=EXCLUDED.key, description=EXCLUDED.description, agg_func=EXCLUDED.agg_func, agg_weights=EXCLUDED.agg_weights;

INSERT INTO fields
        (id, key, description, agg_func, agg_weights)
        VALUES ('176b73f7-02ae-49ea-8d1d-f1214fb0bd5d', 'percentage_complete', 'Secondary raw scenario score.', NULL, NULL)
        ON CONFLICT(id) DO UPDATE SET key=EXCLUDED.key, description=EXCLUDED.description, agg_func=EXCLUDED.agg_func, agg_weights=EXCLUDED.agg_weights;

INSERT INTO tests
    (id, name, description, field_ids, scenario_ids, loop, queue)
    VALUES ('254de248-0210-4bf9-a349-8f769c5280e2', 'Test 2', 'Test 2: 20 agents,  30x30, 3', array['d1acf912-f71d-4ded-832c-e89cd272a0cc', 'd077454a-bba5-4798-90ed-4919d6f26e8b']::uuid[], array['be14b4e1-2d73-4fca-8575-0934ef8694b3', '3b053c18-660a-4a59-94c9-7fde88da9c46', '46937ddf-e489-4544-bb44-23ac1b6ade0a', '9b20e819-8eb9-47ce-bcf7-ca468d31b631', '9a92f7b9-28d3-40ff-8669-45ddb83dea08', 'be689371-2b8b-42b6-9a27-c19a82651e27', '3ff7e013-3ab7-493c-8a69-1abab2813a9c', '82d014b2-1f71-4f4c-9545-5c73ac27f531', '1b1e5bc3-b424-40fe-a143-5adb7104b2c3', 'bf67d71b-b3ce-45f3-aed7-0b36a9b6a576']::uuid[], 'CLOSED', NULL)
    ON CONFLICT(id) DO UPDATE SET name=EXCLUDED.name, description=EXCLUDED.description, field_ids=EXCLUDED.field_ids, scenario_ids=EXCLUDED.scenario_ids, loop=EXCLUDED.loop, queue=EXCLUDED.queue;

INSERT INTO fields
        (id, key, description, agg_func, agg_weights)
        VALUES ('d1acf912-f71d-4ded-832c-e89cd272a0cc', 'normalized_reward', 'Primary test score (NANSUM of corresponding scenario scores)', 'NANSUM', NULL)
        ON CONFLICT(id) DO UPDATE SET key=EXCLUDED.key, description=EXCLUDED.description, agg_func=EXCLUDED.agg_func, agg_weights=EXCLUDED.agg_weights;

INSERT INTO fields
        (id, key, description, agg_func, agg_weights)
        VALUES ('d077454a-bba5-4798-90ed-4919d6f26e8b', 'percentage_complete', 'Secondary test score (NANMEAN of corresponding scenario scores)', 'NANMEAN', NULL)
        ON CONFLICT(id) DO UPDATE SET key=EXCLUDED.key, description=EXCLUDED.description, agg_func=EXCLUDED.agg_func, agg_weights=EXCLUDED.agg_weights;

INSERT INTO scenarios
    (id, name, description, field_ids)
    VALUES ('be14b4e1-2d73-4fca-8575-0934ef8694b3', 'be14b4e1-2d73-4fca-8575-0934ef8694b3', 'be14b4e1-2d73-4fca-8575-0934ef8694b3', array['19d07c00-6f34-4e32-9c5e-50a8a46f1c90', '176b73f7-02ae-49ea-8d1d-f1214fb0bd5d']::uuid[])
    ON CONFLICT(id) DO UPDATE SET name=EXCLUDED.name, description=EXCLUDED.description, field_ids=EXCLUDED.field_ids;

INSERT INTO fields
        (id, key, description, agg_func, agg_weights)
        VALUES ('19d07c00-6f34-4e32-9c5e-50a8a46f1c90', 'normalized_reward', 'Primary raw scenario score.', NULL, NULL)
        ON CONFLICT(id) DO UPDATE SET key=EXCLUDED.key, description=EXCLUDED.description, agg_func=EXCLUDED.agg_func, agg_weights=EXCLUDED.agg_weights;

INSERT INTO fields
        (id, key, description, agg_func, agg_weights)
        VALUES ('176b73f7-02ae-49ea-8d1d-f1214fb0bd5d', 'percentage_complete', 'Secondary raw scenario score.', NULL, NULL)
        ON CONFLICT(id) DO UPDATE SET key=EXCLUDED.key, description=EXCLUDED.description, agg_func=EXCLUDED.agg_func, agg_weights=EXCLUDED.agg_weights;

INSERT INTO scenarios
    (id, name, description, field_ids)
    VALUES ('3b053c18-660a-4a59-94c9-7fde88da9c46', '3b053c18-660a-4a59-94c9-7fde88da9c46', '3b053c18-660a-4a59-94c9-7fde88da9c46', array['19d07c00-6f34-4e32-9c5e-50a8a46f1c90', '176b73f7-02ae-49ea-8d1d-f1214fb0bd5d']::uuid[])
    ON CONFLICT(id) DO UPDATE SET name=EXCLUDED.name, description=EXCLUDED.description, field_ids=EXCLUDED.field_ids;

INSERT INTO fields
        (id, key, description, agg_func, agg_weights)
        VALUES ('19d07c00-6f34-4e32-9c5e-50a8a46f1c90', 'normalized_reward', 'Primary raw scenario score.', NULL, NULL)
        ON CONFLICT(id) DO UPDATE SET key=EXCLUDED.key, description=EXCLUDED.description, agg_func=EXCLUDED.agg_func, agg_weights=EXCLUDED.agg_weights;

INSERT INTO fields
        (id, key, description, agg_func, agg_weights)
        VALUES ('176b73f7-02ae-49ea-8d1d-f1214fb0bd5d', 'percentage_complete', 'Secondary raw scenario score.', NULL, NULL)
        ON CONFLICT(id) DO UPDATE SET key=EXCLUDED.key, description=EXCLUDED.description, agg_func=EXCLUDED.agg_func, agg_weights=EXCLUDED.agg_weights;

INSERT INTO scenarios
    (id, name, description, field_ids)
    VALUES ('46937ddf-e489-4544-bb44-23ac1b6ade0a', '46937ddf-e489-4544-bb44-23ac1b6ade0a', '46937ddf-e489-4544-bb44-23ac1b6ade0a', array['19d07c00-6f34-4e32-9c5e-50a8a46f1c90', '176b73f7-02ae-49ea-8d1d-f1214fb0bd5d']::uuid[])
    ON CONFLICT(id) DO UPDATE SET name=EXCLUDED.name, description=EXCLUDED.description, field_ids=EXCLUDED.field_ids;

INSERT INTO fields
        (id, key, description, agg_func, agg_weights)
        VALUES ('19d07c00-6f34-4e32-9c5e-50a8a46f1c90', 'normalized_reward', 'Primary raw scenario score.', NULL, NULL)
        ON CONFLICT(id) DO UPDATE SET key=EXCLUDED.key, description=EXCLUDED.description, agg_func=EXCLUDED.agg_func, agg_weights=EXCLUDED.agg_weights;

INSERT INTO fields
        (id, key, description, agg_func, agg_weights)
        VALUES ('176b73f7-02ae-49ea-8d1d-f1214fb0bd5d', 'percentage_complete', 'Secondary raw scenario score.', NULL, NULL)
        ON CONFLICT(id) DO UPDATE SET key=EXCLUDED.key, description=EXCLUDED.description, agg_func=EXCLUDED.agg_func, agg_weights=EXCLUDED.agg_weights;

INSERT INTO scenarios
    (id, name, description, field_ids)
    VALUES ('9b20e819-8eb9-47ce-bcf7-ca468d31b631', '9b20e819-8eb9-47ce-bcf7-ca468d31b631', '9b20e819-8eb9-47ce-bcf7-ca468d31b631', array['19d07c00-6f34-4e32-9c5e-50a8a46f1c90', '176b73f7-02ae-49ea-8d1d-f1214fb0bd5d']::uuid[])
    ON CONFLICT(id) DO UPDATE SET name=EXCLUDED.name, description=EXCLUDED.description, field_ids=EXCLUDED.field_ids;

INSERT INTO fields
        (id, key, description, agg_func, agg_weights)
        VALUES ('19d07c00-6f34-4e32-9c5e-50a8a46f1c90', 'normalized_reward', 'Primary raw scenario score.', NULL, NULL)
        ON CONFLICT(id) DO UPDATE SET key=EXCLUDED.key, description=EXCLUDED.description, agg_func=EXCLUDED.agg_func, agg_weights=EXCLUDED.agg_weights;

INSERT INTO fields
        (id, key, description, agg_func, agg_weights)
        VALUES ('176b73f7-02ae-49ea-8d1d-f1214fb0bd5d', 'percentage_complete', 'Secondary raw scenario score.', NULL, NULL)
        ON CONFLICT(id) DO UPDATE SET key=EXCLUDED.key, description=EXCLUDED.description, agg_func=EXCLUDED.agg_func, agg_weights=EXCLUDED.agg_weights;

INSERT INTO scenarios
    (id, name, description, field_ids)
    VALUES ('9a92f7b9-28d3-40ff-8669-45ddb83dea08', '9a92f7b9-28d3-40ff-8669-45ddb83dea08', '9a92f7b9-28d3-40ff-8669-45ddb83dea08', array['19d07c00-6f34-4e32-9c5e-50a8a46f1c90', '176b73f7-02ae-49ea-8d1d-f1214fb0bd5d']::uuid[])
    ON CONFLICT(id) DO UPDATE SET name=EXCLUDED.name, description=EXCLUDED.description, field_ids=EXCLUDED.field_ids;

INSERT INTO fields
        (id, key, description, agg_func, agg_weights)
        VALUES ('19d07c00-6f34-4e32-9c5e-50a8a46f1c90', 'normalized_reward', 'Primary raw scenario score.', NULL, NULL)
        ON CONFLICT(id) DO UPDATE SET key=EXCLUDED.key, description=EXCLUDED.description, agg_func=EXCLUDED.agg_func, agg_weights=EXCLUDED.agg_weights;

INSERT INTO fields
        (id, key, description, agg_func, agg_weights)
        VALUES ('176b73f7-02ae-49ea-8d1d-f1214fb0bd5d', 'percentage_complete', 'Secondary raw scenario score.', NULL, NULL)
        ON CONFLICT(id) DO UPDATE SET key=EXCLUDED.key, description=EXCLUDED.description, agg_func=EXCLUDED.agg_func, agg_weights=EXCLUDED.agg_weights;

INSERT INTO scenarios
    (id, name, description, field_ids)
    VALUES ('be689371-2b8b-42b6-9a27-c19a82651e27', 'be689371-2b8b-42b6-9a27-c19a82651e27', 'be689371-2b8b-42b6-9a27-c19a82651e27', array['19d07c00-6f34-4e32-9c5e-50a8a46f1c90', '176b73f7-02ae-49ea-8d1d-f1214fb0bd5d']::uuid[])
    ON CONFLICT(id) DO UPDATE SET name=EXCLUDED.name, description=EXCLUDED.description, field_ids=EXCLUDED.field_ids;

INSERT INTO fields
        (id, key, description, agg_func, agg_weights)
        VALUES ('19d07c00-6f34-4e32-9c5e-50a8a46f1c90', 'normalized_reward', 'Primary raw scenario score.', NULL, NULL)
        ON CONFLICT(id) DO UPDATE SET key=EXCLUDED.key, description=EXCLUDED.description, agg_func=EXCLUDED.agg_func, agg_weights=EXCLUDED.agg_weights;

INSERT INTO fields
        (id, key, description, agg_func, agg_weights)
        VALUES ('176b73f7-02ae-49ea-8d1d-f1214fb0bd5d', 'percentage_complete', 'Secondary raw scenario score.', NULL, NULL)
        ON CONFLICT(id) DO UPDATE SET key=EXCLUDED.key, description=EXCLUDED.description, agg_func=EXCLUDED.agg_func, agg_weights=EXCLUDED.agg_weights;

INSERT INTO scenarios
    (id, name, description, field_ids)
    VALUES ('3ff7e013-3ab7-493c-8a69-1abab2813a9c', '3ff7e013-3ab7-493c-8a69-1abab2813a9c', '3ff7e013-3ab7-493c-8a69-1abab2813a9c', array['19d07c00-6f34-4e32-9c5e-50a8a46f1c90', '176b73f7-02ae-49ea-8d1d-f1214fb0bd5d']::uuid[])
    ON CONFLICT(id) DO UPDATE SET name=EXCLUDED.name, description=EXCLUDED.description, field_ids=EXCLUDED.field_ids;

INSERT INTO fields
        (id, key, description, agg_func, agg_weights)
        VALUES ('19d07c00-6f34-4e32-9c5e-50a8a46f1c90', 'normalized_reward', 'Primary raw scenario score.', NULL, NULL)
        ON CONFLICT(id) DO UPDATE SET key=EXCLUDED.key, description=EXCLUDED.description, agg_func=EXCLUDED.agg_func, agg_weights=EXCLUDED.agg_weights;

INSERT INTO fields
        (id, key, description, agg_func, agg_weights)
        VALUES ('176b73f7-02ae-49ea-8d1d-f1214fb0bd5d', 'percentage_complete', 'Secondary raw scenario score.', NULL, NULL)
        ON CONFLICT(id) DO UPDATE SET key=EXCLUDED.key, description=EXCLUDED.description, agg_func=EXCLUDED.agg_func, agg_weights=EXCLUDED.agg_weights;

INSERT INTO scenarios
    (id, name, description, field_ids)
    VALUES ('82d014b2-1f71-4f4c-9545-5c73ac27f531', '82d014b2-1f71-4f4c-9545-5c73ac27f531', '82d014b2-1f71-4f4c-9545-5c73ac27f531', array['19d07c00-6f34-4e32-9c5e-50a8a46f1c90', '176b73f7-02ae-49ea-8d1d-f1214fb0bd5d']::uuid[])
    ON CONFLICT(id) DO UPDATE SET name=EXCLUDED.name, description=EXCLUDED.description, field_ids=EXCLUDED.field_ids;

INSERT INTO fields
        (id, key, description, agg_func, agg_weights)
        VALUES ('19d07c00-6f34-4e32-9c5e-50a8a46f1c90', 'normalized_reward', 'Primary raw scenario score.', NULL, NULL)
        ON CONFLICT(id) DO UPDATE SET key=EXCLUDED.key, description=EXCLUDED.description, agg_func=EXCLUDED.agg_func, agg_weights=EXCLUDED.agg_weights;

INSERT INTO fields
        (id, key, description, agg_func, agg_weights)
        VALUES ('176b73f7-02ae-49ea-8d1d-f1214fb0bd5d', 'percentage_complete', 'Secondary raw scenario score.', NULL, NULL)
        ON CONFLICT(id) DO UPDATE SET key=EXCLUDED.key, description=EXCLUDED.description, agg_func=EXCLUDED.agg_func, agg_weights=EXCLUDED.agg_weights;

INSERT INTO scenarios
    (id, name, description, field_ids)
    VALUES ('1b1e5bc3-b424-40fe-a143-5adb7104b2c3', '1b1e5bc3-b424-40fe-a143-5adb7104b2c3', '1b1e5bc3-b424-40fe-a143-5adb7104b2c3', array['19d07c00-6f34-4e32-9c5e-50a8a46f1c90', '176b73f7-02ae-49ea-8d1d-f1214fb0bd5d']::uuid[])
    ON CONFLICT(id) DO UPDATE SET name=EXCLUDED.name, description=EXCLUDED.description, field_ids=EXCLUDED.field_ids;

INSERT INTO fields
        (id, key, description, agg_func, agg_weights)
        VALUES ('19d07c00-6f34-4e32-9c5e-50a8a46f1c90', 'normalized_reward', 'Primary raw scenario score.', NULL, NULL)
        ON CONFLICT(id) DO UPDATE SET key=EXCLUDED.key, description=EXCLUDED.description, agg_func=EXCLUDED.agg_func, agg_weights=EXCLUDED.agg_weights;

INSERT INTO fields
        (id, key, description, agg_func, agg_weights)
        VALUES ('176b73f7-02ae-49ea-8d1d-f1214fb0bd5d', 'percentage_complete', 'Secondary raw scenario score.', NULL, NULL)
        ON CONFLICT(id) DO UPDATE SET key=EXCLUDED.key, description=EXCLUDED.description, agg_func=EXCLUDED.agg_func, agg_weights=EXCLUDED.agg_weights;

INSERT INTO scenarios
    (id, name, description, field_ids)
    VALUES ('bf67d71b-b3ce-45f3-aed7-0b36a9b6a576', 'bf67d71b-b3ce-45f3-aed7-0b36a9b6a576', 'bf67d71b-b3ce-45f3-aed7-0b36a9b6a576', array['19d07c00-6f34-4e32-9c5e-50a8a46f1c90', '176b73f7-02ae-49ea-8d1d-f1214fb0bd5d']::uuid[])
    ON CONFLICT(id) DO UPDATE SET name=EXCLUDED.name, description=EXCLUDED.description, field_ids=EXCLUDED.field_ids;

INSERT INTO fields
        (id, key, description, agg_func, agg_weights)
        VALUES ('19d07c00-6f34-4e32-9c5e-50a8a46f1c90', 'normalized_reward', 'Primary raw scenario score.', NULL, NULL)
        ON CONFLICT(id) DO UPDATE SET key=EXCLUDED.key, description=EXCLUDED.description, agg_func=EXCLUDED.agg_func, agg_weights=EXCLUDED.agg_weights;

INSERT INTO fields
        (id, key, description, agg_func, agg_weights)
        VALUES ('176b73f7-02ae-49ea-8d1d-f1214fb0bd5d', 'percentage_complete', 'Secondary raw scenario score.', NULL, NULL)
        ON CONFLICT(id) DO UPDATE SET key=EXCLUDED.key, description=EXCLUDED.description, agg_func=EXCLUDED.agg_func, agg_weights=EXCLUDED.agg_weights;

INSERT INTO tests
    (id, name, description, field_ids, scenario_ids, loop, queue)
    VALUES ('e3bf5a0f-4d6c-43be-9352-c630938b871c', 'Test 3', 'Test 3: 50 agents,  35x30, 3', array['d1acf912-f71d-4ded-832c-e89cd272a0cc', 'd077454a-bba5-4798-90ed-4919d6f26e8b']::uuid[], array['f63e8714-b6a6-4aa4-9b5e-efe411781d8e', 'ce96cbd9-a84f-4a8c-b9aa-52d9f3743f7c', 'a6616e64-cd47-420c-bfa4-1815f08faae6', '0ada9a98-2e98-4579-8654-577234ddacc7', '6f6d5a01-0d22-429f-a791-e1d879aa2cad', 'c08c1a81-d0e1-4230-b653-d5710775a7f2', '31e7455b-9018-4034-8a8d-8160439ed299', '809111d2-dbbb-4746-a410-2962b2765568', '4da5166a-393f-45d8-811c-2ed5f5047dd1', '5284341e-01b7-4565-a5db-8372803aa749']::uuid[], 'CLOSED', NULL)
    ON CONFLICT(id) DO UPDATE SET name=EXCLUDED.name, description=EXCLUDED.description, field_ids=EXCLUDED.field_ids, scenario_ids=EXCLUDED.scenario_ids, loop=EXCLUDED.loop, queue=EXCLUDED.queue;

INSERT INTO fields
        (id, key, description, agg_func, agg_weights)
        VALUES ('d1acf912-f71d-4ded-832c-e89cd272a0cc', 'normalized_reward', 'Primary test score (NANSUM of corresponding scenario scores)', 'NANSUM', NULL)
        ON CONFLICT(id) DO UPDATE SET key=EXCLUDED.key, description=EXCLUDED.description, agg_func=EXCLUDED.agg_func, agg_weights=EXCLUDED.agg_weights;

INSERT INTO fields
        (id, key, description, agg_func, agg_weights)
        VALUES ('d077454a-bba5-4798-90ed-4919d6f26e8b', 'percentage_complete', 'Secondary test score (NANMEAN of corresponding scenario scores)', 'NANMEAN', NULL)
        ON CONFLICT(id) DO UPDATE SET key=EXCLUDED.key, description=EXCLUDED.description, agg_func=EXCLUDED.agg_func, agg_weights=EXCLUDED.agg_weights;

INSERT INTO scenarios
    (id, name, description, field_ids)
    VALUES ('f63e8714-b6a6-4aa4-9b5e-efe411781d8e', 'f63e8714-b6a6-4aa4-9b5e-efe411781d8e', 'f63e8714-b6a6-4aa4-9b5e-efe411781d8e', array['19d07c00-6f34-4e32-9c5e-50a8a46f1c90', '176b73f7-02ae-49ea-8d1d-f1214fb0bd5d']::uuid[])
    ON CONFLICT(id) DO UPDATE SET name=EXCLUDED.name, description=EXCLUDED.description, field_ids=EXCLUDED.field_ids;

INSERT INTO fields
        (id, key, description, agg_func, agg_weights)
        VALUES ('19d07c00-6f34-4e32-9c5e-50a8a46f1c90', 'normalized_reward', 'Primary raw scenario score.', NULL, NULL)
        ON CONFLICT(id) DO UPDATE SET key=EXCLUDED.key, description=EXCLUDED.description, agg_func=EXCLUDED.agg_func, agg_weights=EXCLUDED.agg_weights;

INSERT INTO fields
        (id, key, description, agg_func, agg_weights)
        VALUES ('176b73f7-02ae-49ea-8d1d-f1214fb0bd5d', 'percentage_complete', 'Secondary raw scenario score.', NULL, NULL)
        ON CONFLICT(id) DO UPDATE SET key=EXCLUDED.key, description=EXCLUDED.description, agg_func=EXCLUDED.agg_func, agg_weights=EXCLUDED.agg_weights;

INSERT INTO scenarios
    (id, name, description, field_ids)
    VALUES ('ce96cbd9-a84f-4a8c-b9aa-52d9f3743f7c', 'ce96cbd9-a84f-4a8c-b9aa-52d9f3743f7c', 'ce96cbd9-a84f-4a8c-b9aa-52d9f3743f7c', array['19d07c00-6f34-4e32-9c5e-50a8a46f1c90', '176b73f7-02ae-49ea-8d1d-f1214fb0bd5d']::uuid[])
    ON CONFLICT(id) DO UPDATE SET name=EXCLUDED.name, description=EXCLUDED.description, field_ids=EXCLUDED.field_ids;

INSERT INTO fields
        (id, key, description, agg_func, agg_weights)
        VALUES ('19d07c00-6f34-4e32-9c5e-50a8a46f1c90', 'normalized_reward', 'Primary raw scenario score.', NULL, NULL)
        ON CONFLICT(id) DO UPDATE SET key=EXCLUDED.key, description=EXCLUDED.description, agg_func=EXCLUDED.agg_func, agg_weights=EXCLUDED.agg_weights;

INSERT INTO fields
        (id, key, description, agg_func, agg_weights)
        VALUES ('176b73f7-02ae-49ea-8d1d-f1214fb0bd5d', 'percentage_complete', 'Secondary raw scenario score.', NULL, NULL)
        ON CONFLICT(id) DO UPDATE SET key=EXCLUDED.key, description=EXCLUDED.description, agg_func=EXCLUDED.agg_func, agg_weights=EXCLUDED.agg_weights;

INSERT INTO scenarios
    (id, name, description, field_ids)
    VALUES ('a6616e64-cd47-420c-bfa4-1815f08faae6', 'a6616e64-cd47-420c-bfa4-1815f08faae6', 'a6616e64-cd47-420c-bfa4-1815f08faae6', array['19d07c00-6f34-4e32-9c5e-50a8a46f1c90', '176b73f7-02ae-49ea-8d1d-f1214fb0bd5d']::uuid[])
    ON CONFLICT(id) DO UPDATE SET name=EXCLUDED.name, description=EXCLUDED.description, field_ids=EXCLUDED.field_ids;

INSERT INTO fields
        (id, key, description, agg_func, agg_weights)
        VALUES ('19d07c00-6f34-4e32-9c5e-50a8a46f1c90', 'normalized_reward', 'Primary raw scenario score.', NULL, NULL)
        ON CONFLICT(id) DO UPDATE SET key=EXCLUDED.key, description=EXCLUDED.description, agg_func=EXCLUDED.agg_func, agg_weights=EXCLUDED.agg_weights;

INSERT INTO fields
        (id, key, description, agg_func, agg_weights)
        VALUES ('176b73f7-02ae-49ea-8d1d-f1214fb0bd5d', 'percentage_complete', 'Secondary raw scenario score.', NULL, NULL)
        ON CONFLICT(id) DO UPDATE SET key=EXCLUDED.key, description=EXCLUDED.description, agg_func=EXCLUDED.agg_func, agg_weights=EXCLUDED.agg_weights;

INSERT INTO scenarios
    (id, name, description, field_ids)
    VALUES ('0ada9a98-2e98-4579-8654-577234ddacc7', '0ada9a98-2e98-4579-8654-577234ddacc7', '0ada9a98-2e98-4579-8654-577234ddacc7', array['19d07c00-6f34-4e32-9c5e-50a8a46f1c90', '176b73f7-02ae-49ea-8d1d-f1214fb0bd5d']::uuid[])
    ON CONFLICT(id) DO UPDATE SET name=EXCLUDED.name, description=EXCLUDED.description, field_ids=EXCLUDED.field_ids;

INSERT INTO fields
        (id, key, description, agg_func, agg_weights)
        VALUES ('19d07c00-6f34-4e32-9c5e-50a8a46f1c90', 'normalized_reward', 'Primary raw scenario score.', NULL, NULL)
        ON CONFLICT(id) DO UPDATE SET key=EXCLUDED.key, description=EXCLUDED.description, agg_func=EXCLUDED.agg_func, agg_weights=EXCLUDED.agg_weights;

INSERT INTO fields
        (id, key, description, agg_func, agg_weights)
        VALUES ('176b73f7-02ae-49ea-8d1d-f1214fb0bd5d', 'percentage_complete', 'Secondary raw scenario score.', NULL, NULL)
        ON CONFLICT(id) DO UPDATE SET key=EXCLUDED.key, description=EXCLUDED.description, agg_func=EXCLUDED.agg_func, agg_weights=EXCLUDED.agg_weights;

INSERT INTO scenarios
    (id, name, description, field_ids)
    VALUES ('6f6d5a01-0d22-429f-a791-e1d879aa2cad', '6f6d5a01-0d22-429f-a791-e1d879aa2cad', '6f6d5a01-0d22-429f-a791-e1d879aa2cad', array['19d07c00-6f34-4e32-9c5e-50a8a46f1c90', '176b73f7-02ae-49ea-8d1d-f1214fb0bd5d']::uuid[])
    ON CONFLICT(id) DO UPDATE SET name=EXCLUDED.name, description=EXCLUDED.description, field_ids=EXCLUDED.field_ids;

INSERT INTO fields
        (id, key, description, agg_func, agg_weights)
        VALUES ('19d07c00-6f34-4e32-9c5e-50a8a46f1c90', 'normalized_reward', 'Primary raw scenario score.', NULL, NULL)
        ON CONFLICT(id) DO UPDATE SET key=EXCLUDED.key, description=EXCLUDED.description, agg_func=EXCLUDED.agg_func, agg_weights=EXCLUDED.agg_weights;

INSERT INTO fields
        (id, key, description, agg_func, agg_weights)
        VALUES ('176b73f7-02ae-49ea-8d1d-f1214fb0bd5d', 'percentage_complete', 'Secondary raw scenario score.', NULL, NULL)
        ON CONFLICT(id) DO UPDATE SET key=EXCLUDED.key, description=EXCLUDED.description, agg_func=EXCLUDED.agg_func, agg_weights=EXCLUDED.agg_weights;

INSERT INTO scenarios
    (id, name, description, field_ids)
    VALUES ('c08c1a81-d0e1-4230-b653-d5710775a7f2', 'c08c1a81-d0e1-4230-b653-d5710775a7f2', 'c08c1a81-d0e1-4230-b653-d5710775a7f2', array['19d07c00-6f34-4e32-9c5e-50a8a46f1c90', '176b73f7-02ae-49ea-8d1d-f1214fb0bd5d']::uuid[])
    ON CONFLICT(id) DO UPDATE SET name=EXCLUDED.name, description=EXCLUDED.description, field_ids=EXCLUDED.field_ids;

INSERT INTO fields
        (id, key, description, agg_func, agg_weights)
        VALUES ('19d07c00-6f34-4e32-9c5e-50a8a46f1c90', 'normalized_reward', 'Primary raw scenario score.', NULL, NULL)
        ON CONFLICT(id) DO UPDATE SET key=EXCLUDED.key, description=EXCLUDED.description, agg_func=EXCLUDED.agg_func, agg_weights=EXCLUDED.agg_weights;

INSERT INTO fields
        (id, key, description, agg_func, agg_weights)
        VALUES ('176b73f7-02ae-49ea-8d1d-f1214fb0bd5d', 'percentage_complete', 'Secondary raw scenario score.', NULL, NULL)
        ON CONFLICT(id) DO UPDATE SET key=EXCLUDED.key, description=EXCLUDED.description, agg_func=EXCLUDED.agg_func, agg_weights=EXCLUDED.agg_weights;

INSERT INTO scenarios
    (id, name, description, field_ids)
    VALUES ('31e7455b-9018-4034-8a8d-8160439ed299', '31e7455b-9018-4034-8a8d-8160439ed299', '31e7455b-9018-4034-8a8d-8160439ed299', array['19d07c00-6f34-4e32-9c5e-50a8a46f1c90', '176b73f7-02ae-49ea-8d1d-f1214fb0bd5d']::uuid[])
    ON CONFLICT(id) DO UPDATE SET name=EXCLUDED.name, description=EXCLUDED.description, field_ids=EXCLUDED.field_ids;

INSERT INTO fields
        (id, key, description, agg_func, agg_weights)
        VALUES ('19d07c00-6f34-4e32-9c5e-50a8a46f1c90', 'normalized_reward', 'Primary raw scenario score.', NULL, NULL)
        ON CONFLICT(id) DO UPDATE SET key=EXCLUDED.key, description=EXCLUDED.description, agg_func=EXCLUDED.agg_func, agg_weights=EXCLUDED.agg_weights;

INSERT INTO fields
        (id, key, description, agg_func, agg_weights)
        VALUES ('176b73f7-02ae-49ea-8d1d-f1214fb0bd5d', 'percentage_complete', 'Secondary raw scenario score.', NULL, NULL)
        ON CONFLICT(id) DO UPDATE SET key=EXCLUDED.key, description=EXCLUDED.description, agg_func=EXCLUDED.agg_func, agg_weights=EXCLUDED.agg_weights;

INSERT INTO scenarios
    (id, name, description, field_ids)
    VALUES ('809111d2-dbbb-4746-a410-2962b2765568', '809111d2-dbbb-4746-a410-2962b2765568', '809111d2-dbbb-4746-a410-2962b2765568', array['19d07c00-6f34-4e32-9c5e-50a8a46f1c90', '176b73f7-02ae-49ea-8d1d-f1214fb0bd5d']::uuid[])
    ON CONFLICT(id) DO UPDATE SET name=EXCLUDED.name, description=EXCLUDED.description, field_ids=EXCLUDED.field_ids;

INSERT INTO fields
        (id, key, description, agg_func, agg_weights)
        VALUES ('19d07c00-6f34-4e32-9c5e-50a8a46f1c90', 'normalized_reward', 'Primary raw scenario score.', NULL, NULL)
        ON CONFLICT(id) DO UPDATE SET key=EXCLUDED.key, description=EXCLUDED.description, agg_func=EXCLUDED.agg_func, agg_weights=EXCLUDED.agg_weights;

INSERT INTO fields
        (id, key, description, agg_func, agg_weights)
        VALUES ('176b73f7-02ae-49ea-8d1d-f1214fb0bd5d', 'percentage_complete', 'Secondary raw scenario score.', NULL, NULL)
        ON CONFLICT(id) DO UPDATE SET key=EXCLUDED.key, description=EXCLUDED.description, agg_func=EXCLUDED.agg_func, agg_weights=EXCLUDED.agg_weights;

INSERT INTO scenarios
    (id, name, description, field_ids)
    VALUES ('4da5166a-393f-45d8-811c-2ed5f5047dd1', '4da5166a-393f-45d8-811c-2ed5f5047dd1', '4da5166a-393f-45d8-811c-2ed5f5047dd1', array['19d07c00-6f34-4e32-9c5e-50a8a46f1c90', '176b73f7-02ae-49ea-8d1d-f1214fb0bd5d']::uuid[])
    ON CONFLICT(id) DO UPDATE SET name=EXCLUDED.name, description=EXCLUDED.description, field_ids=EXCLUDED.field_ids;

INSERT INTO fields
        (id, key, description, agg_func, agg_weights)
        VALUES ('19d07c00-6f34-4e32-9c5e-50a8a46f1c90', 'normalized_reward', 'Primary raw scenario score.', NULL, NULL)
        ON CONFLICT(id) DO UPDATE SET key=EXCLUDED.key, description=EXCLUDED.description, agg_func=EXCLUDED.agg_func, agg_weights=EXCLUDED.agg_weights;

INSERT INTO fields
        (id, key, description, agg_func, agg_weights)
        VALUES ('176b73f7-02ae-49ea-8d1d-f1214fb0bd5d', 'percentage_complete', 'Secondary raw scenario score.', NULL, NULL)
        ON CONFLICT(id) DO UPDATE SET key=EXCLUDED.key, description=EXCLUDED.description, agg_func=EXCLUDED.agg_func, agg_weights=EXCLUDED.agg_weights;

INSERT INTO scenarios
    (id, name, description, field_ids)
    VALUES ('5284341e-01b7-4565-a5db-8372803aa749', '5284341e-01b7-4565-a5db-8372803aa749', '5284341e-01b7-4565-a5db-8372803aa749', array['19d07c00-6f34-4e32-9c5e-50a8a46f1c90', '176b73f7-02ae-49ea-8d1d-f1214fb0bd5d']::uuid[])
    ON CONFLICT(id) DO UPDATE SET name=EXCLUDED.name, description=EXCLUDED.description, field_ids=EXCLUDED.field_ids;

INSERT INTO fields
        (id, key, description, agg_func, agg_weights)
        VALUES ('19d07c00-6f34-4e32-9c5e-50a8a46f1c90', 'normalized_reward', 'Primary raw scenario score.', NULL, NULL)
        ON CONFLICT(id) DO UPDATE SET key=EXCLUDED.key, description=EXCLUDED.description, agg_func=EXCLUDED.agg_func, agg_weights=EXCLUDED.agg_weights;

INSERT INTO fields
        (id, key, description, agg_func, agg_weights)
        VALUES ('176b73f7-02ae-49ea-8d1d-f1214fb0bd5d', 'percentage_complete', 'Secondary raw scenario score.', NULL, NULL)
        ON CONFLICT(id) DO UPDATE SET key=EXCLUDED.key, description=EXCLUDED.description, agg_func=EXCLUDED.agg_func, agg_weights=EXCLUDED.agg_weights;

INSERT INTO tests
    (id, name, description, field_ids, scenario_ids, loop, queue)
    VALUES ('8a17eb8e-14cb-463f-b687-2fff7e205a5e', 'Test 4', 'Test 4: 80 agents,  30x35, 5', array['d1acf912-f71d-4ded-832c-e89cd272a0cc', 'd077454a-bba5-4798-90ed-4919d6f26e8b']::uuid[], array['bdae085e-143b-4427-bc44-332bbcb13a2f', 'edb4c75f-d9a3-4c4b-9288-cf850ac638b7', '42f73a20-9f0b-4418-8125-9af3de6c30b6', 'cba8aa28-ac84-423f-b659-e00594f9a51a', 'ced3bed0-ca13-47d5-8212-e1b9610902cd', '98695367-dd38-4f51-98cb-84ecaa1376c7', 'e6cc9f31-1dde-4bb0-8f46-a50f6ed974bc', '931439bd-f1e4-4826-afcc-6ec57cfac218', '18c4c31c-16bd-44b4-855b-d640b8a2a8d7', '46111b17-f9f4-449f-b9cc-9c9e21b4bf4f']::uuid[], 'CLOSED', NULL)
    ON CONFLICT(id) DO UPDATE SET name=EXCLUDED.name, description=EXCLUDED.description, field_ids=EXCLUDED.field_ids, scenario_ids=EXCLUDED.scenario_ids, loop=EXCLUDED.loop, queue=EXCLUDED.queue;

INSERT INTO fields
        (id, key, description, agg_func, agg_weights)
        VALUES ('d1acf912-f71d-4ded-832c-e89cd272a0cc', 'normalized_reward', 'Primary test score (NANSUM of corresponding scenario scores)', 'NANSUM', NULL)
        ON CONFLICT(id) DO UPDATE SET key=EXCLUDED.key, description=EXCLUDED.description, agg_func=EXCLUDED.agg_func, agg_weights=EXCLUDED.agg_weights;

INSERT INTO fields
        (id, key, description, agg_func, agg_weights)
        VALUES ('d077454a-bba5-4798-90ed-4919d6f26e8b', 'percentage_complete', 'Secondary test score (NANMEAN of corresponding scenario scores)', 'NANMEAN', NULL)
        ON CONFLICT(id) DO UPDATE SET key=EXCLUDED.key, description=EXCLUDED.description, agg_func=EXCLUDED.agg_func, agg_weights=EXCLUDED.agg_weights;

INSERT INTO scenarios
    (id, name, description, field_ids)
    VALUES ('bdae085e-143b-4427-bc44-332bbcb13a2f', 'bdae085e-143b-4427-bc44-332bbcb13a2f', 'bdae085e-143b-4427-bc44-332bbcb13a2f', array['19d07c00-6f34-4e32-9c5e-50a8a46f1c90', '176b73f7-02ae-49ea-8d1d-f1214fb0bd5d']::uuid[])
    ON CONFLICT(id) DO UPDATE SET name=EXCLUDED.name, description=EXCLUDED.description, field_ids=EXCLUDED.field_ids;

INSERT INTO fields
        (id, key, description, agg_func, agg_weights)
        VALUES ('19d07c00-6f34-4e32-9c5e-50a8a46f1c90', 'normalized_reward', 'Primary raw scenario score.', NULL, NULL)
        ON CONFLICT(id) DO UPDATE SET key=EXCLUDED.key, description=EXCLUDED.description, agg_func=EXCLUDED.agg_func, agg_weights=EXCLUDED.agg_weights;

INSERT INTO fields
        (id, key, description, agg_func, agg_weights)
        VALUES ('176b73f7-02ae-49ea-8d1d-f1214fb0bd5d', 'percentage_complete', 'Secondary raw scenario score.', NULL, NULL)
        ON CONFLICT(id) DO UPDATE SET key=EXCLUDED.key, description=EXCLUDED.description, agg_func=EXCLUDED.agg_func, agg_weights=EXCLUDED.agg_weights;

INSERT INTO scenarios
    (id, name, description, field_ids)
    VALUES ('edb4c75f-d9a3-4c4b-9288-cf850ac638b7', 'edb4c75f-d9a3-4c4b-9288-cf850ac638b7', 'edb4c75f-d9a3-4c4b-9288-cf850ac638b7', array['19d07c00-6f34-4e32-9c5e-50a8a46f1c90', '176b73f7-02ae-49ea-8d1d-f1214fb0bd5d']::uuid[])
    ON CONFLICT(id) DO UPDATE SET name=EXCLUDED.name, description=EXCLUDED.description, field_ids=EXCLUDED.field_ids;

INSERT INTO fields
        (id, key, description, agg_func, agg_weights)
        VALUES ('19d07c00-6f34-4e32-9c5e-50a8a46f1c90', 'normalized_reward', 'Primary raw scenario score.', NULL, NULL)
        ON CONFLICT(id) DO UPDATE SET key=EXCLUDED.key, description=EXCLUDED.description, agg_func=EXCLUDED.agg_func, agg_weights=EXCLUDED.agg_weights;

INSERT INTO fields
        (id, key, description, agg_func, agg_weights)
        VALUES ('176b73f7-02ae-49ea-8d1d-f1214fb0bd5d', 'percentage_complete', 'Secondary raw scenario score.', NULL, NULL)
        ON CONFLICT(id) DO UPDATE SET key=EXCLUDED.key, description=EXCLUDED.description, agg_func=EXCLUDED.agg_func, agg_weights=EXCLUDED.agg_weights;

INSERT INTO scenarios
    (id, name, description, field_ids)
    VALUES ('42f73a20-9f0b-4418-8125-9af3de6c30b6', '42f73a20-9f0b-4418-8125-9af3de6c30b6', '42f73a20-9f0b-4418-8125-9af3de6c30b6', array['19d07c00-6f34-4e32-9c5e-50a8a46f1c90', '176b73f7-02ae-49ea-8d1d-f1214fb0bd5d']::uuid[])
    ON CONFLICT(id) DO UPDATE SET name=EXCLUDED.name, description=EXCLUDED.description, field_ids=EXCLUDED.field_ids;

INSERT INTO fields
        (id, key, description, agg_func, agg_weights)
        VALUES ('19d07c00-6f34-4e32-9c5e-50a8a46f1c90', 'normalized_reward', 'Primary raw scenario score.', NULL, NULL)
        ON CONFLICT(id) DO UPDATE SET key=EXCLUDED.key, description=EXCLUDED.description, agg_func=EXCLUDED.agg_func, agg_weights=EXCLUDED.agg_weights;

INSERT INTO fields
        (id, key, description, agg_func, agg_weights)
        VALUES ('176b73f7-02ae-49ea-8d1d-f1214fb0bd5d', 'percentage_complete', 'Secondary raw scenario score.', NULL, NULL)
        ON CONFLICT(id) DO UPDATE SET key=EXCLUDED.key, description=EXCLUDED.description, agg_func=EXCLUDED.agg_func, agg_weights=EXCLUDED.agg_weights;

INSERT INTO scenarios
    (id, name, description, field_ids)
    VALUES ('cba8aa28-ac84-423f-b659-e00594f9a51a', 'cba8aa28-ac84-423f-b659-e00594f9a51a', 'cba8aa28-ac84-423f-b659-e00594f9a51a', array['19d07c00-6f34-4e32-9c5e-50a8a46f1c90', '176b73f7-02ae-49ea-8d1d-f1214fb0bd5d']::uuid[])
    ON CONFLICT(id) DO UPDATE SET name=EXCLUDED.name, description=EXCLUDED.description, field_ids=EXCLUDED.field_ids;

INSERT INTO fields
        (id, key, description, agg_func, agg_weights)
        VALUES ('19d07c00-6f34-4e32-9c5e-50a8a46f1c90', 'normalized_reward', 'Primary raw scenario score.', NULL, NULL)
        ON CONFLICT(id) DO UPDATE SET key=EXCLUDED.key, description=EXCLUDED.description, agg_func=EXCLUDED.agg_func, agg_weights=EXCLUDED.agg_weights;

INSERT INTO fields
        (id, key, description, agg_func, agg_weights)
        VALUES ('176b73f7-02ae-49ea-8d1d-f1214fb0bd5d', 'percentage_complete', 'Secondary raw scenario score.', NULL, NULL)
        ON CONFLICT(id) DO UPDATE SET key=EXCLUDED.key, description=EXCLUDED.description, agg_func=EXCLUDED.agg_func, agg_weights=EXCLUDED.agg_weights;

INSERT INTO scenarios
    (id, name, description, field_ids)
    VALUES ('ced3bed0-ca13-47d5-8212-e1b9610902cd', 'ced3bed0-ca13-47d5-8212-e1b9610902cd', 'ced3bed0-ca13-47d5-8212-e1b9610902cd', array['19d07c00-6f34-4e32-9c5e-50a8a46f1c90', '176b73f7-02ae-49ea-8d1d-f1214fb0bd5d']::uuid[])
    ON CONFLICT(id) DO UPDATE SET name=EXCLUDED.name, description=EXCLUDED.description, field_ids=EXCLUDED.field_ids;

INSERT INTO fields
        (id, key, description, agg_func, agg_weights)
        VALUES ('19d07c00-6f34-4e32-9c5e-50a8a46f1c90', 'normalized_reward', 'Primary raw scenario score.', NULL, NULL)
        ON CONFLICT(id) DO UPDATE SET key=EXCLUDED.key, description=EXCLUDED.description, agg_func=EXCLUDED.agg_func, agg_weights=EXCLUDED.agg_weights;

INSERT INTO fields
        (id, key, description, agg_func, agg_weights)
        VALUES ('176b73f7-02ae-49ea-8d1d-f1214fb0bd5d', 'percentage_complete', 'Secondary raw scenario score.', NULL, NULL)
        ON CONFLICT(id) DO UPDATE SET key=EXCLUDED.key, description=EXCLUDED.description, agg_func=EXCLUDED.agg_func, agg_weights=EXCLUDED.agg_weights;

INSERT INTO scenarios
    (id, name, description, field_ids)
    VALUES ('98695367-dd38-4f51-98cb-84ecaa1376c7', '98695367-dd38-4f51-98cb-84ecaa1376c7', '98695367-dd38-4f51-98cb-84ecaa1376c7', array['19d07c00-6f34-4e32-9c5e-50a8a46f1c90', '176b73f7-02ae-49ea-8d1d-f1214fb0bd5d']::uuid[])
    ON CONFLICT(id) DO UPDATE SET name=EXCLUDED.name, description=EXCLUDED.description, field_ids=EXCLUDED.field_ids;

INSERT INTO fields
        (id, key, description, agg_func, agg_weights)
        VALUES ('19d07c00-6f34-4e32-9c5e-50a8a46f1c90', 'normalized_reward', 'Primary raw scenario score.', NULL, NULL)
        ON CONFLICT(id) DO UPDATE SET key=EXCLUDED.key, description=EXCLUDED.description, agg_func=EXCLUDED.agg_func, agg_weights=EXCLUDED.agg_weights;

INSERT INTO fields
        (id, key, description, agg_func, agg_weights)
        VALUES ('176b73f7-02ae-49ea-8d1d-f1214fb0bd5d', 'percentage_complete', 'Secondary raw scenario score.', NULL, NULL)
        ON CONFLICT(id) DO UPDATE SET key=EXCLUDED.key, description=EXCLUDED.description, agg_func=EXCLUDED.agg_func, agg_weights=EXCLUDED.agg_weights;

INSERT INTO scenarios
    (id, name, description, field_ids)
    VALUES ('e6cc9f31-1dde-4bb0-8f46-a50f6ed974bc', 'e6cc9f31-1dde-4bb0-8f46-a50f6ed974bc', 'e6cc9f31-1dde-4bb0-8f46-a50f6ed974bc', array['19d07c00-6f34-4e32-9c5e-50a8a46f1c90', '176b73f7-02ae-49ea-8d1d-f1214fb0bd5d']::uuid[])
    ON CONFLICT(id) DO UPDATE SET name=EXCLUDED.name, description=EXCLUDED.description, field_ids=EXCLUDED.field_ids;

INSERT INTO fields
        (id, key, description, agg_func, agg_weights)
        VALUES ('19d07c00-6f34-4e32-9c5e-50a8a46f1c90', 'normalized_reward', 'Primary raw scenario score.', NULL, NULL)
        ON CONFLICT(id) DO UPDATE SET key=EXCLUDED.key, description=EXCLUDED.description, agg_func=EXCLUDED.agg_func, agg_weights=EXCLUDED.agg_weights;

INSERT INTO fields
        (id, key, description, agg_func, agg_weights)
        VALUES ('176b73f7-02ae-49ea-8d1d-f1214fb0bd5d', 'percentage_complete', 'Secondary raw scenario score.', NULL, NULL)
        ON CONFLICT(id) DO UPDATE SET key=EXCLUDED.key, description=EXCLUDED.description, agg_func=EXCLUDED.agg_func, agg_weights=EXCLUDED.agg_weights;

INSERT INTO scenarios
    (id, name, description, field_ids)
    VALUES ('931439bd-f1e4-4826-afcc-6ec57cfac218', '931439bd-f1e4-4826-afcc-6ec57cfac218', '931439bd-f1e4-4826-afcc-6ec57cfac218', array['19d07c00-6f34-4e32-9c5e-50a8a46f1c90', '176b73f7-02ae-49ea-8d1d-f1214fb0bd5d']::uuid[])
    ON CONFLICT(id) DO UPDATE SET name=EXCLUDED.name, description=EXCLUDED.description, field_ids=EXCLUDED.field_ids;

INSERT INTO fields
        (id, key, description, agg_func, agg_weights)
        VALUES ('19d07c00-6f34-4e32-9c5e-50a8a46f1c90', 'normalized_reward', 'Primary raw scenario score.', NULL, NULL)
        ON CONFLICT(id) DO UPDATE SET key=EXCLUDED.key, description=EXCLUDED.description, agg_func=EXCLUDED.agg_func, agg_weights=EXCLUDED.agg_weights;

INSERT INTO fields
        (id, key, description, agg_func, agg_weights)
        VALUES ('176b73f7-02ae-49ea-8d1d-f1214fb0bd5d', 'percentage_complete', 'Secondary raw scenario score.', NULL, NULL)
        ON CONFLICT(id) DO UPDATE SET key=EXCLUDED.key, description=EXCLUDED.description, agg_func=EXCLUDED.agg_func, agg_weights=EXCLUDED.agg_weights;

INSERT INTO scenarios
    (id, name, description, field_ids)
    VALUES ('18c4c31c-16bd-44b4-855b-d640b8a2a8d7', '18c4c31c-16bd-44b4-855b-d640b8a2a8d7', '18c4c31c-16bd-44b4-855b-d640b8a2a8d7', array['19d07c00-6f34-4e32-9c5e-50a8a46f1c90', '176b73f7-02ae-49ea-8d1d-f1214fb0bd5d']::uuid[])
    ON CONFLICT(id) DO UPDATE SET name=EXCLUDED.name, description=EXCLUDED.description, field_ids=EXCLUDED.field_ids;

INSERT INTO fields
        (id, key, description, agg_func, agg_weights)
        VALUES ('19d07c00-6f34-4e32-9c5e-50a8a46f1c90', 'normalized_reward', 'Primary raw scenario score.', NULL, NULL)
        ON CONFLICT(id) DO UPDATE SET key=EXCLUDED.key, description=EXCLUDED.description, agg_func=EXCLUDED.agg_func, agg_weights=EXCLUDED.agg_weights;

INSERT INTO fields
        (id, key, description, agg_func, agg_weights)
        VALUES ('176b73f7-02ae-49ea-8d1d-f1214fb0bd5d', 'percentage_complete', 'Secondary raw scenario score.', NULL, NULL)
        ON CONFLICT(id) DO UPDATE SET key=EXCLUDED.key, description=EXCLUDED.description, agg_func=EXCLUDED.agg_func, agg_weights=EXCLUDED.agg_weights;

INSERT INTO scenarios
    (id, name, description, field_ids)
    VALUES ('46111b17-f9f4-449f-b9cc-9c9e21b4bf4f', '46111b17-f9f4-449f-b9cc-9c9e21b4bf4f', '46111b17-f9f4-449f-b9cc-9c9e21b4bf4f', array['19d07c00-6f34-4e32-9c5e-50a8a46f1c90', '176b73f7-02ae-49ea-8d1d-f1214fb0bd5d']::uuid[])
    ON CONFLICT(id) DO UPDATE SET name=EXCLUDED.name, description=EXCLUDED.description, field_ids=EXCLUDED.field_ids;

INSERT INTO fields
        (id, key, description, agg_func, agg_weights)
        VALUES ('19d07c00-6f34-4e32-9c5e-50a8a46f1c90', 'normalized_reward', 'Primary raw scenario score.', NULL, NULL)
        ON CONFLICT(id) DO UPDATE SET key=EXCLUDED.key, description=EXCLUDED.description, agg_func=EXCLUDED.agg_func, agg_weights=EXCLUDED.agg_weights;

INSERT INTO fields
        (id, key, description, agg_func, agg_weights)
        VALUES ('176b73f7-02ae-49ea-8d1d-f1214fb0bd5d', 'percentage_complete', 'Secondary raw scenario score.', NULL, NULL)
        ON CONFLICT(id) DO UPDATE SET key=EXCLUDED.key, description=EXCLUDED.description, agg_func=EXCLUDED.agg_func, agg_weights=EXCLUDED.agg_weights;

INSERT INTO tests
    (id, name, description, field_ids, scenario_ids, loop, queue)
    VALUES ('d6dc02b7-4683-4ef5-8632-9f9746e06c70', 'Test 5', 'Test 5: 80 agents,  35x45, 7', array['d1acf912-f71d-4ded-832c-e89cd272a0cc', 'd077454a-bba5-4798-90ed-4919d6f26e8b']::uuid[], array['a1f76840-b65a-4fba-850e-62e6962e8cf3', '7917b42b-46de-4513-88ae-bdbfa8dd4c44', 'b325d370-16ff-4885-accf-232bd90e27f9', 'ad99d767-9f1c-4a63-b93b-431ab53c90d1', 'd3ff288f-26f1-4a6a-8c6c-d4eeb6ffd7c1', 'eb54d12f-26ec-446d-b54f-d088cbf59aec', 'bf6f16a6-7bd8-46a4-a239-7600e19962ff', 'f16b235c-953b-485e-8bdb-f2467bc0e48b', '31f36513-cc80-4e03-815b-e10128bebd7b', '93aaab2b-b224-4331-991c-017536456904']::uuid[], 'CLOSED', NULL)
    ON CONFLICT(id) DO UPDATE SET name=EXCLUDED.name, description=EXCLUDED.description, field_ids=EXCLUDED.field_ids, scenario_ids=EXCLUDED.scenario_ids, loop=EXCLUDED.loop, queue=EXCLUDED.queue;

INSERT INTO fields
        (id, key, description, agg_func, agg_weights)
        VALUES ('d1acf912-f71d-4ded-832c-e89cd272a0cc', 'normalized_reward', 'Primary test score (NANSUM of corresponding scenario scores)', 'NANSUM', NULL)
        ON CONFLICT(id) DO UPDATE SET key=EXCLUDED.key, description=EXCLUDED.description, agg_func=EXCLUDED.agg_func, agg_weights=EXCLUDED.agg_weights;

INSERT INTO fields
        (id, key, description, agg_func, agg_weights)
        VALUES ('d077454a-bba5-4798-90ed-4919d6f26e8b', 'percentage_complete', 'Secondary test score (NANMEAN of corresponding scenario scores)', 'NANMEAN', NULL)
        ON CONFLICT(id) DO UPDATE SET key=EXCLUDED.key, description=EXCLUDED.description, agg_func=EXCLUDED.agg_func, agg_weights=EXCLUDED.agg_weights;

INSERT INTO scenarios
    (id, name, description, field_ids)
    VALUES ('a1f76840-b65a-4fba-850e-62e6962e8cf3', 'a1f76840-b65a-4fba-850e-62e6962e8cf3', 'a1f76840-b65a-4fba-850e-62e6962e8cf3', array['19d07c00-6f34-4e32-9c5e-50a8a46f1c90', '176b73f7-02ae-49ea-8d1d-f1214fb0bd5d']::uuid[])
    ON CONFLICT(id) DO UPDATE SET name=EXCLUDED.name, description=EXCLUDED.description, field_ids=EXCLUDED.field_ids;

INSERT INTO fields
        (id, key, description, agg_func, agg_weights)
        VALUES ('19d07c00-6f34-4e32-9c5e-50a8a46f1c90', 'normalized_reward', 'Primary raw scenario score.', NULL, NULL)
        ON CONFLICT(id) DO UPDATE SET key=EXCLUDED.key, description=EXCLUDED.description, agg_func=EXCLUDED.agg_func, agg_weights=EXCLUDED.agg_weights;

INSERT INTO fields
        (id, key, description, agg_func, agg_weights)
        VALUES ('176b73f7-02ae-49ea-8d1d-f1214fb0bd5d', 'percentage_complete', 'Secondary raw scenario score.', NULL, NULL)
        ON CONFLICT(id) DO UPDATE SET key=EXCLUDED.key, description=EXCLUDED.description, agg_func=EXCLUDED.agg_func, agg_weights=EXCLUDED.agg_weights;

INSERT INTO scenarios
    (id, name, description, field_ids)
    VALUES ('7917b42b-46de-4513-88ae-bdbfa8dd4c44', '7917b42b-46de-4513-88ae-bdbfa8dd4c44', '7917b42b-46de-4513-88ae-bdbfa8dd4c44', array['19d07c00-6f34-4e32-9c5e-50a8a46f1c90', '176b73f7-02ae-49ea-8d1d-f1214fb0bd5d']::uuid[])
    ON CONFLICT(id) DO UPDATE SET name=EXCLUDED.name, description=EXCLUDED.description, field_ids=EXCLUDED.field_ids;

INSERT INTO fields
        (id, key, description, agg_func, agg_weights)
        VALUES ('19d07c00-6f34-4e32-9c5e-50a8a46f1c90', 'normalized_reward', 'Primary raw scenario score.', NULL, NULL)
        ON CONFLICT(id) DO UPDATE SET key=EXCLUDED.key, description=EXCLUDED.description, agg_func=EXCLUDED.agg_func, agg_weights=EXCLUDED.agg_weights;

INSERT INTO fields
        (id, key, description, agg_func, agg_weights)
        VALUES ('176b73f7-02ae-49ea-8d1d-f1214fb0bd5d', 'percentage_complete', 'Secondary raw scenario score.', NULL, NULL)
        ON CONFLICT(id) DO UPDATE SET key=EXCLUDED.key, description=EXCLUDED.description, agg_func=EXCLUDED.agg_func, agg_weights=EXCLUDED.agg_weights;

INSERT INTO scenarios
    (id, name, description, field_ids)
    VALUES ('b325d370-16ff-4885-accf-232bd90e27f9', 'b325d370-16ff-4885-accf-232bd90e27f9', 'b325d370-16ff-4885-accf-232bd90e27f9', array['19d07c00-6f34-4e32-9c5e-50a8a46f1c90', '176b73f7-02ae-49ea-8d1d-f1214fb0bd5d']::uuid[])
    ON CONFLICT(id) DO UPDATE SET name=EXCLUDED.name, description=EXCLUDED.description, field_ids=EXCLUDED.field_ids;

INSERT INTO fields
        (id, key, description, agg_func, agg_weights)
        VALUES ('19d07c00-6f34-4e32-9c5e-50a8a46f1c90', 'normalized_reward', 'Primary raw scenario score.', NULL, NULL)
        ON CONFLICT(id) DO UPDATE SET key=EXCLUDED.key, description=EXCLUDED.description, agg_func=EXCLUDED.agg_func, agg_weights=EXCLUDED.agg_weights;

INSERT INTO fields
        (id, key, description, agg_func, agg_weights)
        VALUES ('176b73f7-02ae-49ea-8d1d-f1214fb0bd5d', 'percentage_complete', 'Secondary raw scenario score.', NULL, NULL)
        ON CONFLICT(id) DO UPDATE SET key=EXCLUDED.key, description=EXCLUDED.description, agg_func=EXCLUDED.agg_func, agg_weights=EXCLUDED.agg_weights;

INSERT INTO scenarios
    (id, name, description, field_ids)
    VALUES ('ad99d767-9f1c-4a63-b93b-431ab53c90d1', 'ad99d767-9f1c-4a63-b93b-431ab53c90d1', 'ad99d767-9f1c-4a63-b93b-431ab53c90d1', array['19d07c00-6f34-4e32-9c5e-50a8a46f1c90', '176b73f7-02ae-49ea-8d1d-f1214fb0bd5d']::uuid[])
    ON CONFLICT(id) DO UPDATE SET name=EXCLUDED.name, description=EXCLUDED.description, field_ids=EXCLUDED.field_ids;

INSERT INTO fields
        (id, key, description, agg_func, agg_weights)
        VALUES ('19d07c00-6f34-4e32-9c5e-50a8a46f1c90', 'normalized_reward', 'Primary raw scenario score.', NULL, NULL)
        ON CONFLICT(id) DO UPDATE SET key=EXCLUDED.key, description=EXCLUDED.description, agg_func=EXCLUDED.agg_func, agg_weights=EXCLUDED.agg_weights;

INSERT INTO fields
        (id, key, description, agg_func, agg_weights)
        VALUES ('176b73f7-02ae-49ea-8d1d-f1214fb0bd5d', 'percentage_complete', 'Secondary raw scenario score.', NULL, NULL)
        ON CONFLICT(id) DO UPDATE SET key=EXCLUDED.key, description=EXCLUDED.description, agg_func=EXCLUDED.agg_func, agg_weights=EXCLUDED.agg_weights;

INSERT INTO scenarios
    (id, name, description, field_ids)
    VALUES ('d3ff288f-26f1-4a6a-8c6c-d4eeb6ffd7c1', 'd3ff288f-26f1-4a6a-8c6c-d4eeb6ffd7c1', 'd3ff288f-26f1-4a6a-8c6c-d4eeb6ffd7c1', array['19d07c00-6f34-4e32-9c5e-50a8a46f1c90', '176b73f7-02ae-49ea-8d1d-f1214fb0bd5d']::uuid[])
    ON CONFLICT(id) DO UPDATE SET name=EXCLUDED.name, description=EXCLUDED.description, field_ids=EXCLUDED.field_ids;

INSERT INTO fields
        (id, key, description, agg_func, agg_weights)
        VALUES ('19d07c00-6f34-4e32-9c5e-50a8a46f1c90', 'normalized_reward', 'Primary raw scenario score.', NULL, NULL)
        ON CONFLICT(id) DO UPDATE SET key=EXCLUDED.key, description=EXCLUDED.description, agg_func=EXCLUDED.agg_func, agg_weights=EXCLUDED.agg_weights;

INSERT INTO fields
        (id, key, description, agg_func, agg_weights)
        VALUES ('176b73f7-02ae-49ea-8d1d-f1214fb0bd5d', 'percentage_complete', 'Secondary raw scenario score.', NULL, NULL)
        ON CONFLICT(id) DO UPDATE SET key=EXCLUDED.key, description=EXCLUDED.description, agg_func=EXCLUDED.agg_func, agg_weights=EXCLUDED.agg_weights;

INSERT INTO scenarios
    (id, name, description, field_ids)
    VALUES ('eb54d12f-26ec-446d-b54f-d088cbf59aec', 'eb54d12f-26ec-446d-b54f-d088cbf59aec', 'eb54d12f-26ec-446d-b54f-d088cbf59aec', array['19d07c00-6f34-4e32-9c5e-50a8a46f1c90', '176b73f7-02ae-49ea-8d1d-f1214fb0bd5d']::uuid[])
    ON CONFLICT(id) DO UPDATE SET name=EXCLUDED.name, description=EXCLUDED.description, field_ids=EXCLUDED.field_ids;

INSERT INTO fields
        (id, key, description, agg_func, agg_weights)
        VALUES ('19d07c00-6f34-4e32-9c5e-50a8a46f1c90', 'normalized_reward', 'Primary raw scenario score.', NULL, NULL)
        ON CONFLICT(id) DO UPDATE SET key=EXCLUDED.key, description=EXCLUDED.description, agg_func=EXCLUDED.agg_func, agg_weights=EXCLUDED.agg_weights;

INSERT INTO fields
        (id, key, description, agg_func, agg_weights)
        VALUES ('176b73f7-02ae-49ea-8d1d-f1214fb0bd5d', 'percentage_complete', 'Secondary raw scenario score.', NULL, NULL)
        ON CONFLICT(id) DO UPDATE SET key=EXCLUDED.key, description=EXCLUDED.description, agg_func=EXCLUDED.agg_func, agg_weights=EXCLUDED.agg_weights;

INSERT INTO scenarios
    (id, name, description, field_ids)
    VALUES ('bf6f16a6-7bd8-46a4-a239-7600e19962ff', 'bf6f16a6-7bd8-46a4-a239-7600e19962ff', 'bf6f16a6-7bd8-46a4-a239-7600e19962ff', array['19d07c00-6f34-4e32-9c5e-50a8a46f1c90', '176b73f7-02ae-49ea-8d1d-f1214fb0bd5d']::uuid[])
    ON CONFLICT(id) DO UPDATE SET name=EXCLUDED.name, description=EXCLUDED.description, field_ids=EXCLUDED.field_ids;

INSERT INTO fields
        (id, key, description, agg_func, agg_weights)
        VALUES ('19d07c00-6f34-4e32-9c5e-50a8a46f1c90', 'normalized_reward', 'Primary raw scenario score.', NULL, NULL)
        ON CONFLICT(id) DO UPDATE SET key=EXCLUDED.key, description=EXCLUDED.description, agg_func=EXCLUDED.agg_func, agg_weights=EXCLUDED.agg_weights;

INSERT INTO fields
        (id, key, description, agg_func, agg_weights)
        VALUES ('176b73f7-02ae-49ea-8d1d-f1214fb0bd5d', 'percentage_complete', 'Secondary raw scenario score.', NULL, NULL)
        ON CONFLICT(id) DO UPDATE SET key=EXCLUDED.key, description=EXCLUDED.description, agg_func=EXCLUDED.agg_func, agg_weights=EXCLUDED.agg_weights;

INSERT INTO scenarios
    (id, name, description, field_ids)
    VALUES ('f16b235c-953b-485e-8bdb-f2467bc0e48b', 'f16b235c-953b-485e-8bdb-f2467bc0e48b', 'f16b235c-953b-485e-8bdb-f2467bc0e48b', array['19d07c00-6f34-4e32-9c5e-50a8a46f1c90', '176b73f7-02ae-49ea-8d1d-f1214fb0bd5d']::uuid[])
    ON CONFLICT(id) DO UPDATE SET name=EXCLUDED.name, description=EXCLUDED.description, field_ids=EXCLUDED.field_ids;

INSERT INTO fields
        (id, key, description, agg_func, agg_weights)
        VALUES ('19d07c00-6f34-4e32-9c5e-50a8a46f1c90', 'normalized_reward', 'Primary raw scenario score.', NULL, NULL)
        ON CONFLICT(id) DO UPDATE SET key=EXCLUDED.key, description=EXCLUDED.description, agg_func=EXCLUDED.agg_func, agg_weights=EXCLUDED.agg_weights;

INSERT INTO fields
        (id, key, description, agg_func, agg_weights)
        VALUES ('176b73f7-02ae-49ea-8d1d-f1214fb0bd5d', 'percentage_complete', 'Secondary raw scenario score.', NULL, NULL)
        ON CONFLICT(id) DO UPDATE SET key=EXCLUDED.key, description=EXCLUDED.description, agg_func=EXCLUDED.agg_func, agg_weights=EXCLUDED.agg_weights;

INSERT INTO scenarios
    (id, name, description, field_ids)
    VALUES ('31f36513-cc80-4e03-815b-e10128bebd7b', '31f36513-cc80-4e03-815b-e10128bebd7b', '31f36513-cc80-4e03-815b-e10128bebd7b', array['19d07c00-6f34-4e32-9c5e-50a8a46f1c90', '176b73f7-02ae-49ea-8d1d-f1214fb0bd5d']::uuid[])
    ON CONFLICT(id) DO UPDATE SET name=EXCLUDED.name, description=EXCLUDED.description, field_ids=EXCLUDED.field_ids;

INSERT INTO fields
        (id, key, description, agg_func, agg_weights)
        VALUES ('19d07c00-6f34-4e32-9c5e-50a8a46f1c90', 'normalized_reward', 'Primary raw scenario score.', NULL, NULL)
        ON CONFLICT(id) DO UPDATE SET key=EXCLUDED.key, description=EXCLUDED.description, agg_func=EXCLUDED.agg_func, agg_weights=EXCLUDED.agg_weights;

INSERT INTO fields
        (id, key, description, agg_func, agg_weights)
        VALUES ('176b73f7-02ae-49ea-8d1d-f1214fb0bd5d', 'percentage_complete', 'Secondary raw scenario score.', NULL, NULL)
        ON CONFLICT(id) DO UPDATE SET key=EXCLUDED.key, description=EXCLUDED.description, agg_func=EXCLUDED.agg_func, agg_weights=EXCLUDED.agg_weights;

INSERT INTO scenarios
    (id, name, description, field_ids)
    VALUES ('93aaab2b-b224-4331-991c-017536456904', '93aaab2b-b224-4331-991c-017536456904', '93aaab2b-b224-4331-991c-017536456904', array['19d07c00-6f34-4e32-9c5e-50a8a46f1c90', '176b73f7-02ae-49ea-8d1d-f1214fb0bd5d']::uuid[])
    ON CONFLICT(id) DO UPDATE SET name=EXCLUDED.name, description=EXCLUDED.description, field_ids=EXCLUDED.field_ids;

INSERT INTO fields
        (id, key, description, agg_func, agg_weights)
        VALUES ('19d07c00-6f34-4e32-9c5e-50a8a46f1c90', 'normalized_reward', 'Primary raw scenario score.', NULL, NULL)
        ON CONFLICT(id) DO UPDATE SET key=EXCLUDED.key, description=EXCLUDED.description, agg_func=EXCLUDED.agg_func, agg_weights=EXCLUDED.agg_weights;

INSERT INTO fields
        (id, key, description, agg_func, agg_weights)
        VALUES ('176b73f7-02ae-49ea-8d1d-f1214fb0bd5d', 'percentage_complete', 'Secondary raw scenario score.', NULL, NULL)
        ON CONFLICT(id) DO UPDATE SET key=EXCLUDED.key, description=EXCLUDED.description, agg_func=EXCLUDED.agg_func, agg_weights=EXCLUDED.agg_weights;

INSERT INTO tests
    (id, name, description, field_ids, scenario_ids, loop, queue)
    VALUES ('6dac64f4-fe91-4cca-a04d-541160d7c72a', 'Test 6', 'Test 6: 80 agents,  60x40, 9', array['d1acf912-f71d-4ded-832c-e89cd272a0cc', 'd077454a-bba5-4798-90ed-4919d6f26e8b']::uuid[], array['dc4abadb-36de-446d-ab82-8284905f61fe', '5bd0786e-8cdd-4a8f-8fd3-781bd453b0f8', '9ccd5eb8-cfb7-4978-8eab-74b22f350856', '643f87c4-fbd7-426d-8a37-489a32b989da', 'e2284e75-33c5-4ba8-a094-a7d98c7ba50d', '2d24fb79-b9e9-49e5-a781-670b08800d6d', '9838248b-9440-4edf-a737-0bb571a9dfb4', '6639e91d-c96b-46ff-8ccf-09b02847abf3', '6285df65-4c03-42bc-99d9-b56c646c1712', '3f65387f-052a-4186-8c44-c957a7432631']::uuid[], 'CLOSED', NULL)
    ON CONFLICT(id) DO UPDATE SET name=EXCLUDED.name, description=EXCLUDED.description, field_ids=EXCLUDED.field_ids, scenario_ids=EXCLUDED.scenario_ids, loop=EXCLUDED.loop, queue=EXCLUDED.queue;

INSERT INTO fields
        (id, key, description, agg_func, agg_weights)
        VALUES ('d1acf912-f71d-4ded-832c-e89cd272a0cc', 'normalized_reward', 'Primary test score (NANSUM of corresponding scenario scores)', 'NANSUM', NULL)
        ON CONFLICT(id) DO UPDATE SET key=EXCLUDED.key, description=EXCLUDED.description, agg_func=EXCLUDED.agg_func, agg_weights=EXCLUDED.agg_weights;

INSERT INTO fields
        (id, key, description, agg_func, agg_weights)
        VALUES ('d077454a-bba5-4798-90ed-4919d6f26e8b', 'percentage_complete', 'Secondary test score (NANMEAN of corresponding scenario scores)', 'NANMEAN', NULL)
        ON CONFLICT(id) DO UPDATE SET key=EXCLUDED.key, description=EXCLUDED.description, agg_func=EXCLUDED.agg_func, agg_weights=EXCLUDED.agg_weights;

INSERT INTO scenarios
    (id, name, description, field_ids)
    VALUES ('dc4abadb-36de-446d-ab82-8284905f61fe', 'dc4abadb-36de-446d-ab82-8284905f61fe', 'dc4abadb-36de-446d-ab82-8284905f61fe', array['19d07c00-6f34-4e32-9c5e-50a8a46f1c90', '176b73f7-02ae-49ea-8d1d-f1214fb0bd5d']::uuid[])
    ON CONFLICT(id) DO UPDATE SET name=EXCLUDED.name, description=EXCLUDED.description, field_ids=EXCLUDED.field_ids;

INSERT INTO fields
        (id, key, description, agg_func, agg_weights)
        VALUES ('19d07c00-6f34-4e32-9c5e-50a8a46f1c90', 'normalized_reward', 'Primary raw scenario score.', NULL, NULL)
        ON CONFLICT(id) DO UPDATE SET key=EXCLUDED.key, description=EXCLUDED.description, agg_func=EXCLUDED.agg_func, agg_weights=EXCLUDED.agg_weights;

INSERT INTO fields
        (id, key, description, agg_func, agg_weights)
        VALUES ('176b73f7-02ae-49ea-8d1d-f1214fb0bd5d', 'percentage_complete', 'Secondary raw scenario score.', NULL, NULL)
        ON CONFLICT(id) DO UPDATE SET key=EXCLUDED.key, description=EXCLUDED.description, agg_func=EXCLUDED.agg_func, agg_weights=EXCLUDED.agg_weights;

INSERT INTO scenarios
    (id, name, description, field_ids)
    VALUES ('5bd0786e-8cdd-4a8f-8fd3-781bd453b0f8', '5bd0786e-8cdd-4a8f-8fd3-781bd453b0f8', '5bd0786e-8cdd-4a8f-8fd3-781bd453b0f8', array['19d07c00-6f34-4e32-9c5e-50a8a46f1c90', '176b73f7-02ae-49ea-8d1d-f1214fb0bd5d']::uuid[])
    ON CONFLICT(id) DO UPDATE SET name=EXCLUDED.name, description=EXCLUDED.description, field_ids=EXCLUDED.field_ids;

INSERT INTO fields
        (id, key, description, agg_func, agg_weights)
        VALUES ('19d07c00-6f34-4e32-9c5e-50a8a46f1c90', 'normalized_reward', 'Primary raw scenario score.', NULL, NULL)
        ON CONFLICT(id) DO UPDATE SET key=EXCLUDED.key, description=EXCLUDED.description, agg_func=EXCLUDED.agg_func, agg_weights=EXCLUDED.agg_weights;

INSERT INTO fields
        (id, key, description, agg_func, agg_weights)
        VALUES ('176b73f7-02ae-49ea-8d1d-f1214fb0bd5d', 'percentage_complete', 'Secondary raw scenario score.', NULL, NULL)
        ON CONFLICT(id) DO UPDATE SET key=EXCLUDED.key, description=EXCLUDED.description, agg_func=EXCLUDED.agg_func, agg_weights=EXCLUDED.agg_weights;

INSERT INTO scenarios
    (id, name, description, field_ids)
    VALUES ('9ccd5eb8-cfb7-4978-8eab-74b22f350856', '9ccd5eb8-cfb7-4978-8eab-74b22f350856', '9ccd5eb8-cfb7-4978-8eab-74b22f350856', array['19d07c00-6f34-4e32-9c5e-50a8a46f1c90', '176b73f7-02ae-49ea-8d1d-f1214fb0bd5d']::uuid[])
    ON CONFLICT(id) DO UPDATE SET name=EXCLUDED.name, description=EXCLUDED.description, field_ids=EXCLUDED.field_ids;

INSERT INTO fields
        (id, key, description, agg_func, agg_weights)
        VALUES ('19d07c00-6f34-4e32-9c5e-50a8a46f1c90', 'normalized_reward', 'Primary raw scenario score.', NULL, NULL)
        ON CONFLICT(id) DO UPDATE SET key=EXCLUDED.key, description=EXCLUDED.description, agg_func=EXCLUDED.agg_func, agg_weights=EXCLUDED.agg_weights;

INSERT INTO fields
        (id, key, description, agg_func, agg_weights)
        VALUES ('176b73f7-02ae-49ea-8d1d-f1214fb0bd5d', 'percentage_complete', 'Secondary raw scenario score.', NULL, NULL)
        ON CONFLICT(id) DO UPDATE SET key=EXCLUDED.key, description=EXCLUDED.description, agg_func=EXCLUDED.agg_func, agg_weights=EXCLUDED.agg_weights;

INSERT INTO scenarios
    (id, name, description, field_ids)
    VALUES ('643f87c4-fbd7-426d-8a37-489a32b989da', '643f87c4-fbd7-426d-8a37-489a32b989da', '643f87c4-fbd7-426d-8a37-489a32b989da', array['19d07c00-6f34-4e32-9c5e-50a8a46f1c90', '176b73f7-02ae-49ea-8d1d-f1214fb0bd5d']::uuid[])
    ON CONFLICT(id) DO UPDATE SET name=EXCLUDED.name, description=EXCLUDED.description, field_ids=EXCLUDED.field_ids;

INSERT INTO fields
        (id, key, description, agg_func, agg_weights)
        VALUES ('19d07c00-6f34-4e32-9c5e-50a8a46f1c90', 'normalized_reward', 'Primary raw scenario score.', NULL, NULL)
        ON CONFLICT(id) DO UPDATE SET key=EXCLUDED.key, description=EXCLUDED.description, agg_func=EXCLUDED.agg_func, agg_weights=EXCLUDED.agg_weights;

INSERT INTO fields
        (id, key, description, agg_func, agg_weights)
        VALUES ('176b73f7-02ae-49ea-8d1d-f1214fb0bd5d', 'percentage_complete', 'Secondary raw scenario score.', NULL, NULL)
        ON CONFLICT(id) DO UPDATE SET key=EXCLUDED.key, description=EXCLUDED.description, agg_func=EXCLUDED.agg_func, agg_weights=EXCLUDED.agg_weights;

INSERT INTO scenarios
    (id, name, description, field_ids)
    VALUES ('e2284e75-33c5-4ba8-a094-a7d98c7ba50d', 'e2284e75-33c5-4ba8-a094-a7d98c7ba50d', 'e2284e75-33c5-4ba8-a094-a7d98c7ba50d', array['19d07c00-6f34-4e32-9c5e-50a8a46f1c90', '176b73f7-02ae-49ea-8d1d-f1214fb0bd5d']::uuid[])
    ON CONFLICT(id) DO UPDATE SET name=EXCLUDED.name, description=EXCLUDED.description, field_ids=EXCLUDED.field_ids;

INSERT INTO fields
        (id, key, description, agg_func, agg_weights)
        VALUES ('19d07c00-6f34-4e32-9c5e-50a8a46f1c90', 'normalized_reward', 'Primary raw scenario score.', NULL, NULL)
        ON CONFLICT(id) DO UPDATE SET key=EXCLUDED.key, description=EXCLUDED.description, agg_func=EXCLUDED.agg_func, agg_weights=EXCLUDED.agg_weights;

INSERT INTO fields
        (id, key, description, agg_func, agg_weights)
        VALUES ('176b73f7-02ae-49ea-8d1d-f1214fb0bd5d', 'percentage_complete', 'Secondary raw scenario score.', NULL, NULL)
        ON CONFLICT(id) DO UPDATE SET key=EXCLUDED.key, description=EXCLUDED.description, agg_func=EXCLUDED.agg_func, agg_weights=EXCLUDED.agg_weights;

INSERT INTO scenarios
    (id, name, description, field_ids)
    VALUES ('2d24fb79-b9e9-49e5-a781-670b08800d6d', '2d24fb79-b9e9-49e5-a781-670b08800d6d', '2d24fb79-b9e9-49e5-a781-670b08800d6d', array['19d07c00-6f34-4e32-9c5e-50a8a46f1c90', '176b73f7-02ae-49ea-8d1d-f1214fb0bd5d']::uuid[])
    ON CONFLICT(id) DO UPDATE SET name=EXCLUDED.name, description=EXCLUDED.description, field_ids=EXCLUDED.field_ids;

INSERT INTO fields
        (id, key, description, agg_func, agg_weights)
        VALUES ('19d07c00-6f34-4e32-9c5e-50a8a46f1c90', 'normalized_reward', 'Primary raw scenario score.', NULL, NULL)
        ON CONFLICT(id) DO UPDATE SET key=EXCLUDED.key, description=EXCLUDED.description, agg_func=EXCLUDED.agg_func, agg_weights=EXCLUDED.agg_weights;

INSERT INTO fields
        (id, key, description, agg_func, agg_weights)
        VALUES ('176b73f7-02ae-49ea-8d1d-f1214fb0bd5d', 'percentage_complete', 'Secondary raw scenario score.', NULL, NULL)
        ON CONFLICT(id) DO UPDATE SET key=EXCLUDED.key, description=EXCLUDED.description, agg_func=EXCLUDED.agg_func, agg_weights=EXCLUDED.agg_weights;

INSERT INTO scenarios
    (id, name, description, field_ids)
    VALUES ('9838248b-9440-4edf-a737-0bb571a9dfb4', '9838248b-9440-4edf-a737-0bb571a9dfb4', '9838248b-9440-4edf-a737-0bb571a9dfb4', array['19d07c00-6f34-4e32-9c5e-50a8a46f1c90', '176b73f7-02ae-49ea-8d1d-f1214fb0bd5d']::uuid[])
    ON CONFLICT(id) DO UPDATE SET name=EXCLUDED.name, description=EXCLUDED.description, field_ids=EXCLUDED.field_ids;

INSERT INTO fields
        (id, key, description, agg_func, agg_weights)
        VALUES ('19d07c00-6f34-4e32-9c5e-50a8a46f1c90', 'normalized_reward', 'Primary raw scenario score.', NULL, NULL)
        ON CONFLICT(id) DO UPDATE SET key=EXCLUDED.key, description=EXCLUDED.description, agg_func=EXCLUDED.agg_func, agg_weights=EXCLUDED.agg_weights;

INSERT INTO fields
        (id, key, description, agg_func, agg_weights)
        VALUES ('176b73f7-02ae-49ea-8d1d-f1214fb0bd5d', 'percentage_complete', 'Secondary raw scenario score.', NULL, NULL)
        ON CONFLICT(id) DO UPDATE SET key=EXCLUDED.key, description=EXCLUDED.description, agg_func=EXCLUDED.agg_func, agg_weights=EXCLUDED.agg_weights;

INSERT INTO scenarios
    (id, name, description, field_ids)
    VALUES ('6639e91d-c96b-46ff-8ccf-09b02847abf3', '6639e91d-c96b-46ff-8ccf-09b02847abf3', '6639e91d-c96b-46ff-8ccf-09b02847abf3', array['19d07c00-6f34-4e32-9c5e-50a8a46f1c90', '176b73f7-02ae-49ea-8d1d-f1214fb0bd5d']::uuid[])
    ON CONFLICT(id) DO UPDATE SET name=EXCLUDED.name, description=EXCLUDED.description, field_ids=EXCLUDED.field_ids;

INSERT INTO fields
        (id, key, description, agg_func, agg_weights)
        VALUES ('19d07c00-6f34-4e32-9c5e-50a8a46f1c90', 'normalized_reward', 'Primary raw scenario score.', NULL, NULL)
        ON CONFLICT(id) DO UPDATE SET key=EXCLUDED.key, description=EXCLUDED.description, agg_func=EXCLUDED.agg_func, agg_weights=EXCLUDED.agg_weights;

INSERT INTO fields
        (id, key, description, agg_func, agg_weights)
        VALUES ('176b73f7-02ae-49ea-8d1d-f1214fb0bd5d', 'percentage_complete', 'Secondary raw scenario score.', NULL, NULL)
        ON CONFLICT(id) DO UPDATE SET key=EXCLUDED.key, description=EXCLUDED.description, agg_func=EXCLUDED.agg_func, agg_weights=EXCLUDED.agg_weights;

INSERT INTO scenarios
    (id, name, description, field_ids)
    VALUES ('6285df65-4c03-42bc-99d9-b56c646c1712', '6285df65-4c03-42bc-99d9-b56c646c1712', '6285df65-4c03-42bc-99d9-b56c646c1712', array['19d07c00-6f34-4e32-9c5e-50a8a46f1c90', '176b73f7-02ae-49ea-8d1d-f1214fb0bd5d']::uuid[])
    ON CONFLICT(id) DO UPDATE SET name=EXCLUDED.name, description=EXCLUDED.description, field_ids=EXCLUDED.field_ids;

INSERT INTO fields
        (id, key, description, agg_func, agg_weights)
        VALUES ('19d07c00-6f34-4e32-9c5e-50a8a46f1c90', 'normalized_reward', 'Primary raw scenario score.', NULL, NULL)
        ON CONFLICT(id) DO UPDATE SET key=EXCLUDED.key, description=EXCLUDED.description, agg_func=EXCLUDED.agg_func, agg_weights=EXCLUDED.agg_weights;

INSERT INTO fields
        (id, key, description, agg_func, agg_weights)
        VALUES ('176b73f7-02ae-49ea-8d1d-f1214fb0bd5d', 'percentage_complete', 'Secondary raw scenario score.', NULL, NULL)
        ON CONFLICT(id) DO UPDATE SET key=EXCLUDED.key, description=EXCLUDED.description, agg_func=EXCLUDED.agg_func, agg_weights=EXCLUDED.agg_weights;

INSERT INTO scenarios
    (id, name, description, field_ids)
    VALUES ('3f65387f-052a-4186-8c44-c957a7432631', '3f65387f-052a-4186-8c44-c957a7432631', '3f65387f-052a-4186-8c44-c957a7432631', array['19d07c00-6f34-4e32-9c5e-50a8a46f1c90', '176b73f7-02ae-49ea-8d1d-f1214fb0bd5d']::uuid[])
    ON CONFLICT(id) DO UPDATE SET name=EXCLUDED.name, description=EXCLUDED.description, field_ids=EXCLUDED.field_ids;

INSERT INTO fields
        (id, key, description, agg_func, agg_weights)
        VALUES ('19d07c00-6f34-4e32-9c5e-50a8a46f1c90', 'normalized_reward', 'Primary raw scenario score.', NULL, NULL)
        ON CONFLICT(id) DO UPDATE SET key=EXCLUDED.key, description=EXCLUDED.description, agg_func=EXCLUDED.agg_func, agg_weights=EXCLUDED.agg_weights;

INSERT INTO fields
        (id, key, description, agg_func, agg_weights)
        VALUES ('176b73f7-02ae-49ea-8d1d-f1214fb0bd5d', 'percentage_complete', 'Secondary raw scenario score.', NULL, NULL)
        ON CONFLICT(id) DO UPDATE SET key=EXCLUDED.key, description=EXCLUDED.description, agg_func=EXCLUDED.agg_func, agg_weights=EXCLUDED.agg_weights;

INSERT INTO tests
    (id, name, description, field_ids, scenario_ids, loop, queue)
    VALUES ('3beb68e9-464d-4fb9-962b-15552f1e5185', 'Test 7', 'Test 7: 80 agents,  40x60, 13', array['d1acf912-f71d-4ded-832c-e89cd272a0cc', 'd077454a-bba5-4798-90ed-4919d6f26e8b']::uuid[], array['d4746426-3158-48a0-bd9c-7d519aa0d0c1', '3c57145c-5b00-42c2-b2bb-e0dafa95dc25', 'db2a7727-0600-4ccf-94d8-08439820296a', '22bda67d-6126-4697-a2ad-55e54eef8268', 'dd4c3c50-7ebe-4613-ba3f-48cc8625fc1d', 'bbd8f606-cc5c-4a02-b59e-08bd6567b8b4', '7aaef47c-7afa-4f3b-aba8-0699e62c62d5', 'a11e0c70-edb2-4589-b311-ff79c4b8d481', 'ef3e0e89-6262-4c4d-af58-a40e28b39d0a', '7ea32c28-f50e-4829-b61e-2bfca9e96f50']::uuid[], 'CLOSED', NULL)
    ON CONFLICT(id) DO UPDATE SET name=EXCLUDED.name, description=EXCLUDED.description, field_ids=EXCLUDED.field_ids, scenario_ids=EXCLUDED.scenario_ids, loop=EXCLUDED.loop, queue=EXCLUDED.queue;

INSERT INTO fields
        (id, key, description, agg_func, agg_weights)
        VALUES ('d1acf912-f71d-4ded-832c-e89cd272a0cc', 'normalized_reward', 'Primary test score (NANSUM of corresponding scenario scores)', 'NANSUM', NULL)
        ON CONFLICT(id) DO UPDATE SET key=EXCLUDED.key, description=EXCLUDED.description, agg_func=EXCLUDED.agg_func, agg_weights=EXCLUDED.agg_weights;

INSERT INTO fields
        (id, key, description, agg_func, agg_weights)
        VALUES ('d077454a-bba5-4798-90ed-4919d6f26e8b', 'percentage_complete', 'Secondary test score (NANMEAN of corresponding scenario scores)', 'NANMEAN', NULL)
        ON CONFLICT(id) DO UPDATE SET key=EXCLUDED.key, description=EXCLUDED.description, agg_func=EXCLUDED.agg_func, agg_weights=EXCLUDED.agg_weights;

INSERT INTO scenarios
    (id, name, description, field_ids)
    VALUES ('d4746426-3158-48a0-bd9c-7d519aa0d0c1', 'd4746426-3158-48a0-bd9c-7d519aa0d0c1', 'd4746426-3158-48a0-bd9c-7d519aa0d0c1', array['19d07c00-6f34-4e32-9c5e-50a8a46f1c90', '176b73f7-02ae-49ea-8d1d-f1214fb0bd5d']::uuid[])
    ON CONFLICT(id) DO UPDATE SET name=EXCLUDED.name, description=EXCLUDED.description, field_ids=EXCLUDED.field_ids;

INSERT INTO fields
        (id, key, description, agg_func, agg_weights)
        VALUES ('19d07c00-6f34-4e32-9c5e-50a8a46f1c90', 'normalized_reward', 'Primary raw scenario score.', NULL, NULL)
        ON CONFLICT(id) DO UPDATE SET key=EXCLUDED.key, description=EXCLUDED.description, agg_func=EXCLUDED.agg_func, agg_weights=EXCLUDED.agg_weights;

INSERT INTO fields
        (id, key, description, agg_func, agg_weights)
        VALUES ('176b73f7-02ae-49ea-8d1d-f1214fb0bd5d', 'percentage_complete', 'Secondary raw scenario score.', NULL, NULL)
        ON CONFLICT(id) DO UPDATE SET key=EXCLUDED.key, description=EXCLUDED.description, agg_func=EXCLUDED.agg_func, agg_weights=EXCLUDED.agg_weights;

INSERT INTO scenarios
    (id, name, description, field_ids)
    VALUES ('3c57145c-5b00-42c2-b2bb-e0dafa95dc25', '3c57145c-5b00-42c2-b2bb-e0dafa95dc25', '3c57145c-5b00-42c2-b2bb-e0dafa95dc25', array['19d07c00-6f34-4e32-9c5e-50a8a46f1c90', '176b73f7-02ae-49ea-8d1d-f1214fb0bd5d']::uuid[])
    ON CONFLICT(id) DO UPDATE SET name=EXCLUDED.name, description=EXCLUDED.description, field_ids=EXCLUDED.field_ids;

INSERT INTO fields
        (id, key, description, agg_func, agg_weights)
        VALUES ('19d07c00-6f34-4e32-9c5e-50a8a46f1c90', 'normalized_reward', 'Primary raw scenario score.', NULL, NULL)
        ON CONFLICT(id) DO UPDATE SET key=EXCLUDED.key, description=EXCLUDED.description, agg_func=EXCLUDED.agg_func, agg_weights=EXCLUDED.agg_weights;

INSERT INTO fields
        (id, key, description, agg_func, agg_weights)
        VALUES ('176b73f7-02ae-49ea-8d1d-f1214fb0bd5d', 'percentage_complete', 'Secondary raw scenario score.', NULL, NULL)
        ON CONFLICT(id) DO UPDATE SET key=EXCLUDED.key, description=EXCLUDED.description, agg_func=EXCLUDED.agg_func, agg_weights=EXCLUDED.agg_weights;

INSERT INTO scenarios
    (id, name, description, field_ids)
    VALUES ('db2a7727-0600-4ccf-94d8-08439820296a', 'db2a7727-0600-4ccf-94d8-08439820296a', 'db2a7727-0600-4ccf-94d8-08439820296a', array['19d07c00-6f34-4e32-9c5e-50a8a46f1c90', '176b73f7-02ae-49ea-8d1d-f1214fb0bd5d']::uuid[])
    ON CONFLICT(id) DO UPDATE SET name=EXCLUDED.name, description=EXCLUDED.description, field_ids=EXCLUDED.field_ids;

INSERT INTO fields
        (id, key, description, agg_func, agg_weights)
        VALUES ('19d07c00-6f34-4e32-9c5e-50a8a46f1c90', 'normalized_reward', 'Primary raw scenario score.', NULL, NULL)
        ON CONFLICT(id) DO UPDATE SET key=EXCLUDED.key, description=EXCLUDED.description, agg_func=EXCLUDED.agg_func, agg_weights=EXCLUDED.agg_weights;

INSERT INTO fields
        (id, key, description, agg_func, agg_weights)
        VALUES ('176b73f7-02ae-49ea-8d1d-f1214fb0bd5d', 'percentage_complete', 'Secondary raw scenario score.', NULL, NULL)
        ON CONFLICT(id) DO UPDATE SET key=EXCLUDED.key, description=EXCLUDED.description, agg_func=EXCLUDED.agg_func, agg_weights=EXCLUDED.agg_weights;

INSERT INTO scenarios
    (id, name, description, field_ids)
    VALUES ('22bda67d-6126-4697-a2ad-55e54eef8268', '22bda67d-6126-4697-a2ad-55e54eef8268', '22bda67d-6126-4697-a2ad-55e54eef8268', array['19d07c00-6f34-4e32-9c5e-50a8a46f1c90', '176b73f7-02ae-49ea-8d1d-f1214fb0bd5d']::uuid[])
    ON CONFLICT(id) DO UPDATE SET name=EXCLUDED.name, description=EXCLUDED.description, field_ids=EXCLUDED.field_ids;

INSERT INTO fields
        (id, key, description, agg_func, agg_weights)
        VALUES ('19d07c00-6f34-4e32-9c5e-50a8a46f1c90', 'normalized_reward', 'Primary raw scenario score.', NULL, NULL)
        ON CONFLICT(id) DO UPDATE SET key=EXCLUDED.key, description=EXCLUDED.description, agg_func=EXCLUDED.agg_func, agg_weights=EXCLUDED.agg_weights;

INSERT INTO fields
        (id, key, description, agg_func, agg_weights)
        VALUES ('176b73f7-02ae-49ea-8d1d-f1214fb0bd5d', 'percentage_complete', 'Secondary raw scenario score.', NULL, NULL)
        ON CONFLICT(id) DO UPDATE SET key=EXCLUDED.key, description=EXCLUDED.description, agg_func=EXCLUDED.agg_func, agg_weights=EXCLUDED.agg_weights;

INSERT INTO scenarios
    (id, name, description, field_ids)
    VALUES ('dd4c3c50-7ebe-4613-ba3f-48cc8625fc1d', 'dd4c3c50-7ebe-4613-ba3f-48cc8625fc1d', 'dd4c3c50-7ebe-4613-ba3f-48cc8625fc1d', array['19d07c00-6f34-4e32-9c5e-50a8a46f1c90', '176b73f7-02ae-49ea-8d1d-f1214fb0bd5d']::uuid[])
    ON CONFLICT(id) DO UPDATE SET name=EXCLUDED.name, description=EXCLUDED.description, field_ids=EXCLUDED.field_ids;

INSERT INTO fields
        (id, key, description, agg_func, agg_weights)
        VALUES ('19d07c00-6f34-4e32-9c5e-50a8a46f1c90', 'normalized_reward', 'Primary raw scenario score.', NULL, NULL)
        ON CONFLICT(id) DO UPDATE SET key=EXCLUDED.key, description=EXCLUDED.description, agg_func=EXCLUDED.agg_func, agg_weights=EXCLUDED.agg_weights;

INSERT INTO fields
        (id, key, description, agg_func, agg_weights)
        VALUES ('176b73f7-02ae-49ea-8d1d-f1214fb0bd5d', 'percentage_complete', 'Secondary raw scenario score.', NULL, NULL)
        ON CONFLICT(id) DO UPDATE SET key=EXCLUDED.key, description=EXCLUDED.description, agg_func=EXCLUDED.agg_func, agg_weights=EXCLUDED.agg_weights;

INSERT INTO scenarios
    (id, name, description, field_ids)
    VALUES ('bbd8f606-cc5c-4a02-b59e-08bd6567b8b4', 'bbd8f606-cc5c-4a02-b59e-08bd6567b8b4', 'bbd8f606-cc5c-4a02-b59e-08bd6567b8b4', array['19d07c00-6f34-4e32-9c5e-50a8a46f1c90', '176b73f7-02ae-49ea-8d1d-f1214fb0bd5d']::uuid[])
    ON CONFLICT(id) DO UPDATE SET name=EXCLUDED.name, description=EXCLUDED.description, field_ids=EXCLUDED.field_ids;

INSERT INTO fields
        (id, key, description, agg_func, agg_weights)
        VALUES ('19d07c00-6f34-4e32-9c5e-50a8a46f1c90', 'normalized_reward', 'Primary raw scenario score.', NULL, NULL)
        ON CONFLICT(id) DO UPDATE SET key=EXCLUDED.key, description=EXCLUDED.description, agg_func=EXCLUDED.agg_func, agg_weights=EXCLUDED.agg_weights;

INSERT INTO fields
        (id, key, description, agg_func, agg_weights)
        VALUES ('176b73f7-02ae-49ea-8d1d-f1214fb0bd5d', 'percentage_complete', 'Secondary raw scenario score.', NULL, NULL)
        ON CONFLICT(id) DO UPDATE SET key=EXCLUDED.key, description=EXCLUDED.description, agg_func=EXCLUDED.agg_func, agg_weights=EXCLUDED.agg_weights;

INSERT INTO scenarios
    (id, name, description, field_ids)
    VALUES ('7aaef47c-7afa-4f3b-aba8-0699e62c62d5', '7aaef47c-7afa-4f3b-aba8-0699e62c62d5', '7aaef47c-7afa-4f3b-aba8-0699e62c62d5', array['19d07c00-6f34-4e32-9c5e-50a8a46f1c90', '176b73f7-02ae-49ea-8d1d-f1214fb0bd5d']::uuid[])
    ON CONFLICT(id) DO UPDATE SET name=EXCLUDED.name, description=EXCLUDED.description, field_ids=EXCLUDED.field_ids;

INSERT INTO fields
        (id, key, description, agg_func, agg_weights)
        VALUES ('19d07c00-6f34-4e32-9c5e-50a8a46f1c90', 'normalized_reward', 'Primary raw scenario score.', NULL, NULL)
        ON CONFLICT(id) DO UPDATE SET key=EXCLUDED.key, description=EXCLUDED.description, agg_func=EXCLUDED.agg_func, agg_weights=EXCLUDED.agg_weights;

INSERT INTO fields
        (id, key, description, agg_func, agg_weights)
        VALUES ('176b73f7-02ae-49ea-8d1d-f1214fb0bd5d', 'percentage_complete', 'Secondary raw scenario score.', NULL, NULL)
        ON CONFLICT(id) DO UPDATE SET key=EXCLUDED.key, description=EXCLUDED.description, agg_func=EXCLUDED.agg_func, agg_weights=EXCLUDED.agg_weights;

INSERT INTO scenarios
    (id, name, description, field_ids)
    VALUES ('a11e0c70-edb2-4589-b311-ff79c4b8d481', 'a11e0c70-edb2-4589-b311-ff79c4b8d481', 'a11e0c70-edb2-4589-b311-ff79c4b8d481', array['19d07c00-6f34-4e32-9c5e-50a8a46f1c90', '176b73f7-02ae-49ea-8d1d-f1214fb0bd5d']::uuid[])
    ON CONFLICT(id) DO UPDATE SET name=EXCLUDED.name, description=EXCLUDED.description, field_ids=EXCLUDED.field_ids;

INSERT INTO fields
        (id, key, description, agg_func, agg_weights)
        VALUES ('19d07c00-6f34-4e32-9c5e-50a8a46f1c90', 'normalized_reward', 'Primary raw scenario score.', NULL, NULL)
        ON CONFLICT(id) DO UPDATE SET key=EXCLUDED.key, description=EXCLUDED.description, agg_func=EXCLUDED.agg_func, agg_weights=EXCLUDED.agg_weights;

INSERT INTO fields
        (id, key, description, agg_func, agg_weights)
        VALUES ('176b73f7-02ae-49ea-8d1d-f1214fb0bd5d', 'percentage_complete', 'Secondary raw scenario score.', NULL, NULL)
        ON CONFLICT(id) DO UPDATE SET key=EXCLUDED.key, description=EXCLUDED.description, agg_func=EXCLUDED.agg_func, agg_weights=EXCLUDED.agg_weights;

INSERT INTO scenarios
    (id, name, description, field_ids)
    VALUES ('ef3e0e89-6262-4c4d-af58-a40e28b39d0a', 'ef3e0e89-6262-4c4d-af58-a40e28b39d0a', 'ef3e0e89-6262-4c4d-af58-a40e28b39d0a', array['19d07c00-6f34-4e32-9c5e-50a8a46f1c90', '176b73f7-02ae-49ea-8d1d-f1214fb0bd5d']::uuid[])
    ON CONFLICT(id) DO UPDATE SET name=EXCLUDED.name, description=EXCLUDED.description, field_ids=EXCLUDED.field_ids;

INSERT INTO fields
        (id, key, description, agg_func, agg_weights)
        VALUES ('19d07c00-6f34-4e32-9c5e-50a8a46f1c90', 'normalized_reward', 'Primary raw scenario score.', NULL, NULL)
        ON CONFLICT(id) DO UPDATE SET key=EXCLUDED.key, description=EXCLUDED.description, agg_func=EXCLUDED.agg_func, agg_weights=EXCLUDED.agg_weights;

INSERT INTO fields
        (id, key, description, agg_func, agg_weights)
        VALUES ('176b73f7-02ae-49ea-8d1d-f1214fb0bd5d', 'percentage_complete', 'Secondary raw scenario score.', NULL, NULL)
        ON CONFLICT(id) DO UPDATE SET key=EXCLUDED.key, description=EXCLUDED.description, agg_func=EXCLUDED.agg_func, agg_weights=EXCLUDED.agg_weights;

INSERT INTO scenarios
    (id, name, description, field_ids)
    VALUES ('7ea32c28-f50e-4829-b61e-2bfca9e96f50', '7ea32c28-f50e-4829-b61e-2bfca9e96f50', '7ea32c28-f50e-4829-b61e-2bfca9e96f50', array['19d07c00-6f34-4e32-9c5e-50a8a46f1c90', '176b73f7-02ae-49ea-8d1d-f1214fb0bd5d']::uuid[])
    ON CONFLICT(id) DO UPDATE SET name=EXCLUDED.name, description=EXCLUDED.description, field_ids=EXCLUDED.field_ids;

INSERT INTO fields
        (id, key, description, agg_func, agg_weights)
        VALUES ('19d07c00-6f34-4e32-9c5e-50a8a46f1c90', 'normalized_reward', 'Primary raw scenario score.', NULL, NULL)
        ON CONFLICT(id) DO UPDATE SET key=EXCLUDED.key, description=EXCLUDED.description, agg_func=EXCLUDED.agg_func, agg_weights=EXCLUDED.agg_weights;

INSERT INTO fields
        (id, key, description, agg_func, agg_weights)
        VALUES ('176b73f7-02ae-49ea-8d1d-f1214fb0bd5d', 'percentage_complete', 'Secondary raw scenario score.', NULL, NULL)
        ON CONFLICT(id) DO UPDATE SET key=EXCLUDED.key, description=EXCLUDED.description, agg_func=EXCLUDED.agg_func, agg_weights=EXCLUDED.agg_weights;

INSERT INTO tests
    (id, name, description, field_ids, scenario_ids, loop, queue)
    VALUES ('0036e4d8-ec52-4471-8639-ee410037e56e', 'Test 8', 'Test 8: 80 agents,  60x60, 17', array['d1acf912-f71d-4ded-832c-e89cd272a0cc', 'd077454a-bba5-4798-90ed-4919d6f26e8b']::uuid[], array['e34dc827-57d0-4302-8afa-6ba124d0ed17', 'a618073a-00b8-4b64-b831-649ea1470e2a', 'be362322-0762-406c-a4b5-7de55c315432', 'fa7126ad-c252-4212-8db4-dcab5c0b768a', '444ccd34-db33-44c7-97d6-95e58068d1d9', '803e1f24-87ac-44fd-b6b6-735326fc6d28', '2f4adf26-27e0-4f4a-9a04-02fe7b428aa9', 'bdc2096b-65dc-4a60-bb91-074e8f9652f3', 'e441abf3-d54a-42fa-bb90-7e57408511c4', 'fe65c3bc-55cc-4a9a-bfd4-78ad2b6f7e13']::uuid[], 'CLOSED', NULL)
    ON CONFLICT(id) DO UPDATE SET name=EXCLUDED.name, description=EXCLUDED.description, field_ids=EXCLUDED.field_ids, scenario_ids=EXCLUDED.scenario_ids, loop=EXCLUDED.loop, queue=EXCLUDED.queue;

INSERT INTO fields
        (id, key, description, agg_func, agg_weights)
        VALUES ('d1acf912-f71d-4ded-832c-e89cd272a0cc', 'normalized_reward', 'Primary test score (NANSUM of corresponding scenario scores)', 'NANSUM', NULL)
        ON CONFLICT(id) DO UPDATE SET key=EXCLUDED.key, description=EXCLUDED.description, agg_func=EXCLUDED.agg_func, agg_weights=EXCLUDED.agg_weights;

INSERT INTO fields
        (id, key, description, agg_func, agg_weights)
        VALUES ('d077454a-bba5-4798-90ed-4919d6f26e8b', 'percentage_complete', 'Secondary test score (NANMEAN of corresponding scenario scores)', 'NANMEAN', NULL)
        ON CONFLICT(id) DO UPDATE SET key=EXCLUDED.key, description=EXCLUDED.description, agg_func=EXCLUDED.agg_func, agg_weights=EXCLUDED.agg_weights;

INSERT INTO scenarios
    (id, name, description, field_ids)
    VALUES ('e34dc827-57d0-4302-8afa-6ba124d0ed17', 'e34dc827-57d0-4302-8afa-6ba124d0ed17', 'e34dc827-57d0-4302-8afa-6ba124d0ed17', array['19d07c00-6f34-4e32-9c5e-50a8a46f1c90', '176b73f7-02ae-49ea-8d1d-f1214fb0bd5d']::uuid[])
    ON CONFLICT(id) DO UPDATE SET name=EXCLUDED.name, description=EXCLUDED.description, field_ids=EXCLUDED.field_ids;

INSERT INTO fields
        (id, key, description, agg_func, agg_weights)
        VALUES ('19d07c00-6f34-4e32-9c5e-50a8a46f1c90', 'normalized_reward', 'Primary raw scenario score.', NULL, NULL)
        ON CONFLICT(id) DO UPDATE SET key=EXCLUDED.key, description=EXCLUDED.description, agg_func=EXCLUDED.agg_func, agg_weights=EXCLUDED.agg_weights;

INSERT INTO fields
        (id, key, description, agg_func, agg_weights)
        VALUES ('176b73f7-02ae-49ea-8d1d-f1214fb0bd5d', 'percentage_complete', 'Secondary raw scenario score.', NULL, NULL)
        ON CONFLICT(id) DO UPDATE SET key=EXCLUDED.key, description=EXCLUDED.description, agg_func=EXCLUDED.agg_func, agg_weights=EXCLUDED.agg_weights;

INSERT INTO scenarios
    (id, name, description, field_ids)
    VALUES ('a618073a-00b8-4b64-b831-649ea1470e2a', 'a618073a-00b8-4b64-b831-649ea1470e2a', 'a618073a-00b8-4b64-b831-649ea1470e2a', array['19d07c00-6f34-4e32-9c5e-50a8a46f1c90', '176b73f7-02ae-49ea-8d1d-f1214fb0bd5d']::uuid[])
    ON CONFLICT(id) DO UPDATE SET name=EXCLUDED.name, description=EXCLUDED.description, field_ids=EXCLUDED.field_ids;

INSERT INTO fields
        (id, key, description, agg_func, agg_weights)
        VALUES ('19d07c00-6f34-4e32-9c5e-50a8a46f1c90', 'normalized_reward', 'Primary raw scenario score.', NULL, NULL)
        ON CONFLICT(id) DO UPDATE SET key=EXCLUDED.key, description=EXCLUDED.description, agg_func=EXCLUDED.agg_func, agg_weights=EXCLUDED.agg_weights;

INSERT INTO fields
        (id, key, description, agg_func, agg_weights)
        VALUES ('176b73f7-02ae-49ea-8d1d-f1214fb0bd5d', 'percentage_complete', 'Secondary raw scenario score.', NULL, NULL)
        ON CONFLICT(id) DO UPDATE SET key=EXCLUDED.key, description=EXCLUDED.description, agg_func=EXCLUDED.agg_func, agg_weights=EXCLUDED.agg_weights;

INSERT INTO scenarios
    (id, name, description, field_ids)
    VALUES ('be362322-0762-406c-a4b5-7de55c315432', 'be362322-0762-406c-a4b5-7de55c315432', 'be362322-0762-406c-a4b5-7de55c315432', array['19d07c00-6f34-4e32-9c5e-50a8a46f1c90', '176b73f7-02ae-49ea-8d1d-f1214fb0bd5d']::uuid[])
    ON CONFLICT(id) DO UPDATE SET name=EXCLUDED.name, description=EXCLUDED.description, field_ids=EXCLUDED.field_ids;

INSERT INTO fields
        (id, key, description, agg_func, agg_weights)
        VALUES ('19d07c00-6f34-4e32-9c5e-50a8a46f1c90', 'normalized_reward', 'Primary raw scenario score.', NULL, NULL)
        ON CONFLICT(id) DO UPDATE SET key=EXCLUDED.key, description=EXCLUDED.description, agg_func=EXCLUDED.agg_func, agg_weights=EXCLUDED.agg_weights;

INSERT INTO fields
        (id, key, description, agg_func, agg_weights)
        VALUES ('176b73f7-02ae-49ea-8d1d-f1214fb0bd5d', 'percentage_complete', 'Secondary raw scenario score.', NULL, NULL)
        ON CONFLICT(id) DO UPDATE SET key=EXCLUDED.key, description=EXCLUDED.description, agg_func=EXCLUDED.agg_func, agg_weights=EXCLUDED.agg_weights;

INSERT INTO scenarios
    (id, name, description, field_ids)
    VALUES ('fa7126ad-c252-4212-8db4-dcab5c0b768a', 'fa7126ad-c252-4212-8db4-dcab5c0b768a', 'fa7126ad-c252-4212-8db4-dcab5c0b768a', array['19d07c00-6f34-4e32-9c5e-50a8a46f1c90', '176b73f7-02ae-49ea-8d1d-f1214fb0bd5d']::uuid[])
    ON CONFLICT(id) DO UPDATE SET name=EXCLUDED.name, description=EXCLUDED.description, field_ids=EXCLUDED.field_ids;

INSERT INTO fields
        (id, key, description, agg_func, agg_weights)
        VALUES ('19d07c00-6f34-4e32-9c5e-50a8a46f1c90', 'normalized_reward', 'Primary raw scenario score.', NULL, NULL)
        ON CONFLICT(id) DO UPDATE SET key=EXCLUDED.key, description=EXCLUDED.description, agg_func=EXCLUDED.agg_func, agg_weights=EXCLUDED.agg_weights;

INSERT INTO fields
        (id, key, description, agg_func, agg_weights)
        VALUES ('176b73f7-02ae-49ea-8d1d-f1214fb0bd5d', 'percentage_complete', 'Secondary raw scenario score.', NULL, NULL)
        ON CONFLICT(id) DO UPDATE SET key=EXCLUDED.key, description=EXCLUDED.description, agg_func=EXCLUDED.agg_func, agg_weights=EXCLUDED.agg_weights;

INSERT INTO scenarios
    (id, name, description, field_ids)
    VALUES ('444ccd34-db33-44c7-97d6-95e58068d1d9', '444ccd34-db33-44c7-97d6-95e58068d1d9', '444ccd34-db33-44c7-97d6-95e58068d1d9', array['19d07c00-6f34-4e32-9c5e-50a8a46f1c90', '176b73f7-02ae-49ea-8d1d-f1214fb0bd5d']::uuid[])
    ON CONFLICT(id) DO UPDATE SET name=EXCLUDED.name, description=EXCLUDED.description, field_ids=EXCLUDED.field_ids;

INSERT INTO fields
        (id, key, description, agg_func, agg_weights)
        VALUES ('19d07c00-6f34-4e32-9c5e-50a8a46f1c90', 'normalized_reward', 'Primary raw scenario score.', NULL, NULL)
        ON CONFLICT(id) DO UPDATE SET key=EXCLUDED.key, description=EXCLUDED.description, agg_func=EXCLUDED.agg_func, agg_weights=EXCLUDED.agg_weights;

INSERT INTO fields
        (id, key, description, agg_func, agg_weights)
        VALUES ('176b73f7-02ae-49ea-8d1d-f1214fb0bd5d', 'percentage_complete', 'Secondary raw scenario score.', NULL, NULL)
        ON CONFLICT(id) DO UPDATE SET key=EXCLUDED.key, description=EXCLUDED.description, agg_func=EXCLUDED.agg_func, agg_weights=EXCLUDED.agg_weights;

INSERT INTO scenarios
    (id, name, description, field_ids)
    VALUES ('803e1f24-87ac-44fd-b6b6-735326fc6d28', '803e1f24-87ac-44fd-b6b6-735326fc6d28', '803e1f24-87ac-44fd-b6b6-735326fc6d28', array['19d07c00-6f34-4e32-9c5e-50a8a46f1c90', '176b73f7-02ae-49ea-8d1d-f1214fb0bd5d']::uuid[])
    ON CONFLICT(id) DO UPDATE SET name=EXCLUDED.name, description=EXCLUDED.description, field_ids=EXCLUDED.field_ids;

INSERT INTO fields
        (id, key, description, agg_func, agg_weights)
        VALUES ('19d07c00-6f34-4e32-9c5e-50a8a46f1c90', 'normalized_reward', 'Primary raw scenario score.', NULL, NULL)
        ON CONFLICT(id) DO UPDATE SET key=EXCLUDED.key, description=EXCLUDED.description, agg_func=EXCLUDED.agg_func, agg_weights=EXCLUDED.agg_weights;

INSERT INTO fields
        (id, key, description, agg_func, agg_weights)
        VALUES ('176b73f7-02ae-49ea-8d1d-f1214fb0bd5d', 'percentage_complete', 'Secondary raw scenario score.', NULL, NULL)
        ON CONFLICT(id) DO UPDATE SET key=EXCLUDED.key, description=EXCLUDED.description, agg_func=EXCLUDED.agg_func, agg_weights=EXCLUDED.agg_weights;

INSERT INTO scenarios
    (id, name, description, field_ids)
    VALUES ('2f4adf26-27e0-4f4a-9a04-02fe7b428aa9', '2f4adf26-27e0-4f4a-9a04-02fe7b428aa9', '2f4adf26-27e0-4f4a-9a04-02fe7b428aa9', array['19d07c00-6f34-4e32-9c5e-50a8a46f1c90', '176b73f7-02ae-49ea-8d1d-f1214fb0bd5d']::uuid[])
    ON CONFLICT(id) DO UPDATE SET name=EXCLUDED.name, description=EXCLUDED.description, field_ids=EXCLUDED.field_ids;

INSERT INTO fields
        (id, key, description, agg_func, agg_weights)
        VALUES ('19d07c00-6f34-4e32-9c5e-50a8a46f1c90', 'normalized_reward', 'Primary raw scenario score.', NULL, NULL)
        ON CONFLICT(id) DO UPDATE SET key=EXCLUDED.key, description=EXCLUDED.description, agg_func=EXCLUDED.agg_func, agg_weights=EXCLUDED.agg_weights;

INSERT INTO fields
        (id, key, description, agg_func, agg_weights)
        VALUES ('176b73f7-02ae-49ea-8d1d-f1214fb0bd5d', 'percentage_complete', 'Secondary raw scenario score.', NULL, NULL)
        ON CONFLICT(id) DO UPDATE SET key=EXCLUDED.key, description=EXCLUDED.description, agg_func=EXCLUDED.agg_func, agg_weights=EXCLUDED.agg_weights;

INSERT INTO scenarios
    (id, name, description, field_ids)
    VALUES ('bdc2096b-65dc-4a60-bb91-074e8f9652f3', 'bdc2096b-65dc-4a60-bb91-074e8f9652f3', 'bdc2096b-65dc-4a60-bb91-074e8f9652f3', array['19d07c00-6f34-4e32-9c5e-50a8a46f1c90', '176b73f7-02ae-49ea-8d1d-f1214fb0bd5d']::uuid[])
    ON CONFLICT(id) DO UPDATE SET name=EXCLUDED.name, description=EXCLUDED.description, field_ids=EXCLUDED.field_ids;

INSERT INTO fields
        (id, key, description, agg_func, agg_weights)
        VALUES ('19d07c00-6f34-4e32-9c5e-50a8a46f1c90', 'normalized_reward', 'Primary raw scenario score.', NULL, NULL)
        ON CONFLICT(id) DO UPDATE SET key=EXCLUDED.key, description=EXCLUDED.description, agg_func=EXCLUDED.agg_func, agg_weights=EXCLUDED.agg_weights;

INSERT INTO fields
        (id, key, description, agg_func, agg_weights)
        VALUES ('176b73f7-02ae-49ea-8d1d-f1214fb0bd5d', 'percentage_complete', 'Secondary raw scenario score.', NULL, NULL)
        ON CONFLICT(id) DO UPDATE SET key=EXCLUDED.key, description=EXCLUDED.description, agg_func=EXCLUDED.agg_func, agg_weights=EXCLUDED.agg_weights;

INSERT INTO scenarios
    (id, name, description, field_ids)
    VALUES ('e441abf3-d54a-42fa-bb90-7e57408511c4', 'e441abf3-d54a-42fa-bb90-7e57408511c4', 'e441abf3-d54a-42fa-bb90-7e57408511c4', array['19d07c00-6f34-4e32-9c5e-50a8a46f1c90', '176b73f7-02ae-49ea-8d1d-f1214fb0bd5d']::uuid[])
    ON CONFLICT(id) DO UPDATE SET name=EXCLUDED.name, description=EXCLUDED.description, field_ids=EXCLUDED.field_ids;

INSERT INTO fields
        (id, key, description, agg_func, agg_weights)
        VALUES ('19d07c00-6f34-4e32-9c5e-50a8a46f1c90', 'normalized_reward', 'Primary raw scenario score.', NULL, NULL)
        ON CONFLICT(id) DO UPDATE SET key=EXCLUDED.key, description=EXCLUDED.description, agg_func=EXCLUDED.agg_func, agg_weights=EXCLUDED.agg_weights;

INSERT INTO fields
        (id, key, description, agg_func, agg_weights)
        VALUES ('176b73f7-02ae-49ea-8d1d-f1214fb0bd5d', 'percentage_complete', 'Secondary raw scenario score.', NULL, NULL)
        ON CONFLICT(id) DO UPDATE SET key=EXCLUDED.key, description=EXCLUDED.description, agg_func=EXCLUDED.agg_func, agg_weights=EXCLUDED.agg_weights;

INSERT INTO scenarios
    (id, name, description, field_ids)
    VALUES ('fe65c3bc-55cc-4a9a-bfd4-78ad2b6f7e13', 'fe65c3bc-55cc-4a9a-bfd4-78ad2b6f7e13', 'fe65c3bc-55cc-4a9a-bfd4-78ad2b6f7e13', array['19d07c00-6f34-4e32-9c5e-50a8a46f1c90', '176b73f7-02ae-49ea-8d1d-f1214fb0bd5d']::uuid[])
    ON CONFLICT(id) DO UPDATE SET name=EXCLUDED.name, description=EXCLUDED.description, field_ids=EXCLUDED.field_ids;

INSERT INTO fields
        (id, key, description, agg_func, agg_weights)
        VALUES ('19d07c00-6f34-4e32-9c5e-50a8a46f1c90', 'normalized_reward', 'Primary raw scenario score.', NULL, NULL)
        ON CONFLICT(id) DO UPDATE SET key=EXCLUDED.key, description=EXCLUDED.description, agg_func=EXCLUDED.agg_func, agg_weights=EXCLUDED.agg_weights;

INSERT INTO fields
        (id, key, description, agg_func, agg_weights)
        VALUES ('176b73f7-02ae-49ea-8d1d-f1214fb0bd5d', 'percentage_complete', 'Secondary raw scenario score.', NULL, NULL)
        ON CONFLICT(id) DO UPDATE SET key=EXCLUDED.key, description=EXCLUDED.description, agg_func=EXCLUDED.agg_func, agg_weights=EXCLUDED.agg_weights;

INSERT INTO tests
    (id, name, description, field_ids, scenario_ids, loop, queue)
    VALUES ('c69e9baf-6903-40a5-90ed-8a6ace77c20b', 'Test 9', 'Test 9: 100 agents,  120x80, 21', array['d1acf912-f71d-4ded-832c-e89cd272a0cc', 'd077454a-bba5-4798-90ed-4919d6f26e8b']::uuid[], array['01ab5e33-30ef-423b-8f95-abcea8f3ce38', 'eed70e25-3940-469c-b7d8-ec80826108cd', 'c8353dd3-9c7d-44d6-a255-1e94d7fe6021', '11d27167-2e2a-499c-a3ee-d19a033b95a1', 'd36802a3-89cb-4e05-bb3c-429e9942fe89', '7183cea7-a755-4873-ba97-d35e461040db', '260924ef-970e-423b-95fb-d6ada627113b', 'fccfb900-2b3b-46e2-a878-5c466d5e8e80', '7e5fa86f-9a9b-4827-8876-6d73e296de43', 'd42ee599-bd9f-49a2-8d21-78826eaf1b24']::uuid[], 'CLOSED', NULL)
    ON CONFLICT(id) DO UPDATE SET name=EXCLUDED.name, description=EXCLUDED.description, field_ids=EXCLUDED.field_ids, scenario_ids=EXCLUDED.scenario_ids, loop=EXCLUDED.loop, queue=EXCLUDED.queue;

INSERT INTO fields
        (id, key, description, agg_func, agg_weights)
        VALUES ('d1acf912-f71d-4ded-832c-e89cd272a0cc', 'normalized_reward', 'Primary test score (NANSUM of corresponding scenario scores)', 'NANSUM', NULL)
        ON CONFLICT(id) DO UPDATE SET key=EXCLUDED.key, description=EXCLUDED.description, agg_func=EXCLUDED.agg_func, agg_weights=EXCLUDED.agg_weights;

INSERT INTO fields
        (id, key, description, agg_func, agg_weights)
        VALUES ('d077454a-bba5-4798-90ed-4919d6f26e8b', 'percentage_complete', 'Secondary test score (NANMEAN of corresponding scenario scores)', 'NANMEAN', NULL)
        ON CONFLICT(id) DO UPDATE SET key=EXCLUDED.key, description=EXCLUDED.description, agg_func=EXCLUDED.agg_func, agg_weights=EXCLUDED.agg_weights;

INSERT INTO scenarios
    (id, name, description, field_ids)
    VALUES ('01ab5e33-30ef-423b-8f95-abcea8f3ce38', '01ab5e33-30ef-423b-8f95-abcea8f3ce38', '01ab5e33-30ef-423b-8f95-abcea8f3ce38', array['19d07c00-6f34-4e32-9c5e-50a8a46f1c90', '176b73f7-02ae-49ea-8d1d-f1214fb0bd5d']::uuid[])
    ON CONFLICT(id) DO UPDATE SET name=EXCLUDED.name, description=EXCLUDED.description, field_ids=EXCLUDED.field_ids;

INSERT INTO fields
        (id, key, description, agg_func, agg_weights)
        VALUES ('19d07c00-6f34-4e32-9c5e-50a8a46f1c90', 'normalized_reward', 'Primary raw scenario score.', NULL, NULL)
        ON CONFLICT(id) DO UPDATE SET key=EXCLUDED.key, description=EXCLUDED.description, agg_func=EXCLUDED.agg_func, agg_weights=EXCLUDED.agg_weights;

INSERT INTO fields
        (id, key, description, agg_func, agg_weights)
        VALUES ('176b73f7-02ae-49ea-8d1d-f1214fb0bd5d', 'percentage_complete', 'Secondary raw scenario score.', NULL, NULL)
        ON CONFLICT(id) DO UPDATE SET key=EXCLUDED.key, description=EXCLUDED.description, agg_func=EXCLUDED.agg_func, agg_weights=EXCLUDED.agg_weights;

INSERT INTO scenarios
    (id, name, description, field_ids)
    VALUES ('eed70e25-3940-469c-b7d8-ec80826108cd', 'eed70e25-3940-469c-b7d8-ec80826108cd', 'eed70e25-3940-469c-b7d8-ec80826108cd', array['19d07c00-6f34-4e32-9c5e-50a8a46f1c90', '176b73f7-02ae-49ea-8d1d-f1214fb0bd5d']::uuid[])
    ON CONFLICT(id) DO UPDATE SET name=EXCLUDED.name, description=EXCLUDED.description, field_ids=EXCLUDED.field_ids;

INSERT INTO fields
        (id, key, description, agg_func, agg_weights)
        VALUES ('19d07c00-6f34-4e32-9c5e-50a8a46f1c90', 'normalized_reward', 'Primary raw scenario score.', NULL, NULL)
        ON CONFLICT(id) DO UPDATE SET key=EXCLUDED.key, description=EXCLUDED.description, agg_func=EXCLUDED.agg_func, agg_weights=EXCLUDED.agg_weights;

INSERT INTO fields
        (id, key, description, agg_func, agg_weights)
        VALUES ('176b73f7-02ae-49ea-8d1d-f1214fb0bd5d', 'percentage_complete', 'Secondary raw scenario score.', NULL, NULL)
        ON CONFLICT(id) DO UPDATE SET key=EXCLUDED.key, description=EXCLUDED.description, agg_func=EXCLUDED.agg_func, agg_weights=EXCLUDED.agg_weights;

INSERT INTO scenarios
    (id, name, description, field_ids)
    VALUES ('c8353dd3-9c7d-44d6-a255-1e94d7fe6021', 'c8353dd3-9c7d-44d6-a255-1e94d7fe6021', 'c8353dd3-9c7d-44d6-a255-1e94d7fe6021', array['19d07c00-6f34-4e32-9c5e-50a8a46f1c90', '176b73f7-02ae-49ea-8d1d-f1214fb0bd5d']::uuid[])
    ON CONFLICT(id) DO UPDATE SET name=EXCLUDED.name, description=EXCLUDED.description, field_ids=EXCLUDED.field_ids;

INSERT INTO fields
        (id, key, description, agg_func, agg_weights)
        VALUES ('19d07c00-6f34-4e32-9c5e-50a8a46f1c90', 'normalized_reward', 'Primary raw scenario score.', NULL, NULL)
        ON CONFLICT(id) DO UPDATE SET key=EXCLUDED.key, description=EXCLUDED.description, agg_func=EXCLUDED.agg_func, agg_weights=EXCLUDED.agg_weights;

INSERT INTO fields
        (id, key, description, agg_func, agg_weights)
        VALUES ('176b73f7-02ae-49ea-8d1d-f1214fb0bd5d', 'percentage_complete', 'Secondary raw scenario score.', NULL, NULL)
        ON CONFLICT(id) DO UPDATE SET key=EXCLUDED.key, description=EXCLUDED.description, agg_func=EXCLUDED.agg_func, agg_weights=EXCLUDED.agg_weights;

INSERT INTO scenarios
    (id, name, description, field_ids)
    VALUES ('11d27167-2e2a-499c-a3ee-d19a033b95a1', '11d27167-2e2a-499c-a3ee-d19a033b95a1', '11d27167-2e2a-499c-a3ee-d19a033b95a1', array['19d07c00-6f34-4e32-9c5e-50a8a46f1c90', '176b73f7-02ae-49ea-8d1d-f1214fb0bd5d']::uuid[])
    ON CONFLICT(id) DO UPDATE SET name=EXCLUDED.name, description=EXCLUDED.description, field_ids=EXCLUDED.field_ids;

INSERT INTO fields
        (id, key, description, agg_func, agg_weights)
        VALUES ('19d07c00-6f34-4e32-9c5e-50a8a46f1c90', 'normalized_reward', 'Primary raw scenario score.', NULL, NULL)
        ON CONFLICT(id) DO UPDATE SET key=EXCLUDED.key, description=EXCLUDED.description, agg_func=EXCLUDED.agg_func, agg_weights=EXCLUDED.agg_weights;

INSERT INTO fields
        (id, key, description, agg_func, agg_weights)
        VALUES ('176b73f7-02ae-49ea-8d1d-f1214fb0bd5d', 'percentage_complete', 'Secondary raw scenario score.', NULL, NULL)
        ON CONFLICT(id) DO UPDATE SET key=EXCLUDED.key, description=EXCLUDED.description, agg_func=EXCLUDED.agg_func, agg_weights=EXCLUDED.agg_weights;

INSERT INTO scenarios
    (id, name, description, field_ids)
    VALUES ('d36802a3-89cb-4e05-bb3c-429e9942fe89', 'd36802a3-89cb-4e05-bb3c-429e9942fe89', 'd36802a3-89cb-4e05-bb3c-429e9942fe89', array['19d07c00-6f34-4e32-9c5e-50a8a46f1c90', '176b73f7-02ae-49ea-8d1d-f1214fb0bd5d']::uuid[])
    ON CONFLICT(id) DO UPDATE SET name=EXCLUDED.name, description=EXCLUDED.description, field_ids=EXCLUDED.field_ids;

INSERT INTO fields
        (id, key, description, agg_func, agg_weights)
        VALUES ('19d07c00-6f34-4e32-9c5e-50a8a46f1c90', 'normalized_reward', 'Primary raw scenario score.', NULL, NULL)
        ON CONFLICT(id) DO UPDATE SET key=EXCLUDED.key, description=EXCLUDED.description, agg_func=EXCLUDED.agg_func, agg_weights=EXCLUDED.agg_weights;

INSERT INTO fields
        (id, key, description, agg_func, agg_weights)
        VALUES ('176b73f7-02ae-49ea-8d1d-f1214fb0bd5d', 'percentage_complete', 'Secondary raw scenario score.', NULL, NULL)
        ON CONFLICT(id) DO UPDATE SET key=EXCLUDED.key, description=EXCLUDED.description, agg_func=EXCLUDED.agg_func, agg_weights=EXCLUDED.agg_weights;

INSERT INTO scenarios
    (id, name, description, field_ids)
    VALUES ('7183cea7-a755-4873-ba97-d35e461040db', '7183cea7-a755-4873-ba97-d35e461040db', '7183cea7-a755-4873-ba97-d35e461040db', array['19d07c00-6f34-4e32-9c5e-50a8a46f1c90', '176b73f7-02ae-49ea-8d1d-f1214fb0bd5d']::uuid[])
    ON CONFLICT(id) DO UPDATE SET name=EXCLUDED.name, description=EXCLUDED.description, field_ids=EXCLUDED.field_ids;

INSERT INTO fields
        (id, key, description, agg_func, agg_weights)
        VALUES ('19d07c00-6f34-4e32-9c5e-50a8a46f1c90', 'normalized_reward', 'Primary raw scenario score.', NULL, NULL)
        ON CONFLICT(id) DO UPDATE SET key=EXCLUDED.key, description=EXCLUDED.description, agg_func=EXCLUDED.agg_func, agg_weights=EXCLUDED.agg_weights;

INSERT INTO fields
        (id, key, description, agg_func, agg_weights)
        VALUES ('176b73f7-02ae-49ea-8d1d-f1214fb0bd5d', 'percentage_complete', 'Secondary raw scenario score.', NULL, NULL)
        ON CONFLICT(id) DO UPDATE SET key=EXCLUDED.key, description=EXCLUDED.description, agg_func=EXCLUDED.agg_func, agg_weights=EXCLUDED.agg_weights;

INSERT INTO scenarios
    (id, name, description, field_ids)
    VALUES ('260924ef-970e-423b-95fb-d6ada627113b', '260924ef-970e-423b-95fb-d6ada627113b', '260924ef-970e-423b-95fb-d6ada627113b', array['19d07c00-6f34-4e32-9c5e-50a8a46f1c90', '176b73f7-02ae-49ea-8d1d-f1214fb0bd5d']::uuid[])
    ON CONFLICT(id) DO UPDATE SET name=EXCLUDED.name, description=EXCLUDED.description, field_ids=EXCLUDED.field_ids;

INSERT INTO fields
        (id, key, description, agg_func, agg_weights)
        VALUES ('19d07c00-6f34-4e32-9c5e-50a8a46f1c90', 'normalized_reward', 'Primary raw scenario score.', NULL, NULL)
        ON CONFLICT(id) DO UPDATE SET key=EXCLUDED.key, description=EXCLUDED.description, agg_func=EXCLUDED.agg_func, agg_weights=EXCLUDED.agg_weights;

INSERT INTO fields
        (id, key, description, agg_func, agg_weights)
        VALUES ('176b73f7-02ae-49ea-8d1d-f1214fb0bd5d', 'percentage_complete', 'Secondary raw scenario score.', NULL, NULL)
        ON CONFLICT(id) DO UPDATE SET key=EXCLUDED.key, description=EXCLUDED.description, agg_func=EXCLUDED.agg_func, agg_weights=EXCLUDED.agg_weights;

INSERT INTO scenarios
    (id, name, description, field_ids)
    VALUES ('fccfb900-2b3b-46e2-a878-5c466d5e8e80', 'fccfb900-2b3b-46e2-a878-5c466d5e8e80', 'fccfb900-2b3b-46e2-a878-5c466d5e8e80', array['19d07c00-6f34-4e32-9c5e-50a8a46f1c90', '176b73f7-02ae-49ea-8d1d-f1214fb0bd5d']::uuid[])
    ON CONFLICT(id) DO UPDATE SET name=EXCLUDED.name, description=EXCLUDED.description, field_ids=EXCLUDED.field_ids;

INSERT INTO fields
        (id, key, description, agg_func, agg_weights)
        VALUES ('19d07c00-6f34-4e32-9c5e-50a8a46f1c90', 'normalized_reward', 'Primary raw scenario score.', NULL, NULL)
        ON CONFLICT(id) DO UPDATE SET key=EXCLUDED.key, description=EXCLUDED.description, agg_func=EXCLUDED.agg_func, agg_weights=EXCLUDED.agg_weights;

INSERT INTO fields
        (id, key, description, agg_func, agg_weights)
        VALUES ('176b73f7-02ae-49ea-8d1d-f1214fb0bd5d', 'percentage_complete', 'Secondary raw scenario score.', NULL, NULL)
        ON CONFLICT(id) DO UPDATE SET key=EXCLUDED.key, description=EXCLUDED.description, agg_func=EXCLUDED.agg_func, agg_weights=EXCLUDED.agg_weights;

INSERT INTO scenarios
    (id, name, description, field_ids)
    VALUES ('7e5fa86f-9a9b-4827-8876-6d73e296de43', '7e5fa86f-9a9b-4827-8876-6d73e296de43', '7e5fa86f-9a9b-4827-8876-6d73e296de43', array['19d07c00-6f34-4e32-9c5e-50a8a46f1c90', '176b73f7-02ae-49ea-8d1d-f1214fb0bd5d']::uuid[])
    ON CONFLICT(id) DO UPDATE SET name=EXCLUDED.name, description=EXCLUDED.description, field_ids=EXCLUDED.field_ids;

INSERT INTO fields
        (id, key, description, agg_func, agg_weights)
        VALUES ('19d07c00-6f34-4e32-9c5e-50a8a46f1c90', 'normalized_reward', 'Primary raw scenario score.', NULL, NULL)
        ON CONFLICT(id) DO UPDATE SET key=EXCLUDED.key, description=EXCLUDED.description, agg_func=EXCLUDED.agg_func, agg_weights=EXCLUDED.agg_weights;

INSERT INTO fields
        (id, key, description, agg_func, agg_weights)
        VALUES ('176b73f7-02ae-49ea-8d1d-f1214fb0bd5d', 'percentage_complete', 'Secondary raw scenario score.', NULL, NULL)
        ON CONFLICT(id) DO UPDATE SET key=EXCLUDED.key, description=EXCLUDED.description, agg_func=EXCLUDED.agg_func, agg_weights=EXCLUDED.agg_weights;

INSERT INTO scenarios
    (id, name, description, field_ids)
    VALUES ('d42ee599-bd9f-49a2-8d21-78826eaf1b24', 'd42ee599-bd9f-49a2-8d21-78826eaf1b24', 'd42ee599-bd9f-49a2-8d21-78826eaf1b24', array['19d07c00-6f34-4e32-9c5e-50a8a46f1c90', '176b73f7-02ae-49ea-8d1d-f1214fb0bd5d']::uuid[])
    ON CONFLICT(id) DO UPDATE SET name=EXCLUDED.name, description=EXCLUDED.description, field_ids=EXCLUDED.field_ids;

INSERT INTO fields
        (id, key, description, agg_func, agg_weights)
        VALUES ('19d07c00-6f34-4e32-9c5e-50a8a46f1c90', 'normalized_reward', 'Primary raw scenario score.', NULL, NULL)
        ON CONFLICT(id) DO UPDATE SET key=EXCLUDED.key, description=EXCLUDED.description, agg_func=EXCLUDED.agg_func, agg_weights=EXCLUDED.agg_weights;

INSERT INTO fields
        (id, key, description, agg_func, agg_weights)
        VALUES ('176b73f7-02ae-49ea-8d1d-f1214fb0bd5d', 'percentage_complete', 'Secondary raw scenario score.', NULL, NULL)
        ON CONFLICT(id) DO UPDATE SET key=EXCLUDED.key, description=EXCLUDED.description, agg_func=EXCLUDED.agg_func, agg_weights=EXCLUDED.agg_weights;

INSERT INTO tests
    (id, name, description, field_ids, scenario_ids, loop, queue)
    VALUES ('21e4c84a-9595-4c83-9c7f-29d1d11be0af', 'Test 10', 'Test 10: 100 agents,  80x100, 25', array['d1acf912-f71d-4ded-832c-e89cd272a0cc', 'd077454a-bba5-4798-90ed-4919d6f26e8b']::uuid[], array['f07c0a83-6a5b-4b38-8c46-18451a9cf704', '213037ae-d645-41d8-8b84-e6c08b5837f1', 'b1635abf-3877-4ed9-ab6e-74e49d6c8a97', '4b4c5137-0cf9-41f7-882e-462a57c9b642', '0645d6af-042d-4466-8bbe-d3698478059c', '8a65f839-4c2b-4a75-bb82-29c03c0527ed', '477099b1-b31a-4475-8504-0ce6e7d21360', '944fd888-2998-48bf-90cb-4f8cef185c60', '39f1bb6a-2413-46c2-839d-a4da467cd4c4', 'cea4f99b-dabc-415a-9caf-08f123533365']::uuid[], 'CLOSED', NULL)
    ON CONFLICT(id) DO UPDATE SET name=EXCLUDED.name, description=EXCLUDED.description, field_ids=EXCLUDED.field_ids, scenario_ids=EXCLUDED.scenario_ids, loop=EXCLUDED.loop, queue=EXCLUDED.queue;

INSERT INTO fields
        (id, key, description, agg_func, agg_weights)
        VALUES ('d1acf912-f71d-4ded-832c-e89cd272a0cc', 'normalized_reward', 'Primary test score (NANSUM of corresponding scenario scores)', 'NANSUM', NULL)
        ON CONFLICT(id) DO UPDATE SET key=EXCLUDED.key, description=EXCLUDED.description, agg_func=EXCLUDED.agg_func, agg_weights=EXCLUDED.agg_weights;

INSERT INTO fields
        (id, key, description, agg_func, agg_weights)
        VALUES ('d077454a-bba5-4798-90ed-4919d6f26e8b', 'percentage_complete', 'Secondary test score (NANMEAN of corresponding scenario scores)', 'NANMEAN', NULL)
        ON CONFLICT(id) DO UPDATE SET key=EXCLUDED.key, description=EXCLUDED.description, agg_func=EXCLUDED.agg_func, agg_weights=EXCLUDED.agg_weights;

INSERT INTO scenarios
    (id, name, description, field_ids)
    VALUES ('f07c0a83-6a5b-4b38-8c46-18451a9cf704', 'f07c0a83-6a5b-4b38-8c46-18451a9cf704', 'f07c0a83-6a5b-4b38-8c46-18451a9cf704', array['19d07c00-6f34-4e32-9c5e-50a8a46f1c90', '176b73f7-02ae-49ea-8d1d-f1214fb0bd5d']::uuid[])
    ON CONFLICT(id) DO UPDATE SET name=EXCLUDED.name, description=EXCLUDED.description, field_ids=EXCLUDED.field_ids;

INSERT INTO fields
        (id, key, description, agg_func, agg_weights)
        VALUES ('19d07c00-6f34-4e32-9c5e-50a8a46f1c90', 'normalized_reward', 'Primary raw scenario score.', NULL, NULL)
        ON CONFLICT(id) DO UPDATE SET key=EXCLUDED.key, description=EXCLUDED.description, agg_func=EXCLUDED.agg_func, agg_weights=EXCLUDED.agg_weights;

INSERT INTO fields
        (id, key, description, agg_func, agg_weights)
        VALUES ('176b73f7-02ae-49ea-8d1d-f1214fb0bd5d', 'percentage_complete', 'Secondary raw scenario score.', NULL, NULL)
        ON CONFLICT(id) DO UPDATE SET key=EXCLUDED.key, description=EXCLUDED.description, agg_func=EXCLUDED.agg_func, agg_weights=EXCLUDED.agg_weights;

INSERT INTO scenarios
    (id, name, description, field_ids)
    VALUES ('213037ae-d645-41d8-8b84-e6c08b5837f1', '213037ae-d645-41d8-8b84-e6c08b5837f1', '213037ae-d645-41d8-8b84-e6c08b5837f1', array['19d07c00-6f34-4e32-9c5e-50a8a46f1c90', '176b73f7-02ae-49ea-8d1d-f1214fb0bd5d']::uuid[])
    ON CONFLICT(id) DO UPDATE SET name=EXCLUDED.name, description=EXCLUDED.description, field_ids=EXCLUDED.field_ids;

INSERT INTO fields
        (id, key, description, agg_func, agg_weights)
        VALUES ('19d07c00-6f34-4e32-9c5e-50a8a46f1c90', 'normalized_reward', 'Primary raw scenario score.', NULL, NULL)
        ON CONFLICT(id) DO UPDATE SET key=EXCLUDED.key, description=EXCLUDED.description, agg_func=EXCLUDED.agg_func, agg_weights=EXCLUDED.agg_weights;

INSERT INTO fields
        (id, key, description, agg_func, agg_weights)
        VALUES ('176b73f7-02ae-49ea-8d1d-f1214fb0bd5d', 'percentage_complete', 'Secondary raw scenario score.', NULL, NULL)
        ON CONFLICT(id) DO UPDATE SET key=EXCLUDED.key, description=EXCLUDED.description, agg_func=EXCLUDED.agg_func, agg_weights=EXCLUDED.agg_weights;

INSERT INTO scenarios
    (id, name, description, field_ids)
    VALUES ('b1635abf-3877-4ed9-ab6e-74e49d6c8a97', 'b1635abf-3877-4ed9-ab6e-74e49d6c8a97', 'b1635abf-3877-4ed9-ab6e-74e49d6c8a97', array['19d07c00-6f34-4e32-9c5e-50a8a46f1c90', '176b73f7-02ae-49ea-8d1d-f1214fb0bd5d']::uuid[])
    ON CONFLICT(id) DO UPDATE SET name=EXCLUDED.name, description=EXCLUDED.description, field_ids=EXCLUDED.field_ids;

INSERT INTO fields
        (id, key, description, agg_func, agg_weights)
        VALUES ('19d07c00-6f34-4e32-9c5e-50a8a46f1c90', 'normalized_reward', 'Primary raw scenario score.', NULL, NULL)
        ON CONFLICT(id) DO UPDATE SET key=EXCLUDED.key, description=EXCLUDED.description, agg_func=EXCLUDED.agg_func, agg_weights=EXCLUDED.agg_weights;

INSERT INTO fields
        (id, key, description, agg_func, agg_weights)
        VALUES ('176b73f7-02ae-49ea-8d1d-f1214fb0bd5d', 'percentage_complete', 'Secondary raw scenario score.', NULL, NULL)
        ON CONFLICT(id) DO UPDATE SET key=EXCLUDED.key, description=EXCLUDED.description, agg_func=EXCLUDED.agg_func, agg_weights=EXCLUDED.agg_weights;

INSERT INTO scenarios
    (id, name, description, field_ids)
    VALUES ('4b4c5137-0cf9-41f7-882e-462a57c9b642', '4b4c5137-0cf9-41f7-882e-462a57c9b642', '4b4c5137-0cf9-41f7-882e-462a57c9b642', array['19d07c00-6f34-4e32-9c5e-50a8a46f1c90', '176b73f7-02ae-49ea-8d1d-f1214fb0bd5d']::uuid[])
    ON CONFLICT(id) DO UPDATE SET name=EXCLUDED.name, description=EXCLUDED.description, field_ids=EXCLUDED.field_ids;

INSERT INTO fields
        (id, key, description, agg_func, agg_weights)
        VALUES ('19d07c00-6f34-4e32-9c5e-50a8a46f1c90', 'normalized_reward', 'Primary raw scenario score.', NULL, NULL)
        ON CONFLICT(id) DO UPDATE SET key=EXCLUDED.key, description=EXCLUDED.description, agg_func=EXCLUDED.agg_func, agg_weights=EXCLUDED.agg_weights;

INSERT INTO fields
        (id, key, description, agg_func, agg_weights)
        VALUES ('176b73f7-02ae-49ea-8d1d-f1214fb0bd5d', 'percentage_complete', 'Secondary raw scenario score.', NULL, NULL)
        ON CONFLICT(id) DO UPDATE SET key=EXCLUDED.key, description=EXCLUDED.description, agg_func=EXCLUDED.agg_func, agg_weights=EXCLUDED.agg_weights;

INSERT INTO scenarios
    (id, name, description, field_ids)
    VALUES ('0645d6af-042d-4466-8bbe-d3698478059c', '0645d6af-042d-4466-8bbe-d3698478059c', '0645d6af-042d-4466-8bbe-d3698478059c', array['19d07c00-6f34-4e32-9c5e-50a8a46f1c90', '176b73f7-02ae-49ea-8d1d-f1214fb0bd5d']::uuid[])
    ON CONFLICT(id) DO UPDATE SET name=EXCLUDED.name, description=EXCLUDED.description, field_ids=EXCLUDED.field_ids;

INSERT INTO fields
        (id, key, description, agg_func, agg_weights)
        VALUES ('19d07c00-6f34-4e32-9c5e-50a8a46f1c90', 'normalized_reward', 'Primary raw scenario score.', NULL, NULL)
        ON CONFLICT(id) DO UPDATE SET key=EXCLUDED.key, description=EXCLUDED.description, agg_func=EXCLUDED.agg_func, agg_weights=EXCLUDED.agg_weights;

INSERT INTO fields
        (id, key, description, agg_func, agg_weights)
        VALUES ('176b73f7-02ae-49ea-8d1d-f1214fb0bd5d', 'percentage_complete', 'Secondary raw scenario score.', NULL, NULL)
        ON CONFLICT(id) DO UPDATE SET key=EXCLUDED.key, description=EXCLUDED.description, agg_func=EXCLUDED.agg_func, agg_weights=EXCLUDED.agg_weights;

INSERT INTO scenarios
    (id, name, description, field_ids)
    VALUES ('8a65f839-4c2b-4a75-bb82-29c03c0527ed', '8a65f839-4c2b-4a75-bb82-29c03c0527ed', '8a65f839-4c2b-4a75-bb82-29c03c0527ed', array['19d07c00-6f34-4e32-9c5e-50a8a46f1c90', '176b73f7-02ae-49ea-8d1d-f1214fb0bd5d']::uuid[])
    ON CONFLICT(id) DO UPDATE SET name=EXCLUDED.name, description=EXCLUDED.description, field_ids=EXCLUDED.field_ids;

INSERT INTO fields
        (id, key, description, agg_func, agg_weights)
        VALUES ('19d07c00-6f34-4e32-9c5e-50a8a46f1c90', 'normalized_reward', 'Primary raw scenario score.', NULL, NULL)
        ON CONFLICT(id) DO UPDATE SET key=EXCLUDED.key, description=EXCLUDED.description, agg_func=EXCLUDED.agg_func, agg_weights=EXCLUDED.agg_weights;

INSERT INTO fields
        (id, key, description, agg_func, agg_weights)
        VALUES ('176b73f7-02ae-49ea-8d1d-f1214fb0bd5d', 'percentage_complete', 'Secondary raw scenario score.', NULL, NULL)
        ON CONFLICT(id) DO UPDATE SET key=EXCLUDED.key, description=EXCLUDED.description, agg_func=EXCLUDED.agg_func, agg_weights=EXCLUDED.agg_weights;

INSERT INTO scenarios
    (id, name, description, field_ids)
    VALUES ('477099b1-b31a-4475-8504-0ce6e7d21360', '477099b1-b31a-4475-8504-0ce6e7d21360', '477099b1-b31a-4475-8504-0ce6e7d21360', array['19d07c00-6f34-4e32-9c5e-50a8a46f1c90', '176b73f7-02ae-49ea-8d1d-f1214fb0bd5d']::uuid[])
    ON CONFLICT(id) DO UPDATE SET name=EXCLUDED.name, description=EXCLUDED.description, field_ids=EXCLUDED.field_ids;

INSERT INTO fields
        (id, key, description, agg_func, agg_weights)
        VALUES ('19d07c00-6f34-4e32-9c5e-50a8a46f1c90', 'normalized_reward', 'Primary raw scenario score.', NULL, NULL)
        ON CONFLICT(id) DO UPDATE SET key=EXCLUDED.key, description=EXCLUDED.description, agg_func=EXCLUDED.agg_func, agg_weights=EXCLUDED.agg_weights;

INSERT INTO fields
        (id, key, description, agg_func, agg_weights)
        VALUES ('176b73f7-02ae-49ea-8d1d-f1214fb0bd5d', 'percentage_complete', 'Secondary raw scenario score.', NULL, NULL)
        ON CONFLICT(id) DO UPDATE SET key=EXCLUDED.key, description=EXCLUDED.description, agg_func=EXCLUDED.agg_func, agg_weights=EXCLUDED.agg_weights;

INSERT INTO scenarios
    (id, name, description, field_ids)
    VALUES ('944fd888-2998-48bf-90cb-4f8cef185c60', '944fd888-2998-48bf-90cb-4f8cef185c60', '944fd888-2998-48bf-90cb-4f8cef185c60', array['19d07c00-6f34-4e32-9c5e-50a8a46f1c90', '176b73f7-02ae-49ea-8d1d-f1214fb0bd5d']::uuid[])
    ON CONFLICT(id) DO UPDATE SET name=EXCLUDED.name, description=EXCLUDED.description, field_ids=EXCLUDED.field_ids;

INSERT INTO fields
        (id, key, description, agg_func, agg_weights)
        VALUES ('19d07c00-6f34-4e32-9c5e-50a8a46f1c90', 'normalized_reward', 'Primary raw scenario score.', NULL, NULL)
        ON CONFLICT(id) DO UPDATE SET key=EXCLUDED.key, description=EXCLUDED.description, agg_func=EXCLUDED.agg_func, agg_weights=EXCLUDED.agg_weights;

INSERT INTO fields
        (id, key, description, agg_func, agg_weights)
        VALUES ('176b73f7-02ae-49ea-8d1d-f1214fb0bd5d', 'percentage_complete', 'Secondary raw scenario score.', NULL, NULL)
        ON CONFLICT(id) DO UPDATE SET key=EXCLUDED.key, description=EXCLUDED.description, agg_func=EXCLUDED.agg_func, agg_weights=EXCLUDED.agg_weights;

INSERT INTO scenarios
    (id, name, description, field_ids)
    VALUES ('39f1bb6a-2413-46c2-839d-a4da467cd4c4', '39f1bb6a-2413-46c2-839d-a4da467cd4c4', '39f1bb6a-2413-46c2-839d-a4da467cd4c4', array['19d07c00-6f34-4e32-9c5e-50a8a46f1c90', '176b73f7-02ae-49ea-8d1d-f1214fb0bd5d']::uuid[])
    ON CONFLICT(id) DO UPDATE SET name=EXCLUDED.name, description=EXCLUDED.description, field_ids=EXCLUDED.field_ids;

INSERT INTO fields
        (id, key, description, agg_func, agg_weights)
        VALUES ('19d07c00-6f34-4e32-9c5e-50a8a46f1c90', 'normalized_reward', 'Primary raw scenario score.', NULL, NULL)
        ON CONFLICT(id) DO UPDATE SET key=EXCLUDED.key, description=EXCLUDED.description, agg_func=EXCLUDED.agg_func, agg_weights=EXCLUDED.agg_weights;

INSERT INTO fields
        (id, key, description, agg_func, agg_weights)
        VALUES ('176b73f7-02ae-49ea-8d1d-f1214fb0bd5d', 'percentage_complete', 'Secondary raw scenario score.', NULL, NULL)
        ON CONFLICT(id) DO UPDATE SET key=EXCLUDED.key, description=EXCLUDED.description, agg_func=EXCLUDED.agg_func, agg_weights=EXCLUDED.agg_weights;

INSERT INTO scenarios
    (id, name, description, field_ids)
    VALUES ('cea4f99b-dabc-415a-9caf-08f123533365', 'cea4f99b-dabc-415a-9caf-08f123533365', 'cea4f99b-dabc-415a-9caf-08f123533365', array['19d07c00-6f34-4e32-9c5e-50a8a46f1c90', '176b73f7-02ae-49ea-8d1d-f1214fb0bd5d']::uuid[])
    ON CONFLICT(id) DO UPDATE SET name=EXCLUDED.name, description=EXCLUDED.description, field_ids=EXCLUDED.field_ids;

INSERT INTO fields
        (id, key, description, agg_func, agg_weights)
        VALUES ('19d07c00-6f34-4e32-9c5e-50a8a46f1c90', 'normalized_reward', 'Primary raw scenario score.', NULL, NULL)
        ON CONFLICT(id) DO UPDATE SET key=EXCLUDED.key, description=EXCLUDED.description, agg_func=EXCLUDED.agg_func, agg_weights=EXCLUDED.agg_weights;

INSERT INTO fields
        (id, key, description, agg_func, agg_weights)
        VALUES ('176b73f7-02ae-49ea-8d1d-f1214fb0bd5d', 'percentage_complete', 'Secondary raw scenario score.', NULL, NULL)
        ON CONFLICT(id) DO UPDATE SET key=EXCLUDED.key, description=EXCLUDED.description, agg_func=EXCLUDED.agg_func, agg_weights=EXCLUDED.agg_weights;

INSERT INTO tests
    (id, name, description, field_ids, scenario_ids, loop, queue)
    VALUES ('dd8bdf82-4e0a-45c2-a3f7-5585007ef0ab', 'Test 11', 'Test 11: 200 agents,  100x100, 29', array['d1acf912-f71d-4ded-832c-e89cd272a0cc', 'd077454a-bba5-4798-90ed-4919d6f26e8b']::uuid[], array['6b023d2c-9c78-4375-b3d5-ab0dce2c7e69', 'eec908a1-7332-42ce-8fc1-c820cf705d0d', '068e614b-0645-4d62-81ed-7605f4e12d51', '4f5d8ec4-540e-436e-ab48-e126d3989486', '2b0b0d44-f3f2-4948-9a3f-14d45aa05b75', '8343d3cb-b482-40cb-9b72-d5d5716dea9b', '0b159694-c6d4-4a7a-844f-a10418a16ad5', '70320f0b-24a7-43d1-aba0-55f49dc19e43', 'f43ae5cd-0eca-4b3b-8233-d3838f8867a5', '0be419aa-c9ee-45da-816d-769b1150b78d']::uuid[], 'CLOSED', NULL)
    ON CONFLICT(id) DO UPDATE SET name=EXCLUDED.name, description=EXCLUDED.description, field_ids=EXCLUDED.field_ids, scenario_ids=EXCLUDED.scenario_ids, loop=EXCLUDED.loop, queue=EXCLUDED.queue;

INSERT INTO fields
        (id, key, description, agg_func, agg_weights)
        VALUES ('d1acf912-f71d-4ded-832c-e89cd272a0cc', 'normalized_reward', 'Primary test score (NANSUM of corresponding scenario scores)', 'NANSUM', NULL)
        ON CONFLICT(id) DO UPDATE SET key=EXCLUDED.key, description=EXCLUDED.description, agg_func=EXCLUDED.agg_func, agg_weights=EXCLUDED.agg_weights;

INSERT INTO fields
        (id, key, description, agg_func, agg_weights)
        VALUES ('d077454a-bba5-4798-90ed-4919d6f26e8b', 'percentage_complete', 'Secondary test score (NANMEAN of corresponding scenario scores)', 'NANMEAN', NULL)
        ON CONFLICT(id) DO UPDATE SET key=EXCLUDED.key, description=EXCLUDED.description, agg_func=EXCLUDED.agg_func, agg_weights=EXCLUDED.agg_weights;

INSERT INTO scenarios
    (id, name, description, field_ids)
    VALUES ('6b023d2c-9c78-4375-b3d5-ab0dce2c7e69', '6b023d2c-9c78-4375-b3d5-ab0dce2c7e69', '6b023d2c-9c78-4375-b3d5-ab0dce2c7e69', array['19d07c00-6f34-4e32-9c5e-50a8a46f1c90', '176b73f7-02ae-49ea-8d1d-f1214fb0bd5d']::uuid[])
    ON CONFLICT(id) DO UPDATE SET name=EXCLUDED.name, description=EXCLUDED.description, field_ids=EXCLUDED.field_ids;

INSERT INTO fields
        (id, key, description, agg_func, agg_weights)
        VALUES ('19d07c00-6f34-4e32-9c5e-50a8a46f1c90', 'normalized_reward', 'Primary raw scenario score.', NULL, NULL)
        ON CONFLICT(id) DO UPDATE SET key=EXCLUDED.key, description=EXCLUDED.description, agg_func=EXCLUDED.agg_func, agg_weights=EXCLUDED.agg_weights;

INSERT INTO fields
        (id, key, description, agg_func, agg_weights)
        VALUES ('176b73f7-02ae-49ea-8d1d-f1214fb0bd5d', 'percentage_complete', 'Secondary raw scenario score.', NULL, NULL)
        ON CONFLICT(id) DO UPDATE SET key=EXCLUDED.key, description=EXCLUDED.description, agg_func=EXCLUDED.agg_func, agg_weights=EXCLUDED.agg_weights;

INSERT INTO scenarios
    (id, name, description, field_ids)
    VALUES ('eec908a1-7332-42ce-8fc1-c820cf705d0d', 'eec908a1-7332-42ce-8fc1-c820cf705d0d', 'eec908a1-7332-42ce-8fc1-c820cf705d0d', array['19d07c00-6f34-4e32-9c5e-50a8a46f1c90', '176b73f7-02ae-49ea-8d1d-f1214fb0bd5d']::uuid[])
    ON CONFLICT(id) DO UPDATE SET name=EXCLUDED.name, description=EXCLUDED.description, field_ids=EXCLUDED.field_ids;

INSERT INTO fields
        (id, key, description, agg_func, agg_weights)
        VALUES ('19d07c00-6f34-4e32-9c5e-50a8a46f1c90', 'normalized_reward', 'Primary raw scenario score.', NULL, NULL)
        ON CONFLICT(id) DO UPDATE SET key=EXCLUDED.key, description=EXCLUDED.description, agg_func=EXCLUDED.agg_func, agg_weights=EXCLUDED.agg_weights;

INSERT INTO fields
        (id, key, description, agg_func, agg_weights)
        VALUES ('176b73f7-02ae-49ea-8d1d-f1214fb0bd5d', 'percentage_complete', 'Secondary raw scenario score.', NULL, NULL)
        ON CONFLICT(id) DO UPDATE SET key=EXCLUDED.key, description=EXCLUDED.description, agg_func=EXCLUDED.agg_func, agg_weights=EXCLUDED.agg_weights;

INSERT INTO scenarios
    (id, name, description, field_ids)
    VALUES ('068e614b-0645-4d62-81ed-7605f4e12d51', '068e614b-0645-4d62-81ed-7605f4e12d51', '068e614b-0645-4d62-81ed-7605f4e12d51', array['19d07c00-6f34-4e32-9c5e-50a8a46f1c90', '176b73f7-02ae-49ea-8d1d-f1214fb0bd5d']::uuid[])
    ON CONFLICT(id) DO UPDATE SET name=EXCLUDED.name, description=EXCLUDED.description, field_ids=EXCLUDED.field_ids;

INSERT INTO fields
        (id, key, description, agg_func, agg_weights)
        VALUES ('19d07c00-6f34-4e32-9c5e-50a8a46f1c90', 'normalized_reward', 'Primary raw scenario score.', NULL, NULL)
        ON CONFLICT(id) DO UPDATE SET key=EXCLUDED.key, description=EXCLUDED.description, agg_func=EXCLUDED.agg_func, agg_weights=EXCLUDED.agg_weights;

INSERT INTO fields
        (id, key, description, agg_func, agg_weights)
        VALUES ('176b73f7-02ae-49ea-8d1d-f1214fb0bd5d', 'percentage_complete', 'Secondary raw scenario score.', NULL, NULL)
        ON CONFLICT(id) DO UPDATE SET key=EXCLUDED.key, description=EXCLUDED.description, agg_func=EXCLUDED.agg_func, agg_weights=EXCLUDED.agg_weights;

INSERT INTO scenarios
    (id, name, description, field_ids)
    VALUES ('4f5d8ec4-540e-436e-ab48-e126d3989486', '4f5d8ec4-540e-436e-ab48-e126d3989486', '4f5d8ec4-540e-436e-ab48-e126d3989486', array['19d07c00-6f34-4e32-9c5e-50a8a46f1c90', '176b73f7-02ae-49ea-8d1d-f1214fb0bd5d']::uuid[])
    ON CONFLICT(id) DO UPDATE SET name=EXCLUDED.name, description=EXCLUDED.description, field_ids=EXCLUDED.field_ids;

INSERT INTO fields
        (id, key, description, agg_func, agg_weights)
        VALUES ('19d07c00-6f34-4e32-9c5e-50a8a46f1c90', 'normalized_reward', 'Primary raw scenario score.', NULL, NULL)
        ON CONFLICT(id) DO UPDATE SET key=EXCLUDED.key, description=EXCLUDED.description, agg_func=EXCLUDED.agg_func, agg_weights=EXCLUDED.agg_weights;

INSERT INTO fields
        (id, key, description, agg_func, agg_weights)
        VALUES ('176b73f7-02ae-49ea-8d1d-f1214fb0bd5d', 'percentage_complete', 'Secondary raw scenario score.', NULL, NULL)
        ON CONFLICT(id) DO UPDATE SET key=EXCLUDED.key, description=EXCLUDED.description, agg_func=EXCLUDED.agg_func, agg_weights=EXCLUDED.agg_weights;

INSERT INTO scenarios
    (id, name, description, field_ids)
    VALUES ('2b0b0d44-f3f2-4948-9a3f-14d45aa05b75', '2b0b0d44-f3f2-4948-9a3f-14d45aa05b75', '2b0b0d44-f3f2-4948-9a3f-14d45aa05b75', array['19d07c00-6f34-4e32-9c5e-50a8a46f1c90', '176b73f7-02ae-49ea-8d1d-f1214fb0bd5d']::uuid[])
    ON CONFLICT(id) DO UPDATE SET name=EXCLUDED.name, description=EXCLUDED.description, field_ids=EXCLUDED.field_ids;

INSERT INTO fields
        (id, key, description, agg_func, agg_weights)
        VALUES ('19d07c00-6f34-4e32-9c5e-50a8a46f1c90', 'normalized_reward', 'Primary raw scenario score.', NULL, NULL)
        ON CONFLICT(id) DO UPDATE SET key=EXCLUDED.key, description=EXCLUDED.description, agg_func=EXCLUDED.agg_func, agg_weights=EXCLUDED.agg_weights;

INSERT INTO fields
        (id, key, description, agg_func, agg_weights)
        VALUES ('176b73f7-02ae-49ea-8d1d-f1214fb0bd5d', 'percentage_complete', 'Secondary raw scenario score.', NULL, NULL)
        ON CONFLICT(id) DO UPDATE SET key=EXCLUDED.key, description=EXCLUDED.description, agg_func=EXCLUDED.agg_func, agg_weights=EXCLUDED.agg_weights;

INSERT INTO scenarios
    (id, name, description, field_ids)
    VALUES ('8343d3cb-b482-40cb-9b72-d5d5716dea9b', '8343d3cb-b482-40cb-9b72-d5d5716dea9b', '8343d3cb-b482-40cb-9b72-d5d5716dea9b', array['19d07c00-6f34-4e32-9c5e-50a8a46f1c90', '176b73f7-02ae-49ea-8d1d-f1214fb0bd5d']::uuid[])
    ON CONFLICT(id) DO UPDATE SET name=EXCLUDED.name, description=EXCLUDED.description, field_ids=EXCLUDED.field_ids;

INSERT INTO fields
        (id, key, description, agg_func, agg_weights)
        VALUES ('19d07c00-6f34-4e32-9c5e-50a8a46f1c90', 'normalized_reward', 'Primary raw scenario score.', NULL, NULL)
        ON CONFLICT(id) DO UPDATE SET key=EXCLUDED.key, description=EXCLUDED.description, agg_func=EXCLUDED.agg_func, agg_weights=EXCLUDED.agg_weights;

INSERT INTO fields
        (id, key, description, agg_func, agg_weights)
        VALUES ('176b73f7-02ae-49ea-8d1d-f1214fb0bd5d', 'percentage_complete', 'Secondary raw scenario score.', NULL, NULL)
        ON CONFLICT(id) DO UPDATE SET key=EXCLUDED.key, description=EXCLUDED.description, agg_func=EXCLUDED.agg_func, agg_weights=EXCLUDED.agg_weights;

INSERT INTO scenarios
    (id, name, description, field_ids)
    VALUES ('0b159694-c6d4-4a7a-844f-a10418a16ad5', '0b159694-c6d4-4a7a-844f-a10418a16ad5', '0b159694-c6d4-4a7a-844f-a10418a16ad5', array['19d07c00-6f34-4e32-9c5e-50a8a46f1c90', '176b73f7-02ae-49ea-8d1d-f1214fb0bd5d']::uuid[])
    ON CONFLICT(id) DO UPDATE SET name=EXCLUDED.name, description=EXCLUDED.description, field_ids=EXCLUDED.field_ids;

INSERT INTO fields
        (id, key, description, agg_func, agg_weights)
        VALUES ('19d07c00-6f34-4e32-9c5e-50a8a46f1c90', 'normalized_reward', 'Primary raw scenario score.', NULL, NULL)
        ON CONFLICT(id) DO UPDATE SET key=EXCLUDED.key, description=EXCLUDED.description, agg_func=EXCLUDED.agg_func, agg_weights=EXCLUDED.agg_weights;

INSERT INTO fields
        (id, key, description, agg_func, agg_weights)
        VALUES ('176b73f7-02ae-49ea-8d1d-f1214fb0bd5d', 'percentage_complete', 'Secondary raw scenario score.', NULL, NULL)
        ON CONFLICT(id) DO UPDATE SET key=EXCLUDED.key, description=EXCLUDED.description, agg_func=EXCLUDED.agg_func, agg_weights=EXCLUDED.agg_weights;

INSERT INTO scenarios
    (id, name, description, field_ids)
    VALUES ('70320f0b-24a7-43d1-aba0-55f49dc19e43', '70320f0b-24a7-43d1-aba0-55f49dc19e43', '70320f0b-24a7-43d1-aba0-55f49dc19e43', array['19d07c00-6f34-4e32-9c5e-50a8a46f1c90', '176b73f7-02ae-49ea-8d1d-f1214fb0bd5d']::uuid[])
    ON CONFLICT(id) DO UPDATE SET name=EXCLUDED.name, description=EXCLUDED.description, field_ids=EXCLUDED.field_ids;

INSERT INTO fields
        (id, key, description, agg_func, agg_weights)
        VALUES ('19d07c00-6f34-4e32-9c5e-50a8a46f1c90', 'normalized_reward', 'Primary raw scenario score.', NULL, NULL)
        ON CONFLICT(id) DO UPDATE SET key=EXCLUDED.key, description=EXCLUDED.description, agg_func=EXCLUDED.agg_func, agg_weights=EXCLUDED.agg_weights;

INSERT INTO fields
        (id, key, description, agg_func, agg_weights)
        VALUES ('176b73f7-02ae-49ea-8d1d-f1214fb0bd5d', 'percentage_complete', 'Secondary raw scenario score.', NULL, NULL)
        ON CONFLICT(id) DO UPDATE SET key=EXCLUDED.key, description=EXCLUDED.description, agg_func=EXCLUDED.agg_func, agg_weights=EXCLUDED.agg_weights;

INSERT INTO scenarios
    (id, name, description, field_ids)
    VALUES ('f43ae5cd-0eca-4b3b-8233-d3838f8867a5', 'f43ae5cd-0eca-4b3b-8233-d3838f8867a5', 'f43ae5cd-0eca-4b3b-8233-d3838f8867a5', array['19d07c00-6f34-4e32-9c5e-50a8a46f1c90', '176b73f7-02ae-49ea-8d1d-f1214fb0bd5d']::uuid[])
    ON CONFLICT(id) DO UPDATE SET name=EXCLUDED.name, description=EXCLUDED.description, field_ids=EXCLUDED.field_ids;

INSERT INTO fields
        (id, key, description, agg_func, agg_weights)
        VALUES ('19d07c00-6f34-4e32-9c5e-50a8a46f1c90', 'normalized_reward', 'Primary raw scenario score.', NULL, NULL)
        ON CONFLICT(id) DO UPDATE SET key=EXCLUDED.key, description=EXCLUDED.description, agg_func=EXCLUDED.agg_func, agg_weights=EXCLUDED.agg_weights;

INSERT INTO fields
        (id, key, description, agg_func, agg_weights)
        VALUES ('176b73f7-02ae-49ea-8d1d-f1214fb0bd5d', 'percentage_complete', 'Secondary raw scenario score.', NULL, NULL)
        ON CONFLICT(id) DO UPDATE SET key=EXCLUDED.key, description=EXCLUDED.description, agg_func=EXCLUDED.agg_func, agg_weights=EXCLUDED.agg_weights;

INSERT INTO scenarios
    (id, name, description, field_ids)
    VALUES ('0be419aa-c9ee-45da-816d-769b1150b78d', '0be419aa-c9ee-45da-816d-769b1150b78d', '0be419aa-c9ee-45da-816d-769b1150b78d', array['19d07c00-6f34-4e32-9c5e-50a8a46f1c90', '176b73f7-02ae-49ea-8d1d-f1214fb0bd5d']::uuid[])
    ON CONFLICT(id) DO UPDATE SET name=EXCLUDED.name, description=EXCLUDED.description, field_ids=EXCLUDED.field_ids;

INSERT INTO fields
        (id, key, description, agg_func, agg_weights)
        VALUES ('19d07c00-6f34-4e32-9c5e-50a8a46f1c90', 'normalized_reward', 'Primary raw scenario score.', NULL, NULL)
        ON CONFLICT(id) DO UPDATE SET key=EXCLUDED.key, description=EXCLUDED.description, agg_func=EXCLUDED.agg_func, agg_weights=EXCLUDED.agg_weights;

INSERT INTO fields
        (id, key, description, agg_func, agg_weights)
        VALUES ('176b73f7-02ae-49ea-8d1d-f1214fb0bd5d', 'percentage_complete', 'Secondary raw scenario score.', NULL, NULL)
        ON CONFLICT(id) DO UPDATE SET key=EXCLUDED.key, description=EXCLUDED.description, agg_func=EXCLUDED.agg_func, agg_weights=EXCLUDED.agg_weights;

INSERT INTO tests
    (id, name, description, field_ids, scenario_ids, loop, queue)
    VALUES ('c04e6a19-af18-4676-b84a-a6bc84453e3d', 'Test 12', 'Test 12: 200 agents,  150x150, 33', array['d1acf912-f71d-4ded-832c-e89cd272a0cc', 'd077454a-bba5-4798-90ed-4919d6f26e8b']::uuid[], array['edfaca88-562f-424f-a69e-f5d34c39f501', 'fac213e7-ab55-4fec-8a7e-19528d356c04', '0d874b28-3b8b-438d-b30b-51883b73d38c', '62fba050-1bbc-456b-8fce-25950cf0c7b3', 'e1632a99-02a1-445c-8ba1-3fa30cfb3c03', 'f31a6f8e-9a9a-45b2-ab31-1225b558dd9b', '98703b4f-8cbe-414b-b157-138704c6b808', '7e92ab49-e433-491b-a0b0-f30c020a91d0', '38811b63-2470-4b50-b9ba-7d8e9a2a7880', '3e97a630-d21a-4f42-a2cc-2e44446d0e78']::uuid[], 'CLOSED', NULL)
    ON CONFLICT(id) DO UPDATE SET name=EXCLUDED.name, description=EXCLUDED.description, field_ids=EXCLUDED.field_ids, scenario_ids=EXCLUDED.scenario_ids, loop=EXCLUDED.loop, queue=EXCLUDED.queue;

INSERT INTO fields
        (id, key, description, agg_func, agg_weights)
        VALUES ('d1acf912-f71d-4ded-832c-e89cd272a0cc', 'normalized_reward', 'Primary test score (NANSUM of corresponding scenario scores)', 'NANSUM', NULL)
        ON CONFLICT(id) DO UPDATE SET key=EXCLUDED.key, description=EXCLUDED.description, agg_func=EXCLUDED.agg_func, agg_weights=EXCLUDED.agg_weights;

INSERT INTO fields
        (id, key, description, agg_func, agg_weights)
        VALUES ('d077454a-bba5-4798-90ed-4919d6f26e8b', 'percentage_complete', 'Secondary test score (NANMEAN of corresponding scenario scores)', 'NANMEAN', NULL)
        ON CONFLICT(id) DO UPDATE SET key=EXCLUDED.key, description=EXCLUDED.description, agg_func=EXCLUDED.agg_func, agg_weights=EXCLUDED.agg_weights;

INSERT INTO scenarios
    (id, name, description, field_ids)
    VALUES ('edfaca88-562f-424f-a69e-f5d34c39f501', 'edfaca88-562f-424f-a69e-f5d34c39f501', 'edfaca88-562f-424f-a69e-f5d34c39f501', array['19d07c00-6f34-4e32-9c5e-50a8a46f1c90', '176b73f7-02ae-49ea-8d1d-f1214fb0bd5d']::uuid[])
    ON CONFLICT(id) DO UPDATE SET name=EXCLUDED.name, description=EXCLUDED.description, field_ids=EXCLUDED.field_ids;

INSERT INTO fields
        (id, key, description, agg_func, agg_weights)
        VALUES ('19d07c00-6f34-4e32-9c5e-50a8a46f1c90', 'normalized_reward', 'Primary raw scenario score.', NULL, NULL)
        ON CONFLICT(id) DO UPDATE SET key=EXCLUDED.key, description=EXCLUDED.description, agg_func=EXCLUDED.agg_func, agg_weights=EXCLUDED.agg_weights;

INSERT INTO fields
        (id, key, description, agg_func, agg_weights)
        VALUES ('176b73f7-02ae-49ea-8d1d-f1214fb0bd5d', 'percentage_complete', 'Secondary raw scenario score.', NULL, NULL)
        ON CONFLICT(id) DO UPDATE SET key=EXCLUDED.key, description=EXCLUDED.description, agg_func=EXCLUDED.agg_func, agg_weights=EXCLUDED.agg_weights;

INSERT INTO scenarios
    (id, name, description, field_ids)
    VALUES ('fac213e7-ab55-4fec-8a7e-19528d356c04', 'fac213e7-ab55-4fec-8a7e-19528d356c04', 'fac213e7-ab55-4fec-8a7e-19528d356c04', array['19d07c00-6f34-4e32-9c5e-50a8a46f1c90', '176b73f7-02ae-49ea-8d1d-f1214fb0bd5d']::uuid[])
    ON CONFLICT(id) DO UPDATE SET name=EXCLUDED.name, description=EXCLUDED.description, field_ids=EXCLUDED.field_ids;

INSERT INTO fields
        (id, key, description, agg_func, agg_weights)
        VALUES ('19d07c00-6f34-4e32-9c5e-50a8a46f1c90', 'normalized_reward', 'Primary raw scenario score.', NULL, NULL)
        ON CONFLICT(id) DO UPDATE SET key=EXCLUDED.key, description=EXCLUDED.description, agg_func=EXCLUDED.agg_func, agg_weights=EXCLUDED.agg_weights;

INSERT INTO fields
        (id, key, description, agg_func, agg_weights)
        VALUES ('176b73f7-02ae-49ea-8d1d-f1214fb0bd5d', 'percentage_complete', 'Secondary raw scenario score.', NULL, NULL)
        ON CONFLICT(id) DO UPDATE SET key=EXCLUDED.key, description=EXCLUDED.description, agg_func=EXCLUDED.agg_func, agg_weights=EXCLUDED.agg_weights;

INSERT INTO scenarios
    (id, name, description, field_ids)
    VALUES ('0d874b28-3b8b-438d-b30b-51883b73d38c', '0d874b28-3b8b-438d-b30b-51883b73d38c', '0d874b28-3b8b-438d-b30b-51883b73d38c', array['19d07c00-6f34-4e32-9c5e-50a8a46f1c90', '176b73f7-02ae-49ea-8d1d-f1214fb0bd5d']::uuid[])
    ON CONFLICT(id) DO UPDATE SET name=EXCLUDED.name, description=EXCLUDED.description, field_ids=EXCLUDED.field_ids;

INSERT INTO fields
        (id, key, description, agg_func, agg_weights)
        VALUES ('19d07c00-6f34-4e32-9c5e-50a8a46f1c90', 'normalized_reward', 'Primary raw scenario score.', NULL, NULL)
        ON CONFLICT(id) DO UPDATE SET key=EXCLUDED.key, description=EXCLUDED.description, agg_func=EXCLUDED.agg_func, agg_weights=EXCLUDED.agg_weights;

INSERT INTO fields
        (id, key, description, agg_func, agg_weights)
        VALUES ('176b73f7-02ae-49ea-8d1d-f1214fb0bd5d', 'percentage_complete', 'Secondary raw scenario score.', NULL, NULL)
        ON CONFLICT(id) DO UPDATE SET key=EXCLUDED.key, description=EXCLUDED.description, agg_func=EXCLUDED.agg_func, agg_weights=EXCLUDED.agg_weights;

INSERT INTO scenarios
    (id, name, description, field_ids)
    VALUES ('62fba050-1bbc-456b-8fce-25950cf0c7b3', '62fba050-1bbc-456b-8fce-25950cf0c7b3', '62fba050-1bbc-456b-8fce-25950cf0c7b3', array['19d07c00-6f34-4e32-9c5e-50a8a46f1c90', '176b73f7-02ae-49ea-8d1d-f1214fb0bd5d']::uuid[])
    ON CONFLICT(id) DO UPDATE SET name=EXCLUDED.name, description=EXCLUDED.description, field_ids=EXCLUDED.field_ids;

INSERT INTO fields
        (id, key, description, agg_func, agg_weights)
        VALUES ('19d07c00-6f34-4e32-9c5e-50a8a46f1c90', 'normalized_reward', 'Primary raw scenario score.', NULL, NULL)
        ON CONFLICT(id) DO UPDATE SET key=EXCLUDED.key, description=EXCLUDED.description, agg_func=EXCLUDED.agg_func, agg_weights=EXCLUDED.agg_weights;

INSERT INTO fields
        (id, key, description, agg_func, agg_weights)
        VALUES ('176b73f7-02ae-49ea-8d1d-f1214fb0bd5d', 'percentage_complete', 'Secondary raw scenario score.', NULL, NULL)
        ON CONFLICT(id) DO UPDATE SET key=EXCLUDED.key, description=EXCLUDED.description, agg_func=EXCLUDED.agg_func, agg_weights=EXCLUDED.agg_weights;

INSERT INTO scenarios
    (id, name, description, field_ids)
    VALUES ('e1632a99-02a1-445c-8ba1-3fa30cfb3c03', 'e1632a99-02a1-445c-8ba1-3fa30cfb3c03', 'e1632a99-02a1-445c-8ba1-3fa30cfb3c03', array['19d07c00-6f34-4e32-9c5e-50a8a46f1c90', '176b73f7-02ae-49ea-8d1d-f1214fb0bd5d']::uuid[])
    ON CONFLICT(id) DO UPDATE SET name=EXCLUDED.name, description=EXCLUDED.description, field_ids=EXCLUDED.field_ids;

INSERT INTO fields
        (id, key, description, agg_func, agg_weights)
        VALUES ('19d07c00-6f34-4e32-9c5e-50a8a46f1c90', 'normalized_reward', 'Primary raw scenario score.', NULL, NULL)
        ON CONFLICT(id) DO UPDATE SET key=EXCLUDED.key, description=EXCLUDED.description, agg_func=EXCLUDED.agg_func, agg_weights=EXCLUDED.agg_weights;

INSERT INTO fields
        (id, key, description, agg_func, agg_weights)
        VALUES ('176b73f7-02ae-49ea-8d1d-f1214fb0bd5d', 'percentage_complete', 'Secondary raw scenario score.', NULL, NULL)
        ON CONFLICT(id) DO UPDATE SET key=EXCLUDED.key, description=EXCLUDED.description, agg_func=EXCLUDED.agg_func, agg_weights=EXCLUDED.agg_weights;

INSERT INTO scenarios
    (id, name, description, field_ids)
    VALUES ('f31a6f8e-9a9a-45b2-ab31-1225b558dd9b', 'f31a6f8e-9a9a-45b2-ab31-1225b558dd9b', 'f31a6f8e-9a9a-45b2-ab31-1225b558dd9b', array['19d07c00-6f34-4e32-9c5e-50a8a46f1c90', '176b73f7-02ae-49ea-8d1d-f1214fb0bd5d']::uuid[])
    ON CONFLICT(id) DO UPDATE SET name=EXCLUDED.name, description=EXCLUDED.description, field_ids=EXCLUDED.field_ids;

INSERT INTO fields
        (id, key, description, agg_func, agg_weights)
        VALUES ('19d07c00-6f34-4e32-9c5e-50a8a46f1c90', 'normalized_reward', 'Primary raw scenario score.', NULL, NULL)
        ON CONFLICT(id) DO UPDATE SET key=EXCLUDED.key, description=EXCLUDED.description, agg_func=EXCLUDED.agg_func, agg_weights=EXCLUDED.agg_weights;

INSERT INTO fields
        (id, key, description, agg_func, agg_weights)
        VALUES ('176b73f7-02ae-49ea-8d1d-f1214fb0bd5d', 'percentage_complete', 'Secondary raw scenario score.', NULL, NULL)
        ON CONFLICT(id) DO UPDATE SET key=EXCLUDED.key, description=EXCLUDED.description, agg_func=EXCLUDED.agg_func, agg_weights=EXCLUDED.agg_weights;

INSERT INTO scenarios
    (id, name, description, field_ids)
    VALUES ('98703b4f-8cbe-414b-b157-138704c6b808', '98703b4f-8cbe-414b-b157-138704c6b808', '98703b4f-8cbe-414b-b157-138704c6b808', array['19d07c00-6f34-4e32-9c5e-50a8a46f1c90', '176b73f7-02ae-49ea-8d1d-f1214fb0bd5d']::uuid[])
    ON CONFLICT(id) DO UPDATE SET name=EXCLUDED.name, description=EXCLUDED.description, field_ids=EXCLUDED.field_ids;

INSERT INTO fields
        (id, key, description, agg_func, agg_weights)
        VALUES ('19d07c00-6f34-4e32-9c5e-50a8a46f1c90', 'normalized_reward', 'Primary raw scenario score.', NULL, NULL)
        ON CONFLICT(id) DO UPDATE SET key=EXCLUDED.key, description=EXCLUDED.description, agg_func=EXCLUDED.agg_func, agg_weights=EXCLUDED.agg_weights;

INSERT INTO fields
        (id, key, description, agg_func, agg_weights)
        VALUES ('176b73f7-02ae-49ea-8d1d-f1214fb0bd5d', 'percentage_complete', 'Secondary raw scenario score.', NULL, NULL)
        ON CONFLICT(id) DO UPDATE SET key=EXCLUDED.key, description=EXCLUDED.description, agg_func=EXCLUDED.agg_func, agg_weights=EXCLUDED.agg_weights;

INSERT INTO scenarios
    (id, name, description, field_ids)
    VALUES ('7e92ab49-e433-491b-a0b0-f30c020a91d0', '7e92ab49-e433-491b-a0b0-f30c020a91d0', '7e92ab49-e433-491b-a0b0-f30c020a91d0', array['19d07c00-6f34-4e32-9c5e-50a8a46f1c90', '176b73f7-02ae-49ea-8d1d-f1214fb0bd5d']::uuid[])
    ON CONFLICT(id) DO UPDATE SET name=EXCLUDED.name, description=EXCLUDED.description, field_ids=EXCLUDED.field_ids;

INSERT INTO fields
        (id, key, description, agg_func, agg_weights)
        VALUES ('19d07c00-6f34-4e32-9c5e-50a8a46f1c90', 'normalized_reward', 'Primary raw scenario score.', NULL, NULL)
        ON CONFLICT(id) DO UPDATE SET key=EXCLUDED.key, description=EXCLUDED.description, agg_func=EXCLUDED.agg_func, agg_weights=EXCLUDED.agg_weights;

INSERT INTO fields
        (id, key, description, agg_func, agg_weights)
        VALUES ('176b73f7-02ae-49ea-8d1d-f1214fb0bd5d', 'percentage_complete', 'Secondary raw scenario score.', NULL, NULL)
        ON CONFLICT(id) DO UPDATE SET key=EXCLUDED.key, description=EXCLUDED.description, agg_func=EXCLUDED.agg_func, agg_weights=EXCLUDED.agg_weights;

INSERT INTO scenarios
    (id, name, description, field_ids)
    VALUES ('38811b63-2470-4b50-b9ba-7d8e9a2a7880', '38811b63-2470-4b50-b9ba-7d8e9a2a7880', '38811b63-2470-4b50-b9ba-7d8e9a2a7880', array['19d07c00-6f34-4e32-9c5e-50a8a46f1c90', '176b73f7-02ae-49ea-8d1d-f1214fb0bd5d']::uuid[])
    ON CONFLICT(id) DO UPDATE SET name=EXCLUDED.name, description=EXCLUDED.description, field_ids=EXCLUDED.field_ids;

INSERT INTO fields
        (id, key, description, agg_func, agg_weights)
        VALUES ('19d07c00-6f34-4e32-9c5e-50a8a46f1c90', 'normalized_reward', 'Primary raw scenario score.', NULL, NULL)
        ON CONFLICT(id) DO UPDATE SET key=EXCLUDED.key, description=EXCLUDED.description, agg_func=EXCLUDED.agg_func, agg_weights=EXCLUDED.agg_weights;

INSERT INTO fields
        (id, key, description, agg_func, agg_weights)
        VALUES ('176b73f7-02ae-49ea-8d1d-f1214fb0bd5d', 'percentage_complete', 'Secondary raw scenario score.', NULL, NULL)
        ON CONFLICT(id) DO UPDATE SET key=EXCLUDED.key, description=EXCLUDED.description, agg_func=EXCLUDED.agg_func, agg_weights=EXCLUDED.agg_weights;

INSERT INTO scenarios
    (id, name, description, field_ids)
    VALUES ('3e97a630-d21a-4f42-a2cc-2e44446d0e78', '3e97a630-d21a-4f42-a2cc-2e44446d0e78', '3e97a630-d21a-4f42-a2cc-2e44446d0e78', array['19d07c00-6f34-4e32-9c5e-50a8a46f1c90', '176b73f7-02ae-49ea-8d1d-f1214fb0bd5d']::uuid[])
    ON CONFLICT(id) DO UPDATE SET name=EXCLUDED.name, description=EXCLUDED.description, field_ids=EXCLUDED.field_ids;

INSERT INTO fields
        (id, key, description, agg_func, agg_weights)
        VALUES ('19d07c00-6f34-4e32-9c5e-50a8a46f1c90', 'normalized_reward', 'Primary raw scenario score.', NULL, NULL)
        ON CONFLICT(id) DO UPDATE SET key=EXCLUDED.key, description=EXCLUDED.description, agg_func=EXCLUDED.agg_func, agg_weights=EXCLUDED.agg_weights;

INSERT INTO fields
        (id, key, description, agg_func, agg_weights)
        VALUES ('176b73f7-02ae-49ea-8d1d-f1214fb0bd5d', 'percentage_complete', 'Secondary raw scenario score.', NULL, NULL)
        ON CONFLICT(id) DO UPDATE SET key=EXCLUDED.key, description=EXCLUDED.description, agg_func=EXCLUDED.agg_func, agg_weights=EXCLUDED.agg_weights;

INSERT INTO tests
    (id, name, description, field_ids, scenario_ids, loop, queue)
    VALUES ('02b447ec-4338-46e6-9634-05b74630388d', 'Test 13', 'Test 13: 400 agents,  150x150, 37', array['d1acf912-f71d-4ded-832c-e89cd272a0cc', 'd077454a-bba5-4798-90ed-4919d6f26e8b']::uuid[], array['e2c6c2a5-1a70-4168-a151-695d737a41fb', 'c76c17da-90fb-4d4b-95c0-ef24ae77e845', 'c8ddce49-631e-48a1-ab3a-f349a5c0ba4b', '8acaa0c9-f725-4e25-8bb5-1c87ec8bcd6c', '474c0fed-2475-4b52-87cc-d875283a79ae', '791e2742-2d4a-44b4-9b2c-648ebcfc0d9d', '511497fc-6658-4dff-b955-b6b92f261c80', 'a765eea1-88dd-4100-8136-45a08e3822a4', '5875fa83-a91a-4ec7-b533-3fa12cfae8ff', 'f8b84f09-2460-44f7-9c25-ceab4a7a5ad3']::uuid[], 'CLOSED', NULL)
    ON CONFLICT(id) DO UPDATE SET name=EXCLUDED.name, description=EXCLUDED.description, field_ids=EXCLUDED.field_ids, scenario_ids=EXCLUDED.scenario_ids, loop=EXCLUDED.loop, queue=EXCLUDED.queue;

INSERT INTO fields
        (id, key, description, agg_func, agg_weights)
        VALUES ('d1acf912-f71d-4ded-832c-e89cd272a0cc', 'normalized_reward', 'Primary test score (NANSUM of corresponding scenario scores)', 'NANSUM', NULL)
        ON CONFLICT(id) DO UPDATE SET key=EXCLUDED.key, description=EXCLUDED.description, agg_func=EXCLUDED.agg_func, agg_weights=EXCLUDED.agg_weights;

INSERT INTO fields
        (id, key, description, agg_func, agg_weights)
        VALUES ('d077454a-bba5-4798-90ed-4919d6f26e8b', 'percentage_complete', 'Secondary test score (NANMEAN of corresponding scenario scores)', 'NANMEAN', NULL)
        ON CONFLICT(id) DO UPDATE SET key=EXCLUDED.key, description=EXCLUDED.description, agg_func=EXCLUDED.agg_func, agg_weights=EXCLUDED.agg_weights;

INSERT INTO scenarios
    (id, name, description, field_ids)
    VALUES ('e2c6c2a5-1a70-4168-a151-695d737a41fb', 'e2c6c2a5-1a70-4168-a151-695d737a41fb', 'e2c6c2a5-1a70-4168-a151-695d737a41fb', array['19d07c00-6f34-4e32-9c5e-50a8a46f1c90', '176b73f7-02ae-49ea-8d1d-f1214fb0bd5d']::uuid[])
    ON CONFLICT(id) DO UPDATE SET name=EXCLUDED.name, description=EXCLUDED.description, field_ids=EXCLUDED.field_ids;

INSERT INTO fields
        (id, key, description, agg_func, agg_weights)
        VALUES ('19d07c00-6f34-4e32-9c5e-50a8a46f1c90', 'normalized_reward', 'Primary raw scenario score.', NULL, NULL)
        ON CONFLICT(id) DO UPDATE SET key=EXCLUDED.key, description=EXCLUDED.description, agg_func=EXCLUDED.agg_func, agg_weights=EXCLUDED.agg_weights;

INSERT INTO fields
        (id, key, description, agg_func, agg_weights)
        VALUES ('176b73f7-02ae-49ea-8d1d-f1214fb0bd5d', 'percentage_complete', 'Secondary raw scenario score.', NULL, NULL)
        ON CONFLICT(id) DO UPDATE SET key=EXCLUDED.key, description=EXCLUDED.description, agg_func=EXCLUDED.agg_func, agg_weights=EXCLUDED.agg_weights;

INSERT INTO scenarios
    (id, name, description, field_ids)
    VALUES ('c76c17da-90fb-4d4b-95c0-ef24ae77e845', 'c76c17da-90fb-4d4b-95c0-ef24ae77e845', 'c76c17da-90fb-4d4b-95c0-ef24ae77e845', array['19d07c00-6f34-4e32-9c5e-50a8a46f1c90', '176b73f7-02ae-49ea-8d1d-f1214fb0bd5d']::uuid[])
    ON CONFLICT(id) DO UPDATE SET name=EXCLUDED.name, description=EXCLUDED.description, field_ids=EXCLUDED.field_ids;

INSERT INTO fields
        (id, key, description, agg_func, agg_weights)
        VALUES ('19d07c00-6f34-4e32-9c5e-50a8a46f1c90', 'normalized_reward', 'Primary raw scenario score.', NULL, NULL)
        ON CONFLICT(id) DO UPDATE SET key=EXCLUDED.key, description=EXCLUDED.description, agg_func=EXCLUDED.agg_func, agg_weights=EXCLUDED.agg_weights;

INSERT INTO fields
        (id, key, description, agg_func, agg_weights)
        VALUES ('176b73f7-02ae-49ea-8d1d-f1214fb0bd5d', 'percentage_complete', 'Secondary raw scenario score.', NULL, NULL)
        ON CONFLICT(id) DO UPDATE SET key=EXCLUDED.key, description=EXCLUDED.description, agg_func=EXCLUDED.agg_func, agg_weights=EXCLUDED.agg_weights;

INSERT INTO scenarios
    (id, name, description, field_ids)
    VALUES ('c8ddce49-631e-48a1-ab3a-f349a5c0ba4b', 'c8ddce49-631e-48a1-ab3a-f349a5c0ba4b', 'c8ddce49-631e-48a1-ab3a-f349a5c0ba4b', array['19d07c00-6f34-4e32-9c5e-50a8a46f1c90', '176b73f7-02ae-49ea-8d1d-f1214fb0bd5d']::uuid[])
    ON CONFLICT(id) DO UPDATE SET name=EXCLUDED.name, description=EXCLUDED.description, field_ids=EXCLUDED.field_ids;

INSERT INTO fields
        (id, key, description, agg_func, agg_weights)
        VALUES ('19d07c00-6f34-4e32-9c5e-50a8a46f1c90', 'normalized_reward', 'Primary raw scenario score.', NULL, NULL)
        ON CONFLICT(id) DO UPDATE SET key=EXCLUDED.key, description=EXCLUDED.description, agg_func=EXCLUDED.agg_func, agg_weights=EXCLUDED.agg_weights;

INSERT INTO fields
        (id, key, description, agg_func, agg_weights)
        VALUES ('176b73f7-02ae-49ea-8d1d-f1214fb0bd5d', 'percentage_complete', 'Secondary raw scenario score.', NULL, NULL)
        ON CONFLICT(id) DO UPDATE SET key=EXCLUDED.key, description=EXCLUDED.description, agg_func=EXCLUDED.agg_func, agg_weights=EXCLUDED.agg_weights;

INSERT INTO scenarios
    (id, name, description, field_ids)
    VALUES ('8acaa0c9-f725-4e25-8bb5-1c87ec8bcd6c', '8acaa0c9-f725-4e25-8bb5-1c87ec8bcd6c', '8acaa0c9-f725-4e25-8bb5-1c87ec8bcd6c', array['19d07c00-6f34-4e32-9c5e-50a8a46f1c90', '176b73f7-02ae-49ea-8d1d-f1214fb0bd5d']::uuid[])
    ON CONFLICT(id) DO UPDATE SET name=EXCLUDED.name, description=EXCLUDED.description, field_ids=EXCLUDED.field_ids;

INSERT INTO fields
        (id, key, description, agg_func, agg_weights)
        VALUES ('19d07c00-6f34-4e32-9c5e-50a8a46f1c90', 'normalized_reward', 'Primary raw scenario score.', NULL, NULL)
        ON CONFLICT(id) DO UPDATE SET key=EXCLUDED.key, description=EXCLUDED.description, agg_func=EXCLUDED.agg_func, agg_weights=EXCLUDED.agg_weights;

INSERT INTO fields
        (id, key, description, agg_func, agg_weights)
        VALUES ('176b73f7-02ae-49ea-8d1d-f1214fb0bd5d', 'percentage_complete', 'Secondary raw scenario score.', NULL, NULL)
        ON CONFLICT(id) DO UPDATE SET key=EXCLUDED.key, description=EXCLUDED.description, agg_func=EXCLUDED.agg_func, agg_weights=EXCLUDED.agg_weights;

INSERT INTO scenarios
    (id, name, description, field_ids)
    VALUES ('474c0fed-2475-4b52-87cc-d875283a79ae', '474c0fed-2475-4b52-87cc-d875283a79ae', '474c0fed-2475-4b52-87cc-d875283a79ae', array['19d07c00-6f34-4e32-9c5e-50a8a46f1c90', '176b73f7-02ae-49ea-8d1d-f1214fb0bd5d']::uuid[])
    ON CONFLICT(id) DO UPDATE SET name=EXCLUDED.name, description=EXCLUDED.description, field_ids=EXCLUDED.field_ids;

INSERT INTO fields
        (id, key, description, agg_func, agg_weights)
        VALUES ('19d07c00-6f34-4e32-9c5e-50a8a46f1c90', 'normalized_reward', 'Primary raw scenario score.', NULL, NULL)
        ON CONFLICT(id) DO UPDATE SET key=EXCLUDED.key, description=EXCLUDED.description, agg_func=EXCLUDED.agg_func, agg_weights=EXCLUDED.agg_weights;

INSERT INTO fields
        (id, key, description, agg_func, agg_weights)
        VALUES ('176b73f7-02ae-49ea-8d1d-f1214fb0bd5d', 'percentage_complete', 'Secondary raw scenario score.', NULL, NULL)
        ON CONFLICT(id) DO UPDATE SET key=EXCLUDED.key, description=EXCLUDED.description, agg_func=EXCLUDED.agg_func, agg_weights=EXCLUDED.agg_weights;

INSERT INTO scenarios
    (id, name, description, field_ids)
    VALUES ('791e2742-2d4a-44b4-9b2c-648ebcfc0d9d', '791e2742-2d4a-44b4-9b2c-648ebcfc0d9d', '791e2742-2d4a-44b4-9b2c-648ebcfc0d9d', array['19d07c00-6f34-4e32-9c5e-50a8a46f1c90', '176b73f7-02ae-49ea-8d1d-f1214fb0bd5d']::uuid[])
    ON CONFLICT(id) DO UPDATE SET name=EXCLUDED.name, description=EXCLUDED.description, field_ids=EXCLUDED.field_ids;

INSERT INTO fields
        (id, key, description, agg_func, agg_weights)
        VALUES ('19d07c00-6f34-4e32-9c5e-50a8a46f1c90', 'normalized_reward', 'Primary raw scenario score.', NULL, NULL)
        ON CONFLICT(id) DO UPDATE SET key=EXCLUDED.key, description=EXCLUDED.description, agg_func=EXCLUDED.agg_func, agg_weights=EXCLUDED.agg_weights;

INSERT INTO fields
        (id, key, description, agg_func, agg_weights)
        VALUES ('176b73f7-02ae-49ea-8d1d-f1214fb0bd5d', 'percentage_complete', 'Secondary raw scenario score.', NULL, NULL)
        ON CONFLICT(id) DO UPDATE SET key=EXCLUDED.key, description=EXCLUDED.description, agg_func=EXCLUDED.agg_func, agg_weights=EXCLUDED.agg_weights;

INSERT INTO scenarios
    (id, name, description, field_ids)
    VALUES ('511497fc-6658-4dff-b955-b6b92f261c80', '511497fc-6658-4dff-b955-b6b92f261c80', '511497fc-6658-4dff-b955-b6b92f261c80', array['19d07c00-6f34-4e32-9c5e-50a8a46f1c90', '176b73f7-02ae-49ea-8d1d-f1214fb0bd5d']::uuid[])
    ON CONFLICT(id) DO UPDATE SET name=EXCLUDED.name, description=EXCLUDED.description, field_ids=EXCLUDED.field_ids;

INSERT INTO fields
        (id, key, description, agg_func, agg_weights)
        VALUES ('19d07c00-6f34-4e32-9c5e-50a8a46f1c90', 'normalized_reward', 'Primary raw scenario score.', NULL, NULL)
        ON CONFLICT(id) DO UPDATE SET key=EXCLUDED.key, description=EXCLUDED.description, agg_func=EXCLUDED.agg_func, agg_weights=EXCLUDED.agg_weights;

INSERT INTO fields
        (id, key, description, agg_func, agg_weights)
        VALUES ('176b73f7-02ae-49ea-8d1d-f1214fb0bd5d', 'percentage_complete', 'Secondary raw scenario score.', NULL, NULL)
        ON CONFLICT(id) DO UPDATE SET key=EXCLUDED.key, description=EXCLUDED.description, agg_func=EXCLUDED.agg_func, agg_weights=EXCLUDED.agg_weights;

INSERT INTO scenarios
    (id, name, description, field_ids)
    VALUES ('a765eea1-88dd-4100-8136-45a08e3822a4', 'a765eea1-88dd-4100-8136-45a08e3822a4', 'a765eea1-88dd-4100-8136-45a08e3822a4', array['19d07c00-6f34-4e32-9c5e-50a8a46f1c90', '176b73f7-02ae-49ea-8d1d-f1214fb0bd5d']::uuid[])
    ON CONFLICT(id) DO UPDATE SET name=EXCLUDED.name, description=EXCLUDED.description, field_ids=EXCLUDED.field_ids;

INSERT INTO fields
        (id, key, description, agg_func, agg_weights)
        VALUES ('19d07c00-6f34-4e32-9c5e-50a8a46f1c90', 'normalized_reward', 'Primary raw scenario score.', NULL, NULL)
        ON CONFLICT(id) DO UPDATE SET key=EXCLUDED.key, description=EXCLUDED.description, agg_func=EXCLUDED.agg_func, agg_weights=EXCLUDED.agg_weights;

INSERT INTO fields
        (id, key, description, agg_func, agg_weights)
        VALUES ('176b73f7-02ae-49ea-8d1d-f1214fb0bd5d', 'percentage_complete', 'Secondary raw scenario score.', NULL, NULL)
        ON CONFLICT(id) DO UPDATE SET key=EXCLUDED.key, description=EXCLUDED.description, agg_func=EXCLUDED.agg_func, agg_weights=EXCLUDED.agg_weights;

INSERT INTO scenarios
    (id, name, description, field_ids)
    VALUES ('5875fa83-a91a-4ec7-b533-3fa12cfae8ff', '5875fa83-a91a-4ec7-b533-3fa12cfae8ff', '5875fa83-a91a-4ec7-b533-3fa12cfae8ff', array['19d07c00-6f34-4e32-9c5e-50a8a46f1c90', '176b73f7-02ae-49ea-8d1d-f1214fb0bd5d']::uuid[])
    ON CONFLICT(id) DO UPDATE SET name=EXCLUDED.name, description=EXCLUDED.description, field_ids=EXCLUDED.field_ids;

INSERT INTO fields
        (id, key, description, agg_func, agg_weights)
        VALUES ('19d07c00-6f34-4e32-9c5e-50a8a46f1c90', 'normalized_reward', 'Primary raw scenario score.', NULL, NULL)
        ON CONFLICT(id) DO UPDATE SET key=EXCLUDED.key, description=EXCLUDED.description, agg_func=EXCLUDED.agg_func, agg_weights=EXCLUDED.agg_weights;

INSERT INTO fields
        (id, key, description, agg_func, agg_weights)
        VALUES ('176b73f7-02ae-49ea-8d1d-f1214fb0bd5d', 'percentage_complete', 'Secondary raw scenario score.', NULL, NULL)
        ON CONFLICT(id) DO UPDATE SET key=EXCLUDED.key, description=EXCLUDED.description, agg_func=EXCLUDED.agg_func, agg_weights=EXCLUDED.agg_weights;

INSERT INTO scenarios
    (id, name, description, field_ids)
    VALUES ('f8b84f09-2460-44f7-9c25-ceab4a7a5ad3', 'f8b84f09-2460-44f7-9c25-ceab4a7a5ad3', 'f8b84f09-2460-44f7-9c25-ceab4a7a5ad3', array['19d07c00-6f34-4e32-9c5e-50a8a46f1c90', '176b73f7-02ae-49ea-8d1d-f1214fb0bd5d']::uuid[])
    ON CONFLICT(id) DO UPDATE SET name=EXCLUDED.name, description=EXCLUDED.description, field_ids=EXCLUDED.field_ids;

INSERT INTO fields
        (id, key, description, agg_func, agg_weights)
        VALUES ('19d07c00-6f34-4e32-9c5e-50a8a46f1c90', 'normalized_reward', 'Primary raw scenario score.', NULL, NULL)
        ON CONFLICT(id) DO UPDATE SET key=EXCLUDED.key, description=EXCLUDED.description, agg_func=EXCLUDED.agg_func, agg_weights=EXCLUDED.agg_weights;

INSERT INTO fields
        (id, key, description, agg_func, agg_weights)
        VALUES ('176b73f7-02ae-49ea-8d1d-f1214fb0bd5d', 'percentage_complete', 'Secondary raw scenario score.', NULL, NULL)
        ON CONFLICT(id) DO UPDATE SET key=EXCLUDED.key, description=EXCLUDED.description, agg_func=EXCLUDED.agg_func, agg_weights=EXCLUDED.agg_weights;

INSERT INTO tests
    (id, name, description, field_ids, scenario_ids, loop, queue)
    VALUES ('e47db3ae-700c-4bad-ae88-466ea5105b87', 'Test 14', 'Test 14: 425 agents,  158x158, 41', array['d1acf912-f71d-4ded-832c-e89cd272a0cc', 'd077454a-bba5-4798-90ed-4919d6f26e8b']::uuid[], array['cf3db404-f053-4582-bb24-f9e8c88f427e', '768cdd29-0ab6-473e-aea1-b4f4e57ab2d0', 'f051290f-9807-4ed7-8c7b-72901877d25a', '6d518914-2e6f-4e17-a33f-6c2264f8300b', 'c0e924e8-b91c-4e3a-8161-59b7d2eb5e11', '2f87ca8c-f3ab-45fe-944a-ed8d9a48c264', 'a0ea19e2-e074-4f9b-bf67-55d05a37ab31', '61840b63-3569-4751-95e0-6cc3f23909a8', '85dbb9a5-52e2-4ed2-ac6e-0030ce5a85ef', '14611e50-ef67-4833-9023-65f21e3208ef']::uuid[], 'CLOSED', NULL)
    ON CONFLICT(id) DO UPDATE SET name=EXCLUDED.name, description=EXCLUDED.description, field_ids=EXCLUDED.field_ids, scenario_ids=EXCLUDED.scenario_ids, loop=EXCLUDED.loop, queue=EXCLUDED.queue;

INSERT INTO fields
        (id, key, description, agg_func, agg_weights)
        VALUES ('d1acf912-f71d-4ded-832c-e89cd272a0cc', 'normalized_reward', 'Primary test score (NANSUM of corresponding scenario scores)', 'NANSUM', NULL)
        ON CONFLICT(id) DO UPDATE SET key=EXCLUDED.key, description=EXCLUDED.description, agg_func=EXCLUDED.agg_func, agg_weights=EXCLUDED.agg_weights;

INSERT INTO fields
        (id, key, description, agg_func, agg_weights)
        VALUES ('d077454a-bba5-4798-90ed-4919d6f26e8b', 'percentage_complete', 'Secondary test score (NANMEAN of corresponding scenario scores)', 'NANMEAN', NULL)
        ON CONFLICT(id) DO UPDATE SET key=EXCLUDED.key, description=EXCLUDED.description, agg_func=EXCLUDED.agg_func, agg_weights=EXCLUDED.agg_weights;

INSERT INTO scenarios
    (id, name, description, field_ids)
    VALUES ('cf3db404-f053-4582-bb24-f9e8c88f427e', 'cf3db404-f053-4582-bb24-f9e8c88f427e', 'cf3db404-f053-4582-bb24-f9e8c88f427e', array['19d07c00-6f34-4e32-9c5e-50a8a46f1c90', '176b73f7-02ae-49ea-8d1d-f1214fb0bd5d']::uuid[])
    ON CONFLICT(id) DO UPDATE SET name=EXCLUDED.name, description=EXCLUDED.description, field_ids=EXCLUDED.field_ids;

INSERT INTO fields
        (id, key, description, agg_func, agg_weights)
        VALUES ('19d07c00-6f34-4e32-9c5e-50a8a46f1c90', 'normalized_reward', 'Primary raw scenario score.', NULL, NULL)
        ON CONFLICT(id) DO UPDATE SET key=EXCLUDED.key, description=EXCLUDED.description, agg_func=EXCLUDED.agg_func, agg_weights=EXCLUDED.agg_weights;

INSERT INTO fields
        (id, key, description, agg_func, agg_weights)
        VALUES ('176b73f7-02ae-49ea-8d1d-f1214fb0bd5d', 'percentage_complete', 'Secondary raw scenario score.', NULL, NULL)
        ON CONFLICT(id) DO UPDATE SET key=EXCLUDED.key, description=EXCLUDED.description, agg_func=EXCLUDED.agg_func, agg_weights=EXCLUDED.agg_weights;

INSERT INTO scenarios
    (id, name, description, field_ids)
    VALUES ('768cdd29-0ab6-473e-aea1-b4f4e57ab2d0', '768cdd29-0ab6-473e-aea1-b4f4e57ab2d0', '768cdd29-0ab6-473e-aea1-b4f4e57ab2d0', array['19d07c00-6f34-4e32-9c5e-50a8a46f1c90', '176b73f7-02ae-49ea-8d1d-f1214fb0bd5d']::uuid[])
    ON CONFLICT(id) DO UPDATE SET name=EXCLUDED.name, description=EXCLUDED.description, field_ids=EXCLUDED.field_ids;

INSERT INTO fields
        (id, key, description, agg_func, agg_weights)
        VALUES ('19d07c00-6f34-4e32-9c5e-50a8a46f1c90', 'normalized_reward', 'Primary raw scenario score.', NULL, NULL)
        ON CONFLICT(id) DO UPDATE SET key=EXCLUDED.key, description=EXCLUDED.description, agg_func=EXCLUDED.agg_func, agg_weights=EXCLUDED.agg_weights;

INSERT INTO fields
        (id, key, description, agg_func, agg_weights)
        VALUES ('176b73f7-02ae-49ea-8d1d-f1214fb0bd5d', 'percentage_complete', 'Secondary raw scenario score.', NULL, NULL)
        ON CONFLICT(id) DO UPDATE SET key=EXCLUDED.key, description=EXCLUDED.description, agg_func=EXCLUDED.agg_func, agg_weights=EXCLUDED.agg_weights;

INSERT INTO scenarios
    (id, name, description, field_ids)
    VALUES ('f051290f-9807-4ed7-8c7b-72901877d25a', 'f051290f-9807-4ed7-8c7b-72901877d25a', 'f051290f-9807-4ed7-8c7b-72901877d25a', array['19d07c00-6f34-4e32-9c5e-50a8a46f1c90', '176b73f7-02ae-49ea-8d1d-f1214fb0bd5d']::uuid[])
    ON CONFLICT(id) DO UPDATE SET name=EXCLUDED.name, description=EXCLUDED.description, field_ids=EXCLUDED.field_ids;

INSERT INTO fields
        (id, key, description, agg_func, agg_weights)
        VALUES ('19d07c00-6f34-4e32-9c5e-50a8a46f1c90', 'normalized_reward', 'Primary raw scenario score.', NULL, NULL)
        ON CONFLICT(id) DO UPDATE SET key=EXCLUDED.key, description=EXCLUDED.description, agg_func=EXCLUDED.agg_func, agg_weights=EXCLUDED.agg_weights;

INSERT INTO fields
        (id, key, description, agg_func, agg_weights)
        VALUES ('176b73f7-02ae-49ea-8d1d-f1214fb0bd5d', 'percentage_complete', 'Secondary raw scenario score.', NULL, NULL)
        ON CONFLICT(id) DO UPDATE SET key=EXCLUDED.key, description=EXCLUDED.description, agg_func=EXCLUDED.agg_func, agg_weights=EXCLUDED.agg_weights;

INSERT INTO scenarios
    (id, name, description, field_ids)
    VALUES ('6d518914-2e6f-4e17-a33f-6c2264f8300b', '6d518914-2e6f-4e17-a33f-6c2264f8300b', '6d518914-2e6f-4e17-a33f-6c2264f8300b', array['19d07c00-6f34-4e32-9c5e-50a8a46f1c90', '176b73f7-02ae-49ea-8d1d-f1214fb0bd5d']::uuid[])
    ON CONFLICT(id) DO UPDATE SET name=EXCLUDED.name, description=EXCLUDED.description, field_ids=EXCLUDED.field_ids;

INSERT INTO fields
        (id, key, description, agg_func, agg_weights)
        VALUES ('19d07c00-6f34-4e32-9c5e-50a8a46f1c90', 'normalized_reward', 'Primary raw scenario score.', NULL, NULL)
        ON CONFLICT(id) DO UPDATE SET key=EXCLUDED.key, description=EXCLUDED.description, agg_func=EXCLUDED.agg_func, agg_weights=EXCLUDED.agg_weights;

INSERT INTO fields
        (id, key, description, agg_func, agg_weights)
        VALUES ('176b73f7-02ae-49ea-8d1d-f1214fb0bd5d', 'percentage_complete', 'Secondary raw scenario score.', NULL, NULL)
        ON CONFLICT(id) DO UPDATE SET key=EXCLUDED.key, description=EXCLUDED.description, agg_func=EXCLUDED.agg_func, agg_weights=EXCLUDED.agg_weights;

INSERT INTO scenarios
    (id, name, description, field_ids)
    VALUES ('c0e924e8-b91c-4e3a-8161-59b7d2eb5e11', 'c0e924e8-b91c-4e3a-8161-59b7d2eb5e11', 'c0e924e8-b91c-4e3a-8161-59b7d2eb5e11', array['19d07c00-6f34-4e32-9c5e-50a8a46f1c90', '176b73f7-02ae-49ea-8d1d-f1214fb0bd5d']::uuid[])
    ON CONFLICT(id) DO UPDATE SET name=EXCLUDED.name, description=EXCLUDED.description, field_ids=EXCLUDED.field_ids;

INSERT INTO fields
        (id, key, description, agg_func, agg_weights)
        VALUES ('19d07c00-6f34-4e32-9c5e-50a8a46f1c90', 'normalized_reward', 'Primary raw scenario score.', NULL, NULL)
        ON CONFLICT(id) DO UPDATE SET key=EXCLUDED.key, description=EXCLUDED.description, agg_func=EXCLUDED.agg_func, agg_weights=EXCLUDED.agg_weights;

INSERT INTO fields
        (id, key, description, agg_func, agg_weights)
        VALUES ('176b73f7-02ae-49ea-8d1d-f1214fb0bd5d', 'percentage_complete', 'Secondary raw scenario score.', NULL, NULL)
        ON CONFLICT(id) DO UPDATE SET key=EXCLUDED.key, description=EXCLUDED.description, agg_func=EXCLUDED.agg_func, agg_weights=EXCLUDED.agg_weights;

INSERT INTO scenarios
    (id, name, description, field_ids)
    VALUES ('2f87ca8c-f3ab-45fe-944a-ed8d9a48c264', '2f87ca8c-f3ab-45fe-944a-ed8d9a48c264', '2f87ca8c-f3ab-45fe-944a-ed8d9a48c264', array['19d07c00-6f34-4e32-9c5e-50a8a46f1c90', '176b73f7-02ae-49ea-8d1d-f1214fb0bd5d']::uuid[])
    ON CONFLICT(id) DO UPDATE SET name=EXCLUDED.name, description=EXCLUDED.description, field_ids=EXCLUDED.field_ids;

INSERT INTO fields
        (id, key, description, agg_func, agg_weights)
        VALUES ('19d07c00-6f34-4e32-9c5e-50a8a46f1c90', 'normalized_reward', 'Primary raw scenario score.', NULL, NULL)
        ON CONFLICT(id) DO UPDATE SET key=EXCLUDED.key, description=EXCLUDED.description, agg_func=EXCLUDED.agg_func, agg_weights=EXCLUDED.agg_weights;

INSERT INTO fields
        (id, key, description, agg_func, agg_weights)
        VALUES ('176b73f7-02ae-49ea-8d1d-f1214fb0bd5d', 'percentage_complete', 'Secondary raw scenario score.', NULL, NULL)
        ON CONFLICT(id) DO UPDATE SET key=EXCLUDED.key, description=EXCLUDED.description, agg_func=EXCLUDED.agg_func, agg_weights=EXCLUDED.agg_weights;

INSERT INTO scenarios
    (id, name, description, field_ids)
    VALUES ('a0ea19e2-e074-4f9b-bf67-55d05a37ab31', 'a0ea19e2-e074-4f9b-bf67-55d05a37ab31', 'a0ea19e2-e074-4f9b-bf67-55d05a37ab31', array['19d07c00-6f34-4e32-9c5e-50a8a46f1c90', '176b73f7-02ae-49ea-8d1d-f1214fb0bd5d']::uuid[])
    ON CONFLICT(id) DO UPDATE SET name=EXCLUDED.name, description=EXCLUDED.description, field_ids=EXCLUDED.field_ids;

INSERT INTO fields
        (id, key, description, agg_func, agg_weights)
        VALUES ('19d07c00-6f34-4e32-9c5e-50a8a46f1c90', 'normalized_reward', 'Primary raw scenario score.', NULL, NULL)
        ON CONFLICT(id) DO UPDATE SET key=EXCLUDED.key, description=EXCLUDED.description, agg_func=EXCLUDED.agg_func, agg_weights=EXCLUDED.agg_weights;

INSERT INTO fields
        (id, key, description, agg_func, agg_weights)
        VALUES ('176b73f7-02ae-49ea-8d1d-f1214fb0bd5d', 'percentage_complete', 'Secondary raw scenario score.', NULL, NULL)
        ON CONFLICT(id) DO UPDATE SET key=EXCLUDED.key, description=EXCLUDED.description, agg_func=EXCLUDED.agg_func, agg_weights=EXCLUDED.agg_weights;

INSERT INTO scenarios
    (id, name, description, field_ids)
    VALUES ('61840b63-3569-4751-95e0-6cc3f23909a8', '61840b63-3569-4751-95e0-6cc3f23909a8', '61840b63-3569-4751-95e0-6cc3f23909a8', array['19d07c00-6f34-4e32-9c5e-50a8a46f1c90', '176b73f7-02ae-49ea-8d1d-f1214fb0bd5d']::uuid[])
    ON CONFLICT(id) DO UPDATE SET name=EXCLUDED.name, description=EXCLUDED.description, field_ids=EXCLUDED.field_ids;

INSERT INTO fields
        (id, key, description, agg_func, agg_weights)
        VALUES ('19d07c00-6f34-4e32-9c5e-50a8a46f1c90', 'normalized_reward', 'Primary raw scenario score.', NULL, NULL)
        ON CONFLICT(id) DO UPDATE SET key=EXCLUDED.key, description=EXCLUDED.description, agg_func=EXCLUDED.agg_func, agg_weights=EXCLUDED.agg_weights;

INSERT INTO fields
        (id, key, description, agg_func, agg_weights)
        VALUES ('176b73f7-02ae-49ea-8d1d-f1214fb0bd5d', 'percentage_complete', 'Secondary raw scenario score.', NULL, NULL)
        ON CONFLICT(id) DO UPDATE SET key=EXCLUDED.key, description=EXCLUDED.description, agg_func=EXCLUDED.agg_func, agg_weights=EXCLUDED.agg_weights;

INSERT INTO scenarios
    (id, name, description, field_ids)
    VALUES ('85dbb9a5-52e2-4ed2-ac6e-0030ce5a85ef', '85dbb9a5-52e2-4ed2-ac6e-0030ce5a85ef', '85dbb9a5-52e2-4ed2-ac6e-0030ce5a85ef', array['19d07c00-6f34-4e32-9c5e-50a8a46f1c90', '176b73f7-02ae-49ea-8d1d-f1214fb0bd5d']::uuid[])
    ON CONFLICT(id) DO UPDATE SET name=EXCLUDED.name, description=EXCLUDED.description, field_ids=EXCLUDED.field_ids;

INSERT INTO fields
        (id, key, description, agg_func, agg_weights)
        VALUES ('19d07c00-6f34-4e32-9c5e-50a8a46f1c90', 'normalized_reward', 'Primary raw scenario score.', NULL, NULL)
        ON CONFLICT(id) DO UPDATE SET key=EXCLUDED.key, description=EXCLUDED.description, agg_func=EXCLUDED.agg_func, agg_weights=EXCLUDED.agg_weights;

INSERT INTO fields
        (id, key, description, agg_func, agg_weights)
        VALUES ('176b73f7-02ae-49ea-8d1d-f1214fb0bd5d', 'percentage_complete', 'Secondary raw scenario score.', NULL, NULL)
        ON CONFLICT(id) DO UPDATE SET key=EXCLUDED.key, description=EXCLUDED.description, agg_func=EXCLUDED.agg_func, agg_weights=EXCLUDED.agg_weights;

INSERT INTO scenarios
    (id, name, description, field_ids)
    VALUES ('14611e50-ef67-4833-9023-65f21e3208ef', '14611e50-ef67-4833-9023-65f21e3208ef', '14611e50-ef67-4833-9023-65f21e3208ef', array['19d07c00-6f34-4e32-9c5e-50a8a46f1c90', '176b73f7-02ae-49ea-8d1d-f1214fb0bd5d']::uuid[])
    ON CONFLICT(id) DO UPDATE SET name=EXCLUDED.name, description=EXCLUDED.description, field_ids=EXCLUDED.field_ids;

INSERT INTO fields
        (id, key, description, agg_func, agg_weights)
        VALUES ('19d07c00-6f34-4e32-9c5e-50a8a46f1c90', 'normalized_reward', 'Primary raw scenario score.', NULL, NULL)
        ON CONFLICT(id) DO UPDATE SET key=EXCLUDED.key, description=EXCLUDED.description, agg_func=EXCLUDED.agg_func, agg_weights=EXCLUDED.agg_weights;

INSERT INTO fields
        (id, key, description, agg_func, agg_weights)
        VALUES ('176b73f7-02ae-49ea-8d1d-f1214fb0bd5d', 'percentage_complete', 'Secondary raw scenario score.', NULL, NULL)
        ON CONFLICT(id) DO UPDATE SET key=EXCLUDED.key, description=EXCLUDED.description, agg_func=EXCLUDED.agg_func, agg_weights=EXCLUDED.agg_weights;

