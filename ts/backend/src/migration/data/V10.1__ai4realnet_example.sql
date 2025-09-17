 INSERT INTO suites
    (id, setup, name, description, benchmark_ids)
    VALUES ('0ca46887-897a-463f-bf83-c6cd6269a977', 'CAMPAIGN', 'Beta Validation Campaign', 'The beta validation campaign runs until 30.11.2025', array['3237ba20-ccff-45b0-af23-44719e584f41', '2da3781a-25a9-4c89-8b43-9269844f3fef', '8d5c876e-22c2-49e7-bdd5-4c1840d309f0', '65547935-f436-49fa-8d20-f320c6bd46dc', '3b1bdca6-ed90-4938-bd63-fd657aa7dcd7', '4b0be731-8371-4e4e-a673-b630187b0bb8', 'd65cd37a-4830-468c-9100-0f60ee9ff72e', '16706c82-75df-4969-932d-a7f5c941eca2', '43040944-39ac-47c9-b91d-bc8ca5693b3c', '3810191b-8cfd-4b03-86b2-f7e530aab30d', '31ea606b-681a-437a-85b9-7c81d4ccc287', 'df309815-8ec0-4a6f-9d0b-dc3dbfc9055a']::uuid[])
    ON CONFLICT(id) DO UPDATE SET setup=EXCLUDED.setup, name=EXCLUDED.name, description=EXCLUDED.description, benchmark_ids=EXCLUDED.benchmark_ids;

INSERT INTO benchmark_definitions
    (id, name, description, field_ids, test_ids)
    VALUES ('3237ba20-ccff-45b0-af23-44719e584f41', 'Human user experience', 'Human user experience', array['6d165bd8-cc48-45d2-8b31-08c178ddeff9']::uuid[], array['8edbf9a1-09b4-478a-ac53-8fc903e70cc1', '98413684-d114-4f88-a5e9-1e118b106d67', '9a9b85fb-6b8b-4b42-af5d-1d81d515e6b1', 'd4bcbd11-740a-478f-8dbc-6d9b53fa6059', '6e005336-6c4c-43ae-ac8d-330d51ab48d4', 'c2a22379-524a-4294-80b2-c751be726b70', '22c590e5-01ad-4e96-9040-29a13ac9118f', '4a9db7b3-0dd9-4ac2-a211-ef5a991e4ab9', '290debb4-eeff-408c-a680-28fce5b376e7', '05e91ee6-744b-47ea-85a0-005e26b578e0', 'd1ba73c3-6796-44db-8d87-129558e3535d', 'ebd2a832-1c69-4d87-9de2-4a283e7c7f37', '40398221-b288-46d9-895c-45d278f1b6a3', 'dbd85bfb-2e78-4646-b2da-b4d16e90e657', 'e52b585d-0da8-4a88-97ff-0953a62a548c', '307bce4c-635f-44c3-9ed2-6d4d45d1bbb2', '4166c200-b50e-4e2e-a3a7-05f31e7f78f8', '26bf1860-4b1c-4fed-8f81-53dac6a8f8f7', '343bc5cf-0bab-4fdf-9760-266c5a738b08', '66c08000-9a5e-42ca-a328-8e6295069142', '96396992-ab9a-45b8-9833-124b46925da6', '452bb0df-9a9d-4475-ac7b-8e62659c0b13', '62bcfa08-99ce-4bfe-b7a4-08343ef3a316', 'ebd44326-8c9b-4144-8e31-8c360b148dd3']::uuid[])
    ON CONFLICT(id) DO UPDATE SET name=EXCLUDED.name, description=EXCLUDED.description, field_ids=EXCLUDED.field_ids, test_ids=EXCLUDED.test_ids;

INSERT INTO field_definitions
        (id, key, description, agg_func, agg_weights)
        VALUES ('6d165bd8-cc48-45d2-8b31-08c178ddeff9', 'primary', 'Benchmark score (MEAN of test scores)', 'MEAN', NULL)
        ON CONFLICT(id) DO UPDATE SET key=EXCLUDED.key, description=EXCLUDED.description, agg_func=EXCLUDED.agg_func, agg_weights=EXCLUDED.agg_weights;

INSERT INTO test_definitions
    (id, name, description, field_ids, scenario_ids, loop, queue)
    VALUES ('8edbf9a1-09b4-478a-ac53-8fc903e70cc1', 'KPI-AS-001: Ability to anticipate (Railway)', '“The ability to anticipate. Knowing what to expect or being able to anticipate developments further into the future, such as potential disruptions, novel demands or constraints, new opportunities, or changing operating conditions” (Hollnagel, 2015, p. 4). <br/>The human operator’s ability to anticipate further into the future can be measured by calculating the ratio of (proactively) prevented deviations to actual deviations. In addition, the extent to which the anticipatory sensemaking process of the human operator is supported by AI-based assistants can be measured using the Rigor-Metric for Sensemaking (Zelik et al., 2018) or similar. The instrument needs to be further developed and adapted to the AI context. ', array['2310ad43-2065-44a5-8a6a-100e2c6076f1']::uuid[], array['c7159f8d-781b-40fc-9efa-cd0e3a8b8d21']::uuid[], 'OFFLINE', 'Railway')
    ON CONFLICT(id) DO UPDATE SET name=EXCLUDED.name, description=EXCLUDED.description, field_ids=EXCLUDED.field_ids, scenario_ids=EXCLUDED.scenario_ids, loop=EXCLUDED.loop, queue=EXCLUDED.queue;

INSERT INTO field_definitions
        (id, key, description, agg_func, agg_weights)
        VALUES ('2310ad43-2065-44a5-8a6a-100e2c6076f1', 'primary', 'Benchmark score (MEAN of test scores)', 'MEAN', NULL)
        ON CONFLICT(id) DO UPDATE SET key=EXCLUDED.key, description=EXCLUDED.description, agg_func=EXCLUDED.agg_func, agg_weights=EXCLUDED.agg_weights;

INSERT INTO scenario_definitions
    (id, name, description, field_ids)
    VALUES ('c7159f8d-781b-40fc-9efa-cd0e3a8b8d21', 'primary', 'This KPI contributes to evaluating Human user experience of the AI-based assistant, as part of Task 4.3 evaluation objectives, and O3 main project objective. ', array['071fb4f2-9765-4fe0-9f7a-573cf8bb2ee7']::uuid[])
    ON CONFLICT(id) DO UPDATE SET name=EXCLUDED.name, description=EXCLUDED.description, field_ids=EXCLUDED.field_ids;

INSERT INTO field_definitions
        (id, key, description, agg_func, agg_weights)
        VALUES ('071fb4f2-9765-4fe0-9f7a-573cf8bb2ee7', 'primary', 'Scenario score (raw values)', NULL, NULL)
        ON CONFLICT(id) DO UPDATE SET key=EXCLUDED.key, description=EXCLUDED.description, agg_func=EXCLUDED.agg_func, agg_weights=EXCLUDED.agg_weights;

INSERT INTO test_definitions
    (id, name, description, field_ids, scenario_ids, loop, queue)
    VALUES ('98413684-d114-4f88-a5e9-1e118b106d67', 'KPI-AS-001: Ability to anticipate (Power Grid)', '“The ability to anticipate. Knowing what to expect or being able to anticipate developments further into the future, such as potential disruptions, novel demands or constraints, new opportunities, or changing operating conditions” (Hollnagel, 2015, p. 4). <br/>The human operator’s ability to anticipate further into the future can be measured by calculating the ratio of (proactively) prevented deviations to actual deviations. In addition, the extent to which the anticipatory sensemaking process of the human operator is supported by AI-based assistants can be measured using the Rigor-Metric for Sensemaking (Zelik et al., 2018) or similar. The instrument needs to be further developed and adapted to the AI context. ', array['02890e30-6f7b-4ed3-80a1-abf2e169e43f']::uuid[], array['ef0af7e2-0212-454d-9391-41de03bd7e57']::uuid[], 'OFFLINE', 'PowerGrid')
    ON CONFLICT(id) DO UPDATE SET name=EXCLUDED.name, description=EXCLUDED.description, field_ids=EXCLUDED.field_ids, scenario_ids=EXCLUDED.scenario_ids, loop=EXCLUDED.loop, queue=EXCLUDED.queue;

INSERT INTO field_definitions
        (id, key, description, agg_func, agg_weights)
        VALUES ('02890e30-6f7b-4ed3-80a1-abf2e169e43f', 'primary', 'Benchmark score (MEAN of test scores)', 'MEAN', NULL)
        ON CONFLICT(id) DO UPDATE SET key=EXCLUDED.key, description=EXCLUDED.description, agg_func=EXCLUDED.agg_func, agg_weights=EXCLUDED.agg_weights;

INSERT INTO scenario_definitions
    (id, name, description, field_ids)
    VALUES ('ef0af7e2-0212-454d-9391-41de03bd7e57', 'primary', 'This KPI contributes to evaluating Human user experience of the AI-based assistant, as part of Task 4.3 evaluation objectives, and O3 main project objective. ', array['ad5addc9-e7e5-4807-9820-8ed96c5453e6']::uuid[])
    ON CONFLICT(id) DO UPDATE SET name=EXCLUDED.name, description=EXCLUDED.description, field_ids=EXCLUDED.field_ids;

INSERT INTO field_definitions
        (id, key, description, agg_func, agg_weights)
        VALUES ('ad5addc9-e7e5-4807-9820-8ed96c5453e6', 'primary', 'Scenario score (raw values)', NULL, NULL)
        ON CONFLICT(id) DO UPDATE SET key=EXCLUDED.key, description=EXCLUDED.description, agg_func=EXCLUDED.agg_func, agg_weights=EXCLUDED.agg_weights;

INSERT INTO test_definitions
    (id, name, description, field_ids, scenario_ids, loop, queue)
    VALUES ('9a9b85fb-6b8b-4b42-af5d-1d81d515e6b1', 'KPI-AS-001: Ability to anticipate (ATM)', '“The ability to anticipate. Knowing what to expect or being able to anticipate developments further into the future, such as potential disruptions, novel demands or constraints, new opportunities, or changing operating conditions” (Hollnagel, 2015, p. 4). <br/>The human operator’s ability to anticipate further into the future can be measured by calculating the ratio of (proactively) prevented deviations to actual deviations. In addition, the extent to which the anticipatory sensemaking process of the human operator is supported by AI-based assistants can be measured using the Rigor-Metric for Sensemaking (Zelik et al., 2018) or similar. The instrument needs to be further developed and adapted to the AI context. ', array['0c8a5446-bbc4-4a96-82bf-a53a86c10e9f']::uuid[], array['4cc07a90-fca8-4e96-b670-563c1e8f42fa']::uuid[], 'OFFLINE', 'ATM')
    ON CONFLICT(id) DO UPDATE SET name=EXCLUDED.name, description=EXCLUDED.description, field_ids=EXCLUDED.field_ids, scenario_ids=EXCLUDED.scenario_ids, loop=EXCLUDED.loop, queue=EXCLUDED.queue;

INSERT INTO field_definitions
        (id, key, description, agg_func, agg_weights)
        VALUES ('0c8a5446-bbc4-4a96-82bf-a53a86c10e9f', 'primary', 'Benchmark score (MEAN of test scores)', 'MEAN', NULL)
        ON CONFLICT(id) DO UPDATE SET key=EXCLUDED.key, description=EXCLUDED.description, agg_func=EXCLUDED.agg_func, agg_weights=EXCLUDED.agg_weights;

INSERT INTO scenario_definitions
    (id, name, description, field_ids)
    VALUES ('4cc07a90-fca8-4e96-b670-563c1e8f42fa', 'primary', 'This KPI contributes to evaluating Human user experience of the AI-based assistant, as part of Task 4.3 evaluation objectives, and O3 main project objective. ', array['38962aaa-3dfa-462a-9feb-399ebce13a2c']::uuid[])
    ON CONFLICT(id) DO UPDATE SET name=EXCLUDED.name, description=EXCLUDED.description, field_ids=EXCLUDED.field_ids;

INSERT INTO field_definitions
        (id, key, description, agg_func, agg_weights)
        VALUES ('38962aaa-3dfa-462a-9feb-399ebce13a2c', 'primary', 'Scenario score (raw values)', NULL, NULL)
        ON CONFLICT(id) DO UPDATE SET key=EXCLUDED.key, description=EXCLUDED.description, agg_func=EXCLUDED.agg_func, agg_weights=EXCLUDED.agg_weights;

INSERT INTO test_definitions
    (id, name, description, field_ids, scenario_ids, loop, queue)
    VALUES ('d4bcbd11-740a-478f-8dbc-6d9b53fa6059', 'KPI-AS-009: Assistant disturbance (Railway)', 'Assistant disturbance KPI aims to measure if the AI assistant''s notifications are disturbing the human operator''s activity. ', array['1d7ef549-2063-466b-b10a-6c78f79244cb']::uuid[], array['59d015ca-ca8a-4015-a113-35c182b301e4']::uuid[], 'OFFLINE', 'Railway')
    ON CONFLICT(id) DO UPDATE SET name=EXCLUDED.name, description=EXCLUDED.description, field_ids=EXCLUDED.field_ids, scenario_ids=EXCLUDED.scenario_ids, loop=EXCLUDED.loop, queue=EXCLUDED.queue;

INSERT INTO field_definitions
        (id, key, description, agg_func, agg_weights)
        VALUES ('1d7ef549-2063-466b-b10a-6c78f79244cb', 'primary', 'Benchmark score (MEAN of test scores)', 'MEAN', NULL)
        ON CONFLICT(id) DO UPDATE SET key=EXCLUDED.key, description=EXCLUDED.description, agg_func=EXCLUDED.agg_func, agg_weights=EXCLUDED.agg_weights;

INSERT INTO scenario_definitions
    (id, name, description, field_ids)
    VALUES ('59d015ca-ca8a-4015-a113-35c182b301e4', 'primary', 'This KPI assesses whether the inputs of the operators are according to their real psychophysiology. This can act as a verification methodology but also support the AI to adapt. <br/>This KPI contributes to evaluating Human-user experience of the AI-based assistant, as part of Task 4.3 evaluation objectives, and O3 main project objective. ', array['982a837c-0ac3-4367-a42b-a86ded8c8380']::uuid[])
    ON CONFLICT(id) DO UPDATE SET name=EXCLUDED.name, description=EXCLUDED.description, field_ids=EXCLUDED.field_ids;

INSERT INTO field_definitions
        (id, key, description, agg_func, agg_weights)
        VALUES ('982a837c-0ac3-4367-a42b-a86ded8c8380', 'primary', 'Scenario score (raw values)', NULL, NULL)
        ON CONFLICT(id) DO UPDATE SET key=EXCLUDED.key, description=EXCLUDED.description, agg_func=EXCLUDED.agg_func, agg_weights=EXCLUDED.agg_weights;

INSERT INTO test_definitions
    (id, name, description, field_ids, scenario_ids, loop, queue)
    VALUES ('6e005336-6c4c-43ae-ac8d-330d51ab48d4', 'KPI-AS-009: Assistant disturbance (Power Grid)', 'Assistant disturbance KPI aims to measure if the AI assistant''s notifications are disturbing the human operator''s activity. ', array['17130cde-b2a7-44b9-9681-d95bb943ec51']::uuid[], array['57c11d6d-0001-4623-9c1e-fbfc0744c8d5']::uuid[], 'OFFLINE', 'PowerGrid')
    ON CONFLICT(id) DO UPDATE SET name=EXCLUDED.name, description=EXCLUDED.description, field_ids=EXCLUDED.field_ids, scenario_ids=EXCLUDED.scenario_ids, loop=EXCLUDED.loop, queue=EXCLUDED.queue;

INSERT INTO field_definitions
        (id, key, description, agg_func, agg_weights)
        VALUES ('17130cde-b2a7-44b9-9681-d95bb943ec51', 'primary', 'Benchmark score (MEAN of test scores)', 'MEAN', NULL)
        ON CONFLICT(id) DO UPDATE SET key=EXCLUDED.key, description=EXCLUDED.description, agg_func=EXCLUDED.agg_func, agg_weights=EXCLUDED.agg_weights;

INSERT INTO scenario_definitions
    (id, name, description, field_ids)
    VALUES ('57c11d6d-0001-4623-9c1e-fbfc0744c8d5', 'primary', 'This KPI assesses whether the inputs of the operators are according to their real psychophysiology. This can act as a verification methodology but also support the AI to adapt. <br/>This KPI contributes to evaluating Human-user experience of the AI-based assistant, as part of Task 4.3 evaluation objectives, and O3 main project objective. ', array['632a41fd-7693-4c8c-bbc5-60dd4afa7da5']::uuid[])
    ON CONFLICT(id) DO UPDATE SET name=EXCLUDED.name, description=EXCLUDED.description, field_ids=EXCLUDED.field_ids;

INSERT INTO field_definitions
        (id, key, description, agg_func, agg_weights)
        VALUES ('632a41fd-7693-4c8c-bbc5-60dd4afa7da5', 'primary', 'Scenario score (raw values)', NULL, NULL)
        ON CONFLICT(id) DO UPDATE SET key=EXCLUDED.key, description=EXCLUDED.description, agg_func=EXCLUDED.agg_func, agg_weights=EXCLUDED.agg_weights;

INSERT INTO test_definitions
    (id, name, description, field_ids, scenario_ids, loop, queue)
    VALUES ('c2a22379-524a-4294-80b2-c751be726b70', 'KPI-AS-009: Assistant disturbance (ATM)', 'Assistant disturbance KPI aims to measure if the AI assistant''s notifications are disturbing the human operator''s activity. ', array['7a49884e-90f2-4ba8-946c-5a9039b0e340']::uuid[], array['76a0cad5-40fd-4b92-b904-5841aadf8a7d']::uuid[], 'OFFLINE', 'ATM')
    ON CONFLICT(id) DO UPDATE SET name=EXCLUDED.name, description=EXCLUDED.description, field_ids=EXCLUDED.field_ids, scenario_ids=EXCLUDED.scenario_ids, loop=EXCLUDED.loop, queue=EXCLUDED.queue;

INSERT INTO field_definitions
        (id, key, description, agg_func, agg_weights)
        VALUES ('7a49884e-90f2-4ba8-946c-5a9039b0e340', 'primary', 'Benchmark score (MEAN of test scores)', 'MEAN', NULL)
        ON CONFLICT(id) DO UPDATE SET key=EXCLUDED.key, description=EXCLUDED.description, agg_func=EXCLUDED.agg_func, agg_weights=EXCLUDED.agg_weights;

INSERT INTO scenario_definitions
    (id, name, description, field_ids)
    VALUES ('76a0cad5-40fd-4b92-b904-5841aadf8a7d', 'primary', 'This KPI assesses whether the inputs of the operators are according to their real psychophysiology. This can act as a verification methodology but also support the AI to adapt. <br/>This KPI contributes to evaluating Human-user experience of the AI-based assistant, as part of Task 4.3 evaluation objectives, and O3 main project objective. ', array['44e94f9b-bb27-43c1-894d-e16f83c1e5ea']::uuid[])
    ON CONFLICT(id) DO UPDATE SET name=EXCLUDED.name, description=EXCLUDED.description, field_ids=EXCLUDED.field_ids;

INSERT INTO field_definitions
        (id, key, description, agg_func, agg_weights)
        VALUES ('44e94f9b-bb27-43c1-894d-e16f83c1e5ea', 'primary', 'Scenario score (raw values)', NULL, NULL)
        ON CONFLICT(id) DO UPDATE SET key=EXCLUDED.key, description=EXCLUDED.description, agg_func=EXCLUDED.agg_func, agg_weights=EXCLUDED.agg_weights;

INSERT INTO test_definitions
    (id, name, description, field_ids, scenario_ids, loop, queue)
    VALUES ('22c590e5-01ad-4e96-9040-29a13ac9118f', 'KPI-DS-015: Decision support satisfaction (Railway)', 'This KPI represents human operators’ self-reported satisfaction with the system’s support for their decision-making process when working with the AI assistant measured with a questionnaire. ', array['208b30ea-3b59-49fc-b660-c45a1a7e9144']::uuid[], array['cbfe8dd3-e8df-464f-92cd-0adeab4a18b8']::uuid[], 'OFFLINE', 'Railway')
    ON CONFLICT(id) DO UPDATE SET name=EXCLUDED.name, description=EXCLUDED.description, field_ids=EXCLUDED.field_ids, scenario_ids=EXCLUDED.scenario_ids, loop=EXCLUDED.loop, queue=EXCLUDED.queue;

INSERT INTO field_definitions
        (id, key, description, agg_func, agg_weights)
        VALUES ('208b30ea-3b59-49fc-b660-c45a1a7e9144', 'primary', 'Benchmark score (MEAN of test scores)', 'MEAN', NULL)
        ON CONFLICT(id) DO UPDATE SET key=EXCLUDED.key, description=EXCLUDED.description, agg_func=EXCLUDED.agg_func, agg_weights=EXCLUDED.agg_weights;

INSERT INTO scenario_definitions
    (id, name, description, field_ids)
    VALUES ('cbfe8dd3-e8df-464f-92cd-0adeab4a18b8', 'primary', 'This KPI contributes to evaluating Human user experience of the AI-based assistant, as part of Task 4.3 evaluation objectives, and O3 main project objective. <br/>It is also relevant to protocols and concepts defined in D1.1 such as “Decision support for the human operator”, “Decision support satisfaction”.  ', array['0a9fe72d-eb7b-4d07-83d8-da256edbc26e']::uuid[])
    ON CONFLICT(id) DO UPDATE SET name=EXCLUDED.name, description=EXCLUDED.description, field_ids=EXCLUDED.field_ids;

INSERT INTO field_definitions
        (id, key, description, agg_func, agg_weights)
        VALUES ('0a9fe72d-eb7b-4d07-83d8-da256edbc26e', 'primary', 'Scenario score (raw values)', NULL, NULL)
        ON CONFLICT(id) DO UPDATE SET key=EXCLUDED.key, description=EXCLUDED.description, agg_func=EXCLUDED.agg_func, agg_weights=EXCLUDED.agg_weights;

INSERT INTO test_definitions
    (id, name, description, field_ids, scenario_ids, loop, queue)
    VALUES ('4a9db7b3-0dd9-4ac2-a211-ef5a991e4ab9', 'KPI-DS-015: Decision support satisfaction (Power Grid)', 'This KPI represents human operators’ self-reported satisfaction with the system’s support for their decision-making process when working with the AI assistant measured with a questionnaire. ', array['8474f229-ee4f-4e15-b633-ca313e08d852']::uuid[], array['3ac00dab-5671-4e60-bf35-99309075ee76']::uuid[], 'OFFLINE', 'PowerGrid')
    ON CONFLICT(id) DO UPDATE SET name=EXCLUDED.name, description=EXCLUDED.description, field_ids=EXCLUDED.field_ids, scenario_ids=EXCLUDED.scenario_ids, loop=EXCLUDED.loop, queue=EXCLUDED.queue;

INSERT INTO field_definitions
        (id, key, description, agg_func, agg_weights)
        VALUES ('8474f229-ee4f-4e15-b633-ca313e08d852', 'primary', 'Benchmark score (MEAN of test scores)', 'MEAN', NULL)
        ON CONFLICT(id) DO UPDATE SET key=EXCLUDED.key, description=EXCLUDED.description, agg_func=EXCLUDED.agg_func, agg_weights=EXCLUDED.agg_weights;

INSERT INTO scenario_definitions
    (id, name, description, field_ids)
    VALUES ('3ac00dab-5671-4e60-bf35-99309075ee76', 'primary', 'This KPI contributes to evaluating Human user experience of the AI-based assistant, as part of Task 4.3 evaluation objectives, and O3 main project objective. <br/>It is also relevant to protocols and concepts defined in D1.1 such as “Decision support for the human operator”, “Decision support satisfaction”.  ', array['97c2caaa-2cc4-4cf0-ac1b-9f9cb3765544']::uuid[])
    ON CONFLICT(id) DO UPDATE SET name=EXCLUDED.name, description=EXCLUDED.description, field_ids=EXCLUDED.field_ids;

INSERT INTO field_definitions
        (id, key, description, agg_func, agg_weights)
        VALUES ('97c2caaa-2cc4-4cf0-ac1b-9f9cb3765544', 'primary', 'Scenario score (raw values)', NULL, NULL)
        ON CONFLICT(id) DO UPDATE SET key=EXCLUDED.key, description=EXCLUDED.description, agg_func=EXCLUDED.agg_func, agg_weights=EXCLUDED.agg_weights;

INSERT INTO test_definitions
    (id, name, description, field_ids, scenario_ids, loop, queue)
    VALUES ('290debb4-eeff-408c-a680-28fce5b376e7', 'KPI-DS-015: Decision support satisfaction (ATM)', 'This KPI represents human operators’ self-reported satisfaction with the system’s support for their decision-making process when working with the AI assistant measured with a questionnaire. ', array['27ccb299-16f8-45dc-b90f-3b715cccaa72']::uuid[], array['22846c4e-e703-46c7-8069-38a6b6027a7d']::uuid[], 'OFFLINE', 'ATM')
    ON CONFLICT(id) DO UPDATE SET name=EXCLUDED.name, description=EXCLUDED.description, field_ids=EXCLUDED.field_ids, scenario_ids=EXCLUDED.scenario_ids, loop=EXCLUDED.loop, queue=EXCLUDED.queue;

INSERT INTO field_definitions
        (id, key, description, agg_func, agg_weights)
        VALUES ('27ccb299-16f8-45dc-b90f-3b715cccaa72', 'primary', 'Benchmark score (MEAN of test scores)', 'MEAN', NULL)
        ON CONFLICT(id) DO UPDATE SET key=EXCLUDED.key, description=EXCLUDED.description, agg_func=EXCLUDED.agg_func, agg_weights=EXCLUDED.agg_weights;

INSERT INTO scenario_definitions
    (id, name, description, field_ids)
    VALUES ('22846c4e-e703-46c7-8069-38a6b6027a7d', 'primary', 'This KPI contributes to evaluating Human user experience of the AI-based assistant, as part of Task 4.3 evaluation objectives, and O3 main project objective. <br/>It is also relevant to protocols and concepts defined in D1.1 such as “Decision support for the human operator”, “Decision support satisfaction”.  ', array['4ac569fa-97b1-4fa8-a7f0-f49a89fce80a']::uuid[])
    ON CONFLICT(id) DO UPDATE SET name=EXCLUDED.name, description=EXCLUDED.description, field_ids=EXCLUDED.field_ids;

INSERT INTO field_definitions
        (id, key, description, agg_func, agg_weights)
        VALUES ('4ac569fa-97b1-4fa8-a7f0-f49a89fce80a', 'primary', 'Scenario score (raw values)', NULL, NULL)
        ON CONFLICT(id) DO UPDATE SET key=EXCLUDED.key, description=EXCLUDED.description, agg_func=EXCLUDED.agg_func, agg_weights=EXCLUDED.agg_weights;

INSERT INTO test_definitions
    (id, name, description, field_ids, scenario_ids, loop, queue)
    VALUES ('05e91ee6-744b-47ea-85a0-005e26b578e0', 'KPI-HS-022: Human motivation (Railway)', '“Intrinsic motivation is defined as doing an activity for its inherent satisfaction rather than for some separable consequence. When intrinsically motivated, a person is moved to act for the fun or challenge entailed rather than because of external products, pressures, or rewards” (Ryan & Deci, 2000, p. 56). ', array['e0522a11-2f30-4cd8-9e88-b3fc9e289dcc']::uuid[], array['ab770463-5832-4edd-9ab2-178b7ee46b74']::uuid[], 'OFFLINE', 'Railway')
    ON CONFLICT(id) DO UPDATE SET name=EXCLUDED.name, description=EXCLUDED.description, field_ids=EXCLUDED.field_ids, scenario_ids=EXCLUDED.scenario_ids, loop=EXCLUDED.loop, queue=EXCLUDED.queue;

INSERT INTO field_definitions
        (id, key, description, agg_func, agg_weights)
        VALUES ('e0522a11-2f30-4cd8-9e88-b3fc9e289dcc', 'primary', 'Benchmark score (MEAN of test scores)', 'MEAN', NULL)
        ON CONFLICT(id) DO UPDATE SET key=EXCLUDED.key, description=EXCLUDED.description, agg_func=EXCLUDED.agg_func, agg_weights=EXCLUDED.agg_weights;

INSERT INTO scenario_definitions
    (id, name, description, field_ids)
    VALUES ('ab770463-5832-4edd-9ab2-178b7ee46b74', 'primary', 'This KPI contributes to evaluating Human-user experience of the AI-based assistant, as part of Task 4.3 evaluation objectives, and O3 main project objective. ', array['7d92aff2-1975-4bde-aaaf-788c4e2500d7']::uuid[])
    ON CONFLICT(id) DO UPDATE SET name=EXCLUDED.name, description=EXCLUDED.description, field_ids=EXCLUDED.field_ids;

INSERT INTO field_definitions
        (id, key, description, agg_func, agg_weights)
        VALUES ('7d92aff2-1975-4bde-aaaf-788c4e2500d7', 'primary', 'Scenario score (raw values)', NULL, NULL)
        ON CONFLICT(id) DO UPDATE SET key=EXCLUDED.key, description=EXCLUDED.description, agg_func=EXCLUDED.agg_func, agg_weights=EXCLUDED.agg_weights;

INSERT INTO test_definitions
    (id, name, description, field_ids, scenario_ids, loop, queue)
    VALUES ('d1ba73c3-6796-44db-8d87-129558e3535d', 'KPI-HS-022: Human motivation (Power Grid)', '“Intrinsic motivation is defined as doing an activity for its inherent satisfaction rather than for some separable consequence. When intrinsically motivated, a person is moved to act for the fun or challenge entailed rather than because of external products, pressures, or rewards” (Ryan & Deci, 2000, p. 56). ', array['78e3f5c5-32b8-4787-bf40-5623e573861b']::uuid[], array['ee4e4f46-9bc1-4da8-94b5-371ffddfab7e']::uuid[], 'OFFLINE', 'PowerGrid')
    ON CONFLICT(id) DO UPDATE SET name=EXCLUDED.name, description=EXCLUDED.description, field_ids=EXCLUDED.field_ids, scenario_ids=EXCLUDED.scenario_ids, loop=EXCLUDED.loop, queue=EXCLUDED.queue;

INSERT INTO field_definitions
        (id, key, description, agg_func, agg_weights)
        VALUES ('78e3f5c5-32b8-4787-bf40-5623e573861b', 'primary', 'Benchmark score (MEAN of test scores)', 'MEAN', NULL)
        ON CONFLICT(id) DO UPDATE SET key=EXCLUDED.key, description=EXCLUDED.description, agg_func=EXCLUDED.agg_func, agg_weights=EXCLUDED.agg_weights;

INSERT INTO scenario_definitions
    (id, name, description, field_ids)
    VALUES ('ee4e4f46-9bc1-4da8-94b5-371ffddfab7e', 'primary', 'This KPI contributes to evaluating Human-user experience of the AI-based assistant, as part of Task 4.3 evaluation objectives, and O3 main project objective. ', array['a2d30aad-9211-415d-8900-6a899dc9dee2']::uuid[])
    ON CONFLICT(id) DO UPDATE SET name=EXCLUDED.name, description=EXCLUDED.description, field_ids=EXCLUDED.field_ids;

INSERT INTO field_definitions
        (id, key, description, agg_func, agg_weights)
        VALUES ('a2d30aad-9211-415d-8900-6a899dc9dee2', 'primary', 'Scenario score (raw values)', NULL, NULL)
        ON CONFLICT(id) DO UPDATE SET key=EXCLUDED.key, description=EXCLUDED.description, agg_func=EXCLUDED.agg_func, agg_weights=EXCLUDED.agg_weights;

INSERT INTO test_definitions
    (id, name, description, field_ids, scenario_ids, loop, queue)
    VALUES ('ebd2a832-1c69-4d87-9de2-4a283e7c7f37', 'KPI-HS-022: Human motivation (ATM)', '“Intrinsic motivation is defined as doing an activity for its inherent satisfaction rather than for some separable consequence. When intrinsically motivated, a person is moved to act for the fun or challenge entailed rather than because of external products, pressures, or rewards” (Ryan & Deci, 2000, p. 56). ', array['4cae7347-89b5-4c89-aed4-7d2c374b45d5']::uuid[], array['4f81efc4-4c7d-4973-9fb6-1fccbe11fcd4']::uuid[], 'OFFLINE', 'ATM')
    ON CONFLICT(id) DO UPDATE SET name=EXCLUDED.name, description=EXCLUDED.description, field_ids=EXCLUDED.field_ids, scenario_ids=EXCLUDED.scenario_ids, loop=EXCLUDED.loop, queue=EXCLUDED.queue;

INSERT INTO field_definitions
        (id, key, description, agg_func, agg_weights)
        VALUES ('4cae7347-89b5-4c89-aed4-7d2c374b45d5', 'primary', 'Benchmark score (MEAN of test scores)', 'MEAN', NULL)
        ON CONFLICT(id) DO UPDATE SET key=EXCLUDED.key, description=EXCLUDED.description, agg_func=EXCLUDED.agg_func, agg_weights=EXCLUDED.agg_weights;

INSERT INTO scenario_definitions
    (id, name, description, field_ids)
    VALUES ('4f81efc4-4c7d-4973-9fb6-1fccbe11fcd4', 'primary', 'This KPI contributes to evaluating Human-user experience of the AI-based assistant, as part of Task 4.3 evaluation objectives, and O3 main project objective. ', array['8d986c1d-3a36-4f03-81cd-790beaedd4ea']::uuid[])
    ON CONFLICT(id) DO UPDATE SET name=EXCLUDED.name, description=EXCLUDED.description, field_ids=EXCLUDED.field_ids;

INSERT INTO field_definitions
        (id, key, description, agg_func, agg_weights)
        VALUES ('8d986c1d-3a36-4f03-81cd-790beaedd4ea', 'primary', 'Scenario score (raw values)', NULL, NULL)
        ON CONFLICT(id) DO UPDATE SET key=EXCLUDED.key, description=EXCLUDED.description, agg_func=EXCLUDED.agg_func, agg_weights=EXCLUDED.agg_weights;

INSERT INTO test_definitions
    (id, name, description, field_ids, scenario_ids, loop, queue)
    VALUES ('40398221-b288-46d9-895c-45d278f1b6a3', 'KPI-HS-023: Human response time (Railway)', 'Human response time KPI evaluates time needed to react to AI advisory/information. ', array['697e097d-ecd3-4ec5-bd46-cd98129ba28d']::uuid[], array['35cf47d4-83f4-4eb7-ab9b-40c6fe7679a8']::uuid[], 'INTERACTIVE', 'Railway')
    ON CONFLICT(id) DO UPDATE SET name=EXCLUDED.name, description=EXCLUDED.description, field_ids=EXCLUDED.field_ids, scenario_ids=EXCLUDED.scenario_ids, loop=EXCLUDED.loop, queue=EXCLUDED.queue;

INSERT INTO field_definitions
        (id, key, description, agg_func, agg_weights)
        VALUES ('697e097d-ecd3-4ec5-bd46-cd98129ba28d', 'primary', 'Benchmark score (MEAN of test scores)', 'MEAN', NULL)
        ON CONFLICT(id) DO UPDATE SET key=EXCLUDED.key, description=EXCLUDED.description, agg_func=EXCLUDED.agg_func, agg_weights=EXCLUDED.agg_weights;

INSERT INTO scenario_definitions
    (id, name, description, field_ids)
    VALUES ('35cf47d4-83f4-4eb7-ab9b-40c6fe7679a8', 'primary', 'This KPI assesses whether the inputs of the operators are according to their real psychophysiology. This can act as a verification methodology but also support the AI to adapt. <br/>This KPI contributes to evaluating Human-user experience of the AI-based assistant, as part of Task 4.3 evaluation objectives, and O3 main project objective. ', array['08d0afa1-026b-43cb-9d7e-097a272e6353']::uuid[])
    ON CONFLICT(id) DO UPDATE SET name=EXCLUDED.name, description=EXCLUDED.description, field_ids=EXCLUDED.field_ids;

INSERT INTO field_definitions
        (id, key, description, agg_func, agg_weights)
        VALUES ('08d0afa1-026b-43cb-9d7e-097a272e6353', 'primary', 'Scenario score (raw values)', NULL, NULL)
        ON CONFLICT(id) DO UPDATE SET key=EXCLUDED.key, description=EXCLUDED.description, agg_func=EXCLUDED.agg_func, agg_weights=EXCLUDED.agg_weights;

INSERT INTO test_definitions
    (id, name, description, field_ids, scenario_ids, loop, queue)
    VALUES ('dbd85bfb-2e78-4646-b2da-b4d16e90e657', 'KPI-HS-023: Human response time (Power Grid)', 'Human response time KPI evaluates time needed to react to AI advisory/information. ', array['bd729f10-2260-4959-b416-5d8c9d04648e']::uuid[], array['d64548d6-2eb6-4e1e-8069-73c0ece64318']::uuid[], 'INTERACTIVE', 'PowerGrid')
    ON CONFLICT(id) DO UPDATE SET name=EXCLUDED.name, description=EXCLUDED.description, field_ids=EXCLUDED.field_ids, scenario_ids=EXCLUDED.scenario_ids, loop=EXCLUDED.loop, queue=EXCLUDED.queue;

INSERT INTO field_definitions
        (id, key, description, agg_func, agg_weights)
        VALUES ('bd729f10-2260-4959-b416-5d8c9d04648e', 'primary', 'Benchmark score (MEAN of test scores)', 'MEAN', NULL)
        ON CONFLICT(id) DO UPDATE SET key=EXCLUDED.key, description=EXCLUDED.description, agg_func=EXCLUDED.agg_func, agg_weights=EXCLUDED.agg_weights;

INSERT INTO scenario_definitions
    (id, name, description, field_ids)
    VALUES ('d64548d6-2eb6-4e1e-8069-73c0ece64318', 'primary', 'This KPI assesses whether the inputs of the operators are according to their real psychophysiology. This can act as a verification methodology but also support the AI to adapt. <br/>This KPI contributes to evaluating Human-user experience of the AI-based assistant, as part of Task 4.3 evaluation objectives, and O3 main project objective. ', array['7dc59090-50a9-4ffc-8184-959feb2f30c0']::uuid[])
    ON CONFLICT(id) DO UPDATE SET name=EXCLUDED.name, description=EXCLUDED.description, field_ids=EXCLUDED.field_ids;

INSERT INTO field_definitions
        (id, key, description, agg_func, agg_weights)
        VALUES ('7dc59090-50a9-4ffc-8184-959feb2f30c0', 'primary', 'Scenario score (raw values)', NULL, NULL)
        ON CONFLICT(id) DO UPDATE SET key=EXCLUDED.key, description=EXCLUDED.description, agg_func=EXCLUDED.agg_func, agg_weights=EXCLUDED.agg_weights;

INSERT INTO test_definitions
    (id, name, description, field_ids, scenario_ids, loop, queue)
    VALUES ('e52b585d-0da8-4a88-97ff-0953a62a548c', 'KPI-HS-023: Human response time (ATM)', 'Human response time KPI evaluates time needed to react to AI advisory/information. ', array['b50efa99-b82e-4c75-8204-afa8c17a52f0']::uuid[], array['f1278028-1c96-485c-bd6b-046d4356c335']::uuid[], 'INTERACTIVE', 'ATM')
    ON CONFLICT(id) DO UPDATE SET name=EXCLUDED.name, description=EXCLUDED.description, field_ids=EXCLUDED.field_ids, scenario_ids=EXCLUDED.scenario_ids, loop=EXCLUDED.loop, queue=EXCLUDED.queue;

INSERT INTO field_definitions
        (id, key, description, agg_func, agg_weights)
        VALUES ('b50efa99-b82e-4c75-8204-afa8c17a52f0', 'primary', 'Benchmark score (MEAN of test scores)', 'MEAN', NULL)
        ON CONFLICT(id) DO UPDATE SET key=EXCLUDED.key, description=EXCLUDED.description, agg_func=EXCLUDED.agg_func, agg_weights=EXCLUDED.agg_weights;

INSERT INTO scenario_definitions
    (id, name, description, field_ids)
    VALUES ('f1278028-1c96-485c-bd6b-046d4356c335', 'primary', 'This KPI assesses whether the inputs of the operators are according to their real psychophysiology. This can act as a verification methodology but also support the AI to adapt. <br/>This KPI contributes to evaluating Human-user experience of the AI-based assistant, as part of Task 4.3 evaluation objectives, and O3 main project objective. ', array['f8401749-6e84-4a36-adf8-3e2d2b8c8fe3']::uuid[])
    ON CONFLICT(id) DO UPDATE SET name=EXCLUDED.name, description=EXCLUDED.description, field_ids=EXCLUDED.field_ids;

INSERT INTO field_definitions
        (id, key, description, agg_func, agg_weights)
        VALUES ('f8401749-6e84-4a36-adf8-3e2d2b8c8fe3', 'primary', 'Scenario score (raw values)', NULL, NULL)
        ON CONFLICT(id) DO UPDATE SET key=EXCLUDED.key, description=EXCLUDED.description, agg_func=EXCLUDED.agg_func, agg_weights=EXCLUDED.agg_weights;

INSERT INTO test_definitions
    (id, name, description, field_ids, scenario_ids, loop, queue)
    VALUES ('307bce4c-635f-44c3-9ed2-6d4d45d1bbb2', 'KPI-SS-031: Situation awareness (Railway)', '“Situation Awareness is the perception of the elements in the environment within a volume of time and space, the comprehension of their meaning, and the projection of their status in the near future” (Endsley, 1988). ', array['d98d5fed-b2b9-4e3c-a3a6-30e666514ccd']::uuid[], array['3131063f-5d0e-42bd-955d-5e875ceaac94']::uuid[], 'OFFLINE', 'Railway')
    ON CONFLICT(id) DO UPDATE SET name=EXCLUDED.name, description=EXCLUDED.description, field_ids=EXCLUDED.field_ids, scenario_ids=EXCLUDED.scenario_ids, loop=EXCLUDED.loop, queue=EXCLUDED.queue;

INSERT INTO field_definitions
        (id, key, description, agg_func, agg_weights)
        VALUES ('d98d5fed-b2b9-4e3c-a3a6-30e666514ccd', 'primary', 'Benchmark score (MEAN of test scores)', 'MEAN', NULL)
        ON CONFLICT(id) DO UPDATE SET key=EXCLUDED.key, description=EXCLUDED.description, agg_func=EXCLUDED.agg_func, agg_weights=EXCLUDED.agg_weights;

INSERT INTO scenario_definitions
    (id, name, description, field_ids)
    VALUES ('3131063f-5d0e-42bd-955d-5e875ceaac94', 'primary', 'This KPI contributes to evaluating Human-user experience of the AI-based assistant, as part of Task 4.3 evaluation objectives, and O3 main project objective. ', array['5aa8e601-0374-4438-bb7b-aab98db7bd6c']::uuid[])
    ON CONFLICT(id) DO UPDATE SET name=EXCLUDED.name, description=EXCLUDED.description, field_ids=EXCLUDED.field_ids;

INSERT INTO field_definitions
        (id, key, description, agg_func, agg_weights)
        VALUES ('5aa8e601-0374-4438-bb7b-aab98db7bd6c', 'primary', 'Scenario score (raw values)', NULL, NULL)
        ON CONFLICT(id) DO UPDATE SET key=EXCLUDED.key, description=EXCLUDED.description, agg_func=EXCLUDED.agg_func, agg_weights=EXCLUDED.agg_weights;

INSERT INTO test_definitions
    (id, name, description, field_ids, scenario_ids, loop, queue)
    VALUES ('4166c200-b50e-4e2e-a3a7-05f31e7f78f8', 'KPI-SS-031: Situation awareness (Power Grid)', '“Situation Awareness is the perception of the elements in the environment within a volume of time and space, the comprehension of their meaning, and the projection of their status in the near future” (Endsley, 1988). ', array['9c0de891-220a-4bd6-be4d-598fbcc898d0']::uuid[], array['5096d57a-00a3-4018-bdc3-02cd28443a85']::uuid[], 'OFFLINE', 'PowerGrid')
    ON CONFLICT(id) DO UPDATE SET name=EXCLUDED.name, description=EXCLUDED.description, field_ids=EXCLUDED.field_ids, scenario_ids=EXCLUDED.scenario_ids, loop=EXCLUDED.loop, queue=EXCLUDED.queue;

INSERT INTO field_definitions
        (id, key, description, agg_func, agg_weights)
        VALUES ('9c0de891-220a-4bd6-be4d-598fbcc898d0', 'primary', 'Benchmark score (MEAN of test scores)', 'MEAN', NULL)
        ON CONFLICT(id) DO UPDATE SET key=EXCLUDED.key, description=EXCLUDED.description, agg_func=EXCLUDED.agg_func, agg_weights=EXCLUDED.agg_weights;

INSERT INTO scenario_definitions
    (id, name, description, field_ids)
    VALUES ('5096d57a-00a3-4018-bdc3-02cd28443a85', 'primary', 'This KPI contributes to evaluating Human-user experience of the AI-based assistant, as part of Task 4.3 evaluation objectives, and O3 main project objective. ', array['5c524071-0d18-4982-aae9-b7a00fe4e397']::uuid[])
    ON CONFLICT(id) DO UPDATE SET name=EXCLUDED.name, description=EXCLUDED.description, field_ids=EXCLUDED.field_ids;

INSERT INTO field_definitions
        (id, key, description, agg_func, agg_weights)
        VALUES ('5c524071-0d18-4982-aae9-b7a00fe4e397', 'primary', 'Scenario score (raw values)', NULL, NULL)
        ON CONFLICT(id) DO UPDATE SET key=EXCLUDED.key, description=EXCLUDED.description, agg_func=EXCLUDED.agg_func, agg_weights=EXCLUDED.agg_weights;

INSERT INTO test_definitions
    (id, name, description, field_ids, scenario_ids, loop, queue)
    VALUES ('26bf1860-4b1c-4fed-8f81-53dac6a8f8f7', 'KPI-SS-031: Situation awareness (ATM)', '“Situation Awareness is the perception of the elements in the environment within a volume of time and space, the comprehension of their meaning, and the projection of their status in the near future” (Endsley, 1988). ', array['e67962af-0e35-4b32-97f9-dc661bf07f10']::uuid[], array['f8fc8712-e092-458e-a1e6-3733f5bc65ea']::uuid[], 'OFFLINE', 'ATM')
    ON CONFLICT(id) DO UPDATE SET name=EXCLUDED.name, description=EXCLUDED.description, field_ids=EXCLUDED.field_ids, scenario_ids=EXCLUDED.scenario_ids, loop=EXCLUDED.loop, queue=EXCLUDED.queue;

INSERT INTO field_definitions
        (id, key, description, agg_func, agg_weights)
        VALUES ('e67962af-0e35-4b32-97f9-dc661bf07f10', 'primary', 'Benchmark score (MEAN of test scores)', 'MEAN', NULL)
        ON CONFLICT(id) DO UPDATE SET key=EXCLUDED.key, description=EXCLUDED.description, agg_func=EXCLUDED.agg_func, agg_weights=EXCLUDED.agg_weights;

INSERT INTO scenario_definitions
    (id, name, description, field_ids)
    VALUES ('f8fc8712-e092-458e-a1e6-3733f5bc65ea', 'primary', 'This KPI contributes to evaluating Human-user experience of the AI-based assistant, as part of Task 4.3 evaluation objectives, and O3 main project objective. ', array['c6e50936-cfb5-4ff4-b28a-bc51fcf6af0e']::uuid[])
    ON CONFLICT(id) DO UPDATE SET name=EXCLUDED.name, description=EXCLUDED.description, field_ids=EXCLUDED.field_ids;

INSERT INTO field_definitions
        (id, key, description, agg_func, agg_weights)
        VALUES ('c6e50936-cfb5-4ff4-b28a-bc51fcf6af0e', 'primary', 'Scenario score (raw values)', NULL, NULL)
        ON CONFLICT(id) DO UPDATE SET key=EXCLUDED.key, description=EXCLUDED.description, agg_func=EXCLUDED.agg_func, agg_weights=EXCLUDED.agg_weights;

INSERT INTO test_definitions
    (id, name, description, field_ids, scenario_ids, loop, queue)
    VALUES ('343bc5cf-0bab-4fdf-9760-266c5a738b08', 'KPI-WS-040: Workload (Railway)', 'Workload KPI is based on the workload assessment of human operators of the AI assistant. <br/>After each testing session using the system, the workload of human operators due to the AI assistant will be evaluated to understand in which scenarios (and depending on the AI level of support) it contributes for a higher workload. ', array['80e0473e-e63a-4398-b592-66b2541a8dde']::uuid[], array['c3ab2e6b-e8ed-420e-b6d2-4fd5dd407288']::uuid[], 'OFFLINE', 'Railway')
    ON CONFLICT(id) DO UPDATE SET name=EXCLUDED.name, description=EXCLUDED.description, field_ids=EXCLUDED.field_ids, scenario_ids=EXCLUDED.scenario_ids, loop=EXCLUDED.loop, queue=EXCLUDED.queue;

INSERT INTO field_definitions
        (id, key, description, agg_func, agg_weights)
        VALUES ('80e0473e-e63a-4398-b592-66b2541a8dde', 'primary', 'Benchmark score (MEAN of test scores)', 'MEAN', NULL)
        ON CONFLICT(id) DO UPDATE SET key=EXCLUDED.key, description=EXCLUDED.description, agg_func=EXCLUDED.agg_func, agg_weights=EXCLUDED.agg_weights;

INSERT INTO scenario_definitions
    (id, name, description, field_ids)
    VALUES ('c3ab2e6b-e8ed-420e-b6d2-4fd5dd407288', 'primary', 'This KPI assesses whether the inputs of the operators are according to their real psychophysiology. This can act as a verification methodology but also support the AI to adapt. <br/>This KPI will be analyzed together with the “Impact on workload” KPI-IS-041. <br/>This KPI contributes to evaluating Human-user experience of the AI-based assistant, as part of Task 4.3 evaluation objectives, and O3 main project objective. ', array['c7e129de-357d-4f39-8963-76155c72e2bc']::uuid[])
    ON CONFLICT(id) DO UPDATE SET name=EXCLUDED.name, description=EXCLUDED.description, field_ids=EXCLUDED.field_ids;

INSERT INTO field_definitions
        (id, key, description, agg_func, agg_weights)
        VALUES ('c7e129de-357d-4f39-8963-76155c72e2bc', 'primary', 'Scenario score (raw values)', NULL, NULL)
        ON CONFLICT(id) DO UPDATE SET key=EXCLUDED.key, description=EXCLUDED.description, agg_func=EXCLUDED.agg_func, agg_weights=EXCLUDED.agg_weights;

INSERT INTO test_definitions
    (id, name, description, field_ids, scenario_ids, loop, queue)
    VALUES ('66c08000-9a5e-42ca-a328-8e6295069142', 'KPI-WS-040: Workload (Power Grid)', 'Workload KPI is based on the workload assessment of human operators of the AI assistant. <br/>After each testing session using the system, the workload of human operators due to the AI assistant will be evaluated to understand in which scenarios (and depending on the AI level of support) it contributes for a higher workload. ', array['be9cbb52-ef44-4679-8c8d-f1b3c12e9aaa']::uuid[], array['06f61acd-da79-493c-8da0-4a1327b5fe6a']::uuid[], 'OFFLINE', 'PowerGrid')
    ON CONFLICT(id) DO UPDATE SET name=EXCLUDED.name, description=EXCLUDED.description, field_ids=EXCLUDED.field_ids, scenario_ids=EXCLUDED.scenario_ids, loop=EXCLUDED.loop, queue=EXCLUDED.queue;

INSERT INTO field_definitions
        (id, key, description, agg_func, agg_weights)
        VALUES ('be9cbb52-ef44-4679-8c8d-f1b3c12e9aaa', 'primary', 'Benchmark score (MEAN of test scores)', 'MEAN', NULL)
        ON CONFLICT(id) DO UPDATE SET key=EXCLUDED.key, description=EXCLUDED.description, agg_func=EXCLUDED.agg_func, agg_weights=EXCLUDED.agg_weights;

INSERT INTO scenario_definitions
    (id, name, description, field_ids)
    VALUES ('06f61acd-da79-493c-8da0-4a1327b5fe6a', 'primary', 'This KPI assesses whether the inputs of the operators are according to their real psychophysiology. This can act as a verification methodology but also support the AI to adapt. <br/>This KPI will be analyzed together with the “Impact on workload” KPI-IS-041. <br/>This KPI contributes to evaluating Human-user experience of the AI-based assistant, as part of Task 4.3 evaluation objectives, and O3 main project objective. ', array['11f79947-fc38-40cf-acaf-ad89adde60b4']::uuid[])
    ON CONFLICT(id) DO UPDATE SET name=EXCLUDED.name, description=EXCLUDED.description, field_ids=EXCLUDED.field_ids;

INSERT INTO field_definitions
        (id, key, description, agg_func, agg_weights)
        VALUES ('11f79947-fc38-40cf-acaf-ad89adde60b4', 'primary', 'Scenario score (raw values)', NULL, NULL)
        ON CONFLICT(id) DO UPDATE SET key=EXCLUDED.key, description=EXCLUDED.description, agg_func=EXCLUDED.agg_func, agg_weights=EXCLUDED.agg_weights;

INSERT INTO test_definitions
    (id, name, description, field_ids, scenario_ids, loop, queue)
    VALUES ('96396992-ab9a-45b8-9833-124b46925da6', 'KPI-WS-040: Workload (ATM)', 'Workload KPI is based on the workload assessment of human operators of the AI assistant. <br/>After each testing session using the system, the workload of human operators due to the AI assistant will be evaluated to understand in which scenarios (and depending on the AI level of support) it contributes for a higher workload. ', array['c5762f88-bd6b-45c6-871f-c34ff539b1a1']::uuid[], array['88a26ad8-bd41-4c4b-9f10-ee7876550752']::uuid[], 'OFFLINE', 'ATM')
    ON CONFLICT(id) DO UPDATE SET name=EXCLUDED.name, description=EXCLUDED.description, field_ids=EXCLUDED.field_ids, scenario_ids=EXCLUDED.scenario_ids, loop=EXCLUDED.loop, queue=EXCLUDED.queue;

INSERT INTO field_definitions
        (id, key, description, agg_func, agg_weights)
        VALUES ('c5762f88-bd6b-45c6-871f-c34ff539b1a1', 'primary', 'Benchmark score (MEAN of test scores)', 'MEAN', NULL)
        ON CONFLICT(id) DO UPDATE SET key=EXCLUDED.key, description=EXCLUDED.description, agg_func=EXCLUDED.agg_func, agg_weights=EXCLUDED.agg_weights;

INSERT INTO scenario_definitions
    (id, name, description, field_ids)
    VALUES ('88a26ad8-bd41-4c4b-9f10-ee7876550752', 'primary', 'This KPI assesses whether the inputs of the operators are according to their real psychophysiology. This can act as a verification methodology but also support the AI to adapt. <br/>This KPI will be analyzed together with the “Impact on workload” KPI-IS-041. <br/>This KPI contributes to evaluating Human-user experience of the AI-based assistant, as part of Task 4.3 evaluation objectives, and O3 main project objective. ', array['7c5551cb-971e-4d20-87bf-f32698f071c8']::uuid[])
    ON CONFLICT(id) DO UPDATE SET name=EXCLUDED.name, description=EXCLUDED.description, field_ids=EXCLUDED.field_ids;

INSERT INTO field_definitions
        (id, key, description, agg_func, agg_weights)
        VALUES ('7c5551cb-971e-4d20-87bf-f32698f071c8', 'primary', 'Scenario score (raw values)', NULL, NULL)
        ON CONFLICT(id) DO UPDATE SET key=EXCLUDED.key, description=EXCLUDED.description, agg_func=EXCLUDED.agg_func, agg_weights=EXCLUDED.agg_weights;

INSERT INTO test_definitions
    (id, name, description, field_ids, scenario_ids, loop, queue)
    VALUES ('452bb0df-9a9d-4475-ac7b-8e62659c0b13', 'KPI-CS-049: Cognitive Performance & Stress (Railway)', 'Cognitive Performance & Stress KPI performs an implicit assessment of the human cognitive performance status and stress levels along the different task that will be performed. The output provides information about the operator mental status and aims to be used to integrate the AI system to contribute as a reward to better adapt decision system. ', array['6b69647e-d663-4f90-ab14-dc4f5335f390']::uuid[], array['76d73b49-ff52-4b9a-96e2-cc664582c8e4']::uuid[], 'INTERACTIVE', 'Railway')
    ON CONFLICT(id) DO UPDATE SET name=EXCLUDED.name, description=EXCLUDED.description, field_ids=EXCLUDED.field_ids, scenario_ids=EXCLUDED.scenario_ids, loop=EXCLUDED.loop, queue=EXCLUDED.queue;

INSERT INTO field_definitions
        (id, key, description, agg_func, agg_weights)
        VALUES ('6b69647e-d663-4f90-ab14-dc4f5335f390', 'primary', 'Benchmark score (MEAN of test scores)', 'MEAN', NULL)
        ON CONFLICT(id) DO UPDATE SET key=EXCLUDED.key, description=EXCLUDED.description, agg_func=EXCLUDED.agg_func, agg_weights=EXCLUDED.agg_weights;

INSERT INTO scenario_definitions
    (id, name, description, field_ids)
    VALUES ('76d73b49-ff52-4b9a-96e2-cc664582c8e4', 'primary', 'The computation of the metrics will be made on the Human Assessment Module and will be integrated in the system that will Tune the autonomy Level of the system. Taking this into account, the objective is to be able to tune the system autonomy level based on the implicit assessment in real time.  <br/>For example, higher traffic or hard situations/decisions will be detected with any interference with the human operator, implicitly providing information to be used by the decision system. <br/>This KPI will not focus on the final results when this module is integrated, but in the calculation of personalized cognitive and stress metrics of a single human based on an individual assessment protocol. If we are not able to perform such protocol, then this module will be generic and not personalized, removing this KPIs. In the personalization we aim to achieve a 20-30% improvement on performance of the model based for a single individual data, enabling a high level of personalization. <br/>This KPI contributes to evaluating Human-user experience of the AI-based assistant, as part of Task 4.3 evaluation objectives, and O3 main project objective. ', array['f1878cc0-4767-4c54-9df5-32f4a03c84bc']::uuid[])
    ON CONFLICT(id) DO UPDATE SET name=EXCLUDED.name, description=EXCLUDED.description, field_ids=EXCLUDED.field_ids;

INSERT INTO field_definitions
        (id, key, description, agg_func, agg_weights)
        VALUES ('f1878cc0-4767-4c54-9df5-32f4a03c84bc', 'primary', 'Scenario score (raw values)', NULL, NULL)
        ON CONFLICT(id) DO UPDATE SET key=EXCLUDED.key, description=EXCLUDED.description, agg_func=EXCLUDED.agg_func, agg_weights=EXCLUDED.agg_weights;

INSERT INTO test_definitions
    (id, name, description, field_ids, scenario_ids, loop, queue)
    VALUES ('62bcfa08-99ce-4bfe-b7a4-08343ef3a316', 'KPI-CS-049: Cognitive Performance & Stress (Power Grid)', 'Cognitive Performance & Stress KPI performs an implicit assessment of the human cognitive performance status and stress levels along the different task that will be performed. The output provides information about the operator mental status and aims to be used to integrate the AI system to contribute as a reward to better adapt decision system. ', array['d839a03d-c127-4c01-84cb-09b3845f8775']::uuid[], array['6ae869dc-40e3-4cd0-a02c-6541a838b5b3']::uuid[], 'INTERACTIVE', 'PowerGrid')
    ON CONFLICT(id) DO UPDATE SET name=EXCLUDED.name, description=EXCLUDED.description, field_ids=EXCLUDED.field_ids, scenario_ids=EXCLUDED.scenario_ids, loop=EXCLUDED.loop, queue=EXCLUDED.queue;

INSERT INTO field_definitions
        (id, key, description, agg_func, agg_weights)
        VALUES ('d839a03d-c127-4c01-84cb-09b3845f8775', 'primary', 'Benchmark score (MEAN of test scores)', 'MEAN', NULL)
        ON CONFLICT(id) DO UPDATE SET key=EXCLUDED.key, description=EXCLUDED.description, agg_func=EXCLUDED.agg_func, agg_weights=EXCLUDED.agg_weights;

INSERT INTO scenario_definitions
    (id, name, description, field_ids)
    VALUES ('6ae869dc-40e3-4cd0-a02c-6541a838b5b3', 'primary', 'The computation of the metrics will be made on the Human Assessment Module and will be integrated in the system that will Tune the autonomy Level of the system. Taking this into account, the objective is to be able to tune the system autonomy level based on the implicit assessment in real time.  <br/>For example, higher traffic or hard situations/decisions will be detected with any interference with the human operator, implicitly providing information to be used by the decision system. <br/>This KPI will not focus on the final results when this module is integrated, but in the calculation of personalized cognitive and stress metrics of a single human based on an individual assessment protocol. If we are not able to perform such protocol, then this module will be generic and not personalized, removing this KPIs. In the personalization we aim to achieve a 20-30% improvement on performance of the model based for a single individual data, enabling a high level of personalization. <br/>This KPI contributes to evaluating Human-user experience of the AI-based assistant, as part of Task 4.3 evaluation objectives, and O3 main project objective. ', array['596704a6-32b5-4694-bce5-2534a2edb8ac']::uuid[])
    ON CONFLICT(id) DO UPDATE SET name=EXCLUDED.name, description=EXCLUDED.description, field_ids=EXCLUDED.field_ids;

INSERT INTO field_definitions
        (id, key, description, agg_func, agg_weights)
        VALUES ('596704a6-32b5-4694-bce5-2534a2edb8ac', 'primary', 'Scenario score (raw values)', NULL, NULL)
        ON CONFLICT(id) DO UPDATE SET key=EXCLUDED.key, description=EXCLUDED.description, agg_func=EXCLUDED.agg_func, agg_weights=EXCLUDED.agg_weights;

INSERT INTO test_definitions
    (id, name, description, field_ids, scenario_ids, loop, queue)
    VALUES ('ebd44326-8c9b-4144-8e31-8c360b148dd3', 'KPI-CS-049: Cognitive Performance & Stress (ATM)', 'Cognitive Performance & Stress KPI performs an implicit assessment of the human cognitive performance status and stress levels along the different task that will be performed. The output provides information about the operator mental status and aims to be used to integrate the AI system to contribute as a reward to better adapt decision system. ', array['476cf7e9-c34a-466e-8fed-53e66d55c10a']::uuid[], array['4b04f1b7-a4b0-4b71-8f75-6a222bb05284']::uuid[], 'INTERACTIVE', 'ATM')
    ON CONFLICT(id) DO UPDATE SET name=EXCLUDED.name, description=EXCLUDED.description, field_ids=EXCLUDED.field_ids, scenario_ids=EXCLUDED.scenario_ids, loop=EXCLUDED.loop, queue=EXCLUDED.queue;

INSERT INTO field_definitions
        (id, key, description, agg_func, agg_weights)
        VALUES ('476cf7e9-c34a-466e-8fed-53e66d55c10a', 'primary', 'Benchmark score (MEAN of test scores)', 'MEAN', NULL)
        ON CONFLICT(id) DO UPDATE SET key=EXCLUDED.key, description=EXCLUDED.description, agg_func=EXCLUDED.agg_func, agg_weights=EXCLUDED.agg_weights;

INSERT INTO scenario_definitions
    (id, name, description, field_ids)
    VALUES ('4b04f1b7-a4b0-4b71-8f75-6a222bb05284', 'primary', 'The computation of the metrics will be made on the Human Assessment Module and will be integrated in the system that will Tune the autonomy Level of the system. Taking this into account, the objective is to be able to tune the system autonomy level based on the implicit assessment in real time.  <br/>For example, higher traffic or hard situations/decisions will be detected with any interference with the human operator, implicitly providing information to be used by the decision system. <br/>This KPI will not focus on the final results when this module is integrated, but in the calculation of personalized cognitive and stress metrics of a single human based on an individual assessment protocol. If we are not able to perform such protocol, then this module will be generic and not personalized, removing this KPIs. In the personalization we aim to achieve a 20-30% improvement on performance of the model based for a single individual data, enabling a high level of personalization. <br/>This KPI contributes to evaluating Human-user experience of the AI-based assistant, as part of Task 4.3 evaluation objectives, and O3 main project objective. ', array['6e7acf6f-aead-444f-b797-f7d18c592819']::uuid[])
    ON CONFLICT(id) DO UPDATE SET name=EXCLUDED.name, description=EXCLUDED.description, field_ids=EXCLUDED.field_ids;

INSERT INTO field_definitions
        (id, key, description, agg_func, agg_weights)
        VALUES ('6e7acf6f-aead-444f-b797-f7d18c592819', 'primary', 'Scenario score (raw values)', NULL, NULL)
        ON CONFLICT(id) DO UPDATE SET key=EXCLUDED.key, description=EXCLUDED.description, agg_func=EXCLUDED.agg_func, agg_weights=EXCLUDED.agg_weights;

INSERT INTO benchmark_definitions
    (id, name, description, field_ids, test_ids)
    VALUES ('2da3781a-25a9-4c89-8b43-9269844f3fef', 'AI acceptability, trust and trustworthiness', 'AI acceptability, trust and trustworthiness', array['980dfc15-2183-4429-9478-356fb70063e9']::uuid[], array['ba7fabe3-6f42-4cc5-875e-b8fb45aa17f3', 'de7f38de-1f0b-450e-9951-b925523a563d', '125cc932-43c2-40db-8fb3-e523557b98df', 'fd01a013-c5aa-4ab2-9c01-ec608013c929', '923fddc9-99f6-4195-a857-00d1493886e6', '7a1e72fb-942c-4f54-bc72-adba7d941a0e', '3c249970-1e83-4faa-bcf4-9fdb63ed904d', '66d9dc9e-a163-4afc-b293-9ece9d45f3cf', '4795ec75-5e16-432a-9a5c-580d649471e2', '57134a8f-d2bb-4a49-975c-4f6e1e07eb09', 'b10a5c41-7f19-414c-9ffe-3b73774ce1d9', '626c4984-069a-4c6d-8bc6-b63d8eb91d4f', '51780641-4f2a-4095-b230-fdddc4bf31af', '9db74767-f2c3-4f04-aa83-cab1746ab83f', 'd3313fc9-8865-49c8-b3a2-ed0742bbcb8d']::uuid[])
    ON CONFLICT(id) DO UPDATE SET name=EXCLUDED.name, description=EXCLUDED.description, field_ids=EXCLUDED.field_ids, test_ids=EXCLUDED.test_ids;

INSERT INTO field_definitions
        (id, key, description, agg_func, agg_weights)
        VALUES ('980dfc15-2183-4429-9478-356fb70063e9', 'primary', 'Benchmark score (MEAN of test scores)', 'MEAN', NULL)
        ON CONFLICT(id) DO UPDATE SET key=EXCLUDED.key, description=EXCLUDED.description, agg_func=EXCLUDED.agg_func, agg_weights=EXCLUDED.agg_weights;

INSERT INTO test_definitions
    (id, name, description, field_ids, scenario_ids, loop, queue)
    VALUES ('ba7fabe3-6f42-4cc5-875e-b8fb45aa17f3', 'KPI-AS-002: Acceptance (Railway)', 'Acceptance of the system by a human user.', array['4d609eed-8062-4e81-893f-b4b653f8e4b7']::uuid[], array['0d85a097-9170-42aa-99ea-d56b833c27cf']::uuid[], 'OFFLINE', 'Railway')
    ON CONFLICT(id) DO UPDATE SET name=EXCLUDED.name, description=EXCLUDED.description, field_ids=EXCLUDED.field_ids, scenario_ids=EXCLUDED.scenario_ids, loop=EXCLUDED.loop, queue=EXCLUDED.queue;

INSERT INTO field_definitions
        (id, key, description, agg_func, agg_weights)
        VALUES ('4d609eed-8062-4e81-893f-b4b653f8e4b7', 'primary', 'Benchmark score (MEAN of test scores)', 'MEAN', NULL)
        ON CONFLICT(id) DO UPDATE SET key=EXCLUDED.key, description=EXCLUDED.description, agg_func=EXCLUDED.agg_func, agg_weights=EXCLUDED.agg_weights;

INSERT INTO scenario_definitions
    (id, name, description, field_ids)
    VALUES ('0d85a097-9170-42aa-99ea-d56b833c27cf', 'primary', 'This KPI contributes to evaluating AI acceptability, trust and trustworthiness of the AI-based assistant, as part of Task 4.3 evaluation objectives, and O2 main project objective. ', array['cf296c89-a971-4c74-aa19-5b08a6e4c86e']::uuid[])
    ON CONFLICT(id) DO UPDATE SET name=EXCLUDED.name, description=EXCLUDED.description, field_ids=EXCLUDED.field_ids;

INSERT INTO field_definitions
        (id, key, description, agg_func, agg_weights)
        VALUES ('cf296c89-a971-4c74-aa19-5b08a6e4c86e', 'primary', 'Scenario score (raw values)', NULL, NULL)
        ON CONFLICT(id) DO UPDATE SET key=EXCLUDED.key, description=EXCLUDED.description, agg_func=EXCLUDED.agg_func, agg_weights=EXCLUDED.agg_weights;

INSERT INTO test_definitions
    (id, name, description, field_ids, scenario_ids, loop, queue)
    VALUES ('de7f38de-1f0b-450e-9951-b925523a563d', 'KPI-AS-002: Acceptance (Power Grid)', 'Acceptance of the system by a human user.', array['99f95a40-b75c-47f1-8fd5-b3dc9c5a42c0']::uuid[], array['b4b167ff-56be-43a1-9a80-121eaaf8108f']::uuid[], 'OFFLINE', 'PowerGrid')
    ON CONFLICT(id) DO UPDATE SET name=EXCLUDED.name, description=EXCLUDED.description, field_ids=EXCLUDED.field_ids, scenario_ids=EXCLUDED.scenario_ids, loop=EXCLUDED.loop, queue=EXCLUDED.queue;

INSERT INTO field_definitions
        (id, key, description, agg_func, agg_weights)
        VALUES ('99f95a40-b75c-47f1-8fd5-b3dc9c5a42c0', 'primary', 'Benchmark score (MEAN of test scores)', 'MEAN', NULL)
        ON CONFLICT(id) DO UPDATE SET key=EXCLUDED.key, description=EXCLUDED.description, agg_func=EXCLUDED.agg_func, agg_weights=EXCLUDED.agg_weights;

INSERT INTO scenario_definitions
    (id, name, description, field_ids)
    VALUES ('b4b167ff-56be-43a1-9a80-121eaaf8108f', 'primary', 'This KPI contributes to evaluating AI acceptability, trust and trustworthiness of the AI-based assistant, as part of Task 4.3 evaluation objectives, and O2 main project objective. ', array['76cb53ca-86f8-4895-908f-d6d4bf256b09']::uuid[])
    ON CONFLICT(id) DO UPDATE SET name=EXCLUDED.name, description=EXCLUDED.description, field_ids=EXCLUDED.field_ids;

INSERT INTO field_definitions
        (id, key, description, agg_func, agg_weights)
        VALUES ('76cb53ca-86f8-4895-908f-d6d4bf256b09', 'primary', 'Scenario score (raw values)', NULL, NULL)
        ON CONFLICT(id) DO UPDATE SET key=EXCLUDED.key, description=EXCLUDED.description, agg_func=EXCLUDED.agg_func, agg_weights=EXCLUDED.agg_weights;

INSERT INTO test_definitions
    (id, name, description, field_ids, scenario_ids, loop, queue)
    VALUES ('125cc932-43c2-40db-8fb3-e523557b98df', 'KPI-AS-002: Acceptance (ATM)', 'Acceptance of the system by a human user.', array['874377c7-380e-4e3c-8d6e-23e85ff26cf0']::uuid[], array['91da4c1c-3011-4f70-809f-8204cd3824ba']::uuid[], 'OFFLINE', 'ATM')
    ON CONFLICT(id) DO UPDATE SET name=EXCLUDED.name, description=EXCLUDED.description, field_ids=EXCLUDED.field_ids, scenario_ids=EXCLUDED.scenario_ids, loop=EXCLUDED.loop, queue=EXCLUDED.queue;

INSERT INTO field_definitions
        (id, key, description, agg_func, agg_weights)
        VALUES ('874377c7-380e-4e3c-8d6e-23e85ff26cf0', 'primary', 'Benchmark score (MEAN of test scores)', 'MEAN', NULL)
        ON CONFLICT(id) DO UPDATE SET key=EXCLUDED.key, description=EXCLUDED.description, agg_func=EXCLUDED.agg_func, agg_weights=EXCLUDED.agg_weights;

INSERT INTO scenario_definitions
    (id, name, description, field_ids)
    VALUES ('91da4c1c-3011-4f70-809f-8204cd3824ba', 'primary', 'This KPI contributes to evaluating AI acceptability, trust and trustworthiness of the AI-based assistant, as part of Task 4.3 evaluation objectives, and O2 main project objective. ', array['f4f4211a-e0fd-4b61-b05f-e47363c1786f']::uuid[])
    ON CONFLICT(id) DO UPDATE SET name=EXCLUDED.name, description=EXCLUDED.description, field_ids=EXCLUDED.field_ids;

INSERT INTO field_definitions
        (id, key, description, agg_func, agg_weights)
        VALUES ('f4f4211a-e0fd-4b61-b05f-e47363c1786f', 'primary', 'Scenario score (raw values)', NULL, NULL)
        ON CONFLICT(id) DO UPDATE SET key=EXCLUDED.key, description=EXCLUDED.description, agg_func=EXCLUDED.agg_func, agg_weights=EXCLUDED.agg_weights;

INSERT INTO test_definitions
    (id, name, description, field_ids, scenario_ids, loop, queue)
    VALUES ('fd01a013-c5aa-4ab2-9c01-ec608013c929', 'KPI-AS-005: Agreement score (Railway)', 'This KPI represents human operators’ self-reported agreement with individual AI-generated solutions/decisions on a scale of 0–100. ', array['a85e44b6-48d9-419f-8c4d-255eb2382531']::uuid[], array['9db20a76-763a-4597-9586-cb217981e191']::uuid[], 'OFFLINE', 'Railway')
    ON CONFLICT(id) DO UPDATE SET name=EXCLUDED.name, description=EXCLUDED.description, field_ids=EXCLUDED.field_ids, scenario_ids=EXCLUDED.scenario_ids, loop=EXCLUDED.loop, queue=EXCLUDED.queue;

INSERT INTO field_definitions
        (id, key, description, agg_func, agg_weights)
        VALUES ('a85e44b6-48d9-419f-8c4d-255eb2382531', 'primary', 'Benchmark score (MEAN of test scores)', 'MEAN', NULL)
        ON CONFLICT(id) DO UPDATE SET key=EXCLUDED.key, description=EXCLUDED.description, agg_func=EXCLUDED.agg_func, agg_weights=EXCLUDED.agg_weights;

INSERT INTO scenario_definitions
    (id, name, description, field_ids)
    VALUES ('9db20a76-763a-4597-9586-cb217981e191', 'primary', 'This KPI contributes to evaluating AI acceptability, trust and trustworthiness of the AI-based assistant, as part of Task 4.3 evaluation objectives, and O2 main project objective. <br/>It is also relevant to protocols and concepts defined in D1.1 such as “Agreement score”.  ', array['62598708-cd90-4dc5-8ef9-4b8243a96e27']::uuid[])
    ON CONFLICT(id) DO UPDATE SET name=EXCLUDED.name, description=EXCLUDED.description, field_ids=EXCLUDED.field_ids;

INSERT INTO field_definitions
        (id, key, description, agg_func, agg_weights)
        VALUES ('62598708-cd90-4dc5-8ef9-4b8243a96e27', 'primary', 'Scenario score (raw values)', NULL, NULL)
        ON CONFLICT(id) DO UPDATE SET key=EXCLUDED.key, description=EXCLUDED.description, agg_func=EXCLUDED.agg_func, agg_weights=EXCLUDED.agg_weights;

INSERT INTO test_definitions
    (id, name, description, field_ids, scenario_ids, loop, queue)
    VALUES ('923fddc9-99f6-4195-a857-00d1493886e6', 'KPI-AS-005: Agreement score (Power Grid)', 'This KPI represents human operators’ self-reported agreement with individual AI-generated solutions/decisions on a scale of 0–100. ', array['ec13012a-5c41-4c30-964d-fca2599efc94']::uuid[], array['631244e4-ade3-4cbb-afd6-a19e56c001d6']::uuid[], 'OFFLINE', 'PowerGrid')
    ON CONFLICT(id) DO UPDATE SET name=EXCLUDED.name, description=EXCLUDED.description, field_ids=EXCLUDED.field_ids, scenario_ids=EXCLUDED.scenario_ids, loop=EXCLUDED.loop, queue=EXCLUDED.queue;

INSERT INTO field_definitions
        (id, key, description, agg_func, agg_weights)
        VALUES ('ec13012a-5c41-4c30-964d-fca2599efc94', 'primary', 'Benchmark score (MEAN of test scores)', 'MEAN', NULL)
        ON CONFLICT(id) DO UPDATE SET key=EXCLUDED.key, description=EXCLUDED.description, agg_func=EXCLUDED.agg_func, agg_weights=EXCLUDED.agg_weights;

INSERT INTO scenario_definitions
    (id, name, description, field_ids)
    VALUES ('631244e4-ade3-4cbb-afd6-a19e56c001d6', 'primary', 'This KPI contributes to evaluating AI acceptability, trust and trustworthiness of the AI-based assistant, as part of Task 4.3 evaluation objectives, and O2 main project objective. <br/>It is also relevant to protocols and concepts defined in D1.1 such as “Agreement score”.  ', array['6ca312a1-5b41-43ce-b81f-899bb3ebb0d1']::uuid[])
    ON CONFLICT(id) DO UPDATE SET name=EXCLUDED.name, description=EXCLUDED.description, field_ids=EXCLUDED.field_ids;

INSERT INTO field_definitions
        (id, key, description, agg_func, agg_weights)
        VALUES ('6ca312a1-5b41-43ce-b81f-899bb3ebb0d1', 'primary', 'Scenario score (raw values)', NULL, NULL)
        ON CONFLICT(id) DO UPDATE SET key=EXCLUDED.key, description=EXCLUDED.description, agg_func=EXCLUDED.agg_func, agg_weights=EXCLUDED.agg_weights;

INSERT INTO test_definitions
    (id, name, description, field_ids, scenario_ids, loop, queue)
    VALUES ('7a1e72fb-942c-4f54-bc72-adba7d941a0e', 'KPI-AS-005: Agreement score (ATM)', 'This KPI represents human operators’ self-reported agreement with individual AI-generated solutions/decisions on a scale of 0–100. ', array['f0bc882a-f98f-46aa-8914-1d8859efddc8']::uuid[], array['5ec8e7f8-a26d-4263-95ea-6c7a0832f61d']::uuid[], 'OFFLINE', 'ATM')
    ON CONFLICT(id) DO UPDATE SET name=EXCLUDED.name, description=EXCLUDED.description, field_ids=EXCLUDED.field_ids, scenario_ids=EXCLUDED.scenario_ids, loop=EXCLUDED.loop, queue=EXCLUDED.queue;

INSERT INTO field_definitions
        (id, key, description, agg_func, agg_weights)
        VALUES ('f0bc882a-f98f-46aa-8914-1d8859efddc8', 'primary', 'Benchmark score (MEAN of test scores)', 'MEAN', NULL)
        ON CONFLICT(id) DO UPDATE SET key=EXCLUDED.key, description=EXCLUDED.description, agg_func=EXCLUDED.agg_func, agg_weights=EXCLUDED.agg_weights;

INSERT INTO scenario_definitions
    (id, name, description, field_ids)
    VALUES ('5ec8e7f8-a26d-4263-95ea-6c7a0832f61d', 'primary', 'This KPI contributes to evaluating AI acceptability, trust and trustworthiness of the AI-based assistant, as part of Task 4.3 evaluation objectives, and O2 main project objective. <br/>It is also relevant to protocols and concepts defined in D1.1 such as “Agreement score”.  ', array['701cf78b-17fe-4c09-9714-448b22a61766']::uuid[])
    ON CONFLICT(id) DO UPDATE SET name=EXCLUDED.name, description=EXCLUDED.description, field_ids=EXCLUDED.field_ids;

INSERT INTO field_definitions
        (id, key, description, agg_func, agg_weights)
        VALUES ('701cf78b-17fe-4c09-9714-448b22a61766', 'primary', 'Scenario score (raw values)', NULL, NULL)
        ON CONFLICT(id) DO UPDATE SET key=EXCLUDED.key, description=EXCLUDED.description, agg_func=EXCLUDED.agg_func, agg_weights=EXCLUDED.agg_weights;

INSERT INTO test_definitions
    (id, name, description, field_ids, scenario_ids, loop, queue)
    VALUES ('3c249970-1e83-4faa-bcf4-9fdb63ed904d', 'KPI-CS-013: Comprehensibility (Railway)', 'This KPI represents human operators’ self-reported ability to understand and thus make use of the AI-generated solution/decision, measured with a questionnaire. ', array['4cf8e1a6-17b5-4de3-a075-29c70641c358']::uuid[], array['0ee42e0f-a284-4979-86e8-4e50c9bfcef7']::uuid[], 'OFFLINE', 'Railway')
    ON CONFLICT(id) DO UPDATE SET name=EXCLUDED.name, description=EXCLUDED.description, field_ids=EXCLUDED.field_ids, scenario_ids=EXCLUDED.scenario_ids, loop=EXCLUDED.loop, queue=EXCLUDED.queue;

INSERT INTO field_definitions
        (id, key, description, agg_func, agg_weights)
        VALUES ('4cf8e1a6-17b5-4de3-a075-29c70641c358', 'primary', 'Benchmark score (MEAN of test scores)', 'MEAN', NULL)
        ON CONFLICT(id) DO UPDATE SET key=EXCLUDED.key, description=EXCLUDED.description, agg_func=EXCLUDED.agg_func, agg_weights=EXCLUDED.agg_weights;

INSERT INTO scenario_definitions
    (id, name, description, field_ids)
    VALUES ('0ee42e0f-a284-4979-86e8-4e50c9bfcef7', 'primary', 'This KPI contributes to evaluating AI acceptability, trust and trustworthiness of the AI-based assistant, as part of Task 4.3 evaluation objectives, and O2 main project objective.  <br/>It is also relevant to protocols and concepts defined in D1.1 such as “Comprehensibility”.  ', array['eee8e62b-a5c3-44a4-bfb0-9a24f63291b2']::uuid[])
    ON CONFLICT(id) DO UPDATE SET name=EXCLUDED.name, description=EXCLUDED.description, field_ids=EXCLUDED.field_ids;

INSERT INTO field_definitions
        (id, key, description, agg_func, agg_weights)
        VALUES ('eee8e62b-a5c3-44a4-bfb0-9a24f63291b2', 'primary', 'Scenario score (raw values)', NULL, NULL)
        ON CONFLICT(id) DO UPDATE SET key=EXCLUDED.key, description=EXCLUDED.description, agg_func=EXCLUDED.agg_func, agg_weights=EXCLUDED.agg_weights;

INSERT INTO test_definitions
    (id, name, description, field_ids, scenario_ids, loop, queue)
    VALUES ('66d9dc9e-a163-4afc-b293-9ece9d45f3cf', 'KPI-CS-013: Comprehensibility (Power Grid)', 'This KPI represents human operators’ self-reported ability to understand and thus make use of the AI-generated solution/decision, measured with a questionnaire. ', array['f257dde6-66c6-415e-b1de-96f965c5f39a']::uuid[], array['9d6c321f-25c4-4b31-91e6-0208c1da3455']::uuid[], 'OFFLINE', 'PowerGrid')
    ON CONFLICT(id) DO UPDATE SET name=EXCLUDED.name, description=EXCLUDED.description, field_ids=EXCLUDED.field_ids, scenario_ids=EXCLUDED.scenario_ids, loop=EXCLUDED.loop, queue=EXCLUDED.queue;

INSERT INTO field_definitions
        (id, key, description, agg_func, agg_weights)
        VALUES ('f257dde6-66c6-415e-b1de-96f965c5f39a', 'primary', 'Benchmark score (MEAN of test scores)', 'MEAN', NULL)
        ON CONFLICT(id) DO UPDATE SET key=EXCLUDED.key, description=EXCLUDED.description, agg_func=EXCLUDED.agg_func, agg_weights=EXCLUDED.agg_weights;

INSERT INTO scenario_definitions
    (id, name, description, field_ids)
    VALUES ('9d6c321f-25c4-4b31-91e6-0208c1da3455', 'primary', 'This KPI contributes to evaluating AI acceptability, trust and trustworthiness of the AI-based assistant, as part of Task 4.3 evaluation objectives, and O2 main project objective.  <br/>It is also relevant to protocols and concepts defined in D1.1 such as “Comprehensibility”.  ', array['cb479f8f-f4fc-4c71-b2cc-0b4212fe95ce']::uuid[])
    ON CONFLICT(id) DO UPDATE SET name=EXCLUDED.name, description=EXCLUDED.description, field_ids=EXCLUDED.field_ids;

INSERT INTO field_definitions
        (id, key, description, agg_func, agg_weights)
        VALUES ('cb479f8f-f4fc-4c71-b2cc-0b4212fe95ce', 'primary', 'Scenario score (raw values)', NULL, NULL)
        ON CONFLICT(id) DO UPDATE SET key=EXCLUDED.key, description=EXCLUDED.description, agg_func=EXCLUDED.agg_func, agg_weights=EXCLUDED.agg_weights;

INSERT INTO test_definitions
    (id, name, description, field_ids, scenario_ids, loop, queue)
    VALUES ('4795ec75-5e16-432a-9a5c-580d649471e2', 'KPI-CS-013: Comprehensibility (ATM)', 'This KPI represents human operators’ self-reported ability to understand and thus make use of the AI-generated solution/decision, measured with a questionnaire. ', array['0fec6160-d278-4194-bb37-2d580d4b8056']::uuid[], array['2057f6f2-015b-4370-a4db-40bb8cd9b244']::uuid[], 'OFFLINE', 'ATM')
    ON CONFLICT(id) DO UPDATE SET name=EXCLUDED.name, description=EXCLUDED.description, field_ids=EXCLUDED.field_ids, scenario_ids=EXCLUDED.scenario_ids, loop=EXCLUDED.loop, queue=EXCLUDED.queue;

INSERT INTO field_definitions
        (id, key, description, agg_func, agg_weights)
        VALUES ('0fec6160-d278-4194-bb37-2d580d4b8056', 'primary', 'Benchmark score (MEAN of test scores)', 'MEAN', NULL)
        ON CONFLICT(id) DO UPDATE SET key=EXCLUDED.key, description=EXCLUDED.description, agg_func=EXCLUDED.agg_func, agg_weights=EXCLUDED.agg_weights;

INSERT INTO scenario_definitions
    (id, name, description, field_ids)
    VALUES ('2057f6f2-015b-4370-a4db-40bb8cd9b244', 'primary', 'This KPI contributes to evaluating AI acceptability, trust and trustworthiness of the AI-based assistant, as part of Task 4.3 evaluation objectives, and O2 main project objective.  <br/>It is also relevant to protocols and concepts defined in D1.1 such as “Comprehensibility”.  ', array['b4007321-4acc-4868-b4eb-27284244b574']::uuid[])
    ON CONFLICT(id) DO UPDATE SET name=EXCLUDED.name, description=EXCLUDED.description, field_ids=EXCLUDED.field_ids;

INSERT INTO field_definitions
        (id, key, description, agg_func, agg_weights)
        VALUES ('b4007321-4acc-4868-b4eb-27284244b574', 'primary', 'Scenario score (raw values)', NULL, NULL)
        ON CONFLICT(id) DO UPDATE SET key=EXCLUDED.key, description=EXCLUDED.description, agg_func=EXCLUDED.agg_func, agg_weights=EXCLUDED.agg_weights;

INSERT INTO test_definitions
    (id, name, description, field_ids, scenario_ids, loop, queue)
    VALUES ('57134a8f-d2bb-4a49-975c-4f6e1e07eb09', 'KPI-TS-038: Trust in AI solutions score (Railway)', 'This KPI represents human operators’ self-reported trust (attitude) for individual AI-generated solutions measured with a questionnaire. ', array['0050454e-c693-41bc-8c18-67e70716cfc9']::uuid[], array['7b07ae08-9153-42cd-b1e9-6c03f3c1df31']::uuid[], 'OFFLINE', 'Railway')
    ON CONFLICT(id) DO UPDATE SET name=EXCLUDED.name, description=EXCLUDED.description, field_ids=EXCLUDED.field_ids, scenario_ids=EXCLUDED.scenario_ids, loop=EXCLUDED.loop, queue=EXCLUDED.queue;

INSERT INTO field_definitions
        (id, key, description, agg_func, agg_weights)
        VALUES ('0050454e-c693-41bc-8c18-67e70716cfc9', 'primary', 'Benchmark score (MEAN of test scores)', 'MEAN', NULL)
        ON CONFLICT(id) DO UPDATE SET key=EXCLUDED.key, description=EXCLUDED.description, agg_func=EXCLUDED.agg_func, agg_weights=EXCLUDED.agg_weights;

INSERT INTO scenario_definitions
    (id, name, description, field_ids)
    VALUES ('7b07ae08-9153-42cd-b1e9-6c03f3c1df31', 'primary', 'This KPI contributes to evaluating AI acceptability, trust and trustworthiness of the AI-based assistant, as part of Task 4.3 evaluation objectives, and O2 main project objective. <br/>It is also relevant to protocols and concepts defined in D1.1 such as “Trust in AI solutions score”.  ', array['9530cdc4-ed66-48f0-9aa9-f7fcd2d3fb38']::uuid[])
    ON CONFLICT(id) DO UPDATE SET name=EXCLUDED.name, description=EXCLUDED.description, field_ids=EXCLUDED.field_ids;

INSERT INTO field_definitions
        (id, key, description, agg_func, agg_weights)
        VALUES ('9530cdc4-ed66-48f0-9aa9-f7fcd2d3fb38', 'primary', 'Scenario score (raw values)', NULL, NULL)
        ON CONFLICT(id) DO UPDATE SET key=EXCLUDED.key, description=EXCLUDED.description, agg_func=EXCLUDED.agg_func, agg_weights=EXCLUDED.agg_weights;

INSERT INTO test_definitions
    (id, name, description, field_ids, scenario_ids, loop, queue)
    VALUES ('b10a5c41-7f19-414c-9ffe-3b73774ce1d9', 'KPI-TS-038: Trust in AI solutions score (Power Grid)', 'This KPI represents human operators’ self-reported trust (attitude) for individual AI-generated solutions measured with a questionnaire. ', array['f3e3b428-5df4-4e6b-af10-430adacdae1b']::uuid[], array['5314d4ab-35d4-4bc3-ade8-3b17bd39dd82']::uuid[], 'OFFLINE', 'PowerGrid')
    ON CONFLICT(id) DO UPDATE SET name=EXCLUDED.name, description=EXCLUDED.description, field_ids=EXCLUDED.field_ids, scenario_ids=EXCLUDED.scenario_ids, loop=EXCLUDED.loop, queue=EXCLUDED.queue;

INSERT INTO field_definitions
        (id, key, description, agg_func, agg_weights)
        VALUES ('f3e3b428-5df4-4e6b-af10-430adacdae1b', 'primary', 'Benchmark score (MEAN of test scores)', 'MEAN', NULL)
        ON CONFLICT(id) DO UPDATE SET key=EXCLUDED.key, description=EXCLUDED.description, agg_func=EXCLUDED.agg_func, agg_weights=EXCLUDED.agg_weights;

INSERT INTO scenario_definitions
    (id, name, description, field_ids)
    VALUES ('5314d4ab-35d4-4bc3-ade8-3b17bd39dd82', 'primary', 'This KPI contributes to evaluating AI acceptability, trust and trustworthiness of the AI-based assistant, as part of Task 4.3 evaluation objectives, and O2 main project objective. <br/>It is also relevant to protocols and concepts defined in D1.1 such as “Trust in AI solutions score”.  ', array['750dcb3a-3bd4-4dc6-b5eb-767e6a2b1484']::uuid[])
    ON CONFLICT(id) DO UPDATE SET name=EXCLUDED.name, description=EXCLUDED.description, field_ids=EXCLUDED.field_ids;

INSERT INTO field_definitions
        (id, key, description, agg_func, agg_weights)
        VALUES ('750dcb3a-3bd4-4dc6-b5eb-767e6a2b1484', 'primary', 'Scenario score (raw values)', NULL, NULL)
        ON CONFLICT(id) DO UPDATE SET key=EXCLUDED.key, description=EXCLUDED.description, agg_func=EXCLUDED.agg_func, agg_weights=EXCLUDED.agg_weights;

INSERT INTO test_definitions
    (id, name, description, field_ids, scenario_ids, loop, queue)
    VALUES ('626c4984-069a-4c6d-8bc6-b63d8eb91d4f', 'KPI-TS-038: Trust in AI solutions score (ATM)', 'This KPI represents human operators’ self-reported trust (attitude) for individual AI-generated solutions measured with a questionnaire. ', array['e98ae93a-b79a-4238-8702-48bbb87a8609']::uuid[], array['e5063e27-d81b-499b-8827-b2a8ab0ff8d8']::uuid[], 'OFFLINE', 'ATM')
    ON CONFLICT(id) DO UPDATE SET name=EXCLUDED.name, description=EXCLUDED.description, field_ids=EXCLUDED.field_ids, scenario_ids=EXCLUDED.scenario_ids, loop=EXCLUDED.loop, queue=EXCLUDED.queue;

INSERT INTO field_definitions
        (id, key, description, agg_func, agg_weights)
        VALUES ('e98ae93a-b79a-4238-8702-48bbb87a8609', 'primary', 'Benchmark score (MEAN of test scores)', 'MEAN', NULL)
        ON CONFLICT(id) DO UPDATE SET key=EXCLUDED.key, description=EXCLUDED.description, agg_func=EXCLUDED.agg_func, agg_weights=EXCLUDED.agg_weights;

INSERT INTO scenario_definitions
    (id, name, description, field_ids)
    VALUES ('e5063e27-d81b-499b-8827-b2a8ab0ff8d8', 'primary', 'This KPI contributes to evaluating AI acceptability, trust and trustworthiness of the AI-based assistant, as part of Task 4.3 evaluation objectives, and O2 main project objective. <br/>It is also relevant to protocols and concepts defined in D1.1 such as “Trust in AI solutions score”.  ', array['f3645865-2353-4077-943d-30516d275ea1']::uuid[])
    ON CONFLICT(id) DO UPDATE SET name=EXCLUDED.name, description=EXCLUDED.description, field_ids=EXCLUDED.field_ids;

INSERT INTO field_definitions
        (id, key, description, agg_func, agg_weights)
        VALUES ('f3645865-2353-4077-943d-30516d275ea1', 'primary', 'Scenario score (raw values)', NULL, NULL)
        ON CONFLICT(id) DO UPDATE SET key=EXCLUDED.key, description=EXCLUDED.description, agg_func=EXCLUDED.agg_func, agg_weights=EXCLUDED.agg_weights;

INSERT INTO test_definitions
    (id, name, description, field_ids, scenario_ids, loop, queue)
    VALUES ('51780641-4f2a-4095-b230-fdddc4bf31af', 'KPI-TS-039: Trust towards the AI tool (Railway)', '(Dis)trust is defined here as a sentiment resulting from knowledge, beliefs, emotions, and other elements derived from lived or transmitted experience, which generates positive or negative expectations concerning the reactions of a system and the interaction with it (whether it is a question of another human being, an organization or a technology)” (Cahour & Forzy, 2009, p. 1261). ', array['015f5bd7-ab19-432b-ac75-486d433782ca']::uuid[], array['0e9f4bb5-6e39-4ccb-b5ae-81b9a1f91607']::uuid[], 'OFFLINE', 'Railway')
    ON CONFLICT(id) DO UPDATE SET name=EXCLUDED.name, description=EXCLUDED.description, field_ids=EXCLUDED.field_ids, scenario_ids=EXCLUDED.scenario_ids, loop=EXCLUDED.loop, queue=EXCLUDED.queue;

INSERT INTO field_definitions
        (id, key, description, agg_func, agg_weights)
        VALUES ('015f5bd7-ab19-432b-ac75-486d433782ca', 'primary', 'Benchmark score (MEAN of test scores)', 'MEAN', NULL)
        ON CONFLICT(id) DO UPDATE SET key=EXCLUDED.key, description=EXCLUDED.description, agg_func=EXCLUDED.agg_func, agg_weights=EXCLUDED.agg_weights;

INSERT INTO scenario_definitions
    (id, name, description, field_ids)
    VALUES ('0e9f4bb5-6e39-4ccb-b5ae-81b9a1f91607', 'primary', 'This KPI contributes to evaluating AI acceptability, trust and trustworthiness of the AI-based assistant, as part of Task 4.3 evaluation objectives, and O2 main project objective. ', array['5ca84b5c-b2f6-43c7-a6b8-efe47660e40f']::uuid[])
    ON CONFLICT(id) DO UPDATE SET name=EXCLUDED.name, description=EXCLUDED.description, field_ids=EXCLUDED.field_ids;

INSERT INTO field_definitions
        (id, key, description, agg_func, agg_weights)
        VALUES ('5ca84b5c-b2f6-43c7-a6b8-efe47660e40f', 'primary', 'Scenario score (raw values)', NULL, NULL)
        ON CONFLICT(id) DO UPDATE SET key=EXCLUDED.key, description=EXCLUDED.description, agg_func=EXCLUDED.agg_func, agg_weights=EXCLUDED.agg_weights;

INSERT INTO test_definitions
    (id, name, description, field_ids, scenario_ids, loop, queue)
    VALUES ('9db74767-f2c3-4f04-aa83-cab1746ab83f', 'KPI-TS-039: Trust towards the AI tool (Power Grid)', '(Dis)trust is defined here as a sentiment resulting from knowledge, beliefs, emotions, and other elements derived from lived or transmitted experience, which generates positive or negative expectations concerning the reactions of a system and the interaction with it (whether it is a question of another human being, an organization or a technology)” (Cahour & Forzy, 2009, p. 1261). ', array['e7d279ae-33b4-4664-ad89-a479462fd579']::uuid[], array['2d5f2c8a-5cfd-4f32-9174-7ae81a82f0be']::uuid[], 'OFFLINE', 'PowerGrid')
    ON CONFLICT(id) DO UPDATE SET name=EXCLUDED.name, description=EXCLUDED.description, field_ids=EXCLUDED.field_ids, scenario_ids=EXCLUDED.scenario_ids, loop=EXCLUDED.loop, queue=EXCLUDED.queue;

INSERT INTO field_definitions
        (id, key, description, agg_func, agg_weights)
        VALUES ('e7d279ae-33b4-4664-ad89-a479462fd579', 'primary', 'Benchmark score (MEAN of test scores)', 'MEAN', NULL)
        ON CONFLICT(id) DO UPDATE SET key=EXCLUDED.key, description=EXCLUDED.description, agg_func=EXCLUDED.agg_func, agg_weights=EXCLUDED.agg_weights;

INSERT INTO scenario_definitions
    (id, name, description, field_ids)
    VALUES ('2d5f2c8a-5cfd-4f32-9174-7ae81a82f0be', 'primary', 'This KPI contributes to evaluating AI acceptability, trust and trustworthiness of the AI-based assistant, as part of Task 4.3 evaluation objectives, and O2 main project objective. ', array['1b354632-d9ac-4048-81f2-5432921286e2']::uuid[])
    ON CONFLICT(id) DO UPDATE SET name=EXCLUDED.name, description=EXCLUDED.description, field_ids=EXCLUDED.field_ids;

INSERT INTO field_definitions
        (id, key, description, agg_func, agg_weights)
        VALUES ('1b354632-d9ac-4048-81f2-5432921286e2', 'primary', 'Scenario score (raw values)', NULL, NULL)
        ON CONFLICT(id) DO UPDATE SET key=EXCLUDED.key, description=EXCLUDED.description, agg_func=EXCLUDED.agg_func, agg_weights=EXCLUDED.agg_weights;

INSERT INTO test_definitions
    (id, name, description, field_ids, scenario_ids, loop, queue)
    VALUES ('d3313fc9-8865-49c8-b3a2-ed0742bbcb8d', 'KPI-TS-039: Trust towards the AI tool (ATM)', '(Dis)trust is defined here as a sentiment resulting from knowledge, beliefs, emotions, and other elements derived from lived or transmitted experience, which generates positive or negative expectations concerning the reactions of a system and the interaction with it (whether it is a question of another human being, an organization or a technology)” (Cahour & Forzy, 2009, p. 1261). ', array['493273d8-0a2b-4b96-b807-667bf651bb2c']::uuid[], array['a5785b63-ccee-4108-ad34-32f861beeadf']::uuid[], 'OFFLINE', 'ATM')
    ON CONFLICT(id) DO UPDATE SET name=EXCLUDED.name, description=EXCLUDED.description, field_ids=EXCLUDED.field_ids, scenario_ids=EXCLUDED.scenario_ids, loop=EXCLUDED.loop, queue=EXCLUDED.queue;

INSERT INTO field_definitions
        (id, key, description, agg_func, agg_weights)
        VALUES ('493273d8-0a2b-4b96-b807-667bf651bb2c', 'primary', 'Benchmark score (MEAN of test scores)', 'MEAN', NULL)
        ON CONFLICT(id) DO UPDATE SET key=EXCLUDED.key, description=EXCLUDED.description, agg_func=EXCLUDED.agg_func, agg_weights=EXCLUDED.agg_weights;

INSERT INTO scenario_definitions
    (id, name, description, field_ids)
    VALUES ('a5785b63-ccee-4108-ad34-32f861beeadf', 'primary', 'This KPI contributes to evaluating AI acceptability, trust and trustworthiness of the AI-based assistant, as part of Task 4.3 evaluation objectives, and O2 main project objective. ', array['3790034c-09e2-44be-b809-2c5212e6a7d9']::uuid[])
    ON CONFLICT(id) DO UPDATE SET name=EXCLUDED.name, description=EXCLUDED.description, field_ids=EXCLUDED.field_ids;

INSERT INTO field_definitions
        (id, key, description, agg_func, agg_weights)
        VALUES ('3790034c-09e2-44be-b809-2c5212e6a7d9', 'primary', 'Scenario score (raw values)', NULL, NULL)
        ON CONFLICT(id) DO UPDATE SET key=EXCLUDED.key, description=EXCLUDED.description, agg_func=EXCLUDED.agg_func, agg_weights=EXCLUDED.agg_weights;

INSERT INTO benchmark_definitions
    (id, name, description, field_ids, test_ids)
    VALUES ('8d5c876e-22c2-49e7-bdd5-4c1840d309f0', 'Social-technical decision quality', 'Social-technical decision quality', array['8611b3d7-1682-4f35-b8e1-22142c638cce']::uuid[], array['22b1dc11-7d3f-4219-adc9-b1eba58562a7', 'bc503fa3-b1ea-4de5-8760-21bd3ede927f', '8936e99a-3667-404d-97b7-eab2791c0cdc', '24eecb84-e881-459c-8116-a224b0253b70', 'f22c4c5d-1957-4262-b763-12736dd692f9', 'a5cebe71-030b-4d3c-be27-d8c01a862952', '74c88d9b-f61b-4162-aefc-75a9d538b8a6', '44758e37-c1d5-4932-8c17-54147903f214', 'c489fc51-158f-4224-baba-8d18c34c19d3']::uuid[])
    ON CONFLICT(id) DO UPDATE SET name=EXCLUDED.name, description=EXCLUDED.description, field_ids=EXCLUDED.field_ids, test_ids=EXCLUDED.test_ids;

INSERT INTO field_definitions
        (id, key, description, agg_func, agg_weights)
        VALUES ('8611b3d7-1682-4f35-b8e1-22142c638cce', 'primary', 'Benchmark score (MEAN of test scores)', 'MEAN', NULL)
        ON CONFLICT(id) DO UPDATE SET key=EXCLUDED.key, description=EXCLUDED.description, agg_func=EXCLUDED.agg_func, agg_weights=EXCLUDED.agg_weights;

INSERT INTO test_definitions
    (id, name, description, field_ids, scenario_ids, loop, queue)
    VALUES ('22b1dc11-7d3f-4219-adc9-b1eba58562a7', 'KPI-HS-003: Human intervention frequency (Railway)', 'The Human Intervention Frequency KPI measures the proportion of instances in which a human operator intervenes in an automated decision-making process. While this KPI was initially developed for railway traffic control scenarios, it has been generalized to assess the reliability and autonomy of any AI-assisted system. It reflects the trust placed in the AI by quantifying how often human corrections are required during routine operations. ', array['bf5d4da4-cf9b-4fca-8b17-11cfd0dacabc']::uuid[], array['6c383eec-31cd-4f3c-9296-cc5bb0d7f4c9']::uuid[], 'INTERACTIVE', 'Railway')
    ON CONFLICT(id) DO UPDATE SET name=EXCLUDED.name, description=EXCLUDED.description, field_ids=EXCLUDED.field_ids, scenario_ids=EXCLUDED.scenario_ids, loop=EXCLUDED.loop, queue=EXCLUDED.queue;

INSERT INTO field_definitions
        (id, key, description, agg_func, agg_weights)
        VALUES ('bf5d4da4-cf9b-4fca-8b17-11cfd0dacabc', 'primary', 'Benchmark score (MEAN of test scores)', 'MEAN', NULL)
        ON CONFLICT(id) DO UPDATE SET key=EXCLUDED.key, description=EXCLUDED.description, agg_func=EXCLUDED.agg_func, agg_weights=EXCLUDED.agg_weights;

INSERT INTO scenario_definitions
    (id, name, description, field_ids)
    VALUES ('6c383eec-31cd-4f3c-9296-cc5bb0d7f4c9', 'primary', 'This KPI contributes to evaluating Social-technical decision quality of the AI-based assistant, as part of Task 4.3 evaluation objectives, and O3 main project objective: <br/>- To evaluate the effectiveness of the AI system in operating autonomously. <br/>- To provide a performance benchmark for minimizing human interventions across various domains. <br/>- To identify areas where the AI may require additional refinement or support. ', array['1362ead2-16e9-401e-8da6-251236369d72']::uuid[])
    ON CONFLICT(id) DO UPDATE SET name=EXCLUDED.name, description=EXCLUDED.description, field_ids=EXCLUDED.field_ids;

INSERT INTO field_definitions
        (id, key, description, agg_func, agg_weights)
        VALUES ('1362ead2-16e9-401e-8da6-251236369d72', 'primary', 'Scenario score (raw values)', NULL, NULL)
        ON CONFLICT(id) DO UPDATE SET key=EXCLUDED.key, description=EXCLUDED.description, agg_func=EXCLUDED.agg_func, agg_weights=EXCLUDED.agg_weights;

INSERT INTO test_definitions
    (id, name, description, field_ids, scenario_ids, loop, queue)
    VALUES ('bc503fa3-b1ea-4de5-8760-21bd3ede927f', 'KPI-HS-003: Human intervention frequency (Power Grid)', 'The Human Intervention Frequency KPI measures the proportion of instances in which a human operator intervenes in an automated decision-making process. While this KPI was initially developed for railway traffic control scenarios, it has been generalized to assess the reliability and autonomy of any AI-assisted system. It reflects the trust placed in the AI by quantifying how often human corrections are required during routine operations. ', array['6e50a7c4-d178-4561-800b-71d0771365c8']::uuid[], array['81cb1769-35b5-4b97-aff0-b0d070dd6e50']::uuid[], 'INTERACTIVE', 'PowerGrid')
    ON CONFLICT(id) DO UPDATE SET name=EXCLUDED.name, description=EXCLUDED.description, field_ids=EXCLUDED.field_ids, scenario_ids=EXCLUDED.scenario_ids, loop=EXCLUDED.loop, queue=EXCLUDED.queue;

INSERT INTO field_definitions
        (id, key, description, agg_func, agg_weights)
        VALUES ('6e50a7c4-d178-4561-800b-71d0771365c8', 'primary', 'Benchmark score (MEAN of test scores)', 'MEAN', NULL)
        ON CONFLICT(id) DO UPDATE SET key=EXCLUDED.key, description=EXCLUDED.description, agg_func=EXCLUDED.agg_func, agg_weights=EXCLUDED.agg_weights;

INSERT INTO scenario_definitions
    (id, name, description, field_ids)
    VALUES ('81cb1769-35b5-4b97-aff0-b0d070dd6e50', 'primary', 'This KPI contributes to evaluating Social-technical decision quality of the AI-based assistant, as part of Task 4.3 evaluation objectives, and O3 main project objective: <br/>- To evaluate the effectiveness of the AI system in operating autonomously. <br/>- To provide a performance benchmark for minimizing human interventions across various domains. <br/>- To identify areas where the AI may require additional refinement or support. ', array['7d55949e-0c19-4623-875f-95c09bfd55f6']::uuid[])
    ON CONFLICT(id) DO UPDATE SET name=EXCLUDED.name, description=EXCLUDED.description, field_ids=EXCLUDED.field_ids;

INSERT INTO field_definitions
        (id, key, description, agg_func, agg_weights)
        VALUES ('7d55949e-0c19-4623-875f-95c09bfd55f6', 'primary', 'Scenario score (raw values)', NULL, NULL)
        ON CONFLICT(id) DO UPDATE SET key=EXCLUDED.key, description=EXCLUDED.description, agg_func=EXCLUDED.agg_func, agg_weights=EXCLUDED.agg_weights;

INSERT INTO test_definitions
    (id, name, description, field_ids, scenario_ids, loop, queue)
    VALUES ('8936e99a-3667-404d-97b7-eab2791c0cdc', 'KPI-HS-003: Human intervention frequency (ATM)', 'The Human Intervention Frequency KPI measures the proportion of instances in which a human operator intervenes in an automated decision-making process. While this KPI was initially developed for railway traffic control scenarios, it has been generalized to assess the reliability and autonomy of any AI-assisted system. It reflects the trust placed in the AI by quantifying how often human corrections are required during routine operations. ', array['f0523454-2778-4047-bce0-dcb3e732b0d2']::uuid[], array['0db9f3ea-ac49-4914-b491-ecf3f1f35263']::uuid[], 'INTERACTIVE', 'ATM')
    ON CONFLICT(id) DO UPDATE SET name=EXCLUDED.name, description=EXCLUDED.description, field_ids=EXCLUDED.field_ids, scenario_ids=EXCLUDED.scenario_ids, loop=EXCLUDED.loop, queue=EXCLUDED.queue;

INSERT INTO field_definitions
        (id, key, description, agg_func, agg_weights)
        VALUES ('f0523454-2778-4047-bce0-dcb3e732b0d2', 'primary', 'Benchmark score (MEAN of test scores)', 'MEAN', NULL)
        ON CONFLICT(id) DO UPDATE SET key=EXCLUDED.key, description=EXCLUDED.description, agg_func=EXCLUDED.agg_func, agg_weights=EXCLUDED.agg_weights;

INSERT INTO scenario_definitions
    (id, name, description, field_ids)
    VALUES ('0db9f3ea-ac49-4914-b491-ecf3f1f35263', 'primary', 'This KPI contributes to evaluating Social-technical decision quality of the AI-based assistant, as part of Task 4.3 evaluation objectives, and O3 main project objective: <br/>- To evaluate the effectiveness of the AI system in operating autonomously. <br/>- To provide a performance benchmark for minimizing human interventions across various domains. <br/>- To identify areas where the AI may require additional refinement or support. ', array['13238d69-4caa-4292-a5f1-94d25262dbe8']::uuid[])
    ON CONFLICT(id) DO UPDATE SET name=EXCLUDED.name, description=EXCLUDED.description, field_ids=EXCLUDED.field_ids;

INSERT INTO field_definitions
        (id, key, description, agg_func, agg_weights)
        VALUES ('13238d69-4caa-4292-a5f1-94d25262dbe8', 'primary', 'Scenario score (raw values)', NULL, NULL)
        ON CONFLICT(id) DO UPDATE SET key=EXCLUDED.key, description=EXCLUDED.description, agg_func=EXCLUDED.agg_func, agg_weights=EXCLUDED.agg_weights;

INSERT INTO test_definitions
    (id, name, description, field_ids, scenario_ids, loop, queue)
    VALUES ('24eecb84-e881-459c-8116-a224b0253b70', 'KPI-SS-030: Significance of human revisions (Railway)', 'This KPI represents human operators’ subjective assessment of necessary revisions for the AI-generated solutions by the human operator, self-reported by the operator with Likert-scale questions. ', array['843d2e64-3243-4138-90fc-1a4686f27178']::uuid[], array['eee4453e-477f-4057-ad7b-c1c2233ed108']::uuid[], 'INTERACTIVE', 'Railway')
    ON CONFLICT(id) DO UPDATE SET name=EXCLUDED.name, description=EXCLUDED.description, field_ids=EXCLUDED.field_ids, scenario_ids=EXCLUDED.scenario_ids, loop=EXCLUDED.loop, queue=EXCLUDED.queue;

INSERT INTO field_definitions
        (id, key, description, agg_func, agg_weights)
        VALUES ('843d2e64-3243-4138-90fc-1a4686f27178', 'primary', 'Benchmark score (MEAN of test scores)', 'MEAN', NULL)
        ON CONFLICT(id) DO UPDATE SET key=EXCLUDED.key, description=EXCLUDED.description, agg_func=EXCLUDED.agg_func, agg_weights=EXCLUDED.agg_weights;

INSERT INTO scenario_definitions
    (id, name, description, field_ids)
    VALUES ('eee4453e-477f-4057-ad7b-c1c2233ed108', 'primary', 'This KPI contributes to evaluating Social-technical decision quality of the AI-based assistant, as part of Task 4.3 evaluation objectives, and O3 main project objective. <br/>It is also relevant to protocols and concepts defined in D1.1 such as “Significance of human revisions”.  ', array['e9aad7a4-3ef8-4ae5-8f4b-dc972a8378ff']::uuid[])
    ON CONFLICT(id) DO UPDATE SET name=EXCLUDED.name, description=EXCLUDED.description, field_ids=EXCLUDED.field_ids;

INSERT INTO field_definitions
        (id, key, description, agg_func, agg_weights)
        VALUES ('e9aad7a4-3ef8-4ae5-8f4b-dc972a8378ff', 'primary', 'Scenario score (raw values)', NULL, NULL)
        ON CONFLICT(id) DO UPDATE SET key=EXCLUDED.key, description=EXCLUDED.description, agg_func=EXCLUDED.agg_func, agg_weights=EXCLUDED.agg_weights;

INSERT INTO test_definitions
    (id, name, description, field_ids, scenario_ids, loop, queue)
    VALUES ('f22c4c5d-1957-4262-b763-12736dd692f9', 'KPI-SS-030: Significance of human revisions (Power Grid)', 'This KPI represents human operators’ subjective assessment of necessary revisions for the AI-generated solutions by the human operator, self-reported by the operator with Likert-scale questions. ', array['61d44975-5de9-41f4-99b0-dd6e29c48f60']::uuid[], array['79f0ed9e-094f-4637-921c-814707f3b02e']::uuid[], 'INTERACTIVE', 'PowerGrid')
    ON CONFLICT(id) DO UPDATE SET name=EXCLUDED.name, description=EXCLUDED.description, field_ids=EXCLUDED.field_ids, scenario_ids=EXCLUDED.scenario_ids, loop=EXCLUDED.loop, queue=EXCLUDED.queue;

INSERT INTO field_definitions
        (id, key, description, agg_func, agg_weights)
        VALUES ('61d44975-5de9-41f4-99b0-dd6e29c48f60', 'primary', 'Benchmark score (MEAN of test scores)', 'MEAN', NULL)
        ON CONFLICT(id) DO UPDATE SET key=EXCLUDED.key, description=EXCLUDED.description, agg_func=EXCLUDED.agg_func, agg_weights=EXCLUDED.agg_weights;

INSERT INTO scenario_definitions
    (id, name, description, field_ids)
    VALUES ('79f0ed9e-094f-4637-921c-814707f3b02e', 'primary', 'This KPI contributes to evaluating Social-technical decision quality of the AI-based assistant, as part of Task 4.3 evaluation objectives, and O3 main project objective. <br/>It is also relevant to protocols and concepts defined in D1.1 such as “Significance of human revisions”.  ', array['d1a5803e-298a-413f-bb66-c5677b0cd265']::uuid[])
    ON CONFLICT(id) DO UPDATE SET name=EXCLUDED.name, description=EXCLUDED.description, field_ids=EXCLUDED.field_ids;

INSERT INTO field_definitions
        (id, key, description, agg_func, agg_weights)
        VALUES ('d1a5803e-298a-413f-bb66-c5677b0cd265', 'primary', 'Scenario score (raw values)', NULL, NULL)
        ON CONFLICT(id) DO UPDATE SET key=EXCLUDED.key, description=EXCLUDED.description, agg_func=EXCLUDED.agg_func, agg_weights=EXCLUDED.agg_weights;

INSERT INTO test_definitions
    (id, name, description, field_ids, scenario_ids, loop, queue)
    VALUES ('a5cebe71-030b-4d3c-be27-d8c01a862952', 'KPI-SS-030: Significance of human revisions (ATM)', 'This KPI represents human operators’ subjective assessment of necessary revisions for the AI-generated solutions by the human operator, self-reported by the operator with Likert-scale questions. ', array['97e45e9c-41f6-44ec-9c49-748fbdbdbc5e']::uuid[], array['a365a4df-98d6-4c7b-83bb-63b5ccb68581']::uuid[], 'INTERACTIVE', 'ATM')
    ON CONFLICT(id) DO UPDATE SET name=EXCLUDED.name, description=EXCLUDED.description, field_ids=EXCLUDED.field_ids, scenario_ids=EXCLUDED.scenario_ids, loop=EXCLUDED.loop, queue=EXCLUDED.queue;

INSERT INTO field_definitions
        (id, key, description, agg_func, agg_weights)
        VALUES ('97e45e9c-41f6-44ec-9c49-748fbdbdbc5e', 'primary', 'Benchmark score (MEAN of test scores)', 'MEAN', NULL)
        ON CONFLICT(id) DO UPDATE SET key=EXCLUDED.key, description=EXCLUDED.description, agg_func=EXCLUDED.agg_func, agg_weights=EXCLUDED.agg_weights;

INSERT INTO scenario_definitions
    (id, name, description, field_ids)
    VALUES ('a365a4df-98d6-4c7b-83bb-63b5ccb68581', 'primary', 'This KPI contributes to evaluating Social-technical decision quality of the AI-based assistant, as part of Task 4.3 evaluation objectives, and O3 main project objective. <br/>It is also relevant to protocols and concepts defined in D1.1 such as “Significance of human revisions”.  ', array['8cf309e8-a558-4cad-b24a-0791ae089f3d']::uuid[])
    ON CONFLICT(id) DO UPDATE SET name=EXCLUDED.name, description=EXCLUDED.description, field_ids=EXCLUDED.field_ids;

INSERT INTO field_definitions
        (id, key, description, agg_func, agg_weights)
        VALUES ('8cf309e8-a558-4cad-b24a-0791ae089f3d', 'primary', 'Scenario score (raw values)', NULL, NULL)
        ON CONFLICT(id) DO UPDATE SET key=EXCLUDED.key, description=EXCLUDED.description, agg_func=EXCLUDED.agg_func, agg_weights=EXCLUDED.agg_weights;

INSERT INTO test_definitions
    (id, name, description, field_ids, scenario_ids, loop, queue)
    VALUES ('74c88d9b-f61b-4162-aefc-75a9d538b8a6', 'KPI-PS-089: Perceived decision novelty (Railway)', 'This KPI represents human operators’ self-reported subjective assessment of nontriviality for the AI-generated solutions measured with a questionnaire. ', array['afffdcbf-3044-4571-a234-ab4d55da46fd']::uuid[], array['b228ee9c-de35-4efd-b59a-7c4bb95ca127']::uuid[], 'OFFLINE', 'Railway')
    ON CONFLICT(id) DO UPDATE SET name=EXCLUDED.name, description=EXCLUDED.description, field_ids=EXCLUDED.field_ids, scenario_ids=EXCLUDED.scenario_ids, loop=EXCLUDED.loop, queue=EXCLUDED.queue;

INSERT INTO field_definitions
        (id, key, description, agg_func, agg_weights)
        VALUES ('afffdcbf-3044-4571-a234-ab4d55da46fd', 'primary', 'Benchmark score (MEAN of test scores)', 'MEAN', NULL)
        ON CONFLICT(id) DO UPDATE SET key=EXCLUDED.key, description=EXCLUDED.description, agg_func=EXCLUDED.agg_func, agg_weights=EXCLUDED.agg_weights;

INSERT INTO scenario_definitions
    (id, name, description, field_ids)
    VALUES ('b228ee9c-de35-4efd-b59a-7c4bb95ca127', 'primary', 'This KPI contributes to evaluating Social-technical decision quality of the AI-based assistant, as part of Task 4.3 evaluation objectives, and O3 main project objective. ', array['156722a0-0cc7-42dc-9ea0-885afb2f1e69']::uuid[])
    ON CONFLICT(id) DO UPDATE SET name=EXCLUDED.name, description=EXCLUDED.description, field_ids=EXCLUDED.field_ids;

INSERT INTO field_definitions
        (id, key, description, agg_func, agg_weights)
        VALUES ('156722a0-0cc7-42dc-9ea0-885afb2f1e69', 'primary', 'Scenario score (raw values)', NULL, NULL)
        ON CONFLICT(id) DO UPDATE SET key=EXCLUDED.key, description=EXCLUDED.description, agg_func=EXCLUDED.agg_func, agg_weights=EXCLUDED.agg_weights;

INSERT INTO test_definitions
    (id, name, description, field_ids, scenario_ids, loop, queue)
    VALUES ('44758e37-c1d5-4932-8c17-54147903f214', 'KPI-PS-089: Perceived decision novelty (Power Grid)', 'This KPI represents human operators’ self-reported subjective assessment of nontriviality for the AI-generated solutions measured with a questionnaire. ', array['2dd6e12b-eb87-47c5-9954-18a7ffeedc61']::uuid[], array['b3b52505-caa6-4438-90b8-6ac84e9880d9']::uuid[], 'OFFLINE', 'PowerGrid')
    ON CONFLICT(id) DO UPDATE SET name=EXCLUDED.name, description=EXCLUDED.description, field_ids=EXCLUDED.field_ids, scenario_ids=EXCLUDED.scenario_ids, loop=EXCLUDED.loop, queue=EXCLUDED.queue;

INSERT INTO field_definitions
        (id, key, description, agg_func, agg_weights)
        VALUES ('2dd6e12b-eb87-47c5-9954-18a7ffeedc61', 'primary', 'Benchmark score (MEAN of test scores)', 'MEAN', NULL)
        ON CONFLICT(id) DO UPDATE SET key=EXCLUDED.key, description=EXCLUDED.description, agg_func=EXCLUDED.agg_func, agg_weights=EXCLUDED.agg_weights;

INSERT INTO scenario_definitions
    (id, name, description, field_ids)
    VALUES ('b3b52505-caa6-4438-90b8-6ac84e9880d9', 'primary', 'This KPI contributes to evaluating Social-technical decision quality of the AI-based assistant, as part of Task 4.3 evaluation objectives, and O3 main project objective. ', array['aec036cc-7b38-42e1-8660-7edff5e86e54']::uuid[])
    ON CONFLICT(id) DO UPDATE SET name=EXCLUDED.name, description=EXCLUDED.description, field_ids=EXCLUDED.field_ids;

INSERT INTO field_definitions
        (id, key, description, agg_func, agg_weights)
        VALUES ('aec036cc-7b38-42e1-8660-7edff5e86e54', 'primary', 'Scenario score (raw values)', NULL, NULL)
        ON CONFLICT(id) DO UPDATE SET key=EXCLUDED.key, description=EXCLUDED.description, agg_func=EXCLUDED.agg_func, agg_weights=EXCLUDED.agg_weights;

INSERT INTO test_definitions
    (id, name, description, field_ids, scenario_ids, loop, queue)
    VALUES ('c489fc51-158f-4224-baba-8d18c34c19d3', 'KPI-PS-089: Perceived decision novelty (ATM)', 'This KPI represents human operators’ self-reported subjective assessment of nontriviality for the AI-generated solutions measured with a questionnaire. ', array['45f78644-ff33-4685-82d8-71a3101ddad8']::uuid[], array['ab1d9b2b-b91f-440f-ad16-54ccabb25230']::uuid[], 'OFFLINE', 'ATM')
    ON CONFLICT(id) DO UPDATE SET name=EXCLUDED.name, description=EXCLUDED.description, field_ids=EXCLUDED.field_ids, scenario_ids=EXCLUDED.scenario_ids, loop=EXCLUDED.loop, queue=EXCLUDED.queue;

INSERT INTO field_definitions
        (id, key, description, agg_func, agg_weights)
        VALUES ('45f78644-ff33-4685-82d8-71a3101ddad8', 'primary', 'Benchmark score (MEAN of test scores)', 'MEAN', NULL)
        ON CONFLICT(id) DO UPDATE SET key=EXCLUDED.key, description=EXCLUDED.description, agg_func=EXCLUDED.agg_func, agg_weights=EXCLUDED.agg_weights;

INSERT INTO scenario_definitions
    (id, name, description, field_ids)
    VALUES ('ab1d9b2b-b91f-440f-ad16-54ccabb25230', 'primary', 'This KPI contributes to evaluating Social-technical decision quality of the AI-based assistant, as part of Task 4.3 evaluation objectives, and O3 main project objective. ', array['19ee2451-b3e5-43bb-89c7-8137fd988bfb']::uuid[])
    ON CONFLICT(id) DO UPDATE SET name=EXCLUDED.name, description=EXCLUDED.description, field_ids=EXCLUDED.field_ids;

INSERT INTO field_definitions
        (id, key, description, agg_func, agg_weights)
        VALUES ('19ee2451-b3e5-43bb-89c7-8137fd988bfb', 'primary', 'Scenario score (raw values)', NULL, NULL)
        ON CONFLICT(id) DO UPDATE SET key=EXCLUDED.key, description=EXCLUDED.description, agg_func=EXCLUDED.agg_func, agg_weights=EXCLUDED.agg_weights;

INSERT INTO benchmark_definitions
    (id, name, description, field_ids, test_ids)
    VALUES ('65547935-f436-49fa-8d20-f320c6bd46dc', 'AI-human learning curves', 'AI-human learning curves', array['932197b6-5a11-4208-84ce-1d0f43d4884e']::uuid[], array['a38618ca-6e9f-437d-a177-270f721ad1c6', 'b2213a56-7841-41e1-afbc-6ef541d1597c', '452bff66-df55-47fd-9ad8-725f327bedf3', 'c258c64f-1905-4d7f-93f0-d696c133978e', '67f77d51-0893-4cbd-b349-b73bd2f73db2', '15de95cc-0ad4-4b78-9984-9bdeac8503dd']::uuid[])
    ON CONFLICT(id) DO UPDATE SET name=EXCLUDED.name, description=EXCLUDED.description, field_ids=EXCLUDED.field_ids, test_ids=EXCLUDED.test_ids;

INSERT INTO field_definitions
        (id, key, description, agg_func, agg_weights)
        VALUES ('932197b6-5a11-4208-84ce-1d0f43d4884e', 'primary', 'Benchmark score (MEAN of test scores)', 'MEAN', NULL)
        ON CONFLICT(id) DO UPDATE SET key=EXCLUDED.key, description=EXCLUDED.description, agg_func=EXCLUDED.agg_func, agg_weights=EXCLUDED.agg_weights;

INSERT INTO test_definitions
    (id, name, description, field_ids, scenario_ids, loop, queue)
    VALUES ('a38618ca-6e9f-437d-a177-270f721ad1c6', 'KPI-AS-006: AI co-learning capability (Railway)', 'This KPI represents human operators’ self-reported assessment of the AI ability to adapt to the operators’ preferences measured with a questionnaire. ', array['916d5bf1-5bee-4955-93e4-127a41c42a97']::uuid[], array['9fdd3565-45d6-4d83-9cda-478c56e94f26']::uuid[], 'OFFLINE', 'Railway')
    ON CONFLICT(id) DO UPDATE SET name=EXCLUDED.name, description=EXCLUDED.description, field_ids=EXCLUDED.field_ids, scenario_ids=EXCLUDED.scenario_ids, loop=EXCLUDED.loop, queue=EXCLUDED.queue;

INSERT INTO field_definitions
        (id, key, description, agg_func, agg_weights)
        VALUES ('916d5bf1-5bee-4955-93e4-127a41c42a97', 'primary', 'Benchmark score (MEAN of test scores)', 'MEAN', NULL)
        ON CONFLICT(id) DO UPDATE SET key=EXCLUDED.key, description=EXCLUDED.description, agg_func=EXCLUDED.agg_func, agg_weights=EXCLUDED.agg_weights;

INSERT INTO scenario_definitions
    (id, name, description, field_ids)
    VALUES ('9fdd3565-45d6-4d83-9cda-478c56e94f26', 'primary', 'This KPI contributes to evaluating AI-human learning curves of the AI-based assistant, as part of Task 4.3 evaluation objectives, and O3 main project objective. <br/>It is also relevant to protocols and concepts defined in D1.1 such as “AI co-learning capability”.  ', array['18246932-0833-40e9-880c-432cec4d0cec']::uuid[])
    ON CONFLICT(id) DO UPDATE SET name=EXCLUDED.name, description=EXCLUDED.description, field_ids=EXCLUDED.field_ids;

INSERT INTO field_definitions
        (id, key, description, agg_func, agg_weights)
        VALUES ('18246932-0833-40e9-880c-432cec4d0cec', 'primary', 'Scenario score (raw values)', NULL, NULL)
        ON CONFLICT(id) DO UPDATE SET key=EXCLUDED.key, description=EXCLUDED.description, agg_func=EXCLUDED.agg_func, agg_weights=EXCLUDED.agg_weights;

INSERT INTO test_definitions
    (id, name, description, field_ids, scenario_ids, loop, queue)
    VALUES ('b2213a56-7841-41e1-afbc-6ef541d1597c', 'KPI-AS-006: AI co-learning capability (Power Grid)', 'This KPI represents human operators’ self-reported assessment of the AI ability to adapt to the operators’ preferences measured with a questionnaire. ', array['4c6e01fe-e8db-40ab-ac1c-88d8068bfccd']::uuid[], array['91b63e8f-7cf1-461c-98ea-0269b26bb3b4']::uuid[], 'OFFLINE', 'PowerGrid')
    ON CONFLICT(id) DO UPDATE SET name=EXCLUDED.name, description=EXCLUDED.description, field_ids=EXCLUDED.field_ids, scenario_ids=EXCLUDED.scenario_ids, loop=EXCLUDED.loop, queue=EXCLUDED.queue;

INSERT INTO field_definitions
        (id, key, description, agg_func, agg_weights)
        VALUES ('4c6e01fe-e8db-40ab-ac1c-88d8068bfccd', 'primary', 'Benchmark score (MEAN of test scores)', 'MEAN', NULL)
        ON CONFLICT(id) DO UPDATE SET key=EXCLUDED.key, description=EXCLUDED.description, agg_func=EXCLUDED.agg_func, agg_weights=EXCLUDED.agg_weights;

INSERT INTO scenario_definitions
    (id, name, description, field_ids)
    VALUES ('91b63e8f-7cf1-461c-98ea-0269b26bb3b4', 'primary', 'This KPI contributes to evaluating AI-human learning curves of the AI-based assistant, as part of Task 4.3 evaluation objectives, and O3 main project objective. <br/>It is also relevant to protocols and concepts defined in D1.1 such as “AI co-learning capability”.  ', array['cba93682-5514-46e1-8399-60bdee8f3bd9']::uuid[])
    ON CONFLICT(id) DO UPDATE SET name=EXCLUDED.name, description=EXCLUDED.description, field_ids=EXCLUDED.field_ids;

INSERT INTO field_definitions
        (id, key, description, agg_func, agg_weights)
        VALUES ('cba93682-5514-46e1-8399-60bdee8f3bd9', 'primary', 'Scenario score (raw values)', NULL, NULL)
        ON CONFLICT(id) DO UPDATE SET key=EXCLUDED.key, description=EXCLUDED.description, agg_func=EXCLUDED.agg_func, agg_weights=EXCLUDED.agg_weights;

INSERT INTO test_definitions
    (id, name, description, field_ids, scenario_ids, loop, queue)
    VALUES ('452bff66-df55-47fd-9ad8-725f327bedf3', 'KPI-AS-006: AI co-learning capability (ATM)', 'This KPI represents human operators’ self-reported assessment of the AI ability to adapt to the operators’ preferences measured with a questionnaire. ', array['f60128ec-90ef-4307-8966-363b75722e12']::uuid[], array['af91490d-d1cf-4644-aaec-887e320e4a36']::uuid[], 'OFFLINE', 'ATM')
    ON CONFLICT(id) DO UPDATE SET name=EXCLUDED.name, description=EXCLUDED.description, field_ids=EXCLUDED.field_ids, scenario_ids=EXCLUDED.scenario_ids, loop=EXCLUDED.loop, queue=EXCLUDED.queue;

INSERT INTO field_definitions
        (id, key, description, agg_func, agg_weights)
        VALUES ('f60128ec-90ef-4307-8966-363b75722e12', 'primary', 'Benchmark score (MEAN of test scores)', 'MEAN', NULL)
        ON CONFLICT(id) DO UPDATE SET key=EXCLUDED.key, description=EXCLUDED.description, agg_func=EXCLUDED.agg_func, agg_weights=EXCLUDED.agg_weights;

INSERT INTO scenario_definitions
    (id, name, description, field_ids)
    VALUES ('af91490d-d1cf-4644-aaec-887e320e4a36', 'primary', 'This KPI contributes to evaluating AI-human learning curves of the AI-based assistant, as part of Task 4.3 evaluation objectives, and O3 main project objective. <br/>It is also relevant to protocols and concepts defined in D1.1 such as “AI co-learning capability”.  ', array['a0b93bbc-dedd-4e40-b772-c45b9d93488f']::uuid[])
    ON CONFLICT(id) DO UPDATE SET name=EXCLUDED.name, description=EXCLUDED.description, field_ids=EXCLUDED.field_ids;

INSERT INTO field_definitions
        (id, key, description, agg_func, agg_weights)
        VALUES ('a0b93bbc-dedd-4e40-b772-c45b9d93488f', 'primary', 'Scenario score (raw values)', NULL, NULL)
        ON CONFLICT(id) DO UPDATE SET key=EXCLUDED.key, description=EXCLUDED.description, agg_func=EXCLUDED.agg_func, agg_weights=EXCLUDED.agg_weights;

INSERT INTO test_definitions
    (id, name, description, field_ids, scenario_ids, loop, queue)
    VALUES ('c258c64f-1905-4d7f-93f0-d696c133978e', 'KPI-HS-021: Human learning (Railway)', 'Human learning is a complex process that leads to lasting changes in humans, influencing their perceptions of the world and their interactions with it across physical, psychological, and social dimensions. It is fundamentally shaped by the ongoing, interactive relationship between the learner''s characteristics and the learning content, all situated within the specific environmental context of time and place and the continuity over time. ', array['d30fc4e1-2f3e-4b80-945a-f5150a91c3e4']::uuid[], array['b4c9184c-c0d1-4a0c-bab1-9210bf8cb548']::uuid[], 'OFFLINE', 'Railway')
    ON CONFLICT(id) DO UPDATE SET name=EXCLUDED.name, description=EXCLUDED.description, field_ids=EXCLUDED.field_ids, scenario_ids=EXCLUDED.scenario_ids, loop=EXCLUDED.loop, queue=EXCLUDED.queue;

INSERT INTO field_definitions
        (id, key, description, agg_func, agg_weights)
        VALUES ('d30fc4e1-2f3e-4b80-945a-f5150a91c3e4', 'primary', 'Benchmark score (MEAN of test scores)', 'MEAN', NULL)
        ON CONFLICT(id) DO UPDATE SET key=EXCLUDED.key, description=EXCLUDED.description, agg_func=EXCLUDED.agg_func, agg_weights=EXCLUDED.agg_weights;

INSERT INTO scenario_definitions
    (id, name, description, field_ids)
    VALUES ('b4c9184c-c0d1-4a0c-bab1-9210bf8cb548', 'primary', 'This KPI contributes to evaluating AI-human learning curves of the AI-based assistant, as part of Task 4.3 evaluation objectives, and O3 main project objective. ', array['03584304-31ae-432a-8d0c-db51bff866e1']::uuid[])
    ON CONFLICT(id) DO UPDATE SET name=EXCLUDED.name, description=EXCLUDED.description, field_ids=EXCLUDED.field_ids;

INSERT INTO field_definitions
        (id, key, description, agg_func, agg_weights)
        VALUES ('03584304-31ae-432a-8d0c-db51bff866e1', 'primary', 'Scenario score (raw values)', NULL, NULL)
        ON CONFLICT(id) DO UPDATE SET key=EXCLUDED.key, description=EXCLUDED.description, agg_func=EXCLUDED.agg_func, agg_weights=EXCLUDED.agg_weights;

INSERT INTO test_definitions
    (id, name, description, field_ids, scenario_ids, loop, queue)
    VALUES ('67f77d51-0893-4cbd-b349-b73bd2f73db2', 'KPI-HS-021: Human learning (Power Grid)', 'Human learning is a complex process that leads to lasting changes in humans, influencing their perceptions of the world and their interactions with it across physical, psychological, and social dimensions. It is fundamentally shaped by the ongoing, interactive relationship between the learner''s characteristics and the learning content, all situated within the specific environmental context of time and place and the continuity over time. ', array['d2ac280c-7583-480a-99c5-7e51b9894f19']::uuid[], array['6958bf4c-39ff-484f-b609-25500e9e314a']::uuid[], 'OFFLINE', 'PowerGrid')
    ON CONFLICT(id) DO UPDATE SET name=EXCLUDED.name, description=EXCLUDED.description, field_ids=EXCLUDED.field_ids, scenario_ids=EXCLUDED.scenario_ids, loop=EXCLUDED.loop, queue=EXCLUDED.queue;

INSERT INTO field_definitions
        (id, key, description, agg_func, agg_weights)
        VALUES ('d2ac280c-7583-480a-99c5-7e51b9894f19', 'primary', 'Benchmark score (MEAN of test scores)', 'MEAN', NULL)
        ON CONFLICT(id) DO UPDATE SET key=EXCLUDED.key, description=EXCLUDED.description, agg_func=EXCLUDED.agg_func, agg_weights=EXCLUDED.agg_weights;

INSERT INTO scenario_definitions
    (id, name, description, field_ids)
    VALUES ('6958bf4c-39ff-484f-b609-25500e9e314a', 'primary', 'This KPI contributes to evaluating AI-human learning curves of the AI-based assistant, as part of Task 4.3 evaluation objectives, and O3 main project objective. ', array['332feb56-b546-4a7f-bc08-1320c024ec59']::uuid[])
    ON CONFLICT(id) DO UPDATE SET name=EXCLUDED.name, description=EXCLUDED.description, field_ids=EXCLUDED.field_ids;

INSERT INTO field_definitions
        (id, key, description, agg_func, agg_weights)
        VALUES ('332feb56-b546-4a7f-bc08-1320c024ec59', 'primary', 'Scenario score (raw values)', NULL, NULL)
        ON CONFLICT(id) DO UPDATE SET key=EXCLUDED.key, description=EXCLUDED.description, agg_func=EXCLUDED.agg_func, agg_weights=EXCLUDED.agg_weights;

INSERT INTO test_definitions
    (id, name, description, field_ids, scenario_ids, loop, queue)
    VALUES ('15de95cc-0ad4-4b78-9984-9bdeac8503dd', 'KPI-HS-021: Human learning (ATM)', 'Human learning is a complex process that leads to lasting changes in humans, influencing their perceptions of the world and their interactions with it across physical, psychological, and social dimensions. It is fundamentally shaped by the ongoing, interactive relationship between the learner''s characteristics and the learning content, all situated within the specific environmental context of time and place and the continuity over time. ', array['4ca83de7-7f8d-4eed-aee6-4751ed3a31bf']::uuid[], array['dd069d03-4ff6-4c9a-b3a6-bf1f1471e640']::uuid[], 'OFFLINE', 'ATM')
    ON CONFLICT(id) DO UPDATE SET name=EXCLUDED.name, description=EXCLUDED.description, field_ids=EXCLUDED.field_ids, scenario_ids=EXCLUDED.scenario_ids, loop=EXCLUDED.loop, queue=EXCLUDED.queue;

INSERT INTO field_definitions
        (id, key, description, agg_func, agg_weights)
        VALUES ('4ca83de7-7f8d-4eed-aee6-4751ed3a31bf', 'primary', 'Benchmark score (MEAN of test scores)', 'MEAN', NULL)
        ON CONFLICT(id) DO UPDATE SET key=EXCLUDED.key, description=EXCLUDED.description, agg_func=EXCLUDED.agg_func, agg_weights=EXCLUDED.agg_weights;

INSERT INTO scenario_definitions
    (id, name, description, field_ids)
    VALUES ('dd069d03-4ff6-4c9a-b3a6-bf1f1471e640', 'primary', 'This KPI contributes to evaluating AI-human learning curves of the AI-based assistant, as part of Task 4.3 evaluation objectives, and O3 main project objective. ', array['13cb3739-9b00-45d8-a511-91d8df7a33c3']::uuid[])
    ON CONFLICT(id) DO UPDATE SET name=EXCLUDED.name, description=EXCLUDED.description, field_ids=EXCLUDED.field_ids;

INSERT INTO field_definitions
        (id, key, description, agg_func, agg_weights)
        VALUES ('13cb3739-9b00-45d8-a511-91d8df7a33c3', 'primary', 'Scenario score (raw values)', NULL, NULL)
        ON CONFLICT(id) DO UPDATE SET key=EXCLUDED.key, description=EXCLUDED.description, agg_func=EXCLUDED.agg_func, agg_weights=EXCLUDED.agg_weights;

INSERT INTO benchmark_definitions
    (id, name, description, field_ids, test_ids)
    VALUES ('3b1bdca6-ed90-4938-bd63-fd657aa7dcd7', 'Effectiveness', 'Effectiveness', array['33c1f8a3-5764-44cc-988b-0f9a53b7f4a1']::uuid[], array['aba10b3f-0d5c-4f90-aec4-69460bbb098b', '6ff3c588-357c-41a6-a45a-2bd946b158c8', '5d1db79c-a7a4-4060-bb03-4629d64b1a43', '98ceb866-5479-47e6-a735-81292de8ca65', '9b6bc151-9f25-4d85-bee1-919753934521', '1e226684-a836-468d-9929-b95bbf2f88dc', 'a6cb2703-be7f-44da-a3d8-652fa8797627', '58ce79e0-5c14-4c51-8d09-89f856361259']::uuid[])
    ON CONFLICT(id) DO UPDATE SET name=EXCLUDED.name, description=EXCLUDED.description, field_ids=EXCLUDED.field_ids, test_ids=EXCLUDED.test_ids;

INSERT INTO field_definitions
        (id, key, description, agg_func, agg_weights)
        VALUES ('33c1f8a3-5764-44cc-988b-0f9a53b7f4a1', 'primary', 'Benchmark score (MEAN of test scores)', 'MEAN', NULL)
        ON CONFLICT(id) DO UPDATE SET key=EXCLUDED.key, description=EXCLUDED.description, agg_func=EXCLUDED.agg_func, agg_weights=EXCLUDED.agg_weights;

INSERT INTO test_definitions
    (id, name, description, field_ids, scenario_ids, loop, queue)
    VALUES ('aba10b3f-0d5c-4f90-aec4-69460bbb098b', 'KPI-AF-008: Assistant alert accuracy (Power Grid)', 'Assistant alert accuracy is based on the number of times the AI assistant agent is right about forecasted issues ahead of time. <br/>Even if forecasted issues concern all events that lead to a grid state out of acceptable limits (set by operation policy), use cases of the project focus on managing overloads only: this KPI therefore only focuses on alerts related to line overloads. <br/>The calculation of KPI relies on simulation of 2 parallel paths (starting from the moment the alert is raised): <br/>- Simulation of the “do nothing” path, to assess the truth values<br/>- Application of remedial actions to the “do nothing” path, to assess solved cases <br/>To calculate the KPI, all interventions by an agent or operator are fixed to a specific plan since every alert is related to a specific plan (e.g. remedial actions). <br/>Note: line contingencies for which alerts can be raised are the lines that can be attacked in the environment (env.alertable_line_ids in grid2Op), so this should be properly configured beforehand. ', array['fcabd61d-91bc-45dc-8bf8-7aeb9724cb67']::uuid[], array['729cc815-ac93-4209-9f62-b57b920c2d0a']::uuid[], 'CLOSED', 'PowerGrid')
    ON CONFLICT(id) DO UPDATE SET name=EXCLUDED.name, description=EXCLUDED.description, field_ids=EXCLUDED.field_ids, scenario_ids=EXCLUDED.scenario_ids, loop=EXCLUDED.loop, queue=EXCLUDED.queue;

INSERT INTO field_definitions
        (id, key, description, agg_func, agg_weights)
        VALUES ('fcabd61d-91bc-45dc-8bf8-7aeb9724cb67', 'primary', 'Benchmark score (MEAN of test scores)', 'MEAN', NULL)
        ON CONFLICT(id) DO UPDATE SET key=EXCLUDED.key, description=EXCLUDED.description, agg_func=EXCLUDED.agg_func, agg_weights=EXCLUDED.agg_weights;

INSERT INTO scenario_definitions
    (id, name, description, field_ids)
    VALUES ('729cc815-ac93-4209-9f62-b57b920c2d0a', 'primary', 'This KPI contributes to evaluating Effectiveness of the AI-based assistant, as part of Task 4.1 evaluation objectives, and O2 main project objective. ', array['7f5b985b-d3a9-4e96-bd01-53ca1b73b256']::uuid[])
    ON CONFLICT(id) DO UPDATE SET name=EXCLUDED.name, description=EXCLUDED.description, field_ids=EXCLUDED.field_ids;

INSERT INTO field_definitions
        (id, key, description, agg_func, agg_weights)
        VALUES ('7f5b985b-d3a9-4e96-bd01-53ca1b73b256', 'primary', 'Scenario score (raw values)', NULL, NULL)
        ON CONFLICT(id) DO UPDATE SET key=EXCLUDED.key, description=EXCLUDED.description, agg_func=EXCLUDED.agg_func, agg_weights=EXCLUDED.agg_weights;

INSERT INTO test_definitions
    (id, name, description, field_ids, scenario_ids, loop, queue)
    VALUES ('6ff3c588-357c-41a6-a45a-2bd946b158c8', 'KPI-DF-016: Delay reduction efficiency (Railway)', 'The Delay Reduction Efficiency KPI quantifies the effectiveness of the AI-driven re-scheduling system in reducing overall train delays. By comparing delays before and after AI intervention, this metric provides insight into the system''s capability to optimize train schedules and minimize disruptions. ', array['0c1be4b0-c30f-4e38-a698-3b141181ede6']::uuid[], array['ba7f9aac-5e96-4436-bae1-23629c4d153b']::uuid[], 'CLOSED', 'Railway')
    ON CONFLICT(id) DO UPDATE SET name=EXCLUDED.name, description=EXCLUDED.description, field_ids=EXCLUDED.field_ids, scenario_ids=EXCLUDED.scenario_ids, loop=EXCLUDED.loop, queue=EXCLUDED.queue;

INSERT INTO field_definitions
        (id, key, description, agg_func, agg_weights)
        VALUES ('0c1be4b0-c30f-4e38-a698-3b141181ede6', 'primary', 'Benchmark score (MEAN of test scores)', 'MEAN', NULL)
        ON CONFLICT(id) DO UPDATE SET key=EXCLUDED.key, description=EXCLUDED.description, agg_func=EXCLUDED.agg_func, agg_weights=EXCLUDED.agg_weights;

INSERT INTO scenario_definitions
    (id, name, description, field_ids)
    VALUES ('ba7f9aac-5e96-4436-bae1-23629c4d153b', 'primary', 'This KPI contributes to evaluating Effectiveness of the AI-based assistant, as part of Task 4.1 evaluation objectives, and O2 main project objective: <br/>- To assess the impact of AI-based re-scheduling on reducing delays in railway operations. <br/>- To ensure that AI interventions lead to measurable improvements in punctuality. <br/>- To provide a performance benchmark for AI-driven traffic management solutions in railway networks. ', array['18da02bc-6f0c-4cac-a080-ee03974d9a8d']::uuid[])
    ON CONFLICT(id) DO UPDATE SET name=EXCLUDED.name, description=EXCLUDED.description, field_ids=EXCLUDED.field_ids;

INSERT INTO field_definitions
        (id, key, description, agg_func, agg_weights)
        VALUES ('18da02bc-6f0c-4cac-a080-ee03974d9a8d', 'primary', 'Scenario score (raw values)', NULL, NULL)
        ON CONFLICT(id) DO UPDATE SET key=EXCLUDED.key, description=EXCLUDED.description, agg_func=EXCLUDED.agg_func, agg_weights=EXCLUDED.agg_weights;

INSERT INTO test_definitions
    (id, name, description, field_ids, scenario_ids, loop, queue)
    VALUES ('5d1db79c-a7a4-4060-bb03-4629d64b1a43', 'KPI-NF-024: Network utilization (Power Grid)', 'Network utilization KPI is based on the relative line loads of the network, indicating to what extent the network and its components are utilized.', array['63e93356-5033-451f-a3c2-cd607721661f']::uuid[], array['ed8ba2fc-853e-4e79-a984-b1986b9b6e97']::uuid[], 'CLOSED', 'PowerGrid')
    ON CONFLICT(id) DO UPDATE SET name=EXCLUDED.name, description=EXCLUDED.description, field_ids=EXCLUDED.field_ids, scenario_ids=EXCLUDED.scenario_ids, loop=EXCLUDED.loop, queue=EXCLUDED.queue;

INSERT INTO field_definitions
        (id, key, description, agg_func, agg_weights)
        VALUES ('63e93356-5033-451f-a3c2-cd607721661f', 'primary', 'Benchmark score (MEAN of test scores)', 'MEAN', NULL)
        ON CONFLICT(id) DO UPDATE SET key=EXCLUDED.key, description=EXCLUDED.description, agg_func=EXCLUDED.agg_func, agg_weights=EXCLUDED.agg_weights;

INSERT INTO scenario_definitions
    (id, name, description, field_ids)
    VALUES ('ed8ba2fc-853e-4e79-a984-b1986b9b6e97', 'primary', 'This KPI contributes to evaluating Effectiveness of the AI-based assistant, as part of Task 4.1 evaluation objectives, and O2 main project objective. ', array['68a7aead-7408-4cfa-92ee-8c108e0bf5c7']::uuid[])
    ON CONFLICT(id) DO UPDATE SET name=EXCLUDED.name, description=EXCLUDED.description, field_ids=EXCLUDED.field_ids;

INSERT INTO field_definitions
        (id, key, description, agg_func, agg_weights)
        VALUES ('68a7aead-7408-4cfa-92ee-8c108e0bf5c7', 'primary', 'Scenario score (raw values)', NULL, NULL)
        ON CONFLICT(id) DO UPDATE SET key=EXCLUDED.key, description=EXCLUDED.description, agg_func=EXCLUDED.agg_func, agg_weights=EXCLUDED.agg_weights;

INSERT INTO test_definitions
    (id, name, description, field_ids, scenario_ids, loop, queue)
    VALUES ('98ceb866-5479-47e6-a735-81292de8ca65', 'KPI-PF-026: Punctuality (Railway)', 'Punctuality measures the percentage of trains arriving at their destinations on time (the train doesn’t arrive after planned arrival) and the train didn’t depart before planned departure time. The goal is to maintain a high level of reliability and minimize delays for passengers and freight services. ', array['1de0f52c-ae47-4847-9148-97b8568952d3']::uuid[], array['5a60713d-01f2-4d32-9867-21904629e254']::uuid[], 'CLOSED', 'Railway')
    ON CONFLICT(id) DO UPDATE SET name=EXCLUDED.name, description=EXCLUDED.description, field_ids=EXCLUDED.field_ids, scenario_ids=EXCLUDED.scenario_ids, loop=EXCLUDED.loop, queue=EXCLUDED.queue;

INSERT INTO field_definitions
        (id, key, description, agg_func, agg_weights)
        VALUES ('1de0f52c-ae47-4847-9148-97b8568952d3', 'primary', 'Benchmark score (MEAN of test scores)', 'MEAN', NULL)
        ON CONFLICT(id) DO UPDATE SET key=EXCLUDED.key, description=EXCLUDED.description, agg_func=EXCLUDED.agg_func, agg_weights=EXCLUDED.agg_weights;

INSERT INTO scenario_definitions
    (id, name, description, field_ids)
    VALUES ('5a60713d-01f2-4d32-9867-21904629e254', 'primary', 'This KPI contributes to evaluating Effectiveness of the AI-based assistant, as part of Task 4.1 evaluation objectives, and O2 main project objective: <br/>- Improve customer satisfaction by ensuring timely arrivals <br/>- Guarantee maximal planned connection  <br/>- Minimize operational disruptions caused by delays <br/>- Meet regulatory and stakeholder benchmarks for punctuality <br/>This KPI is linked with project’s Long Term Expected Impacts (LTEI) (LTEI1)KPIS-3:  <br/>- 10% increase in punctuality in long-range traffic  <br/>- 5% increase in punctuality in regional traffic (with realistic disturbances) <br/>', array['c2a66425-186d-423b-b002-391c091b33c6']::uuid[])
    ON CONFLICT(id) DO UPDATE SET name=EXCLUDED.name, description=EXCLUDED.description, field_ids=EXCLUDED.field_ids;

INSERT INTO field_definitions
        (id, key, description, agg_func, agg_weights)
        VALUES ('c2a66425-186d-423b-b002-391c091b33c6', 'primary', 'Scenario score (raw values)', NULL, NULL)
        ON CONFLICT(id) DO UPDATE SET key=EXCLUDED.key, description=EXCLUDED.description, agg_func=EXCLUDED.agg_func, agg_weights=EXCLUDED.agg_weights;

INSERT INTO test_definitions
    (id, name, description, field_ids, scenario_ids, loop, queue)
    VALUES ('9b6bc151-9f25-4d85-bee1-919753934521', 'KPI-RF-027: Reduction in delay (ATM)', 'The reduction in delay KPI aims to quantify the time gained overall and for each airplane, with the introduction of AI. ', array['ca6afe0e-a91a-4683-b735-6069e6b0cd8a']::uuid[], array['437971ac-6616-429b-ad27-f8796772c570']::uuid[], 'CLOSED', 'ATM')
    ON CONFLICT(id) DO UPDATE SET name=EXCLUDED.name, description=EXCLUDED.description, field_ids=EXCLUDED.field_ids, scenario_ids=EXCLUDED.scenario_ids, loop=EXCLUDED.loop, queue=EXCLUDED.queue;

INSERT INTO field_definitions
        (id, key, description, agg_func, agg_weights)
        VALUES ('ca6afe0e-a91a-4683-b735-6069e6b0cd8a', 'primary', 'Benchmark score (MEAN of test scores)', 'MEAN', NULL)
        ON CONFLICT(id) DO UPDATE SET key=EXCLUDED.key, description=EXCLUDED.description, agg_func=EXCLUDED.agg_func, agg_weights=EXCLUDED.agg_weights;

INSERT INTO scenario_definitions
    (id, name, description, field_ids)
    VALUES ('437971ac-6616-429b-ad27-f8796772c570', 'primary', 'This KPI aims to quantify the efficiency gains of AI integration by measuring how AI impacts execution time and delays. Specifically, it helps determine whether AI: <br/>- Reduces execution time deviations <br/>- Minimizes delays<br/>- Enhances consistency and reliability in operations. <br/>By evaluating these metrics, we can assess the AI’s effectiveness in improving human decision-making, reducing intervention time, and optimizing operational workflows. <br/>This KPI contributes to evaluating Effectiveness of the AI-based assistant, as part of Task 4.1 evaluation objectives, and O2 main project objective. <br/>This KPI is linked with project’s Long Term Expected Impact (LTEI) (LTEI1)KPIS-4, 3-6% improvement in flight capacity and mile extension. ', array['de36c069-a167-4c22-8b30-3f93e6588507']::uuid[])
    ON CONFLICT(id) DO UPDATE SET name=EXCLUDED.name, description=EXCLUDED.description, field_ids=EXCLUDED.field_ids;

INSERT INTO field_definitions
        (id, key, description, agg_func, agg_weights)
        VALUES ('de36c069-a167-4c22-8b30-3f93e6588507', 'primary', 'Scenario score (raw values)', NULL, NULL)
        ON CONFLICT(id) DO UPDATE SET key=EXCLUDED.key, description=EXCLUDED.description, agg_func=EXCLUDED.agg_func, agg_weights=EXCLUDED.agg_weights;

INSERT INTO test_definitions
    (id, name, description, field_ids, scenario_ids, loop, queue)
    VALUES ('1e226684-a836-468d-9929-b95bbf2f88dc', 'KPI-AF-029: AI Response time (Railway)', 'The Response Time KPI measures the time taken by the AI-assisted railway re-scheduling system to generate a new operational schedule in response to a disruption. This metric evaluates how quickly the system reacts to unexpected events, ensuring minimal delays and maintaining operational efficiency. ', array['e00859c3-d3e5-4bdf-9025-2030e22df317']::uuid[], array['c5219c2e-c3b9-4e7a-aefc-b767a9b3005d']::uuid[], 'CLOSED', 'Railway')
    ON CONFLICT(id) DO UPDATE SET name=EXCLUDED.name, description=EXCLUDED.description, field_ids=EXCLUDED.field_ids, scenario_ids=EXCLUDED.scenario_ids, loop=EXCLUDED.loop, queue=EXCLUDED.queue;

INSERT INTO field_definitions
        (id, key, description, agg_func, agg_weights)
        VALUES ('e00859c3-d3e5-4bdf-9025-2030e22df317', 'primary', 'Benchmark score (MEAN of test scores)', 'MEAN', NULL)
        ON CONFLICT(id) DO UPDATE SET key=EXCLUDED.key, description=EXCLUDED.description, agg_func=EXCLUDED.agg_func, agg_weights=EXCLUDED.agg_weights;

INSERT INTO scenario_definitions
    (id, name, description, field_ids)
    VALUES ('c5219c2e-c3b9-4e7a-aefc-b767a9b3005d', 'primary', 'This KPI contributes to evaluating Effectiveness of the AI-based assistant, as part of Task 4.1 evaluation objectives, and O2 main project objective: <br/>- To assess the speed of AI-assisted decision-making in railway operations. <br/>- To ensure rapid re-scheduling of trains in response to disturbances, minimizing the impact on passengers and freight. <br/>- To compare AI-assisted response times with traditional manual re-scheduling approaches. ', array['35d6834e-5f89-438b-adcc-326bbeda93e2']::uuid[])
    ON CONFLICT(id) DO UPDATE SET name=EXCLUDED.name, description=EXCLUDED.description, field_ids=EXCLUDED.field_ids;

INSERT INTO field_definitions
        (id, key, description, agg_func, agg_weights)
        VALUES ('35d6834e-5f89-438b-adcc-326bbeda93e2', 'primary', 'Scenario score (raw values)', NULL, NULL)
        ON CONFLICT(id) DO UPDATE SET key=EXCLUDED.key, description=EXCLUDED.description, agg_func=EXCLUDED.agg_func, agg_weights=EXCLUDED.agg_weights;

INSERT INTO test_definitions
    (id, name, description, field_ids, scenario_ids, loop, queue)
    VALUES ('a6cb2703-be7f-44da-a3d8-652fa8797627', 'KPI-SS-032: System efficiency (ATM)', 'System efficiency measures the efficiency of the system in delivering trustworthy solutions requiring less effort and time to deliver an appropriate response by the operator.  ', array['67a19c4b-1873-4a44-8c07-e15d9ede1e78']::uuid[], array['22ef21e7-d00d-4c3b-8484-7110e024a4f5']::uuid[], 'INTERACTIVE', 'ATM')
    ON CONFLICT(id) DO UPDATE SET name=EXCLUDED.name, description=EXCLUDED.description, field_ids=EXCLUDED.field_ids, scenario_ids=EXCLUDED.scenario_ids, loop=EXCLUDED.loop, queue=EXCLUDED.queue;

INSERT INTO field_definitions
        (id, key, description, agg_func, agg_weights)
        VALUES ('67a19c4b-1873-4a44-8c07-e15d9ede1e78', 'primary', 'Benchmark score (MEAN of test scores)', 'MEAN', NULL)
        ON CONFLICT(id) DO UPDATE SET key=EXCLUDED.key, description=EXCLUDED.description, agg_func=EXCLUDED.agg_func, agg_weights=EXCLUDED.agg_weights;

INSERT INTO scenario_definitions
    (id, name, description, field_ids)
    VALUES ('22ef21e7-d00d-4c3b-8484-7110e024a4f5', 'primary', 'The System efficiency KPI aims to evaluate the effectiveness of the AI solution in real operational conditions, considering not just its raw response time but also the quality and usability of its assistance. This includes how the AI presents its advice, its ease of use, the accuracy of its recommendations, and how well it integrates with existing data and workflows. <br/>The evaluation will measure the AI-human collaboration, focusing on: <br/>- Response efficiency: The time taken for the AI to generate advice and for the human operator to act on it. <br/>- Advice clarity & usability: How well structured, coherent, and understandable the AI’s suggestions are. <br/>- Data integration quality: How seamlessly the AI incorporates relevant information into its recommendations. <br/>- Human correction factor: Whether and how often the operator needs to correct or refine the AI’s output. <br/>- Decision-making speed: The overall reduction in response time achieved through AI-assisted operation. <br/>By considering these factors, the tests aim to assess how well the AI minimizes human intervention while maximizing efficiency, accuracy, and usability in decision-making. <br/>This KPI contributes to evaluating Effectiveness of the AI-based assistant, as part of Task 4.1 evaluation objectives, and O2 main project objective. ', array['e11b124d-af80-42b7-86d1-355ce9ee83c9']::uuid[])
    ON CONFLICT(id) DO UPDATE SET name=EXCLUDED.name, description=EXCLUDED.description, field_ids=EXCLUDED.field_ids;

INSERT INTO field_definitions
        (id, key, description, agg_func, agg_weights)
        VALUES ('e11b124d-af80-42b7-86d1-355ce9ee83c9', 'primary', 'Scenario score (raw values)', NULL, NULL)
        ON CONFLICT(id) DO UPDATE SET key=EXCLUDED.key, description=EXCLUDED.description, agg_func=EXCLUDED.agg_func, agg_weights=EXCLUDED.agg_weights;

INSERT INTO test_definitions
    (id, name, description, field_ids, scenario_ids, loop, queue)
    VALUES ('58ce79e0-5c14-4c51-8d09-89f856361259', 'KPI-TS-035: Total decision time (Power Grid)', 'It is based on the overall time needed to decide, thus including the respective time taken by the AI assistant and human operator. This KPI can be detailed to specifically distinguish the time needed by the AI assistant to provide a recommendation. <br/>An assumption is that a Human Machine Interaction (HMI) module is available.  ', array['10aadaaf-daa4-4098-bd9d-2042ecb488e9']::uuid[], array['1294d425-66bd-4510-b4b3-d9f64ca0e4f9']::uuid[], 'INTERACTIVE', 'PowerGrid')
    ON CONFLICT(id) DO UPDATE SET name=EXCLUDED.name, description=EXCLUDED.description, field_ids=EXCLUDED.field_ids, scenario_ids=EXCLUDED.scenario_ids, loop=EXCLUDED.loop, queue=EXCLUDED.queue;

INSERT INTO field_definitions
        (id, key, description, agg_func, agg_weights)
        VALUES ('10aadaaf-daa4-4098-bd9d-2042ecb488e9', 'primary', 'Benchmark score (MEAN of test scores)', 'MEAN', NULL)
        ON CONFLICT(id) DO UPDATE SET key=EXCLUDED.key, description=EXCLUDED.description, agg_func=EXCLUDED.agg_func, agg_weights=EXCLUDED.agg_weights;

INSERT INTO scenario_definitions
    (id, name, description, field_ids)
    VALUES ('1294d425-66bd-4510-b4b3-d9f64ca0e4f9', 'primary', 'This KPI addresses the following objectives: <br/>1. Given an alert, how much time is left until the problem occurs? <br/>The longer the better since it gives more time to make a decision.   <br/>2. Given an alert, how much time does the AI assistant take to come up with its recommendations to mitigate the issue? <br/>The shorter the better. <br/>3. Given the recommendations by the AI assistant, how much time does the human operator take to make a final decision? <br/>The shorter the better since it indicates that the recommendations are clear and convincing for the human operator. <br/>In case there is no interaction possible between the AI assistant and the human operator, this overall split is not possible. Then there is only one overall time needed to decide, starting from the alert and ending with the final decision by the human operator. <br/>This KPI contributes to evaluating Effectiveness of the AI-based assistant, as part of Task 4.1 evaluation objectives, and O2 main project objective. ', array['fb1070a5-c929-4cd6-9723-1a5da97bfdf3']::uuid[])
    ON CONFLICT(id) DO UPDATE SET name=EXCLUDED.name, description=EXCLUDED.description, field_ids=EXCLUDED.field_ids;

INSERT INTO field_definitions
        (id, key, description, agg_func, agg_weights)
        VALUES ('fb1070a5-c929-4cd6-9723-1a5da97bfdf3', 'primary', 'Scenario score (raw values)', NULL, NULL)
        ON CONFLICT(id) DO UPDATE SET key=EXCLUDED.key, description=EXCLUDED.description, agg_func=EXCLUDED.agg_func, agg_weights=EXCLUDED.agg_weights;

INSERT INTO benchmark_definitions
    (id, name, description, field_ids, test_ids)
    VALUES ('4b0be731-8371-4e4e-a673-b630187b0bb8', 'Solution quality', 'Solution quality', array['e212421a-0c1a-4b5c-bfdf-b31886439d3f']::uuid[], array['ab91af79-ffc3-4da7-916a-6574609dc1b6', '0b8c02c6-0120-431c-872f-0fb4bc8d5fba', 'ae4dcac7-c559-457e-902d-ee35d064bb3f', 'e075d4a7-5cda-4d3c-83ac-69a0db1d74dd', 'c69ff5e9-497b-41e8-adff-2221bb823365']::uuid[])
    ON CONFLICT(id) DO UPDATE SET name=EXCLUDED.name, description=EXCLUDED.description, field_ids=EXCLUDED.field_ids, test_ids=EXCLUDED.test_ids;

INSERT INTO field_definitions
        (id, key, description, agg_func, agg_weights)
        VALUES ('e212421a-0c1a-4b5c-bfdf-b31886439d3f', 'primary', 'Benchmark score (MEAN of test scores)', 'MEAN', NULL)
        ON CONFLICT(id) DO UPDATE SET key=EXCLUDED.key, description=EXCLUDED.description, agg_func=EXCLUDED.agg_func, agg_weights=EXCLUDED.agg_weights;

INSERT INTO test_definitions
    (id, name, description, field_ids, scenario_ids, loop, queue)
    VALUES ('ab91af79-ffc3-4da7-916a-6574609dc1b6', 'KPI-CF-012: Carbon intensity (Power Grid)', 'Carbon intensity selectivity estimates the overall carbon intensity of the action recommendation provided by the AI assistant to the human operator: goal of carbon intensity KPI is to measure how much the actions will directly contribute to greenhouse gases emission, by focusing on CO2 (which is unfortunately not the only greenhouse gas).  <br/><br/>which is calculated as the weighted averaged emission factor of generation variation, including: <br/><br/>Redispatching actions, <br/><br/>Curtailment actions. ', array['d63f9bce-a639-4d20-aece-c98a16ed1e7d']::uuid[], array['75d20248-740b-4d84-86e7-1de89f10fc1e']::uuid[], 'CLOSED', 'PowerGrid')
    ON CONFLICT(id) DO UPDATE SET name=EXCLUDED.name, description=EXCLUDED.description, field_ids=EXCLUDED.field_ids, scenario_ids=EXCLUDED.scenario_ids, loop=EXCLUDED.loop, queue=EXCLUDED.queue;

INSERT INTO field_definitions
        (id, key, description, agg_func, agg_weights)
        VALUES ('d63f9bce-a639-4d20-aece-c98a16ed1e7d', 'primary', 'Benchmark score (MEAN of test scores)', 'MEAN', NULL)
        ON CONFLICT(id) DO UPDATE SET key=EXCLUDED.key, description=EXCLUDED.description, agg_func=EXCLUDED.agg_func, agg_weights=EXCLUDED.agg_weights;

INSERT INTO scenario_definitions
    (id, name, description, field_ids)
    VALUES ('75d20248-740b-4d84-86e7-1de89f10fc1e', 'primary', 'This KPI is calculated to estimate the relative performance compared to a baseline. <br/>The main difficulty of evaluating and assessing this KPIs lies in the difficulty to establish a proper deadline: <br/>- There is no history of human actions on the digital environments used for evaluation (since they are synthetic ones), <br/>- Comparison with KPI calculated on real grid’s operations (TenneT or RTE) is not relevant since each grid has its own generation mix, and each TSO has its own operation policies (and own redispatching offers). <br/>This KPI contributes to evaluating Solution quality of the AI-based assistant, as part of Task 4.1 evaluation objectives, and O2 main project objective. ', array['e0902cd7-63b3-42ce-b8e4-5fc0dd1828b4']::uuid[])
    ON CONFLICT(id) DO UPDATE SET name=EXCLUDED.name, description=EXCLUDED.description, field_ids=EXCLUDED.field_ids;

INSERT INTO field_definitions
        (id, key, description, agg_func, agg_weights)
        VALUES ('e0902cd7-63b3-42ce-b8e4-5fc0dd1828b4', 'primary', 'Scenario score (raw values)', NULL, NULL)
        ON CONFLICT(id) DO UPDATE SET key=EXCLUDED.key, description=EXCLUDED.description, agg_func=EXCLUDED.agg_func, agg_weights=EXCLUDED.agg_weights;

INSERT INTO test_definitions
    (id, name, description, field_ids, scenario_ids, loop, queue)
    VALUES ('0b8c02c6-0120-431c-872f-0fb4bc8d5fba', 'KPI-TF-034: Topological action complexity (Power Grid)', 'Topological action complexity KPI quantifies the topological utilization of the grid and gives insights into how many topological actions are utilized: performing too complex or too many topology actions can indeed navigate the grid into topologies that are either unknown or hard to recover from for operators. ', array['93dc6748-4349-42ed-9bf1-e8541e768dea']::uuid[], array['5dd33cc9-a4aa-4a61-bd3f-5fae1c1bf701']::uuid[], 'CLOSED', 'PowerGrid')
    ON CONFLICT(id) DO UPDATE SET name=EXCLUDED.name, description=EXCLUDED.description, field_ids=EXCLUDED.field_ids, scenario_ids=EXCLUDED.scenario_ids, loop=EXCLUDED.loop, queue=EXCLUDED.queue;

INSERT INTO field_definitions
        (id, key, description, agg_func, agg_weights)
        VALUES ('93dc6748-4349-42ed-9bf1-e8541e768dea', 'primary', 'Benchmark score (MEAN of test scores)', 'MEAN', NULL)
        ON CONFLICT(id) DO UPDATE SET key=EXCLUDED.key, description=EXCLUDED.description, agg_func=EXCLUDED.agg_func, agg_weights=EXCLUDED.agg_weights;

INSERT INTO scenario_definitions
    (id, name, description, field_ids)
    VALUES ('5dd33cc9-a4aa-4a61-bd3f-5fae1c1bf701', 'primary', 'This KPI contributes to evaluating Solution quality of the AI-based assistant, as part of Task 4.1 evaluation objectives, and O2 main project objective. ', array['2cf2f20b-3970-4568-a8f4-26131ea05c52']::uuid[])
    ON CONFLICT(id) DO UPDATE SET name=EXCLUDED.name, description=EXCLUDED.description, field_ids=EXCLUDED.field_ids;

INSERT INTO field_definitions
        (id, key, description, agg_func, agg_weights)
        VALUES ('2cf2f20b-3970-4568-a8f4-26131ea05c52', 'primary', 'Scenario score (raw values)', NULL, NULL)
        ON CONFLICT(id) DO UPDATE SET key=EXCLUDED.key, description=EXCLUDED.description, agg_func=EXCLUDED.agg_func, agg_weights=EXCLUDED.agg_weights;

INSERT INTO test_definitions
    (id, name, description, field_ids, scenario_ids, loop, queue)
    VALUES ('ae4dcac7-c559-457e-902d-ee35d064bb3f', 'KPI-OF-036: Operation score (Power Grid)', 'The operation score KPI for operating a power grid includes the cost of a blackout, the cost of energy losses on the grid, and the cost of remedial actions. ', array['abe274f7-3401-4fdc-a79c-25c2a4659928']::uuid[], array['fc090c38-8740-4911-96aa-2defd06f8715']::uuid[], 'CLOSED', 'PowerGrid')
    ON CONFLICT(id) DO UPDATE SET name=EXCLUDED.name, description=EXCLUDED.description, field_ids=EXCLUDED.field_ids, scenario_ids=EXCLUDED.scenario_ids, loop=EXCLUDED.loop, queue=EXCLUDED.queue;

INSERT INTO field_definitions
        (id, key, description, agg_func, agg_weights)
        VALUES ('abe274f7-3401-4fdc-a79c-25c2a4659928', 'primary', 'Benchmark score (MEAN of test scores)', 'MEAN', NULL)
        ON CONFLICT(id) DO UPDATE SET key=EXCLUDED.key, description=EXCLUDED.description, agg_func=EXCLUDED.agg_func, agg_weights=EXCLUDED.agg_weights;

INSERT INTO scenario_definitions
    (id, name, description, field_ids)
    VALUES ('fc090c38-8740-4911-96aa-2defd06f8715', 'primary', 'This KPI contributes to evaluating Solution quality of the AI-based assistant, as part of Task 4.1 evaluation objectives, and O2 main project objective. <br/><br/>This KPI is linked with project’s Long Term Expected Impacts (LTEI): <br/>- (LTEI1)KPIS-1, 15%-20% reduction in renewable energy curtailment due to optimal exploration of network flexibility with AI (see “Sum of curtailed RES energy volumes”) <br/>- (LTEI1)KPIS-2, 20%-30% avoided electricity demand shedding (see “Sum of remaining energy to be supplied in case of blackout”) ', array['c9b12bc9-ab15-4938-a0f1-1ca0d2434be6']::uuid[])
    ON CONFLICT(id) DO UPDATE SET name=EXCLUDED.name, description=EXCLUDED.description, field_ids=EXCLUDED.field_ids;

INSERT INTO field_definitions
        (id, key, description, agg_func, agg_weights)
        VALUES ('c9b12bc9-ab15-4938-a0f1-1ca0d2434be6', 'primary', 'Scenario score (raw values)', NULL, NULL)
        ON CONFLICT(id) DO UPDATE SET key=EXCLUDED.key, description=EXCLUDED.description, agg_func=EXCLUDED.agg_func, agg_weights=EXCLUDED.agg_weights;

INSERT INTO test_definitions
    (id, name, description, field_ids, scenario_ids, loop, queue)
    VALUES ('e075d4a7-5cda-4d3c-83ac-69a0db1d74dd', 'KPI-NF-045: Network Impact Propagation (Railway)', 'The Network Impact Propagation KPI measures how disruptions in one part of the railway network affect the overall system, including delay propagation and congestion spillover. This KPI helps evaluate the cascading effects of local disturbances and the efficiency of AI-assisted re-scheduling in mitigating these effects. ', array['0cc2a210-4be2-42b6-ba21-885193fdbdbc']::uuid[], array['bb6302f1-0dc2-43ed-976b-4e5d3126006a']::uuid[], 'CLOSED', 'Railway')
    ON CONFLICT(id) DO UPDATE SET name=EXCLUDED.name, description=EXCLUDED.description, field_ids=EXCLUDED.field_ids, scenario_ids=EXCLUDED.scenario_ids, loop=EXCLUDED.loop, queue=EXCLUDED.queue;

INSERT INTO field_definitions
        (id, key, description, agg_func, agg_weights)
        VALUES ('0cc2a210-4be2-42b6-ba21-885193fdbdbc', 'primary', 'Benchmark score (MEAN of test scores)', 'MEAN', NULL)
        ON CONFLICT(id) DO UPDATE SET key=EXCLUDED.key, description=EXCLUDED.description, agg_func=EXCLUDED.agg_func, agg_weights=EXCLUDED.agg_weights;

INSERT INTO scenario_definitions
    (id, name, description, field_ids)
    VALUES ('bb6302f1-0dc2-43ed-976b-4e5d3126006a', 'primary', 'This KPI contributes to evaluating Solution quality of the AI-based assistant, as part of Task 4.1 evaluation objectives, and O2 main project objective. <br/>- To assess the ripple effects of disruptions across the railway network. <br/>- To quantify how effectively AI-assisted re-scheduling contains and mitigates propagation of delays. <br/>- To support decision-making in optimizing re-scheduling strategies for network-wide efficiency. ', array['87ca95f7-4d83-48ec-94d5-cc654e1b895e']::uuid[])
    ON CONFLICT(id) DO UPDATE SET name=EXCLUDED.name, description=EXCLUDED.description, field_ids=EXCLUDED.field_ids;

INSERT INTO field_definitions
        (id, key, description, agg_func, agg_weights)
        VALUES ('87ca95f7-4d83-48ec-94d5-cc654e1b895e', 'primary', 'Scenario score (raw values)', NULL, NULL)
        ON CONFLICT(id) DO UPDATE SET key=EXCLUDED.key, description=EXCLUDED.description, agg_func=EXCLUDED.agg_func, agg_weights=EXCLUDED.agg_weights;

INSERT INTO test_definitions
    (id, name, description, field_ids, scenario_ids, loop, queue)
    VALUES ('c69ff5e9-497b-41e8-adff-2221bb823365', 'KPI-AS-068: Assistant adaptation to user preferences (Power Grid)', 'Assistant adaptation to user preferences assesses how the AI assistant adapts to operator’s choices and preferences. <br/>The assistant provides several recommendations which represent different trade-offs of different objectives, and the operator eventually makes one single choice. <br/>This KPI assume that an estimation of epistemic uncertainty is calculated for each action recommendation, which can be used later by the human to select the action in a multi-objective setting. <br/>This KPIs thus aims at measuring: <br/>- Whether the choice that the operator makes is in the set of recommendations proposed by the assistant, <br/>- How is the recommendation chosen by the operator ranked compared to the other ones, <br/>- Whether the recommendation chosen by the operator has a high epistemic uncertainty compared to the other recommendations. ', array['c428c0f7-85d3-4f40-9710-6f8690f5cc9c']::uuid[], array['a68e7062-1329-4a34-ac44-4f6075929902']::uuid[], 'INTERACTIVE', 'PowerGrid')
    ON CONFLICT(id) DO UPDATE SET name=EXCLUDED.name, description=EXCLUDED.description, field_ids=EXCLUDED.field_ids, scenario_ids=EXCLUDED.scenario_ids, loop=EXCLUDED.loop, queue=EXCLUDED.queue;

INSERT INTO field_definitions
        (id, key, description, agg_func, agg_weights)
        VALUES ('c428c0f7-85d3-4f40-9710-6f8690f5cc9c', 'primary', 'Benchmark score (MEAN of test scores)', 'MEAN', NULL)
        ON CONFLICT(id) DO UPDATE SET key=EXCLUDED.key, description=EXCLUDED.description, agg_func=EXCLUDED.agg_func, agg_weights=EXCLUDED.agg_weights;

INSERT INTO scenario_definitions
    (id, name, description, field_ids)
    VALUES ('a68e7062-1329-4a34-ac44-4f6075929902', 'primary', 'This KPI contributes to evaluating Solution quality of the AI-based assistant, as part of Task 4.1 evaluation objectives, and O2 main project objective. ', array['c4581424-f519-4f2f-9ca2-35e9aa85be3b']::uuid[])
    ON CONFLICT(id) DO UPDATE SET name=EXCLUDED.name, description=EXCLUDED.description, field_ids=EXCLUDED.field_ids;

INSERT INTO field_definitions
        (id, key, description, agg_func, agg_weights)
        VALUES ('c4581424-f519-4f2f-9ca2-35e9aa85be3b', 'primary', 'Scenario score (raw values)', NULL, NULL)
        ON CONFLICT(id) DO UPDATE SET key=EXCLUDED.key, description=EXCLUDED.description, agg_func=EXCLUDED.agg_func, agg_weights=EXCLUDED.agg_weights;

INSERT INTO benchmark_definitions
    (id, name, description, field_ids, test_ids)
    VALUES ('d65cd37a-4830-468c-9100-0f60ee9ff72e', 'AI-human task allocation balance', 'AI-human task allocation balance', array['b779fc53-d7f5-4494-a977-8b371d2a0033']::uuid[], array['6a896809-dad8-4248-a2f3-d54373953fe6', 'ed250353-1f97-413e-9971-de83937fe4d9', '5be9d1d9-535a-4940-a29d-d32d087cb197', '0d901459-427d-43ea-9c97-3815eaa52bf6', '6d372248-1221-4996-ad99-628f056f0799', '18ae6ae9-d0b4-4af8-bf37-4b7cbdb31a85']::uuid[])
    ON CONFLICT(id) DO UPDATE SET name=EXCLUDED.name, description=EXCLUDED.description, field_ids=EXCLUDED.field_ids, test_ids=EXCLUDED.test_ids;

INSERT INTO field_definitions
        (id, key, description, agg_func, agg_weights)
        VALUES ('b779fc53-d7f5-4494-a977-8b371d2a0033', 'primary', 'Benchmark score (MEAN of test scores)', 'MEAN', NULL)
        ON CONFLICT(id) DO UPDATE SET key=EXCLUDED.key, description=EXCLUDED.description, agg_func=EXCLUDED.agg_func, agg_weights=EXCLUDED.agg_weights;

INSERT INTO test_definitions
    (id, name, description, field_ids, scenario_ids, loop, queue)
    VALUES ('6a896809-dad8-4248-a2f3-d54373953fe6', 'KPI-HS-018: Human control/autonomy over the process (Railway)', 'This KPI represents human operators’ perceived autonomy over the process when working with the AI assistant measured with a questionnaire. ', array['769e8da4-b056-486a-8abc-6da526fbd54b']::uuid[], array['dddb0b01-6bab-408e-9b12-4d7ab8e3b542']::uuid[], 'OFFLINE', 'Railway')
    ON CONFLICT(id) DO UPDATE SET name=EXCLUDED.name, description=EXCLUDED.description, field_ids=EXCLUDED.field_ids, scenario_ids=EXCLUDED.scenario_ids, loop=EXCLUDED.loop, queue=EXCLUDED.queue;

INSERT INTO field_definitions
        (id, key, description, agg_func, agg_weights)
        VALUES ('769e8da4-b056-486a-8abc-6da526fbd54b', 'primary', 'Benchmark score (MEAN of test scores)', 'MEAN', NULL)
        ON CONFLICT(id) DO UPDATE SET key=EXCLUDED.key, description=EXCLUDED.description, agg_func=EXCLUDED.agg_func, agg_weights=EXCLUDED.agg_weights;

INSERT INTO scenario_definitions
    (id, name, description, field_ids)
    VALUES ('dddb0b01-6bab-408e-9b12-4d7ab8e3b542', 'primary', 'This KPI contributes to evaluating AI-human task allocation balance of the AI-based assistant, as part of Task 4.3 evaluation objectives, and O3 main project objective. <br/>It is also relevant to protocols and concepts defined in D1.1 such as “Decision support for the human operator”, “Human Agency and Oversight”, “Human control/autonomy over the process”.  ', array['c4772e39-0e9e-4bb9-8fe6-24a900847f27']::uuid[])
    ON CONFLICT(id) DO UPDATE SET name=EXCLUDED.name, description=EXCLUDED.description, field_ids=EXCLUDED.field_ids;

INSERT INTO field_definitions
        (id, key, description, agg_func, agg_weights)
        VALUES ('c4772e39-0e9e-4bb9-8fe6-24a900847f27', 'primary', 'Scenario score (raw values)', NULL, NULL)
        ON CONFLICT(id) DO UPDATE SET key=EXCLUDED.key, description=EXCLUDED.description, agg_func=EXCLUDED.agg_func, agg_weights=EXCLUDED.agg_weights;

INSERT INTO test_definitions
    (id, name, description, field_ids, scenario_ids, loop, queue)
    VALUES ('ed250353-1f97-413e-9971-de83937fe4d9', 'KPI-HS-018: Human control/autonomy over the process (Power Grid)', 'This KPI represents human operators’ perceived autonomy over the process when working with the AI assistant measured with a questionnaire. ', array['bfdfa6cc-9491-4cd4-9aa3-99d0e9eea7bd']::uuid[], array['edcf64a8-f1b8-48ec-ab6a-229d5abc1be4']::uuid[], 'OFFLINE', 'PowerGrid')
    ON CONFLICT(id) DO UPDATE SET name=EXCLUDED.name, description=EXCLUDED.description, field_ids=EXCLUDED.field_ids, scenario_ids=EXCLUDED.scenario_ids, loop=EXCLUDED.loop, queue=EXCLUDED.queue;

INSERT INTO field_definitions
        (id, key, description, agg_func, agg_weights)
        VALUES ('bfdfa6cc-9491-4cd4-9aa3-99d0e9eea7bd', 'primary', 'Benchmark score (MEAN of test scores)', 'MEAN', NULL)
        ON CONFLICT(id) DO UPDATE SET key=EXCLUDED.key, description=EXCLUDED.description, agg_func=EXCLUDED.agg_func, agg_weights=EXCLUDED.agg_weights;

INSERT INTO scenario_definitions
    (id, name, description, field_ids)
    VALUES ('edcf64a8-f1b8-48ec-ab6a-229d5abc1be4', 'primary', 'This KPI contributes to evaluating AI-human task allocation balance of the AI-based assistant, as part of Task 4.3 evaluation objectives, and O3 main project objective. <br/>It is also relevant to protocols and concepts defined in D1.1 such as “Decision support for the human operator”, “Human Agency and Oversight”, “Human control/autonomy over the process”.  ', array['e3b66c93-9e69-4ba7-a78f-b7fde9ad8138']::uuid[])
    ON CONFLICT(id) DO UPDATE SET name=EXCLUDED.name, description=EXCLUDED.description, field_ids=EXCLUDED.field_ids;

INSERT INTO field_definitions
        (id, key, description, agg_func, agg_weights)
        VALUES ('e3b66c93-9e69-4ba7-a78f-b7fde9ad8138', 'primary', 'Scenario score (raw values)', NULL, NULL)
        ON CONFLICT(id) DO UPDATE SET key=EXCLUDED.key, description=EXCLUDED.description, agg_func=EXCLUDED.agg_func, agg_weights=EXCLUDED.agg_weights;

INSERT INTO test_definitions
    (id, name, description, field_ids, scenario_ids, loop, queue)
    VALUES ('5be9d1d9-535a-4940-a29d-d32d087cb197', 'KPI-HS-018: Human control/autonomy over the process (ATM)', 'This KPI represents human operators’ perceived autonomy over the process when working with the AI assistant measured with a questionnaire. ', array['127ea400-14bd-48aa-9da6-e932a802dcb3']::uuid[], array['3324347e-e4cb-42a2-9f53-430421090075']::uuid[], 'OFFLINE', 'ATM')
    ON CONFLICT(id) DO UPDATE SET name=EXCLUDED.name, description=EXCLUDED.description, field_ids=EXCLUDED.field_ids, scenario_ids=EXCLUDED.scenario_ids, loop=EXCLUDED.loop, queue=EXCLUDED.queue;

INSERT INTO field_definitions
        (id, key, description, agg_func, agg_weights)
        VALUES ('127ea400-14bd-48aa-9da6-e932a802dcb3', 'primary', 'Benchmark score (MEAN of test scores)', 'MEAN', NULL)
        ON CONFLICT(id) DO UPDATE SET key=EXCLUDED.key, description=EXCLUDED.description, agg_func=EXCLUDED.agg_func, agg_weights=EXCLUDED.agg_weights;

INSERT INTO scenario_definitions
    (id, name, description, field_ids)
    VALUES ('3324347e-e4cb-42a2-9f53-430421090075', 'primary', 'This KPI contributes to evaluating AI-human task allocation balance of the AI-based assistant, as part of Task 4.3 evaluation objectives, and O3 main project objective. <br/>It is also relevant to protocols and concepts defined in D1.1 such as “Decision support for the human operator”, “Human Agency and Oversight”, “Human control/autonomy over the process”.  ', array['32b83567-5e58-403c-b509-66a6a53d103c']::uuid[])
    ON CONFLICT(id) DO UPDATE SET name=EXCLUDED.name, description=EXCLUDED.description, field_ids=EXCLUDED.field_ids;

INSERT INTO field_definitions
        (id, key, description, agg_func, agg_weights)
        VALUES ('32b83567-5e58-403c-b509-66a6a53d103c', 'primary', 'Scenario score (raw values)', NULL, NULL)
        ON CONFLICT(id) DO UPDATE SET key=EXCLUDED.key, description=EXCLUDED.description, agg_func=EXCLUDED.agg_func, agg_weights=EXCLUDED.agg_weights;

INSERT INTO test_definitions
    (id, name, description, field_ids, scenario_ids, loop, queue)
    VALUES ('0d901459-427d-43ea-9c97-3815eaa52bf6', 'KPI-IS-041: Impact on workload (Railway)', 'Impact on the workload KPI assesses operators’ perception of the system impact on their workload (either positive or negative)  ', array['831bdb0e-c5c3-4df0-b9c4-4e42c6515c09']::uuid[], array['e967a3b5-6d9b-41c2-9897-4e40a186e879']::uuid[], 'OFFLINE', 'Railway')
    ON CONFLICT(id) DO UPDATE SET name=EXCLUDED.name, description=EXCLUDED.description, field_ids=EXCLUDED.field_ids, scenario_ids=EXCLUDED.scenario_ids, loop=EXCLUDED.loop, queue=EXCLUDED.queue;

INSERT INTO field_definitions
        (id, key, description, agg_func, agg_weights)
        VALUES ('831bdb0e-c5c3-4df0-b9c4-4e42c6515c09', 'primary', 'Benchmark score (MEAN of test scores)', 'MEAN', NULL)
        ON CONFLICT(id) DO UPDATE SET key=EXCLUDED.key, description=EXCLUDED.description, agg_func=EXCLUDED.agg_func, agg_weights=EXCLUDED.agg_weights;

INSERT INTO scenario_definitions
    (id, name, description, field_ids)
    VALUES ('e967a3b5-6d9b-41c2-9897-4e40a186e879', 'primary', 'This KPI compares if the inputs of the operators are according to their real psychophysiology. This can act as a verification methodology but also support the AI to adapt. <br/>This KPI will be analyzed together with the “Workload” KPI-WS-040. <br/>This KPI contributes to evaluating AI-human task allocation balance of the AI-based assistant, as part of Task 4.3 evaluation objectives, and O3 main project objective. ', array['d70b6f48-795a-430d-8c82-288190d35b78']::uuid[])
    ON CONFLICT(id) DO UPDATE SET name=EXCLUDED.name, description=EXCLUDED.description, field_ids=EXCLUDED.field_ids;

INSERT INTO field_definitions
        (id, key, description, agg_func, agg_weights)
        VALUES ('d70b6f48-795a-430d-8c82-288190d35b78', 'primary', 'Scenario score (raw values)', NULL, NULL)
        ON CONFLICT(id) DO UPDATE SET key=EXCLUDED.key, description=EXCLUDED.description, agg_func=EXCLUDED.agg_func, agg_weights=EXCLUDED.agg_weights;

INSERT INTO test_definitions
    (id, name, description, field_ids, scenario_ids, loop, queue)
    VALUES ('6d372248-1221-4996-ad99-628f056f0799', 'KPI-IS-041: Impact on workload (Power Grid)', 'Impact on the workload KPI assesses operators’ perception of the system impact on their workload (either positive or negative)  ', array['df9918ae-1bb3-4407-8240-6aaa6d67a5ea']::uuid[], array['df02b09a-b431-49ee-af6b-ffd709d47670']::uuid[], 'OFFLINE', 'PowerGrid')
    ON CONFLICT(id) DO UPDATE SET name=EXCLUDED.name, description=EXCLUDED.description, field_ids=EXCLUDED.field_ids, scenario_ids=EXCLUDED.scenario_ids, loop=EXCLUDED.loop, queue=EXCLUDED.queue;

INSERT INTO field_definitions
        (id, key, description, agg_func, agg_weights)
        VALUES ('df9918ae-1bb3-4407-8240-6aaa6d67a5ea', 'primary', 'Benchmark score (MEAN of test scores)', 'MEAN', NULL)
        ON CONFLICT(id) DO UPDATE SET key=EXCLUDED.key, description=EXCLUDED.description, agg_func=EXCLUDED.agg_func, agg_weights=EXCLUDED.agg_weights;

INSERT INTO scenario_definitions
    (id, name, description, field_ids)
    VALUES ('df02b09a-b431-49ee-af6b-ffd709d47670', 'primary', 'This KPI compares if the inputs of the operators are according to their real psychophysiology. This can act as a verification methodology but also support the AI to adapt. <br/>This KPI will be analyzed together with the “Workload” KPI-WS-040. <br/>This KPI contributes to evaluating AI-human task allocation balance of the AI-based assistant, as part of Task 4.3 evaluation objectives, and O3 main project objective. ', array['bb67e013-b02d-460e-be59-e5ef3948e34b']::uuid[])
    ON CONFLICT(id) DO UPDATE SET name=EXCLUDED.name, description=EXCLUDED.description, field_ids=EXCLUDED.field_ids;

INSERT INTO field_definitions
        (id, key, description, agg_func, agg_weights)
        VALUES ('bb67e013-b02d-460e-be59-e5ef3948e34b', 'primary', 'Scenario score (raw values)', NULL, NULL)
        ON CONFLICT(id) DO UPDATE SET key=EXCLUDED.key, description=EXCLUDED.description, agg_func=EXCLUDED.agg_func, agg_weights=EXCLUDED.agg_weights;

INSERT INTO test_definitions
    (id, name, description, field_ids, scenario_ids, loop, queue)
    VALUES ('18ae6ae9-d0b4-4af8-bf37-4b7cbdb31a85', 'KPI-IS-041: Impact on workload (ATM)', 'Impact on the workload KPI assesses operators’ perception of the system impact on their workload (either positive or negative)  ', array['74b82b7a-f693-4423-b221-d9acae930d93']::uuid[], array['fddeb18e-789e-40e0-9680-ca58ae10851f']::uuid[], 'OFFLINE', 'ATM')
    ON CONFLICT(id) DO UPDATE SET name=EXCLUDED.name, description=EXCLUDED.description, field_ids=EXCLUDED.field_ids, scenario_ids=EXCLUDED.scenario_ids, loop=EXCLUDED.loop, queue=EXCLUDED.queue;

INSERT INTO field_definitions
        (id, key, description, agg_func, agg_weights)
        VALUES ('74b82b7a-f693-4423-b221-d9acae930d93', 'primary', 'Benchmark score (MEAN of test scores)', 'MEAN', NULL)
        ON CONFLICT(id) DO UPDATE SET key=EXCLUDED.key, description=EXCLUDED.description, agg_func=EXCLUDED.agg_func, agg_weights=EXCLUDED.agg_weights;

INSERT INTO scenario_definitions
    (id, name, description, field_ids)
    VALUES ('fddeb18e-789e-40e0-9680-ca58ae10851f', 'primary', 'This KPI compares if the inputs of the operators are according to their real psychophysiology. This can act as a verification methodology but also support the AI to adapt. <br/>This KPI will be analyzed together with the “Workload” KPI-WS-040. <br/>This KPI contributes to evaluating AI-human task allocation balance of the AI-based assistant, as part of Task 4.3 evaluation objectives, and O3 main project objective. ', array['26c99c3e-8ad1-4241-954f-25f56fade8a0']::uuid[])
    ON CONFLICT(id) DO UPDATE SET name=EXCLUDED.name, description=EXCLUDED.description, field_ids=EXCLUDED.field_ids;

INSERT INTO field_definitions
        (id, key, description, agg_func, agg_weights)
        VALUES ('26c99c3e-8ad1-4241-954f-25f56fade8a0', 'primary', 'Scenario score (raw values)', NULL, NULL)
        ON CONFLICT(id) DO UPDATE SET key=EXCLUDED.key, description=EXCLUDED.description, agg_func=EXCLUDED.agg_func, agg_weights=EXCLUDED.agg_weights;

INSERT INTO benchmark_definitions
    (id, name, description, field_ids, test_ids)
    VALUES ('16706c82-75df-4969-932d-a7f5c941eca2', 'Scalability', 'Scalability', array['4707c199-adb6-4af9-b8a2-cf70368e7905']::uuid[], array['dff7e358-ff14-45e7-bc22-aac2b50500f3', '5af6ffd9-b0a6-4f53-94bf-058fc1383ecd', '4cba45eb-2512-4e8e-87da-d39a45e529f8', 'b2e91a79-1390-414f-bf5d-8a6fd93c6080', '1409dbf6-0f66-4570-97df-fda84c46c71d', 'bf76b70f-77ee-4cc0-9c4c-4165eca347d2']::uuid[])
    ON CONFLICT(id) DO UPDATE SET name=EXCLUDED.name, description=EXCLUDED.description, field_ids=EXCLUDED.field_ids, test_ids=EXCLUDED.test_ids;

INSERT INTO field_definitions
        (id, key, description, agg_func, agg_weights)
        VALUES ('4707c199-adb6-4af9-b8a2-cf70368e7905', 'primary', 'Benchmark score (MEAN of test scores)', 'MEAN', NULL)
        ON CONFLICT(id) DO UPDATE SET key=EXCLUDED.key, description=EXCLUDED.description, agg_func=EXCLUDED.agg_func, agg_weights=EXCLUDED.agg_weights;

INSERT INTO test_definitions
    (id, name, description, field_ids, scenario_ids, loop, queue)
    VALUES ('dff7e358-ff14-45e7-bc22-aac2b50500f3', 'KPI-AF-050: AI-Agent Scalability Training (Railway)', 'AI-Agent Scalability Training measures the elapsed time required by an AI-agent to reach a predefined performance threshold. Time measured both as wallclock time (seconds) as well as steps or episodes according to the domain needs. The performance is defined by the native reward formulation defined by the digital environment or by domain experts. <br/>The time to threshold is measured across:  <br/>(i) Different instance complexities; <br/>(ii) Different hardware availability. <br/>The performance threshold is set empirically and is defined by the cumulative reward formulation specific to the application domain. Note that the reward formulation used to train the agent may differ. For case (i), the type of hardware used should be logged to interpret the wallclock time measurements. ', array['91c4f865-5e81-46d3-bd23-990aa361a828']::uuid[], array['d7cea956-6803-488c-b402-079d13b892c6']::uuid[], 'CLOSED', 'Railway')
    ON CONFLICT(id) DO UPDATE SET name=EXCLUDED.name, description=EXCLUDED.description, field_ids=EXCLUDED.field_ids, scenario_ids=EXCLUDED.scenario_ids, loop=EXCLUDED.loop, queue=EXCLUDED.queue;

INSERT INTO field_definitions
        (id, key, description, agg_func, agg_weights)
        VALUES ('91c4f865-5e81-46d3-bd23-990aa361a828', 'primary', 'Benchmark score (MEAN of test scores)', 'MEAN', NULL)
        ON CONFLICT(id) DO UPDATE SET key=EXCLUDED.key, description=EXCLUDED.description, agg_func=EXCLUDED.agg_func, agg_weights=EXCLUDED.agg_weights;

INSERT INTO scenario_definitions
    (id, name, description, field_ids)
    VALUES ('d7cea956-6803-488c-b402-079d13b892c6', 'primary', 'This KPI contributes to evaluating Scalability of the AI-based assistant, as part of Task 4.1 evaluation objectives, and O2 main project objective. ', array['c61d974a-44c7-44d9-8932-93654ed81ed9']::uuid[])
    ON CONFLICT(id) DO UPDATE SET name=EXCLUDED.name, description=EXCLUDED.description, field_ids=EXCLUDED.field_ids;

INSERT INTO field_definitions
        (id, key, description, agg_func, agg_weights)
        VALUES ('c61d974a-44c7-44d9-8932-93654ed81ed9', 'primary', 'Scenario score (raw values)', NULL, NULL)
        ON CONFLICT(id) DO UPDATE SET key=EXCLUDED.key, description=EXCLUDED.description, agg_func=EXCLUDED.agg_func, agg_weights=EXCLUDED.agg_weights;

INSERT INTO test_definitions
    (id, name, description, field_ids, scenario_ids, loop, queue)
    VALUES ('5af6ffd9-b0a6-4f53-94bf-058fc1383ecd', 'KPI-AF-050: AI-Agent Scalability Training (Power Grid)', 'AI-Agent Scalability Training measures the elapsed time required by an AI-agent to reach a predefined performance threshold. Time measured both as wallclock time (seconds) as well as steps or episodes according to the domain needs. The performance is defined by the native reward formulation defined by the digital environment or by domain experts. <br/>The time to threshold is measured across:  <br/>(i) Different instance complexities; <br/>(ii) Different hardware availability. <br/>The performance threshold is set empirically and is defined by the cumulative reward formulation specific to the application domain. Note that the reward formulation used to train the agent may differ. For case (i), the type of hardware used should be logged to interpret the wallclock time measurements. ', array['a7c2bf7f-7845-4127-8c18-5eb820f5d317']::uuid[], array['7d2d75c8-49e0-433d-809d-b0811c8e2f06']::uuid[], 'CLOSED', 'PowerGrid')
    ON CONFLICT(id) DO UPDATE SET name=EXCLUDED.name, description=EXCLUDED.description, field_ids=EXCLUDED.field_ids, scenario_ids=EXCLUDED.scenario_ids, loop=EXCLUDED.loop, queue=EXCLUDED.queue;

INSERT INTO field_definitions
        (id, key, description, agg_func, agg_weights)
        VALUES ('a7c2bf7f-7845-4127-8c18-5eb820f5d317', 'primary', 'Benchmark score (MEAN of test scores)', 'MEAN', NULL)
        ON CONFLICT(id) DO UPDATE SET key=EXCLUDED.key, description=EXCLUDED.description, agg_func=EXCLUDED.agg_func, agg_weights=EXCLUDED.agg_weights;

INSERT INTO scenario_definitions
    (id, name, description, field_ids)
    VALUES ('7d2d75c8-49e0-433d-809d-b0811c8e2f06', 'primary', 'This KPI contributes to evaluating Scalability of the AI-based assistant, as part of Task 4.1 evaluation objectives, and O2 main project objective. ', array['8232e73d-9f70-466d-ab53-c648efd58afb']::uuid[])
    ON CONFLICT(id) DO UPDATE SET name=EXCLUDED.name, description=EXCLUDED.description, field_ids=EXCLUDED.field_ids;

INSERT INTO field_definitions
        (id, key, description, agg_func, agg_weights)
        VALUES ('8232e73d-9f70-466d-ab53-c648efd58afb', 'primary', 'Scenario score (raw values)', NULL, NULL)
        ON CONFLICT(id) DO UPDATE SET key=EXCLUDED.key, description=EXCLUDED.description, agg_func=EXCLUDED.agg_func, agg_weights=EXCLUDED.agg_weights;

INSERT INTO test_definitions
    (id, name, description, field_ids, scenario_ids, loop, queue)
    VALUES ('4cba45eb-2512-4e8e-87da-d39a45e529f8', 'KPI-AF-050: AI-Agent Scalability Training (ATM)', 'AI-Agent Scalability Training measures the elapsed time required by an AI-agent to reach a predefined performance threshold. Time measured both as wallclock time (seconds) as well as steps or episodes according to the domain needs. The performance is defined by the native reward formulation defined by the digital environment or by domain experts. <br/>The time to threshold is measured across:  <br/>(i) Different instance complexities; <br/>(ii) Different hardware availability. <br/>The performance threshold is set empirically and is defined by the cumulative reward formulation specific to the application domain. Note that the reward formulation used to train the agent may differ. For case (i), the type of hardware used should be logged to interpret the wallclock time measurements. ', array['0a42cb23-d3a2-4691-b430-61753b745806']::uuid[], array['89bbf582-bb03-4039-9318-1178da706760']::uuid[], 'CLOSED', 'ATM')
    ON CONFLICT(id) DO UPDATE SET name=EXCLUDED.name, description=EXCLUDED.description, field_ids=EXCLUDED.field_ids, scenario_ids=EXCLUDED.scenario_ids, loop=EXCLUDED.loop, queue=EXCLUDED.queue;

INSERT INTO field_definitions
        (id, key, description, agg_func, agg_weights)
        VALUES ('0a42cb23-d3a2-4691-b430-61753b745806', 'primary', 'Benchmark score (MEAN of test scores)', 'MEAN', NULL)
        ON CONFLICT(id) DO UPDATE SET key=EXCLUDED.key, description=EXCLUDED.description, agg_func=EXCLUDED.agg_func, agg_weights=EXCLUDED.agg_weights;

INSERT INTO scenario_definitions
    (id, name, description, field_ids)
    VALUES ('89bbf582-bb03-4039-9318-1178da706760', 'primary', 'This KPI contributes to evaluating Scalability of the AI-based assistant, as part of Task 4.1 evaluation objectives, and O2 main project objective. ', array['6d8c4b1d-d30e-41e1-a0e5-dbd327af240f']::uuid[])
    ON CONFLICT(id) DO UPDATE SET name=EXCLUDED.name, description=EXCLUDED.description, field_ids=EXCLUDED.field_ids;

INSERT INTO field_definitions
        (id, key, description, agg_func, agg_weights)
        VALUES ('6d8c4b1d-d30e-41e1-a0e5-dbd327af240f', 'primary', 'Scenario score (raw values)', NULL, NULL)
        ON CONFLICT(id) DO UPDATE SET key=EXCLUDED.key, description=EXCLUDED.description, agg_func=EXCLUDED.agg_func, agg_weights=EXCLUDED.agg_weights;

INSERT INTO test_definitions
    (id, name, description, field_ids, scenario_ids, loop, queue)
    VALUES ('b2e91a79-1390-414f-bf5d-8a6fd93c6080', 'KPI-AF-051: AI-Agent Scalability Testing (Railway)', 'Compare multiple trained agents, RL-based or not, based on the average inference time to sample one or multiple actions while increasing the complexity of the scenario analysed. Complexity is a domain-relevant concept that must be defined. ', array['efee7a16-4bb5-4c6f-965d-272ec8c2631b']::uuid[], array['1f2b1af1-dc36-49ae-9322-e61656951545']::uuid[], 'CLOSED', 'Railway')
    ON CONFLICT(id) DO UPDATE SET name=EXCLUDED.name, description=EXCLUDED.description, field_ids=EXCLUDED.field_ids, scenario_ids=EXCLUDED.scenario_ids, loop=EXCLUDED.loop, queue=EXCLUDED.queue;

INSERT INTO field_definitions
        (id, key, description, agg_func, agg_weights)
        VALUES ('efee7a16-4bb5-4c6f-965d-272ec8c2631b', 'primary', 'Benchmark score (MEAN of test scores)', 'MEAN', NULL)
        ON CONFLICT(id) DO UPDATE SET key=EXCLUDED.key, description=EXCLUDED.description, agg_func=EXCLUDED.agg_func, agg_weights=EXCLUDED.agg_weights;

INSERT INTO scenario_definitions
    (id, name, description, field_ids)
    VALUES ('1f2b1af1-dc36-49ae-9322-e61656951545', 'primary', 'This KPI contributes to evaluating Scalability of the AI-based assistant, as part of Task 4.1 evaluation objectives, and O2 main project objective. ', array['60b8cf5e-e4bf-46a6-ba95-4efa12309373']::uuid[])
    ON CONFLICT(id) DO UPDATE SET name=EXCLUDED.name, description=EXCLUDED.description, field_ids=EXCLUDED.field_ids;

INSERT INTO field_definitions
        (id, key, description, agg_func, agg_weights)
        VALUES ('60b8cf5e-e4bf-46a6-ba95-4efa12309373', 'primary', 'Scenario score (raw values)', NULL, NULL)
        ON CONFLICT(id) DO UPDATE SET key=EXCLUDED.key, description=EXCLUDED.description, agg_func=EXCLUDED.agg_func, agg_weights=EXCLUDED.agg_weights;

INSERT INTO test_definitions
    (id, name, description, field_ids, scenario_ids, loop, queue)
    VALUES ('1409dbf6-0f66-4570-97df-fda84c46c71d', 'KPI-AF-051: AI-Agent Scalability Testing (Power Grid)', 'Compare multiple trained agents, RL-based or not, based on the average inference time to sample one or multiple actions while increasing the complexity of the scenario analysed. Complexity is a domain-relevant concept that must be defined. ', array['c6f944e3-9937-453c-95da-9b69681b023e']::uuid[], array['547f8244-d091-40da-892d-ee24a26ee29f']::uuid[], 'CLOSED', 'PowerGrid')
    ON CONFLICT(id) DO UPDATE SET name=EXCLUDED.name, description=EXCLUDED.description, field_ids=EXCLUDED.field_ids, scenario_ids=EXCLUDED.scenario_ids, loop=EXCLUDED.loop, queue=EXCLUDED.queue;

INSERT INTO field_definitions
        (id, key, description, agg_func, agg_weights)
        VALUES ('c6f944e3-9937-453c-95da-9b69681b023e', 'primary', 'Benchmark score (MEAN of test scores)', 'MEAN', NULL)
        ON CONFLICT(id) DO UPDATE SET key=EXCLUDED.key, description=EXCLUDED.description, agg_func=EXCLUDED.agg_func, agg_weights=EXCLUDED.agg_weights;

INSERT INTO scenario_definitions
    (id, name, description, field_ids)
    VALUES ('547f8244-d091-40da-892d-ee24a26ee29f', 'primary', 'This KPI contributes to evaluating Scalability of the AI-based assistant, as part of Task 4.1 evaluation objectives, and O2 main project objective. ', array['3f680640-3269-4678-bd28-3900b8dddd6a']::uuid[])
    ON CONFLICT(id) DO UPDATE SET name=EXCLUDED.name, description=EXCLUDED.description, field_ids=EXCLUDED.field_ids;

INSERT INTO field_definitions
        (id, key, description, agg_func, agg_weights)
        VALUES ('3f680640-3269-4678-bd28-3900b8dddd6a', 'primary', 'Scenario score (raw values)', NULL, NULL)
        ON CONFLICT(id) DO UPDATE SET key=EXCLUDED.key, description=EXCLUDED.description, agg_func=EXCLUDED.agg_func, agg_weights=EXCLUDED.agg_weights;

INSERT INTO test_definitions
    (id, name, description, field_ids, scenario_ids, loop, queue)
    VALUES ('bf76b70f-77ee-4cc0-9c4c-4165eca347d2', 'KPI-AF-051: AI-Agent Scalability Testing (ATM)', 'Compare multiple trained agents, RL-based or not, based on the average inference time to sample one or multiple actions while increasing the complexity of the scenario analysed. Complexity is a domain-relevant concept that must be defined. ', array['7ff6b34d-2221-414e-86e8-c26dbd34f8f5']::uuid[], array['b63f9a44-68e0-4850-b622-bac55d980b30']::uuid[], 'CLOSED', 'ATM')
    ON CONFLICT(id) DO UPDATE SET name=EXCLUDED.name, description=EXCLUDED.description, field_ids=EXCLUDED.field_ids, scenario_ids=EXCLUDED.scenario_ids, loop=EXCLUDED.loop, queue=EXCLUDED.queue;

INSERT INTO field_definitions
        (id, key, description, agg_func, agg_weights)
        VALUES ('7ff6b34d-2221-414e-86e8-c26dbd34f8f5', 'primary', 'Benchmark score (MEAN of test scores)', 'MEAN', NULL)
        ON CONFLICT(id) DO UPDATE SET key=EXCLUDED.key, description=EXCLUDED.description, agg_func=EXCLUDED.agg_func, agg_weights=EXCLUDED.agg_weights;

INSERT INTO scenario_definitions
    (id, name, description, field_ids)
    VALUES ('b63f9a44-68e0-4850-b622-bac55d980b30', 'primary', 'This KPI contributes to evaluating Scalability of the AI-based assistant, as part of Task 4.1 evaluation objectives, and O2 main project objective. ', array['51378548-5033-44f4-9578-703014cbc902']::uuid[])
    ON CONFLICT(id) DO UPDATE SET name=EXCLUDED.name, description=EXCLUDED.description, field_ids=EXCLUDED.field_ids;

INSERT INTO field_definitions
        (id, key, description, agg_func, agg_weights)
        VALUES ('51378548-5033-44f4-9578-703014cbc902', 'primary', 'Scenario score (raw values)', NULL, NULL)
        ON CONFLICT(id) DO UPDATE SET key=EXCLUDED.key, description=EXCLUDED.description, agg_func=EXCLUDED.agg_func, agg_weights=EXCLUDED.agg_weights;

INSERT INTO benchmark_definitions
    (id, name, description, field_ids, test_ids)
    VALUES ('43040944-39ac-47c9-b91d-bc8ca5693b3c', 'Reliability', 'Reliability', array['69d2fb08-7e8c-495a-b95d-688de344c989']::uuid[], array['0c3b9843-1940-45ef-943a-dc13ec1d090a', '855729a4-6729-4ae2-bb8d-443ef4867d94', '68412020-58d7-4180-8cae-99f2ffa4dbf5', 'fba17d1f-2eb7-4c06-8f77-5da14e7b875a', '17b805b2-b773-4c22-8ba9-598780e7a40d', 'aecbfe66-c49f-42cb-b624-d98c3d74fcb1', '69259fb3-bba8-4e62-9103-552b439ebaf4', '7149a428-b0a7-48f7-ba55-4d553932af41', 'a34741a1-d279-4b5b-a327-2a0f94bea125', 'dce1c0e9-f2ae-4faa-a6b3-76d037c082d0', '115d6c9d-c0d1-423d-b74e-140f9e5608c5', 'a3adb18d-3b44-4498-8c2c-728d5ff40248', '03e1fcaf-a933-4ad1-abf2-5541574298a2', '07f8625d-c39a-4fd1-9633-012f342352e9', 'defac2f8-5b3b-4de9-ae1b-8e2f74380257', 'd795c7bd-f8be-43c2-ae6e-a931194d3fc5', 'c5e4f893-4302-47e8-98d6-b5fbcb10963a', 'e75c588d-276f-4c6f-a329-90d570da9b67', '511f2ab0-da90-4d55-a23f-af5eda0baf7d', '648afbec-80ad-4490-869f-6c3d8088d50f', '9c6f7e45-b966-4b55-8315-790577683344']::uuid[])
    ON CONFLICT(id) DO UPDATE SET name=EXCLUDED.name, description=EXCLUDED.description, field_ids=EXCLUDED.field_ids, test_ids=EXCLUDED.test_ids;

INSERT INTO field_definitions
        (id, key, description, agg_func, agg_weights)
        VALUES ('69d2fb08-7e8c-495a-b95d-688de344c989', 'primary', 'Benchmark score (MEAN of test scores)', 'MEAN', NULL)
        ON CONFLICT(id) DO UPDATE SET key=EXCLUDED.key, description=EXCLUDED.description, agg_func=EXCLUDED.agg_func, agg_weights=EXCLUDED.agg_weights;

INSERT INTO test_definitions
    (id, name, description, field_ids, scenario_ids, loop, queue)
    VALUES ('0c3b9843-1940-45ef-943a-dc13ec1d090a', 'KPI-DF-052: Domain shift adaptation time (Railway)', 'The time or number of episodes required for the agent to regain a specific level of performance in the shifted domain after the domain shift has occurred. It can be used to evaluate how quickly an agent can adapt to new environmental conditions.  ', array['eac95a57-49b8-4909-a460-54277465030a']::uuid[], array['adb8b61b-6203-436d-9b40-8d4f95af7f43']::uuid[], 'CLOSED', 'Railway')
    ON CONFLICT(id) DO UPDATE SET name=EXCLUDED.name, description=EXCLUDED.description, field_ids=EXCLUDED.field_ids, scenario_ids=EXCLUDED.scenario_ids, loop=EXCLUDED.loop, queue=EXCLUDED.queue;

INSERT INTO field_definitions
        (id, key, description, agg_func, agg_weights)
        VALUES ('eac95a57-49b8-4909-a460-54277465030a', 'primary', 'Benchmark score (MEAN of test scores)', 'MEAN', NULL)
        ON CONFLICT(id) DO UPDATE SET key=EXCLUDED.key, description=EXCLUDED.description, agg_func=EXCLUDED.agg_func, agg_weights=EXCLUDED.agg_weights;

INSERT INTO scenario_definitions
    (id, name, description, field_ids)
    VALUES ('adb8b61b-6203-436d-9b40-8d4f95af7f43', 'primary', 'Domain adaptation (DA) is a sub-field of transfer learning. DA can be defined as the capability to deploy a model trained in one or more source domains into a different target domain. We consider that the source and target domains have the same feature space. In this sense, it is important for RL based agents to have a reasonable adaptation time to a new domain which may present a slight shift from the source domain. However, the adaptation time should also consider the performance drop into its computation, as a high performance drop after the adaptation could not be tolerated.  <br/>This KPI contributes to evaluating Reliability of the AI-based assistant when dealing with real-world conditions which may be slightly different from source domain, as part of Task 4.2 evaluation objectives, and O4 main project objective. ', array['0b2b67e3-4d94-4006-9934-bbaf2184135c']::uuid[])
    ON CONFLICT(id) DO UPDATE SET name=EXCLUDED.name, description=EXCLUDED.description, field_ids=EXCLUDED.field_ids;

INSERT INTO field_definitions
        (id, key, description, agg_func, agg_weights)
        VALUES ('0b2b67e3-4d94-4006-9934-bbaf2184135c', 'primary', 'Scenario score (raw values)', NULL, NULL)
        ON CONFLICT(id) DO UPDATE SET key=EXCLUDED.key, description=EXCLUDED.description, agg_func=EXCLUDED.agg_func, agg_weights=EXCLUDED.agg_weights;

INSERT INTO test_definitions
    (id, name, description, field_ids, scenario_ids, loop, queue)
    VALUES ('855729a4-6729-4ae2-bb8d-443ef4867d94', 'KPI-DF-052: Domain shift adaptation time (Power Grid)', 'The time or number of episodes required for the agent to regain a specific level of performance in the shifted domain after the domain shift has occurred. It can be used to evaluate how quickly an agent can adapt to new environmental conditions.  ', array['fc6b934f-8cea-4126-a835-6f1450b423ec']::uuid[], array['81f18394-0164-4896-9408-4315bcfcc5e0']::uuid[], 'CLOSED', 'PowerGrid')
    ON CONFLICT(id) DO UPDATE SET name=EXCLUDED.name, description=EXCLUDED.description, field_ids=EXCLUDED.field_ids, scenario_ids=EXCLUDED.scenario_ids, loop=EXCLUDED.loop, queue=EXCLUDED.queue;

INSERT INTO field_definitions
        (id, key, description, agg_func, agg_weights)
        VALUES ('fc6b934f-8cea-4126-a835-6f1450b423ec', 'primary', 'Benchmark score (MEAN of test scores)', 'MEAN', NULL)
        ON CONFLICT(id) DO UPDATE SET key=EXCLUDED.key, description=EXCLUDED.description, agg_func=EXCLUDED.agg_func, agg_weights=EXCLUDED.agg_weights;

INSERT INTO scenario_definitions
    (id, name, description, field_ids)
    VALUES ('81f18394-0164-4896-9408-4315bcfcc5e0', 'primary', 'Domain adaptation (DA) is a sub-field of transfer learning. DA can be defined as the capability to deploy a model trained in one or more source domains into a different target domain. We consider that the source and target domains have the same feature space. In this sense, it is important for RL based agents to have a reasonable adaptation time to a new domain which may present a slight shift from the source domain. However, the adaptation time should also consider the performance drop into its computation, as a high performance drop after the adaptation could not be tolerated.  <br/>This KPI contributes to evaluating Reliability of the AI-based assistant when dealing with real-world conditions which may be slightly different from source domain, as part of Task 4.2 evaluation objectives, and O4 main project objective. ', array['3fdb69b7-1e58-4453-b2ca-0b559f83140a']::uuid[])
    ON CONFLICT(id) DO UPDATE SET name=EXCLUDED.name, description=EXCLUDED.description, field_ids=EXCLUDED.field_ids;

INSERT INTO field_definitions
        (id, key, description, agg_func, agg_weights)
        VALUES ('3fdb69b7-1e58-4453-b2ca-0b559f83140a', 'primary', 'Scenario score (raw values)', NULL, NULL)
        ON CONFLICT(id) DO UPDATE SET key=EXCLUDED.key, description=EXCLUDED.description, agg_func=EXCLUDED.agg_func, agg_weights=EXCLUDED.agg_weights;

INSERT INTO test_definitions
    (id, name, description, field_ids, scenario_ids, loop, queue)
    VALUES ('68412020-58d7-4180-8cae-99f2ffa4dbf5', 'KPI-DF-052: Domain shift adaptation time (ATM)', 'The time or number of episodes required for the agent to regain a specific level of performance in the shifted domain after the domain shift has occurred. It can be used to evaluate how quickly an agent can adapt to new environmental conditions.  ', array['f82e887c-f5f0-4ea9-8724-1105035c7ece']::uuid[], array['c60afe79-dbc6-4c44-893e-387adf7bc02c']::uuid[], 'CLOSED', 'ATM')
    ON CONFLICT(id) DO UPDATE SET name=EXCLUDED.name, description=EXCLUDED.description, field_ids=EXCLUDED.field_ids, scenario_ids=EXCLUDED.scenario_ids, loop=EXCLUDED.loop, queue=EXCLUDED.queue;

INSERT INTO field_definitions
        (id, key, description, agg_func, agg_weights)
        VALUES ('f82e887c-f5f0-4ea9-8724-1105035c7ece', 'primary', 'Benchmark score (MEAN of test scores)', 'MEAN', NULL)
        ON CONFLICT(id) DO UPDATE SET key=EXCLUDED.key, description=EXCLUDED.description, agg_func=EXCLUDED.agg_func, agg_weights=EXCLUDED.agg_weights;

INSERT INTO scenario_definitions
    (id, name, description, field_ids)
    VALUES ('c60afe79-dbc6-4c44-893e-387adf7bc02c', 'primary', 'Domain adaptation (DA) is a sub-field of transfer learning. DA can be defined as the capability to deploy a model trained in one or more source domains into a different target domain. We consider that the source and target domains have the same feature space. In this sense, it is important for RL based agents to have a reasonable adaptation time to a new domain which may present a slight shift from the source domain. However, the adaptation time should also consider the performance drop into its computation, as a high performance drop after the adaptation could not be tolerated.  <br/>This KPI contributes to evaluating Reliability of the AI-based assistant when dealing with real-world conditions which may be slightly different from source domain, as part of Task 4.2 evaluation objectives, and O4 main project objective. ', array['059a334c-5dc9-4880-a4bc-0fbaab4a8135']::uuid[])
    ON CONFLICT(id) DO UPDATE SET name=EXCLUDED.name, description=EXCLUDED.description, field_ids=EXCLUDED.field_ids;

INSERT INTO field_definitions
        (id, key, description, agg_func, agg_weights)
        VALUES ('059a334c-5dc9-4880-a4bc-0fbaab4a8135', 'primary', 'Scenario score (raw values)', NULL, NULL)
        ON CONFLICT(id) DO UPDATE SET key=EXCLUDED.key, description=EXCLUDED.description, agg_func=EXCLUDED.agg_func, agg_weights=EXCLUDED.agg_weights;

INSERT INTO test_definitions
    (id, name, description, field_ids, scenario_ids, loop, queue)
    VALUES ('fba17d1f-2eb7-4c06-8f77-5da14e7b875a', 'KPI-DF-053: Domain shift generalization gap (Railway)', 'Domain shift – generalization gap evaluates the absolute difference between the performance (e.g., rewards) in the training domain and the shifted domain. This metrics quantifies the extent of performance loss due to domain shift. ', array['fdeb371c-e722-49f6-9b2b-7e08784e0bda']::uuid[], array['d741cc0b-7dd9-4c2e-b23c-805b622c3878']::uuid[], 'CLOSED', 'Railway')
    ON CONFLICT(id) DO UPDATE SET name=EXCLUDED.name, description=EXCLUDED.description, field_ids=EXCLUDED.field_ids, scenario_ids=EXCLUDED.scenario_ids, loop=EXCLUDED.loop, queue=EXCLUDED.queue;

INSERT INTO field_definitions
        (id, key, description, agg_func, agg_weights)
        VALUES ('fdeb371c-e722-49f6-9b2b-7e08784e0bda', 'primary', 'Benchmark score (MEAN of test scores)', 'MEAN', NULL)
        ON CONFLICT(id) DO UPDATE SET key=EXCLUDED.key, description=EXCLUDED.description, agg_func=EXCLUDED.agg_func, agg_weights=EXCLUDED.agg_weights;

INSERT INTO scenario_definitions
    (id, name, description, field_ids)
    VALUES ('d741cc0b-7dd9-4c2e-b23c-805b622c3878', 'primary', 'The objective is to verify to which extent the AI-based assistant performance deteriorates when the target domain presents some changes in comparison to the source domain. If an agent can retain the same performance expectations in shifted domain, it will be qualified as reliable. <br/>This KPI contributes to evaluating Reliability of the AI-based assistant when dealing with real-world conditions which may be slightly different from source domain, as part of Task 4.2 evaluation objectives, and O4 main project objective. ', array['2cb1902a-32c0-4e53-a1f9-0edf1b7f5c33']::uuid[])
    ON CONFLICT(id) DO UPDATE SET name=EXCLUDED.name, description=EXCLUDED.description, field_ids=EXCLUDED.field_ids;

INSERT INTO field_definitions
        (id, key, description, agg_func, agg_weights)
        VALUES ('2cb1902a-32c0-4e53-a1f9-0edf1b7f5c33', 'primary', 'Scenario score (raw values)', NULL, NULL)
        ON CONFLICT(id) DO UPDATE SET key=EXCLUDED.key, description=EXCLUDED.description, agg_func=EXCLUDED.agg_func, agg_weights=EXCLUDED.agg_weights;

INSERT INTO test_definitions
    (id, name, description, field_ids, scenario_ids, loop, queue)
    VALUES ('17b805b2-b773-4c22-8ba9-598780e7a40d', 'KPI-DF-053: Domain shift generalization gap (Power Grid)', 'Domain shift – generalization gap evaluates the absolute difference between the performance (e.g., rewards) in the training domain and the shifted domain. This metrics quantifies the extent of performance loss due to domain shift. ', array['a7321e2a-6c39-4464-a53d-9d6352b14cb9']::uuid[], array['9fdfbb00-0754-444a-88c8-c8549e2cc6f9']::uuid[], 'CLOSED', 'PowerGrid')
    ON CONFLICT(id) DO UPDATE SET name=EXCLUDED.name, description=EXCLUDED.description, field_ids=EXCLUDED.field_ids, scenario_ids=EXCLUDED.scenario_ids, loop=EXCLUDED.loop, queue=EXCLUDED.queue;

INSERT INTO field_definitions
        (id, key, description, agg_func, agg_weights)
        VALUES ('a7321e2a-6c39-4464-a53d-9d6352b14cb9', 'primary', 'Benchmark score (MEAN of test scores)', 'MEAN', NULL)
        ON CONFLICT(id) DO UPDATE SET key=EXCLUDED.key, description=EXCLUDED.description, agg_func=EXCLUDED.agg_func, agg_weights=EXCLUDED.agg_weights;

INSERT INTO scenario_definitions
    (id, name, description, field_ids)
    VALUES ('9fdfbb00-0754-444a-88c8-c8549e2cc6f9', 'primary', 'The objective is to verify to which extent the AI-based assistant performance deteriorates when the target domain presents some changes in comparison to the source domain. If an agent can retain the same performance expectations in shifted domain, it will be qualified as reliable. <br/>This KPI contributes to evaluating Reliability of the AI-based assistant when dealing with real-world conditions which may be slightly different from source domain, as part of Task 4.2 evaluation objectives, and O4 main project objective. ', array['9977d7d9-df1b-4842-a95a-5b8ea9a334b6']::uuid[])
    ON CONFLICT(id) DO UPDATE SET name=EXCLUDED.name, description=EXCLUDED.description, field_ids=EXCLUDED.field_ids;

INSERT INTO field_definitions
        (id, key, description, agg_func, agg_weights)
        VALUES ('9977d7d9-df1b-4842-a95a-5b8ea9a334b6', 'primary', 'Scenario score (raw values)', NULL, NULL)
        ON CONFLICT(id) DO UPDATE SET key=EXCLUDED.key, description=EXCLUDED.description, agg_func=EXCLUDED.agg_func, agg_weights=EXCLUDED.agg_weights;

INSERT INTO test_definitions
    (id, name, description, field_ids, scenario_ids, loop, queue)
    VALUES ('aecbfe66-c49f-42cb-b624-d98c3d74fcb1', 'KPI-DF-053: Domain shift generalization gap (ATM)', 'Domain shift – generalization gap evaluates the absolute difference between the performance (e.g., rewards) in the training domain and the shifted domain. This metrics quantifies the extent of performance loss due to domain shift. ', array['769bd4eb-28c9-40d0-af5b-549adb14ec0e']::uuid[], array['1f8238f7-f6b6-482c-96ad-f4e0880b801d']::uuid[], 'CLOSED', 'ATM')
    ON CONFLICT(id) DO UPDATE SET name=EXCLUDED.name, description=EXCLUDED.description, field_ids=EXCLUDED.field_ids, scenario_ids=EXCLUDED.scenario_ids, loop=EXCLUDED.loop, queue=EXCLUDED.queue;

INSERT INTO field_definitions
        (id, key, description, agg_func, agg_weights)
        VALUES ('769bd4eb-28c9-40d0-af5b-549adb14ec0e', 'primary', 'Benchmark score (MEAN of test scores)', 'MEAN', NULL)
        ON CONFLICT(id) DO UPDATE SET key=EXCLUDED.key, description=EXCLUDED.description, agg_func=EXCLUDED.agg_func, agg_weights=EXCLUDED.agg_weights;

INSERT INTO scenario_definitions
    (id, name, description, field_ids)
    VALUES ('1f8238f7-f6b6-482c-96ad-f4e0880b801d', 'primary', 'The objective is to verify to which extent the AI-based assistant performance deteriorates when the target domain presents some changes in comparison to the source domain. If an agent can retain the same performance expectations in shifted domain, it will be qualified as reliable. <br/>This KPI contributes to evaluating Reliability of the AI-based assistant when dealing with real-world conditions which may be slightly different from source domain, as part of Task 4.2 evaluation objectives, and O4 main project objective. ', array['7549c53f-8756-4b98-8c52-ba9aabc30bbf']::uuid[])
    ON CONFLICT(id) DO UPDATE SET name=EXCLUDED.name, description=EXCLUDED.description, field_ids=EXCLUDED.field_ids;

INSERT INTO field_definitions
        (id, key, description, agg_func, agg_weights)
        VALUES ('7549c53f-8756-4b98-8c52-ba9aabc30bbf', 'primary', 'Scenario score (raw values)', NULL, NULL)
        ON CONFLICT(id) DO UPDATE SET key=EXCLUDED.key, description=EXCLUDED.description, agg_func=EXCLUDED.agg_func, agg_weights=EXCLUDED.agg_weights;

INSERT INTO test_definitions
    (id, name, description, field_ids, scenario_ids, loop, queue)
    VALUES ('69259fb3-bba8-4e62-9103-552b439ebaf4', 'KPI-DF-054: Domain shift out of domain detection accuracy (Railway)', 'Domain shift – out of domain detection accuracy measures the accuracy with which the agent can detect whether it is operating in a domain that is different from the one it was trained on. It is useful for systems that need to switch strategies or request human intervention when a domain shift is detected. A recent paper proposed by Nasvytis et al. (2024) introduce various approaches for detection of OOD in RL. ', array['1bdb0477-ba09-4306-93b2-519e445fd2c2']::uuid[], array['8d292cff-0409-4ec7-83fb-3034c3a4106c']::uuid[], 'CLOSED', 'Railway')
    ON CONFLICT(id) DO UPDATE SET name=EXCLUDED.name, description=EXCLUDED.description, field_ids=EXCLUDED.field_ids, scenario_ids=EXCLUDED.scenario_ids, loop=EXCLUDED.loop, queue=EXCLUDED.queue;

INSERT INTO field_definitions
        (id, key, description, agg_func, agg_weights)
        VALUES ('1bdb0477-ba09-4306-93b2-519e445fd2c2', 'primary', 'Benchmark score (MEAN of test scores)', 'MEAN', NULL)
        ON CONFLICT(id) DO UPDATE SET key=EXCLUDED.key, description=EXCLUDED.description, agg_func=EXCLUDED.agg_func, agg_weights=EXCLUDED.agg_weights;

INSERT INTO scenario_definitions
    (id, name, description, field_ids)
    VALUES ('8d292cff-0409-4ec7-83fb-3034c3a4106c', 'primary', 'It is crucial for an AI-based assistant to determine whether it can make reliable decisions in a given configuration. AI algorithms tend to be more dependable when they have been trained on similar configurations. Therefore, if the AI assistant can accurately detect out-of-domain configurations, it can seek human feedback to reduce uncertainty, leading to more adapted and reliable decisions in future scenarios. This KPI allows to determine if AI-based system could detect the shift before decision making. <br/>This KPI contributes to evaluating Reliability of the AI-based assistant when dealing with real-world conditions which may be slightly different from source domain, as part of Task 4.2 evaluation objectives, and O4 main project objective. ', array['ba239c95-b828-40bd-98c8-ba673fa4b76b']::uuid[])
    ON CONFLICT(id) DO UPDATE SET name=EXCLUDED.name, description=EXCLUDED.description, field_ids=EXCLUDED.field_ids;

INSERT INTO field_definitions
        (id, key, description, agg_func, agg_weights)
        VALUES ('ba239c95-b828-40bd-98c8-ba673fa4b76b', 'primary', 'Scenario score (raw values)', NULL, NULL)
        ON CONFLICT(id) DO UPDATE SET key=EXCLUDED.key, description=EXCLUDED.description, agg_func=EXCLUDED.agg_func, agg_weights=EXCLUDED.agg_weights;

INSERT INTO test_definitions
    (id, name, description, field_ids, scenario_ids, loop, queue)
    VALUES ('7149a428-b0a7-48f7-ba55-4d553932af41', 'KPI-DF-054: Domain shift out of domain detection accuracy (Power Grid)', 'Domain shift – out of domain detection accuracy measures the accuracy with which the agent can detect whether it is operating in a domain that is different from the one it was trained on. It is useful for systems that need to switch strategies or request human intervention when a domain shift is detected. A recent paper proposed by Nasvytis et al. (2024) introduce various approaches for detection of OOD in RL. ', array['0cdc2df8-7dd6-4e59-b9c8-01d2434ed49b']::uuid[], array['747cba94-8353-4982-9964-ba0b8361e689']::uuid[], 'CLOSED', 'PowerGrid')
    ON CONFLICT(id) DO UPDATE SET name=EXCLUDED.name, description=EXCLUDED.description, field_ids=EXCLUDED.field_ids, scenario_ids=EXCLUDED.scenario_ids, loop=EXCLUDED.loop, queue=EXCLUDED.queue;

INSERT INTO field_definitions
        (id, key, description, agg_func, agg_weights)
        VALUES ('0cdc2df8-7dd6-4e59-b9c8-01d2434ed49b', 'primary', 'Benchmark score (MEAN of test scores)', 'MEAN', NULL)
        ON CONFLICT(id) DO UPDATE SET key=EXCLUDED.key, description=EXCLUDED.description, agg_func=EXCLUDED.agg_func, agg_weights=EXCLUDED.agg_weights;

INSERT INTO scenario_definitions
    (id, name, description, field_ids)
    VALUES ('747cba94-8353-4982-9964-ba0b8361e689', 'primary', 'It is crucial for an AI-based assistant to determine whether it can make reliable decisions in a given configuration. AI algorithms tend to be more dependable when they have been trained on similar configurations. Therefore, if the AI assistant can accurately detect out-of-domain configurations, it can seek human feedback to reduce uncertainty, leading to more adapted and reliable decisions in future scenarios. This KPI allows to determine if AI-based system could detect the shift before decision making. <br/>This KPI contributes to evaluating Reliability of the AI-based assistant when dealing with real-world conditions which may be slightly different from source domain, as part of Task 4.2 evaluation objectives, and O4 main project objective. ', array['92ce6fe6-7144-42b1-a378-7b00ece4e84d']::uuid[])
    ON CONFLICT(id) DO UPDATE SET name=EXCLUDED.name, description=EXCLUDED.description, field_ids=EXCLUDED.field_ids;

INSERT INTO field_definitions
        (id, key, description, agg_func, agg_weights)
        VALUES ('92ce6fe6-7144-42b1-a378-7b00ece4e84d', 'primary', 'Scenario score (raw values)', NULL, NULL)
        ON CONFLICT(id) DO UPDATE SET key=EXCLUDED.key, description=EXCLUDED.description, agg_func=EXCLUDED.agg_func, agg_weights=EXCLUDED.agg_weights;

INSERT INTO test_definitions
    (id, name, description, field_ids, scenario_ids, loop, queue)
    VALUES ('a34741a1-d279-4b5b-a327-2a0f94bea125', 'KPI-DF-054: Domain shift out of domain detection accuracy (ATM)', 'Domain shift – out of domain detection accuracy measures the accuracy with which the agent can detect whether it is operating in a domain that is different from the one it was trained on. It is useful for systems that need to switch strategies or request human intervention when a domain shift is detected. A recent paper proposed by Nasvytis et al. (2024) introduce various approaches for detection of OOD in RL. ', array['adb05676-e33f-45da-a3bc-370a0524d1ee']::uuid[], array['5b92361c-927e-4aaa-83c5-4413989282a2']::uuid[], 'CLOSED', 'ATM')
    ON CONFLICT(id) DO UPDATE SET name=EXCLUDED.name, description=EXCLUDED.description, field_ids=EXCLUDED.field_ids, scenario_ids=EXCLUDED.scenario_ids, loop=EXCLUDED.loop, queue=EXCLUDED.queue;

INSERT INTO field_definitions
        (id, key, description, agg_func, agg_weights)
        VALUES ('adb05676-e33f-45da-a3bc-370a0524d1ee', 'primary', 'Benchmark score (MEAN of test scores)', 'MEAN', NULL)
        ON CONFLICT(id) DO UPDATE SET key=EXCLUDED.key, description=EXCLUDED.description, agg_func=EXCLUDED.agg_func, agg_weights=EXCLUDED.agg_weights;

INSERT INTO scenario_definitions
    (id, name, description, field_ids)
    VALUES ('5b92361c-927e-4aaa-83c5-4413989282a2', 'primary', 'It is crucial for an AI-based assistant to determine whether it can make reliable decisions in a given configuration. AI algorithms tend to be more dependable when they have been trained on similar configurations. Therefore, if the AI assistant can accurately detect out-of-domain configurations, it can seek human feedback to reduce uncertainty, leading to more adapted and reliable decisions in future scenarios. This KPI allows to determine if AI-based system could detect the shift before decision making. <br/>This KPI contributes to evaluating Reliability of the AI-based assistant when dealing with real-world conditions which may be slightly different from source domain, as part of Task 4.2 evaluation objectives, and O4 main project objective. ', array['57e71aab-13fd-475e-ab2c-5d6feee0ba84']::uuid[])
    ON CONFLICT(id) DO UPDATE SET name=EXCLUDED.name, description=EXCLUDED.description, field_ids=EXCLUDED.field_ids;

INSERT INTO field_definitions
        (id, key, description, agg_func, agg_weights)
        VALUES ('57e71aab-13fd-475e-ab2c-5d6feee0ba84', 'primary', 'Scenario score (raw values)', NULL, NULL)
        ON CONFLICT(id) DO UPDATE SET key=EXCLUDED.key, description=EXCLUDED.description, agg_func=EXCLUDED.agg_func, agg_weights=EXCLUDED.agg_weights;

INSERT INTO test_definitions
    (id, name, description, field_ids, scenario_ids, loop, queue)
    VALUES ('dce1c0e9-f2ae-4faa-a6b3-76d037c082d0', 'KPI-DF-055: Domain shift policy robustness (Railway)', 'Domain shift – Policy robustness KPI calculates a ratio of the performance in the shifted domain to the performance in the original domain. A score close to 1 indicates high robustness, while a lower score indicates reduced performance due to the domain shift. It can be used to assess the generalization of a policy learned in a simulated environment when applied to a real-world scenario. ', array['a8bd1701-c2c9-43da-a199-bcf6c0c3a6dc']::uuid[], array['4b42d9b8-9f27-4247-8bef-47ad3ce3a978']::uuid[], 'CLOSED', 'Railway')
    ON CONFLICT(id) DO UPDATE SET name=EXCLUDED.name, description=EXCLUDED.description, field_ids=EXCLUDED.field_ids, scenario_ids=EXCLUDED.scenario_ids, loop=EXCLUDED.loop, queue=EXCLUDED.queue;

INSERT INTO field_definitions
        (id, key, description, agg_func, agg_weights)
        VALUES ('a8bd1701-c2c9-43da-a199-bcf6c0c3a6dc', 'primary', 'Benchmark score (MEAN of test scores)', 'MEAN', NULL)
        ON CONFLICT(id) DO UPDATE SET key=EXCLUDED.key, description=EXCLUDED.description, agg_func=EXCLUDED.agg_func, agg_weights=EXCLUDED.agg_weights;

INSERT INTO scenario_definitions
    (id, name, description, field_ids)
    VALUES ('4b42d9b8-9f27-4247-8bef-47ad3ce3a978', 'primary', 'To evaluate the robustness and generalization capability of a policy by measuring its performance ratio between a shifted domain and the original domain, ensuring that policies trained in simulated environments maintain high effectiveness when applied to real-world scenarios. <br/>This KPI contributes to evaluating Reliability of the AI-based assistant when dealing with real-world conditions which may be slightly different from source domain, as part of Task 4.2 evaluation objectives, and O4 main project objective. ', array['c4b39f46-f236-4521-abb8-b460a7893156']::uuid[])
    ON CONFLICT(id) DO UPDATE SET name=EXCLUDED.name, description=EXCLUDED.description, field_ids=EXCLUDED.field_ids;

INSERT INTO field_definitions
        (id, key, description, agg_func, agg_weights)
        VALUES ('c4b39f46-f236-4521-abb8-b460a7893156', 'primary', 'Scenario score (raw values)', NULL, NULL)
        ON CONFLICT(id) DO UPDATE SET key=EXCLUDED.key, description=EXCLUDED.description, agg_func=EXCLUDED.agg_func, agg_weights=EXCLUDED.agg_weights;

INSERT INTO test_definitions
    (id, name, description, field_ids, scenario_ids, loop, queue)
    VALUES ('115d6c9d-c0d1-423d-b74e-140f9e5608c5', 'KPI-DF-055: Domain shift policy robustness (Power Grid)', 'Domain shift – Policy robustness KPI calculates a ratio of the performance in the shifted domain to the performance in the original domain. A score close to 1 indicates high robustness, while a lower score indicates reduced performance due to the domain shift. It can be used to assess the generalization of a policy learned in a simulated environment when applied to a real-world scenario. ', array['8c9d7ce4-0162-472d-88fb-2c19b811ad34']::uuid[], array['f393653b-850e-4c17-bed1-7fe1ca51c854']::uuid[], 'CLOSED', 'PowerGrid')
    ON CONFLICT(id) DO UPDATE SET name=EXCLUDED.name, description=EXCLUDED.description, field_ids=EXCLUDED.field_ids, scenario_ids=EXCLUDED.scenario_ids, loop=EXCLUDED.loop, queue=EXCLUDED.queue;

INSERT INTO field_definitions
        (id, key, description, agg_func, agg_weights)
        VALUES ('8c9d7ce4-0162-472d-88fb-2c19b811ad34', 'primary', 'Benchmark score (MEAN of test scores)', 'MEAN', NULL)
        ON CONFLICT(id) DO UPDATE SET key=EXCLUDED.key, description=EXCLUDED.description, agg_func=EXCLUDED.agg_func, agg_weights=EXCLUDED.agg_weights;

INSERT INTO scenario_definitions
    (id, name, description, field_ids)
    VALUES ('f393653b-850e-4c17-bed1-7fe1ca51c854', 'primary', 'To evaluate the robustness and generalization capability of a policy by measuring its performance ratio between a shifted domain and the original domain, ensuring that policies trained in simulated environments maintain high effectiveness when applied to real-world scenarios. <br/>This KPI contributes to evaluating Reliability of the AI-based assistant when dealing with real-world conditions which may be slightly different from source domain, as part of Task 4.2 evaluation objectives, and O4 main project objective. ', array['fb740fbf-675f-4f87-b280-1fcdfedf19ea']::uuid[])
    ON CONFLICT(id) DO UPDATE SET name=EXCLUDED.name, description=EXCLUDED.description, field_ids=EXCLUDED.field_ids;

INSERT INTO field_definitions
        (id, key, description, agg_func, agg_weights)
        VALUES ('fb740fbf-675f-4f87-b280-1fcdfedf19ea', 'primary', 'Scenario score (raw values)', NULL, NULL)
        ON CONFLICT(id) DO UPDATE SET key=EXCLUDED.key, description=EXCLUDED.description, agg_func=EXCLUDED.agg_func, agg_weights=EXCLUDED.agg_weights;

INSERT INTO test_definitions
    (id, name, description, field_ids, scenario_ids, loop, queue)
    VALUES ('a3adb18d-3b44-4498-8c2c-728d5ff40248', 'KPI-DF-055: Domain shift policy robustness (ATM)', 'Domain shift – Policy robustness KPI calculates a ratio of the performance in the shifted domain to the performance in the original domain. A score close to 1 indicates high robustness, while a lower score indicates reduced performance due to the domain shift. It can be used to assess the generalization of a policy learned in a simulated environment when applied to a real-world scenario. ', array['1088ae36-888b-443d-af8c-556fc8da4ae4']::uuid[], array['33e32b92-51a9-4531-8b5d-8655b758a958']::uuid[], 'CLOSED', 'ATM')
    ON CONFLICT(id) DO UPDATE SET name=EXCLUDED.name, description=EXCLUDED.description, field_ids=EXCLUDED.field_ids, scenario_ids=EXCLUDED.scenario_ids, loop=EXCLUDED.loop, queue=EXCLUDED.queue;

INSERT INTO field_definitions
        (id, key, description, agg_func, agg_weights)
        VALUES ('1088ae36-888b-443d-af8c-556fc8da4ae4', 'primary', 'Benchmark score (MEAN of test scores)', 'MEAN', NULL)
        ON CONFLICT(id) DO UPDATE SET key=EXCLUDED.key, description=EXCLUDED.description, agg_func=EXCLUDED.agg_func, agg_weights=EXCLUDED.agg_weights;

INSERT INTO scenario_definitions
    (id, name, description, field_ids)
    VALUES ('33e32b92-51a9-4531-8b5d-8655b758a958', 'primary', 'To evaluate the robustness and generalization capability of a policy by measuring its performance ratio between a shifted domain and the original domain, ensuring that policies trained in simulated environments maintain high effectiveness when applied to real-world scenarios. <br/>This KPI contributes to evaluating Reliability of the AI-based assistant when dealing with real-world conditions which may be slightly different from source domain, as part of Task 4.2 evaluation objectives, and O4 main project objective. ', array['ce3d2ed0-cb42-40e4-95e9-8a08b0eb2dfe']::uuid[])
    ON CONFLICT(id) DO UPDATE SET name=EXCLUDED.name, description=EXCLUDED.description, field_ids=EXCLUDED.field_ids;

INSERT INTO field_definitions
        (id, key, description, agg_func, agg_weights)
        VALUES ('ce3d2ed0-cb42-40e4-95e9-8a08b0eb2dfe', 'primary', 'Scenario score (raw values)', NULL, NULL)
        ON CONFLICT(id) DO UPDATE SET key=EXCLUDED.key, description=EXCLUDED.description, agg_func=EXCLUDED.agg_func, agg_weights=EXCLUDED.agg_weights;

INSERT INTO test_definitions
    (id, name, description, field_ids, scenario_ids, loop, queue)
    VALUES ('03e1fcaf-a933-4ad1-abf2-5541574298a2', 'KPI-DF-056: Domain shift robustness to domain parameters (Railway)', 'Robustness to domain parameters KPI evaluates the sensitivity of the agent’s performance (e.g., Reward) to changes in specific domain parameters (e.g., generators type including renewables in power grid domain). It helps to identify which environmental factors most affect the agent’s performance. ', array['bcdce9ba-dd27-4b16-b749-7229c7674a4e']::uuid[], array['2238fa19-e337-49ce-a3b3-08abf85f1453']::uuid[], 'CLOSED', 'Railway')
    ON CONFLICT(id) DO UPDATE SET name=EXCLUDED.name, description=EXCLUDED.description, field_ids=EXCLUDED.field_ids, scenario_ids=EXCLUDED.scenario_ids, loop=EXCLUDED.loop, queue=EXCLUDED.queue;

INSERT INTO field_definitions
        (id, key, description, agg_func, agg_weights)
        VALUES ('bcdce9ba-dd27-4b16-b749-7229c7674a4e', 'primary', 'Benchmark score (MEAN of test scores)', 'MEAN', NULL)
        ON CONFLICT(id) DO UPDATE SET key=EXCLUDED.key, description=EXCLUDED.description, agg_func=EXCLUDED.agg_func, agg_weights=EXCLUDED.agg_weights;

INSERT INTO scenario_definitions
    (id, name, description, field_ids)
    VALUES ('2238fa19-e337-49ce-a3b3-08abf85f1453', 'primary', 'To assess the sensitivity of the agent''s performance to variations in domain parameters, identifying key environmental factors that significantly impact the agent’s effectiveness and robustness, thereby guiding improvements in adaptability and resilience across different scenarios. <br/>This KPI contributes to evaluating Reliability of the AI-based assistant when dealing with real-world conditions which may be slightly different from source domain, as part of Task 4.2 evaluation objectives, and O4 main project objective. ', array['8c63f8fe-dfc7-4b94-944b-91edcc2d6762']::uuid[])
    ON CONFLICT(id) DO UPDATE SET name=EXCLUDED.name, description=EXCLUDED.description, field_ids=EXCLUDED.field_ids;

INSERT INTO field_definitions
        (id, key, description, agg_func, agg_weights)
        VALUES ('8c63f8fe-dfc7-4b94-944b-91edcc2d6762', 'primary', 'Scenario score (raw values)', NULL, NULL)
        ON CONFLICT(id) DO UPDATE SET key=EXCLUDED.key, description=EXCLUDED.description, agg_func=EXCLUDED.agg_func, agg_weights=EXCLUDED.agg_weights;

INSERT INTO test_definitions
    (id, name, description, field_ids, scenario_ids, loop, queue)
    VALUES ('07f8625d-c39a-4fd1-9633-012f342352e9', 'KPI-DF-056: Domain shift robustness to domain parameters (Power Grid)', 'Robustness to domain parameters KPI evaluates the sensitivity of the agent’s performance (e.g., Reward) to changes in specific domain parameters (e.g., generators type including renewables in power grid domain). It helps to identify which environmental factors most affect the agent’s performance. ', array['26c6119e-12dc-44cd-b862-8f95f1420fa0']::uuid[], array['82aed30d-9b28-4b8f-ba9a-fd05d6defec6']::uuid[], 'CLOSED', 'PowerGrid')
    ON CONFLICT(id) DO UPDATE SET name=EXCLUDED.name, description=EXCLUDED.description, field_ids=EXCLUDED.field_ids, scenario_ids=EXCLUDED.scenario_ids, loop=EXCLUDED.loop, queue=EXCLUDED.queue;

INSERT INTO field_definitions
        (id, key, description, agg_func, agg_weights)
        VALUES ('26c6119e-12dc-44cd-b862-8f95f1420fa0', 'primary', 'Benchmark score (MEAN of test scores)', 'MEAN', NULL)
        ON CONFLICT(id) DO UPDATE SET key=EXCLUDED.key, description=EXCLUDED.description, agg_func=EXCLUDED.agg_func, agg_weights=EXCLUDED.agg_weights;

INSERT INTO scenario_definitions
    (id, name, description, field_ids)
    VALUES ('82aed30d-9b28-4b8f-ba9a-fd05d6defec6', 'primary', 'To assess the sensitivity of the agent''s performance to variations in domain parameters, identifying key environmental factors that significantly impact the agent’s effectiveness and robustness, thereby guiding improvements in adaptability and resilience across different scenarios. <br/>This KPI contributes to evaluating Reliability of the AI-based assistant when dealing with real-world conditions which may be slightly different from source domain, as part of Task 4.2 evaluation objectives, and O4 main project objective. ', array['a2a276a5-d9ce-4d35-bc53-8b5775e01c7f']::uuid[])
    ON CONFLICT(id) DO UPDATE SET name=EXCLUDED.name, description=EXCLUDED.description, field_ids=EXCLUDED.field_ids;

INSERT INTO field_definitions
        (id, key, description, agg_func, agg_weights)
        VALUES ('a2a276a5-d9ce-4d35-bc53-8b5775e01c7f', 'primary', 'Scenario score (raw values)', NULL, NULL)
        ON CONFLICT(id) DO UPDATE SET key=EXCLUDED.key, description=EXCLUDED.description, agg_func=EXCLUDED.agg_func, agg_weights=EXCLUDED.agg_weights;

INSERT INTO test_definitions
    (id, name, description, field_ids, scenario_ids, loop, queue)
    VALUES ('defac2f8-5b3b-4de9-ae1b-8e2f74380257', 'KPI-DF-056: Domain shift robustness to domain parameters (ATM)', 'Robustness to domain parameters KPI evaluates the sensitivity of the agent’s performance (e.g., Reward) to changes in specific domain parameters (e.g., generators type including renewables in power grid domain). It helps to identify which environmental factors most affect the agent’s performance. ', array['2834a05b-bf8d-4231-9b1d-7797276bf304']::uuid[], array['3f521f00-d5f7-4883-923a-1ec2a3022dcb']::uuid[], 'CLOSED', 'ATM')
    ON CONFLICT(id) DO UPDATE SET name=EXCLUDED.name, description=EXCLUDED.description, field_ids=EXCLUDED.field_ids, scenario_ids=EXCLUDED.scenario_ids, loop=EXCLUDED.loop, queue=EXCLUDED.queue;

INSERT INTO field_definitions
        (id, key, description, agg_func, agg_weights)
        VALUES ('2834a05b-bf8d-4231-9b1d-7797276bf304', 'primary', 'Benchmark score (MEAN of test scores)', 'MEAN', NULL)
        ON CONFLICT(id) DO UPDATE SET key=EXCLUDED.key, description=EXCLUDED.description, agg_func=EXCLUDED.agg_func, agg_weights=EXCLUDED.agg_weights;

INSERT INTO scenario_definitions
    (id, name, description, field_ids)
    VALUES ('3f521f00-d5f7-4883-923a-1ec2a3022dcb', 'primary', 'To assess the sensitivity of the agent''s performance to variations in domain parameters, identifying key environmental factors that significantly impact the agent’s effectiveness and robustness, thereby guiding improvements in adaptability and resilience across different scenarios. <br/>This KPI contributes to evaluating Reliability of the AI-based assistant when dealing with real-world conditions which may be slightly different from source domain, as part of Task 4.2 evaluation objectives, and O4 main project objective. ', array['11395763-2f0e-477c-a790-244757521cd8']::uuid[])
    ON CONFLICT(id) DO UPDATE SET name=EXCLUDED.name, description=EXCLUDED.description, field_ids=EXCLUDED.field_ids;

INSERT INTO field_definitions
        (id, key, description, agg_func, agg_weights)
        VALUES ('11395763-2f0e-477c-a790-244757521cd8', 'primary', 'Scenario score (raw values)', NULL, NULL)
        ON CONFLICT(id) DO UPDATE SET key=EXCLUDED.key, description=EXCLUDED.description, agg_func=EXCLUDED.agg_func, agg_weights=EXCLUDED.agg_weights;

INSERT INTO test_definitions
    (id, name, description, field_ids, scenario_ids, loop, queue)
    VALUES ('d795c7bd-f8be-43c2-ae6e-a931194d3fc5', 'KPI-DF-057: Domain shift success rate drop (Railway)', 'Domain shift – success rate drop KPI measures drop in the performance of the agent after the occurrence of a shift in the source domain. ', array['7d368ebc-67ab-44f0-96c6-d13324da9582']::uuid[], array['5d017ca4-f062-44c9-821c-31f85928903a']::uuid[], 'CLOSED', 'Railway')
    ON CONFLICT(id) DO UPDATE SET name=EXCLUDED.name, description=EXCLUDED.description, field_ids=EXCLUDED.field_ids, scenario_ids=EXCLUDED.scenario_ids, loop=EXCLUDED.loop, queue=EXCLUDED.queue;

INSERT INTO field_definitions
        (id, key, description, agg_func, agg_weights)
        VALUES ('7d368ebc-67ab-44f0-96c6-d13324da9582', 'primary', 'Benchmark score (MEAN of test scores)', 'MEAN', NULL)
        ON CONFLICT(id) DO UPDATE SET key=EXCLUDED.key, description=EXCLUDED.description, agg_func=EXCLUDED.agg_func, agg_weights=EXCLUDED.agg_weights;

INSERT INTO scenario_definitions
    (id, name, description, field_ids)
    VALUES ('5d017ca4-f062-44c9-821c-31f85928903a', 'primary', 'To quantify the decline in the agent''s performance after a shift in the source domain, providing insights into the agent''s ability to maintain effectiveness under altered conditions. This KPI helps in evaluating the agent''s resilience, adaptability, and the robustness of its training, facilitating the identification of weaknesses and the development of strategies to improve its performance in dynamic or unpredictable environments. <br/>This KPI contributes to evaluating Reliability of the AI-based assistant when dealing with real-world conditions which may be slightly different from source domain, as part of Task 4.2 evaluation objectives, and O4 main project objective. ', array['d71a4ce5-d954-4404-98a8-2f44df3c48eb']::uuid[])
    ON CONFLICT(id) DO UPDATE SET name=EXCLUDED.name, description=EXCLUDED.description, field_ids=EXCLUDED.field_ids;

INSERT INTO field_definitions
        (id, key, description, agg_func, agg_weights)
        VALUES ('d71a4ce5-d954-4404-98a8-2f44df3c48eb', 'primary', 'Scenario score (raw values)', NULL, NULL)
        ON CONFLICT(id) DO UPDATE SET key=EXCLUDED.key, description=EXCLUDED.description, agg_func=EXCLUDED.agg_func, agg_weights=EXCLUDED.agg_weights;

INSERT INTO test_definitions
    (id, name, description, field_ids, scenario_ids, loop, queue)
    VALUES ('c5e4f893-4302-47e8-98d6-b5fbcb10963a', 'KPI-DF-057: Domain shift success rate drop (Power Grid)', 'Domain shift – success rate drop KPI measures drop in the performance of the agent after the occurrence of a shift in the source domain. ', array['123c3ec2-1cf5-4d73-b86e-7ff4d1671d80']::uuid[], array['4d2b00cd-447a-4c7e-8cab-863f0402cb67']::uuid[], 'CLOSED', 'PowerGrid')
    ON CONFLICT(id) DO UPDATE SET name=EXCLUDED.name, description=EXCLUDED.description, field_ids=EXCLUDED.field_ids, scenario_ids=EXCLUDED.scenario_ids, loop=EXCLUDED.loop, queue=EXCLUDED.queue;

INSERT INTO field_definitions
        (id, key, description, agg_func, agg_weights)
        VALUES ('123c3ec2-1cf5-4d73-b86e-7ff4d1671d80', 'primary', 'Benchmark score (MEAN of test scores)', 'MEAN', NULL)
        ON CONFLICT(id) DO UPDATE SET key=EXCLUDED.key, description=EXCLUDED.description, agg_func=EXCLUDED.agg_func, agg_weights=EXCLUDED.agg_weights;

INSERT INTO scenario_definitions
    (id, name, description, field_ids)
    VALUES ('4d2b00cd-447a-4c7e-8cab-863f0402cb67', 'primary', 'To quantify the decline in the agent''s performance after a shift in the source domain, providing insights into the agent''s ability to maintain effectiveness under altered conditions. This KPI helps in evaluating the agent''s resilience, adaptability, and the robustness of its training, facilitating the identification of weaknesses and the development of strategies to improve its performance in dynamic or unpredictable environments. <br/>This KPI contributes to evaluating Reliability of the AI-based assistant when dealing with real-world conditions which may be slightly different from source domain, as part of Task 4.2 evaluation objectives, and O4 main project objective. ', array['aa4a6491-cb70-4522-a1d4-c416c8efafb0']::uuid[])
    ON CONFLICT(id) DO UPDATE SET name=EXCLUDED.name, description=EXCLUDED.description, field_ids=EXCLUDED.field_ids;

INSERT INTO field_definitions
        (id, key, description, agg_func, agg_weights)
        VALUES ('aa4a6491-cb70-4522-a1d4-c416c8efafb0', 'primary', 'Scenario score (raw values)', NULL, NULL)
        ON CONFLICT(id) DO UPDATE SET key=EXCLUDED.key, description=EXCLUDED.description, agg_func=EXCLUDED.agg_func, agg_weights=EXCLUDED.agg_weights;

INSERT INTO test_definitions
    (id, name, description, field_ids, scenario_ids, loop, queue)
    VALUES ('e75c588d-276f-4c6f-a329-90d570da9b67', 'KPI-DF-057: Domain shift success rate drop (ATM)', 'Domain shift – success rate drop KPI measures drop in the performance of the agent after the occurrence of a shift in the source domain. ', array['0a594511-3eab-4e45-818b-901bca21c1db']::uuid[], array['3ba0619c-8073-4e94-9c34-c3d5e17bcde8']::uuid[], 'CLOSED', 'ATM')
    ON CONFLICT(id) DO UPDATE SET name=EXCLUDED.name, description=EXCLUDED.description, field_ids=EXCLUDED.field_ids, scenario_ids=EXCLUDED.scenario_ids, loop=EXCLUDED.loop, queue=EXCLUDED.queue;

INSERT INTO field_definitions
        (id, key, description, agg_func, agg_weights)
        VALUES ('0a594511-3eab-4e45-818b-901bca21c1db', 'primary', 'Benchmark score (MEAN of test scores)', 'MEAN', NULL)
        ON CONFLICT(id) DO UPDATE SET key=EXCLUDED.key, description=EXCLUDED.description, agg_func=EXCLUDED.agg_func, agg_weights=EXCLUDED.agg_weights;

INSERT INTO scenario_definitions
    (id, name, description, field_ids)
    VALUES ('3ba0619c-8073-4e94-9c34-c3d5e17bcde8', 'primary', 'To quantify the decline in the agent''s performance after a shift in the source domain, providing insights into the agent''s ability to maintain effectiveness under altered conditions. This KPI helps in evaluating the agent''s resilience, adaptability, and the robustness of its training, facilitating the identification of weaknesses and the development of strategies to improve its performance in dynamic or unpredictable environments. <br/>This KPI contributes to evaluating Reliability of the AI-based assistant when dealing with real-world conditions which may be slightly different from source domain, as part of Task 4.2 evaluation objectives, and O4 main project objective. ', array['e4db242e-60e9-4db0-bd6b-b14a4eb1ff65']::uuid[])
    ON CONFLICT(id) DO UPDATE SET name=EXCLUDED.name, description=EXCLUDED.description, field_ids=EXCLUDED.field_ids;

INSERT INTO field_definitions
        (id, key, description, agg_func, agg_weights)
        VALUES ('e4db242e-60e9-4db0-bd6b-b14a4eb1ff65', 'primary', 'Scenario score (raw values)', NULL, NULL)
        ON CONFLICT(id) DO UPDATE SET key=EXCLUDED.key, description=EXCLUDED.description, agg_func=EXCLUDED.agg_func, agg_weights=EXCLUDED.agg_weights;

INSERT INTO test_definitions
    (id, name, description, field_ids, scenario_ids, loop, queue)
    VALUES ('511f2ab0-da90-4d55-a23f-af5eda0baf7d', 'KPI-DF-090: Domain shift forgetting rate (Railway)', 'The rate at which an agent forgets its performance in the original domain after being exposed to a shifted domain. It helps to measure the extent to which learning in the new domain negatively impacts the agent’s ability to perform in the original domain. ', array['dc6c2dca-d4c2-48d0-9f75-0df01de53c54']::uuid[], array['cf7bb259-0ad4-4454-a9c8-eb8add0bec57']::uuid[], 'CLOSED', 'Railway')
    ON CONFLICT(id) DO UPDATE SET name=EXCLUDED.name, description=EXCLUDED.description, field_ids=EXCLUDED.field_ids, scenario_ids=EXCLUDED.scenario_ids, loop=EXCLUDED.loop, queue=EXCLUDED.queue;

INSERT INTO field_definitions
        (id, key, description, agg_func, agg_weights)
        VALUES ('dc6c2dca-d4c2-48d0-9f75-0df01de53c54', 'primary', 'Benchmark score (MEAN of test scores)', 'MEAN', NULL)
        ON CONFLICT(id) DO UPDATE SET key=EXCLUDED.key, description=EXCLUDED.description, agg_func=EXCLUDED.agg_func, agg_weights=EXCLUDED.agg_weights;

INSERT INTO scenario_definitions
    (id, name, description, field_ids)
    VALUES ('cf7bb259-0ad4-4454-a9c8-eb8add0bec57', 'primary', 'The objective of computing the Forgetting Rate in Domain Shift is to quantify the decline in an agent''s performance on the original domain after being trained or exposed to a shifted domain. This metric helps assess the extent of negative transfer, ensuring that adaptation to the new domain does not excessively degrade prior knowledge. A higher forgetting rate indicates a more significant loss of previously learned knowledge due to domain shift. <br/>This KPI contributes to evaluating Reliability of the AI-based assistant when dealing with real-world conditions which may be slightly different from source domain, as part of Task 4.2 evaluation objectives, and O4 main project objective. ', array['237806e9-50d9-4feb-a52d-e6359984b0e0']::uuid[])
    ON CONFLICT(id) DO UPDATE SET name=EXCLUDED.name, description=EXCLUDED.description, field_ids=EXCLUDED.field_ids;

INSERT INTO field_definitions
        (id, key, description, agg_func, agg_weights)
        VALUES ('237806e9-50d9-4feb-a52d-e6359984b0e0', 'primary', 'Scenario score (raw values)', NULL, NULL)
        ON CONFLICT(id) DO UPDATE SET key=EXCLUDED.key, description=EXCLUDED.description, agg_func=EXCLUDED.agg_func, agg_weights=EXCLUDED.agg_weights;

INSERT INTO test_definitions
    (id, name, description, field_ids, scenario_ids, loop, queue)
    VALUES ('648afbec-80ad-4490-869f-6c3d8088d50f', 'KPI-DF-090: Domain shift forgetting rate (Power Grid)', 'The rate at which an agent forgets its performance in the original domain after being exposed to a shifted domain. It helps to measure the extent to which learning in the new domain negatively impacts the agent’s ability to perform in the original domain. ', array['42c553a8-37f1-4abe-a0fd-14daec0078e0']::uuid[], array['99dfde1e-2798-4741-b3eb-610a3e847bc8']::uuid[], 'CLOSED', 'PowerGrid')
    ON CONFLICT(id) DO UPDATE SET name=EXCLUDED.name, description=EXCLUDED.description, field_ids=EXCLUDED.field_ids, scenario_ids=EXCLUDED.scenario_ids, loop=EXCLUDED.loop, queue=EXCLUDED.queue;

INSERT INTO field_definitions
        (id, key, description, agg_func, agg_weights)
        VALUES ('42c553a8-37f1-4abe-a0fd-14daec0078e0', 'primary', 'Benchmark score (MEAN of test scores)', 'MEAN', NULL)
        ON CONFLICT(id) DO UPDATE SET key=EXCLUDED.key, description=EXCLUDED.description, agg_func=EXCLUDED.agg_func, agg_weights=EXCLUDED.agg_weights;

INSERT INTO scenario_definitions
    (id, name, description, field_ids)
    VALUES ('99dfde1e-2798-4741-b3eb-610a3e847bc8', 'primary', 'The objective of computing the Forgetting Rate in Domain Shift is to quantify the decline in an agent''s performance on the original domain after being trained or exposed to a shifted domain. This metric helps assess the extent of negative transfer, ensuring that adaptation to the new domain does not excessively degrade prior knowledge. A higher forgetting rate indicates a more significant loss of previously learned knowledge due to domain shift. <br/>This KPI contributes to evaluating Reliability of the AI-based assistant when dealing with real-world conditions which may be slightly different from source domain, as part of Task 4.2 evaluation objectives, and O4 main project objective. ', array['47765b19-9357-47e2-8e9d-a97e86807170']::uuid[])
    ON CONFLICT(id) DO UPDATE SET name=EXCLUDED.name, description=EXCLUDED.description, field_ids=EXCLUDED.field_ids;

INSERT INTO field_definitions
        (id, key, description, agg_func, agg_weights)
        VALUES ('47765b19-9357-47e2-8e9d-a97e86807170', 'primary', 'Scenario score (raw values)', NULL, NULL)
        ON CONFLICT(id) DO UPDATE SET key=EXCLUDED.key, description=EXCLUDED.description, agg_func=EXCLUDED.agg_func, agg_weights=EXCLUDED.agg_weights;

INSERT INTO test_definitions
    (id, name, description, field_ids, scenario_ids, loop, queue)
    VALUES ('9c6f7e45-b966-4b55-8315-790577683344', 'KPI-DF-090: Domain shift forgetting rate (ATM)', 'The rate at which an agent forgets its performance in the original domain after being exposed to a shifted domain. It helps to measure the extent to which learning in the new domain negatively impacts the agent’s ability to perform in the original domain. ', array['9517152b-7271-4aaf-8df8-b2cbdc5d5223']::uuid[], array['3c03cc5e-f94e-4573-90a3-924b217442e6']::uuid[], 'CLOSED', 'ATM')
    ON CONFLICT(id) DO UPDATE SET name=EXCLUDED.name, description=EXCLUDED.description, field_ids=EXCLUDED.field_ids, scenario_ids=EXCLUDED.scenario_ids, loop=EXCLUDED.loop, queue=EXCLUDED.queue;

INSERT INTO field_definitions
        (id, key, description, agg_func, agg_weights)
        VALUES ('9517152b-7271-4aaf-8df8-b2cbdc5d5223', 'primary', 'Benchmark score (MEAN of test scores)', 'MEAN', NULL)
        ON CONFLICT(id) DO UPDATE SET key=EXCLUDED.key, description=EXCLUDED.description, agg_func=EXCLUDED.agg_func, agg_weights=EXCLUDED.agg_weights;

INSERT INTO scenario_definitions
    (id, name, description, field_ids)
    VALUES ('3c03cc5e-f94e-4573-90a3-924b217442e6', 'primary', 'The objective of computing the Forgetting Rate in Domain Shift is to quantify the decline in an agent''s performance on the original domain after being trained or exposed to a shifted domain. This metric helps assess the extent of negative transfer, ensuring that adaptation to the new domain does not excessively degrade prior knowledge. A higher forgetting rate indicates a more significant loss of previously learned knowledge due to domain shift. <br/>This KPI contributes to evaluating Reliability of the AI-based assistant when dealing with real-world conditions which may be slightly different from source domain, as part of Task 4.2 evaluation objectives, and O4 main project objective. ', array['ddde7763-4544-46dd-b2fa-36e340dfc58c']::uuid[])
    ON CONFLICT(id) DO UPDATE SET name=EXCLUDED.name, description=EXCLUDED.description, field_ids=EXCLUDED.field_ids;

INSERT INTO field_definitions
        (id, key, description, agg_func, agg_weights)
        VALUES ('ddde7763-4544-46dd-b2fa-36e340dfc58c', 'primary', 'Scenario score (raw values)', NULL, NULL)
        ON CONFLICT(id) DO UPDATE SET key=EXCLUDED.key, description=EXCLUDED.description, agg_func=EXCLUDED.agg_func, agg_weights=EXCLUDED.agg_weights;

INSERT INTO benchmark_definitions
    (id, name, description, field_ids, test_ids)
    VALUES ('3810191b-8cfd-4b03-86b2-f7e530aab30d', 'Robustness', 'Robustness', array['e0895e55-a5d9-46f2-9c95-9389baf25752']::uuid[], array['1cbf44c3-0c82-4f9e-9857-c7c1d96d3ab9', '75cc9343-9371-4eb1-9613-22a26c67fc00', '07881948-f5e0-4772-83c9-3ca517ac245f', 'a94c858e-4bc3-4d67-bd78-5c81506e39f7', '1cbb7783-47b4-4289-9abf-27939da69a2f', '4819e8f6-a2d4-497f-9b61-fc90883a0dfb', '5abadf6b-991c-4d37-810f-f77bb71d490d', 'acaf712a-c06c-4a04-a00f-0e7feeefb60c', 'f0f94fb1-2aef-44f6-ba80-5b8320725fb0', 'dce32e78-e827-4994-a0a2-06feee2528cc', '3d033ec6-942a-4b03-b26e-f8152ba48022', '02bfbe09-6e9b-4243-a376-1a51b1beef19', 'e5206c56-75a0-41fa-9db3-bec66359337e', 'a121d8bd-1943-41ba-b3a7-472a0154f8f9', 'c466661d-12dc-4d1e-81a4-1db1623e3cc1', '0ddba8a7-5ef8-45d1-b0d6-0842bc44d2cc', 'b8a9a411-7cfe-4c1d-b9a6-eef1c0efe920', '5cfc7e4d-024b-4dd1-82a5-c3d9bf25ba50', '8ebc88f0-896c-4910-8997-a44d107e7eb7', '95ba1e9a-8d72-4c0e-9526-7676f70ff067', '885cab0d-d4fc-4d93-95db-243870506405', '89919375-8b53-4e3f-8382-a97e0af7eb56', 'ce7d0394-1aa0-41c2-84b7-dfcfe006eb8b']::uuid[])
    ON CONFLICT(id) DO UPDATE SET name=EXCLUDED.name, description=EXCLUDED.description, field_ids=EXCLUDED.field_ids, test_ids=EXCLUDED.test_ids;

INSERT INTO field_definitions
        (id, key, description, agg_func, agg_weights)
        VALUES ('e0895e55-a5d9-46f2-9c95-9389baf25752', 'primary', 'Benchmark score (MEAN of test scores)', 'MEAN', NULL)
        ON CONFLICT(id) DO UPDATE SET key=EXCLUDED.key, description=EXCLUDED.description, agg_func=EXCLUDED.agg_func, agg_weights=EXCLUDED.agg_weights;

INSERT INTO test_definitions
    (id, name, description, field_ids, scenario_ids, loop, queue)
    VALUES ('1cbf44c3-0c82-4f9e-9857-c7c1d96d3ab9', 'KPI-RS-058: Robustness to operator input (Railway)', 'The KPI should measure or evaluate how the trained agent behaves in terms of robustness if, during the decision-making process where a human operator makes the final decisions, a human operator occasionally intervenes and significantly overrides the autonomous decisions of the trained agent. <br/>For agents trained using machine learning methods, this can cause an offset between the type of states encountered in the training data and during deployment, especially for agents trained using reinforcement learning or similar methods where the agent itself decides which actions to execute. As a consequence of this offset, the agent might make poorer decisions if the human operator does not always follow the proposed actions of the agents. <br/>To measure how sensitive the agent is to such offsets, this KPI proposes to use a “simulated operator” that does not fully follow the course of actions suggested by the agents, and instead overwrites certain action variables set by the agents in a fraction of time steps. ', array['df5f8939-f85f-4fbb-9bea-017c46b2a8f7']::uuid[], array['7a1c9dac-ec75-42e1-9355-34d88eabc52f']::uuid[], 'INTERACTIVE', 'Railway')
    ON CONFLICT(id) DO UPDATE SET name=EXCLUDED.name, description=EXCLUDED.description, field_ids=EXCLUDED.field_ids, scenario_ids=EXCLUDED.scenario_ids, loop=EXCLUDED.loop, queue=EXCLUDED.queue;

INSERT INTO field_definitions
        (id, key, description, agg_func, agg_weights)
        VALUES ('df5f8939-f85f-4fbb-9bea-017c46b2a8f7', 'primary', 'Benchmark score (MEAN of test scores)', 'MEAN', NULL)
        ON CONFLICT(id) DO UPDATE SET key=EXCLUDED.key, description=EXCLUDED.description, agg_func=EXCLUDED.agg_func, agg_weights=EXCLUDED.agg_weights;

INSERT INTO scenario_definitions
    (id, name, description, field_ids)
    VALUES ('7a1c9dac-ec75-42e1-9355-34d88eabc52f', 'primary', 'Overall, this KPI contributes to evaluating Robustness of the AI-based assistant when dealing with real-world conditions, as part of Task 4.2 evaluation objectives, and O4 main project objective. <br/>The KPI is related to Tasks 3.1 and 3.3. Specifically, it is related to goal (4) of Task 3.1 (“Analysis of the impact of human intervention in the decision process on AI agents developed and trained towards fully autonomous behavior”), goal (1) of Task 3.3 (“Develop and expand order-agnostic network architectures adapted to the RL setting to use human-data or human-like perturbations and ensure the system can also make good decisions in the context where actions are partially chosen by the human partner”) and goal (2) of Task 3.4 (“Detect risks early on and potentially inform human supervisors, e.g. relinquish control to a human supervisor or transition into “safety mode” when necessary”).   ', array['65db1797-5f1c-4a20-9e79-f8ef95c22db5']::uuid[])
    ON CONFLICT(id) DO UPDATE SET name=EXCLUDED.name, description=EXCLUDED.description, field_ids=EXCLUDED.field_ids;

INSERT INTO field_definitions
        (id, key, description, agg_func, agg_weights)
        VALUES ('65db1797-5f1c-4a20-9e79-f8ef95c22db5', 'primary', 'Scenario score (raw values)', NULL, NULL)
        ON CONFLICT(id) DO UPDATE SET key=EXCLUDED.key, description=EXCLUDED.description, agg_func=EXCLUDED.agg_func, agg_weights=EXCLUDED.agg_weights;

INSERT INTO test_definitions
    (id, name, description, field_ids, scenario_ids, loop, queue)
    VALUES ('75cc9343-9371-4eb1-9613-22a26c67fc00', 'KPI-RS-058: Robustness to operator input (Power Grid)', 'The KPI should measure or evaluate how the trained agent behaves in terms of robustness if, during the decision-making process where a human operator makes the final decisions, a human operator occasionally intervenes and significantly overrides the autonomous decisions of the trained agent. <br/>For agents trained using machine learning methods, this can cause an offset between the type of states encountered in the training data and during deployment, especially for agents trained using reinforcement learning or similar methods where the agent itself decides which actions to execute. As a consequence of this offset, the agent might make poorer decisions if the human operator does not always follow the proposed actions of the agents. <br/>To measure how sensitive the agent is to such offsets, this KPI proposes to use a “simulated operator” that does not fully follow the course of actions suggested by the agents, and instead overwrites certain action variables set by the agents in a fraction of time steps. ', array['6e222adc-3153-4763-8bca-256cbb3d8716']::uuid[], array['0c0730f2-e795-4c9d-8220-9bee29c46dc6']::uuid[], 'INTERACTIVE', 'PowerGrid')
    ON CONFLICT(id) DO UPDATE SET name=EXCLUDED.name, description=EXCLUDED.description, field_ids=EXCLUDED.field_ids, scenario_ids=EXCLUDED.scenario_ids, loop=EXCLUDED.loop, queue=EXCLUDED.queue;

INSERT INTO field_definitions
        (id, key, description, agg_func, agg_weights)
        VALUES ('6e222adc-3153-4763-8bca-256cbb3d8716', 'primary', 'Benchmark score (MEAN of test scores)', 'MEAN', NULL)
        ON CONFLICT(id) DO UPDATE SET key=EXCLUDED.key, description=EXCLUDED.description, agg_func=EXCLUDED.agg_func, agg_weights=EXCLUDED.agg_weights;

INSERT INTO scenario_definitions
    (id, name, description, field_ids)
    VALUES ('0c0730f2-e795-4c9d-8220-9bee29c46dc6', 'primary', 'Overall, this KPI contributes to evaluating Robustness of the AI-based assistant when dealing with real-world conditions, as part of Task 4.2 evaluation objectives, and O4 main project objective. <br/>The KPI is related to Tasks 3.1 and 3.3. Specifically, it is related to goal (4) of Task 3.1 (“Analysis of the impact of human intervention in the decision process on AI agents developed and trained towards fully autonomous behavior”), goal (1) of Task 3.3 (“Develop and expand order-agnostic network architectures adapted to the RL setting to use human-data or human-like perturbations and ensure the system can also make good decisions in the context where actions are partially chosen by the human partner”) and goal (2) of Task 3.4 (“Detect risks early on and potentially inform human supervisors, e.g. relinquish control to a human supervisor or transition into “safety mode” when necessary”).   ', array['729d218a-950e-4aa3-8153-2643347869de']::uuid[])
    ON CONFLICT(id) DO UPDATE SET name=EXCLUDED.name, description=EXCLUDED.description, field_ids=EXCLUDED.field_ids;

INSERT INTO field_definitions
        (id, key, description, agg_func, agg_weights)
        VALUES ('729d218a-950e-4aa3-8153-2643347869de', 'primary', 'Scenario score (raw values)', NULL, NULL)
        ON CONFLICT(id) DO UPDATE SET key=EXCLUDED.key, description=EXCLUDED.description, agg_func=EXCLUDED.agg_func, agg_weights=EXCLUDED.agg_weights;

INSERT INTO test_definitions
    (id, name, description, field_ids, scenario_ids, loop, queue)
    VALUES ('07881948-f5e0-4772-83c9-3ca517ac245f', 'KPI-RS-058: Robustness to operator input (ATM)', 'The KPI should measure or evaluate how the trained agent behaves in terms of robustness if, during the decision-making process where a human operator makes the final decisions, a human operator occasionally intervenes and significantly overrides the autonomous decisions of the trained agent. <br/>For agents trained using machine learning methods, this can cause an offset between the type of states encountered in the training data and during deployment, especially for agents trained using reinforcement learning or similar methods where the agent itself decides which actions to execute. As a consequence of this offset, the agent might make poorer decisions if the human operator does not always follow the proposed actions of the agents. <br/>To measure how sensitive the agent is to such offsets, this KPI proposes to use a “simulated operator” that does not fully follow the course of actions suggested by the agents, and instead overwrites certain action variables set by the agents in a fraction of time steps. ', array['9916de43-06b8-413f-bc55-3ff7c10757ce']::uuid[], array['2d805705-e6b1-45e2-8511-39d3d23a9994']::uuid[], 'INTERACTIVE', 'ATM')
    ON CONFLICT(id) DO UPDATE SET name=EXCLUDED.name, description=EXCLUDED.description, field_ids=EXCLUDED.field_ids, scenario_ids=EXCLUDED.scenario_ids, loop=EXCLUDED.loop, queue=EXCLUDED.queue;

INSERT INTO field_definitions
        (id, key, description, agg_func, agg_weights)
        VALUES ('9916de43-06b8-413f-bc55-3ff7c10757ce', 'primary', 'Benchmark score (MEAN of test scores)', 'MEAN', NULL)
        ON CONFLICT(id) DO UPDATE SET key=EXCLUDED.key, description=EXCLUDED.description, agg_func=EXCLUDED.agg_func, agg_weights=EXCLUDED.agg_weights;

INSERT INTO scenario_definitions
    (id, name, description, field_ids)
    VALUES ('2d805705-e6b1-45e2-8511-39d3d23a9994', 'primary', 'Overall, this KPI contributes to evaluating Robustness of the AI-based assistant when dealing with real-world conditions, as part of Task 4.2 evaluation objectives, and O4 main project objective. <br/>The KPI is related to Tasks 3.1 and 3.3. Specifically, it is related to goal (4) of Task 3.1 (“Analysis of the impact of human intervention in the decision process on AI agents developed and trained towards fully autonomous behavior”), goal (1) of Task 3.3 (“Develop and expand order-agnostic network architectures adapted to the RL setting to use human-data or human-like perturbations and ensure the system can also make good decisions in the context where actions are partially chosen by the human partner”) and goal (2) of Task 3.4 (“Detect risks early on and potentially inform human supervisors, e.g. relinquish control to a human supervisor or transition into “safety mode” when necessary”).   ', array['d6eacff5-2331-4003-a5c7-fc1c78016062']::uuid[])
    ON CONFLICT(id) DO UPDATE SET name=EXCLUDED.name, description=EXCLUDED.description, field_ids=EXCLUDED.field_ids;

INSERT INTO field_definitions
        (id, key, description, agg_func, agg_weights)
        VALUES ('d6eacff5-2331-4003-a5c7-fc1c78016062', 'primary', 'Scenario score (raw values)', NULL, NULL)
        ON CONFLICT(id) DO UPDATE SET key=EXCLUDED.key, description=EXCLUDED.description, agg_func=EXCLUDED.agg_func, agg_weights=EXCLUDED.agg_weights;

INSERT INTO test_definitions
    (id, name, description, field_ids, scenario_ids, loop, queue)
    VALUES ('a94c858e-4bc3-4d67-bd78-5c81506e39f7', 'KPI-DF-069: Drop-off in reward (Railway)', 'Drop-off in reward calculates difference in reward between situation with perfect information and imperfect information either through natural malfunctions while measuring data or through intentional perturbations by an attacker. ', array['4463c7f3-fbda-44b4-9c75-fdd552a2e3ba']::uuid[], array['74dd5830-6e59-423f-89f4-b050319db14e']::uuid[], 'CLOSED', 'Railway')
    ON CONFLICT(id) DO UPDATE SET name=EXCLUDED.name, description=EXCLUDED.description, field_ids=EXCLUDED.field_ids, scenario_ids=EXCLUDED.scenario_ids, loop=EXCLUDED.loop, queue=EXCLUDED.queue;

INSERT INTO field_definitions
        (id, key, description, agg_func, agg_weights)
        VALUES ('4463c7f3-fbda-44b4-9c75-fdd552a2e3ba', 'primary', 'Benchmark score (MEAN of test scores)', 'MEAN', NULL)
        ON CONFLICT(id) DO UPDATE SET key=EXCLUDED.key, description=EXCLUDED.description, agg_func=EXCLUDED.agg_func, agg_weights=EXCLUDED.agg_weights;

INSERT INTO scenario_definitions
    (id, name, description, field_ids)
    VALUES ('74dd5830-6e59-423f-89f4-b050319db14e', 'primary', 'This KPI contributes to evaluating Robustness of the AI-based assistant, as part of Task 4.2 evaluation objectives, and O4 main project objective. ', array['6eefe84b-567f-4d82-9c90-d6b877f05cd8']::uuid[])
    ON CONFLICT(id) DO UPDATE SET name=EXCLUDED.name, description=EXCLUDED.description, field_ids=EXCLUDED.field_ids;

INSERT INTO field_definitions
        (id, key, description, agg_func, agg_weights)
        VALUES ('6eefe84b-567f-4d82-9c90-d6b877f05cd8', 'primary', 'Scenario score (raw values)', NULL, NULL)
        ON CONFLICT(id) DO UPDATE SET key=EXCLUDED.key, description=EXCLUDED.description, agg_func=EXCLUDED.agg_func, agg_weights=EXCLUDED.agg_weights;

INSERT INTO test_definitions
    (id, name, description, field_ids, scenario_ids, loop, queue)
    VALUES ('1cbb7783-47b4-4289-9abf-27939da69a2f', 'KPI-DF-069: Drop-off in reward (Power Grid)', 'Drop-off in reward calculates difference in reward between situation with perfect information and imperfect information either through natural malfunctions while measuring data or through intentional perturbations by an attacker. ', array['5cf53de4-c331-4fc6-a54e-a93834b23fef']::uuid[], array['900d5489-2539-4a49-b3fb-3ae2039be92f']::uuid[], 'CLOSED', 'PowerGrid')
    ON CONFLICT(id) DO UPDATE SET name=EXCLUDED.name, description=EXCLUDED.description, field_ids=EXCLUDED.field_ids, scenario_ids=EXCLUDED.scenario_ids, loop=EXCLUDED.loop, queue=EXCLUDED.queue;

INSERT INTO field_definitions
        (id, key, description, agg_func, agg_weights)
        VALUES ('5cf53de4-c331-4fc6-a54e-a93834b23fef', 'primary', 'Benchmark score (MEAN of test scores)', 'MEAN', NULL)
        ON CONFLICT(id) DO UPDATE SET key=EXCLUDED.key, description=EXCLUDED.description, agg_func=EXCLUDED.agg_func, agg_weights=EXCLUDED.agg_weights;

INSERT INTO scenario_definitions
    (id, name, description, field_ids)
    VALUES ('900d5489-2539-4a49-b3fb-3ae2039be92f', 'primary', 'This KPI contributes to evaluating Robustness of the AI-based assistant, as part of Task 4.2 evaluation objectives, and O4 main project objective. ', array['128e21d2-c26e-44d8-b154-ea288187972a']::uuid[])
    ON CONFLICT(id) DO UPDATE SET name=EXCLUDED.name, description=EXCLUDED.description, field_ids=EXCLUDED.field_ids;

INSERT INTO field_definitions
        (id, key, description, agg_func, agg_weights)
        VALUES ('128e21d2-c26e-44d8-b154-ea288187972a', 'primary', 'Scenario score (raw values)', NULL, NULL)
        ON CONFLICT(id) DO UPDATE SET key=EXCLUDED.key, description=EXCLUDED.description, agg_func=EXCLUDED.agg_func, agg_weights=EXCLUDED.agg_weights;

INSERT INTO test_definitions
    (id, name, description, field_ids, scenario_ids, loop, queue)
    VALUES ('4819e8f6-a2d4-497f-9b61-fc90883a0dfb', 'KPI-DF-069: Drop-off in reward (ATM)', 'Drop-off in reward calculates difference in reward between situation with perfect information and imperfect information either through natural malfunctions while measuring data or through intentional perturbations by an attacker. ', array['4bd8d175-100b-4367-bbce-564d96996b40']::uuid[], array['532a18a1-5e58-45a4-830e-b5ca016499f9']::uuid[], 'CLOSED', 'ATM')
    ON CONFLICT(id) DO UPDATE SET name=EXCLUDED.name, description=EXCLUDED.description, field_ids=EXCLUDED.field_ids, scenario_ids=EXCLUDED.scenario_ids, loop=EXCLUDED.loop, queue=EXCLUDED.queue;

INSERT INTO field_definitions
        (id, key, description, agg_func, agg_weights)
        VALUES ('4bd8d175-100b-4367-bbce-564d96996b40', 'primary', 'Benchmark score (MEAN of test scores)', 'MEAN', NULL)
        ON CONFLICT(id) DO UPDATE SET key=EXCLUDED.key, description=EXCLUDED.description, agg_func=EXCLUDED.agg_func, agg_weights=EXCLUDED.agg_weights;

INSERT INTO scenario_definitions
    (id, name, description, field_ids)
    VALUES ('532a18a1-5e58-45a4-830e-b5ca016499f9', 'primary', 'This KPI contributes to evaluating Robustness of the AI-based assistant, as part of Task 4.2 evaluation objectives, and O4 main project objective. ', array['b29bdff4-e173-469c-9a01-80656400b4b5']::uuid[])
    ON CONFLICT(id) DO UPDATE SET name=EXCLUDED.name, description=EXCLUDED.description, field_ids=EXCLUDED.field_ids;

INSERT INTO field_definitions
        (id, key, description, agg_func, agg_weights)
        VALUES ('b29bdff4-e173-469c-9a01-80656400b4b5', 'primary', 'Scenario score (raw values)', NULL, NULL)
        ON CONFLICT(id) DO UPDATE SET key=EXCLUDED.key, description=EXCLUDED.description, agg_func=EXCLUDED.agg_func, agg_weights=EXCLUDED.agg_weights;

INSERT INTO test_definitions
    (id, name, description, field_ids, scenario_ids, loop, queue)
    VALUES ('5abadf6b-991c-4d37-810f-f77bb71d490d', 'KPI-FF-070: Frequency changed output AI agent (Railway)', 'Frequency changed output AI agent calculates the number of times the output of the AI agent (i.e. the action the agent chooses) is changed due to perturbations ', array['0a658c26-5b6d-4369-b28b-b42acfc95ced']::uuid[], array['ffcadd8d-207a-49af-8b09-54e922642f01']::uuid[], 'CLOSED', 'Railway')
    ON CONFLICT(id) DO UPDATE SET name=EXCLUDED.name, description=EXCLUDED.description, field_ids=EXCLUDED.field_ids, scenario_ids=EXCLUDED.scenario_ids, loop=EXCLUDED.loop, queue=EXCLUDED.queue;

INSERT INTO field_definitions
        (id, key, description, agg_func, agg_weights)
        VALUES ('0a658c26-5b6d-4369-b28b-b42acfc95ced', 'primary', 'Benchmark score (MEAN of test scores)', 'MEAN', NULL)
        ON CONFLICT(id) DO UPDATE SET key=EXCLUDED.key, description=EXCLUDED.description, agg_func=EXCLUDED.agg_func, agg_weights=EXCLUDED.agg_weights;

INSERT INTO scenario_definitions
    (id, name, description, field_ids)
    VALUES ('ffcadd8d-207a-49af-8b09-54e922642f01', 'primary', 'This KPI contributes to evaluating Robustness of the AI-based assistant, as part of Task 4.2 evaluation objectives, and O4 main project objective.  ', array['c695f336-10fc-41df-8376-33857fff1816']::uuid[])
    ON CONFLICT(id) DO UPDATE SET name=EXCLUDED.name, description=EXCLUDED.description, field_ids=EXCLUDED.field_ids;

INSERT INTO field_definitions
        (id, key, description, agg_func, agg_weights)
        VALUES ('c695f336-10fc-41df-8376-33857fff1816', 'primary', 'Scenario score (raw values)', NULL, NULL)
        ON CONFLICT(id) DO UPDATE SET key=EXCLUDED.key, description=EXCLUDED.description, agg_func=EXCLUDED.agg_func, agg_weights=EXCLUDED.agg_weights;

INSERT INTO test_definitions
    (id, name, description, field_ids, scenario_ids, loop, queue)
    VALUES ('acaf712a-c06c-4a04-a00f-0e7feeefb60c', 'KPI-FF-070: Frequency changed output AI agent (Power Grid)', 'Frequency changed output AI agent calculates the number of times the output of the AI agent (i.e. the action the agent chooses) is changed due to perturbations ', array['64208759-4b1b-415c-ae2e-d5244b328e68']::uuid[], array['fdaac433-3ef0-4667-afb8-8014d0c1afa3']::uuid[], 'CLOSED', 'PowerGrid')
    ON CONFLICT(id) DO UPDATE SET name=EXCLUDED.name, description=EXCLUDED.description, field_ids=EXCLUDED.field_ids, scenario_ids=EXCLUDED.scenario_ids, loop=EXCLUDED.loop, queue=EXCLUDED.queue;

INSERT INTO field_definitions
        (id, key, description, agg_func, agg_weights)
        VALUES ('64208759-4b1b-415c-ae2e-d5244b328e68', 'primary', 'Benchmark score (MEAN of test scores)', 'MEAN', NULL)
        ON CONFLICT(id) DO UPDATE SET key=EXCLUDED.key, description=EXCLUDED.description, agg_func=EXCLUDED.agg_func, agg_weights=EXCLUDED.agg_weights;

INSERT INTO scenario_definitions
    (id, name, description, field_ids)
    VALUES ('fdaac433-3ef0-4667-afb8-8014d0c1afa3', 'primary', 'This KPI contributes to evaluating Robustness of the AI-based assistant, as part of Task 4.2 evaluation objectives, and O4 main project objective.  ', array['44384196-3ffd-4df4-bd68-0e803f77757d']::uuid[])
    ON CONFLICT(id) DO UPDATE SET name=EXCLUDED.name, description=EXCLUDED.description, field_ids=EXCLUDED.field_ids;

INSERT INTO field_definitions
        (id, key, description, agg_func, agg_weights)
        VALUES ('44384196-3ffd-4df4-bd68-0e803f77757d', 'primary', 'Scenario score (raw values)', NULL, NULL)
        ON CONFLICT(id) DO UPDATE SET key=EXCLUDED.key, description=EXCLUDED.description, agg_func=EXCLUDED.agg_func, agg_weights=EXCLUDED.agg_weights;

INSERT INTO test_definitions
    (id, name, description, field_ids, scenario_ids, loop, queue)
    VALUES ('f0f94fb1-2aef-44f6-ba80-5b8320725fb0', 'KPI-FF-070: Frequency changed output AI agent (ATM)', 'Frequency changed output AI agent calculates the number of times the output of the AI agent (i.e. the action the agent chooses) is changed due to perturbations ', array['9124a4ed-a727-49c7-aab9-dc2473594490']::uuid[], array['12c63b69-e6b1-4316-999b-7112e0b0c1d2']::uuid[], 'CLOSED', 'ATM')
    ON CONFLICT(id) DO UPDATE SET name=EXCLUDED.name, description=EXCLUDED.description, field_ids=EXCLUDED.field_ids, scenario_ids=EXCLUDED.scenario_ids, loop=EXCLUDED.loop, queue=EXCLUDED.queue;

INSERT INTO field_definitions
        (id, key, description, agg_func, agg_weights)
        VALUES ('9124a4ed-a727-49c7-aab9-dc2473594490', 'primary', 'Benchmark score (MEAN of test scores)', 'MEAN', NULL)
        ON CONFLICT(id) DO UPDATE SET key=EXCLUDED.key, description=EXCLUDED.description, agg_func=EXCLUDED.agg_func, agg_weights=EXCLUDED.agg_weights;

INSERT INTO scenario_definitions
    (id, name, description, field_ids)
    VALUES ('12c63b69-e6b1-4316-999b-7112e0b0c1d2', 'primary', 'This KPI contributes to evaluating Robustness of the AI-based assistant, as part of Task 4.2 evaluation objectives, and O4 main project objective.  ', array['35b65c55-13d4-4385-bff4-5c5ccfeb1077']::uuid[])
    ON CONFLICT(id) DO UPDATE SET name=EXCLUDED.name, description=EXCLUDED.description, field_ids=EXCLUDED.field_ids;

INSERT INTO field_definitions
        (id, key, description, agg_func, agg_weights)
        VALUES ('35b65c55-13d4-4385-bff4-5c5ccfeb1077', 'primary', 'Scenario score (raw values)', NULL, NULL)
        ON CONFLICT(id) DO UPDATE SET key=EXCLUDED.key, description=EXCLUDED.description, agg_func=EXCLUDED.agg_func, agg_weights=EXCLUDED.agg_weights;

INSERT INTO test_definitions
    (id, name, description, field_ids, scenario_ids, loop, queue)
    VALUES ('dce32e78-e827-4994-a0a2-06feee2528cc', 'KPI-SF-071: Severity of changed output AI agent (Railway)', 'Severity of changed output AI agent KPI measures similarity of the action chosen by AI agent based on a perturbed input to the action chosen with perfect information. Average pre-defined similarity score per changed action indicating how different the new action is from the original one. ', array['1957912f-47fd-4ce6-8596-90a320c4a46e']::uuid[], array['588ae37c-f583-47df-9154-ca12c9ac134a']::uuid[], 'CLOSED', 'Railway')
    ON CONFLICT(id) DO UPDATE SET name=EXCLUDED.name, description=EXCLUDED.description, field_ids=EXCLUDED.field_ids, scenario_ids=EXCLUDED.scenario_ids, loop=EXCLUDED.loop, queue=EXCLUDED.queue;

INSERT INTO field_definitions
        (id, key, description, agg_func, agg_weights)
        VALUES ('1957912f-47fd-4ce6-8596-90a320c4a46e', 'primary', 'Benchmark score (MEAN of test scores)', 'MEAN', NULL)
        ON CONFLICT(id) DO UPDATE SET key=EXCLUDED.key, description=EXCLUDED.description, agg_func=EXCLUDED.agg_func, agg_weights=EXCLUDED.agg_weights;

INSERT INTO scenario_definitions
    (id, name, description, field_ids)
    VALUES ('588ae37c-f583-47df-9154-ca12c9ac134a', 'primary', 'This KPI contributes to evaluating Robustness of the AI-based assistant, as part of Task 4.2 evaluation objectives, and O4 main project objective. ', array['f28523cf-b708-4431-91c0-3b29056139f9']::uuid[])
    ON CONFLICT(id) DO UPDATE SET name=EXCLUDED.name, description=EXCLUDED.description, field_ids=EXCLUDED.field_ids;

INSERT INTO field_definitions
        (id, key, description, agg_func, agg_weights)
        VALUES ('f28523cf-b708-4431-91c0-3b29056139f9', 'primary', 'Scenario score (raw values)', NULL, NULL)
        ON CONFLICT(id) DO UPDATE SET key=EXCLUDED.key, description=EXCLUDED.description, agg_func=EXCLUDED.agg_func, agg_weights=EXCLUDED.agg_weights;

INSERT INTO test_definitions
    (id, name, description, field_ids, scenario_ids, loop, queue)
    VALUES ('3d033ec6-942a-4b03-b26e-f8152ba48022', 'KPI-SF-071: Severity of changed output AI agent (Power Grid)', 'Severity of changed output AI agent KPI measures similarity of the action chosen by AI agent based on a perturbed input to the action chosen with perfect information. Average pre-defined similarity score per changed action indicating how different the new action is from the original one. ', array['861dc5e2-f3ce-4c74-829b-9c50c891a610']::uuid[], array['70d937d5-742b-4838-a456-4a95ff994788']::uuid[], 'CLOSED', 'PowerGrid')
    ON CONFLICT(id) DO UPDATE SET name=EXCLUDED.name, description=EXCLUDED.description, field_ids=EXCLUDED.field_ids, scenario_ids=EXCLUDED.scenario_ids, loop=EXCLUDED.loop, queue=EXCLUDED.queue;

INSERT INTO field_definitions
        (id, key, description, agg_func, agg_weights)
        VALUES ('861dc5e2-f3ce-4c74-829b-9c50c891a610', 'primary', 'Benchmark score (MEAN of test scores)', 'MEAN', NULL)
        ON CONFLICT(id) DO UPDATE SET key=EXCLUDED.key, description=EXCLUDED.description, agg_func=EXCLUDED.agg_func, agg_weights=EXCLUDED.agg_weights;

INSERT INTO scenario_definitions
    (id, name, description, field_ids)
    VALUES ('70d937d5-742b-4838-a456-4a95ff994788', 'primary', 'This KPI contributes to evaluating Robustness of the AI-based assistant, as part of Task 4.2 evaluation objectives, and O4 main project objective. ', array['eb411f0f-eb8a-47e1-9ba1-6a929449d59c']::uuid[])
    ON CONFLICT(id) DO UPDATE SET name=EXCLUDED.name, description=EXCLUDED.description, field_ids=EXCLUDED.field_ids;

INSERT INTO field_definitions
        (id, key, description, agg_func, agg_weights)
        VALUES ('eb411f0f-eb8a-47e1-9ba1-6a929449d59c', 'primary', 'Scenario score (raw values)', NULL, NULL)
        ON CONFLICT(id) DO UPDATE SET key=EXCLUDED.key, description=EXCLUDED.description, agg_func=EXCLUDED.agg_func, agg_weights=EXCLUDED.agg_weights;

INSERT INTO test_definitions
    (id, name, description, field_ids, scenario_ids, loop, queue)
    VALUES ('02bfbe09-6e9b-4243-a376-1a51b1beef19', 'KPI-SF-071: Severity of changed output AI agent (ATM)', 'Severity of changed output AI agent KPI measures similarity of the action chosen by AI agent based on a perturbed input to the action chosen with perfect information. Average pre-defined similarity score per changed action indicating how different the new action is from the original one. ', array['da2b5bd3-4bef-4d57-b257-be675bf3dc2a']::uuid[], array['af261375-7fd2-4a89-92b6-3477b018a09d']::uuid[], 'CLOSED', 'ATM')
    ON CONFLICT(id) DO UPDATE SET name=EXCLUDED.name, description=EXCLUDED.description, field_ids=EXCLUDED.field_ids, scenario_ids=EXCLUDED.scenario_ids, loop=EXCLUDED.loop, queue=EXCLUDED.queue;

INSERT INTO field_definitions
        (id, key, description, agg_func, agg_weights)
        VALUES ('da2b5bd3-4bef-4d57-b257-be675bf3dc2a', 'primary', 'Benchmark score (MEAN of test scores)', 'MEAN', NULL)
        ON CONFLICT(id) DO UPDATE SET key=EXCLUDED.key, description=EXCLUDED.description, agg_func=EXCLUDED.agg_func, agg_weights=EXCLUDED.agg_weights;

INSERT INTO scenario_definitions
    (id, name, description, field_ids)
    VALUES ('af261375-7fd2-4a89-92b6-3477b018a09d', 'primary', 'This KPI contributes to evaluating Robustness of the AI-based assistant, as part of Task 4.2 evaluation objectives, and O4 main project objective. ', array['4bb80a5b-6ed3-45f9-bab4-6a8ce1607721']::uuid[])
    ON CONFLICT(id) DO UPDATE SET name=EXCLUDED.name, description=EXCLUDED.description, field_ids=EXCLUDED.field_ids;

INSERT INTO field_definitions
        (id, key, description, agg_func, agg_weights)
        VALUES ('4bb80a5b-6ed3-45f9-bab4-6a8ce1607721', 'primary', 'Scenario score (raw values)', NULL, NULL)
        ON CONFLICT(id) DO UPDATE SET key=EXCLUDED.key, description=EXCLUDED.description, agg_func=EXCLUDED.agg_func, agg_weights=EXCLUDED.agg_weights;

INSERT INTO test_definitions
    (id, name, description, field_ids, scenario_ids, loop, queue)
    VALUES ('e5206c56-75a0-41fa-9db3-bec66359337e', 'KPI-SF-072: Steps survived with perturbations (Railway)', 'Steps survived with perturbations KPI calculates the number of steps the AI agent is able to survive in environment with perturbation agent ', array['b297a241-a1dd-48c5-9dab-bbd58261c3e9']::uuid[], array['8011c7bd-6082-4653-8d9d-887d23f1ec5c']::uuid[], 'CLOSED', 'Railway')
    ON CONFLICT(id) DO UPDATE SET name=EXCLUDED.name, description=EXCLUDED.description, field_ids=EXCLUDED.field_ids, scenario_ids=EXCLUDED.scenario_ids, loop=EXCLUDED.loop, queue=EXCLUDED.queue;

INSERT INTO field_definitions
        (id, key, description, agg_func, agg_weights)
        VALUES ('b297a241-a1dd-48c5-9dab-bbd58261c3e9', 'primary', 'Benchmark score (MEAN of test scores)', 'MEAN', NULL)
        ON CONFLICT(id) DO UPDATE SET key=EXCLUDED.key, description=EXCLUDED.description, agg_func=EXCLUDED.agg_func, agg_weights=EXCLUDED.agg_weights;

INSERT INTO scenario_definitions
    (id, name, description, field_ids)
    VALUES ('8011c7bd-6082-4653-8d9d-887d23f1ec5c', 'primary', 'This KPI contributes to evaluating Robustness of the AI-based assistant, as part of Task 4.2 evaluation objectives, and O4 main project objective. ', array['10bb95e7-9938-468e-b6c2-ed7c5017fd3b']::uuid[])
    ON CONFLICT(id) DO UPDATE SET name=EXCLUDED.name, description=EXCLUDED.description, field_ids=EXCLUDED.field_ids;

INSERT INTO field_definitions
        (id, key, description, agg_func, agg_weights)
        VALUES ('10bb95e7-9938-468e-b6c2-ed7c5017fd3b', 'primary', 'Scenario score (raw values)', NULL, NULL)
        ON CONFLICT(id) DO UPDATE SET key=EXCLUDED.key, description=EXCLUDED.description, agg_func=EXCLUDED.agg_func, agg_weights=EXCLUDED.agg_weights;

INSERT INTO test_definitions
    (id, name, description, field_ids, scenario_ids, loop, queue)
    VALUES ('a121d8bd-1943-41ba-b3a7-472a0154f8f9', 'KPI-SF-072: Steps survived with perturbations (Power Grid)', 'Steps survived with perturbations KPI calculates the number of steps the AI agent is able to survive in environment with perturbation agent ', array['7b373f1a-e892-44f7-a76d-7b93e73f745b']::uuid[], array['9cd1a5e0-8445-4b9d-859b-76b096d33049']::uuid[], 'CLOSED', 'PowerGrid')
    ON CONFLICT(id) DO UPDATE SET name=EXCLUDED.name, description=EXCLUDED.description, field_ids=EXCLUDED.field_ids, scenario_ids=EXCLUDED.scenario_ids, loop=EXCLUDED.loop, queue=EXCLUDED.queue;

INSERT INTO field_definitions
        (id, key, description, agg_func, agg_weights)
        VALUES ('7b373f1a-e892-44f7-a76d-7b93e73f745b', 'primary', 'Benchmark score (MEAN of test scores)', 'MEAN', NULL)
        ON CONFLICT(id) DO UPDATE SET key=EXCLUDED.key, description=EXCLUDED.description, agg_func=EXCLUDED.agg_func, agg_weights=EXCLUDED.agg_weights;

INSERT INTO scenario_definitions
    (id, name, description, field_ids)
    VALUES ('9cd1a5e0-8445-4b9d-859b-76b096d33049', 'primary', 'This KPI contributes to evaluating Robustness of the AI-based assistant, as part of Task 4.2 evaluation objectives, and O4 main project objective. ', array['2495463f-0168-438a-8b2c-65efbcfdb288']::uuid[])
    ON CONFLICT(id) DO UPDATE SET name=EXCLUDED.name, description=EXCLUDED.description, field_ids=EXCLUDED.field_ids;

INSERT INTO field_definitions
        (id, key, description, agg_func, agg_weights)
        VALUES ('2495463f-0168-438a-8b2c-65efbcfdb288', 'primary', 'Scenario score (raw values)', NULL, NULL)
        ON CONFLICT(id) DO UPDATE SET key=EXCLUDED.key, description=EXCLUDED.description, agg_func=EXCLUDED.agg_func, agg_weights=EXCLUDED.agg_weights;

INSERT INTO test_definitions
    (id, name, description, field_ids, scenario_ids, loop, queue)
    VALUES ('c466661d-12dc-4d1e-81a4-1db1623e3cc1', 'KPI-SF-072: Steps survived with perturbations (ATM)', 'Steps survived with perturbations KPI calculates the number of steps the AI agent is able to survive in environment with perturbation agent ', array['5ef0d594-d8c5-4ebe-8adc-ad972481f301']::uuid[], array['f903201d-a631-46c9-997f-f32bf7e3ff5d']::uuid[], 'CLOSED', 'ATM')
    ON CONFLICT(id) DO UPDATE SET name=EXCLUDED.name, description=EXCLUDED.description, field_ids=EXCLUDED.field_ids, scenario_ids=EXCLUDED.scenario_ids, loop=EXCLUDED.loop, queue=EXCLUDED.queue;

INSERT INTO field_definitions
        (id, key, description, agg_func, agg_weights)
        VALUES ('5ef0d594-d8c5-4ebe-8adc-ad972481f301', 'primary', 'Benchmark score (MEAN of test scores)', 'MEAN', NULL)
        ON CONFLICT(id) DO UPDATE SET key=EXCLUDED.key, description=EXCLUDED.description, agg_func=EXCLUDED.agg_func, agg_weights=EXCLUDED.agg_weights;

INSERT INTO scenario_definitions
    (id, name, description, field_ids)
    VALUES ('f903201d-a631-46c9-997f-f32bf7e3ff5d', 'primary', 'This KPI contributes to evaluating Robustness of the AI-based assistant, as part of Task 4.2 evaluation objectives, and O4 main project objective. ', array['86becfb7-36df-449f-aa44-e27aa8d9c5c8']::uuid[])
    ON CONFLICT(id) DO UPDATE SET name=EXCLUDED.name, description=EXCLUDED.description, field_ids=EXCLUDED.field_ids;

INSERT INTO field_definitions
        (id, key, description, agg_func, agg_weights)
        VALUES ('86becfb7-36df-449f-aa44-e27aa8d9c5c8', 'primary', 'Scenario score (raw values)', NULL, NULL)
        ON CONFLICT(id) DO UPDATE SET key=EXCLUDED.key, description=EXCLUDED.description, agg_func=EXCLUDED.agg_func, agg_weights=EXCLUDED.agg_weights;

INSERT INTO test_definitions
    (id, name, description, field_ids, scenario_ids, loop, queue)
    VALUES ('0ddba8a7-5ef8-45d1-b0d6-0842bc44d2cc', 'KPI-VF-073: Vulnerability to perturbation (Railway)', 'Vulnerability to perturbation KPI measures vulnerability of specific value in observed state to perturbations, i.e. how likely it is that perturbing the value will result in a change in action chosen by the AI agent ', array['45500bcb-96bc-4b21-87ad-1ae69122cf88']::uuid[], array['47a11418-fad5-4d55-a637-6b90a8351500']::uuid[], 'CLOSED', 'Railway')
    ON CONFLICT(id) DO UPDATE SET name=EXCLUDED.name, description=EXCLUDED.description, field_ids=EXCLUDED.field_ids, scenario_ids=EXCLUDED.scenario_ids, loop=EXCLUDED.loop, queue=EXCLUDED.queue;

INSERT INTO field_definitions
        (id, key, description, agg_func, agg_weights)
        VALUES ('45500bcb-96bc-4b21-87ad-1ae69122cf88', 'primary', 'Benchmark score (MEAN of test scores)', 'MEAN', NULL)
        ON CONFLICT(id) DO UPDATE SET key=EXCLUDED.key, description=EXCLUDED.description, agg_func=EXCLUDED.agg_func, agg_weights=EXCLUDED.agg_weights;

INSERT INTO scenario_definitions
    (id, name, description, field_ids)
    VALUES ('47a11418-fad5-4d55-a637-6b90a8351500', 'primary', 'This KPI contributes to evaluating Robustness of the AI-based assistant, as part of Task 4.2 evaluation objectives, and O4 main project objective. ', array['ad276973-ba49-4688-91d1-1217b35b33e1']::uuid[])
    ON CONFLICT(id) DO UPDATE SET name=EXCLUDED.name, description=EXCLUDED.description, field_ids=EXCLUDED.field_ids;

INSERT INTO field_definitions
        (id, key, description, agg_func, agg_weights)
        VALUES ('ad276973-ba49-4688-91d1-1217b35b33e1', 'primary', 'Scenario score (raw values)', NULL, NULL)
        ON CONFLICT(id) DO UPDATE SET key=EXCLUDED.key, description=EXCLUDED.description, agg_func=EXCLUDED.agg_func, agg_weights=EXCLUDED.agg_weights;

INSERT INTO test_definitions
    (id, name, description, field_ids, scenario_ids, loop, queue)
    VALUES ('b8a9a411-7cfe-4c1d-b9a6-eef1c0efe920', 'KPI-VF-073: Vulnerability to perturbation (Power Grid)', 'Vulnerability to perturbation KPI measures vulnerability of specific value in observed state to perturbations, i.e. how likely it is that perturbing the value will result in a change in action chosen by the AI agent ', array['cad90039-f91d-4883-9937-8671f8363766']::uuid[], array['61063867-df62-4024-be42-c57507a15d7c']::uuid[], 'CLOSED', 'PowerGrid')
    ON CONFLICT(id) DO UPDATE SET name=EXCLUDED.name, description=EXCLUDED.description, field_ids=EXCLUDED.field_ids, scenario_ids=EXCLUDED.scenario_ids, loop=EXCLUDED.loop, queue=EXCLUDED.queue;

INSERT INTO field_definitions
        (id, key, description, agg_func, agg_weights)
        VALUES ('cad90039-f91d-4883-9937-8671f8363766', 'primary', 'Benchmark score (MEAN of test scores)', 'MEAN', NULL)
        ON CONFLICT(id) DO UPDATE SET key=EXCLUDED.key, description=EXCLUDED.description, agg_func=EXCLUDED.agg_func, agg_weights=EXCLUDED.agg_weights;

INSERT INTO scenario_definitions
    (id, name, description, field_ids)
    VALUES ('61063867-df62-4024-be42-c57507a15d7c', 'primary', 'This KPI contributes to evaluating Robustness of the AI-based assistant, as part of Task 4.2 evaluation objectives, and O4 main project objective. ', array['e4f93627-fb2a-4dc9-943b-77c8f224222c']::uuid[])
    ON CONFLICT(id) DO UPDATE SET name=EXCLUDED.name, description=EXCLUDED.description, field_ids=EXCLUDED.field_ids;

INSERT INTO field_definitions
        (id, key, description, agg_func, agg_weights)
        VALUES ('e4f93627-fb2a-4dc9-943b-77c8f224222c', 'primary', 'Scenario score (raw values)', NULL, NULL)
        ON CONFLICT(id) DO UPDATE SET key=EXCLUDED.key, description=EXCLUDED.description, agg_func=EXCLUDED.agg_func, agg_weights=EXCLUDED.agg_weights;

INSERT INTO test_definitions
    (id, name, description, field_ids, scenario_ids, loop, queue)
    VALUES ('5cfc7e4d-024b-4dd1-82a5-c3d9bf25ba50', 'KPI-VF-073: Vulnerability to perturbation (ATM)', 'Vulnerability to perturbation KPI measures vulnerability of specific value in observed state to perturbations, i.e. how likely it is that perturbing the value will result in a change in action chosen by the AI agent ', array['58aa9828-9572-4433-b492-339104be9ad1']::uuid[], array['3ced691e-d23c-47de-9967-5cf5d7be3e9e']::uuid[], 'CLOSED', 'ATM')
    ON CONFLICT(id) DO UPDATE SET name=EXCLUDED.name, description=EXCLUDED.description, field_ids=EXCLUDED.field_ids, scenario_ids=EXCLUDED.scenario_ids, loop=EXCLUDED.loop, queue=EXCLUDED.queue;

INSERT INTO field_definitions
        (id, key, description, agg_func, agg_weights)
        VALUES ('58aa9828-9572-4433-b492-339104be9ad1', 'primary', 'Benchmark score (MEAN of test scores)', 'MEAN', NULL)
        ON CONFLICT(id) DO UPDATE SET key=EXCLUDED.key, description=EXCLUDED.description, agg_func=EXCLUDED.agg_func, agg_weights=EXCLUDED.agg_weights;

INSERT INTO scenario_definitions
    (id, name, description, field_ids)
    VALUES ('3ced691e-d23c-47de-9967-5cf5d7be3e9e', 'primary', 'This KPI contributes to evaluating Robustness of the AI-based assistant, as part of Task 4.2 evaluation objectives, and O4 main project objective. ', array['48571925-e8a2-4329-8b58-1a9e6d9b0d1f']::uuid[])
    ON CONFLICT(id) DO UPDATE SET name=EXCLUDED.name, description=EXCLUDED.description, field_ids=EXCLUDED.field_ids;

INSERT INTO field_definitions
        (id, key, description, agg_func, agg_weights)
        VALUES ('48571925-e8a2-4329-8b58-1a9e6d9b0d1f', 'primary', 'Scenario score (raw values)', NULL, NULL)
        ON CONFLICT(id) DO UPDATE SET key=EXCLUDED.key, description=EXCLUDED.description, agg_func=EXCLUDED.agg_func, agg_weights=EXCLUDED.agg_weights;

INSERT INTO test_definitions
    (id, name, description, field_ids, scenario_ids, loop, queue)
    VALUES ('8ebc88f0-896c-4910-8997-a44d107e7eb7', 'KPI-RF-078: Reward per action (Railway)', 'Reward per action KPI calculates average reward obtained for each action performed by the AI agent ', array['30d12d61-8f39-4e99-b292-b1f9ed21a6b4']::uuid[], array['dc8195e4-266d-4afb-ba60-2659f59acfa4']::uuid[], 'CLOSED', 'Railway')
    ON CONFLICT(id) DO UPDATE SET name=EXCLUDED.name, description=EXCLUDED.description, field_ids=EXCLUDED.field_ids, scenario_ids=EXCLUDED.scenario_ids, loop=EXCLUDED.loop, queue=EXCLUDED.queue;

INSERT INTO field_definitions
        (id, key, description, agg_func, agg_weights)
        VALUES ('30d12d61-8f39-4e99-b292-b1f9ed21a6b4', 'primary', 'Benchmark score (MEAN of test scores)', 'MEAN', NULL)
        ON CONFLICT(id) DO UPDATE SET key=EXCLUDED.key, description=EXCLUDED.description, agg_func=EXCLUDED.agg_func, agg_weights=EXCLUDED.agg_weights;

INSERT INTO scenario_definitions
    (id, name, description, field_ids)
    VALUES ('dc8195e4-266d-4afb-ba60-2659f59acfa4', 'primary', 'This KPI contributes to evaluating Robustness of the AI-based assistant, as part of Task 4.2 evaluation objectives, and O4 main project objective. ', array['b82960af-30e3-4402-aea4-f129b8518ad9']::uuid[])
    ON CONFLICT(id) DO UPDATE SET name=EXCLUDED.name, description=EXCLUDED.description, field_ids=EXCLUDED.field_ids;

INSERT INTO field_definitions
        (id, key, description, agg_func, agg_weights)
        VALUES ('b82960af-30e3-4402-aea4-f129b8518ad9', 'primary', 'Scenario score (raw values)', NULL, NULL)
        ON CONFLICT(id) DO UPDATE SET key=EXCLUDED.key, description=EXCLUDED.description, agg_func=EXCLUDED.agg_func, agg_weights=EXCLUDED.agg_weights;

INSERT INTO test_definitions
    (id, name, description, field_ids, scenario_ids, loop, queue)
    VALUES ('95ba1e9a-8d72-4c0e-9526-7676f70ff067', 'KPI-RF-078: Reward per action (Power Grid)', 'Reward per action KPI calculates average reward obtained for each action performed by the AI agent ', array['e248e90c-65e0-4e36-89df-2e3232ed430d']::uuid[], array['a999eb93-2efe-4f73-a2d8-eab51f158ae8']::uuid[], 'CLOSED', 'PowerGrid')
    ON CONFLICT(id) DO UPDATE SET name=EXCLUDED.name, description=EXCLUDED.description, field_ids=EXCLUDED.field_ids, scenario_ids=EXCLUDED.scenario_ids, loop=EXCLUDED.loop, queue=EXCLUDED.queue;

INSERT INTO field_definitions
        (id, key, description, agg_func, agg_weights)
        VALUES ('e248e90c-65e0-4e36-89df-2e3232ed430d', 'primary', 'Benchmark score (MEAN of test scores)', 'MEAN', NULL)
        ON CONFLICT(id) DO UPDATE SET key=EXCLUDED.key, description=EXCLUDED.description, agg_func=EXCLUDED.agg_func, agg_weights=EXCLUDED.agg_weights;

INSERT INTO scenario_definitions
    (id, name, description, field_ids)
    VALUES ('a999eb93-2efe-4f73-a2d8-eab51f158ae8', 'primary', 'This KPI contributes to evaluating Robustness of the AI-based assistant, as part of Task 4.2 evaluation objectives, and O4 main project objective. ', array['a904e4a5-a0bc-4dbc-af03-7f7d8af21a28']::uuid[])
    ON CONFLICT(id) DO UPDATE SET name=EXCLUDED.name, description=EXCLUDED.description, field_ids=EXCLUDED.field_ids;

INSERT INTO field_definitions
        (id, key, description, agg_func, agg_weights)
        VALUES ('a904e4a5-a0bc-4dbc-af03-7f7d8af21a28', 'primary', 'Scenario score (raw values)', NULL, NULL)
        ON CONFLICT(id) DO UPDATE SET key=EXCLUDED.key, description=EXCLUDED.description, agg_func=EXCLUDED.agg_func, agg_weights=EXCLUDED.agg_weights;

INSERT INTO test_definitions
    (id, name, description, field_ids, scenario_ids, loop, queue)
    VALUES ('885cab0d-d4fc-4d93-95db-243870506405', 'KPI-RF-078: Reward per action (ATM)', 'Reward per action KPI calculates average reward obtained for each action performed by the AI agent ', array['3813d4e2-3ac4-44b3-9abf-c16dd67f00ac']::uuid[], array['eeb9b483-616d-4508-85b8-812a09f93d23']::uuid[], 'CLOSED', 'ATM')
    ON CONFLICT(id) DO UPDATE SET name=EXCLUDED.name, description=EXCLUDED.description, field_ids=EXCLUDED.field_ids, scenario_ids=EXCLUDED.scenario_ids, loop=EXCLUDED.loop, queue=EXCLUDED.queue;

INSERT INTO field_definitions
        (id, key, description, agg_func, agg_weights)
        VALUES ('3813d4e2-3ac4-44b3-9abf-c16dd67f00ac', 'primary', 'Benchmark score (MEAN of test scores)', 'MEAN', NULL)
        ON CONFLICT(id) DO UPDATE SET key=EXCLUDED.key, description=EXCLUDED.description, agg_func=EXCLUDED.agg_func, agg_weights=EXCLUDED.agg_weights;

INSERT INTO scenario_definitions
    (id, name, description, field_ids)
    VALUES ('eeb9b483-616d-4508-85b8-812a09f93d23', 'primary', 'This KPI contributes to evaluating Robustness of the AI-based assistant, as part of Task 4.2 evaluation objectives, and O4 main project objective. ', array['4cd393ef-cca3-4624-812e-02d69c32a22c']::uuid[])
    ON CONFLICT(id) DO UPDATE SET name=EXCLUDED.name, description=EXCLUDED.description, field_ids=EXCLUDED.field_ids;

INSERT INTO field_definitions
        (id, key, description, agg_func, agg_weights)
        VALUES ('4cd393ef-cca3-4624-812e-02d69c32a22c', 'primary', 'Scenario score (raw values)', NULL, NULL)
        ON CONFLICT(id) DO UPDATE SET key=EXCLUDED.key, description=EXCLUDED.description, agg_func=EXCLUDED.agg_func, agg_weights=EXCLUDED.agg_weights;

INSERT INTO test_definitions
    (id, name, description, field_ids, scenario_ids, loop, queue)
    VALUES ('89919375-8b53-4e3f-8382-a97e0af7eb56', 'KPI-EF-086: Explainability Robustness (Power Grid)', 'The Explainability Robustness KPI evaluates the stability of explanations against small input perturbations, assuming the model’s output remains relatively unchanged. A robust explanation should not fluctuate significantly when the input is slightly modified. The Average Sensitivity Metric quantifies this stability by applying small perturbations to the input data and measuring how much the explanation changes. Since computing sensitivity over all possible perturbations is impractical, Monte Carlo sampling is used to estimate these variations efficiently. ', array['a1d636fb-9525-4796-85f6-565ecc4dc2a3']::uuid[], array['e36d1ef8-939c-4cd8-a660-0a224ce24aa0']::uuid[], 'CLOSED', 'PowerGrid')
    ON CONFLICT(id) DO UPDATE SET name=EXCLUDED.name, description=EXCLUDED.description, field_ids=EXCLUDED.field_ids, scenario_ids=EXCLUDED.scenario_ids, loop=EXCLUDED.loop, queue=EXCLUDED.queue;

INSERT INTO field_definitions
        (id, key, description, agg_func, agg_weights)
        VALUES ('a1d636fb-9525-4796-85f6-565ecc4dc2a3', 'primary', 'Benchmark score (MEAN of test scores)', 'MEAN', NULL)
        ON CONFLICT(id) DO UPDATE SET key=EXCLUDED.key, description=EXCLUDED.description, agg_func=EXCLUDED.agg_func, agg_weights=EXCLUDED.agg_weights;

INSERT INTO scenario_definitions
    (id, name, description, field_ids)
    VALUES ('e36d1ef8-939c-4cd8-a660-0a224ce24aa0', 'primary', 'This KPI ensures that AI-driven explanations remain reliable and aligned with the actual decision-making process of the model. It helps evaluate interpretability methods in AI systems used in critical applications. <br/>This KPI contributes to evaluating AI trustworthiness, acceptability and trust of the AI-based assistant, as part of Task 4.3 evaluation objectives, and O4 main project objective.', array['17c72ca8-d2e0-4ff4-9c6c-c5d3b2391d63']::uuid[])
    ON CONFLICT(id) DO UPDATE SET name=EXCLUDED.name, description=EXCLUDED.description, field_ids=EXCLUDED.field_ids;

INSERT INTO field_definitions
        (id, key, description, agg_func, agg_weights)
        VALUES ('17c72ca8-d2e0-4ff4-9c6c-c5d3b2391d63', 'primary', 'Scenario score (raw values)', NULL, NULL)
        ON CONFLICT(id) DO UPDATE SET key=EXCLUDED.key, description=EXCLUDED.description, agg_func=EXCLUDED.agg_func, agg_weights=EXCLUDED.agg_weights;

INSERT INTO test_definitions
    (id, name, description, field_ids, scenario_ids, loop, queue)
    VALUES ('ce7d0394-1aa0-41c2-84b7-dfcfe006eb8b', 'KPI-EF-087: Explainability Faithfulness (Power Grid)', 'The Faithfulness KPI assesses whether the feature importance scores provided by an explanation method accurately reflect the model’s decision-making process. It systematically removes or alters features and measures the impact on the model’s predictions. The assumption is that if a feature is truly important, removing or altering it should significantly affect the model’s output. ', array['92eb89c5-a934-4f62-b64b-9ff63c3189fc']::uuid[], array['53b0db0e-7092-455b-9e2c-327ee017f776']::uuid[], 'CLOSED', 'PowerGrid')
    ON CONFLICT(id) DO UPDATE SET name=EXCLUDED.name, description=EXCLUDED.description, field_ids=EXCLUDED.field_ids, scenario_ids=EXCLUDED.scenario_ids, loop=EXCLUDED.loop, queue=EXCLUDED.queue;

INSERT INTO field_definitions
        (id, key, description, agg_func, agg_weights)
        VALUES ('92eb89c5-a934-4f62-b64b-9ff63c3189fc', 'primary', 'Benchmark score (MEAN of test scores)', 'MEAN', NULL)
        ON CONFLICT(id) DO UPDATE SET key=EXCLUDED.key, description=EXCLUDED.description, agg_func=EXCLUDED.agg_func, agg_weights=EXCLUDED.agg_weights;

INSERT INTO scenario_definitions
    (id, name, description, field_ids)
    VALUES ('53b0db0e-7092-455b-9e2c-327ee017f776', 'primary', 'This KPI ensures that AI-driven explanations remain reliable and aligned with the actual decision-making process of the model. It helps evaluate interpretability methods in AI systems used in critical applications. <br/><br/>This KPI contributes to evaluating AI trustworthiness, acceptability and trust of the AI-based assistant, as part of Task 4.3 evaluation objectives, and O4 main project objective. ', array['9fc1e90a-54bb-4d43-8cf2-89f5b8751315']::uuid[])
    ON CONFLICT(id) DO UPDATE SET name=EXCLUDED.name, description=EXCLUDED.description, field_ids=EXCLUDED.field_ids;

INSERT INTO field_definitions
        (id, key, description, agg_func, agg_weights)
        VALUES ('9fc1e90a-54bb-4d43-8cf2-89f5b8751315', 'primary', 'Scenario score (raw values)', NULL, NULL)
        ON CONFLICT(id) DO UPDATE SET key=EXCLUDED.key, description=EXCLUDED.description, agg_func=EXCLUDED.agg_func, agg_weights=EXCLUDED.agg_weights;

INSERT INTO benchmark_definitions
    (id, name, description, field_ids, test_ids)
    VALUES ('31ea606b-681a-437a-85b9-7c81d4ccc287', 'Resilience', 'Resilience', array['7284d7ae-8896-4342-bf8c-58db3362e484']::uuid[], array['707a1a4e-7073-432b-94fc-af4a5ee9f07d', '534f5a1f-7115-48a5-b58c-4deb044d425d', '5372decd-6a2a-4c50-bf7a-cd57cfebe3de', '2c4be118-6108-43b3-b09f-a4bee842167a', '04a23bfc-fc44-4ec4-a732-c29214130a83', '2baef867-c1f2-4b6e-b13c-0eac9463c2fa', '2cac54e0-aaf3-4f22-8307-f23878c432f0', '225aaee8-7c7f-4faf-810b-407b551e9f2a', '7b15a7b3-2413-4953-b91a-24f5c0c5b6da', 'd432299f-dbee-46ba-9e15-77954086440a', '7fe4210f-1253-411c-ba03-49d8b37c71fa', 'e3fb76a2-2121-4889-adf2-b60ca29c5c71']::uuid[])
    ON CONFLICT(id) DO UPDATE SET name=EXCLUDED.name, description=EXCLUDED.description, field_ids=EXCLUDED.field_ids, test_ids=EXCLUDED.test_ids;

INSERT INTO field_definitions
        (id, key, description, agg_func, agg_weights)
        VALUES ('7284d7ae-8896-4342-bf8c-58db3362e484', 'primary', 'Benchmark score (MEAN of test scores)', 'MEAN', NULL)
        ON CONFLICT(id) DO UPDATE SET key=EXCLUDED.key, description=EXCLUDED.description, agg_func=EXCLUDED.agg_func, agg_weights=EXCLUDED.agg_weights;

INSERT INTO test_definitions
    (id, name, description, field_ids, scenario_ids, loop, queue)
    VALUES ('707a1a4e-7073-432b-94fc-af4a5ee9f07d', 'KPI-AF-074: Area between reward curves (Railway)', 'Area between reward curves calculates area between the curve corresponding to the reward obtained in each step in an environment where the AI agent has perfect information and the curve for an environment where the agent''s input is perturbed ', array['f0163954-829c-4d4b-b677-995c1ade5a4a']::uuid[], array['a9e3fbf7-b5d5-477d-a0c8-d23880237d2d']::uuid[], 'CLOSED', 'Railway')
    ON CONFLICT(id) DO UPDATE SET name=EXCLUDED.name, description=EXCLUDED.description, field_ids=EXCLUDED.field_ids, scenario_ids=EXCLUDED.scenario_ids, loop=EXCLUDED.loop, queue=EXCLUDED.queue;

INSERT INTO field_definitions
        (id, key, description, agg_func, agg_weights)
        VALUES ('f0163954-829c-4d4b-b677-995c1ade5a4a', 'primary', 'Benchmark score (MEAN of test scores)', 'MEAN', NULL)
        ON CONFLICT(id) DO UPDATE SET key=EXCLUDED.key, description=EXCLUDED.description, agg_func=EXCLUDED.agg_func, agg_weights=EXCLUDED.agg_weights;

INSERT INTO scenario_definitions
    (id, name, description, field_ids)
    VALUES ('a9e3fbf7-b5d5-477d-a0c8-d23880237d2d', 'primary', 'This KPI contributes to evaluating Resilience of the AI-based assistant, as part of Task 4.2 evaluation objectives, and O4 main project objective. ', array['0c62855e-4a6f-487f-a374-da6616523e78']::uuid[])
    ON CONFLICT(id) DO UPDATE SET name=EXCLUDED.name, description=EXCLUDED.description, field_ids=EXCLUDED.field_ids;

INSERT INTO field_definitions
        (id, key, description, agg_func, agg_weights)
        VALUES ('0c62855e-4a6f-487f-a374-da6616523e78', 'primary', 'Scenario score (raw values)', NULL, NULL)
        ON CONFLICT(id) DO UPDATE SET key=EXCLUDED.key, description=EXCLUDED.description, agg_func=EXCLUDED.agg_func, agg_weights=EXCLUDED.agg_weights;

INSERT INTO test_definitions
    (id, name, description, field_ids, scenario_ids, loop, queue)
    VALUES ('534f5a1f-7115-48a5-b58c-4deb044d425d', 'KPI-AF-074: Area between reward curves (Power Grid)', 'Area between reward curves calculates area between the curve corresponding to the reward obtained in each step in an environment where the AI agent has perfect information and the curve for an environment where the agent''s input is perturbed ', array['00fb1d4c-a9b4-4a3f-88ab-eec7f4eb1a76']::uuid[], array['bbcf8224-c768-4469-8ff5-939d977383b4']::uuid[], 'CLOSED', 'PowerGrid')
    ON CONFLICT(id) DO UPDATE SET name=EXCLUDED.name, description=EXCLUDED.description, field_ids=EXCLUDED.field_ids, scenario_ids=EXCLUDED.scenario_ids, loop=EXCLUDED.loop, queue=EXCLUDED.queue;

INSERT INTO field_definitions
        (id, key, description, agg_func, agg_weights)
        VALUES ('00fb1d4c-a9b4-4a3f-88ab-eec7f4eb1a76', 'primary', 'Benchmark score (MEAN of test scores)', 'MEAN', NULL)
        ON CONFLICT(id) DO UPDATE SET key=EXCLUDED.key, description=EXCLUDED.description, agg_func=EXCLUDED.agg_func, agg_weights=EXCLUDED.agg_weights;

INSERT INTO scenario_definitions
    (id, name, description, field_ids)
    VALUES ('bbcf8224-c768-4469-8ff5-939d977383b4', 'primary', 'This KPI contributes to evaluating Resilience of the AI-based assistant, as part of Task 4.2 evaluation objectives, and O4 main project objective. ', array['7d47d27f-5210-4b32-af74-c675f01b7f34']::uuid[])
    ON CONFLICT(id) DO UPDATE SET name=EXCLUDED.name, description=EXCLUDED.description, field_ids=EXCLUDED.field_ids;

INSERT INTO field_definitions
        (id, key, description, agg_func, agg_weights)
        VALUES ('7d47d27f-5210-4b32-af74-c675f01b7f34', 'primary', 'Scenario score (raw values)', NULL, NULL)
        ON CONFLICT(id) DO UPDATE SET key=EXCLUDED.key, description=EXCLUDED.description, agg_func=EXCLUDED.agg_func, agg_weights=EXCLUDED.agg_weights;

INSERT INTO test_definitions
    (id, name, description, field_ids, scenario_ids, loop, queue)
    VALUES ('5372decd-6a2a-4c50-bf7a-cd57cfebe3de', 'KPI-AF-074: Area between reward curves (ATM)', 'Area between reward curves calculates area between the curve corresponding to the reward obtained in each step in an environment where the AI agent has perfect information and the curve for an environment where the agent''s input is perturbed ', array['db803996-450c-4462-a2d0-289e9855ff5d']::uuid[], array['e80a5e55-dc60-459f-bf22-26f196a4711a']::uuid[], 'CLOSED', 'ATM')
    ON CONFLICT(id) DO UPDATE SET name=EXCLUDED.name, description=EXCLUDED.description, field_ids=EXCLUDED.field_ids, scenario_ids=EXCLUDED.scenario_ids, loop=EXCLUDED.loop, queue=EXCLUDED.queue;

INSERT INTO field_definitions
        (id, key, description, agg_func, agg_weights)
        VALUES ('db803996-450c-4462-a2d0-289e9855ff5d', 'primary', 'Benchmark score (MEAN of test scores)', 'MEAN', NULL)
        ON CONFLICT(id) DO UPDATE SET key=EXCLUDED.key, description=EXCLUDED.description, agg_func=EXCLUDED.agg_func, agg_weights=EXCLUDED.agg_weights;

INSERT INTO scenario_definitions
    (id, name, description, field_ids)
    VALUES ('e80a5e55-dc60-459f-bf22-26f196a4711a', 'primary', 'This KPI contributes to evaluating Resilience of the AI-based assistant, as part of Task 4.2 evaluation objectives, and O4 main project objective. ', array['9aa013b5-5b38-40ee-ae5a-5a995ed848b5']::uuid[])
    ON CONFLICT(id) DO UPDATE SET name=EXCLUDED.name, description=EXCLUDED.description, field_ids=EXCLUDED.field_ids;

INSERT INTO field_definitions
        (id, key, description, agg_func, agg_weights)
        VALUES ('9aa013b5-5b38-40ee-ae5a-5a995ed848b5', 'primary', 'Scenario score (raw values)', NULL, NULL)
        ON CONFLICT(id) DO UPDATE SET key=EXCLUDED.key, description=EXCLUDED.description, agg_func=EXCLUDED.agg_func, agg_weights=EXCLUDED.agg_weights;

INSERT INTO test_definitions
    (id, name, description, field_ids, scenario_ids, loop, queue)
    VALUES ('2c4be118-6108-43b3-b09f-a4bee842167a', 'KPI-DF-075: Degradation time (Railway)', 'Number of steps/episodes until reward reaches its lowest point after introducing perturbations to the input of the AI agent ', array['40b5fecc-3ee2-4da9-9f19-3b5c7df27575']::uuid[], array['dc03b9f1-bfb2-44b8-b124-f7eede10e0a7']::uuid[], 'CLOSED', 'Railway')
    ON CONFLICT(id) DO UPDATE SET name=EXCLUDED.name, description=EXCLUDED.description, field_ids=EXCLUDED.field_ids, scenario_ids=EXCLUDED.scenario_ids, loop=EXCLUDED.loop, queue=EXCLUDED.queue;

INSERT INTO field_definitions
        (id, key, description, agg_func, agg_weights)
        VALUES ('40b5fecc-3ee2-4da9-9f19-3b5c7df27575', 'primary', 'Benchmark score (MEAN of test scores)', 'MEAN', NULL)
        ON CONFLICT(id) DO UPDATE SET key=EXCLUDED.key, description=EXCLUDED.description, agg_func=EXCLUDED.agg_func, agg_weights=EXCLUDED.agg_weights;

INSERT INTO scenario_definitions
    (id, name, description, field_ids)
    VALUES ('dc03b9f1-bfb2-44b8-b124-f7eede10e0a7', 'primary', 'This KPI contributes to evaluating Resilience of the AI-based assistant, as part of Task 4.2 evaluation objectives, and O4 main project objective. ', array['6c5d2104-95b2-4dfb-af77-3eccd7416d33']::uuid[])
    ON CONFLICT(id) DO UPDATE SET name=EXCLUDED.name, description=EXCLUDED.description, field_ids=EXCLUDED.field_ids;

INSERT INTO field_definitions
        (id, key, description, agg_func, agg_weights)
        VALUES ('6c5d2104-95b2-4dfb-af77-3eccd7416d33', 'primary', 'Scenario score (raw values)', NULL, NULL)
        ON CONFLICT(id) DO UPDATE SET key=EXCLUDED.key, description=EXCLUDED.description, agg_func=EXCLUDED.agg_func, agg_weights=EXCLUDED.agg_weights;

INSERT INTO test_definitions
    (id, name, description, field_ids, scenario_ids, loop, queue)
    VALUES ('04a23bfc-fc44-4ec4-a732-c29214130a83', 'KPI-DF-075: Degradation time (Power Grid)', 'Number of steps/episodes until reward reaches its lowest point after introducing perturbations to the input of the AI agent ', array['805cc0df-c8f5-4e7d-8a1c-9a1600e18479']::uuid[], array['b355482b-30a2-431e-9536-8e3dd29d06d1']::uuid[], 'CLOSED', 'PowerGrid')
    ON CONFLICT(id) DO UPDATE SET name=EXCLUDED.name, description=EXCLUDED.description, field_ids=EXCLUDED.field_ids, scenario_ids=EXCLUDED.scenario_ids, loop=EXCLUDED.loop, queue=EXCLUDED.queue;

INSERT INTO field_definitions
        (id, key, description, agg_func, agg_weights)
        VALUES ('805cc0df-c8f5-4e7d-8a1c-9a1600e18479', 'primary', 'Benchmark score (MEAN of test scores)', 'MEAN', NULL)
        ON CONFLICT(id) DO UPDATE SET key=EXCLUDED.key, description=EXCLUDED.description, agg_func=EXCLUDED.agg_func, agg_weights=EXCLUDED.agg_weights;

INSERT INTO scenario_definitions
    (id, name, description, field_ids)
    VALUES ('b355482b-30a2-431e-9536-8e3dd29d06d1', 'primary', 'This KPI contributes to evaluating Resilience of the AI-based assistant, as part of Task 4.2 evaluation objectives, and O4 main project objective. ', array['e52742ce-a6f6-46c9-9806-83bd9d036cce']::uuid[])
    ON CONFLICT(id) DO UPDATE SET name=EXCLUDED.name, description=EXCLUDED.description, field_ids=EXCLUDED.field_ids;

INSERT INTO field_definitions
        (id, key, description, agg_func, agg_weights)
        VALUES ('e52742ce-a6f6-46c9-9806-83bd9d036cce', 'primary', 'Scenario score (raw values)', NULL, NULL)
        ON CONFLICT(id) DO UPDATE SET key=EXCLUDED.key, description=EXCLUDED.description, agg_func=EXCLUDED.agg_func, agg_weights=EXCLUDED.agg_weights;

INSERT INTO test_definitions
    (id, name, description, field_ids, scenario_ids, loop, queue)
    VALUES ('2baef867-c1f2-4b6e-b13c-0eac9463c2fa', 'KPI-DF-075: Degradation time (ATM)', 'Number of steps/episodes until reward reaches its lowest point after introducing perturbations to the input of the AI agent ', array['643d28e7-3ec1-45f8-aed8-5364e65a0c05']::uuid[], array['2aaed2a4-7dd9-4ea6-a2df-e3ef2207680a']::uuid[], 'CLOSED', 'ATM')
    ON CONFLICT(id) DO UPDATE SET name=EXCLUDED.name, description=EXCLUDED.description, field_ids=EXCLUDED.field_ids, scenario_ids=EXCLUDED.scenario_ids, loop=EXCLUDED.loop, queue=EXCLUDED.queue;

INSERT INTO field_definitions
        (id, key, description, agg_func, agg_weights)
        VALUES ('643d28e7-3ec1-45f8-aed8-5364e65a0c05', 'primary', 'Benchmark score (MEAN of test scores)', 'MEAN', NULL)
        ON CONFLICT(id) DO UPDATE SET key=EXCLUDED.key, description=EXCLUDED.description, agg_func=EXCLUDED.agg_func, agg_weights=EXCLUDED.agg_weights;

INSERT INTO scenario_definitions
    (id, name, description, field_ids)
    VALUES ('2aaed2a4-7dd9-4ea6-a2df-e3ef2207680a', 'primary', 'This KPI contributes to evaluating Resilience of the AI-based assistant, as part of Task 4.2 evaluation objectives, and O4 main project objective. ', array['23b4c9ee-0dec-4e36-b755-15aa29cf5b91']::uuid[])
    ON CONFLICT(id) DO UPDATE SET name=EXCLUDED.name, description=EXCLUDED.description, field_ids=EXCLUDED.field_ids;

INSERT INTO field_definitions
        (id, key, description, agg_func, agg_weights)
        VALUES ('23b4c9ee-0dec-4e36-b755-15aa29cf5b91', 'primary', 'Scenario score (raw values)', NULL, NULL)
        ON CONFLICT(id) DO UPDATE SET key=EXCLUDED.key, description=EXCLUDED.description, agg_func=EXCLUDED.agg_func, agg_weights=EXCLUDED.agg_weights;

INSERT INTO test_definitions
    (id, name, description, field_ids, scenario_ids, loop, queue)
    VALUES ('2cac54e0-aaf3-4f22-8307-f23878c432f0', 'KPI-RF-076: Restorative time (Railway)', 'Number of steps/episodes until reward recovers to its highest point after reaching the lowest point after introducing perturbations to the input of the AI agent ', array['c6d7099f-9893-4d76-8fcd-f6cba430b690']::uuid[], array['56160b90-a287-4dec-acc7-f40967d60fa0']::uuid[], 'CLOSED', 'Railway')
    ON CONFLICT(id) DO UPDATE SET name=EXCLUDED.name, description=EXCLUDED.description, field_ids=EXCLUDED.field_ids, scenario_ids=EXCLUDED.scenario_ids, loop=EXCLUDED.loop, queue=EXCLUDED.queue;

INSERT INTO field_definitions
        (id, key, description, agg_func, agg_weights)
        VALUES ('c6d7099f-9893-4d76-8fcd-f6cba430b690', 'primary', 'Benchmark score (MEAN of test scores)', 'MEAN', NULL)
        ON CONFLICT(id) DO UPDATE SET key=EXCLUDED.key, description=EXCLUDED.description, agg_func=EXCLUDED.agg_func, agg_weights=EXCLUDED.agg_weights;

INSERT INTO scenario_definitions
    (id, name, description, field_ids)
    VALUES ('56160b90-a287-4dec-acc7-f40967d60fa0', 'primary', 'This KPI contributes to evaluating Resilience of the AI-based assistant, as part of Task 4.2 evaluation objectives, and O4 main project objective. ', array['fb1b87be-26a3-48f2-bb69-d98e341ed128']::uuid[])
    ON CONFLICT(id) DO UPDATE SET name=EXCLUDED.name, description=EXCLUDED.description, field_ids=EXCLUDED.field_ids;

INSERT INTO field_definitions
        (id, key, description, agg_func, agg_weights)
        VALUES ('fb1b87be-26a3-48f2-bb69-d98e341ed128', 'primary', 'Scenario score (raw values)', NULL, NULL)
        ON CONFLICT(id) DO UPDATE SET key=EXCLUDED.key, description=EXCLUDED.description, agg_func=EXCLUDED.agg_func, agg_weights=EXCLUDED.agg_weights;

INSERT INTO test_definitions
    (id, name, description, field_ids, scenario_ids, loop, queue)
    VALUES ('225aaee8-7c7f-4faf-810b-407b551e9f2a', 'KPI-RF-076: Restorative time (Power Grid)', 'Number of steps/episodes until reward recovers to its highest point after reaching the lowest point after introducing perturbations to the input of the AI agent ', array['a6fcdd38-158e-4865-9300-4b061553dcab']::uuid[], array['2eaf04e3-090a-4c13-b923-ac86de1b6db1']::uuid[], 'CLOSED', 'PowerGrid')
    ON CONFLICT(id) DO UPDATE SET name=EXCLUDED.name, description=EXCLUDED.description, field_ids=EXCLUDED.field_ids, scenario_ids=EXCLUDED.scenario_ids, loop=EXCLUDED.loop, queue=EXCLUDED.queue;

INSERT INTO field_definitions
        (id, key, description, agg_func, agg_weights)
        VALUES ('a6fcdd38-158e-4865-9300-4b061553dcab', 'primary', 'Benchmark score (MEAN of test scores)', 'MEAN', NULL)
        ON CONFLICT(id) DO UPDATE SET key=EXCLUDED.key, description=EXCLUDED.description, agg_func=EXCLUDED.agg_func, agg_weights=EXCLUDED.agg_weights;

INSERT INTO scenario_definitions
    (id, name, description, field_ids)
    VALUES ('2eaf04e3-090a-4c13-b923-ac86de1b6db1', 'primary', 'This KPI contributes to evaluating Resilience of the AI-based assistant, as part of Task 4.2 evaluation objectives, and O4 main project objective. ', array['0c79911b-29de-4f7f-bca6-820ef7f28f34']::uuid[])
    ON CONFLICT(id) DO UPDATE SET name=EXCLUDED.name, description=EXCLUDED.description, field_ids=EXCLUDED.field_ids;

INSERT INTO field_definitions
        (id, key, description, agg_func, agg_weights)
        VALUES ('0c79911b-29de-4f7f-bca6-820ef7f28f34', 'primary', 'Scenario score (raw values)', NULL, NULL)
        ON CONFLICT(id) DO UPDATE SET key=EXCLUDED.key, description=EXCLUDED.description, agg_func=EXCLUDED.agg_func, agg_weights=EXCLUDED.agg_weights;

INSERT INTO test_definitions
    (id, name, description, field_ids, scenario_ids, loop, queue)
    VALUES ('7b15a7b3-2413-4953-b91a-24f5c0c5b6da', 'KPI-RF-076: Restorative time (ATM)', 'Number of steps/episodes until reward recovers to its highest point after reaching the lowest point after introducing perturbations to the input of the AI agent ', array['58733189-5333-46a5-a759-21ecd5e9a5e7']::uuid[], array['00e749d7-baa3-4b24-8092-d3dd69cdea58']::uuid[], 'CLOSED', 'ATM')
    ON CONFLICT(id) DO UPDATE SET name=EXCLUDED.name, description=EXCLUDED.description, field_ids=EXCLUDED.field_ids, scenario_ids=EXCLUDED.scenario_ids, loop=EXCLUDED.loop, queue=EXCLUDED.queue;

INSERT INTO field_definitions
        (id, key, description, agg_func, agg_weights)
        VALUES ('58733189-5333-46a5-a759-21ecd5e9a5e7', 'primary', 'Benchmark score (MEAN of test scores)', 'MEAN', NULL)
        ON CONFLICT(id) DO UPDATE SET key=EXCLUDED.key, description=EXCLUDED.description, agg_func=EXCLUDED.agg_func, agg_weights=EXCLUDED.agg_weights;

INSERT INTO scenario_definitions
    (id, name, description, field_ids)
    VALUES ('00e749d7-baa3-4b24-8092-d3dd69cdea58', 'primary', 'This KPI contributes to evaluating Resilience of the AI-based assistant, as part of Task 4.2 evaluation objectives, and O4 main project objective. ', array['b75f5075-8c72-49b2-bbb7-523cf3757b17']::uuid[])
    ON CONFLICT(id) DO UPDATE SET name=EXCLUDED.name, description=EXCLUDED.description, field_ids=EXCLUDED.field_ids;

INSERT INTO field_definitions
        (id, key, description, agg_func, agg_weights)
        VALUES ('b75f5075-8c72-49b2-bbb7-523cf3757b17', 'primary', 'Scenario score (raw values)', NULL, NULL)
        ON CONFLICT(id) DO UPDATE SET key=EXCLUDED.key, description=EXCLUDED.description, agg_func=EXCLUDED.agg_func, agg_weights=EXCLUDED.agg_weights;

INSERT INTO test_definitions
    (id, name, description, field_ids, scenario_ids, loop, queue)
    VALUES ('d432299f-dbee-46ba-9e15-77954086440a', 'KPI-SF-077: Similarity state to unperturbed situation (Railway)', 'Similarity state to unperturbed situation KPI measures similarity of the state in an environment where AI agent''s input is perturbed to the state in the same context of an environment with perfect information ', array['0b8ffb01-5523-482f-81c2-47a81c626ab2']::uuid[], array['367a8b12-1b87-42f1-9400-4ecf96d6b617']::uuid[], 'CLOSED', 'Railway')
    ON CONFLICT(id) DO UPDATE SET name=EXCLUDED.name, description=EXCLUDED.description, field_ids=EXCLUDED.field_ids, scenario_ids=EXCLUDED.scenario_ids, loop=EXCLUDED.loop, queue=EXCLUDED.queue;

INSERT INTO field_definitions
        (id, key, description, agg_func, agg_weights)
        VALUES ('0b8ffb01-5523-482f-81c2-47a81c626ab2', 'primary', 'Benchmark score (MEAN of test scores)', 'MEAN', NULL)
        ON CONFLICT(id) DO UPDATE SET key=EXCLUDED.key, description=EXCLUDED.description, agg_func=EXCLUDED.agg_func, agg_weights=EXCLUDED.agg_weights;

INSERT INTO scenario_definitions
    (id, name, description, field_ids)
    VALUES ('367a8b12-1b87-42f1-9400-4ecf96d6b617', 'primary', 'This KPI contributes to evaluating Resilience of the AI-based assistant, as part of Task 4.2 evaluation objectives, and O4 main project objective. ', array['7929ff8d-5b64-48e1-ab5c-ebb398917ce3']::uuid[])
    ON CONFLICT(id) DO UPDATE SET name=EXCLUDED.name, description=EXCLUDED.description, field_ids=EXCLUDED.field_ids;

INSERT INTO field_definitions
        (id, key, description, agg_func, agg_weights)
        VALUES ('7929ff8d-5b64-48e1-ab5c-ebb398917ce3', 'primary', 'Scenario score (raw values)', NULL, NULL)
        ON CONFLICT(id) DO UPDATE SET key=EXCLUDED.key, description=EXCLUDED.description, agg_func=EXCLUDED.agg_func, agg_weights=EXCLUDED.agg_weights;

INSERT INTO test_definitions
    (id, name, description, field_ids, scenario_ids, loop, queue)
    VALUES ('7fe4210f-1253-411c-ba03-49d8b37c71fa', 'KPI-SF-077: Similarity state to unperturbed situation (Power Grid)', 'Similarity state to unperturbed situation KPI measures similarity of the state in an environment where AI agent''s input is perturbed to the state in the same context of an environment with perfect information ', array['36601f97-1681-43ac-a07c-c4cfbb4b3ede']::uuid[], array['4523d73e-427a-42a1-b841-c9668373fafb']::uuid[], 'CLOSED', 'PowerGrid')
    ON CONFLICT(id) DO UPDATE SET name=EXCLUDED.name, description=EXCLUDED.description, field_ids=EXCLUDED.field_ids, scenario_ids=EXCLUDED.scenario_ids, loop=EXCLUDED.loop, queue=EXCLUDED.queue;

INSERT INTO field_definitions
        (id, key, description, agg_func, agg_weights)
        VALUES ('36601f97-1681-43ac-a07c-c4cfbb4b3ede', 'primary', 'Benchmark score (MEAN of test scores)', 'MEAN', NULL)
        ON CONFLICT(id) DO UPDATE SET key=EXCLUDED.key, description=EXCLUDED.description, agg_func=EXCLUDED.agg_func, agg_weights=EXCLUDED.agg_weights;

INSERT INTO scenario_definitions
    (id, name, description, field_ids)
    VALUES ('4523d73e-427a-42a1-b841-c9668373fafb', 'primary', 'This KPI contributes to evaluating Resilience of the AI-based assistant, as part of Task 4.2 evaluation objectives, and O4 main project objective. ', array['5e04f982-70cf-402b-aeac-ee1184c336ba']::uuid[])
    ON CONFLICT(id) DO UPDATE SET name=EXCLUDED.name, description=EXCLUDED.description, field_ids=EXCLUDED.field_ids;

INSERT INTO field_definitions
        (id, key, description, agg_func, agg_weights)
        VALUES ('5e04f982-70cf-402b-aeac-ee1184c336ba', 'primary', 'Scenario score (raw values)', NULL, NULL)
        ON CONFLICT(id) DO UPDATE SET key=EXCLUDED.key, description=EXCLUDED.description, agg_func=EXCLUDED.agg_func, agg_weights=EXCLUDED.agg_weights;

INSERT INTO test_definitions
    (id, name, description, field_ids, scenario_ids, loop, queue)
    VALUES ('e3fb76a2-2121-4889-adf2-b60ca29c5c71', 'KPI-SF-077: Similarity state to unperturbed situation (ATM)', 'Similarity state to unperturbed situation KPI measures similarity of the state in an environment where AI agent''s input is perturbed to the state in the same context of an environment with perfect information ', array['b6b65966-5f68-4e31-879c-5f237220a8b4']::uuid[], array['afc812fc-e4f3-4380-a856-9987bc557d5c']::uuid[], 'CLOSED', 'ATM')
    ON CONFLICT(id) DO UPDATE SET name=EXCLUDED.name, description=EXCLUDED.description, field_ids=EXCLUDED.field_ids, scenario_ids=EXCLUDED.scenario_ids, loop=EXCLUDED.loop, queue=EXCLUDED.queue;

INSERT INTO field_definitions
        (id, key, description, agg_func, agg_weights)
        VALUES ('b6b65966-5f68-4e31-879c-5f237220a8b4', 'primary', 'Benchmark score (MEAN of test scores)', 'MEAN', NULL)
        ON CONFLICT(id) DO UPDATE SET key=EXCLUDED.key, description=EXCLUDED.description, agg_func=EXCLUDED.agg_func, agg_weights=EXCLUDED.agg_weights;

INSERT INTO scenario_definitions
    (id, name, description, field_ids)
    VALUES ('afc812fc-e4f3-4380-a856-9987bc557d5c', 'primary', 'This KPI contributes to evaluating Resilience of the AI-based assistant, as part of Task 4.2 evaluation objectives, and O4 main project objective. ', array['0bc0cca0-d4db-4d28-b5f9-74609d12fef8']::uuid[])
    ON CONFLICT(id) DO UPDATE SET name=EXCLUDED.name, description=EXCLUDED.description, field_ids=EXCLUDED.field_ids;

INSERT INTO field_definitions
        (id, key, description, agg_func, agg_weights)
        VALUES ('0bc0cca0-d4db-4d28-b5f9-74609d12fef8', 'primary', 'Scenario score (raw values)', NULL, NULL)
        ON CONFLICT(id) DO UPDATE SET key=EXCLUDED.key, description=EXCLUDED.description, agg_func=EXCLUDED.agg_func, agg_weights=EXCLUDED.agg_weights;

INSERT INTO benchmark_definitions
    (id, name, description, field_ids, test_ids)
    VALUES ('df309815-8ec0-4a6f-9d0b-dc3dbfc9055a', 'Long-term consequences of AI assistants', 'Long-term consequences of AI assistants', array['7cfd40ba-89d3-49e5-8bb9-c3e982d0dd10']::uuid[], array['9e680ab9-c861-4dd7-a5ea-abbdc1a91088', '0eb49c18-fbf7-4797-b4c5-6dabc9795ddb', '4847c6f6-123d-4f5c-ab7c-6ff63b5407e5', '8eb804ef-d122-4c59-a6b3-53f3c9664d2b', 'b7d124f7-998a-416e-81a0-424cb6192755', '1f368c52-2c18-4658-a5b7-c2524e90b9dc', '8f5a1908-6319-4e2a-a43b-6528c7c5e92e', 'e860b491-42b1-416a-b2fb-bea9bd8a249d', '8de9a511-8d9e-4289-a78b-0004737443c9', 'a6a54b1d-54bf-4b09-9887-706eed3e1a57', 'ff1099da-8b25-4dff-8f64-c7ce1d5c9d9d', '7ce3a25e-219c-4146-b2a7-c4f46bc7b137', '0d898adb-7378-4ddd-8afa-a7136f13e3fa', 'afa5288f-3a6f-4933-8bd9-1761d4c97c34', '81b57209-24e3-4213-a93f-8129b3ca1c1c', 'be770a02-c8be-4774-97b6-bc15e91b2fd8', 'b67c3a5a-c157-420c-9d3c-8c949413a79b', '733c3705-a1a3-45e1-9fd6-b19e9627bf50', '2c71e014-3994-4413-a469-e27b0d1e121d', 'f322d495-95e0-49ab-9439-156228593328', 'de69aa29-4aa0-4473-918e-14004116a9dc']::uuid[])
    ON CONFLICT(id) DO UPDATE SET name=EXCLUDED.name, description=EXCLUDED.description, field_ids=EXCLUDED.field_ids, test_ids=EXCLUDED.test_ids;

INSERT INTO field_definitions
        (id, key, description, agg_func, agg_weights)
        VALUES ('7cfd40ba-89d3-49e5-8bb9-c3e982d0dd10', 'primary', 'Benchmark score (MEAN of test scores)', 'MEAN', NULL)
        ON CONFLICT(id) DO UPDATE SET key=EXCLUDED.key, description=EXCLUDED.description, agg_func=EXCLUDED.agg_func, agg_weights=EXCLUDED.agg_weights;

INSERT INTO test_definitions
    (id, name, description, field_ids, scenario_ids, loop, queue)
    VALUES ('9e680ab9-c861-4dd7-a5ea-abbdc1a91088', 'KPI-RS-091: Reflection on operator trust  (Railway)', 'This KPI represents self-reported human operators’ perception of the changes in their trust for the AI assistant over time (increased/decreased) on a Likert scale. ', array['345b6241-acd6-4d1f-b04d-ccb2b98a84bf']::uuid[], array['e9e537cc-a8d0-4864-9460-9098c72b269f']::uuid[], 'OFFLINE', 'Railway')
    ON CONFLICT(id) DO UPDATE SET name=EXCLUDED.name, description=EXCLUDED.description, field_ids=EXCLUDED.field_ids, scenario_ids=EXCLUDED.scenario_ids, loop=EXCLUDED.loop, queue=EXCLUDED.queue;

INSERT INTO field_definitions
        (id, key, description, agg_func, agg_weights)
        VALUES ('345b6241-acd6-4d1f-b04d-ccb2b98a84bf', 'primary', 'Benchmark score (MEAN of test scores)', 'MEAN', NULL)
        ON CONFLICT(id) DO UPDATE SET key=EXCLUDED.key, description=EXCLUDED.description, agg_func=EXCLUDED.agg_func, agg_weights=EXCLUDED.agg_weights;

INSERT INTO scenario_definitions
    (id, name, description, field_ids)
    VALUES ('e9e537cc-a8d0-4864-9460-9098c72b269f', 'primary', 'This KPI contributes to evaluating Long-term consequences of AI assistants of the AI-based assistant, as part of Task 4.3 evaluation objectives, and O3 main project objective. <br/>It is also relevant to protocols and concepts defined in D1.1 such as “Transparency”, “Human Agency and Oversight”, “Credibility and Intimacy”. Furthermore, it is also relevant to the overall project KPI-ET-7 "% of acceptance of human operators regarding AI4REALNET solutions". ', array['90fb4912-29b4-468c-80f9-66221b97b575']::uuid[])
    ON CONFLICT(id) DO UPDATE SET name=EXCLUDED.name, description=EXCLUDED.description, field_ids=EXCLUDED.field_ids;

INSERT INTO field_definitions
        (id, key, description, agg_func, agg_weights)
        VALUES ('90fb4912-29b4-468c-80f9-66221b97b575', 'primary', 'Scenario score (raw values)', NULL, NULL)
        ON CONFLICT(id) DO UPDATE SET key=EXCLUDED.key, description=EXCLUDED.description, agg_func=EXCLUDED.agg_func, agg_weights=EXCLUDED.agg_weights;

INSERT INTO test_definitions
    (id, name, description, field_ids, scenario_ids, loop, queue)
    VALUES ('0eb49c18-fbf7-4797-b4c5-6dabc9795ddb', 'KPI-RS-091: Reflection on operator trust  (Power Grid)', 'This KPI represents self-reported human operators’ perception of the changes in their trust for the AI assistant over time (increased/decreased) on a Likert scale. ', array['955e3993-0196-477e-8362-adcb2cc929e0']::uuid[], array['b26f54c0-146a-473c-82a6-fcecbedc9cbc']::uuid[], 'OFFLINE', 'PowerGrid')
    ON CONFLICT(id) DO UPDATE SET name=EXCLUDED.name, description=EXCLUDED.description, field_ids=EXCLUDED.field_ids, scenario_ids=EXCLUDED.scenario_ids, loop=EXCLUDED.loop, queue=EXCLUDED.queue;

INSERT INTO field_definitions
        (id, key, description, agg_func, agg_weights)
        VALUES ('955e3993-0196-477e-8362-adcb2cc929e0', 'primary', 'Benchmark score (MEAN of test scores)', 'MEAN', NULL)
        ON CONFLICT(id) DO UPDATE SET key=EXCLUDED.key, description=EXCLUDED.description, agg_func=EXCLUDED.agg_func, agg_weights=EXCLUDED.agg_weights;

INSERT INTO scenario_definitions
    (id, name, description, field_ids)
    VALUES ('b26f54c0-146a-473c-82a6-fcecbedc9cbc', 'primary', 'This KPI contributes to evaluating Long-term consequences of AI assistants of the AI-based assistant, as part of Task 4.3 evaluation objectives, and O3 main project objective. <br/>It is also relevant to protocols and concepts defined in D1.1 such as “Transparency”, “Human Agency and Oversight”, “Credibility and Intimacy”. Furthermore, it is also relevant to the overall project KPI-ET-7 "% of acceptance of human operators regarding AI4REALNET solutions". ', array['ca679741-cbb3-4d96-b688-dd817693a94c']::uuid[])
    ON CONFLICT(id) DO UPDATE SET name=EXCLUDED.name, description=EXCLUDED.description, field_ids=EXCLUDED.field_ids;

INSERT INTO field_definitions
        (id, key, description, agg_func, agg_weights)
        VALUES ('ca679741-cbb3-4d96-b688-dd817693a94c', 'primary', 'Scenario score (raw values)', NULL, NULL)
        ON CONFLICT(id) DO UPDATE SET key=EXCLUDED.key, description=EXCLUDED.description, agg_func=EXCLUDED.agg_func, agg_weights=EXCLUDED.agg_weights;

INSERT INTO test_definitions
    (id, name, description, field_ids, scenario_ids, loop, queue)
    VALUES ('4847c6f6-123d-4f5c-ab7c-6ff63b5407e5', 'KPI-RS-091: Reflection on operator trust  (ATM)', 'This KPI represents self-reported human operators’ perception of the changes in their trust for the AI assistant over time (increased/decreased) on a Likert scale. ', array['df393b26-77dd-45e2-9e1f-11e2a603b714']::uuid[], array['12e1531b-8525-408d-b800-1d0df54f84bb']::uuid[], 'OFFLINE', 'ATM')
    ON CONFLICT(id) DO UPDATE SET name=EXCLUDED.name, description=EXCLUDED.description, field_ids=EXCLUDED.field_ids, scenario_ids=EXCLUDED.scenario_ids, loop=EXCLUDED.loop, queue=EXCLUDED.queue;

INSERT INTO field_definitions
        (id, key, description, agg_func, agg_weights)
        VALUES ('df393b26-77dd-45e2-9e1f-11e2a603b714', 'primary', 'Benchmark score (MEAN of test scores)', 'MEAN', NULL)
        ON CONFLICT(id) DO UPDATE SET key=EXCLUDED.key, description=EXCLUDED.description, agg_func=EXCLUDED.agg_func, agg_weights=EXCLUDED.agg_weights;

INSERT INTO scenario_definitions
    (id, name, description, field_ids)
    VALUES ('12e1531b-8525-408d-b800-1d0df54f84bb', 'primary', 'This KPI contributes to evaluating Long-term consequences of AI assistants of the AI-based assistant, as part of Task 4.3 evaluation objectives, and O3 main project objective. <br/>It is also relevant to protocols and concepts defined in D1.1 such as “Transparency”, “Human Agency and Oversight”, “Credibility and Intimacy”. Furthermore, it is also relevant to the overall project KPI-ET-7 "% of acceptance of human operators regarding AI4REALNET solutions". ', array['89f5fc6a-2365-43d0-949d-63474e6bfc04']::uuid[])
    ON CONFLICT(id) DO UPDATE SET name=EXCLUDED.name, description=EXCLUDED.description, field_ids=EXCLUDED.field_ids;

INSERT INTO field_definitions
        (id, key, description, agg_func, agg_weights)
        VALUES ('89f5fc6a-2365-43d0-949d-63474e6bfc04', 'primary', 'Scenario score (raw values)', NULL, NULL)
        ON CONFLICT(id) DO UPDATE SET key=EXCLUDED.key, description=EXCLUDED.description, agg_func=EXCLUDED.agg_func, agg_weights=EXCLUDED.agg_weights;

INSERT INTO test_definitions
    (id, name, description, field_ids, scenario_ids, loop, queue)
    VALUES ('8eb804ef-d122-4c59-a6b3-53f3c9664d2b', 'KPI-RS-092: Reflection on operator agency  (Railway)', 'This KPI represents self-reported human operators’ perception of the changes in their agency working with the AI assistant over time (increased/decreased) on a Likert scale. ', array['b7a35c88-5413-4abb-bae0-774a27b3c84e']::uuid[], array['1ce89667-c4c2-483d-8ed1-c7add0a24b4b']::uuid[], 'OFFLINE', 'Railway')
    ON CONFLICT(id) DO UPDATE SET name=EXCLUDED.name, description=EXCLUDED.description, field_ids=EXCLUDED.field_ids, scenario_ids=EXCLUDED.scenario_ids, loop=EXCLUDED.loop, queue=EXCLUDED.queue;

INSERT INTO field_definitions
        (id, key, description, agg_func, agg_weights)
        VALUES ('b7a35c88-5413-4abb-bae0-774a27b3c84e', 'primary', 'Benchmark score (MEAN of test scores)', 'MEAN', NULL)
        ON CONFLICT(id) DO UPDATE SET key=EXCLUDED.key, description=EXCLUDED.description, agg_func=EXCLUDED.agg_func, agg_weights=EXCLUDED.agg_weights;

INSERT INTO scenario_definitions
    (id, name, description, field_ids)
    VALUES ('1ce89667-c4c2-483d-8ed1-c7add0a24b4b', 'primary', 'This KPI contributes to evaluating Long-term consequences of AI assistants of the AI-based assistant, as part of Task 4.3 evaluation objectives, and O3 main project objective.  <br/>It is also relevant to protocols and concepts defined in D1.1 such as “Transparency”, “Decision support for the human operator”, “Human Agency and Oversight”.  ', array['9f07e590-75bd-4fe2-a0b7-fb4826d1280a']::uuid[])
    ON CONFLICT(id) DO UPDATE SET name=EXCLUDED.name, description=EXCLUDED.description, field_ids=EXCLUDED.field_ids;

INSERT INTO field_definitions
        (id, key, description, agg_func, agg_weights)
        VALUES ('9f07e590-75bd-4fe2-a0b7-fb4826d1280a', 'primary', 'Scenario score (raw values)', NULL, NULL)
        ON CONFLICT(id) DO UPDATE SET key=EXCLUDED.key, description=EXCLUDED.description, agg_func=EXCLUDED.agg_func, agg_weights=EXCLUDED.agg_weights;

INSERT INTO test_definitions
    (id, name, description, field_ids, scenario_ids, loop, queue)
    VALUES ('b7d124f7-998a-416e-81a0-424cb6192755', 'KPI-RS-092: Reflection on operator agency  (Power Grid)', 'This KPI represents self-reported human operators’ perception of the changes in their agency working with the AI assistant over time (increased/decreased) on a Likert scale. ', array['1ac0bc44-71c0-427b-bc1e-b7a177809ad7']::uuid[], array['284e2178-d34c-4dcb-8868-21b4d2310744']::uuid[], 'OFFLINE', 'PowerGrid')
    ON CONFLICT(id) DO UPDATE SET name=EXCLUDED.name, description=EXCLUDED.description, field_ids=EXCLUDED.field_ids, scenario_ids=EXCLUDED.scenario_ids, loop=EXCLUDED.loop, queue=EXCLUDED.queue;

INSERT INTO field_definitions
        (id, key, description, agg_func, agg_weights)
        VALUES ('1ac0bc44-71c0-427b-bc1e-b7a177809ad7', 'primary', 'Benchmark score (MEAN of test scores)', 'MEAN', NULL)
        ON CONFLICT(id) DO UPDATE SET key=EXCLUDED.key, description=EXCLUDED.description, agg_func=EXCLUDED.agg_func, agg_weights=EXCLUDED.agg_weights;

INSERT INTO scenario_definitions
    (id, name, description, field_ids)
    VALUES ('284e2178-d34c-4dcb-8868-21b4d2310744', 'primary', 'This KPI contributes to evaluating Long-term consequences of AI assistants of the AI-based assistant, as part of Task 4.3 evaluation objectives, and O3 main project objective.  <br/>It is also relevant to protocols and concepts defined in D1.1 such as “Transparency”, “Decision support for the human operator”, “Human Agency and Oversight”.  ', array['f06cdfb0-7ba6-4463-8633-d38cc856c75a']::uuid[])
    ON CONFLICT(id) DO UPDATE SET name=EXCLUDED.name, description=EXCLUDED.description, field_ids=EXCLUDED.field_ids;

INSERT INTO field_definitions
        (id, key, description, agg_func, agg_weights)
        VALUES ('f06cdfb0-7ba6-4463-8633-d38cc856c75a', 'primary', 'Scenario score (raw values)', NULL, NULL)
        ON CONFLICT(id) DO UPDATE SET key=EXCLUDED.key, description=EXCLUDED.description, agg_func=EXCLUDED.agg_func, agg_weights=EXCLUDED.agg_weights;

INSERT INTO test_definitions
    (id, name, description, field_ids, scenario_ids, loop, queue)
    VALUES ('1f368c52-2c18-4658-a5b7-c2524e90b9dc', 'KPI-RS-092: Reflection on operator agency  (ATM)', 'This KPI represents self-reported human operators’ perception of the changes in their agency working with the AI assistant over time (increased/decreased) on a Likert scale. ', array['e9d6451c-c25b-49e5-a80e-cd84985b3c7c']::uuid[], array['5afb6acf-df83-47e9-9e7e-cdfb85a3c5de']::uuid[], 'OFFLINE', 'ATM')
    ON CONFLICT(id) DO UPDATE SET name=EXCLUDED.name, description=EXCLUDED.description, field_ids=EXCLUDED.field_ids, scenario_ids=EXCLUDED.scenario_ids, loop=EXCLUDED.loop, queue=EXCLUDED.queue;

INSERT INTO field_definitions
        (id, key, description, agg_func, agg_weights)
        VALUES ('e9d6451c-c25b-49e5-a80e-cd84985b3c7c', 'primary', 'Benchmark score (MEAN of test scores)', 'MEAN', NULL)
        ON CONFLICT(id) DO UPDATE SET key=EXCLUDED.key, description=EXCLUDED.description, agg_func=EXCLUDED.agg_func, agg_weights=EXCLUDED.agg_weights;

INSERT INTO scenario_definitions
    (id, name, description, field_ids)
    VALUES ('5afb6acf-df83-47e9-9e7e-cdfb85a3c5de', 'primary', 'This KPI contributes to evaluating Long-term consequences of AI assistants of the AI-based assistant, as part of Task 4.3 evaluation objectives, and O3 main project objective.  <br/>It is also relevant to protocols and concepts defined in D1.1 such as “Transparency”, “Decision support for the human operator”, “Human Agency and Oversight”.  ', array['ab2a6648-8405-4490-b868-5231ec741cc8']::uuid[])
    ON CONFLICT(id) DO UPDATE SET name=EXCLUDED.name, description=EXCLUDED.description, field_ids=EXCLUDED.field_ids;

INSERT INTO field_definitions
        (id, key, description, agg_func, agg_weights)
        VALUES ('ab2a6648-8405-4490-b868-5231ec741cc8', 'primary', 'Scenario score (raw values)', NULL, NULL)
        ON CONFLICT(id) DO UPDATE SET key=EXCLUDED.key, description=EXCLUDED.description, agg_func=EXCLUDED.agg_func, agg_weights=EXCLUDED.agg_weights;

INSERT INTO test_definitions
    (id, name, description, field_ids, scenario_ids, loop, queue)
    VALUES ('8f5a1908-6319-4e2a-a43b-6528c7c5e92e', 'KPI-RS-093: Reflection on operator de-skilling  (Railway)', 'This KPI represents self-reported human operators’ perception of the changes in their own skills working with the AI assistant over time (increased/decreased) on a Likert scale. ', array['435e4d59-237c-43c9-94bc-f1851d03e7d1']::uuid[], array['e283be95-96da-4f69-8869-06ab82ee2c45']::uuid[], 'OFFLINE', 'Railway')
    ON CONFLICT(id) DO UPDATE SET name=EXCLUDED.name, description=EXCLUDED.description, field_ids=EXCLUDED.field_ids, scenario_ids=EXCLUDED.scenario_ids, loop=EXCLUDED.loop, queue=EXCLUDED.queue;

INSERT INTO field_definitions
        (id, key, description, agg_func, agg_weights)
        VALUES ('435e4d59-237c-43c9-94bc-f1851d03e7d1', 'primary', 'Benchmark score (MEAN of test scores)', 'MEAN', NULL)
        ON CONFLICT(id) DO UPDATE SET key=EXCLUDED.key, description=EXCLUDED.description, agg_func=EXCLUDED.agg_func, agg_weights=EXCLUDED.agg_weights;

INSERT INTO scenario_definitions
    (id, name, description, field_ids)
    VALUES ('e283be95-96da-4f69-8869-06ab82ee2c45', 'primary', 'This KPI contributes to evaluating Long-term consequences of AI assistants of the AI-based assistant, as part of Task 4.3 evaluation objectives, and O3 main project objective. <br/>It is also relevant to protocols and concepts defined in D1.1 such as “Mitigate de-skilling in the human operators”. ', array['a7c602c7-736c-4dd0-b4e4-f2199d1d6014']::uuid[])
    ON CONFLICT(id) DO UPDATE SET name=EXCLUDED.name, description=EXCLUDED.description, field_ids=EXCLUDED.field_ids;

INSERT INTO field_definitions
        (id, key, description, agg_func, agg_weights)
        VALUES ('a7c602c7-736c-4dd0-b4e4-f2199d1d6014', 'primary', 'Scenario score (raw values)', NULL, NULL)
        ON CONFLICT(id) DO UPDATE SET key=EXCLUDED.key, description=EXCLUDED.description, agg_func=EXCLUDED.agg_func, agg_weights=EXCLUDED.agg_weights;

INSERT INTO test_definitions
    (id, name, description, field_ids, scenario_ids, loop, queue)
    VALUES ('e860b491-42b1-416a-b2fb-bea9bd8a249d', 'KPI-RS-093: Reflection on operator de-skilling  (Power Grid)', 'This KPI represents self-reported human operators’ perception of the changes in their own skills working with the AI assistant over time (increased/decreased) on a Likert scale. ', array['43e38b85-6b62-4898-a0c6-6b1b5e9b7e83']::uuid[], array['f253c68c-bd5e-43a2-8d72-77ab9caccb0d']::uuid[], 'OFFLINE', 'PowerGrid')
    ON CONFLICT(id) DO UPDATE SET name=EXCLUDED.name, description=EXCLUDED.description, field_ids=EXCLUDED.field_ids, scenario_ids=EXCLUDED.scenario_ids, loop=EXCLUDED.loop, queue=EXCLUDED.queue;

INSERT INTO field_definitions
        (id, key, description, agg_func, agg_weights)
        VALUES ('43e38b85-6b62-4898-a0c6-6b1b5e9b7e83', 'primary', 'Benchmark score (MEAN of test scores)', 'MEAN', NULL)
        ON CONFLICT(id) DO UPDATE SET key=EXCLUDED.key, description=EXCLUDED.description, agg_func=EXCLUDED.agg_func, agg_weights=EXCLUDED.agg_weights;

INSERT INTO scenario_definitions
    (id, name, description, field_ids)
    VALUES ('f253c68c-bd5e-43a2-8d72-77ab9caccb0d', 'primary', 'This KPI contributes to evaluating Long-term consequences of AI assistants of the AI-based assistant, as part of Task 4.3 evaluation objectives, and O3 main project objective. <br/>It is also relevant to protocols and concepts defined in D1.1 such as “Mitigate de-skilling in the human operators”. ', array['1897db1b-869a-4100-8596-a983a5525cbf']::uuid[])
    ON CONFLICT(id) DO UPDATE SET name=EXCLUDED.name, description=EXCLUDED.description, field_ids=EXCLUDED.field_ids;

INSERT INTO field_definitions
        (id, key, description, agg_func, agg_weights)
        VALUES ('1897db1b-869a-4100-8596-a983a5525cbf', 'primary', 'Scenario score (raw values)', NULL, NULL)
        ON CONFLICT(id) DO UPDATE SET key=EXCLUDED.key, description=EXCLUDED.description, agg_func=EXCLUDED.agg_func, agg_weights=EXCLUDED.agg_weights;

INSERT INTO test_definitions
    (id, name, description, field_ids, scenario_ids, loop, queue)
    VALUES ('8de9a511-8d9e-4289-a78b-0004737443c9', 'KPI-RS-093: Reflection on operator de-skilling  (ATM)', 'This KPI represents self-reported human operators’ perception of the changes in their own skills working with the AI assistant over time (increased/decreased) on a Likert scale. ', array['68dee536-8f29-4208-a327-48d67900c581']::uuid[], array['e62d0769-c481-4641-b9d4-ad5586008e38']::uuid[], 'OFFLINE', 'ATM')
    ON CONFLICT(id) DO UPDATE SET name=EXCLUDED.name, description=EXCLUDED.description, field_ids=EXCLUDED.field_ids, scenario_ids=EXCLUDED.scenario_ids, loop=EXCLUDED.loop, queue=EXCLUDED.queue;

INSERT INTO field_definitions
        (id, key, description, agg_func, agg_weights)
        VALUES ('68dee536-8f29-4208-a327-48d67900c581', 'primary', 'Benchmark score (MEAN of test scores)', 'MEAN', NULL)
        ON CONFLICT(id) DO UPDATE SET key=EXCLUDED.key, description=EXCLUDED.description, agg_func=EXCLUDED.agg_func, agg_weights=EXCLUDED.agg_weights;

INSERT INTO scenario_definitions
    (id, name, description, field_ids)
    VALUES ('e62d0769-c481-4641-b9d4-ad5586008e38', 'primary', 'This KPI contributes to evaluating Long-term consequences of AI assistants of the AI-based assistant, as part of Task 4.3 evaluation objectives, and O3 main project objective. <br/>It is also relevant to protocols and concepts defined in D1.1 such as “Mitigate de-skilling in the human operators”. ', array['7cef4f40-a0a6-48e1-a4b9-a20f8bae0409']::uuid[])
    ON CONFLICT(id) DO UPDATE SET name=EXCLUDED.name, description=EXCLUDED.description, field_ids=EXCLUDED.field_ids;

INSERT INTO field_definitions
        (id, key, description, agg_func, agg_weights)
        VALUES ('7cef4f40-a0a6-48e1-a4b9-a20f8bae0409', 'primary', 'Scenario score (raw values)', NULL, NULL)
        ON CONFLICT(id) DO UPDATE SET key=EXCLUDED.key, description=EXCLUDED.description, agg_func=EXCLUDED.agg_func, agg_weights=EXCLUDED.agg_weights;

INSERT INTO test_definitions
    (id, name, description, field_ids, scenario_ids, loop, queue)
    VALUES ('a6a54b1d-54bf-4b09-9887-706eed3e1a57', 'KPI-RS-094: Reflection on over-reliance  (Railway)', 'This KPI represents self-reported human operators’ perception of their potential over-reliance on the AI assistant on a Likert scale. ', array['cabb2d9f-8086-4510-9735-8b10321096c6']::uuid[], array['fbe33158-fb85-492d-9015-62b95f4658e8']::uuid[], 'OFFLINE', 'Railway')
    ON CONFLICT(id) DO UPDATE SET name=EXCLUDED.name, description=EXCLUDED.description, field_ids=EXCLUDED.field_ids, scenario_ids=EXCLUDED.scenario_ids, loop=EXCLUDED.loop, queue=EXCLUDED.queue;

INSERT INTO field_definitions
        (id, key, description, agg_func, agg_weights)
        VALUES ('cabb2d9f-8086-4510-9735-8b10321096c6', 'primary', 'Benchmark score (MEAN of test scores)', 'MEAN', NULL)
        ON CONFLICT(id) DO UPDATE SET key=EXCLUDED.key, description=EXCLUDED.description, agg_func=EXCLUDED.agg_func, agg_weights=EXCLUDED.agg_weights;

INSERT INTO scenario_definitions
    (id, name, description, field_ids)
    VALUES ('fbe33158-fb85-492d-9015-62b95f4658e8', 'primary', 'This KPI contributes to evaluating Long-term consequences of AI assistants of the AI-based assistant, as part of Task 4.3 evaluation objectives, and O3 main project objective. <br/>It is also relevant to protocols and concepts defined in D1.1 such as “Mitigate addictive behavior from humans”. ', array['06cb3d29-b11f-41cb-aa32-a0bab80f9e41']::uuid[])
    ON CONFLICT(id) DO UPDATE SET name=EXCLUDED.name, description=EXCLUDED.description, field_ids=EXCLUDED.field_ids;

INSERT INTO field_definitions
        (id, key, description, agg_func, agg_weights)
        VALUES ('06cb3d29-b11f-41cb-aa32-a0bab80f9e41', 'primary', 'Scenario score (raw values)', NULL, NULL)
        ON CONFLICT(id) DO UPDATE SET key=EXCLUDED.key, description=EXCLUDED.description, agg_func=EXCLUDED.agg_func, agg_weights=EXCLUDED.agg_weights;

INSERT INTO test_definitions
    (id, name, description, field_ids, scenario_ids, loop, queue)
    VALUES ('ff1099da-8b25-4dff-8f64-c7ce1d5c9d9d', 'KPI-RS-094: Reflection on over-reliance  (Power Grid)', 'This KPI represents self-reported human operators’ perception of their potential over-reliance on the AI assistant on a Likert scale. ', array['43eebab4-d111-4f5d-8c3d-1abdaafb2a4b']::uuid[], array['44daf1f7-1449-408e-baa6-9d5c29dc50f0']::uuid[], 'OFFLINE', 'PowerGrid')
    ON CONFLICT(id) DO UPDATE SET name=EXCLUDED.name, description=EXCLUDED.description, field_ids=EXCLUDED.field_ids, scenario_ids=EXCLUDED.scenario_ids, loop=EXCLUDED.loop, queue=EXCLUDED.queue;

INSERT INTO field_definitions
        (id, key, description, agg_func, agg_weights)
        VALUES ('43eebab4-d111-4f5d-8c3d-1abdaafb2a4b', 'primary', 'Benchmark score (MEAN of test scores)', 'MEAN', NULL)
        ON CONFLICT(id) DO UPDATE SET key=EXCLUDED.key, description=EXCLUDED.description, agg_func=EXCLUDED.agg_func, agg_weights=EXCLUDED.agg_weights;

INSERT INTO scenario_definitions
    (id, name, description, field_ids)
    VALUES ('44daf1f7-1449-408e-baa6-9d5c29dc50f0', 'primary', 'This KPI contributes to evaluating Long-term consequences of AI assistants of the AI-based assistant, as part of Task 4.3 evaluation objectives, and O3 main project objective. <br/>It is also relevant to protocols and concepts defined in D1.1 such as “Mitigate addictive behavior from humans”. ', array['00ddf7a5-e115-485b-b60a-e20fe7e4a47b']::uuid[])
    ON CONFLICT(id) DO UPDATE SET name=EXCLUDED.name, description=EXCLUDED.description, field_ids=EXCLUDED.field_ids;

INSERT INTO field_definitions
        (id, key, description, agg_func, agg_weights)
        VALUES ('00ddf7a5-e115-485b-b60a-e20fe7e4a47b', 'primary', 'Scenario score (raw values)', NULL, NULL)
        ON CONFLICT(id) DO UPDATE SET key=EXCLUDED.key, description=EXCLUDED.description, agg_func=EXCLUDED.agg_func, agg_weights=EXCLUDED.agg_weights;

INSERT INTO test_definitions
    (id, name, description, field_ids, scenario_ids, loop, queue)
    VALUES ('7ce3a25e-219c-4146-b2a7-c4f46bc7b137', 'KPI-RS-094: Reflection on over-reliance  (ATM)', 'This KPI represents self-reported human operators’ perception of their potential over-reliance on the AI assistant on a Likert scale. ', array['4daf6937-535b-4846-858b-9eaab6ff1b19']::uuid[], array['a65a72e0-5ac4-4182-a919-da70d1241a59']::uuid[], 'OFFLINE', 'ATM')
    ON CONFLICT(id) DO UPDATE SET name=EXCLUDED.name, description=EXCLUDED.description, field_ids=EXCLUDED.field_ids, scenario_ids=EXCLUDED.scenario_ids, loop=EXCLUDED.loop, queue=EXCLUDED.queue;

INSERT INTO field_definitions
        (id, key, description, agg_func, agg_weights)
        VALUES ('4daf6937-535b-4846-858b-9eaab6ff1b19', 'primary', 'Benchmark score (MEAN of test scores)', 'MEAN', NULL)
        ON CONFLICT(id) DO UPDATE SET key=EXCLUDED.key, description=EXCLUDED.description, agg_func=EXCLUDED.agg_func, agg_weights=EXCLUDED.agg_weights;

INSERT INTO scenario_definitions
    (id, name, description, field_ids)
    VALUES ('a65a72e0-5ac4-4182-a919-da70d1241a59', 'primary', 'This KPI contributes to evaluating Long-term consequences of AI assistants of the AI-based assistant, as part of Task 4.3 evaluation objectives, and O3 main project objective. <br/>It is also relevant to protocols and concepts defined in D1.1 such as “Mitigate addictive behavior from humans”. ', array['48c96014-f53b-4245-a23b-e69235885b75']::uuid[])
    ON CONFLICT(id) DO UPDATE SET name=EXCLUDED.name, description=EXCLUDED.description, field_ids=EXCLUDED.field_ids;

INSERT INTO field_definitions
        (id, key, description, agg_func, agg_weights)
        VALUES ('48c96014-f53b-4245-a23b-e69235885b75', 'primary', 'Scenario score (raw values)', NULL, NULL)
        ON CONFLICT(id) DO UPDATE SET key=EXCLUDED.key, description=EXCLUDED.description, agg_func=EXCLUDED.agg_func, agg_weights=EXCLUDED.agg_weights;

INSERT INTO test_definitions
    (id, name, description, field_ids, scenario_ids, loop, queue)
    VALUES ('0d898adb-7378-4ddd-8afa-a7136f13e3fa', 'KPI-RS-095: Reflection on additional training  (Railway)', 'This KPI represents self-reported human operators’ perception of the additional training necessary to adopt the AI assistant on a Likert scale. ', array['e7cf7efc-69fa-4b80-bc56-bb5d7a44f0f9']::uuid[], array['4a6d19a8-0d27-42d8-97af-9197987e64ce']::uuid[], 'OFFLINE', 'Railway')
    ON CONFLICT(id) DO UPDATE SET name=EXCLUDED.name, description=EXCLUDED.description, field_ids=EXCLUDED.field_ids, scenario_ids=EXCLUDED.scenario_ids, loop=EXCLUDED.loop, queue=EXCLUDED.queue;

INSERT INTO field_definitions
        (id, key, description, agg_func, agg_weights)
        VALUES ('e7cf7efc-69fa-4b80-bc56-bb5d7a44f0f9', 'primary', 'Benchmark score (MEAN of test scores)', 'MEAN', NULL)
        ON CONFLICT(id) DO UPDATE SET key=EXCLUDED.key, description=EXCLUDED.description, agg_func=EXCLUDED.agg_func, agg_weights=EXCLUDED.agg_weights;

INSERT INTO scenario_definitions
    (id, name, description, field_ids)
    VALUES ('4a6d19a8-0d27-42d8-97af-9197987e64ce', 'primary', 'This KPI contributes to evaluating Long-term consequences of AI assistants of the AI-based assistant, as part of Task 4.3 evaluation objectives, and O3 main project objective. <br/>It is also relevant to protocols and concepts defined in D1.1 such as “Additional training about AI for human operators” and “Societal and Environmental Well-being”. ', array['125e2e59-23cc-4a2b-a964-bdb5ef835ef5']::uuid[])
    ON CONFLICT(id) DO UPDATE SET name=EXCLUDED.name, description=EXCLUDED.description, field_ids=EXCLUDED.field_ids;

INSERT INTO field_definitions
        (id, key, description, agg_func, agg_weights)
        VALUES ('125e2e59-23cc-4a2b-a964-bdb5ef835ef5', 'primary', 'Scenario score (raw values)', NULL, NULL)
        ON CONFLICT(id) DO UPDATE SET key=EXCLUDED.key, description=EXCLUDED.description, agg_func=EXCLUDED.agg_func, agg_weights=EXCLUDED.agg_weights;

INSERT INTO test_definitions
    (id, name, description, field_ids, scenario_ids, loop, queue)
    VALUES ('afa5288f-3a6f-4933-8bd9-1761d4c97c34', 'KPI-RS-095: Reflection on additional training  (Power Grid)', 'This KPI represents self-reported human operators’ perception of the additional training necessary to adopt the AI assistant on a Likert scale. ', array['69721968-c18b-4bf4-9223-2ed001231c7f']::uuid[], array['9cfb4458-2418-4a83-a7f3-0c27758c4752']::uuid[], 'OFFLINE', 'PowerGrid')
    ON CONFLICT(id) DO UPDATE SET name=EXCLUDED.name, description=EXCLUDED.description, field_ids=EXCLUDED.field_ids, scenario_ids=EXCLUDED.scenario_ids, loop=EXCLUDED.loop, queue=EXCLUDED.queue;

INSERT INTO field_definitions
        (id, key, description, agg_func, agg_weights)
        VALUES ('69721968-c18b-4bf4-9223-2ed001231c7f', 'primary', 'Benchmark score (MEAN of test scores)', 'MEAN', NULL)
        ON CONFLICT(id) DO UPDATE SET key=EXCLUDED.key, description=EXCLUDED.description, agg_func=EXCLUDED.agg_func, agg_weights=EXCLUDED.agg_weights;

INSERT INTO scenario_definitions
    (id, name, description, field_ids)
    VALUES ('9cfb4458-2418-4a83-a7f3-0c27758c4752', 'primary', 'This KPI contributes to evaluating Long-term consequences of AI assistants of the AI-based assistant, as part of Task 4.3 evaluation objectives, and O3 main project objective. <br/>It is also relevant to protocols and concepts defined in D1.1 such as “Additional training about AI for human operators” and “Societal and Environmental Well-being”. ', array['64ec96be-c917-4d84-bea6-f1b3a1dbf810']::uuid[])
    ON CONFLICT(id) DO UPDATE SET name=EXCLUDED.name, description=EXCLUDED.description, field_ids=EXCLUDED.field_ids;

INSERT INTO field_definitions
        (id, key, description, agg_func, agg_weights)
        VALUES ('64ec96be-c917-4d84-bea6-f1b3a1dbf810', 'primary', 'Scenario score (raw values)', NULL, NULL)
        ON CONFLICT(id) DO UPDATE SET key=EXCLUDED.key, description=EXCLUDED.description, agg_func=EXCLUDED.agg_func, agg_weights=EXCLUDED.agg_weights;

INSERT INTO test_definitions
    (id, name, description, field_ids, scenario_ids, loop, queue)
    VALUES ('81b57209-24e3-4213-a93f-8129b3ca1c1c', 'KPI-RS-095: Reflection on additional training  (ATM)', 'This KPI represents self-reported human operators’ perception of the additional training necessary to adopt the AI assistant on a Likert scale. ', array['5839d96c-291b-465d-bfab-ba8951b3853e']::uuid[], array['e82bc94e-ed5e-403a-8dce-a4ed9c7cb63d']::uuid[], 'OFFLINE', 'ATM')
    ON CONFLICT(id) DO UPDATE SET name=EXCLUDED.name, description=EXCLUDED.description, field_ids=EXCLUDED.field_ids, scenario_ids=EXCLUDED.scenario_ids, loop=EXCLUDED.loop, queue=EXCLUDED.queue;

INSERT INTO field_definitions
        (id, key, description, agg_func, agg_weights)
        VALUES ('5839d96c-291b-465d-bfab-ba8951b3853e', 'primary', 'Benchmark score (MEAN of test scores)', 'MEAN', NULL)
        ON CONFLICT(id) DO UPDATE SET key=EXCLUDED.key, description=EXCLUDED.description, agg_func=EXCLUDED.agg_func, agg_weights=EXCLUDED.agg_weights;

INSERT INTO scenario_definitions
    (id, name, description, field_ids)
    VALUES ('e82bc94e-ed5e-403a-8dce-a4ed9c7cb63d', 'primary', 'This KPI contributes to evaluating Long-term consequences of AI assistants of the AI-based assistant, as part of Task 4.3 evaluation objectives, and O3 main project objective. <br/>It is also relevant to protocols and concepts defined in D1.1 such as “Additional training about AI for human operators” and “Societal and Environmental Well-being”. ', array['ec681c67-7748-4699-a7f9-346b81aa2c14']::uuid[])
    ON CONFLICT(id) DO UPDATE SET name=EXCLUDED.name, description=EXCLUDED.description, field_ids=EXCLUDED.field_ids;

INSERT INTO field_definitions
        (id, key, description, agg_func, agg_weights)
        VALUES ('ec681c67-7748-4699-a7f9-346b81aa2c14', 'primary', 'Scenario score (raw values)', NULL, NULL)
        ON CONFLICT(id) DO UPDATE SET key=EXCLUDED.key, description=EXCLUDED.description, agg_func=EXCLUDED.agg_func, agg_weights=EXCLUDED.agg_weights;

INSERT INTO test_definitions
    (id, name, description, field_ids, scenario_ids, loop, queue)
    VALUES ('be770a02-c8be-4774-97b6-bc15e91b2fd8', 'KPI-RS-096: Reflection on biases  (Railway)', 'This KPI represents self-reported human operators’ perception of biased decisions potentially produced by the AI assistant with respect to gender/ethnicity/age or commercial interests on a Likert scale. ', array['6b1b9ae3-ac68-45f7-8706-80ca756e3cfa']::uuid[], array['b646c5dd-20e5-4628-984c-0b6ab3156538']::uuid[], 'OFFLINE', 'Railway')
    ON CONFLICT(id) DO UPDATE SET name=EXCLUDED.name, description=EXCLUDED.description, field_ids=EXCLUDED.field_ids, scenario_ids=EXCLUDED.scenario_ids, loop=EXCLUDED.loop, queue=EXCLUDED.queue;

INSERT INTO field_definitions
        (id, key, description, agg_func, agg_weights)
        VALUES ('6b1b9ae3-ac68-45f7-8706-80ca756e3cfa', 'primary', 'Benchmark score (MEAN of test scores)', 'MEAN', NULL)
        ON CONFLICT(id) DO UPDATE SET key=EXCLUDED.key, description=EXCLUDED.description, agg_func=EXCLUDED.agg_func, agg_weights=EXCLUDED.agg_weights;

INSERT INTO scenario_definitions
    (id, name, description, field_ids)
    VALUES ('b646c5dd-20e5-4628-984c-0b6ab3156538', 'primary', 'This KPI contributes to evaluating Long-term consequences of AI assistants of the AI-based assistant, as part of Task 4.3 evaluation objectives, and O3 main project objective. <br/>It is also relevant to protocols and concepts defined in D1.1 such as “Diversity, Non-discrimination, and Fairness”. ', array['5a6f8659-28db-43ec-b112-d9f5aa9fd3a3']::uuid[])
    ON CONFLICT(id) DO UPDATE SET name=EXCLUDED.name, description=EXCLUDED.description, field_ids=EXCLUDED.field_ids;

INSERT INTO field_definitions
        (id, key, description, agg_func, agg_weights)
        VALUES ('5a6f8659-28db-43ec-b112-d9f5aa9fd3a3', 'primary', 'Scenario score (raw values)', NULL, NULL)
        ON CONFLICT(id) DO UPDATE SET key=EXCLUDED.key, description=EXCLUDED.description, agg_func=EXCLUDED.agg_func, agg_weights=EXCLUDED.agg_weights;

INSERT INTO test_definitions
    (id, name, description, field_ids, scenario_ids, loop, queue)
    VALUES ('b67c3a5a-c157-420c-9d3c-8c949413a79b', 'KPI-RS-096: Reflection on biases  (Power Grid)', 'This KPI represents self-reported human operators’ perception of biased decisions potentially produced by the AI assistant with respect to gender/ethnicity/age or commercial interests on a Likert scale. ', array['f16522e3-b973-4b1d-bf7a-b728885a0b29']::uuid[], array['7dfff29e-c251-459e-b591-295d796b328a']::uuid[], 'OFFLINE', 'PowerGrid')
    ON CONFLICT(id) DO UPDATE SET name=EXCLUDED.name, description=EXCLUDED.description, field_ids=EXCLUDED.field_ids, scenario_ids=EXCLUDED.scenario_ids, loop=EXCLUDED.loop, queue=EXCLUDED.queue;

INSERT INTO field_definitions
        (id, key, description, agg_func, agg_weights)
        VALUES ('f16522e3-b973-4b1d-bf7a-b728885a0b29', 'primary', 'Benchmark score (MEAN of test scores)', 'MEAN', NULL)
        ON CONFLICT(id) DO UPDATE SET key=EXCLUDED.key, description=EXCLUDED.description, agg_func=EXCLUDED.agg_func, agg_weights=EXCLUDED.agg_weights;

INSERT INTO scenario_definitions
    (id, name, description, field_ids)
    VALUES ('7dfff29e-c251-459e-b591-295d796b328a', 'primary', 'This KPI contributes to evaluating Long-term consequences of AI assistants of the AI-based assistant, as part of Task 4.3 evaluation objectives, and O3 main project objective. <br/>It is also relevant to protocols and concepts defined in D1.1 such as “Diversity, Non-discrimination, and Fairness”. ', array['b60958e0-1320-4afd-b080-4454ebe059c0']::uuid[])
    ON CONFLICT(id) DO UPDATE SET name=EXCLUDED.name, description=EXCLUDED.description, field_ids=EXCLUDED.field_ids;

INSERT INTO field_definitions
        (id, key, description, agg_func, agg_weights)
        VALUES ('b60958e0-1320-4afd-b080-4454ebe059c0', 'primary', 'Scenario score (raw values)', NULL, NULL)
        ON CONFLICT(id) DO UPDATE SET key=EXCLUDED.key, description=EXCLUDED.description, agg_func=EXCLUDED.agg_func, agg_weights=EXCLUDED.agg_weights;

INSERT INTO test_definitions
    (id, name, description, field_ids, scenario_ids, loop, queue)
    VALUES ('733c3705-a1a3-45e1-9fd6-b19e9627bf50', 'KPI-RS-096: Reflection on biases  (ATM)', 'This KPI represents self-reported human operators’ perception of biased decisions potentially produced by the AI assistant with respect to gender/ethnicity/age or commercial interests on a Likert scale. ', array['4c5e593d-4785-45a6-9dfd-5190f909f913']::uuid[], array['3c3dd29c-67f1-49fa-8aef-384c957acaa4']::uuid[], 'OFFLINE', 'ATM')
    ON CONFLICT(id) DO UPDATE SET name=EXCLUDED.name, description=EXCLUDED.description, field_ids=EXCLUDED.field_ids, scenario_ids=EXCLUDED.scenario_ids, loop=EXCLUDED.loop, queue=EXCLUDED.queue;

INSERT INTO field_definitions
        (id, key, description, agg_func, agg_weights)
        VALUES ('4c5e593d-4785-45a6-9dfd-5190f909f913', 'primary', 'Benchmark score (MEAN of test scores)', 'MEAN', NULL)
        ON CONFLICT(id) DO UPDATE SET key=EXCLUDED.key, description=EXCLUDED.description, agg_func=EXCLUDED.agg_func, agg_weights=EXCLUDED.agg_weights;

INSERT INTO scenario_definitions
    (id, name, description, field_ids)
    VALUES ('3c3dd29c-67f1-49fa-8aef-384c957acaa4', 'primary', 'This KPI contributes to evaluating Long-term consequences of AI assistants of the AI-based assistant, as part of Task 4.3 evaluation objectives, and O3 main project objective. <br/>It is also relevant to protocols and concepts defined in D1.1 such as “Diversity, Non-discrimination, and Fairness”. ', array['bb338017-71b2-4f70-80e2-4b425894cbc2']::uuid[])
    ON CONFLICT(id) DO UPDATE SET name=EXCLUDED.name, description=EXCLUDED.description, field_ids=EXCLUDED.field_ids;

INSERT INTO field_definitions
        (id, key, description, agg_func, agg_weights)
        VALUES ('bb338017-71b2-4f70-80e2-4b425894cbc2', 'primary', 'Scenario score (raw values)', NULL, NULL)
        ON CONFLICT(id) DO UPDATE SET key=EXCLUDED.key, description=EXCLUDED.description, agg_func=EXCLUDED.agg_func, agg_weights=EXCLUDED.agg_weights;

INSERT INTO test_definitions
    (id, name, description, field_ids, scenario_ids, loop, queue)
    VALUES ('2c71e014-3994-4413-a469-e27b0d1e121d', 'KPI-PS-097: Predicted long-term adoption  (Railway)', 'This KPI represents predicted adoption of the AI assistant by users, stakeholders, or experts on a Likert scale. ', array['ee00b722-5e1f-4adb-84aa-89dc2c1e698d']::uuid[], array['691ab2fd-9827-45f9-8d03-0878c1005144']::uuid[], 'OFFLINE', 'Railway')
    ON CONFLICT(id) DO UPDATE SET name=EXCLUDED.name, description=EXCLUDED.description, field_ids=EXCLUDED.field_ids, scenario_ids=EXCLUDED.scenario_ids, loop=EXCLUDED.loop, queue=EXCLUDED.queue;

INSERT INTO field_definitions
        (id, key, description, agg_func, agg_weights)
        VALUES ('ee00b722-5e1f-4adb-84aa-89dc2c1e698d', 'primary', 'Benchmark score (MEAN of test scores)', 'MEAN', NULL)
        ON CONFLICT(id) DO UPDATE SET key=EXCLUDED.key, description=EXCLUDED.description, agg_func=EXCLUDED.agg_func, agg_weights=EXCLUDED.agg_weights;

INSERT INTO scenario_definitions
    (id, name, description, field_ids)
    VALUES ('691ab2fd-9827-45f9-8d03-0878c1005144', 'primary', 'This KPI contributes to evaluating Long-term consequences of AI assistants of the AI-based assistant, as part of Task 4.3 evaluation objectives, and O3 main project objective. <br/>It is also relevant to protocols and concepts defined in D1.1 such as “Human Agency and Oversight”, “Societal and Environmental Well-being”. ', array['6134d787-1015-46f3-bb71-572fb747f71a']::uuid[])
    ON CONFLICT(id) DO UPDATE SET name=EXCLUDED.name, description=EXCLUDED.description, field_ids=EXCLUDED.field_ids;

INSERT INTO field_definitions
        (id, key, description, agg_func, agg_weights)
        VALUES ('6134d787-1015-46f3-bb71-572fb747f71a', 'primary', 'Scenario score (raw values)', NULL, NULL)
        ON CONFLICT(id) DO UPDATE SET key=EXCLUDED.key, description=EXCLUDED.description, agg_func=EXCLUDED.agg_func, agg_weights=EXCLUDED.agg_weights;

INSERT INTO test_definitions
    (id, name, description, field_ids, scenario_ids, loop, queue)
    VALUES ('f322d495-95e0-49ab-9439-156228593328', 'KPI-PS-097: Predicted long-term adoption  (Power Grid)', 'This KPI represents predicted adoption of the AI assistant by users, stakeholders, or experts on a Likert scale. ', array['929eb222-48b9-4652-bb0f-8b71899a02da']::uuid[], array['d885d30d-408c-4b88-9a25-add134aca45b']::uuid[], 'OFFLINE', 'PowerGrid')
    ON CONFLICT(id) DO UPDATE SET name=EXCLUDED.name, description=EXCLUDED.description, field_ids=EXCLUDED.field_ids, scenario_ids=EXCLUDED.scenario_ids, loop=EXCLUDED.loop, queue=EXCLUDED.queue;

INSERT INTO field_definitions
        (id, key, description, agg_func, agg_weights)
        VALUES ('929eb222-48b9-4652-bb0f-8b71899a02da', 'primary', 'Benchmark score (MEAN of test scores)', 'MEAN', NULL)
        ON CONFLICT(id) DO UPDATE SET key=EXCLUDED.key, description=EXCLUDED.description, agg_func=EXCLUDED.agg_func, agg_weights=EXCLUDED.agg_weights;

INSERT INTO scenario_definitions
    (id, name, description, field_ids)
    VALUES ('d885d30d-408c-4b88-9a25-add134aca45b', 'primary', 'This KPI contributes to evaluating Long-term consequences of AI assistants of the AI-based assistant, as part of Task 4.3 evaluation objectives, and O3 main project objective. <br/>It is also relevant to protocols and concepts defined in D1.1 such as “Human Agency and Oversight”, “Societal and Environmental Well-being”. ', array['15727caa-9a67-4397-9e08-14c6b1f4e236']::uuid[])
    ON CONFLICT(id) DO UPDATE SET name=EXCLUDED.name, description=EXCLUDED.description, field_ids=EXCLUDED.field_ids;

INSERT INTO field_definitions
        (id, key, description, agg_func, agg_weights)
        VALUES ('15727caa-9a67-4397-9e08-14c6b1f4e236', 'primary', 'Scenario score (raw values)', NULL, NULL)
        ON CONFLICT(id) DO UPDATE SET key=EXCLUDED.key, description=EXCLUDED.description, agg_func=EXCLUDED.agg_func, agg_weights=EXCLUDED.agg_weights;

INSERT INTO test_definitions
    (id, name, description, field_ids, scenario_ids, loop, queue)
    VALUES ('de69aa29-4aa0-4473-918e-14004116a9dc', 'KPI-PS-097: Predicted long-term adoption  (ATM)', 'This KPI represents predicted adoption of the AI assistant by users, stakeholders, or experts on a Likert scale. ', array['0dcc4cb8-a438-49cc-bf19-d5f1bb6999ff']::uuid[], array['664cd46e-7eac-480f-92da-79574b470da4']::uuid[], 'OFFLINE', 'ATM')
    ON CONFLICT(id) DO UPDATE SET name=EXCLUDED.name, description=EXCLUDED.description, field_ids=EXCLUDED.field_ids, scenario_ids=EXCLUDED.scenario_ids, loop=EXCLUDED.loop, queue=EXCLUDED.queue;

INSERT INTO field_definitions
        (id, key, description, agg_func, agg_weights)
        VALUES ('0dcc4cb8-a438-49cc-bf19-d5f1bb6999ff', 'primary', 'Benchmark score (MEAN of test scores)', 'MEAN', NULL)
        ON CONFLICT(id) DO UPDATE SET key=EXCLUDED.key, description=EXCLUDED.description, agg_func=EXCLUDED.agg_func, agg_weights=EXCLUDED.agg_weights;

INSERT INTO scenario_definitions
    (id, name, description, field_ids)
    VALUES ('664cd46e-7eac-480f-92da-79574b470da4', 'primary', 'This KPI contributes to evaluating Long-term consequences of AI assistants of the AI-based assistant, as part of Task 4.3 evaluation objectives, and O3 main project objective. <br/>It is also relevant to protocols and concepts defined in D1.1 such as “Human Agency and Oversight”, “Societal and Environmental Well-being”. ', array['524d2cef-fca0-42d8-ab3f-5abd20ab2c3e']::uuid[])
    ON CONFLICT(id) DO UPDATE SET name=EXCLUDED.name, description=EXCLUDED.description, field_ids=EXCLUDED.field_ids;

INSERT INTO field_definitions
        (id, key, description, agg_func, agg_weights)
        VALUES ('524d2cef-fca0-42d8-ab3f-5abd20ab2c3e', 'primary', 'Scenario score (raw values)', NULL, NULL)
        ON CONFLICT(id) DO UPDATE SET key=EXCLUDED.key, description=EXCLUDED.description, agg_func=EXCLUDED.agg_func, agg_weights=EXCLUDED.agg_weights;

