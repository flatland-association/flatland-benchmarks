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
    VALUES ('8edbf9a1-09b4-478a-ac53-8fc903e70cc1', 'KPI-AS-001: Ability to anticipate (Railway)', '“The ability to anticipate. Knowing what to expect or being able to anticipate developments further into the future, such as potential disruptions, novel demands or constraints, new opportunities, or changing operating conditions” (Hollnagel, 2015, p. 4).<br/>The human operator’s ability to anticipate further into the future can be measured by calculating the ratio of (proactively) prevented deviations to actual deviations. In addition, the extent to which the anticipatory sensemaking process of the human operator is supported by AI-based assistants can be measured using the Rigor-Metric for Sensemaking (Zelik et al., 2018) or similar. The instrument needs to be further developed and adapted to the AI context. ', array['2310ad43-2065-44a5-8a6a-100e2c6076f1']::uuid[], array['c7159f8d-781b-40fc-9efa-cd0e3a8b8d21']::uuid[], 'OFFLINE', 'Railway')
    ON CONFLICT(id) DO UPDATE SET name=EXCLUDED.name, description=EXCLUDED.description, field_ids=EXCLUDED.field_ids, scenario_ids=EXCLUDED.scenario_ids, loop=EXCLUDED.loop, queue=EXCLUDED.queue;

INSERT INTO field_definitions
        (id, key, description, agg_func, agg_weights)
        VALUES ('2310ad43-2065-44a5-8a6a-100e2c6076f1', 'primary', 'Benchmark score (MEAN of test scores)', 'MEAN', NULL)
        ON CONFLICT(id) DO UPDATE SET key=EXCLUDED.key, description=EXCLUDED.description, agg_func=EXCLUDED.agg_func, agg_weights=EXCLUDED.agg_weights;

INSERT INTO scenario_definitions
    (id, name, description, field_ids)
    VALUES ('c7159f8d-781b-40fc-9efa-cd0e3a8b8d21', 'Scenario 1 - “The ability to anticipate. Knowing what to expect or being able to anticipate developments further into the future, such as potential disruptions, novel demands or constraints, new opportunities, or changing operating conditions” (Hollnagel, 2015, p. 4).<br/>The human operator’s ability to anticipate further into the future can be measured by calculating the ratio of (proactively) prevented deviations to actual deviations. In addition, the extent to which the anticipatory sensemaking process of the human operator is supported by AI-based assistants can be measured using the Rigor-Metric for Sensemaking (Zelik et al., 2018) or similar. The instrument needs to be further developed and adapted to the AI context. ', 'This KPI contributes to evaluating Human user experience of the AI-based assistant, as part of Task 4.3 evaluation objectives, and O3 main project objective. ', array['071fb4f2-9765-4fe0-9f7a-573cf8bb2ee7']::uuid[])
    ON CONFLICT(id) DO UPDATE SET name=EXCLUDED.name, description=EXCLUDED.description, field_ids=EXCLUDED.field_ids;

INSERT INTO field_definitions
        (id, key, description, agg_func, agg_weights)
        VALUES ('071fb4f2-9765-4fe0-9f7a-573cf8bb2ee7', 'primary', 'Scenario score (raw values)', NULL, NULL)
        ON CONFLICT(id) DO UPDATE SET key=EXCLUDED.key, description=EXCLUDED.description, agg_func=EXCLUDED.agg_func, agg_weights=EXCLUDED.agg_weights;

INSERT INTO test_definitions
    (id, name, description, field_ids, scenario_ids, loop, queue)
    VALUES ('98413684-d114-4f88-a5e9-1e118b106d67', 'KPI-AS-001: Ability to anticipate (Power Grid)', '“The ability to anticipate. Knowing what to expect or being able to anticipate developments further into the future, such as potential disruptions, novel demands or constraints, new opportunities, or changing operating conditions” (Hollnagel, 2015, p. 4).<br/>The human operator’s ability to anticipate further into the future can be measured by calculating the ratio of (proactively) prevented deviations to actual deviations. In addition, the extent to which the anticipatory sensemaking process of the human operator is supported by AI-based assistants can be measured using the Rigor-Metric for Sensemaking (Zelik et al., 2018) or similar. The instrument needs to be further developed and adapted to the AI context. ', array['02890e30-6f7b-4ed3-80a1-abf2e169e43f']::uuid[], array['ef0af7e2-0212-454d-9391-41de03bd7e57']::uuid[], 'OFFLINE', 'PowerGrid')
    ON CONFLICT(id) DO UPDATE SET name=EXCLUDED.name, description=EXCLUDED.description, field_ids=EXCLUDED.field_ids, scenario_ids=EXCLUDED.scenario_ids, loop=EXCLUDED.loop, queue=EXCLUDED.queue;

INSERT INTO field_definitions
        (id, key, description, agg_func, agg_weights)
        VALUES ('02890e30-6f7b-4ed3-80a1-abf2e169e43f', 'primary', 'Benchmark score (MEAN of test scores)', 'MEAN', NULL)
        ON CONFLICT(id) DO UPDATE SET key=EXCLUDED.key, description=EXCLUDED.description, agg_func=EXCLUDED.agg_func, agg_weights=EXCLUDED.agg_weights;

INSERT INTO scenario_definitions
    (id, name, description, field_ids)
    VALUES ('ef0af7e2-0212-454d-9391-41de03bd7e57', 'Scenario 1 - “The ability to anticipate. Knowing what to expect or being able to anticipate developments further into the future, such as potential disruptions, novel demands or constraints, new opportunities, or changing operating conditions” (Hollnagel, 2015, p. 4).<br/>The human operator’s ability to anticipate further into the future can be measured by calculating the ratio of (proactively) prevented deviations to actual deviations. In addition, the extent to which the anticipatory sensemaking process of the human operator is supported by AI-based assistants can be measured using the Rigor-Metric for Sensemaking (Zelik et al., 2018) or similar. The instrument needs to be further developed and adapted to the AI context. ', 'This KPI contributes to evaluating Human user experience of the AI-based assistant, as part of Task 4.3 evaluation objectives, and O3 main project objective. ', array['ad5addc9-e7e5-4807-9820-8ed96c5453e6']::uuid[])
    ON CONFLICT(id) DO UPDATE SET name=EXCLUDED.name, description=EXCLUDED.description, field_ids=EXCLUDED.field_ids;

INSERT INTO field_definitions
        (id, key, description, agg_func, agg_weights)
        VALUES ('ad5addc9-e7e5-4807-9820-8ed96c5453e6', 'primary', 'Scenario score (raw values)', NULL, NULL)
        ON CONFLICT(id) DO UPDATE SET key=EXCLUDED.key, description=EXCLUDED.description, agg_func=EXCLUDED.agg_func, agg_weights=EXCLUDED.agg_weights;

INSERT INTO test_definitions
    (id, name, description, field_ids, scenario_ids, loop, queue)
    VALUES ('9a9b85fb-6b8b-4b42-af5d-1d81d515e6b1', 'KPI-AS-001: Ability to anticipate (ATM)', '“The ability to anticipate. Knowing what to expect or being able to anticipate developments further into the future, such as potential disruptions, novel demands or constraints, new opportunities, or changing operating conditions” (Hollnagel, 2015, p. 4).<br/>The human operator’s ability to anticipate further into the future can be measured by calculating the ratio of (proactively) prevented deviations to actual deviations. In addition, the extent to which the anticipatory sensemaking process of the human operator is supported by AI-based assistants can be measured using the Rigor-Metric for Sensemaking (Zelik et al., 2018) or similar. The instrument needs to be further developed and adapted to the AI context. ', array['0c8a5446-bbc4-4a96-82bf-a53a86c10e9f']::uuid[], array['4cc07a90-fca8-4e96-b670-563c1e8f42fa']::uuid[], 'OFFLINE', 'ATM')
    ON CONFLICT(id) DO UPDATE SET name=EXCLUDED.name, description=EXCLUDED.description, field_ids=EXCLUDED.field_ids, scenario_ids=EXCLUDED.scenario_ids, loop=EXCLUDED.loop, queue=EXCLUDED.queue;

INSERT INTO field_definitions
        (id, key, description, agg_func, agg_weights)
        VALUES ('0c8a5446-bbc4-4a96-82bf-a53a86c10e9f', 'primary', 'Benchmark score (MEAN of test scores)', 'MEAN', NULL)
        ON CONFLICT(id) DO UPDATE SET key=EXCLUDED.key, description=EXCLUDED.description, agg_func=EXCLUDED.agg_func, agg_weights=EXCLUDED.agg_weights;

INSERT INTO scenario_definitions
    (id, name, description, field_ids)
    VALUES ('4cc07a90-fca8-4e96-b670-563c1e8f42fa', 'Scenario 1 - “The ability to anticipate. Knowing what to expect or being able to anticipate developments further into the future, such as potential disruptions, novel demands or constraints, new opportunities, or changing operating conditions” (Hollnagel, 2015, p. 4).<br/>The human operator’s ability to anticipate further into the future can be measured by calculating the ratio of (proactively) prevented deviations to actual deviations. In addition, the extent to which the anticipatory sensemaking process of the human operator is supported by AI-based assistants can be measured using the Rigor-Metric for Sensemaking (Zelik et al., 2018) or similar. The instrument needs to be further developed and adapted to the AI context. ', 'This KPI contributes to evaluating Human user experience of the AI-based assistant, as part of Task 4.3 evaluation objectives, and O3 main project objective. ', array['38962aaa-3dfa-462a-9feb-399ebce13a2c']::uuid[])
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
    VALUES ('59d015ca-ca8a-4015-a113-35c182b301e4', 'Scenario 1 - Assistant disturbance KPI aims to measure if the AI assistant''s notifications are disturbing the human operator''s activity. ', 'This KPI assesses whether the inputs of the operators are according to their real psychophysiology. This can act as a verification methodology but also support the AI to adapt.<br/>This KPI contributes to evaluating Human-user experience of the AI-based assistant, as part of Task 4.3 evaluation objectives, and O3 main project objective. ', array['982a837c-0ac3-4367-a42b-a86ded8c8380']::uuid[])
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
    VALUES ('57c11d6d-0001-4623-9c1e-fbfc0744c8d5', 'Scenario 1 - Assistant disturbance KPI aims to measure if the AI assistant''s notifications are disturbing the human operator''s activity. ', 'This KPI assesses whether the inputs of the operators are according to their real psychophysiology. This can act as a verification methodology but also support the AI to adapt.<br/>This KPI contributes to evaluating Human-user experience of the AI-based assistant, as part of Task 4.3 evaluation objectives, and O3 main project objective. ', array['632a41fd-7693-4c8c-bbc5-60dd4afa7da5']::uuid[])
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
    VALUES ('76a0cad5-40fd-4b92-b904-5841aadf8a7d', 'Scenario 1 - Assistant disturbance KPI aims to measure if the AI assistant''s notifications are disturbing the human operator''s activity. ', 'This KPI assesses whether the inputs of the operators are according to their real psychophysiology. This can act as a verification methodology but also support the AI to adapt.<br/>This KPI contributes to evaluating Human-user experience of the AI-based assistant, as part of Task 4.3 evaluation objectives, and O3 main project objective. ', array['44e94f9b-bb27-43c1-894d-e16f83c1e5ea']::uuid[])
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
    VALUES ('cbfe8dd3-e8df-464f-92cd-0adeab4a18b8', 'Scenario 1 - This KPI represents human operators’ self-reported satisfaction with the system’s support for their decision-making process when working with the AI assistant measured with a questionnaire. ', 'This KPI contributes to evaluating Human user experience of the AI-based assistant, as part of Task 4.3 evaluation objectives, and O3 main project objective.<br/>It is also relevant to protocols and concepts defined in D1.1 such as “Decision support for the human operator”, “Decision support satisfaction”.  ', array['0a9fe72d-eb7b-4d07-83d8-da256edbc26e']::uuid[])
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
    VALUES ('3ac00dab-5671-4e60-bf35-99309075ee76', 'Scenario 1 - This KPI represents human operators’ self-reported satisfaction with the system’s support for their decision-making process when working with the AI assistant measured with a questionnaire. ', 'This KPI contributes to evaluating Human user experience of the AI-based assistant, as part of Task 4.3 evaluation objectives, and O3 main project objective.<br/>It is also relevant to protocols and concepts defined in D1.1 such as “Decision support for the human operator”, “Decision support satisfaction”.  ', array['97c2caaa-2cc4-4cf0-ac1b-9f9cb3765544']::uuid[])
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
    VALUES ('22846c4e-e703-46c7-8069-38a6b6027a7d', 'Scenario 1 - This KPI represents human operators’ self-reported satisfaction with the system’s support for their decision-making process when working with the AI assistant measured with a questionnaire. ', 'This KPI contributes to evaluating Human user experience of the AI-based assistant, as part of Task 4.3 evaluation objectives, and O3 main project objective.<br/>It is also relevant to protocols and concepts defined in D1.1 such as “Decision support for the human operator”, “Decision support satisfaction”.  ', array['4ac569fa-97b1-4fa8-a7f0-f49a89fce80a']::uuid[])
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
    VALUES ('ab770463-5832-4edd-9ab2-178b7ee46b74', 'Scenario 1 - “Intrinsic motivation is defined as doing an activity for its inherent satisfaction rather than for some separable consequence. When intrinsically motivated, a person is moved to act for the fun or challenge entailed rather than because of external products, pressures, or rewards” (Ryan & Deci, 2000, p. 56). ', 'This KPI contributes to evaluating Human-user experience of the AI-based assistant, as part of Task 4.3 evaluation objectives, and O3 main project objective. ', array['7d92aff2-1975-4bde-aaaf-788c4e2500d7']::uuid[])
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
    VALUES ('ee4e4f46-9bc1-4da8-94b5-371ffddfab7e', 'Scenario 1 - “Intrinsic motivation is defined as doing an activity for its inherent satisfaction rather than for some separable consequence. When intrinsically motivated, a person is moved to act for the fun or challenge entailed rather than because of external products, pressures, or rewards” (Ryan & Deci, 2000, p. 56). ', 'This KPI contributes to evaluating Human-user experience of the AI-based assistant, as part of Task 4.3 evaluation objectives, and O3 main project objective. ', array['a2d30aad-9211-415d-8900-6a899dc9dee2']::uuid[])
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
    VALUES ('4f81efc4-4c7d-4973-9fb6-1fccbe11fcd4', 'Scenario 1 - “Intrinsic motivation is defined as doing an activity for its inherent satisfaction rather than for some separable consequence. When intrinsically motivated, a person is moved to act for the fun or challenge entailed rather than because of external products, pressures, or rewards” (Ryan & Deci, 2000, p. 56). ', 'This KPI contributes to evaluating Human-user experience of the AI-based assistant, as part of Task 4.3 evaluation objectives, and O3 main project objective. ', array['8d986c1d-3a36-4f03-81cd-790beaedd4ea']::uuid[])
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
    VALUES ('35cf47d4-83f4-4eb7-ab9b-40c6fe7679a8', 'Scenario 1 - Human response time KPI evaluates time needed to react to AI advisory/information. ', 'This KPI assesses whether the inputs of the operators are according to their real psychophysiology. This can act as a verification methodology but also support the AI to adapt.<br/>This KPI contributes to evaluating Human-user experience of the AI-based assistant, as part of Task 4.3 evaluation objectives, and O3 main project objective. ', array['08d0afa1-026b-43cb-9d7e-097a272e6353']::uuid[])
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
    VALUES ('d64548d6-2eb6-4e1e-8069-73c0ece64318', 'Scenario 1 - Human response time KPI evaluates time needed to react to AI advisory/information. ', 'This KPI assesses whether the inputs of the operators are according to their real psychophysiology. This can act as a verification methodology but also support the AI to adapt.<br/>This KPI contributes to evaluating Human-user experience of the AI-based assistant, as part of Task 4.3 evaluation objectives, and O3 main project objective. ', array['7dc59090-50a9-4ffc-8184-959feb2f30c0']::uuid[])
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
    VALUES ('f1278028-1c96-485c-bd6b-046d4356c335', 'Scenario 1 - Human response time KPI evaluates time needed to react to AI advisory/information. ', 'This KPI assesses whether the inputs of the operators are according to their real psychophysiology. This can act as a verification methodology but also support the AI to adapt.<br/>This KPI contributes to evaluating Human-user experience of the AI-based assistant, as part of Task 4.3 evaluation objectives, and O3 main project objective. ', array['f8401749-6e84-4a36-adf8-3e2d2b8c8fe3']::uuid[])
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
    VALUES ('3131063f-5d0e-42bd-955d-5e875ceaac94', 'Scenario 1 - “Situation Awareness is the perception of the elements in the environment within a volume of time and space, the comprehension of their meaning, and the projection of their status in the near future” (Endsley, 1988). ', 'This KPI contributes to evaluating Human-user experience of the AI-based assistant, as part of Task 4.3 evaluation objectives, and O3 main project objective. ', array['5aa8e601-0374-4438-bb7b-aab98db7bd6c']::uuid[])
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
    VALUES ('5096d57a-00a3-4018-bdc3-02cd28443a85', 'Scenario 1 - “Situation Awareness is the perception of the elements in the environment within a volume of time and space, the comprehension of their meaning, and the projection of their status in the near future” (Endsley, 1988). ', 'This KPI contributes to evaluating Human-user experience of the AI-based assistant, as part of Task 4.3 evaluation objectives, and O3 main project objective. ', array['5c524071-0d18-4982-aae9-b7a00fe4e397']::uuid[])
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
    VALUES ('f8fc8712-e092-458e-a1e6-3733f5bc65ea', 'Scenario 1 - “Situation Awareness is the perception of the elements in the environment within a volume of time and space, the comprehension of their meaning, and the projection of their status in the near future” (Endsley, 1988). ', 'This KPI contributes to evaluating Human-user experience of the AI-based assistant, as part of Task 4.3 evaluation objectives, and O3 main project objective. ', array['c6e50936-cfb5-4ff4-b28a-bc51fcf6af0e']::uuid[])
    ON CONFLICT(id) DO UPDATE SET name=EXCLUDED.name, description=EXCLUDED.description, field_ids=EXCLUDED.field_ids;

INSERT INTO field_definitions
        (id, key, description, agg_func, agg_weights)
        VALUES ('c6e50936-cfb5-4ff4-b28a-bc51fcf6af0e', 'primary', 'Scenario score (raw values)', NULL, NULL)
        ON CONFLICT(id) DO UPDATE SET key=EXCLUDED.key, description=EXCLUDED.description, agg_func=EXCLUDED.agg_func, agg_weights=EXCLUDED.agg_weights;

INSERT INTO test_definitions
    (id, name, description, field_ids, scenario_ids, loop, queue)
    VALUES ('343bc5cf-0bab-4fdf-9760-266c5a738b08', 'KPI-WS-040: Workload (Railway)', 'Workload KPI is based on the workload assessment of human operators of the AI assistant.<br/>After each testing session using the system, the workload of human operators due to the AI assistant will be evaluated to understand in which scenarios (and depending on the AI level of support) it contributes for a higher workload. ', array['80e0473e-e63a-4398-b592-66b2541a8dde']::uuid[], array['c3ab2e6b-e8ed-420e-b6d2-4fd5dd407288']::uuid[], 'OFFLINE', 'Railway')
    ON CONFLICT(id) DO UPDATE SET name=EXCLUDED.name, description=EXCLUDED.description, field_ids=EXCLUDED.field_ids, scenario_ids=EXCLUDED.scenario_ids, loop=EXCLUDED.loop, queue=EXCLUDED.queue;

INSERT INTO field_definitions
        (id, key, description, agg_func, agg_weights)
        VALUES ('80e0473e-e63a-4398-b592-66b2541a8dde', 'primary', 'Benchmark score (MEAN of test scores)', 'MEAN', NULL)
        ON CONFLICT(id) DO UPDATE SET key=EXCLUDED.key, description=EXCLUDED.description, agg_func=EXCLUDED.agg_func, agg_weights=EXCLUDED.agg_weights;

INSERT INTO scenario_definitions
    (id, name, description, field_ids)
    VALUES ('c3ab2e6b-e8ed-420e-b6d2-4fd5dd407288', 'Scenario 1 - Workload KPI is based on the workload assessment of human operators of the AI assistant.<br/>After each testing session using the system, the workload of human operators due to the AI assistant will be evaluated to understand in which scenarios (and depending on the AI level of support) it contributes for a higher workload. ', 'This KPI assesses whether the inputs of the operators are according to their real psychophysiology. This can act as a verification methodology but also support the AI to adapt.<br/>This KPI will be analyzed together with the “Impact on workload” KPI-IS-041.<br/>This KPI contributes to evaluating Human-user experience of the AI-based assistant, as part of Task 4.3 evaluation objectives, and O3 main project objective. ', array['c7e129de-357d-4f39-8963-76155c72e2bc']::uuid[])
    ON CONFLICT(id) DO UPDATE SET name=EXCLUDED.name, description=EXCLUDED.description, field_ids=EXCLUDED.field_ids;

INSERT INTO field_definitions
        (id, key, description, agg_func, agg_weights)
        VALUES ('c7e129de-357d-4f39-8963-76155c72e2bc', 'primary', 'Scenario score (raw values)', NULL, NULL)
        ON CONFLICT(id) DO UPDATE SET key=EXCLUDED.key, description=EXCLUDED.description, agg_func=EXCLUDED.agg_func, agg_weights=EXCLUDED.agg_weights;

INSERT INTO test_definitions
    (id, name, description, field_ids, scenario_ids, loop, queue)
    VALUES ('66c08000-9a5e-42ca-a328-8e6295069142', 'KPI-WS-040: Workload (Power Grid)', 'Workload KPI is based on the workload assessment of human operators of the AI assistant.<br/>After each testing session using the system, the workload of human operators due to the AI assistant will be evaluated to understand in which scenarios (and depending on the AI level of support) it contributes for a higher workload. ', array['be9cbb52-ef44-4679-8c8d-f1b3c12e9aaa']::uuid[], array['06f61acd-da79-493c-8da0-4a1327b5fe6a']::uuid[], 'OFFLINE', 'PowerGrid')
    ON CONFLICT(id) DO UPDATE SET name=EXCLUDED.name, description=EXCLUDED.description, field_ids=EXCLUDED.field_ids, scenario_ids=EXCLUDED.scenario_ids, loop=EXCLUDED.loop, queue=EXCLUDED.queue;

INSERT INTO field_definitions
        (id, key, description, agg_func, agg_weights)
        VALUES ('be9cbb52-ef44-4679-8c8d-f1b3c12e9aaa', 'primary', 'Benchmark score (MEAN of test scores)', 'MEAN', NULL)
        ON CONFLICT(id) DO UPDATE SET key=EXCLUDED.key, description=EXCLUDED.description, agg_func=EXCLUDED.agg_func, agg_weights=EXCLUDED.agg_weights;

INSERT INTO scenario_definitions
    (id, name, description, field_ids)
    VALUES ('06f61acd-da79-493c-8da0-4a1327b5fe6a', 'Scenario 1 - Workload KPI is based on the workload assessment of human operators of the AI assistant.<br/>After each testing session using the system, the workload of human operators due to the AI assistant will be evaluated to understand in which scenarios (and depending on the AI level of support) it contributes for a higher workload. ', 'This KPI assesses whether the inputs of the operators are according to their real psychophysiology. This can act as a verification methodology but also support the AI to adapt.<br/>This KPI will be analyzed together with the “Impact on workload” KPI-IS-041.<br/>This KPI contributes to evaluating Human-user experience of the AI-based assistant, as part of Task 4.3 evaluation objectives, and O3 main project objective. ', array['11f79947-fc38-40cf-acaf-ad89adde60b4']::uuid[])
    ON CONFLICT(id) DO UPDATE SET name=EXCLUDED.name, description=EXCLUDED.description, field_ids=EXCLUDED.field_ids;

INSERT INTO field_definitions
        (id, key, description, agg_func, agg_weights)
        VALUES ('11f79947-fc38-40cf-acaf-ad89adde60b4', 'primary', 'Scenario score (raw values)', NULL, NULL)
        ON CONFLICT(id) DO UPDATE SET key=EXCLUDED.key, description=EXCLUDED.description, agg_func=EXCLUDED.agg_func, agg_weights=EXCLUDED.agg_weights;

INSERT INTO test_definitions
    (id, name, description, field_ids, scenario_ids, loop, queue)
    VALUES ('96396992-ab9a-45b8-9833-124b46925da6', 'KPI-WS-040: Workload (ATM)', 'Workload KPI is based on the workload assessment of human operators of the AI assistant.<br/>After each testing session using the system, the workload of human operators due to the AI assistant will be evaluated to understand in which scenarios (and depending on the AI level of support) it contributes for a higher workload. ', array['c5762f88-bd6b-45c6-871f-c34ff539b1a1']::uuid[], array['88a26ad8-bd41-4c4b-9f10-ee7876550752']::uuid[], 'OFFLINE', 'ATM')
    ON CONFLICT(id) DO UPDATE SET name=EXCLUDED.name, description=EXCLUDED.description, field_ids=EXCLUDED.field_ids, scenario_ids=EXCLUDED.scenario_ids, loop=EXCLUDED.loop, queue=EXCLUDED.queue;

INSERT INTO field_definitions
        (id, key, description, agg_func, agg_weights)
        VALUES ('c5762f88-bd6b-45c6-871f-c34ff539b1a1', 'primary', 'Benchmark score (MEAN of test scores)', 'MEAN', NULL)
        ON CONFLICT(id) DO UPDATE SET key=EXCLUDED.key, description=EXCLUDED.description, agg_func=EXCLUDED.agg_func, agg_weights=EXCLUDED.agg_weights;

INSERT INTO scenario_definitions
    (id, name, description, field_ids)
    VALUES ('88a26ad8-bd41-4c4b-9f10-ee7876550752', 'Scenario 1 - Workload KPI is based on the workload assessment of human operators of the AI assistant.<br/>After each testing session using the system, the workload of human operators due to the AI assistant will be evaluated to understand in which scenarios (and depending on the AI level of support) it contributes for a higher workload. ', 'This KPI assesses whether the inputs of the operators are according to their real psychophysiology. This can act as a verification methodology but also support the AI to adapt.<br/>This KPI will be analyzed together with the “Impact on workload” KPI-IS-041.<br/>This KPI contributes to evaluating Human-user experience of the AI-based assistant, as part of Task 4.3 evaluation objectives, and O3 main project objective. ', array['7c5551cb-971e-4d20-87bf-f32698f071c8']::uuid[])
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
    VALUES ('76d73b49-ff52-4b9a-96e2-cc664582c8e4', 'Scenario 1 - Cognitive Performance & Stress KPI performs an implicit assessment of the human cognitive performance status and stress levels along the different task that will be performed. The output provides information about the operator mental status and aims to be used to integrate the AI system to contribute as a reward to better adapt decision system. ', 'The computation of the metrics will be made on the Human Assessment Module and will be integrated in the system that will Tune the autonomy Level of the system. Taking this into account, the objective is to be able to tune the system autonomy level based on the implicit assessment in real time.<br/>For example, higher traffic or hard situations/decisions will be detected with any interference with the human operator, implicitly providing information to be used by the decision system.<br/>This KPI will not focus on the final results when this module is integrated, but in the calculation of personalized cognitive and stress metrics of a single human based on an individual assessment protocol. If we are not able to perform such protocol, then this module will be generic and not personalized, removing this KPIs. In the personalization we aim to achieve a 20-30% improvement on performance of the model based for a single individual data, enabling a high level of personalization.<br/>This KPI contributes to evaluati', array['f1878cc0-4767-4c54-9df5-32f4a03c84bc']::uuid[])
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
    VALUES ('6ae869dc-40e3-4cd0-a02c-6541a838b5b3', 'Scenario 1 - Cognitive Performance & Stress KPI performs an implicit assessment of the human cognitive performance status and stress levels along the different task that will be performed. The output provides information about the operator mental status and aims to be used to integrate the AI system to contribute as a reward to better adapt decision system. ', 'The computation of the metrics will be made on the Human Assessment Module and will be integrated in the system that will Tune the autonomy Level of the system. Taking this into account, the objective is to be able to tune the system autonomy level based on the implicit assessment in real time.<br/>For example, higher traffic or hard situations/decisions will be detected with any interference with the human operator, implicitly providing information to be used by the decision system.<br/>This KPI will not focus on the final results when this module is integrated, but in the calculation of personalized cognitive and stress metrics of a single human based on an individual assessment protocol. If we are not able to perform such protocol, then this module will be generic and not personalized, removing this KPIs. In the personalization we aim to achieve a 20-30% improvement on performance of the model based for a single individual data, enabling a high level of personalization.<br/>This KPI contributes to evaluati', array['596704a6-32b5-4694-bce5-2534a2edb8ac']::uuid[])
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
    VALUES ('4b04f1b7-a4b0-4b71-8f75-6a222bb05284', 'Scenario 1 - Cognitive Performance & Stress KPI performs an implicit assessment of the human cognitive performance status and stress levels along the different task that will be performed. The output provides information about the operator mental status and aims to be used to integrate the AI system to contribute as a reward to better adapt decision system. ', 'The computation of the metrics will be made on the Human Assessment Module and will be integrated in the system that will Tune the autonomy Level of the system. Taking this into account, the objective is to be able to tune the system autonomy level based on the implicit assessment in real time.<br/>For example, higher traffic or hard situations/decisions will be detected with any interference with the human operator, implicitly providing information to be used by the decision system.<br/>This KPI will not focus on the final results when this module is integrated, but in the calculation of personalized cognitive and stress metrics of a single human based on an individual assessment protocol. If we are not able to perform such protocol, then this module will be generic and not personalized, removing this KPIs. In the personalization we aim to achieve a 20-30% improvement on performance of the model based for a single individual data, enabling a high level of personalization.<br/>This KPI contributes to evaluati', array['6e7acf6f-aead-444f-b797-f7d18c592819']::uuid[])
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
    VALUES ('0d85a097-9170-42aa-99ea-d56b833c27cf', 'Scenario 1 - Acceptance of the system by a human user.', 'This KPI contributes to evaluating AI acceptability, trust and trustworthiness of the AI-based assistant, as part of Task 4.3 evaluation objectives, and O2 main project objective. ', array['cf296c89-a971-4c74-aa19-5b08a6e4c86e']::uuid[])
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
    VALUES ('b4b167ff-56be-43a1-9a80-121eaaf8108f', 'Scenario 1 - Acceptance of the system by a human user.', 'This KPI contributes to evaluating AI acceptability, trust and trustworthiness of the AI-based assistant, as part of Task 4.3 evaluation objectives, and O2 main project objective. ', array['76cb53ca-86f8-4895-908f-d6d4bf256b09']::uuid[])
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
    VALUES ('91da4c1c-3011-4f70-809f-8204cd3824ba', 'Scenario 1 - Acceptance of the system by a human user.', 'This KPI contributes to evaluating AI acceptability, trust and trustworthiness of the AI-based assistant, as part of Task 4.3 evaluation objectives, and O2 main project objective. ', array['f4f4211a-e0fd-4b61-b05f-e47363c1786f']::uuid[])
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
    VALUES ('9db20a76-763a-4597-9586-cb217981e191', 'Scenario 1 - This KPI represents human operators’ self-reported agreement with individual AI-generated solutions/decisions on a scale of 0–100. ', 'This KPI contributes to evaluating AI acceptability, trust and trustworthiness of the AI-based assistant, as part of Task 4.3 evaluation objectives, and O2 main project objective.<br/>It is also relevant to protocols and concepts defined in D1.1 such as “Agreement score”.  ', array['62598708-cd90-4dc5-8ef9-4b8243a96e27']::uuid[])
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
    VALUES ('631244e4-ade3-4cbb-afd6-a19e56c001d6', 'Scenario 1 - This KPI represents human operators’ self-reported agreement with individual AI-generated solutions/decisions on a scale of 0–100. ', 'This KPI contributes to evaluating AI acceptability, trust and trustworthiness of the AI-based assistant, as part of Task 4.3 evaluation objectives, and O2 main project objective.<br/>It is also relevant to protocols and concepts defined in D1.1 such as “Agreement score”.  ', array['6ca312a1-5b41-43ce-b81f-899bb3ebb0d1']::uuid[])
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
    VALUES ('5ec8e7f8-a26d-4263-95ea-6c7a0832f61d', 'Scenario 1 - This KPI represents human operators’ self-reported agreement with individual AI-generated solutions/decisions on a scale of 0–100. ', 'This KPI contributes to evaluating AI acceptability, trust and trustworthiness of the AI-based assistant, as part of Task 4.3 evaluation objectives, and O2 main project objective.<br/>It is also relevant to protocols and concepts defined in D1.1 such as “Agreement score”.  ', array['701cf78b-17fe-4c09-9714-448b22a61766']::uuid[])
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
    VALUES ('0ee42e0f-a284-4979-86e8-4e50c9bfcef7', 'Scenario 1 - This KPI represents human operators’ self-reported ability to understand and thus make use of the AI-generated solution/decision, measured with a questionnaire. ', 'This KPI contributes to evaluating AI acceptability, trust and trustworthiness of the AI-based assistant, as part of Task 4.3 evaluation objectives, and O2 main project objective.<br/>It is also relevant to protocols and concepts defined in D1.1 such as “Comprehensibility”.  ', array['eee8e62b-a5c3-44a4-bfb0-9a24f63291b2']::uuid[])
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
    VALUES ('9d6c321f-25c4-4b31-91e6-0208c1da3455', 'Scenario 1 - This KPI represents human operators’ self-reported ability to understand and thus make use of the AI-generated solution/decision, measured with a questionnaire. ', 'This KPI contributes to evaluating AI acceptability, trust and trustworthiness of the AI-based assistant, as part of Task 4.3 evaluation objectives, and O2 main project objective.<br/>It is also relevant to protocols and concepts defined in D1.1 such as “Comprehensibility”.  ', array['cb479f8f-f4fc-4c71-b2cc-0b4212fe95ce']::uuid[])
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
    VALUES ('2057f6f2-015b-4370-a4db-40bb8cd9b244', 'Scenario 1 - This KPI represents human operators’ self-reported ability to understand and thus make use of the AI-generated solution/decision, measured with a questionnaire. ', 'This KPI contributes to evaluating AI acceptability, trust and trustworthiness of the AI-based assistant, as part of Task 4.3 evaluation objectives, and O2 main project objective.<br/>It is also relevant to protocols and concepts defined in D1.1 such as “Comprehensibility”.  ', array['b4007321-4acc-4868-b4eb-27284244b574']::uuid[])
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
    VALUES ('7b07ae08-9153-42cd-b1e9-6c03f3c1df31', 'Scenario 1 - This KPI represents human operators’ self-reported trust (attitude) for individual AI-generated solutions measured with a questionnaire. ', 'This KPI contributes to evaluating AI acceptability, trust and trustworthiness of the AI-based assistant, as part of Task 4.3 evaluation objectives, and O2 main project objective.<br/>It is also relevant to protocols and concepts defined in D1.1 such as “Trust in AI solutions score”.  ', array['9530cdc4-ed66-48f0-9aa9-f7fcd2d3fb38']::uuid[])
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
    VALUES ('5314d4ab-35d4-4bc3-ade8-3b17bd39dd82', 'Scenario 1 - This KPI represents human operators’ self-reported trust (attitude) for individual AI-generated solutions measured with a questionnaire. ', 'This KPI contributes to evaluating AI acceptability, trust and trustworthiness of the AI-based assistant, as part of Task 4.3 evaluation objectives, and O2 main project objective.<br/>It is also relevant to protocols and concepts defined in D1.1 such as “Trust in AI solutions score”.  ', array['750dcb3a-3bd4-4dc6-b5eb-767e6a2b1484']::uuid[])
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
    VALUES ('e5063e27-d81b-499b-8827-b2a8ab0ff8d8', 'Scenario 1 - This KPI represents human operators’ self-reported trust (attitude) for individual AI-generated solutions measured with a questionnaire. ', 'This KPI contributes to evaluating AI acceptability, trust and trustworthiness of the AI-based assistant, as part of Task 4.3 evaluation objectives, and O2 main project objective.<br/>It is also relevant to protocols and concepts defined in D1.1 such as “Trust in AI solutions score”.  ', array['f3645865-2353-4077-943d-30516d275ea1']::uuid[])
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
    VALUES ('0e9f4bb5-6e39-4ccb-b5ae-81b9a1f91607', 'Scenario 1 - (Dis)trust is defined here as a sentiment resulting from knowledge, beliefs, emotions, and other elements derived from lived or transmitted experience, which generates positive or negative expectations concerning the reactions of a system and the interaction with it (whether it is a question of another human being, an organization or a technology)” (Cahour & Forzy, 2009, p. 1261). ', 'This KPI contributes to evaluating AI acceptability, trust and trustworthiness of the AI-based assistant, as part of Task 4.3 evaluation objectives, and O2 main project objective. ', array['5ca84b5c-b2f6-43c7-a6b8-efe47660e40f']::uuid[])
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
    VALUES ('2d5f2c8a-5cfd-4f32-9174-7ae81a82f0be', 'Scenario 1 - (Dis)trust is defined here as a sentiment resulting from knowledge, beliefs, emotions, and other elements derived from lived or transmitted experience, which generates positive or negative expectations concerning the reactions of a system and the interaction with it (whether it is a question of another human being, an organization or a technology)” (Cahour & Forzy, 2009, p. 1261). ', 'This KPI contributes to evaluating AI acceptability, trust and trustworthiness of the AI-based assistant, as part of Task 4.3 evaluation objectives, and O2 main project objective. ', array['1b354632-d9ac-4048-81f2-5432921286e2']::uuid[])
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
    VALUES ('a5785b63-ccee-4108-ad34-32f861beeadf', 'Scenario 1 - (Dis)trust is defined here as a sentiment resulting from knowledge, beliefs, emotions, and other elements derived from lived or transmitted experience, which generates positive or negative expectations concerning the reactions of a system and the interaction with it (whether it is a question of another human being, an organization or a technology)” (Cahour & Forzy, 2009, p. 1261). ', 'This KPI contributes to evaluating AI acceptability, trust and trustworthiness of the AI-based assistant, as part of Task 4.3 evaluation objectives, and O2 main project objective. ', array['3790034c-09e2-44be-b809-2c5212e6a7d9']::uuid[])
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
    VALUES ('6c383eec-31cd-4f3c-9296-cc5bb0d7f4c9', 'Scenario 1 - The Human Intervention Frequency KPI measures the proportion of instances in which a human operator intervenes in an automated decision-making process. While this KPI was initially developed for railway traffic control scenarios, it has been generalized to assess the reliability and autonomy of any AI-assisted system. It reflects the trust placed in the AI by quantifying how often human corrections are required during routine operations. ', 'This KPI contributes to evaluating Social-technical decision quality of the AI-based assistant, as part of Task 4.3 evaluation objectives, and O3 main project objective:<br/>- To evaluate the effectiveness of the AI system in operating autonomously.<br/>- To provide a performance benchmark for minimizing human interventions across various domains.<br/>- To identify areas where the AI may require additional refinement or support. ', array['1362ead2-16e9-401e-8da6-251236369d72']::uuid[])
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
    VALUES ('81cb1769-35b5-4b97-aff0-b0d070dd6e50', 'Scenario 1 - The Human Intervention Frequency KPI measures the proportion of instances in which a human operator intervenes in an automated decision-making process. While this KPI was initially developed for railway traffic control scenarios, it has been generalized to assess the reliability and autonomy of any AI-assisted system. It reflects the trust placed in the AI by quantifying how often human corrections are required during routine operations. ', 'This KPI contributes to evaluating Social-technical decision quality of the AI-based assistant, as part of Task 4.3 evaluation objectives, and O3 main project objective:<br/>- To evaluate the effectiveness of the AI system in operating autonomously.<br/>- To provide a performance benchmark for minimizing human interventions across various domains.<br/>- To identify areas where the AI may require additional refinement or support. ', array['7d55949e-0c19-4623-875f-95c09bfd55f6']::uuid[])
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
    VALUES ('0db9f3ea-ac49-4914-b491-ecf3f1f35263', 'Scenario 1 - The Human Intervention Frequency KPI measures the proportion of instances in which a human operator intervenes in an automated decision-making process. While this KPI was initially developed for railway traffic control scenarios, it has been generalized to assess the reliability and autonomy of any AI-assisted system. It reflects the trust placed in the AI by quantifying how often human corrections are required during routine operations. ', 'This KPI contributes to evaluating Social-technical decision quality of the AI-based assistant, as part of Task 4.3 evaluation objectives, and O3 main project objective:<br/>- To evaluate the effectiveness of the AI system in operating autonomously.<br/>- To provide a performance benchmark for minimizing human interventions across various domains.<br/>- To identify areas where the AI may require additional refinement or support. ', array['13238d69-4caa-4292-a5f1-94d25262dbe8']::uuid[])
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
    VALUES ('eee4453e-477f-4057-ad7b-c1c2233ed108', 'Scenario 1 - This KPI represents human operators’ subjective assessment of necessary revisions for the AI-generated solutions by the human operator, self-reported by the operator with Likert-scale questions. ', 'This KPI contributes to evaluating Social-technical decision quality of the AI-based assistant, as part of Task 4.3 evaluation objectives, and O3 main project objective.<br/>It is also relevant to protocols and concepts defined in D1.1 such as “Significance of human revisions”.  ', array['e9aad7a4-3ef8-4ae5-8f4b-dc972a8378ff']::uuid[])
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
    VALUES ('79f0ed9e-094f-4637-921c-814707f3b02e', 'Scenario 1 - This KPI represents human operators’ subjective assessment of necessary revisions for the AI-generated solutions by the human operator, self-reported by the operator with Likert-scale questions. ', 'This KPI contributes to evaluating Social-technical decision quality of the AI-based assistant, as part of Task 4.3 evaluation objectives, and O3 main project objective.<br/>It is also relevant to protocols and concepts defined in D1.1 such as “Significance of human revisions”.  ', array['d1a5803e-298a-413f-bb66-c5677b0cd265']::uuid[])
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
    VALUES ('a365a4df-98d6-4c7b-83bb-63b5ccb68581', 'Scenario 1 - This KPI represents human operators’ subjective assessment of necessary revisions for the AI-generated solutions by the human operator, self-reported by the operator with Likert-scale questions. ', 'This KPI contributes to evaluating Social-technical decision quality of the AI-based assistant, as part of Task 4.3 evaluation objectives, and O3 main project objective.<br/>It is also relevant to protocols and concepts defined in D1.1 such as “Significance of human revisions”.  ', array['8cf309e8-a558-4cad-b24a-0791ae089f3d']::uuid[])
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
    VALUES ('b228ee9c-de35-4efd-b59a-7c4bb95ca127', 'Scenario 1 - This KPI represents human operators’ self-reported subjective assessment of nontriviality for the AI-generated solutions measured with a questionnaire. ', 'This KPI contributes to evaluating Social-technical decision quality of the AI-based assistant, as part of Task 4.3 evaluation objectives, and O3 main project objective. ', array['156722a0-0cc7-42dc-9ea0-885afb2f1e69']::uuid[])
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
    VALUES ('b3b52505-caa6-4438-90b8-6ac84e9880d9', 'Scenario 1 - This KPI represents human operators’ self-reported subjective assessment of nontriviality for the AI-generated solutions measured with a questionnaire. ', 'This KPI contributes to evaluating Social-technical decision quality of the AI-based assistant, as part of Task 4.3 evaluation objectives, and O3 main project objective. ', array['aec036cc-7b38-42e1-8660-7edff5e86e54']::uuid[])
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
    VALUES ('ab1d9b2b-b91f-440f-ad16-54ccabb25230', 'Scenario 1 - This KPI represents human operators’ self-reported subjective assessment of nontriviality for the AI-generated solutions measured with a questionnaire. ', 'This KPI contributes to evaluating Social-technical decision quality of the AI-based assistant, as part of Task 4.3 evaluation objectives, and O3 main project objective. ', array['19ee2451-b3e5-43bb-89c7-8137fd988bfb']::uuid[])
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
    VALUES ('9fdd3565-45d6-4d83-9cda-478c56e94f26', 'Scenario 1 - This KPI represents human operators’ self-reported assessment of the AI ability to adapt to the operators’ preferences measured with a questionnaire. ', 'This KPI contributes to evaluating AI-human learning curves of the AI-based assistant, as part of Task 4.3 evaluation objectives, and O3 main project objective.<br/>It is also relevant to protocols and concepts defined in D1.1 such as “AI co-learning capability”.  ', array['18246932-0833-40e9-880c-432cec4d0cec']::uuid[])
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
    VALUES ('91b63e8f-7cf1-461c-98ea-0269b26bb3b4', 'Scenario 1 - This KPI represents human operators’ self-reported assessment of the AI ability to adapt to the operators’ preferences measured with a questionnaire. ', 'This KPI contributes to evaluating AI-human learning curves of the AI-based assistant, as part of Task 4.3 evaluation objectives, and O3 main project objective.<br/>It is also relevant to protocols and concepts defined in D1.1 such as “AI co-learning capability”.  ', array['cba93682-5514-46e1-8399-60bdee8f3bd9']::uuid[])
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
    VALUES ('af91490d-d1cf-4644-aaec-887e320e4a36', 'Scenario 1 - This KPI represents human operators’ self-reported assessment of the AI ability to adapt to the operators’ preferences measured with a questionnaire. ', 'This KPI contributes to evaluating AI-human learning curves of the AI-based assistant, as part of Task 4.3 evaluation objectives, and O3 main project objective.<br/>It is also relevant to protocols and concepts defined in D1.1 such as “AI co-learning capability”.  ', array['a0b93bbc-dedd-4e40-b772-c45b9d93488f']::uuid[])
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
    VALUES ('b4c9184c-c0d1-4a0c-bab1-9210bf8cb548', 'Scenario 1 - Human learning is a complex process that leads to lasting changes in humans, influencing their perceptions of the world and their interactions with it across physical, psychological, and social dimensions. It is fundamentally shaped by the ongoing, interactive relationship between the learner''s characteristics and the learning content, all situated within the specific environmental context of time and place and the continuity over time. ', 'This KPI contributes to evaluating AI-human learning curves of the AI-based assistant, as part of Task 4.3 evaluation objectives, and O3 main project objective. ', array['03584304-31ae-432a-8d0c-db51bff866e1']::uuid[])
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
    VALUES ('6958bf4c-39ff-484f-b609-25500e9e314a', 'Scenario 1 - Human learning is a complex process that leads to lasting changes in humans, influencing their perceptions of the world and their interactions with it across physical, psychological, and social dimensions. It is fundamentally shaped by the ongoing, interactive relationship between the learner''s characteristics and the learning content, all situated within the specific environmental context of time and place and the continuity over time. ', 'This KPI contributes to evaluating AI-human learning curves of the AI-based assistant, as part of Task 4.3 evaluation objectives, and O3 main project objective. ', array['332feb56-b546-4a7f-bc08-1320c024ec59']::uuid[])
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
    VALUES ('dd069d03-4ff6-4c9a-b3a6-bf1f1471e640', 'Scenario 1 - Human learning is a complex process that leads to lasting changes in humans, influencing their perceptions of the world and their interactions with it across physical, psychological, and social dimensions. It is fundamentally shaped by the ongoing, interactive relationship between the learner''s characteristics and the learning content, all situated within the specific environmental context of time and place and the continuity over time. ', 'This KPI contributes to evaluating AI-human learning curves of the AI-based assistant, as part of Task 4.3 evaluation objectives, and O3 main project objective. ', array['13cb3739-9b00-45d8-a511-91d8df7a33c3']::uuid[])
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
    VALUES ('aba10b3f-0d5c-4f90-aec4-69460bbb098b', 'KPI-AF-008: Assistant alert accuracy (Power Grid)', 'Assistant alert accuracy is based on the number of times the AI assistant agent is right about forecasted issues ahead of time.<br/>Even if forecasted issues concern all events that lead to a grid state out of acceptable limits (set by operation policy), use cases of the project focus on managing overloads only: this KPI therefore only focuses on alerts related to line overloads.<br/>The calculation of KPI relies on simulation of 2 parallel paths (starting from the moment the alert is raised):<br/>- Simulation of the “do nothing” path, to assess the truth values<br/>- Application of remedial actions to the “do nothing” path, to assess solved cases<br/>To calculate the KPI, all interventions by an agent or operator are fixed to a specific plan since every alert is related to a specific plan (e.g. remedial actions).<br/>Note: line contingencies for which alerts can be raised are the lines that can be attacked in the environment (env.alertable_line_ids in grid2Op), so this should be properly configured beforehand. ', array['fcabd61d-91bc-45dc-8bf8-7aeb9724cb67']::uuid[], array['729cc815-ac93-4209-9f62-b57b920c2d0a']::uuid[], 'CLOSED', 'PowerGrid')
    ON CONFLICT(id) DO UPDATE SET name=EXCLUDED.name, description=EXCLUDED.description, field_ids=EXCLUDED.field_ids, scenario_ids=EXCLUDED.scenario_ids, loop=EXCLUDED.loop, queue=EXCLUDED.queue;

INSERT INTO field_definitions
        (id, key, description, agg_func, agg_weights)
        VALUES ('fcabd61d-91bc-45dc-8bf8-7aeb9724cb67', 'primary', 'Benchmark score (MEAN of test scores)', 'MEAN', NULL)
        ON CONFLICT(id) DO UPDATE SET key=EXCLUDED.key, description=EXCLUDED.description, agg_func=EXCLUDED.agg_func, agg_weights=EXCLUDED.agg_weights;

INSERT INTO scenario_definitions
    (id, name, description, field_ids)
    VALUES ('729cc815-ac93-4209-9f62-b57b920c2d0a', 'Scenario 1 - Assistant alert accuracy is based on the number of times the AI assistant agent is right about forecasted issues ahead of time.<br/>Even if forecasted issues concern all events that lead to a grid state out of acceptable limits (set by operation policy), use cases of the project focus on managing overloads only: this KPI therefore only focuses on alerts related to line overloads.<br/>The calculation of KPI relies on simulation of 2 parallel paths (starting from the moment the alert is raised):<br/>- Simulation of the “do nothing” path, to assess the truth values<br/>- Application of remedial actions to the “do nothing” path, to assess solved cases<br/>To calculate the KPI, all interventions by an agent or operator are fixed to a specific plan since every alert is related to a specific plan (e.g. remedial actions).<br/>Note: line contingencies for which alerts can be raised are the lines that can be attacked in the environment (env.alertable_line_ids in grid2Op), so this should be properly configu', 'This KPI contributes to evaluating Effectiveness of the AI-based assistant, as part of Task 4.1 evaluation objectives, and O2 main project objective. ', array['7f5b985b-d3a9-4e96-bd01-53ca1b73b256']::uuid[])
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
    VALUES ('ba7f9aac-5e96-4436-bae1-23629c4d153b', 'Scenario 1 - The Delay Reduction Efficiency KPI quantifies the effectiveness of the AI-driven re-scheduling system in reducing overall train delays. By comparing delays before and after AI intervention, this metric provides insight into the system''s capability to optimize train schedules and minimize disruptions. ', 'This KPI contributes to evaluating Effectiveness of the AI-based assistant, as part of Task 4.1 evaluation objectives, and O2 main project objective:<br/>- To assess the impact of AI-based re-scheduling on reducing delays in railway operations.<br/>- To ensure that AI interventions lead to measurable improvements in punctuality.<br/>- To provide a performance benchmark for AI-driven traffic management solutions in railway networks. ', array['18da02bc-6f0c-4cac-a080-ee03974d9a8d']::uuid[])
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
    VALUES ('ed8ba2fc-853e-4e79-a984-b1986b9b6e97', 'Scenario 1 - Network utilization KPI is based on the relative line loads of the network, indicating to what extent the network and its components are utilized.', 'This KPI contributes to evaluating Effectiveness of the AI-based assistant, as part of Task 4.1 evaluation objectives, and O2 main project objective. ', array['68a7aead-7408-4cfa-92ee-8c108e0bf5c7']::uuid[])
    ON CONFLICT(id) DO UPDATE SET name=EXCLUDED.name, description=EXCLUDED.description, field_ids=EXCLUDED.field_ids;

INSERT INTO field_definitions
        (id, key, description, agg_func, agg_weights)
        VALUES ('68a7aead-7408-4cfa-92ee-8c108e0bf5c7', 'primary', 'Scenario score (raw values)', NULL, NULL)
        ON CONFLICT(id) DO UPDATE SET key=EXCLUDED.key, description=EXCLUDED.description, agg_func=EXCLUDED.agg_func, agg_weights=EXCLUDED.agg_weights;

INSERT INTO test_definitions
    (id, name, description, field_ids, scenario_ids, loop, queue)
    VALUES ('98ceb866-5479-47e6-a735-81292de8ca65', 'KPI-PF-026: Punctuality (Railway)', 'Punctuality measures the percentage of trains arriving at their destinations on time (the train doesn’t arrive after planned arrival) and the train didn’t depart before planned departure time. The goal is to maintain a high level of reliability and minimize delays for passengers and freight services. ', array['1de0f52c-ae47-4847-9148-97b8568952d3']::uuid[], array['5a60713d-01f2-4d32-9867-21904629e254', '0db72a40-43e8-477b-89b3-a7bd1224660a', '7def3118-2e9c-4de7-8d61-f0e76fbeee5d', '3ae60635-6995-4fb1-8309-61fded3d6fd8', 'eeef8445-723d-4740-b89f-4dbaf75f9ae6', '94af1ed1-3686-4a9e-99f5-3a7ad908f125', '8250d0e2-700e-4051-85c3-a8d0d95a5f0f', 'c58759a7-a64a-4cbf-970b-948bae0c2254', 'f94f517f-c0a4-4415-b726-186cdc75f9c6', 'c0e2c3e0-c171-48dd-a312-5de070e3f937', '26fb51b9-2466-48ab-8c0a-89d9536d4c34', '66c23554-47bb-4268-b08e-518f6f163e9d', '08641d25-9b18-41bb-9cbc-4039b4ad24f0', '4d3dd85a-2b16-45de-b524-f83b4a58a2f4', 'bf9209c7-125c-42f9-b78e-4e5b7aacefcc', 'f511044d-2378-4c7f-af92-45c78146bdef', 'f89cee49-e1ae-427d-ae42-5cc411661a1c', '262e43bd-bf35-4171-b38b-c77969db0b16', '61bd29ec-0b09-4067-ada0-b43e48a8ac9a', '92d22472-4696-40ba-924f-861a2f4343b6', '6fc5f67a-40fa-45ce-819e-35a85e08e560', '66bce513-502c-43b4-a155-8a16c410a7c6', 'eff645bf-7ea8-490d-ae8a-ebb0d16a774c', '8397e6d6-babc-469b-a239-7eabcbd510da', 'c359f13c-d222-4b04-ad0a-2bb30fb9da5f', '97203764-6717-4ca6-bae9-c35c4eb38206', 'adc4bf52-096c-4369-a85f-c9bf4b86bc64', '72f93d48-ecef-4bf7-9d97-cb008b47e566', 'b470667b-d9c9-4af4-b64e-c32102c34387', '4aa9e1b8-8669-466e-b4b9-c7db2a098bec', '44354e67-e0b7-4faa-9385-2d6247c7a50c', '4bca2964-ef35-4b03-a47e-829bc9078374', '6190b6ac-a06b-4b07-8b82-0dfb1088663f', 'a51d4e4a-c841-416f-9292-fc64dead758b', 'd08f6539-5c3e-4a98-93ae-3e344611e3a8', '8a2ec760-d2c2-4329-b373-3acd95395076', '9b136147-f560-45d4-abd8-9f7de7cd7570', '9723c2c5-ee55-441d-9dba-1a1dc23fdc5e', '3406bbe9-cb19-44b7-af26-460b0a117a6c', 'ae0a88ad-3bfd-4201-b28a-e2c75d081cd5', '8b308495-7ea6-4ddc-acb4-56eb5b3aec12', 'a8f69dc4-04a1-434a-ad97-27c745561b6a', '8b244f56-50e1-411a-a7d8-a2b89dfab26e', '8e6419c1-6470-4272-9c4b-43d9fe19dd3d', 'ec503b6e-3682-4dcd-9dc7-b194b67283d9', '74fd9eab-d2e5-4222-8656-81fc2dde7c21', 'c16e54c1-33b2-45b8-95b0-33cc4f5400d5', 'c80effec-27b8-4103-b726-344a85f35407', '9bec9335-3dd5-4d88-b2ac-c5d711bcab36', '4a067d3c-75e6-4e91-a42d-cdf291016674', '1f6c674b-fdb5-40c8-bbe3-d924c2b7146e', '8bd15e2f-6089-4022-8383-26a36093dc80', '5b026a8a-e0dc-47d2-b2ce-d0bfc083e6c5', 'ab2e2bba-baa0-45de-b639-c7ebf29bf947', '8f8b6f67-d3c3-41ec-b60d-2924577e68f4', '3e59642a-7b20-4989-b9e6-01a35a82b9da', '0e4618c7-7ab7-4323-855c-7f95cbaef2d0', '4a59929b-b391-464f-bfa1-628f7a45ac36', '27f8ac34-3d09-4b68-9fb4-c51cfbfd09df', 'bacb4c11-11b4-4c76-910d-f92abc5b7a39', 'a5dff3c8-902e-4cb9-8466-d277d0ed4d67', 'aca25feb-6254-40b3-8d40-3c805797c69b', 'deb21442-0f94-4ff3-b78d-8d418415d646', '6cf2cc89-d30e-4063-bced-051f3cdae92f', '84bcbff5-346f-452c-87ab-08ceff6364f2', '9acbe68e-2a45-420b-a142-34996dbcfb83', '42786e4c-c80e-40f5-8237-bafc5f39979d', '242a6240-b62c-48b4-a264-b6737e893fa5', '3c38a1d3-2340-43ed-ac0b-4b76c6588b92', 'b89daede-405b-411a-a02b-ee32d7c9d020', '736301d9-0cff-4e25-af78-4d6f78b48cd5', '3b74e3a8-e740-4bb2-802f-2b2bedabad65', '61ee09b0-96fb-4562-bf7d-a01606de424c', '8d75b03c-2a34-4b2a-8408-d8db01a7ae1a', '81c01671-1a30-41cd-9f6c-25b2f9253da9', '01723b62-3f4d-4921-8904-752f092588f5', '5d44cb89-3c63-4716-8551-bd25de881f89', 'cf7c97fc-1c61-4c0d-ad1e-952bf6d6f23a', '60ddab54-dc12-4fbd-bbec-53b23d896c9d', '7eab41ad-8fd5-4a04-8c06-4d6c2016a594', '9e0aac9e-ddf9-4575-bf1c-d08a923e15fa', 'befa97fb-2a74-4f2e-91c8-ea2879d08dcf', '0cc18965-c967-4b58-ac7f-38a443b4cd16', 'd0f62f51-5a51-443b-bf7b-18e3d5b191dc', 'c2ebb179-0a2d-4e84-95be-2837be406716', '3ac76f3c-f560-4666-af61-c693e4cd3ad4', '484bbf93-bc67-4726-8b81-6c4ab608c861', '11b19a5f-4d61-4b5d-980c-98cf0c16906a', 'edecaeb7-53d3-411a-a00c-2ce6226fde50', 'a43cb746-fa63-4d39-87cd-43a81fbf3a8e', '5a3cc8a5-584c-4171-ae2c-97bdbc5047a1', '30778350-508b-4cbe-bff2-8882d0743aed', 'dc652dd4-c0b5-4036-bb70-f71cd9fd488a', '6e4dd7f4-2155-407f-922b-25aeb04a47b7', 'ba75d8cb-bfb9-4d2b-ac2f-2b5b8697188c', '10c621d6-1f99-4045-82a0-47d3ea107ddc', '7a6b6aeb-af0e-441f-97b5-d5db846bb045', '8e2cfb59-d31b-4346-b67a-b96a12ca04f5', '2661fcc0-9b3c-45bd-b60e-3c6351acabd1', 'efcce7b2-e33a-4510-af56-09db1bfb5bd0', 'c643a6ba-a8a3-42de-afcc-fa92328397b7', '86c8d140-2b1d-41df-ba97-a959c54d2c19', '9826d43a-6be2-49ac-bfd7-fa2475f62985', '151f38af-a59a-42f8-9b2e-2df3fef3f658', '5b7b42ed-e41a-4e97-806a-6287ac918537', 'd897ffe6-43a8-4ebc-9881-6097be7711e7', '95aa9a6b-b80a-4dcc-a0a4-228f53bc7959', '0330f00b-412e-44d5-b7cc-23bebd26fa88', '9742751d-d670-4310-97ab-a14973112470', '72df8c4b-f0ef-438d-9858-88053cb188c1', '05b4cb03-5576-4d79-9afa-1c6318d632ec', '6db73b00-b6f1-4f63-9fd0-49f518361ee2', '69df632e-d2aa-4005-a9e2-1c5e07eeebd9', '09aff9df-7c67-4810-8e13-90f8c9bd05a1', '3de1e810-7abe-4dd4-9663-e19270c37c52', 'afd8d475-9bd3-4740-a5be-293cd211b34d', 'de0a8389-d573-483c-811b-e7829bd58a54', '65b60f43-6a71-4c7b-805f-6c3f564c87bb', '8d1746ff-83c6-4675-acd7-01a2a654ec0a', '011866d3-76a6-4b5a-9c42-447e2d567892', '23d5ddd1-1fb0-4149-bf59-a2e7cd34213a', '1990750e-de0f-4789-9dcc-dae5b9b99173', 'b127b87c-600d-4f28-b74a-e6c33d27e42f', 'bf0f6ceb-62fd-4a92-a7b0-29cf898b05e1', '103881e7-8415-4d6b-90c5-cef06f36b5b3', '8c558c8b-1a04-4c38-9f98-20cd5c8195a7', '5c025c8a-a032-494f-8204-dd92b1067448', '441fe9aa-79d7-4e27-8fb5-213c77c4f295', 'b630c1ad-f3a1-41c3-8e34-735a78dec9d1', '3200dbee-2685-48c7-a7dc-2e780853efda', '46583ddd-855b-4e6d-8711-d7b5a4fd26c1', 'a497e35d-fd84-4be2-a45d-f847962cd5f8', '295d5dc4-f4d4-4016-8fc0-4badd1b9c94e', 'f8934f7d-e1f6-462e-8a12-dc82c440bc90', '30fd755b-9f29-4330-b4d3-8eccc44ffade', 'a9cf3c28-8b08-451a-830f-b737936a9579', '273b434f-74b7-4581-9d69-13f030b67313', 'fcf115d7-4246-4790-a89d-666f368b3356', 'c1306680-d5e0-4629-939d-ee9e3f4c439b', 'a5cafc37-5ab6-40b2-8c1b-19089e724b1d', '34606fe8-3ba5-4778-a7f0-0275c1def3b8', '2d6ffd36-f33d-4a68-9868-53c7aa3f4011', '38e4e4d4-f801-42a0-8eac-a1a9a41a8a3e', 'bec0103f-bdf4-42b5-b04e-a44528b8c8d1', '1e01bc5e-dcdb-4ef1-94a6-f4e3a77613b8', '5debda2f-e5c1-447e-b025-d71252591074', '2d8872a4-f002-4294-9396-91d9cefabdb7', 'ac4adfe9-a213-45bd-843b-f346c9891b2c', 'b59c4643-2b45-45e4-89f7-007ef1955c9f', 'f56f6f85-9aff-4f4e-bd84-8d763708e76f']::uuid[], 'CLOSED', 'Railway')
    ON CONFLICT(id) DO UPDATE SET name=EXCLUDED.name, description=EXCLUDED.description, field_ids=EXCLUDED.field_ids, scenario_ids=EXCLUDED.scenario_ids, loop=EXCLUDED.loop, queue=EXCLUDED.queue;

INSERT INTO field_definitions
        (id, key, description, agg_func, agg_weights)
        VALUES ('1de0f52c-ae47-4847-9148-97b8568952d3', 'sum_normalized_reward', 'Benchmark score (MEAN of test scores)', 'MEAN', NULL)
        ON CONFLICT(id) DO UPDATE SET key=EXCLUDED.key, description=EXCLUDED.description, agg_func=EXCLUDED.agg_func, agg_weights=EXCLUDED.agg_weights;

INSERT INTO scenario_definitions
    (id, name, description, field_ids)
    VALUES ('5a60713d-01f2-4d32-9867-21904629e254', 'Scenario 000 - Punctuality measures the percentage of trains arriving at their destinations on time (the train doesn’t arrive after planned arrival) and the train didn’t depart before planned departure time. The goal is to maintain a high level of reliability and minimize delays for passengers and freight services. ', 'This KPI contributes to evaluating Effectiveness of the AI-based assistant, as part of Task 4.1 evaluation objectives, and O2 main project objective:<br/>- Improve customer satisfaction by ensuring timely arrivals<br/>- Guarantee maximal planned connection<br/>- Minimize operational disruptions caused by delays<br/>- Meet regulatory and stakeholder benchmarks for punctuality<br/>This KPI is linked with project’s Long Term Expected Impacts (LTEI) (LTEI1)KPIS-3:<br/>- 10% increase in punctuality in long-range traffic<br/>- 5% increase in punctuality in regional traffic (with realistic disturbances)<br/>', array['c2a66425-186d-423b-b002-391c091b33c6', 'f56b119f-719d-4601-94ff-e511b2aaeeed']::uuid[])
    ON CONFLICT(id) DO UPDATE SET name=EXCLUDED.name, description=EXCLUDED.description, field_ids=EXCLUDED.field_ids;

INSERT INTO field_definitions
        (id, key, description, agg_func, agg_weights)
        VALUES ('c2a66425-186d-423b-b002-391c091b33c6', 'sum_normalized_reward', 'Primary scenario score (raw values): sum_normalized_reward', NULL, NULL)
        ON CONFLICT(id) DO UPDATE SET key=EXCLUDED.key, description=EXCLUDED.description, agg_func=EXCLUDED.agg_func, agg_weights=EXCLUDED.agg_weights;

INSERT INTO field_definitions
        (id, key, description, agg_func, agg_weights)
        VALUES ('f56b119f-719d-4601-94ff-e511b2aaeeed', 'success_rate', 'Secondary scenario score (raw values): success_rate', NULL, NULL)
        ON CONFLICT(id) DO UPDATE SET key=EXCLUDED.key, description=EXCLUDED.description, agg_func=EXCLUDED.agg_func, agg_weights=EXCLUDED.agg_weights;

INSERT INTO scenario_definitions
    (id, name, description, field_ids)
    VALUES ('0db72a40-43e8-477b-89b3-a7bd1224660a', 'Scenario 001 - Punctuality measures the percentage of trains arriving at their destinations on time (the train doesn’t arrive after planned arrival) and the train didn’t depart before planned departure time. The goal is to maintain a high level of reliability and minimize delays for passengers and freight services. ', 'This KPI contributes to evaluating Effectiveness of the AI-based assistant, as part of Task 4.1 evaluation objectives, and O2 main project objective:<br/>- Improve customer satisfaction by ensuring timely arrivals<br/>- Guarantee maximal planned connection<br/>- Minimize operational disruptions caused by delays<br/>- Meet regulatory and stakeholder benchmarks for punctuality<br/>This KPI is linked with project’s Long Term Expected Impacts (LTEI) (LTEI1)KPIS-3:<br/>- 10% increase in punctuality in long-range traffic<br/>- 5% increase in punctuality in regional traffic (with realistic disturbances)<br/>', array['f0f478d6-436e-476f-be79-33d8c34f20c1', 'a5c6d789-0c00-413d-b689-862806dd9b56']::uuid[])
    ON CONFLICT(id) DO UPDATE SET name=EXCLUDED.name, description=EXCLUDED.description, field_ids=EXCLUDED.field_ids;

INSERT INTO field_definitions
        (id, key, description, agg_func, agg_weights)
        VALUES ('f0f478d6-436e-476f-be79-33d8c34f20c1', 'sum_normalized_reward', 'Primary scenario score (raw values): sum_normalized_reward', NULL, NULL)
        ON CONFLICT(id) DO UPDATE SET key=EXCLUDED.key, description=EXCLUDED.description, agg_func=EXCLUDED.agg_func, agg_weights=EXCLUDED.agg_weights;

INSERT INTO field_definitions
        (id, key, description, agg_func, agg_weights)
        VALUES ('a5c6d789-0c00-413d-b689-862806dd9b56', 'success_rate', 'Secondary scenario score (raw values): success_rate', NULL, NULL)
        ON CONFLICT(id) DO UPDATE SET key=EXCLUDED.key, description=EXCLUDED.description, agg_func=EXCLUDED.agg_func, agg_weights=EXCLUDED.agg_weights;

INSERT INTO scenario_definitions
    (id, name, description, field_ids)
    VALUES ('7def3118-2e9c-4de7-8d61-f0e76fbeee5d', 'Scenario 002 - Punctuality measures the percentage of trains arriving at their destinations on time (the train doesn’t arrive after planned arrival) and the train didn’t depart before planned departure time. The goal is to maintain a high level of reliability and minimize delays for passengers and freight services. ', 'This KPI contributes to evaluating Effectiveness of the AI-based assistant, as part of Task 4.1 evaluation objectives, and O2 main project objective:<br/>- Improve customer satisfaction by ensuring timely arrivals<br/>- Guarantee maximal planned connection<br/>- Minimize operational disruptions caused by delays<br/>- Meet regulatory and stakeholder benchmarks for punctuality<br/>This KPI is linked with project’s Long Term Expected Impacts (LTEI) (LTEI1)KPIS-3:<br/>- 10% increase in punctuality in long-range traffic<br/>- 5% increase in punctuality in regional traffic (with realistic disturbances)<br/>', array['b52ec6bc-ef4a-44ec-a079-76ae7073753f', '082b3385-72b2-4d39-914b-1c8d8e7501ee']::uuid[])
    ON CONFLICT(id) DO UPDATE SET name=EXCLUDED.name, description=EXCLUDED.description, field_ids=EXCLUDED.field_ids;

INSERT INTO field_definitions
        (id, key, description, agg_func, agg_weights)
        VALUES ('b52ec6bc-ef4a-44ec-a079-76ae7073753f', 'sum_normalized_reward', 'Primary scenario score (raw values): sum_normalized_reward', NULL, NULL)
        ON CONFLICT(id) DO UPDATE SET key=EXCLUDED.key, description=EXCLUDED.description, agg_func=EXCLUDED.agg_func, agg_weights=EXCLUDED.agg_weights;

INSERT INTO field_definitions
        (id, key, description, agg_func, agg_weights)
        VALUES ('082b3385-72b2-4d39-914b-1c8d8e7501ee', 'success_rate', 'Secondary scenario score (raw values): success_rate', NULL, NULL)
        ON CONFLICT(id) DO UPDATE SET key=EXCLUDED.key, description=EXCLUDED.description, agg_func=EXCLUDED.agg_func, agg_weights=EXCLUDED.agg_weights;

INSERT INTO scenario_definitions
    (id, name, description, field_ids)
    VALUES ('3ae60635-6995-4fb1-8309-61fded3d6fd8', 'Scenario 003 - Punctuality measures the percentage of trains arriving at their destinations on time (the train doesn’t arrive after planned arrival) and the train didn’t depart before planned departure time. The goal is to maintain a high level of reliability and minimize delays for passengers and freight services. ', 'This KPI contributes to evaluating Effectiveness of the AI-based assistant, as part of Task 4.1 evaluation objectives, and O2 main project objective:<br/>- Improve customer satisfaction by ensuring timely arrivals<br/>- Guarantee maximal planned connection<br/>- Minimize operational disruptions caused by delays<br/>- Meet regulatory and stakeholder benchmarks for punctuality<br/>This KPI is linked with project’s Long Term Expected Impacts (LTEI) (LTEI1)KPIS-3:<br/>- 10% increase in punctuality in long-range traffic<br/>- 5% increase in punctuality in regional traffic (with realistic disturbances)<br/>', array['c2291e69-1591-4247-96e0-898f8755a53b', 'ee474e04-b720-42cc-97be-f62d261ada60']::uuid[])
    ON CONFLICT(id) DO UPDATE SET name=EXCLUDED.name, description=EXCLUDED.description, field_ids=EXCLUDED.field_ids;

INSERT INTO field_definitions
        (id, key, description, agg_func, agg_weights)
        VALUES ('c2291e69-1591-4247-96e0-898f8755a53b', 'sum_normalized_reward', 'Primary scenario score (raw values): sum_normalized_reward', NULL, NULL)
        ON CONFLICT(id) DO UPDATE SET key=EXCLUDED.key, description=EXCLUDED.description, agg_func=EXCLUDED.agg_func, agg_weights=EXCLUDED.agg_weights;

INSERT INTO field_definitions
        (id, key, description, agg_func, agg_weights)
        VALUES ('ee474e04-b720-42cc-97be-f62d261ada60', 'success_rate', 'Secondary scenario score (raw values): success_rate', NULL, NULL)
        ON CONFLICT(id) DO UPDATE SET key=EXCLUDED.key, description=EXCLUDED.description, agg_func=EXCLUDED.agg_func, agg_weights=EXCLUDED.agg_weights;

INSERT INTO scenario_definitions
    (id, name, description, field_ids)
    VALUES ('eeef8445-723d-4740-b89f-4dbaf75f9ae6', 'Scenario 004 - Punctuality measures the percentage of trains arriving at their destinations on time (the train doesn’t arrive after planned arrival) and the train didn’t depart before planned departure time. The goal is to maintain a high level of reliability and minimize delays for passengers and freight services. ', 'This KPI contributes to evaluating Effectiveness of the AI-based assistant, as part of Task 4.1 evaluation objectives, and O2 main project objective:<br/>- Improve customer satisfaction by ensuring timely arrivals<br/>- Guarantee maximal planned connection<br/>- Minimize operational disruptions caused by delays<br/>- Meet regulatory and stakeholder benchmarks for punctuality<br/>This KPI is linked with project’s Long Term Expected Impacts (LTEI) (LTEI1)KPIS-3:<br/>- 10% increase in punctuality in long-range traffic<br/>- 5% increase in punctuality in regional traffic (with realistic disturbances)<br/>', array['ca218ea1-9dfb-4663-80c5-1dd8e3b4f49a', '70ecd6de-db9e-4c10-b6d3-c65323811973']::uuid[])
    ON CONFLICT(id) DO UPDATE SET name=EXCLUDED.name, description=EXCLUDED.description, field_ids=EXCLUDED.field_ids;

INSERT INTO field_definitions
        (id, key, description, agg_func, agg_weights)
        VALUES ('ca218ea1-9dfb-4663-80c5-1dd8e3b4f49a', 'sum_normalized_reward', 'Primary scenario score (raw values): sum_normalized_reward', NULL, NULL)
        ON CONFLICT(id) DO UPDATE SET key=EXCLUDED.key, description=EXCLUDED.description, agg_func=EXCLUDED.agg_func, agg_weights=EXCLUDED.agg_weights;

INSERT INTO field_definitions
        (id, key, description, agg_func, agg_weights)
        VALUES ('70ecd6de-db9e-4c10-b6d3-c65323811973', 'success_rate', 'Secondary scenario score (raw values): success_rate', NULL, NULL)
        ON CONFLICT(id) DO UPDATE SET key=EXCLUDED.key, description=EXCLUDED.description, agg_func=EXCLUDED.agg_func, agg_weights=EXCLUDED.agg_weights;

INSERT INTO scenario_definitions
    (id, name, description, field_ids)
    VALUES ('94af1ed1-3686-4a9e-99f5-3a7ad908f125', 'Scenario 005 - Punctuality measures the percentage of trains arriving at their destinations on time (the train doesn’t arrive after planned arrival) and the train didn’t depart before planned departure time. The goal is to maintain a high level of reliability and minimize delays for passengers and freight services. ', 'This KPI contributes to evaluating Effectiveness of the AI-based assistant, as part of Task 4.1 evaluation objectives, and O2 main project objective:<br/>- Improve customer satisfaction by ensuring timely arrivals<br/>- Guarantee maximal planned connection<br/>- Minimize operational disruptions caused by delays<br/>- Meet regulatory and stakeholder benchmarks for punctuality<br/>This KPI is linked with project’s Long Term Expected Impacts (LTEI) (LTEI1)KPIS-3:<br/>- 10% increase in punctuality in long-range traffic<br/>- 5% increase in punctuality in regional traffic (with realistic disturbances)<br/>', array['77a857be-3070-4bea-a298-3749c919ecab', 'ffcf031a-4845-4a63-b3bc-269f31913a2d']::uuid[])
    ON CONFLICT(id) DO UPDATE SET name=EXCLUDED.name, description=EXCLUDED.description, field_ids=EXCLUDED.field_ids;

INSERT INTO field_definitions
        (id, key, description, agg_func, agg_weights)
        VALUES ('77a857be-3070-4bea-a298-3749c919ecab', 'sum_normalized_reward', 'Primary scenario score (raw values): sum_normalized_reward', NULL, NULL)
        ON CONFLICT(id) DO UPDATE SET key=EXCLUDED.key, description=EXCLUDED.description, agg_func=EXCLUDED.agg_func, agg_weights=EXCLUDED.agg_weights;

INSERT INTO field_definitions
        (id, key, description, agg_func, agg_weights)
        VALUES ('ffcf031a-4845-4a63-b3bc-269f31913a2d', 'success_rate', 'Secondary scenario score (raw values): success_rate', NULL, NULL)
        ON CONFLICT(id) DO UPDATE SET key=EXCLUDED.key, description=EXCLUDED.description, agg_func=EXCLUDED.agg_func, agg_weights=EXCLUDED.agg_weights;

INSERT INTO scenario_definitions
    (id, name, description, field_ids)
    VALUES ('8250d0e2-700e-4051-85c3-a8d0d95a5f0f', 'Scenario 006 - Punctuality measures the percentage of trains arriving at their destinations on time (the train doesn’t arrive after planned arrival) and the train didn’t depart before planned departure time. The goal is to maintain a high level of reliability and minimize delays for passengers and freight services. ', 'This KPI contributes to evaluating Effectiveness of the AI-based assistant, as part of Task 4.1 evaluation objectives, and O2 main project objective:<br/>- Improve customer satisfaction by ensuring timely arrivals<br/>- Guarantee maximal planned connection<br/>- Minimize operational disruptions caused by delays<br/>- Meet regulatory and stakeholder benchmarks for punctuality<br/>This KPI is linked with project’s Long Term Expected Impacts (LTEI) (LTEI1)KPIS-3:<br/>- 10% increase in punctuality in long-range traffic<br/>- 5% increase in punctuality in regional traffic (with realistic disturbances)<br/>', array['95ce9498-b09f-4c3a-9b4d-987235efec2e', 'ecc75557-a1ea-4b1b-bab5-4e5269bbb8eb']::uuid[])
    ON CONFLICT(id) DO UPDATE SET name=EXCLUDED.name, description=EXCLUDED.description, field_ids=EXCLUDED.field_ids;

INSERT INTO field_definitions
        (id, key, description, agg_func, agg_weights)
        VALUES ('95ce9498-b09f-4c3a-9b4d-987235efec2e', 'sum_normalized_reward', 'Primary scenario score (raw values): sum_normalized_reward', NULL, NULL)
        ON CONFLICT(id) DO UPDATE SET key=EXCLUDED.key, description=EXCLUDED.description, agg_func=EXCLUDED.agg_func, agg_weights=EXCLUDED.agg_weights;

INSERT INTO field_definitions
        (id, key, description, agg_func, agg_weights)
        VALUES ('ecc75557-a1ea-4b1b-bab5-4e5269bbb8eb', 'success_rate', 'Secondary scenario score (raw values): success_rate', NULL, NULL)
        ON CONFLICT(id) DO UPDATE SET key=EXCLUDED.key, description=EXCLUDED.description, agg_func=EXCLUDED.agg_func, agg_weights=EXCLUDED.agg_weights;

INSERT INTO scenario_definitions
    (id, name, description, field_ids)
    VALUES ('c58759a7-a64a-4cbf-970b-948bae0c2254', 'Scenario 007 - Punctuality measures the percentage of trains arriving at their destinations on time (the train doesn’t arrive after planned arrival) and the train didn’t depart before planned departure time. The goal is to maintain a high level of reliability and minimize delays for passengers and freight services. ', 'This KPI contributes to evaluating Effectiveness of the AI-based assistant, as part of Task 4.1 evaluation objectives, and O2 main project objective:<br/>- Improve customer satisfaction by ensuring timely arrivals<br/>- Guarantee maximal planned connection<br/>- Minimize operational disruptions caused by delays<br/>- Meet regulatory and stakeholder benchmarks for punctuality<br/>This KPI is linked with project’s Long Term Expected Impacts (LTEI) (LTEI1)KPIS-3:<br/>- 10% increase in punctuality in long-range traffic<br/>- 5% increase in punctuality in regional traffic (with realistic disturbances)<br/>', array['2a77ef34-110c-4d20-94bc-2228058f2024', '7a0a3e17-543e-46b5-81ec-042c8d9a2238']::uuid[])
    ON CONFLICT(id) DO UPDATE SET name=EXCLUDED.name, description=EXCLUDED.description, field_ids=EXCLUDED.field_ids;

INSERT INTO field_definitions
        (id, key, description, agg_func, agg_weights)
        VALUES ('2a77ef34-110c-4d20-94bc-2228058f2024', 'sum_normalized_reward', 'Primary scenario score (raw values): sum_normalized_reward', NULL, NULL)
        ON CONFLICT(id) DO UPDATE SET key=EXCLUDED.key, description=EXCLUDED.description, agg_func=EXCLUDED.agg_func, agg_weights=EXCLUDED.agg_weights;

INSERT INTO field_definitions
        (id, key, description, agg_func, agg_weights)
        VALUES ('7a0a3e17-543e-46b5-81ec-042c8d9a2238', 'success_rate', 'Secondary scenario score (raw values): success_rate', NULL, NULL)
        ON CONFLICT(id) DO UPDATE SET key=EXCLUDED.key, description=EXCLUDED.description, agg_func=EXCLUDED.agg_func, agg_weights=EXCLUDED.agg_weights;

INSERT INTO scenario_definitions
    (id, name, description, field_ids)
    VALUES ('f94f517f-c0a4-4415-b726-186cdc75f9c6', 'Scenario 008 - Punctuality measures the percentage of trains arriving at their destinations on time (the train doesn’t arrive after planned arrival) and the train didn’t depart before planned departure time. The goal is to maintain a high level of reliability and minimize delays for passengers and freight services. ', 'This KPI contributes to evaluating Effectiveness of the AI-based assistant, as part of Task 4.1 evaluation objectives, and O2 main project objective:<br/>- Improve customer satisfaction by ensuring timely arrivals<br/>- Guarantee maximal planned connection<br/>- Minimize operational disruptions caused by delays<br/>- Meet regulatory and stakeholder benchmarks for punctuality<br/>This KPI is linked with project’s Long Term Expected Impacts (LTEI) (LTEI1)KPIS-3:<br/>- 10% increase in punctuality in long-range traffic<br/>- 5% increase in punctuality in regional traffic (with realistic disturbances)<br/>', array['f97a7d4f-499b-4b90-a7ef-097382ab189d', '8692e760-cc0d-4e25-b86d-bed3417d52dd']::uuid[])
    ON CONFLICT(id) DO UPDATE SET name=EXCLUDED.name, description=EXCLUDED.description, field_ids=EXCLUDED.field_ids;

INSERT INTO field_definitions
        (id, key, description, agg_func, agg_weights)
        VALUES ('f97a7d4f-499b-4b90-a7ef-097382ab189d', 'sum_normalized_reward', 'Primary scenario score (raw values): sum_normalized_reward', NULL, NULL)
        ON CONFLICT(id) DO UPDATE SET key=EXCLUDED.key, description=EXCLUDED.description, agg_func=EXCLUDED.agg_func, agg_weights=EXCLUDED.agg_weights;

INSERT INTO field_definitions
        (id, key, description, agg_func, agg_weights)
        VALUES ('8692e760-cc0d-4e25-b86d-bed3417d52dd', 'success_rate', 'Secondary scenario score (raw values): success_rate', NULL, NULL)
        ON CONFLICT(id) DO UPDATE SET key=EXCLUDED.key, description=EXCLUDED.description, agg_func=EXCLUDED.agg_func, agg_weights=EXCLUDED.agg_weights;

INSERT INTO scenario_definitions
    (id, name, description, field_ids)
    VALUES ('c0e2c3e0-c171-48dd-a312-5de070e3f937', 'Scenario 009 - Punctuality measures the percentage of trains arriving at their destinations on time (the train doesn’t arrive after planned arrival) and the train didn’t depart before planned departure time. The goal is to maintain a high level of reliability and minimize delays for passengers and freight services. ', 'This KPI contributes to evaluating Effectiveness of the AI-based assistant, as part of Task 4.1 evaluation objectives, and O2 main project objective:<br/>- Improve customer satisfaction by ensuring timely arrivals<br/>- Guarantee maximal planned connection<br/>- Minimize operational disruptions caused by delays<br/>- Meet regulatory and stakeholder benchmarks for punctuality<br/>This KPI is linked with project’s Long Term Expected Impacts (LTEI) (LTEI1)KPIS-3:<br/>- 10% increase in punctuality in long-range traffic<br/>- 5% increase in punctuality in regional traffic (with realistic disturbances)<br/>', array['c6459e07-91ec-42e2-86ed-51edd5eeb253', '1f56631f-a864-446a-b236-19bfd7910ca5']::uuid[])
    ON CONFLICT(id) DO UPDATE SET name=EXCLUDED.name, description=EXCLUDED.description, field_ids=EXCLUDED.field_ids;

INSERT INTO field_definitions
        (id, key, description, agg_func, agg_weights)
        VALUES ('c6459e07-91ec-42e2-86ed-51edd5eeb253', 'sum_normalized_reward', 'Primary scenario score (raw values): sum_normalized_reward', NULL, NULL)
        ON CONFLICT(id) DO UPDATE SET key=EXCLUDED.key, description=EXCLUDED.description, agg_func=EXCLUDED.agg_func, agg_weights=EXCLUDED.agg_weights;

INSERT INTO field_definitions
        (id, key, description, agg_func, agg_weights)
        VALUES ('1f56631f-a864-446a-b236-19bfd7910ca5', 'success_rate', 'Secondary scenario score (raw values): success_rate', NULL, NULL)
        ON CONFLICT(id) DO UPDATE SET key=EXCLUDED.key, description=EXCLUDED.description, agg_func=EXCLUDED.agg_func, agg_weights=EXCLUDED.agg_weights;

INSERT INTO scenario_definitions
    (id, name, description, field_ids)
    VALUES ('26fb51b9-2466-48ab-8c0a-89d9536d4c34', 'Scenario 010 - Punctuality measures the percentage of trains arriving at their destinations on time (the train doesn’t arrive after planned arrival) and the train didn’t depart before planned departure time. The goal is to maintain a high level of reliability and minimize delays for passengers and freight services. ', 'This KPI contributes to evaluating Effectiveness of the AI-based assistant, as part of Task 4.1 evaluation objectives, and O2 main project objective:<br/>- Improve customer satisfaction by ensuring timely arrivals<br/>- Guarantee maximal planned connection<br/>- Minimize operational disruptions caused by delays<br/>- Meet regulatory and stakeholder benchmarks for punctuality<br/>This KPI is linked with project’s Long Term Expected Impacts (LTEI) (LTEI1)KPIS-3:<br/>- 10% increase in punctuality in long-range traffic<br/>- 5% increase in punctuality in regional traffic (with realistic disturbances)<br/>', array['fbd6177b-7831-4009-9191-47eae9a71255', 'db82dc7b-55e7-4952-9902-b1e3fda60775']::uuid[])
    ON CONFLICT(id) DO UPDATE SET name=EXCLUDED.name, description=EXCLUDED.description, field_ids=EXCLUDED.field_ids;

INSERT INTO field_definitions
        (id, key, description, agg_func, agg_weights)
        VALUES ('fbd6177b-7831-4009-9191-47eae9a71255', 'sum_normalized_reward', 'Primary scenario score (raw values): sum_normalized_reward', NULL, NULL)
        ON CONFLICT(id) DO UPDATE SET key=EXCLUDED.key, description=EXCLUDED.description, agg_func=EXCLUDED.agg_func, agg_weights=EXCLUDED.agg_weights;

INSERT INTO field_definitions
        (id, key, description, agg_func, agg_weights)
        VALUES ('db82dc7b-55e7-4952-9902-b1e3fda60775', 'success_rate', 'Secondary scenario score (raw values): success_rate', NULL, NULL)
        ON CONFLICT(id) DO UPDATE SET key=EXCLUDED.key, description=EXCLUDED.description, agg_func=EXCLUDED.agg_func, agg_weights=EXCLUDED.agg_weights;

INSERT INTO scenario_definitions
    (id, name, description, field_ids)
    VALUES ('66c23554-47bb-4268-b08e-518f6f163e9d', 'Scenario 011 - Punctuality measures the percentage of trains arriving at their destinations on time (the train doesn’t arrive after planned arrival) and the train didn’t depart before planned departure time. The goal is to maintain a high level of reliability and minimize delays for passengers and freight services. ', 'This KPI contributes to evaluating Effectiveness of the AI-based assistant, as part of Task 4.1 evaluation objectives, and O2 main project objective:<br/>- Improve customer satisfaction by ensuring timely arrivals<br/>- Guarantee maximal planned connection<br/>- Minimize operational disruptions caused by delays<br/>- Meet regulatory and stakeholder benchmarks for punctuality<br/>This KPI is linked with project’s Long Term Expected Impacts (LTEI) (LTEI1)KPIS-3:<br/>- 10% increase in punctuality in long-range traffic<br/>- 5% increase in punctuality in regional traffic (with realistic disturbances)<br/>', array['e4b29a23-0d03-42bc-aa14-756122757af8', '5dc33daf-5f76-4e6d-b86c-e6986c21bae0']::uuid[])
    ON CONFLICT(id) DO UPDATE SET name=EXCLUDED.name, description=EXCLUDED.description, field_ids=EXCLUDED.field_ids;

INSERT INTO field_definitions
        (id, key, description, agg_func, agg_weights)
        VALUES ('e4b29a23-0d03-42bc-aa14-756122757af8', 'sum_normalized_reward', 'Primary scenario score (raw values): sum_normalized_reward', NULL, NULL)
        ON CONFLICT(id) DO UPDATE SET key=EXCLUDED.key, description=EXCLUDED.description, agg_func=EXCLUDED.agg_func, agg_weights=EXCLUDED.agg_weights;

INSERT INTO field_definitions
        (id, key, description, agg_func, agg_weights)
        VALUES ('5dc33daf-5f76-4e6d-b86c-e6986c21bae0', 'success_rate', 'Secondary scenario score (raw values): success_rate', NULL, NULL)
        ON CONFLICT(id) DO UPDATE SET key=EXCLUDED.key, description=EXCLUDED.description, agg_func=EXCLUDED.agg_func, agg_weights=EXCLUDED.agg_weights;

INSERT INTO scenario_definitions
    (id, name, description, field_ids)
    VALUES ('08641d25-9b18-41bb-9cbc-4039b4ad24f0', 'Scenario 012 - Punctuality measures the percentage of trains arriving at their destinations on time (the train doesn’t arrive after planned arrival) and the train didn’t depart before planned departure time. The goal is to maintain a high level of reliability and minimize delays for passengers and freight services. ', 'This KPI contributes to evaluating Effectiveness of the AI-based assistant, as part of Task 4.1 evaluation objectives, and O2 main project objective:<br/>- Improve customer satisfaction by ensuring timely arrivals<br/>- Guarantee maximal planned connection<br/>- Minimize operational disruptions caused by delays<br/>- Meet regulatory and stakeholder benchmarks for punctuality<br/>This KPI is linked with project’s Long Term Expected Impacts (LTEI) (LTEI1)KPIS-3:<br/>- 10% increase in punctuality in long-range traffic<br/>- 5% increase in punctuality in regional traffic (with realistic disturbances)<br/>', array['6c2515e2-d550-4f79-99d5-488c0119f108', 'cc6617af-d031-48d2-89e9-ac4569f6b82a']::uuid[])
    ON CONFLICT(id) DO UPDATE SET name=EXCLUDED.name, description=EXCLUDED.description, field_ids=EXCLUDED.field_ids;

INSERT INTO field_definitions
        (id, key, description, agg_func, agg_weights)
        VALUES ('6c2515e2-d550-4f79-99d5-488c0119f108', 'sum_normalized_reward', 'Primary scenario score (raw values): sum_normalized_reward', NULL, NULL)
        ON CONFLICT(id) DO UPDATE SET key=EXCLUDED.key, description=EXCLUDED.description, agg_func=EXCLUDED.agg_func, agg_weights=EXCLUDED.agg_weights;

INSERT INTO field_definitions
        (id, key, description, agg_func, agg_weights)
        VALUES ('cc6617af-d031-48d2-89e9-ac4569f6b82a', 'success_rate', 'Secondary scenario score (raw values): success_rate', NULL, NULL)
        ON CONFLICT(id) DO UPDATE SET key=EXCLUDED.key, description=EXCLUDED.description, agg_func=EXCLUDED.agg_func, agg_weights=EXCLUDED.agg_weights;

INSERT INTO scenario_definitions
    (id, name, description, field_ids)
    VALUES ('4d3dd85a-2b16-45de-b524-f83b4a58a2f4', 'Scenario 013 - Punctuality measures the percentage of trains arriving at their destinations on time (the train doesn’t arrive after planned arrival) and the train didn’t depart before planned departure time. The goal is to maintain a high level of reliability and minimize delays for passengers and freight services. ', 'This KPI contributes to evaluating Effectiveness of the AI-based assistant, as part of Task 4.1 evaluation objectives, and O2 main project objective:<br/>- Improve customer satisfaction by ensuring timely arrivals<br/>- Guarantee maximal planned connection<br/>- Minimize operational disruptions caused by delays<br/>- Meet regulatory and stakeholder benchmarks for punctuality<br/>This KPI is linked with project’s Long Term Expected Impacts (LTEI) (LTEI1)KPIS-3:<br/>- 10% increase in punctuality in long-range traffic<br/>- 5% increase in punctuality in regional traffic (with realistic disturbances)<br/>', array['53ccb901-fc56-4020-80bd-f9802a41b224', '4779f14d-2533-4324-a7e2-6fb4dfe726e3']::uuid[])
    ON CONFLICT(id) DO UPDATE SET name=EXCLUDED.name, description=EXCLUDED.description, field_ids=EXCLUDED.field_ids;

INSERT INTO field_definitions
        (id, key, description, agg_func, agg_weights)
        VALUES ('53ccb901-fc56-4020-80bd-f9802a41b224', 'sum_normalized_reward', 'Primary scenario score (raw values): sum_normalized_reward', NULL, NULL)
        ON CONFLICT(id) DO UPDATE SET key=EXCLUDED.key, description=EXCLUDED.description, agg_func=EXCLUDED.agg_func, agg_weights=EXCLUDED.agg_weights;

INSERT INTO field_definitions
        (id, key, description, agg_func, agg_weights)
        VALUES ('4779f14d-2533-4324-a7e2-6fb4dfe726e3', 'success_rate', 'Secondary scenario score (raw values): success_rate', NULL, NULL)
        ON CONFLICT(id) DO UPDATE SET key=EXCLUDED.key, description=EXCLUDED.description, agg_func=EXCLUDED.agg_func, agg_weights=EXCLUDED.agg_weights;

INSERT INTO scenario_definitions
    (id, name, description, field_ids)
    VALUES ('bf9209c7-125c-42f9-b78e-4e5b7aacefcc', 'Scenario 014 - Punctuality measures the percentage of trains arriving at their destinations on time (the train doesn’t arrive after planned arrival) and the train didn’t depart before planned departure time. The goal is to maintain a high level of reliability and minimize delays for passengers and freight services. ', 'This KPI contributes to evaluating Effectiveness of the AI-based assistant, as part of Task 4.1 evaluation objectives, and O2 main project objective:<br/>- Improve customer satisfaction by ensuring timely arrivals<br/>- Guarantee maximal planned connection<br/>- Minimize operational disruptions caused by delays<br/>- Meet regulatory and stakeholder benchmarks for punctuality<br/>This KPI is linked with project’s Long Term Expected Impacts (LTEI) (LTEI1)KPIS-3:<br/>- 10% increase in punctuality in long-range traffic<br/>- 5% increase in punctuality in regional traffic (with realistic disturbances)<br/>', array['380d1ecc-6600-4d0a-ab26-a9d34f49dc38', 'df9103a1-6c9f-4db4-8ceb-510b51263a65']::uuid[])
    ON CONFLICT(id) DO UPDATE SET name=EXCLUDED.name, description=EXCLUDED.description, field_ids=EXCLUDED.field_ids;

INSERT INTO field_definitions
        (id, key, description, agg_func, agg_weights)
        VALUES ('380d1ecc-6600-4d0a-ab26-a9d34f49dc38', 'sum_normalized_reward', 'Primary scenario score (raw values): sum_normalized_reward', NULL, NULL)
        ON CONFLICT(id) DO UPDATE SET key=EXCLUDED.key, description=EXCLUDED.description, agg_func=EXCLUDED.agg_func, agg_weights=EXCLUDED.agg_weights;

INSERT INTO field_definitions
        (id, key, description, agg_func, agg_weights)
        VALUES ('df9103a1-6c9f-4db4-8ceb-510b51263a65', 'success_rate', 'Secondary scenario score (raw values): success_rate', NULL, NULL)
        ON CONFLICT(id) DO UPDATE SET key=EXCLUDED.key, description=EXCLUDED.description, agg_func=EXCLUDED.agg_func, agg_weights=EXCLUDED.agg_weights;

INSERT INTO scenario_definitions
    (id, name, description, field_ids)
    VALUES ('f511044d-2378-4c7f-af92-45c78146bdef', 'Scenario 015 - Punctuality measures the percentage of trains arriving at their destinations on time (the train doesn’t arrive after planned arrival) and the train didn’t depart before planned departure time. The goal is to maintain a high level of reliability and minimize delays for passengers and freight services. ', 'This KPI contributes to evaluating Effectiveness of the AI-based assistant, as part of Task 4.1 evaluation objectives, and O2 main project objective:<br/>- Improve customer satisfaction by ensuring timely arrivals<br/>- Guarantee maximal planned connection<br/>- Minimize operational disruptions caused by delays<br/>- Meet regulatory and stakeholder benchmarks for punctuality<br/>This KPI is linked with project’s Long Term Expected Impacts (LTEI) (LTEI1)KPIS-3:<br/>- 10% increase in punctuality in long-range traffic<br/>- 5% increase in punctuality in regional traffic (with realistic disturbances)<br/>', array['2edc7757-717a-4c9a-8d2e-8119a32b72f4', 'da93159a-3664-4d2e-94e0-79f7af5403f6']::uuid[])
    ON CONFLICT(id) DO UPDATE SET name=EXCLUDED.name, description=EXCLUDED.description, field_ids=EXCLUDED.field_ids;

INSERT INTO field_definitions
        (id, key, description, agg_func, agg_weights)
        VALUES ('2edc7757-717a-4c9a-8d2e-8119a32b72f4', 'sum_normalized_reward', 'Primary scenario score (raw values): sum_normalized_reward', NULL, NULL)
        ON CONFLICT(id) DO UPDATE SET key=EXCLUDED.key, description=EXCLUDED.description, agg_func=EXCLUDED.agg_func, agg_weights=EXCLUDED.agg_weights;

INSERT INTO field_definitions
        (id, key, description, agg_func, agg_weights)
        VALUES ('da93159a-3664-4d2e-94e0-79f7af5403f6', 'success_rate', 'Secondary scenario score (raw values): success_rate', NULL, NULL)
        ON CONFLICT(id) DO UPDATE SET key=EXCLUDED.key, description=EXCLUDED.description, agg_func=EXCLUDED.agg_func, agg_weights=EXCLUDED.agg_weights;

INSERT INTO scenario_definitions
    (id, name, description, field_ids)
    VALUES ('f89cee49-e1ae-427d-ae42-5cc411661a1c', 'Scenario 016 - Punctuality measures the percentage of trains arriving at their destinations on time (the train doesn’t arrive after planned arrival) and the train didn’t depart before planned departure time. The goal is to maintain a high level of reliability and minimize delays for passengers and freight services. ', 'This KPI contributes to evaluating Effectiveness of the AI-based assistant, as part of Task 4.1 evaluation objectives, and O2 main project objective:<br/>- Improve customer satisfaction by ensuring timely arrivals<br/>- Guarantee maximal planned connection<br/>- Minimize operational disruptions caused by delays<br/>- Meet regulatory and stakeholder benchmarks for punctuality<br/>This KPI is linked with project’s Long Term Expected Impacts (LTEI) (LTEI1)KPIS-3:<br/>- 10% increase in punctuality in long-range traffic<br/>- 5% increase in punctuality in regional traffic (with realistic disturbances)<br/>', array['1a39cae1-4a44-4a39-b9e6-8f58b29b8b03', '1aad118d-0364-4eeb-9ab6-6103db65ceb2']::uuid[])
    ON CONFLICT(id) DO UPDATE SET name=EXCLUDED.name, description=EXCLUDED.description, field_ids=EXCLUDED.field_ids;

INSERT INTO field_definitions
        (id, key, description, agg_func, agg_weights)
        VALUES ('1a39cae1-4a44-4a39-b9e6-8f58b29b8b03', 'sum_normalized_reward', 'Primary scenario score (raw values): sum_normalized_reward', NULL, NULL)
        ON CONFLICT(id) DO UPDATE SET key=EXCLUDED.key, description=EXCLUDED.description, agg_func=EXCLUDED.agg_func, agg_weights=EXCLUDED.agg_weights;

INSERT INTO field_definitions
        (id, key, description, agg_func, agg_weights)
        VALUES ('1aad118d-0364-4eeb-9ab6-6103db65ceb2', 'success_rate', 'Secondary scenario score (raw values): success_rate', NULL, NULL)
        ON CONFLICT(id) DO UPDATE SET key=EXCLUDED.key, description=EXCLUDED.description, agg_func=EXCLUDED.agg_func, agg_weights=EXCLUDED.agg_weights;

INSERT INTO scenario_definitions
    (id, name, description, field_ids)
    VALUES ('262e43bd-bf35-4171-b38b-c77969db0b16', 'Scenario 017 - Punctuality measures the percentage of trains arriving at their destinations on time (the train doesn’t arrive after planned arrival) and the train didn’t depart before planned departure time. The goal is to maintain a high level of reliability and minimize delays for passengers and freight services. ', 'This KPI contributes to evaluating Effectiveness of the AI-based assistant, as part of Task 4.1 evaluation objectives, and O2 main project objective:<br/>- Improve customer satisfaction by ensuring timely arrivals<br/>- Guarantee maximal planned connection<br/>- Minimize operational disruptions caused by delays<br/>- Meet regulatory and stakeholder benchmarks for punctuality<br/>This KPI is linked with project’s Long Term Expected Impacts (LTEI) (LTEI1)KPIS-3:<br/>- 10% increase in punctuality in long-range traffic<br/>- 5% increase in punctuality in regional traffic (with realistic disturbances)<br/>', array['1b9a8049-211e-432f-8eb5-03b1e7c7db89', '3d1a1369-26cd-4a12-bca6-80c0e29e657b']::uuid[])
    ON CONFLICT(id) DO UPDATE SET name=EXCLUDED.name, description=EXCLUDED.description, field_ids=EXCLUDED.field_ids;

INSERT INTO field_definitions
        (id, key, description, agg_func, agg_weights)
        VALUES ('1b9a8049-211e-432f-8eb5-03b1e7c7db89', 'sum_normalized_reward', 'Primary scenario score (raw values): sum_normalized_reward', NULL, NULL)
        ON CONFLICT(id) DO UPDATE SET key=EXCLUDED.key, description=EXCLUDED.description, agg_func=EXCLUDED.agg_func, agg_weights=EXCLUDED.agg_weights;

INSERT INTO field_definitions
        (id, key, description, agg_func, agg_weights)
        VALUES ('3d1a1369-26cd-4a12-bca6-80c0e29e657b', 'success_rate', 'Secondary scenario score (raw values): success_rate', NULL, NULL)
        ON CONFLICT(id) DO UPDATE SET key=EXCLUDED.key, description=EXCLUDED.description, agg_func=EXCLUDED.agg_func, agg_weights=EXCLUDED.agg_weights;

INSERT INTO scenario_definitions
    (id, name, description, field_ids)
    VALUES ('61bd29ec-0b09-4067-ada0-b43e48a8ac9a', 'Scenario 018 - Punctuality measures the percentage of trains arriving at their destinations on time (the train doesn’t arrive after planned arrival) and the train didn’t depart before planned departure time. The goal is to maintain a high level of reliability and minimize delays for passengers and freight services. ', 'This KPI contributes to evaluating Effectiveness of the AI-based assistant, as part of Task 4.1 evaluation objectives, and O2 main project objective:<br/>- Improve customer satisfaction by ensuring timely arrivals<br/>- Guarantee maximal planned connection<br/>- Minimize operational disruptions caused by delays<br/>- Meet regulatory and stakeholder benchmarks for punctuality<br/>This KPI is linked with project’s Long Term Expected Impacts (LTEI) (LTEI1)KPIS-3:<br/>- 10% increase in punctuality in long-range traffic<br/>- 5% increase in punctuality in regional traffic (with realistic disturbances)<br/>', array['3fada72e-e526-465b-86e0-d35839e5b42a', '86818fce-79f8-4d7d-9e1b-2e052d94602f']::uuid[])
    ON CONFLICT(id) DO UPDATE SET name=EXCLUDED.name, description=EXCLUDED.description, field_ids=EXCLUDED.field_ids;

INSERT INTO field_definitions
        (id, key, description, agg_func, agg_weights)
        VALUES ('3fada72e-e526-465b-86e0-d35839e5b42a', 'sum_normalized_reward', 'Primary scenario score (raw values): sum_normalized_reward', NULL, NULL)
        ON CONFLICT(id) DO UPDATE SET key=EXCLUDED.key, description=EXCLUDED.description, agg_func=EXCLUDED.agg_func, agg_weights=EXCLUDED.agg_weights;

INSERT INTO field_definitions
        (id, key, description, agg_func, agg_weights)
        VALUES ('86818fce-79f8-4d7d-9e1b-2e052d94602f', 'success_rate', 'Secondary scenario score (raw values): success_rate', NULL, NULL)
        ON CONFLICT(id) DO UPDATE SET key=EXCLUDED.key, description=EXCLUDED.description, agg_func=EXCLUDED.agg_func, agg_weights=EXCLUDED.agg_weights;

INSERT INTO scenario_definitions
    (id, name, description, field_ids)
    VALUES ('92d22472-4696-40ba-924f-861a2f4343b6', 'Scenario 019 - Punctuality measures the percentage of trains arriving at their destinations on time (the train doesn’t arrive after planned arrival) and the train didn’t depart before planned departure time. The goal is to maintain a high level of reliability and minimize delays for passengers and freight services. ', 'This KPI contributes to evaluating Effectiveness of the AI-based assistant, as part of Task 4.1 evaluation objectives, and O2 main project objective:<br/>- Improve customer satisfaction by ensuring timely arrivals<br/>- Guarantee maximal planned connection<br/>- Minimize operational disruptions caused by delays<br/>- Meet regulatory and stakeholder benchmarks for punctuality<br/>This KPI is linked with project’s Long Term Expected Impacts (LTEI) (LTEI1)KPIS-3:<br/>- 10% increase in punctuality in long-range traffic<br/>- 5% increase in punctuality in regional traffic (with realistic disturbances)<br/>', array['4b9f0031-b9fc-491a-8f49-73485d3aa755', '77646805-26af-4ee3-878d-8c8917e20f36']::uuid[])
    ON CONFLICT(id) DO UPDATE SET name=EXCLUDED.name, description=EXCLUDED.description, field_ids=EXCLUDED.field_ids;

INSERT INTO field_definitions
        (id, key, description, agg_func, agg_weights)
        VALUES ('4b9f0031-b9fc-491a-8f49-73485d3aa755', 'sum_normalized_reward', 'Primary scenario score (raw values): sum_normalized_reward', NULL, NULL)
        ON CONFLICT(id) DO UPDATE SET key=EXCLUDED.key, description=EXCLUDED.description, agg_func=EXCLUDED.agg_func, agg_weights=EXCLUDED.agg_weights;

INSERT INTO field_definitions
        (id, key, description, agg_func, agg_weights)
        VALUES ('77646805-26af-4ee3-878d-8c8917e20f36', 'success_rate', 'Secondary scenario score (raw values): success_rate', NULL, NULL)
        ON CONFLICT(id) DO UPDATE SET key=EXCLUDED.key, description=EXCLUDED.description, agg_func=EXCLUDED.agg_func, agg_weights=EXCLUDED.agg_weights;

INSERT INTO scenario_definitions
    (id, name, description, field_ids)
    VALUES ('6fc5f67a-40fa-45ce-819e-35a85e08e560', 'Scenario 020 - Punctuality measures the percentage of trains arriving at their destinations on time (the train doesn’t arrive after planned arrival) and the train didn’t depart before planned departure time. The goal is to maintain a high level of reliability and minimize delays for passengers and freight services. ', 'This KPI contributes to evaluating Effectiveness of the AI-based assistant, as part of Task 4.1 evaluation objectives, and O2 main project objective:<br/>- Improve customer satisfaction by ensuring timely arrivals<br/>- Guarantee maximal planned connection<br/>- Minimize operational disruptions caused by delays<br/>- Meet regulatory and stakeholder benchmarks for punctuality<br/>This KPI is linked with project’s Long Term Expected Impacts (LTEI) (LTEI1)KPIS-3:<br/>- 10% increase in punctuality in long-range traffic<br/>- 5% increase in punctuality in regional traffic (with realistic disturbances)<br/>', array['400ef71c-f16c-422f-bd34-640b393ce77a', '51f8e76e-c909-4277-a047-05e3a001620e']::uuid[])
    ON CONFLICT(id) DO UPDATE SET name=EXCLUDED.name, description=EXCLUDED.description, field_ids=EXCLUDED.field_ids;

INSERT INTO field_definitions
        (id, key, description, agg_func, agg_weights)
        VALUES ('400ef71c-f16c-422f-bd34-640b393ce77a', 'sum_normalized_reward', 'Primary scenario score (raw values): sum_normalized_reward', NULL, NULL)
        ON CONFLICT(id) DO UPDATE SET key=EXCLUDED.key, description=EXCLUDED.description, agg_func=EXCLUDED.agg_func, agg_weights=EXCLUDED.agg_weights;

INSERT INTO field_definitions
        (id, key, description, agg_func, agg_weights)
        VALUES ('51f8e76e-c909-4277-a047-05e3a001620e', 'success_rate', 'Secondary scenario score (raw values): success_rate', NULL, NULL)
        ON CONFLICT(id) DO UPDATE SET key=EXCLUDED.key, description=EXCLUDED.description, agg_func=EXCLUDED.agg_func, agg_weights=EXCLUDED.agg_weights;

INSERT INTO scenario_definitions
    (id, name, description, field_ids)
    VALUES ('66bce513-502c-43b4-a155-8a16c410a7c6', 'Scenario 021 - Punctuality measures the percentage of trains arriving at their destinations on time (the train doesn’t arrive after planned arrival) and the train didn’t depart before planned departure time. The goal is to maintain a high level of reliability and minimize delays for passengers and freight services. ', 'This KPI contributes to evaluating Effectiveness of the AI-based assistant, as part of Task 4.1 evaluation objectives, and O2 main project objective:<br/>- Improve customer satisfaction by ensuring timely arrivals<br/>- Guarantee maximal planned connection<br/>- Minimize operational disruptions caused by delays<br/>- Meet regulatory and stakeholder benchmarks for punctuality<br/>This KPI is linked with project’s Long Term Expected Impacts (LTEI) (LTEI1)KPIS-3:<br/>- 10% increase in punctuality in long-range traffic<br/>- 5% increase in punctuality in regional traffic (with realistic disturbances)<br/>', array['740f0229-23ef-4cfc-860b-435e95142ae6', '0fe8c02d-0d01-4642-828a-301196e11188']::uuid[])
    ON CONFLICT(id) DO UPDATE SET name=EXCLUDED.name, description=EXCLUDED.description, field_ids=EXCLUDED.field_ids;

INSERT INTO field_definitions
        (id, key, description, agg_func, agg_weights)
        VALUES ('740f0229-23ef-4cfc-860b-435e95142ae6', 'sum_normalized_reward', 'Primary scenario score (raw values): sum_normalized_reward', NULL, NULL)
        ON CONFLICT(id) DO UPDATE SET key=EXCLUDED.key, description=EXCLUDED.description, agg_func=EXCLUDED.agg_func, agg_weights=EXCLUDED.agg_weights;

INSERT INTO field_definitions
        (id, key, description, agg_func, agg_weights)
        VALUES ('0fe8c02d-0d01-4642-828a-301196e11188', 'success_rate', 'Secondary scenario score (raw values): success_rate', NULL, NULL)
        ON CONFLICT(id) DO UPDATE SET key=EXCLUDED.key, description=EXCLUDED.description, agg_func=EXCLUDED.agg_func, agg_weights=EXCLUDED.agg_weights;

INSERT INTO scenario_definitions
    (id, name, description, field_ids)
    VALUES ('eff645bf-7ea8-490d-ae8a-ebb0d16a774c', 'Scenario 022 - Punctuality measures the percentage of trains arriving at their destinations on time (the train doesn’t arrive after planned arrival) and the train didn’t depart before planned departure time. The goal is to maintain a high level of reliability and minimize delays for passengers and freight services. ', 'This KPI contributes to evaluating Effectiveness of the AI-based assistant, as part of Task 4.1 evaluation objectives, and O2 main project objective:<br/>- Improve customer satisfaction by ensuring timely arrivals<br/>- Guarantee maximal planned connection<br/>- Minimize operational disruptions caused by delays<br/>- Meet regulatory and stakeholder benchmarks for punctuality<br/>This KPI is linked with project’s Long Term Expected Impacts (LTEI) (LTEI1)KPIS-3:<br/>- 10% increase in punctuality in long-range traffic<br/>- 5% increase in punctuality in regional traffic (with realistic disturbances)<br/>', array['ce856981-fd85-49c0-8d04-24036377da9d', '421c6abf-74e9-4a19-b5ef-a81c1ee1b3e0']::uuid[])
    ON CONFLICT(id) DO UPDATE SET name=EXCLUDED.name, description=EXCLUDED.description, field_ids=EXCLUDED.field_ids;

INSERT INTO field_definitions
        (id, key, description, agg_func, agg_weights)
        VALUES ('ce856981-fd85-49c0-8d04-24036377da9d', 'sum_normalized_reward', 'Primary scenario score (raw values): sum_normalized_reward', NULL, NULL)
        ON CONFLICT(id) DO UPDATE SET key=EXCLUDED.key, description=EXCLUDED.description, agg_func=EXCLUDED.agg_func, agg_weights=EXCLUDED.agg_weights;

INSERT INTO field_definitions
        (id, key, description, agg_func, agg_weights)
        VALUES ('421c6abf-74e9-4a19-b5ef-a81c1ee1b3e0', 'success_rate', 'Secondary scenario score (raw values): success_rate', NULL, NULL)
        ON CONFLICT(id) DO UPDATE SET key=EXCLUDED.key, description=EXCLUDED.description, agg_func=EXCLUDED.agg_func, agg_weights=EXCLUDED.agg_weights;

INSERT INTO scenario_definitions
    (id, name, description, field_ids)
    VALUES ('8397e6d6-babc-469b-a239-7eabcbd510da', 'Scenario 023 - Punctuality measures the percentage of trains arriving at their destinations on time (the train doesn’t arrive after planned arrival) and the train didn’t depart before planned departure time. The goal is to maintain a high level of reliability and minimize delays for passengers and freight services. ', 'This KPI contributes to evaluating Effectiveness of the AI-based assistant, as part of Task 4.1 evaluation objectives, and O2 main project objective:<br/>- Improve customer satisfaction by ensuring timely arrivals<br/>- Guarantee maximal planned connection<br/>- Minimize operational disruptions caused by delays<br/>- Meet regulatory and stakeholder benchmarks for punctuality<br/>This KPI is linked with project’s Long Term Expected Impacts (LTEI) (LTEI1)KPIS-3:<br/>- 10% increase in punctuality in long-range traffic<br/>- 5% increase in punctuality in regional traffic (with realistic disturbances)<br/>', array['66f07fc4-dd6a-4e00-a359-76989fa5b898', 'e0a6e544-7561-49b7-bd6a-9d816423046e']::uuid[])
    ON CONFLICT(id) DO UPDATE SET name=EXCLUDED.name, description=EXCLUDED.description, field_ids=EXCLUDED.field_ids;

INSERT INTO field_definitions
        (id, key, description, agg_func, agg_weights)
        VALUES ('66f07fc4-dd6a-4e00-a359-76989fa5b898', 'sum_normalized_reward', 'Primary scenario score (raw values): sum_normalized_reward', NULL, NULL)
        ON CONFLICT(id) DO UPDATE SET key=EXCLUDED.key, description=EXCLUDED.description, agg_func=EXCLUDED.agg_func, agg_weights=EXCLUDED.agg_weights;

INSERT INTO field_definitions
        (id, key, description, agg_func, agg_weights)
        VALUES ('e0a6e544-7561-49b7-bd6a-9d816423046e', 'success_rate', 'Secondary scenario score (raw values): success_rate', NULL, NULL)
        ON CONFLICT(id) DO UPDATE SET key=EXCLUDED.key, description=EXCLUDED.description, agg_func=EXCLUDED.agg_func, agg_weights=EXCLUDED.agg_weights;

INSERT INTO scenario_definitions
    (id, name, description, field_ids)
    VALUES ('c359f13c-d222-4b04-ad0a-2bb30fb9da5f', 'Scenario 024 - Punctuality measures the percentage of trains arriving at their destinations on time (the train doesn’t arrive after planned arrival) and the train didn’t depart before planned departure time. The goal is to maintain a high level of reliability and minimize delays for passengers and freight services. ', 'This KPI contributes to evaluating Effectiveness of the AI-based assistant, as part of Task 4.1 evaluation objectives, and O2 main project objective:<br/>- Improve customer satisfaction by ensuring timely arrivals<br/>- Guarantee maximal planned connection<br/>- Minimize operational disruptions caused by delays<br/>- Meet regulatory and stakeholder benchmarks for punctuality<br/>This KPI is linked with project’s Long Term Expected Impacts (LTEI) (LTEI1)KPIS-3:<br/>- 10% increase in punctuality in long-range traffic<br/>- 5% increase in punctuality in regional traffic (with realistic disturbances)<br/>', array['4c21e031-0502-40b1-bd96-e7231f863343', '00c006b9-e5ed-4a45-a7e8-9763aa0bbcf5']::uuid[])
    ON CONFLICT(id) DO UPDATE SET name=EXCLUDED.name, description=EXCLUDED.description, field_ids=EXCLUDED.field_ids;

INSERT INTO field_definitions
        (id, key, description, agg_func, agg_weights)
        VALUES ('4c21e031-0502-40b1-bd96-e7231f863343', 'sum_normalized_reward', 'Primary scenario score (raw values): sum_normalized_reward', NULL, NULL)
        ON CONFLICT(id) DO UPDATE SET key=EXCLUDED.key, description=EXCLUDED.description, agg_func=EXCLUDED.agg_func, agg_weights=EXCLUDED.agg_weights;

INSERT INTO field_definitions
        (id, key, description, agg_func, agg_weights)
        VALUES ('00c006b9-e5ed-4a45-a7e8-9763aa0bbcf5', 'success_rate', 'Secondary scenario score (raw values): success_rate', NULL, NULL)
        ON CONFLICT(id) DO UPDATE SET key=EXCLUDED.key, description=EXCLUDED.description, agg_func=EXCLUDED.agg_func, agg_weights=EXCLUDED.agg_weights;

INSERT INTO scenario_definitions
    (id, name, description, field_ids)
    VALUES ('97203764-6717-4ca6-bae9-c35c4eb38206', 'Scenario 025 - Punctuality measures the percentage of trains arriving at their destinations on time (the train doesn’t arrive after planned arrival) and the train didn’t depart before planned departure time. The goal is to maintain a high level of reliability and minimize delays for passengers and freight services. ', 'This KPI contributes to evaluating Effectiveness of the AI-based assistant, as part of Task 4.1 evaluation objectives, and O2 main project objective:<br/>- Improve customer satisfaction by ensuring timely arrivals<br/>- Guarantee maximal planned connection<br/>- Minimize operational disruptions caused by delays<br/>- Meet regulatory and stakeholder benchmarks for punctuality<br/>This KPI is linked with project’s Long Term Expected Impacts (LTEI) (LTEI1)KPIS-3:<br/>- 10% increase in punctuality in long-range traffic<br/>- 5% increase in punctuality in regional traffic (with realistic disturbances)<br/>', array['dd9e5742-047d-49dd-8bf7-d982a98ce24f', '360e9659-3510-4a57-bc75-876156ab1c14']::uuid[])
    ON CONFLICT(id) DO UPDATE SET name=EXCLUDED.name, description=EXCLUDED.description, field_ids=EXCLUDED.field_ids;

INSERT INTO field_definitions
        (id, key, description, agg_func, agg_weights)
        VALUES ('dd9e5742-047d-49dd-8bf7-d982a98ce24f', 'sum_normalized_reward', 'Primary scenario score (raw values): sum_normalized_reward', NULL, NULL)
        ON CONFLICT(id) DO UPDATE SET key=EXCLUDED.key, description=EXCLUDED.description, agg_func=EXCLUDED.agg_func, agg_weights=EXCLUDED.agg_weights;

INSERT INTO field_definitions
        (id, key, description, agg_func, agg_weights)
        VALUES ('360e9659-3510-4a57-bc75-876156ab1c14', 'success_rate', 'Secondary scenario score (raw values): success_rate', NULL, NULL)
        ON CONFLICT(id) DO UPDATE SET key=EXCLUDED.key, description=EXCLUDED.description, agg_func=EXCLUDED.agg_func, agg_weights=EXCLUDED.agg_weights;

INSERT INTO scenario_definitions
    (id, name, description, field_ids)
    VALUES ('adc4bf52-096c-4369-a85f-c9bf4b86bc64', 'Scenario 026 - Punctuality measures the percentage of trains arriving at their destinations on time (the train doesn’t arrive after planned arrival) and the train didn’t depart before planned departure time. The goal is to maintain a high level of reliability and minimize delays for passengers and freight services. ', 'This KPI contributes to evaluating Effectiveness of the AI-based assistant, as part of Task 4.1 evaluation objectives, and O2 main project objective:<br/>- Improve customer satisfaction by ensuring timely arrivals<br/>- Guarantee maximal planned connection<br/>- Minimize operational disruptions caused by delays<br/>- Meet regulatory and stakeholder benchmarks for punctuality<br/>This KPI is linked with project’s Long Term Expected Impacts (LTEI) (LTEI1)KPIS-3:<br/>- 10% increase in punctuality in long-range traffic<br/>- 5% increase in punctuality in regional traffic (with realistic disturbances)<br/>', array['8e8c2a63-e9be-4129-b756-b77960a950d7', '1e890bbe-ebbc-4a6a-bbd1-a12a29dc8130']::uuid[])
    ON CONFLICT(id) DO UPDATE SET name=EXCLUDED.name, description=EXCLUDED.description, field_ids=EXCLUDED.field_ids;

INSERT INTO field_definitions
        (id, key, description, agg_func, agg_weights)
        VALUES ('8e8c2a63-e9be-4129-b756-b77960a950d7', 'sum_normalized_reward', 'Primary scenario score (raw values): sum_normalized_reward', NULL, NULL)
        ON CONFLICT(id) DO UPDATE SET key=EXCLUDED.key, description=EXCLUDED.description, agg_func=EXCLUDED.agg_func, agg_weights=EXCLUDED.agg_weights;

INSERT INTO field_definitions
        (id, key, description, agg_func, agg_weights)
        VALUES ('1e890bbe-ebbc-4a6a-bbd1-a12a29dc8130', 'success_rate', 'Secondary scenario score (raw values): success_rate', NULL, NULL)
        ON CONFLICT(id) DO UPDATE SET key=EXCLUDED.key, description=EXCLUDED.description, agg_func=EXCLUDED.agg_func, agg_weights=EXCLUDED.agg_weights;

INSERT INTO scenario_definitions
    (id, name, description, field_ids)
    VALUES ('72f93d48-ecef-4bf7-9d97-cb008b47e566', 'Scenario 027 - Punctuality measures the percentage of trains arriving at their destinations on time (the train doesn’t arrive after planned arrival) and the train didn’t depart before planned departure time. The goal is to maintain a high level of reliability and minimize delays for passengers and freight services. ', 'This KPI contributes to evaluating Effectiveness of the AI-based assistant, as part of Task 4.1 evaluation objectives, and O2 main project objective:<br/>- Improve customer satisfaction by ensuring timely arrivals<br/>- Guarantee maximal planned connection<br/>- Minimize operational disruptions caused by delays<br/>- Meet regulatory and stakeholder benchmarks for punctuality<br/>This KPI is linked with project’s Long Term Expected Impacts (LTEI) (LTEI1)KPIS-3:<br/>- 10% increase in punctuality in long-range traffic<br/>- 5% increase in punctuality in regional traffic (with realistic disturbances)<br/>', array['a41f3b4a-57af-475c-b1de-0635a072857a', 'bab31a7e-eea4-4b54-a8cf-ed721de4aa75']::uuid[])
    ON CONFLICT(id) DO UPDATE SET name=EXCLUDED.name, description=EXCLUDED.description, field_ids=EXCLUDED.field_ids;

INSERT INTO field_definitions
        (id, key, description, agg_func, agg_weights)
        VALUES ('a41f3b4a-57af-475c-b1de-0635a072857a', 'sum_normalized_reward', 'Primary scenario score (raw values): sum_normalized_reward', NULL, NULL)
        ON CONFLICT(id) DO UPDATE SET key=EXCLUDED.key, description=EXCLUDED.description, agg_func=EXCLUDED.agg_func, agg_weights=EXCLUDED.agg_weights;

INSERT INTO field_definitions
        (id, key, description, agg_func, agg_weights)
        VALUES ('bab31a7e-eea4-4b54-a8cf-ed721de4aa75', 'success_rate', 'Secondary scenario score (raw values): success_rate', NULL, NULL)
        ON CONFLICT(id) DO UPDATE SET key=EXCLUDED.key, description=EXCLUDED.description, agg_func=EXCLUDED.agg_func, agg_weights=EXCLUDED.agg_weights;

INSERT INTO scenario_definitions
    (id, name, description, field_ids)
    VALUES ('b470667b-d9c9-4af4-b64e-c32102c34387', 'Scenario 028 - Punctuality measures the percentage of trains arriving at their destinations on time (the train doesn’t arrive after planned arrival) and the train didn’t depart before planned departure time. The goal is to maintain a high level of reliability and minimize delays for passengers and freight services. ', 'This KPI contributes to evaluating Effectiveness of the AI-based assistant, as part of Task 4.1 evaluation objectives, and O2 main project objective:<br/>- Improve customer satisfaction by ensuring timely arrivals<br/>- Guarantee maximal planned connection<br/>- Minimize operational disruptions caused by delays<br/>- Meet regulatory and stakeholder benchmarks for punctuality<br/>This KPI is linked with project’s Long Term Expected Impacts (LTEI) (LTEI1)KPIS-3:<br/>- 10% increase in punctuality in long-range traffic<br/>- 5% increase in punctuality in regional traffic (with realistic disturbances)<br/>', array['3057de2a-da30-46f5-8a22-8c232c5006d5', '4e73fe17-7ff6-4239-8ca9-ecc78ad41fb2']::uuid[])
    ON CONFLICT(id) DO UPDATE SET name=EXCLUDED.name, description=EXCLUDED.description, field_ids=EXCLUDED.field_ids;

INSERT INTO field_definitions
        (id, key, description, agg_func, agg_weights)
        VALUES ('3057de2a-da30-46f5-8a22-8c232c5006d5', 'sum_normalized_reward', 'Primary scenario score (raw values): sum_normalized_reward', NULL, NULL)
        ON CONFLICT(id) DO UPDATE SET key=EXCLUDED.key, description=EXCLUDED.description, agg_func=EXCLUDED.agg_func, agg_weights=EXCLUDED.agg_weights;

INSERT INTO field_definitions
        (id, key, description, agg_func, agg_weights)
        VALUES ('4e73fe17-7ff6-4239-8ca9-ecc78ad41fb2', 'success_rate', 'Secondary scenario score (raw values): success_rate', NULL, NULL)
        ON CONFLICT(id) DO UPDATE SET key=EXCLUDED.key, description=EXCLUDED.description, agg_func=EXCLUDED.agg_func, agg_weights=EXCLUDED.agg_weights;

INSERT INTO scenario_definitions
    (id, name, description, field_ids)
    VALUES ('4aa9e1b8-8669-466e-b4b9-c7db2a098bec', 'Scenario 029 - Punctuality measures the percentage of trains arriving at their destinations on time (the train doesn’t arrive after planned arrival) and the train didn’t depart before planned departure time. The goal is to maintain a high level of reliability and minimize delays for passengers and freight services. ', 'This KPI contributes to evaluating Effectiveness of the AI-based assistant, as part of Task 4.1 evaluation objectives, and O2 main project objective:<br/>- Improve customer satisfaction by ensuring timely arrivals<br/>- Guarantee maximal planned connection<br/>- Minimize operational disruptions caused by delays<br/>- Meet regulatory and stakeholder benchmarks for punctuality<br/>This KPI is linked with project’s Long Term Expected Impacts (LTEI) (LTEI1)KPIS-3:<br/>- 10% increase in punctuality in long-range traffic<br/>- 5% increase in punctuality in regional traffic (with realistic disturbances)<br/>', array['7f662e6c-4857-4b73-8b08-dd6979e050dc', '28006112-841d-4a3c-8117-09887ef3f84c']::uuid[])
    ON CONFLICT(id) DO UPDATE SET name=EXCLUDED.name, description=EXCLUDED.description, field_ids=EXCLUDED.field_ids;

INSERT INTO field_definitions
        (id, key, description, agg_func, agg_weights)
        VALUES ('7f662e6c-4857-4b73-8b08-dd6979e050dc', 'sum_normalized_reward', 'Primary scenario score (raw values): sum_normalized_reward', NULL, NULL)
        ON CONFLICT(id) DO UPDATE SET key=EXCLUDED.key, description=EXCLUDED.description, agg_func=EXCLUDED.agg_func, agg_weights=EXCLUDED.agg_weights;

INSERT INTO field_definitions
        (id, key, description, agg_func, agg_weights)
        VALUES ('28006112-841d-4a3c-8117-09887ef3f84c', 'success_rate', 'Secondary scenario score (raw values): success_rate', NULL, NULL)
        ON CONFLICT(id) DO UPDATE SET key=EXCLUDED.key, description=EXCLUDED.description, agg_func=EXCLUDED.agg_func, agg_weights=EXCLUDED.agg_weights;

INSERT INTO scenario_definitions
    (id, name, description, field_ids)
    VALUES ('44354e67-e0b7-4faa-9385-2d6247c7a50c', 'Scenario 030 - Punctuality measures the percentage of trains arriving at their destinations on time (the train doesn’t arrive after planned arrival) and the train didn’t depart before planned departure time. The goal is to maintain a high level of reliability and minimize delays for passengers and freight services. ', 'This KPI contributes to evaluating Effectiveness of the AI-based assistant, as part of Task 4.1 evaluation objectives, and O2 main project objective:<br/>- Improve customer satisfaction by ensuring timely arrivals<br/>- Guarantee maximal planned connection<br/>- Minimize operational disruptions caused by delays<br/>- Meet regulatory and stakeholder benchmarks for punctuality<br/>This KPI is linked with project’s Long Term Expected Impacts (LTEI) (LTEI1)KPIS-3:<br/>- 10% increase in punctuality in long-range traffic<br/>- 5% increase in punctuality in regional traffic (with realistic disturbances)<br/>', array['77e5889e-20d7-4427-93fe-6fd093084fed', 'bd6ab4c1-1524-46c4-857e-07f822c3797d']::uuid[])
    ON CONFLICT(id) DO UPDATE SET name=EXCLUDED.name, description=EXCLUDED.description, field_ids=EXCLUDED.field_ids;

INSERT INTO field_definitions
        (id, key, description, agg_func, agg_weights)
        VALUES ('77e5889e-20d7-4427-93fe-6fd093084fed', 'sum_normalized_reward', 'Primary scenario score (raw values): sum_normalized_reward', NULL, NULL)
        ON CONFLICT(id) DO UPDATE SET key=EXCLUDED.key, description=EXCLUDED.description, agg_func=EXCLUDED.agg_func, agg_weights=EXCLUDED.agg_weights;

INSERT INTO field_definitions
        (id, key, description, agg_func, agg_weights)
        VALUES ('bd6ab4c1-1524-46c4-857e-07f822c3797d', 'success_rate', 'Secondary scenario score (raw values): success_rate', NULL, NULL)
        ON CONFLICT(id) DO UPDATE SET key=EXCLUDED.key, description=EXCLUDED.description, agg_func=EXCLUDED.agg_func, agg_weights=EXCLUDED.agg_weights;

INSERT INTO scenario_definitions
    (id, name, description, field_ids)
    VALUES ('4bca2964-ef35-4b03-a47e-829bc9078374', 'Scenario 031 - Punctuality measures the percentage of trains arriving at their destinations on time (the train doesn’t arrive after planned arrival) and the train didn’t depart before planned departure time. The goal is to maintain a high level of reliability and minimize delays for passengers and freight services. ', 'This KPI contributes to evaluating Effectiveness of the AI-based assistant, as part of Task 4.1 evaluation objectives, and O2 main project objective:<br/>- Improve customer satisfaction by ensuring timely arrivals<br/>- Guarantee maximal planned connection<br/>- Minimize operational disruptions caused by delays<br/>- Meet regulatory and stakeholder benchmarks for punctuality<br/>This KPI is linked with project’s Long Term Expected Impacts (LTEI) (LTEI1)KPIS-3:<br/>- 10% increase in punctuality in long-range traffic<br/>- 5% increase in punctuality in regional traffic (with realistic disturbances)<br/>', array['01ae1886-d77f-4052-9633-08adeaafb296', 'b8beace1-30c0-4f09-b65f-de89db029e75']::uuid[])
    ON CONFLICT(id) DO UPDATE SET name=EXCLUDED.name, description=EXCLUDED.description, field_ids=EXCLUDED.field_ids;

INSERT INTO field_definitions
        (id, key, description, agg_func, agg_weights)
        VALUES ('01ae1886-d77f-4052-9633-08adeaafb296', 'sum_normalized_reward', 'Primary scenario score (raw values): sum_normalized_reward', NULL, NULL)
        ON CONFLICT(id) DO UPDATE SET key=EXCLUDED.key, description=EXCLUDED.description, agg_func=EXCLUDED.agg_func, agg_weights=EXCLUDED.agg_weights;

INSERT INTO field_definitions
        (id, key, description, agg_func, agg_weights)
        VALUES ('b8beace1-30c0-4f09-b65f-de89db029e75', 'success_rate', 'Secondary scenario score (raw values): success_rate', NULL, NULL)
        ON CONFLICT(id) DO UPDATE SET key=EXCLUDED.key, description=EXCLUDED.description, agg_func=EXCLUDED.agg_func, agg_weights=EXCLUDED.agg_weights;

INSERT INTO scenario_definitions
    (id, name, description, field_ids)
    VALUES ('6190b6ac-a06b-4b07-8b82-0dfb1088663f', 'Scenario 032 - Punctuality measures the percentage of trains arriving at their destinations on time (the train doesn’t arrive after planned arrival) and the train didn’t depart before planned departure time. The goal is to maintain a high level of reliability and minimize delays for passengers and freight services. ', 'This KPI contributes to evaluating Effectiveness of the AI-based assistant, as part of Task 4.1 evaluation objectives, and O2 main project objective:<br/>- Improve customer satisfaction by ensuring timely arrivals<br/>- Guarantee maximal planned connection<br/>- Minimize operational disruptions caused by delays<br/>- Meet regulatory and stakeholder benchmarks for punctuality<br/>This KPI is linked with project’s Long Term Expected Impacts (LTEI) (LTEI1)KPIS-3:<br/>- 10% increase in punctuality in long-range traffic<br/>- 5% increase in punctuality in regional traffic (with realistic disturbances)<br/>', array['89d20126-8572-4cc9-906d-84c35aa882e6', '172848d0-8ec6-4c51-b6a9-60cc4a935479']::uuid[])
    ON CONFLICT(id) DO UPDATE SET name=EXCLUDED.name, description=EXCLUDED.description, field_ids=EXCLUDED.field_ids;

INSERT INTO field_definitions
        (id, key, description, agg_func, agg_weights)
        VALUES ('89d20126-8572-4cc9-906d-84c35aa882e6', 'sum_normalized_reward', 'Primary scenario score (raw values): sum_normalized_reward', NULL, NULL)
        ON CONFLICT(id) DO UPDATE SET key=EXCLUDED.key, description=EXCLUDED.description, agg_func=EXCLUDED.agg_func, agg_weights=EXCLUDED.agg_weights;

INSERT INTO field_definitions
        (id, key, description, agg_func, agg_weights)
        VALUES ('172848d0-8ec6-4c51-b6a9-60cc4a935479', 'success_rate', 'Secondary scenario score (raw values): success_rate', NULL, NULL)
        ON CONFLICT(id) DO UPDATE SET key=EXCLUDED.key, description=EXCLUDED.description, agg_func=EXCLUDED.agg_func, agg_weights=EXCLUDED.agg_weights;

INSERT INTO scenario_definitions
    (id, name, description, field_ids)
    VALUES ('a51d4e4a-c841-416f-9292-fc64dead758b', 'Scenario 033 - Punctuality measures the percentage of trains arriving at their destinations on time (the train doesn’t arrive after planned arrival) and the train didn’t depart before planned departure time. The goal is to maintain a high level of reliability and minimize delays for passengers and freight services. ', 'This KPI contributes to evaluating Effectiveness of the AI-based assistant, as part of Task 4.1 evaluation objectives, and O2 main project objective:<br/>- Improve customer satisfaction by ensuring timely arrivals<br/>- Guarantee maximal planned connection<br/>- Minimize operational disruptions caused by delays<br/>- Meet regulatory and stakeholder benchmarks for punctuality<br/>This KPI is linked with project’s Long Term Expected Impacts (LTEI) (LTEI1)KPIS-3:<br/>- 10% increase in punctuality in long-range traffic<br/>- 5% increase in punctuality in regional traffic (with realistic disturbances)<br/>', array['f3e2cf00-6cc5-4657-9d23-5f9e74747672', 'a056948f-c1b3-4b56-979d-015671202ff1']::uuid[])
    ON CONFLICT(id) DO UPDATE SET name=EXCLUDED.name, description=EXCLUDED.description, field_ids=EXCLUDED.field_ids;

INSERT INTO field_definitions
        (id, key, description, agg_func, agg_weights)
        VALUES ('f3e2cf00-6cc5-4657-9d23-5f9e74747672', 'sum_normalized_reward', 'Primary scenario score (raw values): sum_normalized_reward', NULL, NULL)
        ON CONFLICT(id) DO UPDATE SET key=EXCLUDED.key, description=EXCLUDED.description, agg_func=EXCLUDED.agg_func, agg_weights=EXCLUDED.agg_weights;

INSERT INTO field_definitions
        (id, key, description, agg_func, agg_weights)
        VALUES ('a056948f-c1b3-4b56-979d-015671202ff1', 'success_rate', 'Secondary scenario score (raw values): success_rate', NULL, NULL)
        ON CONFLICT(id) DO UPDATE SET key=EXCLUDED.key, description=EXCLUDED.description, agg_func=EXCLUDED.agg_func, agg_weights=EXCLUDED.agg_weights;

INSERT INTO scenario_definitions
    (id, name, description, field_ids)
    VALUES ('d08f6539-5c3e-4a98-93ae-3e344611e3a8', 'Scenario 034 - Punctuality measures the percentage of trains arriving at their destinations on time (the train doesn’t arrive after planned arrival) and the train didn’t depart before planned departure time. The goal is to maintain a high level of reliability and minimize delays for passengers and freight services. ', 'This KPI contributes to evaluating Effectiveness of the AI-based assistant, as part of Task 4.1 evaluation objectives, and O2 main project objective:<br/>- Improve customer satisfaction by ensuring timely arrivals<br/>- Guarantee maximal planned connection<br/>- Minimize operational disruptions caused by delays<br/>- Meet regulatory and stakeholder benchmarks for punctuality<br/>This KPI is linked with project’s Long Term Expected Impacts (LTEI) (LTEI1)KPIS-3:<br/>- 10% increase in punctuality in long-range traffic<br/>- 5% increase in punctuality in regional traffic (with realistic disturbances)<br/>', array['b1760251-c61d-45e3-9b1f-424a44108d84', 'e40b3acf-b405-4090-8b12-37dc6a57707b']::uuid[])
    ON CONFLICT(id) DO UPDATE SET name=EXCLUDED.name, description=EXCLUDED.description, field_ids=EXCLUDED.field_ids;

INSERT INTO field_definitions
        (id, key, description, agg_func, agg_weights)
        VALUES ('b1760251-c61d-45e3-9b1f-424a44108d84', 'sum_normalized_reward', 'Primary scenario score (raw values): sum_normalized_reward', NULL, NULL)
        ON CONFLICT(id) DO UPDATE SET key=EXCLUDED.key, description=EXCLUDED.description, agg_func=EXCLUDED.agg_func, agg_weights=EXCLUDED.agg_weights;

INSERT INTO field_definitions
        (id, key, description, agg_func, agg_weights)
        VALUES ('e40b3acf-b405-4090-8b12-37dc6a57707b', 'success_rate', 'Secondary scenario score (raw values): success_rate', NULL, NULL)
        ON CONFLICT(id) DO UPDATE SET key=EXCLUDED.key, description=EXCLUDED.description, agg_func=EXCLUDED.agg_func, agg_weights=EXCLUDED.agg_weights;

INSERT INTO scenario_definitions
    (id, name, description, field_ids)
    VALUES ('8a2ec760-d2c2-4329-b373-3acd95395076', 'Scenario 035 - Punctuality measures the percentage of trains arriving at their destinations on time (the train doesn’t arrive after planned arrival) and the train didn’t depart before planned departure time. The goal is to maintain a high level of reliability and minimize delays for passengers and freight services. ', 'This KPI contributes to evaluating Effectiveness of the AI-based assistant, as part of Task 4.1 evaluation objectives, and O2 main project objective:<br/>- Improve customer satisfaction by ensuring timely arrivals<br/>- Guarantee maximal planned connection<br/>- Minimize operational disruptions caused by delays<br/>- Meet regulatory and stakeholder benchmarks for punctuality<br/>This KPI is linked with project’s Long Term Expected Impacts (LTEI) (LTEI1)KPIS-3:<br/>- 10% increase in punctuality in long-range traffic<br/>- 5% increase in punctuality in regional traffic (with realistic disturbances)<br/>', array['7c3c8e30-a60a-429b-94d5-82c55ab7a87b', 'a9c1f2c2-4b4a-402c-a1c9-87f00f3ad557']::uuid[])
    ON CONFLICT(id) DO UPDATE SET name=EXCLUDED.name, description=EXCLUDED.description, field_ids=EXCLUDED.field_ids;

INSERT INTO field_definitions
        (id, key, description, agg_func, agg_weights)
        VALUES ('7c3c8e30-a60a-429b-94d5-82c55ab7a87b', 'sum_normalized_reward', 'Primary scenario score (raw values): sum_normalized_reward', NULL, NULL)
        ON CONFLICT(id) DO UPDATE SET key=EXCLUDED.key, description=EXCLUDED.description, agg_func=EXCLUDED.agg_func, agg_weights=EXCLUDED.agg_weights;

INSERT INTO field_definitions
        (id, key, description, agg_func, agg_weights)
        VALUES ('a9c1f2c2-4b4a-402c-a1c9-87f00f3ad557', 'success_rate', 'Secondary scenario score (raw values): success_rate', NULL, NULL)
        ON CONFLICT(id) DO UPDATE SET key=EXCLUDED.key, description=EXCLUDED.description, agg_func=EXCLUDED.agg_func, agg_weights=EXCLUDED.agg_weights;

INSERT INTO scenario_definitions
    (id, name, description, field_ids)
    VALUES ('9b136147-f560-45d4-abd8-9f7de7cd7570', 'Scenario 036 - Punctuality measures the percentage of trains arriving at their destinations on time (the train doesn’t arrive after planned arrival) and the train didn’t depart before planned departure time. The goal is to maintain a high level of reliability and minimize delays for passengers and freight services. ', 'This KPI contributes to evaluating Effectiveness of the AI-based assistant, as part of Task 4.1 evaluation objectives, and O2 main project objective:<br/>- Improve customer satisfaction by ensuring timely arrivals<br/>- Guarantee maximal planned connection<br/>- Minimize operational disruptions caused by delays<br/>- Meet regulatory and stakeholder benchmarks for punctuality<br/>This KPI is linked with project’s Long Term Expected Impacts (LTEI) (LTEI1)KPIS-3:<br/>- 10% increase in punctuality in long-range traffic<br/>- 5% increase in punctuality in regional traffic (with realistic disturbances)<br/>', array['da8327ac-9de5-42e9-87da-202d07b1fea6', 'dae4156e-afba-4a38-8dcc-8b8b705a08a5']::uuid[])
    ON CONFLICT(id) DO UPDATE SET name=EXCLUDED.name, description=EXCLUDED.description, field_ids=EXCLUDED.field_ids;

INSERT INTO field_definitions
        (id, key, description, agg_func, agg_weights)
        VALUES ('da8327ac-9de5-42e9-87da-202d07b1fea6', 'sum_normalized_reward', 'Primary scenario score (raw values): sum_normalized_reward', NULL, NULL)
        ON CONFLICT(id) DO UPDATE SET key=EXCLUDED.key, description=EXCLUDED.description, agg_func=EXCLUDED.agg_func, agg_weights=EXCLUDED.agg_weights;

INSERT INTO field_definitions
        (id, key, description, agg_func, agg_weights)
        VALUES ('dae4156e-afba-4a38-8dcc-8b8b705a08a5', 'success_rate', 'Secondary scenario score (raw values): success_rate', NULL, NULL)
        ON CONFLICT(id) DO UPDATE SET key=EXCLUDED.key, description=EXCLUDED.description, agg_func=EXCLUDED.agg_func, agg_weights=EXCLUDED.agg_weights;

INSERT INTO scenario_definitions
    (id, name, description, field_ids)
    VALUES ('9723c2c5-ee55-441d-9dba-1a1dc23fdc5e', 'Scenario 037 - Punctuality measures the percentage of trains arriving at their destinations on time (the train doesn’t arrive after planned arrival) and the train didn’t depart before planned departure time. The goal is to maintain a high level of reliability and minimize delays for passengers and freight services. ', 'This KPI contributes to evaluating Effectiveness of the AI-based assistant, as part of Task 4.1 evaluation objectives, and O2 main project objective:<br/>- Improve customer satisfaction by ensuring timely arrivals<br/>- Guarantee maximal planned connection<br/>- Minimize operational disruptions caused by delays<br/>- Meet regulatory and stakeholder benchmarks for punctuality<br/>This KPI is linked with project’s Long Term Expected Impacts (LTEI) (LTEI1)KPIS-3:<br/>- 10% increase in punctuality in long-range traffic<br/>- 5% increase in punctuality in regional traffic (with realistic disturbances)<br/>', array['7d87c886-3a32-4278-9f1b-eb48bcc2d862', '21abc1d2-1930-4993-8d78-13537b924a09']::uuid[])
    ON CONFLICT(id) DO UPDATE SET name=EXCLUDED.name, description=EXCLUDED.description, field_ids=EXCLUDED.field_ids;

INSERT INTO field_definitions
        (id, key, description, agg_func, agg_weights)
        VALUES ('7d87c886-3a32-4278-9f1b-eb48bcc2d862', 'sum_normalized_reward', 'Primary scenario score (raw values): sum_normalized_reward', NULL, NULL)
        ON CONFLICT(id) DO UPDATE SET key=EXCLUDED.key, description=EXCLUDED.description, agg_func=EXCLUDED.agg_func, agg_weights=EXCLUDED.agg_weights;

INSERT INTO field_definitions
        (id, key, description, agg_func, agg_weights)
        VALUES ('21abc1d2-1930-4993-8d78-13537b924a09', 'success_rate', 'Secondary scenario score (raw values): success_rate', NULL, NULL)
        ON CONFLICT(id) DO UPDATE SET key=EXCLUDED.key, description=EXCLUDED.description, agg_func=EXCLUDED.agg_func, agg_weights=EXCLUDED.agg_weights;

INSERT INTO scenario_definitions
    (id, name, description, field_ids)
    VALUES ('3406bbe9-cb19-44b7-af26-460b0a117a6c', 'Scenario 038 - Punctuality measures the percentage of trains arriving at their destinations on time (the train doesn’t arrive after planned arrival) and the train didn’t depart before planned departure time. The goal is to maintain a high level of reliability and minimize delays for passengers and freight services. ', 'This KPI contributes to evaluating Effectiveness of the AI-based assistant, as part of Task 4.1 evaluation objectives, and O2 main project objective:<br/>- Improve customer satisfaction by ensuring timely arrivals<br/>- Guarantee maximal planned connection<br/>- Minimize operational disruptions caused by delays<br/>- Meet regulatory and stakeholder benchmarks for punctuality<br/>This KPI is linked with project’s Long Term Expected Impacts (LTEI) (LTEI1)KPIS-3:<br/>- 10% increase in punctuality in long-range traffic<br/>- 5% increase in punctuality in regional traffic (with realistic disturbances)<br/>', array['bd250128-0fb3-4105-abf8-bebd763cb97c', 'bc35dfb5-18bc-4d2b-b3f4-f16f2bda8fa0']::uuid[])
    ON CONFLICT(id) DO UPDATE SET name=EXCLUDED.name, description=EXCLUDED.description, field_ids=EXCLUDED.field_ids;

INSERT INTO field_definitions
        (id, key, description, agg_func, agg_weights)
        VALUES ('bd250128-0fb3-4105-abf8-bebd763cb97c', 'sum_normalized_reward', 'Primary scenario score (raw values): sum_normalized_reward', NULL, NULL)
        ON CONFLICT(id) DO UPDATE SET key=EXCLUDED.key, description=EXCLUDED.description, agg_func=EXCLUDED.agg_func, agg_weights=EXCLUDED.agg_weights;

INSERT INTO field_definitions
        (id, key, description, agg_func, agg_weights)
        VALUES ('bc35dfb5-18bc-4d2b-b3f4-f16f2bda8fa0', 'success_rate', 'Secondary scenario score (raw values): success_rate', NULL, NULL)
        ON CONFLICT(id) DO UPDATE SET key=EXCLUDED.key, description=EXCLUDED.description, agg_func=EXCLUDED.agg_func, agg_weights=EXCLUDED.agg_weights;

INSERT INTO scenario_definitions
    (id, name, description, field_ids)
    VALUES ('ae0a88ad-3bfd-4201-b28a-e2c75d081cd5', 'Scenario 039 - Punctuality measures the percentage of trains arriving at their destinations on time (the train doesn’t arrive after planned arrival) and the train didn’t depart before planned departure time. The goal is to maintain a high level of reliability and minimize delays for passengers and freight services. ', 'This KPI contributes to evaluating Effectiveness of the AI-based assistant, as part of Task 4.1 evaluation objectives, and O2 main project objective:<br/>- Improve customer satisfaction by ensuring timely arrivals<br/>- Guarantee maximal planned connection<br/>- Minimize operational disruptions caused by delays<br/>- Meet regulatory and stakeholder benchmarks for punctuality<br/>This KPI is linked with project’s Long Term Expected Impacts (LTEI) (LTEI1)KPIS-3:<br/>- 10% increase in punctuality in long-range traffic<br/>- 5% increase in punctuality in regional traffic (with realistic disturbances)<br/>', array['90b0f241-b7ee-4dbe-8ea4-b2f964fedf58', '93ddf358-4286-4750-9c8f-d5a3e361d737']::uuid[])
    ON CONFLICT(id) DO UPDATE SET name=EXCLUDED.name, description=EXCLUDED.description, field_ids=EXCLUDED.field_ids;

INSERT INTO field_definitions
        (id, key, description, agg_func, agg_weights)
        VALUES ('90b0f241-b7ee-4dbe-8ea4-b2f964fedf58', 'sum_normalized_reward', 'Primary scenario score (raw values): sum_normalized_reward', NULL, NULL)
        ON CONFLICT(id) DO UPDATE SET key=EXCLUDED.key, description=EXCLUDED.description, agg_func=EXCLUDED.agg_func, agg_weights=EXCLUDED.agg_weights;

INSERT INTO field_definitions
        (id, key, description, agg_func, agg_weights)
        VALUES ('93ddf358-4286-4750-9c8f-d5a3e361d737', 'success_rate', 'Secondary scenario score (raw values): success_rate', NULL, NULL)
        ON CONFLICT(id) DO UPDATE SET key=EXCLUDED.key, description=EXCLUDED.description, agg_func=EXCLUDED.agg_func, agg_weights=EXCLUDED.agg_weights;

INSERT INTO scenario_definitions
    (id, name, description, field_ids)
    VALUES ('8b308495-7ea6-4ddc-acb4-56eb5b3aec12', 'Scenario 040 - Punctuality measures the percentage of trains arriving at their destinations on time (the train doesn’t arrive after planned arrival) and the train didn’t depart before planned departure time. The goal is to maintain a high level of reliability and minimize delays for passengers and freight services. ', 'This KPI contributes to evaluating Effectiveness of the AI-based assistant, as part of Task 4.1 evaluation objectives, and O2 main project objective:<br/>- Improve customer satisfaction by ensuring timely arrivals<br/>- Guarantee maximal planned connection<br/>- Minimize operational disruptions caused by delays<br/>- Meet regulatory and stakeholder benchmarks for punctuality<br/>This KPI is linked with project’s Long Term Expected Impacts (LTEI) (LTEI1)KPIS-3:<br/>- 10% increase in punctuality in long-range traffic<br/>- 5% increase in punctuality in regional traffic (with realistic disturbances)<br/>', array['88f509f0-83ce-4f89-84c4-f460ee6194c0', '2cb5003f-1593-47ac-a807-6866199c877f']::uuid[])
    ON CONFLICT(id) DO UPDATE SET name=EXCLUDED.name, description=EXCLUDED.description, field_ids=EXCLUDED.field_ids;

INSERT INTO field_definitions
        (id, key, description, agg_func, agg_weights)
        VALUES ('88f509f0-83ce-4f89-84c4-f460ee6194c0', 'sum_normalized_reward', 'Primary scenario score (raw values): sum_normalized_reward', NULL, NULL)
        ON CONFLICT(id) DO UPDATE SET key=EXCLUDED.key, description=EXCLUDED.description, agg_func=EXCLUDED.agg_func, agg_weights=EXCLUDED.agg_weights;

INSERT INTO field_definitions
        (id, key, description, agg_func, agg_weights)
        VALUES ('2cb5003f-1593-47ac-a807-6866199c877f', 'success_rate', 'Secondary scenario score (raw values): success_rate', NULL, NULL)
        ON CONFLICT(id) DO UPDATE SET key=EXCLUDED.key, description=EXCLUDED.description, agg_func=EXCLUDED.agg_func, agg_weights=EXCLUDED.agg_weights;

INSERT INTO scenario_definitions
    (id, name, description, field_ids)
    VALUES ('a8f69dc4-04a1-434a-ad97-27c745561b6a', 'Scenario 041 - Punctuality measures the percentage of trains arriving at their destinations on time (the train doesn’t arrive after planned arrival) and the train didn’t depart before planned departure time. The goal is to maintain a high level of reliability and minimize delays for passengers and freight services. ', 'This KPI contributes to evaluating Effectiveness of the AI-based assistant, as part of Task 4.1 evaluation objectives, and O2 main project objective:<br/>- Improve customer satisfaction by ensuring timely arrivals<br/>- Guarantee maximal planned connection<br/>- Minimize operational disruptions caused by delays<br/>- Meet regulatory and stakeholder benchmarks for punctuality<br/>This KPI is linked with project’s Long Term Expected Impacts (LTEI) (LTEI1)KPIS-3:<br/>- 10% increase in punctuality in long-range traffic<br/>- 5% increase in punctuality in regional traffic (with realistic disturbances)<br/>', array['23559b62-3bac-42ea-bfaf-0ecfaf2d5418', '9d441444-09dd-42a0-b2e7-7138d7367410']::uuid[])
    ON CONFLICT(id) DO UPDATE SET name=EXCLUDED.name, description=EXCLUDED.description, field_ids=EXCLUDED.field_ids;

INSERT INTO field_definitions
        (id, key, description, agg_func, agg_weights)
        VALUES ('23559b62-3bac-42ea-bfaf-0ecfaf2d5418', 'sum_normalized_reward', 'Primary scenario score (raw values): sum_normalized_reward', NULL, NULL)
        ON CONFLICT(id) DO UPDATE SET key=EXCLUDED.key, description=EXCLUDED.description, agg_func=EXCLUDED.agg_func, agg_weights=EXCLUDED.agg_weights;

INSERT INTO field_definitions
        (id, key, description, agg_func, agg_weights)
        VALUES ('9d441444-09dd-42a0-b2e7-7138d7367410', 'success_rate', 'Secondary scenario score (raw values): success_rate', NULL, NULL)
        ON CONFLICT(id) DO UPDATE SET key=EXCLUDED.key, description=EXCLUDED.description, agg_func=EXCLUDED.agg_func, agg_weights=EXCLUDED.agg_weights;

INSERT INTO scenario_definitions
    (id, name, description, field_ids)
    VALUES ('8b244f56-50e1-411a-a7d8-a2b89dfab26e', 'Scenario 042 - Punctuality measures the percentage of trains arriving at their destinations on time (the train doesn’t arrive after planned arrival) and the train didn’t depart before planned departure time. The goal is to maintain a high level of reliability and minimize delays for passengers and freight services. ', 'This KPI contributes to evaluating Effectiveness of the AI-based assistant, as part of Task 4.1 evaluation objectives, and O2 main project objective:<br/>- Improve customer satisfaction by ensuring timely arrivals<br/>- Guarantee maximal planned connection<br/>- Minimize operational disruptions caused by delays<br/>- Meet regulatory and stakeholder benchmarks for punctuality<br/>This KPI is linked with project’s Long Term Expected Impacts (LTEI) (LTEI1)KPIS-3:<br/>- 10% increase in punctuality in long-range traffic<br/>- 5% increase in punctuality in regional traffic (with realistic disturbances)<br/>', array['dc76fa30-a594-4d6f-a16b-6e2d13537830', '25d93d2a-953f-4be6-8656-0e8b2523b356']::uuid[])
    ON CONFLICT(id) DO UPDATE SET name=EXCLUDED.name, description=EXCLUDED.description, field_ids=EXCLUDED.field_ids;

INSERT INTO field_definitions
        (id, key, description, agg_func, agg_weights)
        VALUES ('dc76fa30-a594-4d6f-a16b-6e2d13537830', 'sum_normalized_reward', 'Primary scenario score (raw values): sum_normalized_reward', NULL, NULL)
        ON CONFLICT(id) DO UPDATE SET key=EXCLUDED.key, description=EXCLUDED.description, agg_func=EXCLUDED.agg_func, agg_weights=EXCLUDED.agg_weights;

INSERT INTO field_definitions
        (id, key, description, agg_func, agg_weights)
        VALUES ('25d93d2a-953f-4be6-8656-0e8b2523b356', 'success_rate', 'Secondary scenario score (raw values): success_rate', NULL, NULL)
        ON CONFLICT(id) DO UPDATE SET key=EXCLUDED.key, description=EXCLUDED.description, agg_func=EXCLUDED.agg_func, agg_weights=EXCLUDED.agg_weights;

INSERT INTO scenario_definitions
    (id, name, description, field_ids)
    VALUES ('8e6419c1-6470-4272-9c4b-43d9fe19dd3d', 'Scenario 043 - Punctuality measures the percentage of trains arriving at their destinations on time (the train doesn’t arrive after planned arrival) and the train didn’t depart before planned departure time. The goal is to maintain a high level of reliability and minimize delays for passengers and freight services. ', 'This KPI contributes to evaluating Effectiveness of the AI-based assistant, as part of Task 4.1 evaluation objectives, and O2 main project objective:<br/>- Improve customer satisfaction by ensuring timely arrivals<br/>- Guarantee maximal planned connection<br/>- Minimize operational disruptions caused by delays<br/>- Meet regulatory and stakeholder benchmarks for punctuality<br/>This KPI is linked with project’s Long Term Expected Impacts (LTEI) (LTEI1)KPIS-3:<br/>- 10% increase in punctuality in long-range traffic<br/>- 5% increase in punctuality in regional traffic (with realistic disturbances)<br/>', array['727b60a3-ac15-4361-9a33-5ca97594204c', '14045d98-c5d9-4345-9145-80663d7bd564']::uuid[])
    ON CONFLICT(id) DO UPDATE SET name=EXCLUDED.name, description=EXCLUDED.description, field_ids=EXCLUDED.field_ids;

INSERT INTO field_definitions
        (id, key, description, agg_func, agg_weights)
        VALUES ('727b60a3-ac15-4361-9a33-5ca97594204c', 'sum_normalized_reward', 'Primary scenario score (raw values): sum_normalized_reward', NULL, NULL)
        ON CONFLICT(id) DO UPDATE SET key=EXCLUDED.key, description=EXCLUDED.description, agg_func=EXCLUDED.agg_func, agg_weights=EXCLUDED.agg_weights;

INSERT INTO field_definitions
        (id, key, description, agg_func, agg_weights)
        VALUES ('14045d98-c5d9-4345-9145-80663d7bd564', 'success_rate', 'Secondary scenario score (raw values): success_rate', NULL, NULL)
        ON CONFLICT(id) DO UPDATE SET key=EXCLUDED.key, description=EXCLUDED.description, agg_func=EXCLUDED.agg_func, agg_weights=EXCLUDED.agg_weights;

INSERT INTO scenario_definitions
    (id, name, description, field_ids)
    VALUES ('ec503b6e-3682-4dcd-9dc7-b194b67283d9', 'Scenario 044 - Punctuality measures the percentage of trains arriving at their destinations on time (the train doesn’t arrive after planned arrival) and the train didn’t depart before planned departure time. The goal is to maintain a high level of reliability and minimize delays for passengers and freight services. ', 'This KPI contributes to evaluating Effectiveness of the AI-based assistant, as part of Task 4.1 evaluation objectives, and O2 main project objective:<br/>- Improve customer satisfaction by ensuring timely arrivals<br/>- Guarantee maximal planned connection<br/>- Minimize operational disruptions caused by delays<br/>- Meet regulatory and stakeholder benchmarks for punctuality<br/>This KPI is linked with project’s Long Term Expected Impacts (LTEI) (LTEI1)KPIS-3:<br/>- 10% increase in punctuality in long-range traffic<br/>- 5% increase in punctuality in regional traffic (with realistic disturbances)<br/>', array['3c18cf32-f868-4777-ba32-1edef5ca52ab', 'c0618d61-13c1-41a2-bfdd-d64ddd37637c']::uuid[])
    ON CONFLICT(id) DO UPDATE SET name=EXCLUDED.name, description=EXCLUDED.description, field_ids=EXCLUDED.field_ids;

INSERT INTO field_definitions
        (id, key, description, agg_func, agg_weights)
        VALUES ('3c18cf32-f868-4777-ba32-1edef5ca52ab', 'sum_normalized_reward', 'Primary scenario score (raw values): sum_normalized_reward', NULL, NULL)
        ON CONFLICT(id) DO UPDATE SET key=EXCLUDED.key, description=EXCLUDED.description, agg_func=EXCLUDED.agg_func, agg_weights=EXCLUDED.agg_weights;

INSERT INTO field_definitions
        (id, key, description, agg_func, agg_weights)
        VALUES ('c0618d61-13c1-41a2-bfdd-d64ddd37637c', 'success_rate', 'Secondary scenario score (raw values): success_rate', NULL, NULL)
        ON CONFLICT(id) DO UPDATE SET key=EXCLUDED.key, description=EXCLUDED.description, agg_func=EXCLUDED.agg_func, agg_weights=EXCLUDED.agg_weights;

INSERT INTO scenario_definitions
    (id, name, description, field_ids)
    VALUES ('74fd9eab-d2e5-4222-8656-81fc2dde7c21', 'Scenario 045 - Punctuality measures the percentage of trains arriving at their destinations on time (the train doesn’t arrive after planned arrival) and the train didn’t depart before planned departure time. The goal is to maintain a high level of reliability and minimize delays for passengers and freight services. ', 'This KPI contributes to evaluating Effectiveness of the AI-based assistant, as part of Task 4.1 evaluation objectives, and O2 main project objective:<br/>- Improve customer satisfaction by ensuring timely arrivals<br/>- Guarantee maximal planned connection<br/>- Minimize operational disruptions caused by delays<br/>- Meet regulatory and stakeholder benchmarks for punctuality<br/>This KPI is linked with project’s Long Term Expected Impacts (LTEI) (LTEI1)KPIS-3:<br/>- 10% increase in punctuality in long-range traffic<br/>- 5% increase in punctuality in regional traffic (with realistic disturbances)<br/>', array['987adb8c-2121-495e-9fb6-e478e770dfe8', '3d84a2bc-963f-4034-bf5d-5a5cdc187d0f']::uuid[])
    ON CONFLICT(id) DO UPDATE SET name=EXCLUDED.name, description=EXCLUDED.description, field_ids=EXCLUDED.field_ids;

INSERT INTO field_definitions
        (id, key, description, agg_func, agg_weights)
        VALUES ('987adb8c-2121-495e-9fb6-e478e770dfe8', 'sum_normalized_reward', 'Primary scenario score (raw values): sum_normalized_reward', NULL, NULL)
        ON CONFLICT(id) DO UPDATE SET key=EXCLUDED.key, description=EXCLUDED.description, agg_func=EXCLUDED.agg_func, agg_weights=EXCLUDED.agg_weights;

INSERT INTO field_definitions
        (id, key, description, agg_func, agg_weights)
        VALUES ('3d84a2bc-963f-4034-bf5d-5a5cdc187d0f', 'success_rate', 'Secondary scenario score (raw values): success_rate', NULL, NULL)
        ON CONFLICT(id) DO UPDATE SET key=EXCLUDED.key, description=EXCLUDED.description, agg_func=EXCLUDED.agg_func, agg_weights=EXCLUDED.agg_weights;

INSERT INTO scenario_definitions
    (id, name, description, field_ids)
    VALUES ('c16e54c1-33b2-45b8-95b0-33cc4f5400d5', 'Scenario 046 - Punctuality measures the percentage of trains arriving at their destinations on time (the train doesn’t arrive after planned arrival) and the train didn’t depart before planned departure time. The goal is to maintain a high level of reliability and minimize delays for passengers and freight services. ', 'This KPI contributes to evaluating Effectiveness of the AI-based assistant, as part of Task 4.1 evaluation objectives, and O2 main project objective:<br/>- Improve customer satisfaction by ensuring timely arrivals<br/>- Guarantee maximal planned connection<br/>- Minimize operational disruptions caused by delays<br/>- Meet regulatory and stakeholder benchmarks for punctuality<br/>This KPI is linked with project’s Long Term Expected Impacts (LTEI) (LTEI1)KPIS-3:<br/>- 10% increase in punctuality in long-range traffic<br/>- 5% increase in punctuality in regional traffic (with realistic disturbances)<br/>', array['d1e06eae-7a72-487e-8734-8a88956dbe5c', 'b4dd871a-b97c-417a-bd01-53e998622638']::uuid[])
    ON CONFLICT(id) DO UPDATE SET name=EXCLUDED.name, description=EXCLUDED.description, field_ids=EXCLUDED.field_ids;

INSERT INTO field_definitions
        (id, key, description, agg_func, agg_weights)
        VALUES ('d1e06eae-7a72-487e-8734-8a88956dbe5c', 'sum_normalized_reward', 'Primary scenario score (raw values): sum_normalized_reward', NULL, NULL)
        ON CONFLICT(id) DO UPDATE SET key=EXCLUDED.key, description=EXCLUDED.description, agg_func=EXCLUDED.agg_func, agg_weights=EXCLUDED.agg_weights;

INSERT INTO field_definitions
        (id, key, description, agg_func, agg_weights)
        VALUES ('b4dd871a-b97c-417a-bd01-53e998622638', 'success_rate', 'Secondary scenario score (raw values): success_rate', NULL, NULL)
        ON CONFLICT(id) DO UPDATE SET key=EXCLUDED.key, description=EXCLUDED.description, agg_func=EXCLUDED.agg_func, agg_weights=EXCLUDED.agg_weights;

INSERT INTO scenario_definitions
    (id, name, description, field_ids)
    VALUES ('c80effec-27b8-4103-b726-344a85f35407', 'Scenario 047 - Punctuality measures the percentage of trains arriving at their destinations on time (the train doesn’t arrive after planned arrival) and the train didn’t depart before planned departure time. The goal is to maintain a high level of reliability and minimize delays for passengers and freight services. ', 'This KPI contributes to evaluating Effectiveness of the AI-based assistant, as part of Task 4.1 evaluation objectives, and O2 main project objective:<br/>- Improve customer satisfaction by ensuring timely arrivals<br/>- Guarantee maximal planned connection<br/>- Minimize operational disruptions caused by delays<br/>- Meet regulatory and stakeholder benchmarks for punctuality<br/>This KPI is linked with project’s Long Term Expected Impacts (LTEI) (LTEI1)KPIS-3:<br/>- 10% increase in punctuality in long-range traffic<br/>- 5% increase in punctuality in regional traffic (with realistic disturbances)<br/>', array['32631a5c-824f-4adc-a8a3-57f23019a7b4', 'e74d8945-60ca-4bb8-b1d2-ac60857fcad1']::uuid[])
    ON CONFLICT(id) DO UPDATE SET name=EXCLUDED.name, description=EXCLUDED.description, field_ids=EXCLUDED.field_ids;

INSERT INTO field_definitions
        (id, key, description, agg_func, agg_weights)
        VALUES ('32631a5c-824f-4adc-a8a3-57f23019a7b4', 'sum_normalized_reward', 'Primary scenario score (raw values): sum_normalized_reward', NULL, NULL)
        ON CONFLICT(id) DO UPDATE SET key=EXCLUDED.key, description=EXCLUDED.description, agg_func=EXCLUDED.agg_func, agg_weights=EXCLUDED.agg_weights;

INSERT INTO field_definitions
        (id, key, description, agg_func, agg_weights)
        VALUES ('e74d8945-60ca-4bb8-b1d2-ac60857fcad1', 'success_rate', 'Secondary scenario score (raw values): success_rate', NULL, NULL)
        ON CONFLICT(id) DO UPDATE SET key=EXCLUDED.key, description=EXCLUDED.description, agg_func=EXCLUDED.agg_func, agg_weights=EXCLUDED.agg_weights;

INSERT INTO scenario_definitions
    (id, name, description, field_ids)
    VALUES ('9bec9335-3dd5-4d88-b2ac-c5d711bcab36', 'Scenario 048 - Punctuality measures the percentage of trains arriving at their destinations on time (the train doesn’t arrive after planned arrival) and the train didn’t depart before planned departure time. The goal is to maintain a high level of reliability and minimize delays for passengers and freight services. ', 'This KPI contributes to evaluating Effectiveness of the AI-based assistant, as part of Task 4.1 evaluation objectives, and O2 main project objective:<br/>- Improve customer satisfaction by ensuring timely arrivals<br/>- Guarantee maximal planned connection<br/>- Minimize operational disruptions caused by delays<br/>- Meet regulatory and stakeholder benchmarks for punctuality<br/>This KPI is linked with project’s Long Term Expected Impacts (LTEI) (LTEI1)KPIS-3:<br/>- 10% increase in punctuality in long-range traffic<br/>- 5% increase in punctuality in regional traffic (with realistic disturbances)<br/>', array['d679aac1-453c-47b5-bfd2-d70fbe6ed60d', '92a6e80d-9d64-4dce-8352-a857280ce42d']::uuid[])
    ON CONFLICT(id) DO UPDATE SET name=EXCLUDED.name, description=EXCLUDED.description, field_ids=EXCLUDED.field_ids;

INSERT INTO field_definitions
        (id, key, description, agg_func, agg_weights)
        VALUES ('d679aac1-453c-47b5-bfd2-d70fbe6ed60d', 'sum_normalized_reward', 'Primary scenario score (raw values): sum_normalized_reward', NULL, NULL)
        ON CONFLICT(id) DO UPDATE SET key=EXCLUDED.key, description=EXCLUDED.description, agg_func=EXCLUDED.agg_func, agg_weights=EXCLUDED.agg_weights;

INSERT INTO field_definitions
        (id, key, description, agg_func, agg_weights)
        VALUES ('92a6e80d-9d64-4dce-8352-a857280ce42d', 'success_rate', 'Secondary scenario score (raw values): success_rate', NULL, NULL)
        ON CONFLICT(id) DO UPDATE SET key=EXCLUDED.key, description=EXCLUDED.description, agg_func=EXCLUDED.agg_func, agg_weights=EXCLUDED.agg_weights;

INSERT INTO scenario_definitions
    (id, name, description, field_ids)
    VALUES ('4a067d3c-75e6-4e91-a42d-cdf291016674', 'Scenario 049 - Punctuality measures the percentage of trains arriving at their destinations on time (the train doesn’t arrive after planned arrival) and the train didn’t depart before planned departure time. The goal is to maintain a high level of reliability and minimize delays for passengers and freight services. ', 'This KPI contributes to evaluating Effectiveness of the AI-based assistant, as part of Task 4.1 evaluation objectives, and O2 main project objective:<br/>- Improve customer satisfaction by ensuring timely arrivals<br/>- Guarantee maximal planned connection<br/>- Minimize operational disruptions caused by delays<br/>- Meet regulatory and stakeholder benchmarks for punctuality<br/>This KPI is linked with project’s Long Term Expected Impacts (LTEI) (LTEI1)KPIS-3:<br/>- 10% increase in punctuality in long-range traffic<br/>- 5% increase in punctuality in regional traffic (with realistic disturbances)<br/>', array['8f4ed654-e525-430a-be79-7ade82ef09fd', 'af5b8f78-be09-4c13-a9cb-25ed84ca819c']::uuid[])
    ON CONFLICT(id) DO UPDATE SET name=EXCLUDED.name, description=EXCLUDED.description, field_ids=EXCLUDED.field_ids;

INSERT INTO field_definitions
        (id, key, description, agg_func, agg_weights)
        VALUES ('8f4ed654-e525-430a-be79-7ade82ef09fd', 'sum_normalized_reward', 'Primary scenario score (raw values): sum_normalized_reward', NULL, NULL)
        ON CONFLICT(id) DO UPDATE SET key=EXCLUDED.key, description=EXCLUDED.description, agg_func=EXCLUDED.agg_func, agg_weights=EXCLUDED.agg_weights;

INSERT INTO field_definitions
        (id, key, description, agg_func, agg_weights)
        VALUES ('af5b8f78-be09-4c13-a9cb-25ed84ca819c', 'success_rate', 'Secondary scenario score (raw values): success_rate', NULL, NULL)
        ON CONFLICT(id) DO UPDATE SET key=EXCLUDED.key, description=EXCLUDED.description, agg_func=EXCLUDED.agg_func, agg_weights=EXCLUDED.agg_weights;

INSERT INTO scenario_definitions
    (id, name, description, field_ids)
    VALUES ('1f6c674b-fdb5-40c8-bbe3-d924c2b7146e', 'Scenario 050 - Punctuality measures the percentage of trains arriving at their destinations on time (the train doesn’t arrive after planned arrival) and the train didn’t depart before planned departure time. The goal is to maintain a high level of reliability and minimize delays for passengers and freight services. ', 'This KPI contributes to evaluating Effectiveness of the AI-based assistant, as part of Task 4.1 evaluation objectives, and O2 main project objective:<br/>- Improve customer satisfaction by ensuring timely arrivals<br/>- Guarantee maximal planned connection<br/>- Minimize operational disruptions caused by delays<br/>- Meet regulatory and stakeholder benchmarks for punctuality<br/>This KPI is linked with project’s Long Term Expected Impacts (LTEI) (LTEI1)KPIS-3:<br/>- 10% increase in punctuality in long-range traffic<br/>- 5% increase in punctuality in regional traffic (with realistic disturbances)<br/>', array['7f80b003-1758-44cd-a894-8cafdace7b17', '14482ada-9a30-4857-a2db-003968c8a57c']::uuid[])
    ON CONFLICT(id) DO UPDATE SET name=EXCLUDED.name, description=EXCLUDED.description, field_ids=EXCLUDED.field_ids;

INSERT INTO field_definitions
        (id, key, description, agg_func, agg_weights)
        VALUES ('7f80b003-1758-44cd-a894-8cafdace7b17', 'sum_normalized_reward', 'Primary scenario score (raw values): sum_normalized_reward', NULL, NULL)
        ON CONFLICT(id) DO UPDATE SET key=EXCLUDED.key, description=EXCLUDED.description, agg_func=EXCLUDED.agg_func, agg_weights=EXCLUDED.agg_weights;

INSERT INTO field_definitions
        (id, key, description, agg_func, agg_weights)
        VALUES ('14482ada-9a30-4857-a2db-003968c8a57c', 'success_rate', 'Secondary scenario score (raw values): success_rate', NULL, NULL)
        ON CONFLICT(id) DO UPDATE SET key=EXCLUDED.key, description=EXCLUDED.description, agg_func=EXCLUDED.agg_func, agg_weights=EXCLUDED.agg_weights;

INSERT INTO scenario_definitions
    (id, name, description, field_ids)
    VALUES ('8bd15e2f-6089-4022-8383-26a36093dc80', 'Scenario 051 - Punctuality measures the percentage of trains arriving at their destinations on time (the train doesn’t arrive after planned arrival) and the train didn’t depart before planned departure time. The goal is to maintain a high level of reliability and minimize delays for passengers and freight services. ', 'This KPI contributes to evaluating Effectiveness of the AI-based assistant, as part of Task 4.1 evaluation objectives, and O2 main project objective:<br/>- Improve customer satisfaction by ensuring timely arrivals<br/>- Guarantee maximal planned connection<br/>- Minimize operational disruptions caused by delays<br/>- Meet regulatory and stakeholder benchmarks for punctuality<br/>This KPI is linked with project’s Long Term Expected Impacts (LTEI) (LTEI1)KPIS-3:<br/>- 10% increase in punctuality in long-range traffic<br/>- 5% increase in punctuality in regional traffic (with realistic disturbances)<br/>', array['b24d7c51-d119-40ac-abe5-002f50d83a5b', '9c06b3df-40bf-4489-95e6-e4d296688bf2']::uuid[])
    ON CONFLICT(id) DO UPDATE SET name=EXCLUDED.name, description=EXCLUDED.description, field_ids=EXCLUDED.field_ids;

INSERT INTO field_definitions
        (id, key, description, agg_func, agg_weights)
        VALUES ('b24d7c51-d119-40ac-abe5-002f50d83a5b', 'sum_normalized_reward', 'Primary scenario score (raw values): sum_normalized_reward', NULL, NULL)
        ON CONFLICT(id) DO UPDATE SET key=EXCLUDED.key, description=EXCLUDED.description, agg_func=EXCLUDED.agg_func, agg_weights=EXCLUDED.agg_weights;

INSERT INTO field_definitions
        (id, key, description, agg_func, agg_weights)
        VALUES ('9c06b3df-40bf-4489-95e6-e4d296688bf2', 'success_rate', 'Secondary scenario score (raw values): success_rate', NULL, NULL)
        ON CONFLICT(id) DO UPDATE SET key=EXCLUDED.key, description=EXCLUDED.description, agg_func=EXCLUDED.agg_func, agg_weights=EXCLUDED.agg_weights;

INSERT INTO scenario_definitions
    (id, name, description, field_ids)
    VALUES ('5b026a8a-e0dc-47d2-b2ce-d0bfc083e6c5', 'Scenario 052 - Punctuality measures the percentage of trains arriving at their destinations on time (the train doesn’t arrive after planned arrival) and the train didn’t depart before planned departure time. The goal is to maintain a high level of reliability and minimize delays for passengers and freight services. ', 'This KPI contributes to evaluating Effectiveness of the AI-based assistant, as part of Task 4.1 evaluation objectives, and O2 main project objective:<br/>- Improve customer satisfaction by ensuring timely arrivals<br/>- Guarantee maximal planned connection<br/>- Minimize operational disruptions caused by delays<br/>- Meet regulatory and stakeholder benchmarks for punctuality<br/>This KPI is linked with project’s Long Term Expected Impacts (LTEI) (LTEI1)KPIS-3:<br/>- 10% increase in punctuality in long-range traffic<br/>- 5% increase in punctuality in regional traffic (with realistic disturbances)<br/>', array['37f7837f-0f94-4d73-9fec-a1eaa2bdb731', '4c8c8b55-c550-410d-883f-20bd22bced94']::uuid[])
    ON CONFLICT(id) DO UPDATE SET name=EXCLUDED.name, description=EXCLUDED.description, field_ids=EXCLUDED.field_ids;

INSERT INTO field_definitions
        (id, key, description, agg_func, agg_weights)
        VALUES ('37f7837f-0f94-4d73-9fec-a1eaa2bdb731', 'sum_normalized_reward', 'Primary scenario score (raw values): sum_normalized_reward', NULL, NULL)
        ON CONFLICT(id) DO UPDATE SET key=EXCLUDED.key, description=EXCLUDED.description, agg_func=EXCLUDED.agg_func, agg_weights=EXCLUDED.agg_weights;

INSERT INTO field_definitions
        (id, key, description, agg_func, agg_weights)
        VALUES ('4c8c8b55-c550-410d-883f-20bd22bced94', 'success_rate', 'Secondary scenario score (raw values): success_rate', NULL, NULL)
        ON CONFLICT(id) DO UPDATE SET key=EXCLUDED.key, description=EXCLUDED.description, agg_func=EXCLUDED.agg_func, agg_weights=EXCLUDED.agg_weights;

INSERT INTO scenario_definitions
    (id, name, description, field_ids)
    VALUES ('ab2e2bba-baa0-45de-b639-c7ebf29bf947', 'Scenario 053 - Punctuality measures the percentage of trains arriving at their destinations on time (the train doesn’t arrive after planned arrival) and the train didn’t depart before planned departure time. The goal is to maintain a high level of reliability and minimize delays for passengers and freight services. ', 'This KPI contributes to evaluating Effectiveness of the AI-based assistant, as part of Task 4.1 evaluation objectives, and O2 main project objective:<br/>- Improve customer satisfaction by ensuring timely arrivals<br/>- Guarantee maximal planned connection<br/>- Minimize operational disruptions caused by delays<br/>- Meet regulatory and stakeholder benchmarks for punctuality<br/>This KPI is linked with project’s Long Term Expected Impacts (LTEI) (LTEI1)KPIS-3:<br/>- 10% increase in punctuality in long-range traffic<br/>- 5% increase in punctuality in regional traffic (with realistic disturbances)<br/>', array['211a770e-d3fe-4631-9005-9de97f51e373', '51187b86-7215-4195-b125-de5d170bb3a1']::uuid[])
    ON CONFLICT(id) DO UPDATE SET name=EXCLUDED.name, description=EXCLUDED.description, field_ids=EXCLUDED.field_ids;

INSERT INTO field_definitions
        (id, key, description, agg_func, agg_weights)
        VALUES ('211a770e-d3fe-4631-9005-9de97f51e373', 'sum_normalized_reward', 'Primary scenario score (raw values): sum_normalized_reward', NULL, NULL)
        ON CONFLICT(id) DO UPDATE SET key=EXCLUDED.key, description=EXCLUDED.description, agg_func=EXCLUDED.agg_func, agg_weights=EXCLUDED.agg_weights;

INSERT INTO field_definitions
        (id, key, description, agg_func, agg_weights)
        VALUES ('51187b86-7215-4195-b125-de5d170bb3a1', 'success_rate', 'Secondary scenario score (raw values): success_rate', NULL, NULL)
        ON CONFLICT(id) DO UPDATE SET key=EXCLUDED.key, description=EXCLUDED.description, agg_func=EXCLUDED.agg_func, agg_weights=EXCLUDED.agg_weights;

INSERT INTO scenario_definitions
    (id, name, description, field_ids)
    VALUES ('8f8b6f67-d3c3-41ec-b60d-2924577e68f4', 'Scenario 054 - Punctuality measures the percentage of trains arriving at their destinations on time (the train doesn’t arrive after planned arrival) and the train didn’t depart before planned departure time. The goal is to maintain a high level of reliability and minimize delays for passengers and freight services. ', 'This KPI contributes to evaluating Effectiveness of the AI-based assistant, as part of Task 4.1 evaluation objectives, and O2 main project objective:<br/>- Improve customer satisfaction by ensuring timely arrivals<br/>- Guarantee maximal planned connection<br/>- Minimize operational disruptions caused by delays<br/>- Meet regulatory and stakeholder benchmarks for punctuality<br/>This KPI is linked with project’s Long Term Expected Impacts (LTEI) (LTEI1)KPIS-3:<br/>- 10% increase in punctuality in long-range traffic<br/>- 5% increase in punctuality in regional traffic (with realistic disturbances)<br/>', array['400a12a8-2884-4e8c-b62a-d051a100e30f', '04a84ce1-a102-49cf-9f20-abc9167d55ba']::uuid[])
    ON CONFLICT(id) DO UPDATE SET name=EXCLUDED.name, description=EXCLUDED.description, field_ids=EXCLUDED.field_ids;

INSERT INTO field_definitions
        (id, key, description, agg_func, agg_weights)
        VALUES ('400a12a8-2884-4e8c-b62a-d051a100e30f', 'sum_normalized_reward', 'Primary scenario score (raw values): sum_normalized_reward', NULL, NULL)
        ON CONFLICT(id) DO UPDATE SET key=EXCLUDED.key, description=EXCLUDED.description, agg_func=EXCLUDED.agg_func, agg_weights=EXCLUDED.agg_weights;

INSERT INTO field_definitions
        (id, key, description, agg_func, agg_weights)
        VALUES ('04a84ce1-a102-49cf-9f20-abc9167d55ba', 'success_rate', 'Secondary scenario score (raw values): success_rate', NULL, NULL)
        ON CONFLICT(id) DO UPDATE SET key=EXCLUDED.key, description=EXCLUDED.description, agg_func=EXCLUDED.agg_func, agg_weights=EXCLUDED.agg_weights;

INSERT INTO scenario_definitions
    (id, name, description, field_ids)
    VALUES ('3e59642a-7b20-4989-b9e6-01a35a82b9da', 'Scenario 055 - Punctuality measures the percentage of trains arriving at their destinations on time (the train doesn’t arrive after planned arrival) and the train didn’t depart before planned departure time. The goal is to maintain a high level of reliability and minimize delays for passengers and freight services. ', 'This KPI contributes to evaluating Effectiveness of the AI-based assistant, as part of Task 4.1 evaluation objectives, and O2 main project objective:<br/>- Improve customer satisfaction by ensuring timely arrivals<br/>- Guarantee maximal planned connection<br/>- Minimize operational disruptions caused by delays<br/>- Meet regulatory and stakeholder benchmarks for punctuality<br/>This KPI is linked with project’s Long Term Expected Impacts (LTEI) (LTEI1)KPIS-3:<br/>- 10% increase in punctuality in long-range traffic<br/>- 5% increase in punctuality in regional traffic (with realistic disturbances)<br/>', array['aa69cbde-947a-414c-90da-3b45e0fb596b', '1acfb16a-d114-4800-8a1a-03009eaa01ea']::uuid[])
    ON CONFLICT(id) DO UPDATE SET name=EXCLUDED.name, description=EXCLUDED.description, field_ids=EXCLUDED.field_ids;

INSERT INTO field_definitions
        (id, key, description, agg_func, agg_weights)
        VALUES ('aa69cbde-947a-414c-90da-3b45e0fb596b', 'sum_normalized_reward', 'Primary scenario score (raw values): sum_normalized_reward', NULL, NULL)
        ON CONFLICT(id) DO UPDATE SET key=EXCLUDED.key, description=EXCLUDED.description, agg_func=EXCLUDED.agg_func, agg_weights=EXCLUDED.agg_weights;

INSERT INTO field_definitions
        (id, key, description, agg_func, agg_weights)
        VALUES ('1acfb16a-d114-4800-8a1a-03009eaa01ea', 'success_rate', 'Secondary scenario score (raw values): success_rate', NULL, NULL)
        ON CONFLICT(id) DO UPDATE SET key=EXCLUDED.key, description=EXCLUDED.description, agg_func=EXCLUDED.agg_func, agg_weights=EXCLUDED.agg_weights;

INSERT INTO scenario_definitions
    (id, name, description, field_ids)
    VALUES ('0e4618c7-7ab7-4323-855c-7f95cbaef2d0', 'Scenario 056 - Punctuality measures the percentage of trains arriving at their destinations on time (the train doesn’t arrive after planned arrival) and the train didn’t depart before planned departure time. The goal is to maintain a high level of reliability and minimize delays for passengers and freight services. ', 'This KPI contributes to evaluating Effectiveness of the AI-based assistant, as part of Task 4.1 evaluation objectives, and O2 main project objective:<br/>- Improve customer satisfaction by ensuring timely arrivals<br/>- Guarantee maximal planned connection<br/>- Minimize operational disruptions caused by delays<br/>- Meet regulatory and stakeholder benchmarks for punctuality<br/>This KPI is linked with project’s Long Term Expected Impacts (LTEI) (LTEI1)KPIS-3:<br/>- 10% increase in punctuality in long-range traffic<br/>- 5% increase in punctuality in regional traffic (with realistic disturbances)<br/>', array['5bf88d2b-eae0-464c-8f94-413b9d25b17f', 'c868d354-61ee-4604-a95c-27f9f72163f2']::uuid[])
    ON CONFLICT(id) DO UPDATE SET name=EXCLUDED.name, description=EXCLUDED.description, field_ids=EXCLUDED.field_ids;

INSERT INTO field_definitions
        (id, key, description, agg_func, agg_weights)
        VALUES ('5bf88d2b-eae0-464c-8f94-413b9d25b17f', 'sum_normalized_reward', 'Primary scenario score (raw values): sum_normalized_reward', NULL, NULL)
        ON CONFLICT(id) DO UPDATE SET key=EXCLUDED.key, description=EXCLUDED.description, agg_func=EXCLUDED.agg_func, agg_weights=EXCLUDED.agg_weights;

INSERT INTO field_definitions
        (id, key, description, agg_func, agg_weights)
        VALUES ('c868d354-61ee-4604-a95c-27f9f72163f2', 'success_rate', 'Secondary scenario score (raw values): success_rate', NULL, NULL)
        ON CONFLICT(id) DO UPDATE SET key=EXCLUDED.key, description=EXCLUDED.description, agg_func=EXCLUDED.agg_func, agg_weights=EXCLUDED.agg_weights;

INSERT INTO scenario_definitions
    (id, name, description, field_ids)
    VALUES ('4a59929b-b391-464f-bfa1-628f7a45ac36', 'Scenario 057 - Punctuality measures the percentage of trains arriving at their destinations on time (the train doesn’t arrive after planned arrival) and the train didn’t depart before planned departure time. The goal is to maintain a high level of reliability and minimize delays for passengers and freight services. ', 'This KPI contributes to evaluating Effectiveness of the AI-based assistant, as part of Task 4.1 evaluation objectives, and O2 main project objective:<br/>- Improve customer satisfaction by ensuring timely arrivals<br/>- Guarantee maximal planned connection<br/>- Minimize operational disruptions caused by delays<br/>- Meet regulatory and stakeholder benchmarks for punctuality<br/>This KPI is linked with project’s Long Term Expected Impacts (LTEI) (LTEI1)KPIS-3:<br/>- 10% increase in punctuality in long-range traffic<br/>- 5% increase in punctuality in regional traffic (with realistic disturbances)<br/>', array['b48c47af-49e2-4224-8104-16301ac09b82', '6529a3ec-aaf5-4484-b998-b26632252fa2']::uuid[])
    ON CONFLICT(id) DO UPDATE SET name=EXCLUDED.name, description=EXCLUDED.description, field_ids=EXCLUDED.field_ids;

INSERT INTO field_definitions
        (id, key, description, agg_func, agg_weights)
        VALUES ('b48c47af-49e2-4224-8104-16301ac09b82', 'sum_normalized_reward', 'Primary scenario score (raw values): sum_normalized_reward', NULL, NULL)
        ON CONFLICT(id) DO UPDATE SET key=EXCLUDED.key, description=EXCLUDED.description, agg_func=EXCLUDED.agg_func, agg_weights=EXCLUDED.agg_weights;

INSERT INTO field_definitions
        (id, key, description, agg_func, agg_weights)
        VALUES ('6529a3ec-aaf5-4484-b998-b26632252fa2', 'success_rate', 'Secondary scenario score (raw values): success_rate', NULL, NULL)
        ON CONFLICT(id) DO UPDATE SET key=EXCLUDED.key, description=EXCLUDED.description, agg_func=EXCLUDED.agg_func, agg_weights=EXCLUDED.agg_weights;

INSERT INTO scenario_definitions
    (id, name, description, field_ids)
    VALUES ('27f8ac34-3d09-4b68-9fb4-c51cfbfd09df', 'Scenario 058 - Punctuality measures the percentage of trains arriving at their destinations on time (the train doesn’t arrive after planned arrival) and the train didn’t depart before planned departure time. The goal is to maintain a high level of reliability and minimize delays for passengers and freight services. ', 'This KPI contributes to evaluating Effectiveness of the AI-based assistant, as part of Task 4.1 evaluation objectives, and O2 main project objective:<br/>- Improve customer satisfaction by ensuring timely arrivals<br/>- Guarantee maximal planned connection<br/>- Minimize operational disruptions caused by delays<br/>- Meet regulatory and stakeholder benchmarks for punctuality<br/>This KPI is linked with project’s Long Term Expected Impacts (LTEI) (LTEI1)KPIS-3:<br/>- 10% increase in punctuality in long-range traffic<br/>- 5% increase in punctuality in regional traffic (with realistic disturbances)<br/>', array['073cd85e-d4b0-450a-af4f-82942568a8c2', '06168613-30f9-41b0-8ed1-45ac4af5db21']::uuid[])
    ON CONFLICT(id) DO UPDATE SET name=EXCLUDED.name, description=EXCLUDED.description, field_ids=EXCLUDED.field_ids;

INSERT INTO field_definitions
        (id, key, description, agg_func, agg_weights)
        VALUES ('073cd85e-d4b0-450a-af4f-82942568a8c2', 'sum_normalized_reward', 'Primary scenario score (raw values): sum_normalized_reward', NULL, NULL)
        ON CONFLICT(id) DO UPDATE SET key=EXCLUDED.key, description=EXCLUDED.description, agg_func=EXCLUDED.agg_func, agg_weights=EXCLUDED.agg_weights;

INSERT INTO field_definitions
        (id, key, description, agg_func, agg_weights)
        VALUES ('06168613-30f9-41b0-8ed1-45ac4af5db21', 'success_rate', 'Secondary scenario score (raw values): success_rate', NULL, NULL)
        ON CONFLICT(id) DO UPDATE SET key=EXCLUDED.key, description=EXCLUDED.description, agg_func=EXCLUDED.agg_func, agg_weights=EXCLUDED.agg_weights;

INSERT INTO scenario_definitions
    (id, name, description, field_ids)
    VALUES ('bacb4c11-11b4-4c76-910d-f92abc5b7a39', 'Scenario 059 - Punctuality measures the percentage of trains arriving at their destinations on time (the train doesn’t arrive after planned arrival) and the train didn’t depart before planned departure time. The goal is to maintain a high level of reliability and minimize delays for passengers and freight services. ', 'This KPI contributes to evaluating Effectiveness of the AI-based assistant, as part of Task 4.1 evaluation objectives, and O2 main project objective:<br/>- Improve customer satisfaction by ensuring timely arrivals<br/>- Guarantee maximal planned connection<br/>- Minimize operational disruptions caused by delays<br/>- Meet regulatory and stakeholder benchmarks for punctuality<br/>This KPI is linked with project’s Long Term Expected Impacts (LTEI) (LTEI1)KPIS-3:<br/>- 10% increase in punctuality in long-range traffic<br/>- 5% increase in punctuality in regional traffic (with realistic disturbances)<br/>', array['8b4da62c-a1d5-429a-af67-9f82cab18e9f', '7c901056-66e1-4f24-b290-ff0b651b1abb']::uuid[])
    ON CONFLICT(id) DO UPDATE SET name=EXCLUDED.name, description=EXCLUDED.description, field_ids=EXCLUDED.field_ids;

INSERT INTO field_definitions
        (id, key, description, agg_func, agg_weights)
        VALUES ('8b4da62c-a1d5-429a-af67-9f82cab18e9f', 'sum_normalized_reward', 'Primary scenario score (raw values): sum_normalized_reward', NULL, NULL)
        ON CONFLICT(id) DO UPDATE SET key=EXCLUDED.key, description=EXCLUDED.description, agg_func=EXCLUDED.agg_func, agg_weights=EXCLUDED.agg_weights;

INSERT INTO field_definitions
        (id, key, description, agg_func, agg_weights)
        VALUES ('7c901056-66e1-4f24-b290-ff0b651b1abb', 'success_rate', 'Secondary scenario score (raw values): success_rate', NULL, NULL)
        ON CONFLICT(id) DO UPDATE SET key=EXCLUDED.key, description=EXCLUDED.description, agg_func=EXCLUDED.agg_func, agg_weights=EXCLUDED.agg_weights;

INSERT INTO scenario_definitions
    (id, name, description, field_ids)
    VALUES ('a5dff3c8-902e-4cb9-8466-d277d0ed4d67', 'Scenario 060 - Punctuality measures the percentage of trains arriving at their destinations on time (the train doesn’t arrive after planned arrival) and the train didn’t depart before planned departure time. The goal is to maintain a high level of reliability and minimize delays for passengers and freight services. ', 'This KPI contributes to evaluating Effectiveness of the AI-based assistant, as part of Task 4.1 evaluation objectives, and O2 main project objective:<br/>- Improve customer satisfaction by ensuring timely arrivals<br/>- Guarantee maximal planned connection<br/>- Minimize operational disruptions caused by delays<br/>- Meet regulatory and stakeholder benchmarks for punctuality<br/>This KPI is linked with project’s Long Term Expected Impacts (LTEI) (LTEI1)KPIS-3:<br/>- 10% increase in punctuality in long-range traffic<br/>- 5% increase in punctuality in regional traffic (with realistic disturbances)<br/>', array['00b8aacc-fde9-4f90-996d-76ff04db92c0', '18add694-5992-4211-9cdd-0a266b997073']::uuid[])
    ON CONFLICT(id) DO UPDATE SET name=EXCLUDED.name, description=EXCLUDED.description, field_ids=EXCLUDED.field_ids;

INSERT INTO field_definitions
        (id, key, description, agg_func, agg_weights)
        VALUES ('00b8aacc-fde9-4f90-996d-76ff04db92c0', 'sum_normalized_reward', 'Primary scenario score (raw values): sum_normalized_reward', NULL, NULL)
        ON CONFLICT(id) DO UPDATE SET key=EXCLUDED.key, description=EXCLUDED.description, agg_func=EXCLUDED.agg_func, agg_weights=EXCLUDED.agg_weights;

INSERT INTO field_definitions
        (id, key, description, agg_func, agg_weights)
        VALUES ('18add694-5992-4211-9cdd-0a266b997073', 'success_rate', 'Secondary scenario score (raw values): success_rate', NULL, NULL)
        ON CONFLICT(id) DO UPDATE SET key=EXCLUDED.key, description=EXCLUDED.description, agg_func=EXCLUDED.agg_func, agg_weights=EXCLUDED.agg_weights;

INSERT INTO scenario_definitions
    (id, name, description, field_ids)
    VALUES ('aca25feb-6254-40b3-8d40-3c805797c69b', 'Scenario 061 - Punctuality measures the percentage of trains arriving at their destinations on time (the train doesn’t arrive after planned arrival) and the train didn’t depart before planned departure time. The goal is to maintain a high level of reliability and minimize delays for passengers and freight services. ', 'This KPI contributes to evaluating Effectiveness of the AI-based assistant, as part of Task 4.1 evaluation objectives, and O2 main project objective:<br/>- Improve customer satisfaction by ensuring timely arrivals<br/>- Guarantee maximal planned connection<br/>- Minimize operational disruptions caused by delays<br/>- Meet regulatory and stakeholder benchmarks for punctuality<br/>This KPI is linked with project’s Long Term Expected Impacts (LTEI) (LTEI1)KPIS-3:<br/>- 10% increase in punctuality in long-range traffic<br/>- 5% increase in punctuality in regional traffic (with realistic disturbances)<br/>', array['77f74e7b-fe38-4b17-8c0b-031288fe3e72', 'f0a5bd0a-d2d6-4b12-b657-68e46310e433']::uuid[])
    ON CONFLICT(id) DO UPDATE SET name=EXCLUDED.name, description=EXCLUDED.description, field_ids=EXCLUDED.field_ids;

INSERT INTO field_definitions
        (id, key, description, agg_func, agg_weights)
        VALUES ('77f74e7b-fe38-4b17-8c0b-031288fe3e72', 'sum_normalized_reward', 'Primary scenario score (raw values): sum_normalized_reward', NULL, NULL)
        ON CONFLICT(id) DO UPDATE SET key=EXCLUDED.key, description=EXCLUDED.description, agg_func=EXCLUDED.agg_func, agg_weights=EXCLUDED.agg_weights;

INSERT INTO field_definitions
        (id, key, description, agg_func, agg_weights)
        VALUES ('f0a5bd0a-d2d6-4b12-b657-68e46310e433', 'success_rate', 'Secondary scenario score (raw values): success_rate', NULL, NULL)
        ON CONFLICT(id) DO UPDATE SET key=EXCLUDED.key, description=EXCLUDED.description, agg_func=EXCLUDED.agg_func, agg_weights=EXCLUDED.agg_weights;

INSERT INTO scenario_definitions
    (id, name, description, field_ids)
    VALUES ('deb21442-0f94-4ff3-b78d-8d418415d646', 'Scenario 062 - Punctuality measures the percentage of trains arriving at their destinations on time (the train doesn’t arrive after planned arrival) and the train didn’t depart before planned departure time. The goal is to maintain a high level of reliability and minimize delays for passengers and freight services. ', 'This KPI contributes to evaluating Effectiveness of the AI-based assistant, as part of Task 4.1 evaluation objectives, and O2 main project objective:<br/>- Improve customer satisfaction by ensuring timely arrivals<br/>- Guarantee maximal planned connection<br/>- Minimize operational disruptions caused by delays<br/>- Meet regulatory and stakeholder benchmarks for punctuality<br/>This KPI is linked with project’s Long Term Expected Impacts (LTEI) (LTEI1)KPIS-3:<br/>- 10% increase in punctuality in long-range traffic<br/>- 5% increase in punctuality in regional traffic (with realistic disturbances)<br/>', array['0171b423-8f3a-4021-af1b-80cb1b6bb64d', '1cef0986-13e2-4fc7-82c3-a04d3b506802']::uuid[])
    ON CONFLICT(id) DO UPDATE SET name=EXCLUDED.name, description=EXCLUDED.description, field_ids=EXCLUDED.field_ids;

INSERT INTO field_definitions
        (id, key, description, agg_func, agg_weights)
        VALUES ('0171b423-8f3a-4021-af1b-80cb1b6bb64d', 'sum_normalized_reward', 'Primary scenario score (raw values): sum_normalized_reward', NULL, NULL)
        ON CONFLICT(id) DO UPDATE SET key=EXCLUDED.key, description=EXCLUDED.description, agg_func=EXCLUDED.agg_func, agg_weights=EXCLUDED.agg_weights;

INSERT INTO field_definitions
        (id, key, description, agg_func, agg_weights)
        VALUES ('1cef0986-13e2-4fc7-82c3-a04d3b506802', 'success_rate', 'Secondary scenario score (raw values): success_rate', NULL, NULL)
        ON CONFLICT(id) DO UPDATE SET key=EXCLUDED.key, description=EXCLUDED.description, agg_func=EXCLUDED.agg_func, agg_weights=EXCLUDED.agg_weights;

INSERT INTO scenario_definitions
    (id, name, description, field_ids)
    VALUES ('6cf2cc89-d30e-4063-bced-051f3cdae92f', 'Scenario 063 - Punctuality measures the percentage of trains arriving at their destinations on time (the train doesn’t arrive after planned arrival) and the train didn’t depart before planned departure time. The goal is to maintain a high level of reliability and minimize delays for passengers and freight services. ', 'This KPI contributes to evaluating Effectiveness of the AI-based assistant, as part of Task 4.1 evaluation objectives, and O2 main project objective:<br/>- Improve customer satisfaction by ensuring timely arrivals<br/>- Guarantee maximal planned connection<br/>- Minimize operational disruptions caused by delays<br/>- Meet regulatory and stakeholder benchmarks for punctuality<br/>This KPI is linked with project’s Long Term Expected Impacts (LTEI) (LTEI1)KPIS-3:<br/>- 10% increase in punctuality in long-range traffic<br/>- 5% increase in punctuality in regional traffic (with realistic disturbances)<br/>', array['7c4d516d-7c3b-432f-8b15-b801b93d8a47', '399c2730-f645-4bcf-b828-6ced81fdeef8']::uuid[])
    ON CONFLICT(id) DO UPDATE SET name=EXCLUDED.name, description=EXCLUDED.description, field_ids=EXCLUDED.field_ids;

INSERT INTO field_definitions
        (id, key, description, agg_func, agg_weights)
        VALUES ('7c4d516d-7c3b-432f-8b15-b801b93d8a47', 'sum_normalized_reward', 'Primary scenario score (raw values): sum_normalized_reward', NULL, NULL)
        ON CONFLICT(id) DO UPDATE SET key=EXCLUDED.key, description=EXCLUDED.description, agg_func=EXCLUDED.agg_func, agg_weights=EXCLUDED.agg_weights;

INSERT INTO field_definitions
        (id, key, description, agg_func, agg_weights)
        VALUES ('399c2730-f645-4bcf-b828-6ced81fdeef8', 'success_rate', 'Secondary scenario score (raw values): success_rate', NULL, NULL)
        ON CONFLICT(id) DO UPDATE SET key=EXCLUDED.key, description=EXCLUDED.description, agg_func=EXCLUDED.agg_func, agg_weights=EXCLUDED.agg_weights;

INSERT INTO scenario_definitions
    (id, name, description, field_ids)
    VALUES ('84bcbff5-346f-452c-87ab-08ceff6364f2', 'Scenario 064 - Punctuality measures the percentage of trains arriving at their destinations on time (the train doesn’t arrive after planned arrival) and the train didn’t depart before planned departure time. The goal is to maintain a high level of reliability and minimize delays for passengers and freight services. ', 'This KPI contributes to evaluating Effectiveness of the AI-based assistant, as part of Task 4.1 evaluation objectives, and O2 main project objective:<br/>- Improve customer satisfaction by ensuring timely arrivals<br/>- Guarantee maximal planned connection<br/>- Minimize operational disruptions caused by delays<br/>- Meet regulatory and stakeholder benchmarks for punctuality<br/>This KPI is linked with project’s Long Term Expected Impacts (LTEI) (LTEI1)KPIS-3:<br/>- 10% increase in punctuality in long-range traffic<br/>- 5% increase in punctuality in regional traffic (with realistic disturbances)<br/>', array['f3848bdc-7c50-46aa-8aa9-d88dfc084a1b', 'd7faf305-6d32-4b20-b83b-ef80945c50ef']::uuid[])
    ON CONFLICT(id) DO UPDATE SET name=EXCLUDED.name, description=EXCLUDED.description, field_ids=EXCLUDED.field_ids;

INSERT INTO field_definitions
        (id, key, description, agg_func, agg_weights)
        VALUES ('f3848bdc-7c50-46aa-8aa9-d88dfc084a1b', 'sum_normalized_reward', 'Primary scenario score (raw values): sum_normalized_reward', NULL, NULL)
        ON CONFLICT(id) DO UPDATE SET key=EXCLUDED.key, description=EXCLUDED.description, agg_func=EXCLUDED.agg_func, agg_weights=EXCLUDED.agg_weights;

INSERT INTO field_definitions
        (id, key, description, agg_func, agg_weights)
        VALUES ('d7faf305-6d32-4b20-b83b-ef80945c50ef', 'success_rate', 'Secondary scenario score (raw values): success_rate', NULL, NULL)
        ON CONFLICT(id) DO UPDATE SET key=EXCLUDED.key, description=EXCLUDED.description, agg_func=EXCLUDED.agg_func, agg_weights=EXCLUDED.agg_weights;

INSERT INTO scenario_definitions
    (id, name, description, field_ids)
    VALUES ('9acbe68e-2a45-420b-a142-34996dbcfb83', 'Scenario 065 - Punctuality measures the percentage of trains arriving at their destinations on time (the train doesn’t arrive after planned arrival) and the train didn’t depart before planned departure time. The goal is to maintain a high level of reliability and minimize delays for passengers and freight services. ', 'This KPI contributes to evaluating Effectiveness of the AI-based assistant, as part of Task 4.1 evaluation objectives, and O2 main project objective:<br/>- Improve customer satisfaction by ensuring timely arrivals<br/>- Guarantee maximal planned connection<br/>- Minimize operational disruptions caused by delays<br/>- Meet regulatory and stakeholder benchmarks for punctuality<br/>This KPI is linked with project’s Long Term Expected Impacts (LTEI) (LTEI1)KPIS-3:<br/>- 10% increase in punctuality in long-range traffic<br/>- 5% increase in punctuality in regional traffic (with realistic disturbances)<br/>', array['09919795-1368-4d97-b0aa-4764ebb93db0', '4509a7f1-92df-4b74-9a87-b84f924f6637']::uuid[])
    ON CONFLICT(id) DO UPDATE SET name=EXCLUDED.name, description=EXCLUDED.description, field_ids=EXCLUDED.field_ids;

INSERT INTO field_definitions
        (id, key, description, agg_func, agg_weights)
        VALUES ('09919795-1368-4d97-b0aa-4764ebb93db0', 'sum_normalized_reward', 'Primary scenario score (raw values): sum_normalized_reward', NULL, NULL)
        ON CONFLICT(id) DO UPDATE SET key=EXCLUDED.key, description=EXCLUDED.description, agg_func=EXCLUDED.agg_func, agg_weights=EXCLUDED.agg_weights;

INSERT INTO field_definitions
        (id, key, description, agg_func, agg_weights)
        VALUES ('4509a7f1-92df-4b74-9a87-b84f924f6637', 'success_rate', 'Secondary scenario score (raw values): success_rate', NULL, NULL)
        ON CONFLICT(id) DO UPDATE SET key=EXCLUDED.key, description=EXCLUDED.description, agg_func=EXCLUDED.agg_func, agg_weights=EXCLUDED.agg_weights;

INSERT INTO scenario_definitions
    (id, name, description, field_ids)
    VALUES ('42786e4c-c80e-40f5-8237-bafc5f39979d', 'Scenario 066 - Punctuality measures the percentage of trains arriving at their destinations on time (the train doesn’t arrive after planned arrival) and the train didn’t depart before planned departure time. The goal is to maintain a high level of reliability and minimize delays for passengers and freight services. ', 'This KPI contributes to evaluating Effectiveness of the AI-based assistant, as part of Task 4.1 evaluation objectives, and O2 main project objective:<br/>- Improve customer satisfaction by ensuring timely arrivals<br/>- Guarantee maximal planned connection<br/>- Minimize operational disruptions caused by delays<br/>- Meet regulatory and stakeholder benchmarks for punctuality<br/>This KPI is linked with project’s Long Term Expected Impacts (LTEI) (LTEI1)KPIS-3:<br/>- 10% increase in punctuality in long-range traffic<br/>- 5% increase in punctuality in regional traffic (with realistic disturbances)<br/>', array['23602def-5aa9-4a2d-8542-acff4e9e8277', '9c0b5ac4-5ea9-443b-aa68-40c33769c5b7']::uuid[])
    ON CONFLICT(id) DO UPDATE SET name=EXCLUDED.name, description=EXCLUDED.description, field_ids=EXCLUDED.field_ids;

INSERT INTO field_definitions
        (id, key, description, agg_func, agg_weights)
        VALUES ('23602def-5aa9-4a2d-8542-acff4e9e8277', 'sum_normalized_reward', 'Primary scenario score (raw values): sum_normalized_reward', NULL, NULL)
        ON CONFLICT(id) DO UPDATE SET key=EXCLUDED.key, description=EXCLUDED.description, agg_func=EXCLUDED.agg_func, agg_weights=EXCLUDED.agg_weights;

INSERT INTO field_definitions
        (id, key, description, agg_func, agg_weights)
        VALUES ('9c0b5ac4-5ea9-443b-aa68-40c33769c5b7', 'success_rate', 'Secondary scenario score (raw values): success_rate', NULL, NULL)
        ON CONFLICT(id) DO UPDATE SET key=EXCLUDED.key, description=EXCLUDED.description, agg_func=EXCLUDED.agg_func, agg_weights=EXCLUDED.agg_weights;

INSERT INTO scenario_definitions
    (id, name, description, field_ids)
    VALUES ('242a6240-b62c-48b4-a264-b6737e893fa5', 'Scenario 067 - Punctuality measures the percentage of trains arriving at their destinations on time (the train doesn’t arrive after planned arrival) and the train didn’t depart before planned departure time. The goal is to maintain a high level of reliability and minimize delays for passengers and freight services. ', 'This KPI contributes to evaluating Effectiveness of the AI-based assistant, as part of Task 4.1 evaluation objectives, and O2 main project objective:<br/>- Improve customer satisfaction by ensuring timely arrivals<br/>- Guarantee maximal planned connection<br/>- Minimize operational disruptions caused by delays<br/>- Meet regulatory and stakeholder benchmarks for punctuality<br/>This KPI is linked with project’s Long Term Expected Impacts (LTEI) (LTEI1)KPIS-3:<br/>- 10% increase in punctuality in long-range traffic<br/>- 5% increase in punctuality in regional traffic (with realistic disturbances)<br/>', array['e90355e4-5e27-4a55-b7bf-19ab148d21da', '58b04b70-72e7-4891-8478-a5aa4521b727']::uuid[])
    ON CONFLICT(id) DO UPDATE SET name=EXCLUDED.name, description=EXCLUDED.description, field_ids=EXCLUDED.field_ids;

INSERT INTO field_definitions
        (id, key, description, agg_func, agg_weights)
        VALUES ('e90355e4-5e27-4a55-b7bf-19ab148d21da', 'sum_normalized_reward', 'Primary scenario score (raw values): sum_normalized_reward', NULL, NULL)
        ON CONFLICT(id) DO UPDATE SET key=EXCLUDED.key, description=EXCLUDED.description, agg_func=EXCLUDED.agg_func, agg_weights=EXCLUDED.agg_weights;

INSERT INTO field_definitions
        (id, key, description, agg_func, agg_weights)
        VALUES ('58b04b70-72e7-4891-8478-a5aa4521b727', 'success_rate', 'Secondary scenario score (raw values): success_rate', NULL, NULL)
        ON CONFLICT(id) DO UPDATE SET key=EXCLUDED.key, description=EXCLUDED.description, agg_func=EXCLUDED.agg_func, agg_weights=EXCLUDED.agg_weights;

INSERT INTO scenario_definitions
    (id, name, description, field_ids)
    VALUES ('3c38a1d3-2340-43ed-ac0b-4b76c6588b92', 'Scenario 068 - Punctuality measures the percentage of trains arriving at their destinations on time (the train doesn’t arrive after planned arrival) and the train didn’t depart before planned departure time. The goal is to maintain a high level of reliability and minimize delays for passengers and freight services. ', 'This KPI contributes to evaluating Effectiveness of the AI-based assistant, as part of Task 4.1 evaluation objectives, and O2 main project objective:<br/>- Improve customer satisfaction by ensuring timely arrivals<br/>- Guarantee maximal planned connection<br/>- Minimize operational disruptions caused by delays<br/>- Meet regulatory and stakeholder benchmarks for punctuality<br/>This KPI is linked with project’s Long Term Expected Impacts (LTEI) (LTEI1)KPIS-3:<br/>- 10% increase in punctuality in long-range traffic<br/>- 5% increase in punctuality in regional traffic (with realistic disturbances)<br/>', array['881b7248-873d-46e0-9ceb-31ebb76df897', '78478b83-be82-4418-864e-35b7c0d364a1']::uuid[])
    ON CONFLICT(id) DO UPDATE SET name=EXCLUDED.name, description=EXCLUDED.description, field_ids=EXCLUDED.field_ids;

INSERT INTO field_definitions
        (id, key, description, agg_func, agg_weights)
        VALUES ('881b7248-873d-46e0-9ceb-31ebb76df897', 'sum_normalized_reward', 'Primary scenario score (raw values): sum_normalized_reward', NULL, NULL)
        ON CONFLICT(id) DO UPDATE SET key=EXCLUDED.key, description=EXCLUDED.description, agg_func=EXCLUDED.agg_func, agg_weights=EXCLUDED.agg_weights;

INSERT INTO field_definitions
        (id, key, description, agg_func, agg_weights)
        VALUES ('78478b83-be82-4418-864e-35b7c0d364a1', 'success_rate', 'Secondary scenario score (raw values): success_rate', NULL, NULL)
        ON CONFLICT(id) DO UPDATE SET key=EXCLUDED.key, description=EXCLUDED.description, agg_func=EXCLUDED.agg_func, agg_weights=EXCLUDED.agg_weights;

INSERT INTO scenario_definitions
    (id, name, description, field_ids)
    VALUES ('b89daede-405b-411a-a02b-ee32d7c9d020', 'Scenario 069 - Punctuality measures the percentage of trains arriving at their destinations on time (the train doesn’t arrive after planned arrival) and the train didn’t depart before planned departure time. The goal is to maintain a high level of reliability and minimize delays for passengers and freight services. ', 'This KPI contributes to evaluating Effectiveness of the AI-based assistant, as part of Task 4.1 evaluation objectives, and O2 main project objective:<br/>- Improve customer satisfaction by ensuring timely arrivals<br/>- Guarantee maximal planned connection<br/>- Minimize operational disruptions caused by delays<br/>- Meet regulatory and stakeholder benchmarks for punctuality<br/>This KPI is linked with project’s Long Term Expected Impacts (LTEI) (LTEI1)KPIS-3:<br/>- 10% increase in punctuality in long-range traffic<br/>- 5% increase in punctuality in regional traffic (with realistic disturbances)<br/>', array['f58732b5-e3f8-4997-a6c0-e24d57935e15', 'b8bcb820-9dd9-4861-b031-8b1fbc6d65dd']::uuid[])
    ON CONFLICT(id) DO UPDATE SET name=EXCLUDED.name, description=EXCLUDED.description, field_ids=EXCLUDED.field_ids;

INSERT INTO field_definitions
        (id, key, description, agg_func, agg_weights)
        VALUES ('f58732b5-e3f8-4997-a6c0-e24d57935e15', 'sum_normalized_reward', 'Primary scenario score (raw values): sum_normalized_reward', NULL, NULL)
        ON CONFLICT(id) DO UPDATE SET key=EXCLUDED.key, description=EXCLUDED.description, agg_func=EXCLUDED.agg_func, agg_weights=EXCLUDED.agg_weights;

INSERT INTO field_definitions
        (id, key, description, agg_func, agg_weights)
        VALUES ('b8bcb820-9dd9-4861-b031-8b1fbc6d65dd', 'success_rate', 'Secondary scenario score (raw values): success_rate', NULL, NULL)
        ON CONFLICT(id) DO UPDATE SET key=EXCLUDED.key, description=EXCLUDED.description, agg_func=EXCLUDED.agg_func, agg_weights=EXCLUDED.agg_weights;

INSERT INTO scenario_definitions
    (id, name, description, field_ids)
    VALUES ('736301d9-0cff-4e25-af78-4d6f78b48cd5', 'Scenario 070 - Punctuality measures the percentage of trains arriving at their destinations on time (the train doesn’t arrive after planned arrival) and the train didn’t depart before planned departure time. The goal is to maintain a high level of reliability and minimize delays for passengers and freight services. ', 'This KPI contributes to evaluating Effectiveness of the AI-based assistant, as part of Task 4.1 evaluation objectives, and O2 main project objective:<br/>- Improve customer satisfaction by ensuring timely arrivals<br/>- Guarantee maximal planned connection<br/>- Minimize operational disruptions caused by delays<br/>- Meet regulatory and stakeholder benchmarks for punctuality<br/>This KPI is linked with project’s Long Term Expected Impacts (LTEI) (LTEI1)KPIS-3:<br/>- 10% increase in punctuality in long-range traffic<br/>- 5% increase in punctuality in regional traffic (with realistic disturbances)<br/>', array['2ccc3087-4f95-4828-9f86-dcd1dd8342a3', 'f398ab87-38eb-488d-9863-4688423c9ced']::uuid[])
    ON CONFLICT(id) DO UPDATE SET name=EXCLUDED.name, description=EXCLUDED.description, field_ids=EXCLUDED.field_ids;

INSERT INTO field_definitions
        (id, key, description, agg_func, agg_weights)
        VALUES ('2ccc3087-4f95-4828-9f86-dcd1dd8342a3', 'sum_normalized_reward', 'Primary scenario score (raw values): sum_normalized_reward', NULL, NULL)
        ON CONFLICT(id) DO UPDATE SET key=EXCLUDED.key, description=EXCLUDED.description, agg_func=EXCLUDED.agg_func, agg_weights=EXCLUDED.agg_weights;

INSERT INTO field_definitions
        (id, key, description, agg_func, agg_weights)
        VALUES ('f398ab87-38eb-488d-9863-4688423c9ced', 'success_rate', 'Secondary scenario score (raw values): success_rate', NULL, NULL)
        ON CONFLICT(id) DO UPDATE SET key=EXCLUDED.key, description=EXCLUDED.description, agg_func=EXCLUDED.agg_func, agg_weights=EXCLUDED.agg_weights;

INSERT INTO scenario_definitions
    (id, name, description, field_ids)
    VALUES ('3b74e3a8-e740-4bb2-802f-2b2bedabad65', 'Scenario 071 - Punctuality measures the percentage of trains arriving at their destinations on time (the train doesn’t arrive after planned arrival) and the train didn’t depart before planned departure time. The goal is to maintain a high level of reliability and minimize delays for passengers and freight services. ', 'This KPI contributes to evaluating Effectiveness of the AI-based assistant, as part of Task 4.1 evaluation objectives, and O2 main project objective:<br/>- Improve customer satisfaction by ensuring timely arrivals<br/>- Guarantee maximal planned connection<br/>- Minimize operational disruptions caused by delays<br/>- Meet regulatory and stakeholder benchmarks for punctuality<br/>This KPI is linked with project’s Long Term Expected Impacts (LTEI) (LTEI1)KPIS-3:<br/>- 10% increase in punctuality in long-range traffic<br/>- 5% increase in punctuality in regional traffic (with realistic disturbances)<br/>', array['e025c0ba-938d-49d6-8b5e-f8f2c3c0f317', '32992519-d2b3-45db-a41d-c03c4fcc048b']::uuid[])
    ON CONFLICT(id) DO UPDATE SET name=EXCLUDED.name, description=EXCLUDED.description, field_ids=EXCLUDED.field_ids;

INSERT INTO field_definitions
        (id, key, description, agg_func, agg_weights)
        VALUES ('e025c0ba-938d-49d6-8b5e-f8f2c3c0f317', 'sum_normalized_reward', 'Primary scenario score (raw values): sum_normalized_reward', NULL, NULL)
        ON CONFLICT(id) DO UPDATE SET key=EXCLUDED.key, description=EXCLUDED.description, agg_func=EXCLUDED.agg_func, agg_weights=EXCLUDED.agg_weights;

INSERT INTO field_definitions
        (id, key, description, agg_func, agg_weights)
        VALUES ('32992519-d2b3-45db-a41d-c03c4fcc048b', 'success_rate', 'Secondary scenario score (raw values): success_rate', NULL, NULL)
        ON CONFLICT(id) DO UPDATE SET key=EXCLUDED.key, description=EXCLUDED.description, agg_func=EXCLUDED.agg_func, agg_weights=EXCLUDED.agg_weights;

INSERT INTO scenario_definitions
    (id, name, description, field_ids)
    VALUES ('61ee09b0-96fb-4562-bf7d-a01606de424c', 'Scenario 072 - Punctuality measures the percentage of trains arriving at their destinations on time (the train doesn’t arrive after planned arrival) and the train didn’t depart before planned departure time. The goal is to maintain a high level of reliability and minimize delays for passengers and freight services. ', 'This KPI contributes to evaluating Effectiveness of the AI-based assistant, as part of Task 4.1 evaluation objectives, and O2 main project objective:<br/>- Improve customer satisfaction by ensuring timely arrivals<br/>- Guarantee maximal planned connection<br/>- Minimize operational disruptions caused by delays<br/>- Meet regulatory and stakeholder benchmarks for punctuality<br/>This KPI is linked with project’s Long Term Expected Impacts (LTEI) (LTEI1)KPIS-3:<br/>- 10% increase in punctuality in long-range traffic<br/>- 5% increase in punctuality in regional traffic (with realistic disturbances)<br/>', array['bb4d978b-bdd5-42c7-91bd-968187e080df', 'f75737c9-7ef6-4f09-b724-fb6267204ab1']::uuid[])
    ON CONFLICT(id) DO UPDATE SET name=EXCLUDED.name, description=EXCLUDED.description, field_ids=EXCLUDED.field_ids;

INSERT INTO field_definitions
        (id, key, description, agg_func, agg_weights)
        VALUES ('bb4d978b-bdd5-42c7-91bd-968187e080df', 'sum_normalized_reward', 'Primary scenario score (raw values): sum_normalized_reward', NULL, NULL)
        ON CONFLICT(id) DO UPDATE SET key=EXCLUDED.key, description=EXCLUDED.description, agg_func=EXCLUDED.agg_func, agg_weights=EXCLUDED.agg_weights;

INSERT INTO field_definitions
        (id, key, description, agg_func, agg_weights)
        VALUES ('f75737c9-7ef6-4f09-b724-fb6267204ab1', 'success_rate', 'Secondary scenario score (raw values): success_rate', NULL, NULL)
        ON CONFLICT(id) DO UPDATE SET key=EXCLUDED.key, description=EXCLUDED.description, agg_func=EXCLUDED.agg_func, agg_weights=EXCLUDED.agg_weights;

INSERT INTO scenario_definitions
    (id, name, description, field_ids)
    VALUES ('8d75b03c-2a34-4b2a-8408-d8db01a7ae1a', 'Scenario 073 - Punctuality measures the percentage of trains arriving at their destinations on time (the train doesn’t arrive after planned arrival) and the train didn’t depart before planned departure time. The goal is to maintain a high level of reliability and minimize delays for passengers and freight services. ', 'This KPI contributes to evaluating Effectiveness of the AI-based assistant, as part of Task 4.1 evaluation objectives, and O2 main project objective:<br/>- Improve customer satisfaction by ensuring timely arrivals<br/>- Guarantee maximal planned connection<br/>- Minimize operational disruptions caused by delays<br/>- Meet regulatory and stakeholder benchmarks for punctuality<br/>This KPI is linked with project’s Long Term Expected Impacts (LTEI) (LTEI1)KPIS-3:<br/>- 10% increase in punctuality in long-range traffic<br/>- 5% increase in punctuality in regional traffic (with realistic disturbances)<br/>', array['b12f3a92-65ea-489e-939d-029f78fbf6d4', '7250585b-50f3-45ac-ab03-fcc6b564f9d5']::uuid[])
    ON CONFLICT(id) DO UPDATE SET name=EXCLUDED.name, description=EXCLUDED.description, field_ids=EXCLUDED.field_ids;

INSERT INTO field_definitions
        (id, key, description, agg_func, agg_weights)
        VALUES ('b12f3a92-65ea-489e-939d-029f78fbf6d4', 'sum_normalized_reward', 'Primary scenario score (raw values): sum_normalized_reward', NULL, NULL)
        ON CONFLICT(id) DO UPDATE SET key=EXCLUDED.key, description=EXCLUDED.description, agg_func=EXCLUDED.agg_func, agg_weights=EXCLUDED.agg_weights;

INSERT INTO field_definitions
        (id, key, description, agg_func, agg_weights)
        VALUES ('7250585b-50f3-45ac-ab03-fcc6b564f9d5', 'success_rate', 'Secondary scenario score (raw values): success_rate', NULL, NULL)
        ON CONFLICT(id) DO UPDATE SET key=EXCLUDED.key, description=EXCLUDED.description, agg_func=EXCLUDED.agg_func, agg_weights=EXCLUDED.agg_weights;

INSERT INTO scenario_definitions
    (id, name, description, field_ids)
    VALUES ('81c01671-1a30-41cd-9f6c-25b2f9253da9', 'Scenario 074 - Punctuality measures the percentage of trains arriving at their destinations on time (the train doesn’t arrive after planned arrival) and the train didn’t depart before planned departure time. The goal is to maintain a high level of reliability and minimize delays for passengers and freight services. ', 'This KPI contributes to evaluating Effectiveness of the AI-based assistant, as part of Task 4.1 evaluation objectives, and O2 main project objective:<br/>- Improve customer satisfaction by ensuring timely arrivals<br/>- Guarantee maximal planned connection<br/>- Minimize operational disruptions caused by delays<br/>- Meet regulatory and stakeholder benchmarks for punctuality<br/>This KPI is linked with project’s Long Term Expected Impacts (LTEI) (LTEI1)KPIS-3:<br/>- 10% increase in punctuality in long-range traffic<br/>- 5% increase in punctuality in regional traffic (with realistic disturbances)<br/>', array['2349a20f-d33c-43dc-891c-7bf9ebc21ad1', '25bbb2cc-b1d3-4b7f-a04b-32ccc167c110']::uuid[])
    ON CONFLICT(id) DO UPDATE SET name=EXCLUDED.name, description=EXCLUDED.description, field_ids=EXCLUDED.field_ids;

INSERT INTO field_definitions
        (id, key, description, agg_func, agg_weights)
        VALUES ('2349a20f-d33c-43dc-891c-7bf9ebc21ad1', 'sum_normalized_reward', 'Primary scenario score (raw values): sum_normalized_reward', NULL, NULL)
        ON CONFLICT(id) DO UPDATE SET key=EXCLUDED.key, description=EXCLUDED.description, agg_func=EXCLUDED.agg_func, agg_weights=EXCLUDED.agg_weights;

INSERT INTO field_definitions
        (id, key, description, agg_func, agg_weights)
        VALUES ('25bbb2cc-b1d3-4b7f-a04b-32ccc167c110', 'success_rate', 'Secondary scenario score (raw values): success_rate', NULL, NULL)
        ON CONFLICT(id) DO UPDATE SET key=EXCLUDED.key, description=EXCLUDED.description, agg_func=EXCLUDED.agg_func, agg_weights=EXCLUDED.agg_weights;

INSERT INTO scenario_definitions
    (id, name, description, field_ids)
    VALUES ('01723b62-3f4d-4921-8904-752f092588f5', 'Scenario 075 - Punctuality measures the percentage of trains arriving at their destinations on time (the train doesn’t arrive after planned arrival) and the train didn’t depart before planned departure time. The goal is to maintain a high level of reliability and minimize delays for passengers and freight services. ', 'This KPI contributes to evaluating Effectiveness of the AI-based assistant, as part of Task 4.1 evaluation objectives, and O2 main project objective:<br/>- Improve customer satisfaction by ensuring timely arrivals<br/>- Guarantee maximal planned connection<br/>- Minimize operational disruptions caused by delays<br/>- Meet regulatory and stakeholder benchmarks for punctuality<br/>This KPI is linked with project’s Long Term Expected Impacts (LTEI) (LTEI1)KPIS-3:<br/>- 10% increase in punctuality in long-range traffic<br/>- 5% increase in punctuality in regional traffic (with realistic disturbances)<br/>', array['9b3fef3c-2d06-40d3-a15a-0c0fe8d35c13', 'a1403c86-de5f-4386-a9f7-e871058c9927']::uuid[])
    ON CONFLICT(id) DO UPDATE SET name=EXCLUDED.name, description=EXCLUDED.description, field_ids=EXCLUDED.field_ids;

INSERT INTO field_definitions
        (id, key, description, agg_func, agg_weights)
        VALUES ('9b3fef3c-2d06-40d3-a15a-0c0fe8d35c13', 'sum_normalized_reward', 'Primary scenario score (raw values): sum_normalized_reward', NULL, NULL)
        ON CONFLICT(id) DO UPDATE SET key=EXCLUDED.key, description=EXCLUDED.description, agg_func=EXCLUDED.agg_func, agg_weights=EXCLUDED.agg_weights;

INSERT INTO field_definitions
        (id, key, description, agg_func, agg_weights)
        VALUES ('a1403c86-de5f-4386-a9f7-e871058c9927', 'success_rate', 'Secondary scenario score (raw values): success_rate', NULL, NULL)
        ON CONFLICT(id) DO UPDATE SET key=EXCLUDED.key, description=EXCLUDED.description, agg_func=EXCLUDED.agg_func, agg_weights=EXCLUDED.agg_weights;

INSERT INTO scenario_definitions
    (id, name, description, field_ids)
    VALUES ('5d44cb89-3c63-4716-8551-bd25de881f89', 'Scenario 076 - Punctuality measures the percentage of trains arriving at their destinations on time (the train doesn’t arrive after planned arrival) and the train didn’t depart before planned departure time. The goal is to maintain a high level of reliability and minimize delays for passengers and freight services. ', 'This KPI contributes to evaluating Effectiveness of the AI-based assistant, as part of Task 4.1 evaluation objectives, and O2 main project objective:<br/>- Improve customer satisfaction by ensuring timely arrivals<br/>- Guarantee maximal planned connection<br/>- Minimize operational disruptions caused by delays<br/>- Meet regulatory and stakeholder benchmarks for punctuality<br/>This KPI is linked with project’s Long Term Expected Impacts (LTEI) (LTEI1)KPIS-3:<br/>- 10% increase in punctuality in long-range traffic<br/>- 5% increase in punctuality in regional traffic (with realistic disturbances)<br/>', array['415bac48-7878-4fc9-b0a9-afdc266668c5', '66f89046-bb2d-4724-84fb-bdf229337038']::uuid[])
    ON CONFLICT(id) DO UPDATE SET name=EXCLUDED.name, description=EXCLUDED.description, field_ids=EXCLUDED.field_ids;

INSERT INTO field_definitions
        (id, key, description, agg_func, agg_weights)
        VALUES ('415bac48-7878-4fc9-b0a9-afdc266668c5', 'sum_normalized_reward', 'Primary scenario score (raw values): sum_normalized_reward', NULL, NULL)
        ON CONFLICT(id) DO UPDATE SET key=EXCLUDED.key, description=EXCLUDED.description, agg_func=EXCLUDED.agg_func, agg_weights=EXCLUDED.agg_weights;

INSERT INTO field_definitions
        (id, key, description, agg_func, agg_weights)
        VALUES ('66f89046-bb2d-4724-84fb-bdf229337038', 'success_rate', 'Secondary scenario score (raw values): success_rate', NULL, NULL)
        ON CONFLICT(id) DO UPDATE SET key=EXCLUDED.key, description=EXCLUDED.description, agg_func=EXCLUDED.agg_func, agg_weights=EXCLUDED.agg_weights;

INSERT INTO scenario_definitions
    (id, name, description, field_ids)
    VALUES ('cf7c97fc-1c61-4c0d-ad1e-952bf6d6f23a', 'Scenario 077 - Punctuality measures the percentage of trains arriving at their destinations on time (the train doesn’t arrive after planned arrival) and the train didn’t depart before planned departure time. The goal is to maintain a high level of reliability and minimize delays for passengers and freight services. ', 'This KPI contributes to evaluating Effectiveness of the AI-based assistant, as part of Task 4.1 evaluation objectives, and O2 main project objective:<br/>- Improve customer satisfaction by ensuring timely arrivals<br/>- Guarantee maximal planned connection<br/>- Minimize operational disruptions caused by delays<br/>- Meet regulatory and stakeholder benchmarks for punctuality<br/>This KPI is linked with project’s Long Term Expected Impacts (LTEI) (LTEI1)KPIS-3:<br/>- 10% increase in punctuality in long-range traffic<br/>- 5% increase in punctuality in regional traffic (with realistic disturbances)<br/>', array['874509d6-244c-4446-87da-17ecb05d1f86', 'b88ecdcc-f374-4b9d-bd8f-5d96cb1a3206']::uuid[])
    ON CONFLICT(id) DO UPDATE SET name=EXCLUDED.name, description=EXCLUDED.description, field_ids=EXCLUDED.field_ids;

INSERT INTO field_definitions
        (id, key, description, agg_func, agg_weights)
        VALUES ('874509d6-244c-4446-87da-17ecb05d1f86', 'sum_normalized_reward', 'Primary scenario score (raw values): sum_normalized_reward', NULL, NULL)
        ON CONFLICT(id) DO UPDATE SET key=EXCLUDED.key, description=EXCLUDED.description, agg_func=EXCLUDED.agg_func, agg_weights=EXCLUDED.agg_weights;

INSERT INTO field_definitions
        (id, key, description, agg_func, agg_weights)
        VALUES ('b88ecdcc-f374-4b9d-bd8f-5d96cb1a3206', 'success_rate', 'Secondary scenario score (raw values): success_rate', NULL, NULL)
        ON CONFLICT(id) DO UPDATE SET key=EXCLUDED.key, description=EXCLUDED.description, agg_func=EXCLUDED.agg_func, agg_weights=EXCLUDED.agg_weights;

INSERT INTO scenario_definitions
    (id, name, description, field_ids)
    VALUES ('60ddab54-dc12-4fbd-bbec-53b23d896c9d', 'Scenario 078 - Punctuality measures the percentage of trains arriving at their destinations on time (the train doesn’t arrive after planned arrival) and the train didn’t depart before planned departure time. The goal is to maintain a high level of reliability and minimize delays for passengers and freight services. ', 'This KPI contributes to evaluating Effectiveness of the AI-based assistant, as part of Task 4.1 evaluation objectives, and O2 main project objective:<br/>- Improve customer satisfaction by ensuring timely arrivals<br/>- Guarantee maximal planned connection<br/>- Minimize operational disruptions caused by delays<br/>- Meet regulatory and stakeholder benchmarks for punctuality<br/>This KPI is linked with project’s Long Term Expected Impacts (LTEI) (LTEI1)KPIS-3:<br/>- 10% increase in punctuality in long-range traffic<br/>- 5% increase in punctuality in regional traffic (with realistic disturbances)<br/>', array['2c780784-33e4-454b-b37a-681577912a20', 'c838aac4-30aa-4103-b5d6-fe7864395945']::uuid[])
    ON CONFLICT(id) DO UPDATE SET name=EXCLUDED.name, description=EXCLUDED.description, field_ids=EXCLUDED.field_ids;

INSERT INTO field_definitions
        (id, key, description, agg_func, agg_weights)
        VALUES ('2c780784-33e4-454b-b37a-681577912a20', 'sum_normalized_reward', 'Primary scenario score (raw values): sum_normalized_reward', NULL, NULL)
        ON CONFLICT(id) DO UPDATE SET key=EXCLUDED.key, description=EXCLUDED.description, agg_func=EXCLUDED.agg_func, agg_weights=EXCLUDED.agg_weights;

INSERT INTO field_definitions
        (id, key, description, agg_func, agg_weights)
        VALUES ('c838aac4-30aa-4103-b5d6-fe7864395945', 'success_rate', 'Secondary scenario score (raw values): success_rate', NULL, NULL)
        ON CONFLICT(id) DO UPDATE SET key=EXCLUDED.key, description=EXCLUDED.description, agg_func=EXCLUDED.agg_func, agg_weights=EXCLUDED.agg_weights;

INSERT INTO scenario_definitions
    (id, name, description, field_ids)
    VALUES ('7eab41ad-8fd5-4a04-8c06-4d6c2016a594', 'Scenario 079 - Punctuality measures the percentage of trains arriving at their destinations on time (the train doesn’t arrive after planned arrival) and the train didn’t depart before planned departure time. The goal is to maintain a high level of reliability and minimize delays for passengers and freight services. ', 'This KPI contributes to evaluating Effectiveness of the AI-based assistant, as part of Task 4.1 evaluation objectives, and O2 main project objective:<br/>- Improve customer satisfaction by ensuring timely arrivals<br/>- Guarantee maximal planned connection<br/>- Minimize operational disruptions caused by delays<br/>- Meet regulatory and stakeholder benchmarks for punctuality<br/>This KPI is linked with project’s Long Term Expected Impacts (LTEI) (LTEI1)KPIS-3:<br/>- 10% increase in punctuality in long-range traffic<br/>- 5% increase in punctuality in regional traffic (with realistic disturbances)<br/>', array['0f10f947-7e67-4400-92b9-abbacc3a84e4', 'd09f3157-8c73-4a13-9a2d-940e33d9bcb9']::uuid[])
    ON CONFLICT(id) DO UPDATE SET name=EXCLUDED.name, description=EXCLUDED.description, field_ids=EXCLUDED.field_ids;

INSERT INTO field_definitions
        (id, key, description, agg_func, agg_weights)
        VALUES ('0f10f947-7e67-4400-92b9-abbacc3a84e4', 'sum_normalized_reward', 'Primary scenario score (raw values): sum_normalized_reward', NULL, NULL)
        ON CONFLICT(id) DO UPDATE SET key=EXCLUDED.key, description=EXCLUDED.description, agg_func=EXCLUDED.agg_func, agg_weights=EXCLUDED.agg_weights;

INSERT INTO field_definitions
        (id, key, description, agg_func, agg_weights)
        VALUES ('d09f3157-8c73-4a13-9a2d-940e33d9bcb9', 'success_rate', 'Secondary scenario score (raw values): success_rate', NULL, NULL)
        ON CONFLICT(id) DO UPDATE SET key=EXCLUDED.key, description=EXCLUDED.description, agg_func=EXCLUDED.agg_func, agg_weights=EXCLUDED.agg_weights;

INSERT INTO scenario_definitions
    (id, name, description, field_ids)
    VALUES ('9e0aac9e-ddf9-4575-bf1c-d08a923e15fa', 'Scenario 080 - Punctuality measures the percentage of trains arriving at their destinations on time (the train doesn’t arrive after planned arrival) and the train didn’t depart before planned departure time. The goal is to maintain a high level of reliability and minimize delays for passengers and freight services. ', 'This KPI contributes to evaluating Effectiveness of the AI-based assistant, as part of Task 4.1 evaluation objectives, and O2 main project objective:<br/>- Improve customer satisfaction by ensuring timely arrivals<br/>- Guarantee maximal planned connection<br/>- Minimize operational disruptions caused by delays<br/>- Meet regulatory and stakeholder benchmarks for punctuality<br/>This KPI is linked with project’s Long Term Expected Impacts (LTEI) (LTEI1)KPIS-3:<br/>- 10% increase in punctuality in long-range traffic<br/>- 5% increase in punctuality in regional traffic (with realistic disturbances)<br/>', array['22a312d6-d593-47b6-883e-b060a62b95aa', '695de478-eff3-4b6d-8900-475b8bf08387']::uuid[])
    ON CONFLICT(id) DO UPDATE SET name=EXCLUDED.name, description=EXCLUDED.description, field_ids=EXCLUDED.field_ids;

INSERT INTO field_definitions
        (id, key, description, agg_func, agg_weights)
        VALUES ('22a312d6-d593-47b6-883e-b060a62b95aa', 'sum_normalized_reward', 'Primary scenario score (raw values): sum_normalized_reward', NULL, NULL)
        ON CONFLICT(id) DO UPDATE SET key=EXCLUDED.key, description=EXCLUDED.description, agg_func=EXCLUDED.agg_func, agg_weights=EXCLUDED.agg_weights;

INSERT INTO field_definitions
        (id, key, description, agg_func, agg_weights)
        VALUES ('695de478-eff3-4b6d-8900-475b8bf08387', 'success_rate', 'Secondary scenario score (raw values): success_rate', NULL, NULL)
        ON CONFLICT(id) DO UPDATE SET key=EXCLUDED.key, description=EXCLUDED.description, agg_func=EXCLUDED.agg_func, agg_weights=EXCLUDED.agg_weights;

INSERT INTO scenario_definitions
    (id, name, description, field_ids)
    VALUES ('befa97fb-2a74-4f2e-91c8-ea2879d08dcf', 'Scenario 081 - Punctuality measures the percentage of trains arriving at their destinations on time (the train doesn’t arrive after planned arrival) and the train didn’t depart before planned departure time. The goal is to maintain a high level of reliability and minimize delays for passengers and freight services. ', 'This KPI contributes to evaluating Effectiveness of the AI-based assistant, as part of Task 4.1 evaluation objectives, and O2 main project objective:<br/>- Improve customer satisfaction by ensuring timely arrivals<br/>- Guarantee maximal planned connection<br/>- Minimize operational disruptions caused by delays<br/>- Meet regulatory and stakeholder benchmarks for punctuality<br/>This KPI is linked with project’s Long Term Expected Impacts (LTEI) (LTEI1)KPIS-3:<br/>- 10% increase in punctuality in long-range traffic<br/>- 5% increase in punctuality in regional traffic (with realistic disturbances)<br/>', array['4d79afcf-a37b-4632-b7aa-7fa5d438b20c', 'cb1887a7-5fd1-403c-a52c-20ac9a75e86f']::uuid[])
    ON CONFLICT(id) DO UPDATE SET name=EXCLUDED.name, description=EXCLUDED.description, field_ids=EXCLUDED.field_ids;

INSERT INTO field_definitions
        (id, key, description, agg_func, agg_weights)
        VALUES ('4d79afcf-a37b-4632-b7aa-7fa5d438b20c', 'sum_normalized_reward', 'Primary scenario score (raw values): sum_normalized_reward', NULL, NULL)
        ON CONFLICT(id) DO UPDATE SET key=EXCLUDED.key, description=EXCLUDED.description, agg_func=EXCLUDED.agg_func, agg_weights=EXCLUDED.agg_weights;

INSERT INTO field_definitions
        (id, key, description, agg_func, agg_weights)
        VALUES ('cb1887a7-5fd1-403c-a52c-20ac9a75e86f', 'success_rate', 'Secondary scenario score (raw values): success_rate', NULL, NULL)
        ON CONFLICT(id) DO UPDATE SET key=EXCLUDED.key, description=EXCLUDED.description, agg_func=EXCLUDED.agg_func, agg_weights=EXCLUDED.agg_weights;

INSERT INTO scenario_definitions
    (id, name, description, field_ids)
    VALUES ('0cc18965-c967-4b58-ac7f-38a443b4cd16', 'Scenario 082 - Punctuality measures the percentage of trains arriving at their destinations on time (the train doesn’t arrive after planned arrival) and the train didn’t depart before planned departure time. The goal is to maintain a high level of reliability and minimize delays for passengers and freight services. ', 'This KPI contributes to evaluating Effectiveness of the AI-based assistant, as part of Task 4.1 evaluation objectives, and O2 main project objective:<br/>- Improve customer satisfaction by ensuring timely arrivals<br/>- Guarantee maximal planned connection<br/>- Minimize operational disruptions caused by delays<br/>- Meet regulatory and stakeholder benchmarks for punctuality<br/>This KPI is linked with project’s Long Term Expected Impacts (LTEI) (LTEI1)KPIS-3:<br/>- 10% increase in punctuality in long-range traffic<br/>- 5% increase in punctuality in regional traffic (with realistic disturbances)<br/>', array['292efb51-5fc1-44fa-a507-92cc754ac50f', '93018027-3ec6-412d-9afc-76875ea68712']::uuid[])
    ON CONFLICT(id) DO UPDATE SET name=EXCLUDED.name, description=EXCLUDED.description, field_ids=EXCLUDED.field_ids;

INSERT INTO field_definitions
        (id, key, description, agg_func, agg_weights)
        VALUES ('292efb51-5fc1-44fa-a507-92cc754ac50f', 'sum_normalized_reward', 'Primary scenario score (raw values): sum_normalized_reward', NULL, NULL)
        ON CONFLICT(id) DO UPDATE SET key=EXCLUDED.key, description=EXCLUDED.description, agg_func=EXCLUDED.agg_func, agg_weights=EXCLUDED.agg_weights;

INSERT INTO field_definitions
        (id, key, description, agg_func, agg_weights)
        VALUES ('93018027-3ec6-412d-9afc-76875ea68712', 'success_rate', 'Secondary scenario score (raw values): success_rate', NULL, NULL)
        ON CONFLICT(id) DO UPDATE SET key=EXCLUDED.key, description=EXCLUDED.description, agg_func=EXCLUDED.agg_func, agg_weights=EXCLUDED.agg_weights;

INSERT INTO scenario_definitions
    (id, name, description, field_ids)
    VALUES ('d0f62f51-5a51-443b-bf7b-18e3d5b191dc', 'Scenario 083 - Punctuality measures the percentage of trains arriving at their destinations on time (the train doesn’t arrive after planned arrival) and the train didn’t depart before planned departure time. The goal is to maintain a high level of reliability and minimize delays for passengers and freight services. ', 'This KPI contributes to evaluating Effectiveness of the AI-based assistant, as part of Task 4.1 evaluation objectives, and O2 main project objective:<br/>- Improve customer satisfaction by ensuring timely arrivals<br/>- Guarantee maximal planned connection<br/>- Minimize operational disruptions caused by delays<br/>- Meet regulatory and stakeholder benchmarks for punctuality<br/>This KPI is linked with project’s Long Term Expected Impacts (LTEI) (LTEI1)KPIS-3:<br/>- 10% increase in punctuality in long-range traffic<br/>- 5% increase in punctuality in regional traffic (with realistic disturbances)<br/>', array['2ec397b8-6752-4749-b03e-2a99e5daa594', '73c6b52b-4406-498a-9095-3a020e11b29d']::uuid[])
    ON CONFLICT(id) DO UPDATE SET name=EXCLUDED.name, description=EXCLUDED.description, field_ids=EXCLUDED.field_ids;

INSERT INTO field_definitions
        (id, key, description, agg_func, agg_weights)
        VALUES ('2ec397b8-6752-4749-b03e-2a99e5daa594', 'sum_normalized_reward', 'Primary scenario score (raw values): sum_normalized_reward', NULL, NULL)
        ON CONFLICT(id) DO UPDATE SET key=EXCLUDED.key, description=EXCLUDED.description, agg_func=EXCLUDED.agg_func, agg_weights=EXCLUDED.agg_weights;

INSERT INTO field_definitions
        (id, key, description, agg_func, agg_weights)
        VALUES ('73c6b52b-4406-498a-9095-3a020e11b29d', 'success_rate', 'Secondary scenario score (raw values): success_rate', NULL, NULL)
        ON CONFLICT(id) DO UPDATE SET key=EXCLUDED.key, description=EXCLUDED.description, agg_func=EXCLUDED.agg_func, agg_weights=EXCLUDED.agg_weights;

INSERT INTO scenario_definitions
    (id, name, description, field_ids)
    VALUES ('c2ebb179-0a2d-4e84-95be-2837be406716', 'Scenario 084 - Punctuality measures the percentage of trains arriving at their destinations on time (the train doesn’t arrive after planned arrival) and the train didn’t depart before planned departure time. The goal is to maintain a high level of reliability and minimize delays for passengers and freight services. ', 'This KPI contributes to evaluating Effectiveness of the AI-based assistant, as part of Task 4.1 evaluation objectives, and O2 main project objective:<br/>- Improve customer satisfaction by ensuring timely arrivals<br/>- Guarantee maximal planned connection<br/>- Minimize operational disruptions caused by delays<br/>- Meet regulatory and stakeholder benchmarks for punctuality<br/>This KPI is linked with project’s Long Term Expected Impacts (LTEI) (LTEI1)KPIS-3:<br/>- 10% increase in punctuality in long-range traffic<br/>- 5% increase in punctuality in regional traffic (with realistic disturbances)<br/>', array['ea1f7985-4998-42c4-a65d-69cc396b51f4', 'a34442f6-9568-4938-b7fe-20edb8389ab1']::uuid[])
    ON CONFLICT(id) DO UPDATE SET name=EXCLUDED.name, description=EXCLUDED.description, field_ids=EXCLUDED.field_ids;

INSERT INTO field_definitions
        (id, key, description, agg_func, agg_weights)
        VALUES ('ea1f7985-4998-42c4-a65d-69cc396b51f4', 'sum_normalized_reward', 'Primary scenario score (raw values): sum_normalized_reward', NULL, NULL)
        ON CONFLICT(id) DO UPDATE SET key=EXCLUDED.key, description=EXCLUDED.description, agg_func=EXCLUDED.agg_func, agg_weights=EXCLUDED.agg_weights;

INSERT INTO field_definitions
        (id, key, description, agg_func, agg_weights)
        VALUES ('a34442f6-9568-4938-b7fe-20edb8389ab1', 'success_rate', 'Secondary scenario score (raw values): success_rate', NULL, NULL)
        ON CONFLICT(id) DO UPDATE SET key=EXCLUDED.key, description=EXCLUDED.description, agg_func=EXCLUDED.agg_func, agg_weights=EXCLUDED.agg_weights;

INSERT INTO scenario_definitions
    (id, name, description, field_ids)
    VALUES ('3ac76f3c-f560-4666-af61-c693e4cd3ad4', 'Scenario 085 - Punctuality measures the percentage of trains arriving at their destinations on time (the train doesn’t arrive after planned arrival) and the train didn’t depart before planned departure time. The goal is to maintain a high level of reliability and minimize delays for passengers and freight services. ', 'This KPI contributes to evaluating Effectiveness of the AI-based assistant, as part of Task 4.1 evaluation objectives, and O2 main project objective:<br/>- Improve customer satisfaction by ensuring timely arrivals<br/>- Guarantee maximal planned connection<br/>- Minimize operational disruptions caused by delays<br/>- Meet regulatory and stakeholder benchmarks for punctuality<br/>This KPI is linked with project’s Long Term Expected Impacts (LTEI) (LTEI1)KPIS-3:<br/>- 10% increase in punctuality in long-range traffic<br/>- 5% increase in punctuality in regional traffic (with realistic disturbances)<br/>', array['beebd303-05ff-487a-80c3-e52d33647e9c', 'df7d73b8-89e1-4d79-ad30-3a57b74bd11a']::uuid[])
    ON CONFLICT(id) DO UPDATE SET name=EXCLUDED.name, description=EXCLUDED.description, field_ids=EXCLUDED.field_ids;

INSERT INTO field_definitions
        (id, key, description, agg_func, agg_weights)
        VALUES ('beebd303-05ff-487a-80c3-e52d33647e9c', 'sum_normalized_reward', 'Primary scenario score (raw values): sum_normalized_reward', NULL, NULL)
        ON CONFLICT(id) DO UPDATE SET key=EXCLUDED.key, description=EXCLUDED.description, agg_func=EXCLUDED.agg_func, agg_weights=EXCLUDED.agg_weights;

INSERT INTO field_definitions
        (id, key, description, agg_func, agg_weights)
        VALUES ('df7d73b8-89e1-4d79-ad30-3a57b74bd11a', 'success_rate', 'Secondary scenario score (raw values): success_rate', NULL, NULL)
        ON CONFLICT(id) DO UPDATE SET key=EXCLUDED.key, description=EXCLUDED.description, agg_func=EXCLUDED.agg_func, agg_weights=EXCLUDED.agg_weights;

INSERT INTO scenario_definitions
    (id, name, description, field_ids)
    VALUES ('484bbf93-bc67-4726-8b81-6c4ab608c861', 'Scenario 086 - Punctuality measures the percentage of trains arriving at their destinations on time (the train doesn’t arrive after planned arrival) and the train didn’t depart before planned departure time. The goal is to maintain a high level of reliability and minimize delays for passengers and freight services. ', 'This KPI contributes to evaluating Effectiveness of the AI-based assistant, as part of Task 4.1 evaluation objectives, and O2 main project objective:<br/>- Improve customer satisfaction by ensuring timely arrivals<br/>- Guarantee maximal planned connection<br/>- Minimize operational disruptions caused by delays<br/>- Meet regulatory and stakeholder benchmarks for punctuality<br/>This KPI is linked with project’s Long Term Expected Impacts (LTEI) (LTEI1)KPIS-3:<br/>- 10% increase in punctuality in long-range traffic<br/>- 5% increase in punctuality in regional traffic (with realistic disturbances)<br/>', array['7c66d1b5-131e-4c31-bcc6-a9b8cd241869', 'b5e06cc3-e58a-4812-8d26-a9600a38d798']::uuid[])
    ON CONFLICT(id) DO UPDATE SET name=EXCLUDED.name, description=EXCLUDED.description, field_ids=EXCLUDED.field_ids;

INSERT INTO field_definitions
        (id, key, description, agg_func, agg_weights)
        VALUES ('7c66d1b5-131e-4c31-bcc6-a9b8cd241869', 'sum_normalized_reward', 'Primary scenario score (raw values): sum_normalized_reward', NULL, NULL)
        ON CONFLICT(id) DO UPDATE SET key=EXCLUDED.key, description=EXCLUDED.description, agg_func=EXCLUDED.agg_func, agg_weights=EXCLUDED.agg_weights;

INSERT INTO field_definitions
        (id, key, description, agg_func, agg_weights)
        VALUES ('b5e06cc3-e58a-4812-8d26-a9600a38d798', 'success_rate', 'Secondary scenario score (raw values): success_rate', NULL, NULL)
        ON CONFLICT(id) DO UPDATE SET key=EXCLUDED.key, description=EXCLUDED.description, agg_func=EXCLUDED.agg_func, agg_weights=EXCLUDED.agg_weights;

INSERT INTO scenario_definitions
    (id, name, description, field_ids)
    VALUES ('11b19a5f-4d61-4b5d-980c-98cf0c16906a', 'Scenario 087 - Punctuality measures the percentage of trains arriving at their destinations on time (the train doesn’t arrive after planned arrival) and the train didn’t depart before planned departure time. The goal is to maintain a high level of reliability and minimize delays for passengers and freight services. ', 'This KPI contributes to evaluating Effectiveness of the AI-based assistant, as part of Task 4.1 evaluation objectives, and O2 main project objective:<br/>- Improve customer satisfaction by ensuring timely arrivals<br/>- Guarantee maximal planned connection<br/>- Minimize operational disruptions caused by delays<br/>- Meet regulatory and stakeholder benchmarks for punctuality<br/>This KPI is linked with project’s Long Term Expected Impacts (LTEI) (LTEI1)KPIS-3:<br/>- 10% increase in punctuality in long-range traffic<br/>- 5% increase in punctuality in regional traffic (with realistic disturbances)<br/>', array['f311b139-f2a6-4ced-92d7-3b78ab98489b', '3237bc4f-ccbc-4e7f-8f6c-caf4714ef7cf']::uuid[])
    ON CONFLICT(id) DO UPDATE SET name=EXCLUDED.name, description=EXCLUDED.description, field_ids=EXCLUDED.field_ids;

INSERT INTO field_definitions
        (id, key, description, agg_func, agg_weights)
        VALUES ('f311b139-f2a6-4ced-92d7-3b78ab98489b', 'sum_normalized_reward', 'Primary scenario score (raw values): sum_normalized_reward', NULL, NULL)
        ON CONFLICT(id) DO UPDATE SET key=EXCLUDED.key, description=EXCLUDED.description, agg_func=EXCLUDED.agg_func, agg_weights=EXCLUDED.agg_weights;

INSERT INTO field_definitions
        (id, key, description, agg_func, agg_weights)
        VALUES ('3237bc4f-ccbc-4e7f-8f6c-caf4714ef7cf', 'success_rate', 'Secondary scenario score (raw values): success_rate', NULL, NULL)
        ON CONFLICT(id) DO UPDATE SET key=EXCLUDED.key, description=EXCLUDED.description, agg_func=EXCLUDED.agg_func, agg_weights=EXCLUDED.agg_weights;

INSERT INTO scenario_definitions
    (id, name, description, field_ids)
    VALUES ('edecaeb7-53d3-411a-a00c-2ce6226fde50', 'Scenario 088 - Punctuality measures the percentage of trains arriving at their destinations on time (the train doesn’t arrive after planned arrival) and the train didn’t depart before planned departure time. The goal is to maintain a high level of reliability and minimize delays for passengers and freight services. ', 'This KPI contributes to evaluating Effectiveness of the AI-based assistant, as part of Task 4.1 evaluation objectives, and O2 main project objective:<br/>- Improve customer satisfaction by ensuring timely arrivals<br/>- Guarantee maximal planned connection<br/>- Minimize operational disruptions caused by delays<br/>- Meet regulatory and stakeholder benchmarks for punctuality<br/>This KPI is linked with project’s Long Term Expected Impacts (LTEI) (LTEI1)KPIS-3:<br/>- 10% increase in punctuality in long-range traffic<br/>- 5% increase in punctuality in regional traffic (with realistic disturbances)<br/>', array['1af0eb24-9d92-45d0-a831-eee57167229e', '6e7436e0-a6a8-47bc-8114-4419f1fbb550']::uuid[])
    ON CONFLICT(id) DO UPDATE SET name=EXCLUDED.name, description=EXCLUDED.description, field_ids=EXCLUDED.field_ids;

INSERT INTO field_definitions
        (id, key, description, agg_func, agg_weights)
        VALUES ('1af0eb24-9d92-45d0-a831-eee57167229e', 'sum_normalized_reward', 'Primary scenario score (raw values): sum_normalized_reward', NULL, NULL)
        ON CONFLICT(id) DO UPDATE SET key=EXCLUDED.key, description=EXCLUDED.description, agg_func=EXCLUDED.agg_func, agg_weights=EXCLUDED.agg_weights;

INSERT INTO field_definitions
        (id, key, description, agg_func, agg_weights)
        VALUES ('6e7436e0-a6a8-47bc-8114-4419f1fbb550', 'success_rate', 'Secondary scenario score (raw values): success_rate', NULL, NULL)
        ON CONFLICT(id) DO UPDATE SET key=EXCLUDED.key, description=EXCLUDED.description, agg_func=EXCLUDED.agg_func, agg_weights=EXCLUDED.agg_weights;

INSERT INTO scenario_definitions
    (id, name, description, field_ids)
    VALUES ('a43cb746-fa63-4d39-87cd-43a81fbf3a8e', 'Scenario 089 - Punctuality measures the percentage of trains arriving at their destinations on time (the train doesn’t arrive after planned arrival) and the train didn’t depart before planned departure time. The goal is to maintain a high level of reliability and minimize delays for passengers and freight services. ', 'This KPI contributes to evaluating Effectiveness of the AI-based assistant, as part of Task 4.1 evaluation objectives, and O2 main project objective:<br/>- Improve customer satisfaction by ensuring timely arrivals<br/>- Guarantee maximal planned connection<br/>- Minimize operational disruptions caused by delays<br/>- Meet regulatory and stakeholder benchmarks for punctuality<br/>This KPI is linked with project’s Long Term Expected Impacts (LTEI) (LTEI1)KPIS-3:<br/>- 10% increase in punctuality in long-range traffic<br/>- 5% increase in punctuality in regional traffic (with realistic disturbances)<br/>', array['900fe857-9f4f-4853-b307-dd1ea4b342af', '1b83fa6a-4d59-4da9-ad7e-f43a4ced795a']::uuid[])
    ON CONFLICT(id) DO UPDATE SET name=EXCLUDED.name, description=EXCLUDED.description, field_ids=EXCLUDED.field_ids;

INSERT INTO field_definitions
        (id, key, description, agg_func, agg_weights)
        VALUES ('900fe857-9f4f-4853-b307-dd1ea4b342af', 'sum_normalized_reward', 'Primary scenario score (raw values): sum_normalized_reward', NULL, NULL)
        ON CONFLICT(id) DO UPDATE SET key=EXCLUDED.key, description=EXCLUDED.description, agg_func=EXCLUDED.agg_func, agg_weights=EXCLUDED.agg_weights;

INSERT INTO field_definitions
        (id, key, description, agg_func, agg_weights)
        VALUES ('1b83fa6a-4d59-4da9-ad7e-f43a4ced795a', 'success_rate', 'Secondary scenario score (raw values): success_rate', NULL, NULL)
        ON CONFLICT(id) DO UPDATE SET key=EXCLUDED.key, description=EXCLUDED.description, agg_func=EXCLUDED.agg_func, agg_weights=EXCLUDED.agg_weights;

INSERT INTO scenario_definitions
    (id, name, description, field_ids)
    VALUES ('5a3cc8a5-584c-4171-ae2c-97bdbc5047a1', 'Scenario 090 - Punctuality measures the percentage of trains arriving at their destinations on time (the train doesn’t arrive after planned arrival) and the train didn’t depart before planned departure time. The goal is to maintain a high level of reliability and minimize delays for passengers and freight services. ', 'This KPI contributes to evaluating Effectiveness of the AI-based assistant, as part of Task 4.1 evaluation objectives, and O2 main project objective:<br/>- Improve customer satisfaction by ensuring timely arrivals<br/>- Guarantee maximal planned connection<br/>- Minimize operational disruptions caused by delays<br/>- Meet regulatory and stakeholder benchmarks for punctuality<br/>This KPI is linked with project’s Long Term Expected Impacts (LTEI) (LTEI1)KPIS-3:<br/>- 10% increase in punctuality in long-range traffic<br/>- 5% increase in punctuality in regional traffic (with realistic disturbances)<br/>', array['cd689619-3e99-477f-985d-367defa37a8f', 'f7374452-2699-4562-8c9d-f98f187caca0']::uuid[])
    ON CONFLICT(id) DO UPDATE SET name=EXCLUDED.name, description=EXCLUDED.description, field_ids=EXCLUDED.field_ids;

INSERT INTO field_definitions
        (id, key, description, agg_func, agg_weights)
        VALUES ('cd689619-3e99-477f-985d-367defa37a8f', 'sum_normalized_reward', 'Primary scenario score (raw values): sum_normalized_reward', NULL, NULL)
        ON CONFLICT(id) DO UPDATE SET key=EXCLUDED.key, description=EXCLUDED.description, agg_func=EXCLUDED.agg_func, agg_weights=EXCLUDED.agg_weights;

INSERT INTO field_definitions
        (id, key, description, agg_func, agg_weights)
        VALUES ('f7374452-2699-4562-8c9d-f98f187caca0', 'success_rate', 'Secondary scenario score (raw values): success_rate', NULL, NULL)
        ON CONFLICT(id) DO UPDATE SET key=EXCLUDED.key, description=EXCLUDED.description, agg_func=EXCLUDED.agg_func, agg_weights=EXCLUDED.agg_weights;

INSERT INTO scenario_definitions
    (id, name, description, field_ids)
    VALUES ('30778350-508b-4cbe-bff2-8882d0743aed', 'Scenario 091 - Punctuality measures the percentage of trains arriving at their destinations on time (the train doesn’t arrive after planned arrival) and the train didn’t depart before planned departure time. The goal is to maintain a high level of reliability and minimize delays for passengers and freight services. ', 'This KPI contributes to evaluating Effectiveness of the AI-based assistant, as part of Task 4.1 evaluation objectives, and O2 main project objective:<br/>- Improve customer satisfaction by ensuring timely arrivals<br/>- Guarantee maximal planned connection<br/>- Minimize operational disruptions caused by delays<br/>- Meet regulatory and stakeholder benchmarks for punctuality<br/>This KPI is linked with project’s Long Term Expected Impacts (LTEI) (LTEI1)KPIS-3:<br/>- 10% increase in punctuality in long-range traffic<br/>- 5% increase in punctuality in regional traffic (with realistic disturbances)<br/>', array['705f3ef5-f3e0-48c8-a653-a2fc0c97c205', '7b437484-d4be-4772-95cf-a4c7c66c0ff7']::uuid[])
    ON CONFLICT(id) DO UPDATE SET name=EXCLUDED.name, description=EXCLUDED.description, field_ids=EXCLUDED.field_ids;

INSERT INTO field_definitions
        (id, key, description, agg_func, agg_weights)
        VALUES ('705f3ef5-f3e0-48c8-a653-a2fc0c97c205', 'sum_normalized_reward', 'Primary scenario score (raw values): sum_normalized_reward', NULL, NULL)
        ON CONFLICT(id) DO UPDATE SET key=EXCLUDED.key, description=EXCLUDED.description, agg_func=EXCLUDED.agg_func, agg_weights=EXCLUDED.agg_weights;

INSERT INTO field_definitions
        (id, key, description, agg_func, agg_weights)
        VALUES ('7b437484-d4be-4772-95cf-a4c7c66c0ff7', 'success_rate', 'Secondary scenario score (raw values): success_rate', NULL, NULL)
        ON CONFLICT(id) DO UPDATE SET key=EXCLUDED.key, description=EXCLUDED.description, agg_func=EXCLUDED.agg_func, agg_weights=EXCLUDED.agg_weights;

INSERT INTO scenario_definitions
    (id, name, description, field_ids)
    VALUES ('dc652dd4-c0b5-4036-bb70-f71cd9fd488a', 'Scenario 092 - Punctuality measures the percentage of trains arriving at their destinations on time (the train doesn’t arrive after planned arrival) and the train didn’t depart before planned departure time. The goal is to maintain a high level of reliability and minimize delays for passengers and freight services. ', 'This KPI contributes to evaluating Effectiveness of the AI-based assistant, as part of Task 4.1 evaluation objectives, and O2 main project objective:<br/>- Improve customer satisfaction by ensuring timely arrivals<br/>- Guarantee maximal planned connection<br/>- Minimize operational disruptions caused by delays<br/>- Meet regulatory and stakeholder benchmarks for punctuality<br/>This KPI is linked with project’s Long Term Expected Impacts (LTEI) (LTEI1)KPIS-3:<br/>- 10% increase in punctuality in long-range traffic<br/>- 5% increase in punctuality in regional traffic (with realistic disturbances)<br/>', array['a3c43c85-ae7c-4450-8e03-902008ed9ecd', 'aaafe206-b2c7-4ec8-a625-e8e9bddc84b3']::uuid[])
    ON CONFLICT(id) DO UPDATE SET name=EXCLUDED.name, description=EXCLUDED.description, field_ids=EXCLUDED.field_ids;

INSERT INTO field_definitions
        (id, key, description, agg_func, agg_weights)
        VALUES ('a3c43c85-ae7c-4450-8e03-902008ed9ecd', 'sum_normalized_reward', 'Primary scenario score (raw values): sum_normalized_reward', NULL, NULL)
        ON CONFLICT(id) DO UPDATE SET key=EXCLUDED.key, description=EXCLUDED.description, agg_func=EXCLUDED.agg_func, agg_weights=EXCLUDED.agg_weights;

INSERT INTO field_definitions
        (id, key, description, agg_func, agg_weights)
        VALUES ('aaafe206-b2c7-4ec8-a625-e8e9bddc84b3', 'success_rate', 'Secondary scenario score (raw values): success_rate', NULL, NULL)
        ON CONFLICT(id) DO UPDATE SET key=EXCLUDED.key, description=EXCLUDED.description, agg_func=EXCLUDED.agg_func, agg_weights=EXCLUDED.agg_weights;

INSERT INTO scenario_definitions
    (id, name, description, field_ids)
    VALUES ('6e4dd7f4-2155-407f-922b-25aeb04a47b7', 'Scenario 093 - Punctuality measures the percentage of trains arriving at their destinations on time (the train doesn’t arrive after planned arrival) and the train didn’t depart before planned departure time. The goal is to maintain a high level of reliability and minimize delays for passengers and freight services. ', 'This KPI contributes to evaluating Effectiveness of the AI-based assistant, as part of Task 4.1 evaluation objectives, and O2 main project objective:<br/>- Improve customer satisfaction by ensuring timely arrivals<br/>- Guarantee maximal planned connection<br/>- Minimize operational disruptions caused by delays<br/>- Meet regulatory and stakeholder benchmarks for punctuality<br/>This KPI is linked with project’s Long Term Expected Impacts (LTEI) (LTEI1)KPIS-3:<br/>- 10% increase in punctuality in long-range traffic<br/>- 5% increase in punctuality in regional traffic (with realistic disturbances)<br/>', array['ccaa7ea3-7ace-4443-999b-970267108cbe', 'ff7f3ffb-e170-4385-b853-91a7c1b924a8']::uuid[])
    ON CONFLICT(id) DO UPDATE SET name=EXCLUDED.name, description=EXCLUDED.description, field_ids=EXCLUDED.field_ids;

INSERT INTO field_definitions
        (id, key, description, agg_func, agg_weights)
        VALUES ('ccaa7ea3-7ace-4443-999b-970267108cbe', 'sum_normalized_reward', 'Primary scenario score (raw values): sum_normalized_reward', NULL, NULL)
        ON CONFLICT(id) DO UPDATE SET key=EXCLUDED.key, description=EXCLUDED.description, agg_func=EXCLUDED.agg_func, agg_weights=EXCLUDED.agg_weights;

INSERT INTO field_definitions
        (id, key, description, agg_func, agg_weights)
        VALUES ('ff7f3ffb-e170-4385-b853-91a7c1b924a8', 'success_rate', 'Secondary scenario score (raw values): success_rate', NULL, NULL)
        ON CONFLICT(id) DO UPDATE SET key=EXCLUDED.key, description=EXCLUDED.description, agg_func=EXCLUDED.agg_func, agg_weights=EXCLUDED.agg_weights;

INSERT INTO scenario_definitions
    (id, name, description, field_ids)
    VALUES ('ba75d8cb-bfb9-4d2b-ac2f-2b5b8697188c', 'Scenario 094 - Punctuality measures the percentage of trains arriving at their destinations on time (the train doesn’t arrive after planned arrival) and the train didn’t depart before planned departure time. The goal is to maintain a high level of reliability and minimize delays for passengers and freight services. ', 'This KPI contributes to evaluating Effectiveness of the AI-based assistant, as part of Task 4.1 evaluation objectives, and O2 main project objective:<br/>- Improve customer satisfaction by ensuring timely arrivals<br/>- Guarantee maximal planned connection<br/>- Minimize operational disruptions caused by delays<br/>- Meet regulatory and stakeholder benchmarks for punctuality<br/>This KPI is linked with project’s Long Term Expected Impacts (LTEI) (LTEI1)KPIS-3:<br/>- 10% increase in punctuality in long-range traffic<br/>- 5% increase in punctuality in regional traffic (with realistic disturbances)<br/>', array['84657cdf-99d3-4464-8c10-6f0ea9ec0f85', '05b2fe66-9118-4489-92a6-0b4784c1a666']::uuid[])
    ON CONFLICT(id) DO UPDATE SET name=EXCLUDED.name, description=EXCLUDED.description, field_ids=EXCLUDED.field_ids;

INSERT INTO field_definitions
        (id, key, description, agg_func, agg_weights)
        VALUES ('84657cdf-99d3-4464-8c10-6f0ea9ec0f85', 'sum_normalized_reward', 'Primary scenario score (raw values): sum_normalized_reward', NULL, NULL)
        ON CONFLICT(id) DO UPDATE SET key=EXCLUDED.key, description=EXCLUDED.description, agg_func=EXCLUDED.agg_func, agg_weights=EXCLUDED.agg_weights;

INSERT INTO field_definitions
        (id, key, description, agg_func, agg_weights)
        VALUES ('05b2fe66-9118-4489-92a6-0b4784c1a666', 'success_rate', 'Secondary scenario score (raw values): success_rate', NULL, NULL)
        ON CONFLICT(id) DO UPDATE SET key=EXCLUDED.key, description=EXCLUDED.description, agg_func=EXCLUDED.agg_func, agg_weights=EXCLUDED.agg_weights;

INSERT INTO scenario_definitions
    (id, name, description, field_ids)
    VALUES ('10c621d6-1f99-4045-82a0-47d3ea107ddc', 'Scenario 095 - Punctuality measures the percentage of trains arriving at their destinations on time (the train doesn’t arrive after planned arrival) and the train didn’t depart before planned departure time. The goal is to maintain a high level of reliability and minimize delays for passengers and freight services. ', 'This KPI contributes to evaluating Effectiveness of the AI-based assistant, as part of Task 4.1 evaluation objectives, and O2 main project objective:<br/>- Improve customer satisfaction by ensuring timely arrivals<br/>- Guarantee maximal planned connection<br/>- Minimize operational disruptions caused by delays<br/>- Meet regulatory and stakeholder benchmarks for punctuality<br/>This KPI is linked with project’s Long Term Expected Impacts (LTEI) (LTEI1)KPIS-3:<br/>- 10% increase in punctuality in long-range traffic<br/>- 5% increase in punctuality in regional traffic (with realistic disturbances)<br/>', array['6865dac9-35ef-4d63-87d6-bd82d70ff8d8', '2efa40cd-884e-400a-b7c8-608d1a186b7d']::uuid[])
    ON CONFLICT(id) DO UPDATE SET name=EXCLUDED.name, description=EXCLUDED.description, field_ids=EXCLUDED.field_ids;

INSERT INTO field_definitions
        (id, key, description, agg_func, agg_weights)
        VALUES ('6865dac9-35ef-4d63-87d6-bd82d70ff8d8', 'sum_normalized_reward', 'Primary scenario score (raw values): sum_normalized_reward', NULL, NULL)
        ON CONFLICT(id) DO UPDATE SET key=EXCLUDED.key, description=EXCLUDED.description, agg_func=EXCLUDED.agg_func, agg_weights=EXCLUDED.agg_weights;

INSERT INTO field_definitions
        (id, key, description, agg_func, agg_weights)
        VALUES ('2efa40cd-884e-400a-b7c8-608d1a186b7d', 'success_rate', 'Secondary scenario score (raw values): success_rate', NULL, NULL)
        ON CONFLICT(id) DO UPDATE SET key=EXCLUDED.key, description=EXCLUDED.description, agg_func=EXCLUDED.agg_func, agg_weights=EXCLUDED.agg_weights;

INSERT INTO scenario_definitions
    (id, name, description, field_ids)
    VALUES ('7a6b6aeb-af0e-441f-97b5-d5db846bb045', 'Scenario 096 - Punctuality measures the percentage of trains arriving at their destinations on time (the train doesn’t arrive after planned arrival) and the train didn’t depart before planned departure time. The goal is to maintain a high level of reliability and minimize delays for passengers and freight services. ', 'This KPI contributes to evaluating Effectiveness of the AI-based assistant, as part of Task 4.1 evaluation objectives, and O2 main project objective:<br/>- Improve customer satisfaction by ensuring timely arrivals<br/>- Guarantee maximal planned connection<br/>- Minimize operational disruptions caused by delays<br/>- Meet regulatory and stakeholder benchmarks for punctuality<br/>This KPI is linked with project’s Long Term Expected Impacts (LTEI) (LTEI1)KPIS-3:<br/>- 10% increase in punctuality in long-range traffic<br/>- 5% increase in punctuality in regional traffic (with realistic disturbances)<br/>', array['d7d737b8-945c-4551-a685-5dbb70e10977', 'a998e19a-299f-4ae9-9ae5-a540974541ef']::uuid[])
    ON CONFLICT(id) DO UPDATE SET name=EXCLUDED.name, description=EXCLUDED.description, field_ids=EXCLUDED.field_ids;

INSERT INTO field_definitions
        (id, key, description, agg_func, agg_weights)
        VALUES ('d7d737b8-945c-4551-a685-5dbb70e10977', 'sum_normalized_reward', 'Primary scenario score (raw values): sum_normalized_reward', NULL, NULL)
        ON CONFLICT(id) DO UPDATE SET key=EXCLUDED.key, description=EXCLUDED.description, agg_func=EXCLUDED.agg_func, agg_weights=EXCLUDED.agg_weights;

INSERT INTO field_definitions
        (id, key, description, agg_func, agg_weights)
        VALUES ('a998e19a-299f-4ae9-9ae5-a540974541ef', 'success_rate', 'Secondary scenario score (raw values): success_rate', NULL, NULL)
        ON CONFLICT(id) DO UPDATE SET key=EXCLUDED.key, description=EXCLUDED.description, agg_func=EXCLUDED.agg_func, agg_weights=EXCLUDED.agg_weights;

INSERT INTO scenario_definitions
    (id, name, description, field_ids)
    VALUES ('8e2cfb59-d31b-4346-b67a-b96a12ca04f5', 'Scenario 097 - Punctuality measures the percentage of trains arriving at their destinations on time (the train doesn’t arrive after planned arrival) and the train didn’t depart before planned departure time. The goal is to maintain a high level of reliability and minimize delays for passengers and freight services. ', 'This KPI contributes to evaluating Effectiveness of the AI-based assistant, as part of Task 4.1 evaluation objectives, and O2 main project objective:<br/>- Improve customer satisfaction by ensuring timely arrivals<br/>- Guarantee maximal planned connection<br/>- Minimize operational disruptions caused by delays<br/>- Meet regulatory and stakeholder benchmarks for punctuality<br/>This KPI is linked with project’s Long Term Expected Impacts (LTEI) (LTEI1)KPIS-3:<br/>- 10% increase in punctuality in long-range traffic<br/>- 5% increase in punctuality in regional traffic (with realistic disturbances)<br/>', array['db6d2012-322d-4bf7-baf2-cce3112bb836', 'b0456e19-c198-41f6-9ef1-754df0f8b6c3']::uuid[])
    ON CONFLICT(id) DO UPDATE SET name=EXCLUDED.name, description=EXCLUDED.description, field_ids=EXCLUDED.field_ids;

INSERT INTO field_definitions
        (id, key, description, agg_func, agg_weights)
        VALUES ('db6d2012-322d-4bf7-baf2-cce3112bb836', 'sum_normalized_reward', 'Primary scenario score (raw values): sum_normalized_reward', NULL, NULL)
        ON CONFLICT(id) DO UPDATE SET key=EXCLUDED.key, description=EXCLUDED.description, agg_func=EXCLUDED.agg_func, agg_weights=EXCLUDED.agg_weights;

INSERT INTO field_definitions
        (id, key, description, agg_func, agg_weights)
        VALUES ('b0456e19-c198-41f6-9ef1-754df0f8b6c3', 'success_rate', 'Secondary scenario score (raw values): success_rate', NULL, NULL)
        ON CONFLICT(id) DO UPDATE SET key=EXCLUDED.key, description=EXCLUDED.description, agg_func=EXCLUDED.agg_func, agg_weights=EXCLUDED.agg_weights;

INSERT INTO scenario_definitions
    (id, name, description, field_ids)
    VALUES ('2661fcc0-9b3c-45bd-b60e-3c6351acabd1', 'Scenario 098 - Punctuality measures the percentage of trains arriving at their destinations on time (the train doesn’t arrive after planned arrival) and the train didn’t depart before planned departure time. The goal is to maintain a high level of reliability and minimize delays for passengers and freight services. ', 'This KPI contributes to evaluating Effectiveness of the AI-based assistant, as part of Task 4.1 evaluation objectives, and O2 main project objective:<br/>- Improve customer satisfaction by ensuring timely arrivals<br/>- Guarantee maximal planned connection<br/>- Minimize operational disruptions caused by delays<br/>- Meet regulatory and stakeholder benchmarks for punctuality<br/>This KPI is linked with project’s Long Term Expected Impacts (LTEI) (LTEI1)KPIS-3:<br/>- 10% increase in punctuality in long-range traffic<br/>- 5% increase in punctuality in regional traffic (with realistic disturbances)<br/>', array['47195740-d89c-4b17-ac22-bb017ecf5216', '0f46f7a2-d968-4719-bee9-1b1c1f102169']::uuid[])
    ON CONFLICT(id) DO UPDATE SET name=EXCLUDED.name, description=EXCLUDED.description, field_ids=EXCLUDED.field_ids;

INSERT INTO field_definitions
        (id, key, description, agg_func, agg_weights)
        VALUES ('47195740-d89c-4b17-ac22-bb017ecf5216', 'sum_normalized_reward', 'Primary scenario score (raw values): sum_normalized_reward', NULL, NULL)
        ON CONFLICT(id) DO UPDATE SET key=EXCLUDED.key, description=EXCLUDED.description, agg_func=EXCLUDED.agg_func, agg_weights=EXCLUDED.agg_weights;

INSERT INTO field_definitions
        (id, key, description, agg_func, agg_weights)
        VALUES ('0f46f7a2-d968-4719-bee9-1b1c1f102169', 'success_rate', 'Secondary scenario score (raw values): success_rate', NULL, NULL)
        ON CONFLICT(id) DO UPDATE SET key=EXCLUDED.key, description=EXCLUDED.description, agg_func=EXCLUDED.agg_func, agg_weights=EXCLUDED.agg_weights;

INSERT INTO scenario_definitions
    (id, name, description, field_ids)
    VALUES ('efcce7b2-e33a-4510-af56-09db1bfb5bd0', 'Scenario 099 - Punctuality measures the percentage of trains arriving at their destinations on time (the train doesn’t arrive after planned arrival) and the train didn’t depart before planned departure time. The goal is to maintain a high level of reliability and minimize delays for passengers and freight services. ', 'This KPI contributes to evaluating Effectiveness of the AI-based assistant, as part of Task 4.1 evaluation objectives, and O2 main project objective:<br/>- Improve customer satisfaction by ensuring timely arrivals<br/>- Guarantee maximal planned connection<br/>- Minimize operational disruptions caused by delays<br/>- Meet regulatory and stakeholder benchmarks for punctuality<br/>This KPI is linked with project’s Long Term Expected Impacts (LTEI) (LTEI1)KPIS-3:<br/>- 10% increase in punctuality in long-range traffic<br/>- 5% increase in punctuality in regional traffic (with realistic disturbances)<br/>', array['c5ef1284-4ced-423e-85b8-e71eef9a710f', '9167c4a3-e6fd-41fb-9ac6-61d5bd16daae']::uuid[])
    ON CONFLICT(id) DO UPDATE SET name=EXCLUDED.name, description=EXCLUDED.description, field_ids=EXCLUDED.field_ids;

INSERT INTO field_definitions
        (id, key, description, agg_func, agg_weights)
        VALUES ('c5ef1284-4ced-423e-85b8-e71eef9a710f', 'sum_normalized_reward', 'Primary scenario score (raw values): sum_normalized_reward', NULL, NULL)
        ON CONFLICT(id) DO UPDATE SET key=EXCLUDED.key, description=EXCLUDED.description, agg_func=EXCLUDED.agg_func, agg_weights=EXCLUDED.agg_weights;

INSERT INTO field_definitions
        (id, key, description, agg_func, agg_weights)
        VALUES ('9167c4a3-e6fd-41fb-9ac6-61d5bd16daae', 'success_rate', 'Secondary scenario score (raw values): success_rate', NULL, NULL)
        ON CONFLICT(id) DO UPDATE SET key=EXCLUDED.key, description=EXCLUDED.description, agg_func=EXCLUDED.agg_func, agg_weights=EXCLUDED.agg_weights;

INSERT INTO scenario_definitions
    (id, name, description, field_ids)
    VALUES ('c643a6ba-a8a3-42de-afcc-fa92328397b7', 'Scenario 100 - Punctuality measures the percentage of trains arriving at their destinations on time (the train doesn’t arrive after planned arrival) and the train didn’t depart before planned departure time. The goal is to maintain a high level of reliability and minimize delays for passengers and freight services. ', 'This KPI contributes to evaluating Effectiveness of the AI-based assistant, as part of Task 4.1 evaluation objectives, and O2 main project objective:<br/>- Improve customer satisfaction by ensuring timely arrivals<br/>- Guarantee maximal planned connection<br/>- Minimize operational disruptions caused by delays<br/>- Meet regulatory and stakeholder benchmarks for punctuality<br/>This KPI is linked with project’s Long Term Expected Impacts (LTEI) (LTEI1)KPIS-3:<br/>- 10% increase in punctuality in long-range traffic<br/>- 5% increase in punctuality in regional traffic (with realistic disturbances)<br/>', array['d27eb381-c125-43df-8804-011cc46295b0', 'df586b32-0f78-461b-af4f-44851a3e3009']::uuid[])
    ON CONFLICT(id) DO UPDATE SET name=EXCLUDED.name, description=EXCLUDED.description, field_ids=EXCLUDED.field_ids;

INSERT INTO field_definitions
        (id, key, description, agg_func, agg_weights)
        VALUES ('d27eb381-c125-43df-8804-011cc46295b0', 'sum_normalized_reward', 'Primary scenario score (raw values): sum_normalized_reward', NULL, NULL)
        ON CONFLICT(id) DO UPDATE SET key=EXCLUDED.key, description=EXCLUDED.description, agg_func=EXCLUDED.agg_func, agg_weights=EXCLUDED.agg_weights;

INSERT INTO field_definitions
        (id, key, description, agg_func, agg_weights)
        VALUES ('df586b32-0f78-461b-af4f-44851a3e3009', 'success_rate', 'Secondary scenario score (raw values): success_rate', NULL, NULL)
        ON CONFLICT(id) DO UPDATE SET key=EXCLUDED.key, description=EXCLUDED.description, agg_func=EXCLUDED.agg_func, agg_weights=EXCLUDED.agg_weights;

INSERT INTO scenario_definitions
    (id, name, description, field_ids)
    VALUES ('86c8d140-2b1d-41df-ba97-a959c54d2c19', 'Scenario 101 - Punctuality measures the percentage of trains arriving at their destinations on time (the train doesn’t arrive after planned arrival) and the train didn’t depart before planned departure time. The goal is to maintain a high level of reliability and minimize delays for passengers and freight services. ', 'This KPI contributes to evaluating Effectiveness of the AI-based assistant, as part of Task 4.1 evaluation objectives, and O2 main project objective:<br/>- Improve customer satisfaction by ensuring timely arrivals<br/>- Guarantee maximal planned connection<br/>- Minimize operational disruptions caused by delays<br/>- Meet regulatory and stakeholder benchmarks for punctuality<br/>This KPI is linked with project’s Long Term Expected Impacts (LTEI) (LTEI1)KPIS-3:<br/>- 10% increase in punctuality in long-range traffic<br/>- 5% increase in punctuality in regional traffic (with realistic disturbances)<br/>', array['494f08f4-1c11-4f17-a724-c3473a97b38c', 'f9460f21-c236-4fad-8699-a5c802436f92']::uuid[])
    ON CONFLICT(id) DO UPDATE SET name=EXCLUDED.name, description=EXCLUDED.description, field_ids=EXCLUDED.field_ids;

INSERT INTO field_definitions
        (id, key, description, agg_func, agg_weights)
        VALUES ('494f08f4-1c11-4f17-a724-c3473a97b38c', 'sum_normalized_reward', 'Primary scenario score (raw values): sum_normalized_reward', NULL, NULL)
        ON CONFLICT(id) DO UPDATE SET key=EXCLUDED.key, description=EXCLUDED.description, agg_func=EXCLUDED.agg_func, agg_weights=EXCLUDED.agg_weights;

INSERT INTO field_definitions
        (id, key, description, agg_func, agg_weights)
        VALUES ('f9460f21-c236-4fad-8699-a5c802436f92', 'success_rate', 'Secondary scenario score (raw values): success_rate', NULL, NULL)
        ON CONFLICT(id) DO UPDATE SET key=EXCLUDED.key, description=EXCLUDED.description, agg_func=EXCLUDED.agg_func, agg_weights=EXCLUDED.agg_weights;

INSERT INTO scenario_definitions
    (id, name, description, field_ids)
    VALUES ('9826d43a-6be2-49ac-bfd7-fa2475f62985', 'Scenario 102 - Punctuality measures the percentage of trains arriving at their destinations on time (the train doesn’t arrive after planned arrival) and the train didn’t depart before planned departure time. The goal is to maintain a high level of reliability and minimize delays for passengers and freight services. ', 'This KPI contributes to evaluating Effectiveness of the AI-based assistant, as part of Task 4.1 evaluation objectives, and O2 main project objective:<br/>- Improve customer satisfaction by ensuring timely arrivals<br/>- Guarantee maximal planned connection<br/>- Minimize operational disruptions caused by delays<br/>- Meet regulatory and stakeholder benchmarks for punctuality<br/>This KPI is linked with project’s Long Term Expected Impacts (LTEI) (LTEI1)KPIS-3:<br/>- 10% increase in punctuality in long-range traffic<br/>- 5% increase in punctuality in regional traffic (with realistic disturbances)<br/>', array['a05fc857-eb3d-49ee-9664-c5c978fbb80c', '1f5328d6-5b32-46b8-bb4f-aed1a9e08f8b']::uuid[])
    ON CONFLICT(id) DO UPDATE SET name=EXCLUDED.name, description=EXCLUDED.description, field_ids=EXCLUDED.field_ids;

INSERT INTO field_definitions
        (id, key, description, agg_func, agg_weights)
        VALUES ('a05fc857-eb3d-49ee-9664-c5c978fbb80c', 'sum_normalized_reward', 'Primary scenario score (raw values): sum_normalized_reward', NULL, NULL)
        ON CONFLICT(id) DO UPDATE SET key=EXCLUDED.key, description=EXCLUDED.description, agg_func=EXCLUDED.agg_func, agg_weights=EXCLUDED.agg_weights;

INSERT INTO field_definitions
        (id, key, description, agg_func, agg_weights)
        VALUES ('1f5328d6-5b32-46b8-bb4f-aed1a9e08f8b', 'success_rate', 'Secondary scenario score (raw values): success_rate', NULL, NULL)
        ON CONFLICT(id) DO UPDATE SET key=EXCLUDED.key, description=EXCLUDED.description, agg_func=EXCLUDED.agg_func, agg_weights=EXCLUDED.agg_weights;

INSERT INTO scenario_definitions
    (id, name, description, field_ids)
    VALUES ('151f38af-a59a-42f8-9b2e-2df3fef3f658', 'Scenario 103 - Punctuality measures the percentage of trains arriving at their destinations on time (the train doesn’t arrive after planned arrival) and the train didn’t depart before planned departure time. The goal is to maintain a high level of reliability and minimize delays for passengers and freight services. ', 'This KPI contributes to evaluating Effectiveness of the AI-based assistant, as part of Task 4.1 evaluation objectives, and O2 main project objective:<br/>- Improve customer satisfaction by ensuring timely arrivals<br/>- Guarantee maximal planned connection<br/>- Minimize operational disruptions caused by delays<br/>- Meet regulatory and stakeholder benchmarks for punctuality<br/>This KPI is linked with project’s Long Term Expected Impacts (LTEI) (LTEI1)KPIS-3:<br/>- 10% increase in punctuality in long-range traffic<br/>- 5% increase in punctuality in regional traffic (with realistic disturbances)<br/>', array['4cfef0d1-2465-450c-b937-919985b7dd53', '503c6230-a376-4c08-941f-e2cf5cdff362']::uuid[])
    ON CONFLICT(id) DO UPDATE SET name=EXCLUDED.name, description=EXCLUDED.description, field_ids=EXCLUDED.field_ids;

INSERT INTO field_definitions
        (id, key, description, agg_func, agg_weights)
        VALUES ('4cfef0d1-2465-450c-b937-919985b7dd53', 'sum_normalized_reward', 'Primary scenario score (raw values): sum_normalized_reward', NULL, NULL)
        ON CONFLICT(id) DO UPDATE SET key=EXCLUDED.key, description=EXCLUDED.description, agg_func=EXCLUDED.agg_func, agg_weights=EXCLUDED.agg_weights;

INSERT INTO field_definitions
        (id, key, description, agg_func, agg_weights)
        VALUES ('503c6230-a376-4c08-941f-e2cf5cdff362', 'success_rate', 'Secondary scenario score (raw values): success_rate', NULL, NULL)
        ON CONFLICT(id) DO UPDATE SET key=EXCLUDED.key, description=EXCLUDED.description, agg_func=EXCLUDED.agg_func, agg_weights=EXCLUDED.agg_weights;

INSERT INTO scenario_definitions
    (id, name, description, field_ids)
    VALUES ('5b7b42ed-e41a-4e97-806a-6287ac918537', 'Scenario 104 - Punctuality measures the percentage of trains arriving at their destinations on time (the train doesn’t arrive after planned arrival) and the train didn’t depart before planned departure time. The goal is to maintain a high level of reliability and minimize delays for passengers and freight services. ', 'This KPI contributes to evaluating Effectiveness of the AI-based assistant, as part of Task 4.1 evaluation objectives, and O2 main project objective:<br/>- Improve customer satisfaction by ensuring timely arrivals<br/>- Guarantee maximal planned connection<br/>- Minimize operational disruptions caused by delays<br/>- Meet regulatory and stakeholder benchmarks for punctuality<br/>This KPI is linked with project’s Long Term Expected Impacts (LTEI) (LTEI1)KPIS-3:<br/>- 10% increase in punctuality in long-range traffic<br/>- 5% increase in punctuality in regional traffic (with realistic disturbances)<br/>', array['8bb05d08-6b4b-4caa-bda7-95a21c0621e0', '6fdcb499-5d2f-4ede-89ef-fa7f2dd1458b']::uuid[])
    ON CONFLICT(id) DO UPDATE SET name=EXCLUDED.name, description=EXCLUDED.description, field_ids=EXCLUDED.field_ids;

INSERT INTO field_definitions
        (id, key, description, agg_func, agg_weights)
        VALUES ('8bb05d08-6b4b-4caa-bda7-95a21c0621e0', 'sum_normalized_reward', 'Primary scenario score (raw values): sum_normalized_reward', NULL, NULL)
        ON CONFLICT(id) DO UPDATE SET key=EXCLUDED.key, description=EXCLUDED.description, agg_func=EXCLUDED.agg_func, agg_weights=EXCLUDED.agg_weights;

INSERT INTO field_definitions
        (id, key, description, agg_func, agg_weights)
        VALUES ('6fdcb499-5d2f-4ede-89ef-fa7f2dd1458b', 'success_rate', 'Secondary scenario score (raw values): success_rate', NULL, NULL)
        ON CONFLICT(id) DO UPDATE SET key=EXCLUDED.key, description=EXCLUDED.description, agg_func=EXCLUDED.agg_func, agg_weights=EXCLUDED.agg_weights;

INSERT INTO scenario_definitions
    (id, name, description, field_ids)
    VALUES ('d897ffe6-43a8-4ebc-9881-6097be7711e7', 'Scenario 105 - Punctuality measures the percentage of trains arriving at their destinations on time (the train doesn’t arrive after planned arrival) and the train didn’t depart before planned departure time. The goal is to maintain a high level of reliability and minimize delays for passengers and freight services. ', 'This KPI contributes to evaluating Effectiveness of the AI-based assistant, as part of Task 4.1 evaluation objectives, and O2 main project objective:<br/>- Improve customer satisfaction by ensuring timely arrivals<br/>- Guarantee maximal planned connection<br/>- Minimize operational disruptions caused by delays<br/>- Meet regulatory and stakeholder benchmarks for punctuality<br/>This KPI is linked with project’s Long Term Expected Impacts (LTEI) (LTEI1)KPIS-3:<br/>- 10% increase in punctuality in long-range traffic<br/>- 5% increase in punctuality in regional traffic (with realistic disturbances)<br/>', array['fc8cf3fb-4d39-401c-b926-c106a1985dd9', 'a953ffde-862d-45b3-98e6-a96ee8ce7c26']::uuid[])
    ON CONFLICT(id) DO UPDATE SET name=EXCLUDED.name, description=EXCLUDED.description, field_ids=EXCLUDED.field_ids;

INSERT INTO field_definitions
        (id, key, description, agg_func, agg_weights)
        VALUES ('fc8cf3fb-4d39-401c-b926-c106a1985dd9', 'sum_normalized_reward', 'Primary scenario score (raw values): sum_normalized_reward', NULL, NULL)
        ON CONFLICT(id) DO UPDATE SET key=EXCLUDED.key, description=EXCLUDED.description, agg_func=EXCLUDED.agg_func, agg_weights=EXCLUDED.agg_weights;

INSERT INTO field_definitions
        (id, key, description, agg_func, agg_weights)
        VALUES ('a953ffde-862d-45b3-98e6-a96ee8ce7c26', 'success_rate', 'Secondary scenario score (raw values): success_rate', NULL, NULL)
        ON CONFLICT(id) DO UPDATE SET key=EXCLUDED.key, description=EXCLUDED.description, agg_func=EXCLUDED.agg_func, agg_weights=EXCLUDED.agg_weights;

INSERT INTO scenario_definitions
    (id, name, description, field_ids)
    VALUES ('95aa9a6b-b80a-4dcc-a0a4-228f53bc7959', 'Scenario 106 - Punctuality measures the percentage of trains arriving at their destinations on time (the train doesn’t arrive after planned arrival) and the train didn’t depart before planned departure time. The goal is to maintain a high level of reliability and minimize delays for passengers and freight services. ', 'This KPI contributes to evaluating Effectiveness of the AI-based assistant, as part of Task 4.1 evaluation objectives, and O2 main project objective:<br/>- Improve customer satisfaction by ensuring timely arrivals<br/>- Guarantee maximal planned connection<br/>- Minimize operational disruptions caused by delays<br/>- Meet regulatory and stakeholder benchmarks for punctuality<br/>This KPI is linked with project’s Long Term Expected Impacts (LTEI) (LTEI1)KPIS-3:<br/>- 10% increase in punctuality in long-range traffic<br/>- 5% increase in punctuality in regional traffic (with realistic disturbances)<br/>', array['3e2dfea9-609e-44f2-b18f-33ec40524833', '36cea940-cd27-4ae3-9b34-6129b20e558c']::uuid[])
    ON CONFLICT(id) DO UPDATE SET name=EXCLUDED.name, description=EXCLUDED.description, field_ids=EXCLUDED.field_ids;

INSERT INTO field_definitions
        (id, key, description, agg_func, agg_weights)
        VALUES ('3e2dfea9-609e-44f2-b18f-33ec40524833', 'sum_normalized_reward', 'Primary scenario score (raw values): sum_normalized_reward', NULL, NULL)
        ON CONFLICT(id) DO UPDATE SET key=EXCLUDED.key, description=EXCLUDED.description, agg_func=EXCLUDED.agg_func, agg_weights=EXCLUDED.agg_weights;

INSERT INTO field_definitions
        (id, key, description, agg_func, agg_weights)
        VALUES ('36cea940-cd27-4ae3-9b34-6129b20e558c', 'success_rate', 'Secondary scenario score (raw values): success_rate', NULL, NULL)
        ON CONFLICT(id) DO UPDATE SET key=EXCLUDED.key, description=EXCLUDED.description, agg_func=EXCLUDED.agg_func, agg_weights=EXCLUDED.agg_weights;

INSERT INTO scenario_definitions
    (id, name, description, field_ids)
    VALUES ('0330f00b-412e-44d5-b7cc-23bebd26fa88', 'Scenario 107 - Punctuality measures the percentage of trains arriving at their destinations on time (the train doesn’t arrive after planned arrival) and the train didn’t depart before planned departure time. The goal is to maintain a high level of reliability and minimize delays for passengers and freight services. ', 'This KPI contributes to evaluating Effectiveness of the AI-based assistant, as part of Task 4.1 evaluation objectives, and O2 main project objective:<br/>- Improve customer satisfaction by ensuring timely arrivals<br/>- Guarantee maximal planned connection<br/>- Minimize operational disruptions caused by delays<br/>- Meet regulatory and stakeholder benchmarks for punctuality<br/>This KPI is linked with project’s Long Term Expected Impacts (LTEI) (LTEI1)KPIS-3:<br/>- 10% increase in punctuality in long-range traffic<br/>- 5% increase in punctuality in regional traffic (with realistic disturbances)<br/>', array['07f64c1d-1287-4672-b807-137fcc9ebe7b', '22898189-e733-4d34-ae6d-9aeffbe1a457']::uuid[])
    ON CONFLICT(id) DO UPDATE SET name=EXCLUDED.name, description=EXCLUDED.description, field_ids=EXCLUDED.field_ids;

INSERT INTO field_definitions
        (id, key, description, agg_func, agg_weights)
        VALUES ('07f64c1d-1287-4672-b807-137fcc9ebe7b', 'sum_normalized_reward', 'Primary scenario score (raw values): sum_normalized_reward', NULL, NULL)
        ON CONFLICT(id) DO UPDATE SET key=EXCLUDED.key, description=EXCLUDED.description, agg_func=EXCLUDED.agg_func, agg_weights=EXCLUDED.agg_weights;

INSERT INTO field_definitions
        (id, key, description, agg_func, agg_weights)
        VALUES ('22898189-e733-4d34-ae6d-9aeffbe1a457', 'success_rate', 'Secondary scenario score (raw values): success_rate', NULL, NULL)
        ON CONFLICT(id) DO UPDATE SET key=EXCLUDED.key, description=EXCLUDED.description, agg_func=EXCLUDED.agg_func, agg_weights=EXCLUDED.agg_weights;

INSERT INTO scenario_definitions
    (id, name, description, field_ids)
    VALUES ('9742751d-d670-4310-97ab-a14973112470', 'Scenario 108 - Punctuality measures the percentage of trains arriving at their destinations on time (the train doesn’t arrive after planned arrival) and the train didn’t depart before planned departure time. The goal is to maintain a high level of reliability and minimize delays for passengers and freight services. ', 'This KPI contributes to evaluating Effectiveness of the AI-based assistant, as part of Task 4.1 evaluation objectives, and O2 main project objective:<br/>- Improve customer satisfaction by ensuring timely arrivals<br/>- Guarantee maximal planned connection<br/>- Minimize operational disruptions caused by delays<br/>- Meet regulatory and stakeholder benchmarks for punctuality<br/>This KPI is linked with project’s Long Term Expected Impacts (LTEI) (LTEI1)KPIS-3:<br/>- 10% increase in punctuality in long-range traffic<br/>- 5% increase in punctuality in regional traffic (with realistic disturbances)<br/>', array['804fc8af-dabe-45a5-b577-d84f43f9cd3f', '5cf2413a-0523-4d1c-9ef4-fee88393a227']::uuid[])
    ON CONFLICT(id) DO UPDATE SET name=EXCLUDED.name, description=EXCLUDED.description, field_ids=EXCLUDED.field_ids;

INSERT INTO field_definitions
        (id, key, description, agg_func, agg_weights)
        VALUES ('804fc8af-dabe-45a5-b577-d84f43f9cd3f', 'sum_normalized_reward', 'Primary scenario score (raw values): sum_normalized_reward', NULL, NULL)
        ON CONFLICT(id) DO UPDATE SET key=EXCLUDED.key, description=EXCLUDED.description, agg_func=EXCLUDED.agg_func, agg_weights=EXCLUDED.agg_weights;

INSERT INTO field_definitions
        (id, key, description, agg_func, agg_weights)
        VALUES ('5cf2413a-0523-4d1c-9ef4-fee88393a227', 'success_rate', 'Secondary scenario score (raw values): success_rate', NULL, NULL)
        ON CONFLICT(id) DO UPDATE SET key=EXCLUDED.key, description=EXCLUDED.description, agg_func=EXCLUDED.agg_func, agg_weights=EXCLUDED.agg_weights;

INSERT INTO scenario_definitions
    (id, name, description, field_ids)
    VALUES ('72df8c4b-f0ef-438d-9858-88053cb188c1', 'Scenario 109 - Punctuality measures the percentage of trains arriving at their destinations on time (the train doesn’t arrive after planned arrival) and the train didn’t depart before planned departure time. The goal is to maintain a high level of reliability and minimize delays for passengers and freight services. ', 'This KPI contributes to evaluating Effectiveness of the AI-based assistant, as part of Task 4.1 evaluation objectives, and O2 main project objective:<br/>- Improve customer satisfaction by ensuring timely arrivals<br/>- Guarantee maximal planned connection<br/>- Minimize operational disruptions caused by delays<br/>- Meet regulatory and stakeholder benchmarks for punctuality<br/>This KPI is linked with project’s Long Term Expected Impacts (LTEI) (LTEI1)KPIS-3:<br/>- 10% increase in punctuality in long-range traffic<br/>- 5% increase in punctuality in regional traffic (with realistic disturbances)<br/>', array['323c29e8-7a6f-4162-ac4d-e9ab12704992', '1841cc5c-6bf6-48f0-b54c-69c844d1a957']::uuid[])
    ON CONFLICT(id) DO UPDATE SET name=EXCLUDED.name, description=EXCLUDED.description, field_ids=EXCLUDED.field_ids;

INSERT INTO field_definitions
        (id, key, description, agg_func, agg_weights)
        VALUES ('323c29e8-7a6f-4162-ac4d-e9ab12704992', 'sum_normalized_reward', 'Primary scenario score (raw values): sum_normalized_reward', NULL, NULL)
        ON CONFLICT(id) DO UPDATE SET key=EXCLUDED.key, description=EXCLUDED.description, agg_func=EXCLUDED.agg_func, agg_weights=EXCLUDED.agg_weights;

INSERT INTO field_definitions
        (id, key, description, agg_func, agg_weights)
        VALUES ('1841cc5c-6bf6-48f0-b54c-69c844d1a957', 'success_rate', 'Secondary scenario score (raw values): success_rate', NULL, NULL)
        ON CONFLICT(id) DO UPDATE SET key=EXCLUDED.key, description=EXCLUDED.description, agg_func=EXCLUDED.agg_func, agg_weights=EXCLUDED.agg_weights;

INSERT INTO scenario_definitions
    (id, name, description, field_ids)
    VALUES ('05b4cb03-5576-4d79-9afa-1c6318d632ec', 'Scenario 110 - Punctuality measures the percentage of trains arriving at their destinations on time (the train doesn’t arrive after planned arrival) and the train didn’t depart before planned departure time. The goal is to maintain a high level of reliability and minimize delays for passengers and freight services. ', 'This KPI contributes to evaluating Effectiveness of the AI-based assistant, as part of Task 4.1 evaluation objectives, and O2 main project objective:<br/>- Improve customer satisfaction by ensuring timely arrivals<br/>- Guarantee maximal planned connection<br/>- Minimize operational disruptions caused by delays<br/>- Meet regulatory and stakeholder benchmarks for punctuality<br/>This KPI is linked with project’s Long Term Expected Impacts (LTEI) (LTEI1)KPIS-3:<br/>- 10% increase in punctuality in long-range traffic<br/>- 5% increase in punctuality in regional traffic (with realistic disturbances)<br/>', array['f4665504-35ba-48f8-ab7c-748e4378233c', '4084fd1e-525f-4103-8fe9-7accd4f3bff0']::uuid[])
    ON CONFLICT(id) DO UPDATE SET name=EXCLUDED.name, description=EXCLUDED.description, field_ids=EXCLUDED.field_ids;

INSERT INTO field_definitions
        (id, key, description, agg_func, agg_weights)
        VALUES ('f4665504-35ba-48f8-ab7c-748e4378233c', 'sum_normalized_reward', 'Primary scenario score (raw values): sum_normalized_reward', NULL, NULL)
        ON CONFLICT(id) DO UPDATE SET key=EXCLUDED.key, description=EXCLUDED.description, agg_func=EXCLUDED.agg_func, agg_weights=EXCLUDED.agg_weights;

INSERT INTO field_definitions
        (id, key, description, agg_func, agg_weights)
        VALUES ('4084fd1e-525f-4103-8fe9-7accd4f3bff0', 'success_rate', 'Secondary scenario score (raw values): success_rate', NULL, NULL)
        ON CONFLICT(id) DO UPDATE SET key=EXCLUDED.key, description=EXCLUDED.description, agg_func=EXCLUDED.agg_func, agg_weights=EXCLUDED.agg_weights;

INSERT INTO scenario_definitions
    (id, name, description, field_ids)
    VALUES ('6db73b00-b6f1-4f63-9fd0-49f518361ee2', 'Scenario 111 - Punctuality measures the percentage of trains arriving at their destinations on time (the train doesn’t arrive after planned arrival) and the train didn’t depart before planned departure time. The goal is to maintain a high level of reliability and minimize delays for passengers and freight services. ', 'This KPI contributes to evaluating Effectiveness of the AI-based assistant, as part of Task 4.1 evaluation objectives, and O2 main project objective:<br/>- Improve customer satisfaction by ensuring timely arrivals<br/>- Guarantee maximal planned connection<br/>- Minimize operational disruptions caused by delays<br/>- Meet regulatory and stakeholder benchmarks for punctuality<br/>This KPI is linked with project’s Long Term Expected Impacts (LTEI) (LTEI1)KPIS-3:<br/>- 10% increase in punctuality in long-range traffic<br/>- 5% increase in punctuality in regional traffic (with realistic disturbances)<br/>', array['e7a5c603-309a-4a4c-a5d2-622fb512dbed', 'e078e1f1-3fcd-4a29-b92e-eb587ffba3c4']::uuid[])
    ON CONFLICT(id) DO UPDATE SET name=EXCLUDED.name, description=EXCLUDED.description, field_ids=EXCLUDED.field_ids;

INSERT INTO field_definitions
        (id, key, description, agg_func, agg_weights)
        VALUES ('e7a5c603-309a-4a4c-a5d2-622fb512dbed', 'sum_normalized_reward', 'Primary scenario score (raw values): sum_normalized_reward', NULL, NULL)
        ON CONFLICT(id) DO UPDATE SET key=EXCLUDED.key, description=EXCLUDED.description, agg_func=EXCLUDED.agg_func, agg_weights=EXCLUDED.agg_weights;

INSERT INTO field_definitions
        (id, key, description, agg_func, agg_weights)
        VALUES ('e078e1f1-3fcd-4a29-b92e-eb587ffba3c4', 'success_rate', 'Secondary scenario score (raw values): success_rate', NULL, NULL)
        ON CONFLICT(id) DO UPDATE SET key=EXCLUDED.key, description=EXCLUDED.description, agg_func=EXCLUDED.agg_func, agg_weights=EXCLUDED.agg_weights;

INSERT INTO scenario_definitions
    (id, name, description, field_ids)
    VALUES ('69df632e-d2aa-4005-a9e2-1c5e07eeebd9', 'Scenario 112 - Punctuality measures the percentage of trains arriving at their destinations on time (the train doesn’t arrive after planned arrival) and the train didn’t depart before planned departure time. The goal is to maintain a high level of reliability and minimize delays for passengers and freight services. ', 'This KPI contributes to evaluating Effectiveness of the AI-based assistant, as part of Task 4.1 evaluation objectives, and O2 main project objective:<br/>- Improve customer satisfaction by ensuring timely arrivals<br/>- Guarantee maximal planned connection<br/>- Minimize operational disruptions caused by delays<br/>- Meet regulatory and stakeholder benchmarks for punctuality<br/>This KPI is linked with project’s Long Term Expected Impacts (LTEI) (LTEI1)KPIS-3:<br/>- 10% increase in punctuality in long-range traffic<br/>- 5% increase in punctuality in regional traffic (with realistic disturbances)<br/>', array['beb7a7ac-2f4c-4b79-9237-18d4f88f9a50', '2bb30753-995b-47d7-9ad5-4182b148aca5']::uuid[])
    ON CONFLICT(id) DO UPDATE SET name=EXCLUDED.name, description=EXCLUDED.description, field_ids=EXCLUDED.field_ids;

INSERT INTO field_definitions
        (id, key, description, agg_func, agg_weights)
        VALUES ('beb7a7ac-2f4c-4b79-9237-18d4f88f9a50', 'sum_normalized_reward', 'Primary scenario score (raw values): sum_normalized_reward', NULL, NULL)
        ON CONFLICT(id) DO UPDATE SET key=EXCLUDED.key, description=EXCLUDED.description, agg_func=EXCLUDED.agg_func, agg_weights=EXCLUDED.agg_weights;

INSERT INTO field_definitions
        (id, key, description, agg_func, agg_weights)
        VALUES ('2bb30753-995b-47d7-9ad5-4182b148aca5', 'success_rate', 'Secondary scenario score (raw values): success_rate', NULL, NULL)
        ON CONFLICT(id) DO UPDATE SET key=EXCLUDED.key, description=EXCLUDED.description, agg_func=EXCLUDED.agg_func, agg_weights=EXCLUDED.agg_weights;

INSERT INTO scenario_definitions
    (id, name, description, field_ids)
    VALUES ('09aff9df-7c67-4810-8e13-90f8c9bd05a1', 'Scenario 113 - Punctuality measures the percentage of trains arriving at their destinations on time (the train doesn’t arrive after planned arrival) and the train didn’t depart before planned departure time. The goal is to maintain a high level of reliability and minimize delays for passengers and freight services. ', 'This KPI contributes to evaluating Effectiveness of the AI-based assistant, as part of Task 4.1 evaluation objectives, and O2 main project objective:<br/>- Improve customer satisfaction by ensuring timely arrivals<br/>- Guarantee maximal planned connection<br/>- Minimize operational disruptions caused by delays<br/>- Meet regulatory and stakeholder benchmarks for punctuality<br/>This KPI is linked with project’s Long Term Expected Impacts (LTEI) (LTEI1)KPIS-3:<br/>- 10% increase in punctuality in long-range traffic<br/>- 5% increase in punctuality in regional traffic (with realistic disturbances)<br/>', array['1d778112-b0b5-4e7d-a8df-4ad15a95045e', '8f9156a8-42e0-4345-9bf4-a5af9a1e3d29']::uuid[])
    ON CONFLICT(id) DO UPDATE SET name=EXCLUDED.name, description=EXCLUDED.description, field_ids=EXCLUDED.field_ids;

INSERT INTO field_definitions
        (id, key, description, agg_func, agg_weights)
        VALUES ('1d778112-b0b5-4e7d-a8df-4ad15a95045e', 'sum_normalized_reward', 'Primary scenario score (raw values): sum_normalized_reward', NULL, NULL)
        ON CONFLICT(id) DO UPDATE SET key=EXCLUDED.key, description=EXCLUDED.description, agg_func=EXCLUDED.agg_func, agg_weights=EXCLUDED.agg_weights;

INSERT INTO field_definitions
        (id, key, description, agg_func, agg_weights)
        VALUES ('8f9156a8-42e0-4345-9bf4-a5af9a1e3d29', 'success_rate', 'Secondary scenario score (raw values): success_rate', NULL, NULL)
        ON CONFLICT(id) DO UPDATE SET key=EXCLUDED.key, description=EXCLUDED.description, agg_func=EXCLUDED.agg_func, agg_weights=EXCLUDED.agg_weights;

INSERT INTO scenario_definitions
    (id, name, description, field_ids)
    VALUES ('3de1e810-7abe-4dd4-9663-e19270c37c52', 'Scenario 114 - Punctuality measures the percentage of trains arriving at their destinations on time (the train doesn’t arrive after planned arrival) and the train didn’t depart before planned departure time. The goal is to maintain a high level of reliability and minimize delays for passengers and freight services. ', 'This KPI contributes to evaluating Effectiveness of the AI-based assistant, as part of Task 4.1 evaluation objectives, and O2 main project objective:<br/>- Improve customer satisfaction by ensuring timely arrivals<br/>- Guarantee maximal planned connection<br/>- Minimize operational disruptions caused by delays<br/>- Meet regulatory and stakeholder benchmarks for punctuality<br/>This KPI is linked with project’s Long Term Expected Impacts (LTEI) (LTEI1)KPIS-3:<br/>- 10% increase in punctuality in long-range traffic<br/>- 5% increase in punctuality in regional traffic (with realistic disturbances)<br/>', array['47a9a474-25da-45fc-bb60-ac3728fd23d0', '6b935e60-23a9-41a0-80ba-90785cffb7ef']::uuid[])
    ON CONFLICT(id) DO UPDATE SET name=EXCLUDED.name, description=EXCLUDED.description, field_ids=EXCLUDED.field_ids;

INSERT INTO field_definitions
        (id, key, description, agg_func, agg_weights)
        VALUES ('47a9a474-25da-45fc-bb60-ac3728fd23d0', 'sum_normalized_reward', 'Primary scenario score (raw values): sum_normalized_reward', NULL, NULL)
        ON CONFLICT(id) DO UPDATE SET key=EXCLUDED.key, description=EXCLUDED.description, agg_func=EXCLUDED.agg_func, agg_weights=EXCLUDED.agg_weights;

INSERT INTO field_definitions
        (id, key, description, agg_func, agg_weights)
        VALUES ('6b935e60-23a9-41a0-80ba-90785cffb7ef', 'success_rate', 'Secondary scenario score (raw values): success_rate', NULL, NULL)
        ON CONFLICT(id) DO UPDATE SET key=EXCLUDED.key, description=EXCLUDED.description, agg_func=EXCLUDED.agg_func, agg_weights=EXCLUDED.agg_weights;

INSERT INTO scenario_definitions
    (id, name, description, field_ids)
    VALUES ('afd8d475-9bd3-4740-a5be-293cd211b34d', 'Scenario 115 - Punctuality measures the percentage of trains arriving at their destinations on time (the train doesn’t arrive after planned arrival) and the train didn’t depart before planned departure time. The goal is to maintain a high level of reliability and minimize delays for passengers and freight services. ', 'This KPI contributes to evaluating Effectiveness of the AI-based assistant, as part of Task 4.1 evaluation objectives, and O2 main project objective:<br/>- Improve customer satisfaction by ensuring timely arrivals<br/>- Guarantee maximal planned connection<br/>- Minimize operational disruptions caused by delays<br/>- Meet regulatory and stakeholder benchmarks for punctuality<br/>This KPI is linked with project’s Long Term Expected Impacts (LTEI) (LTEI1)KPIS-3:<br/>- 10% increase in punctuality in long-range traffic<br/>- 5% increase in punctuality in regional traffic (with realistic disturbances)<br/>', array['87b1300a-630a-4f9d-9088-ac2e35f826aa', '6cb29511-2f90-47f2-b45f-8b5b466abd44']::uuid[])
    ON CONFLICT(id) DO UPDATE SET name=EXCLUDED.name, description=EXCLUDED.description, field_ids=EXCLUDED.field_ids;

INSERT INTO field_definitions
        (id, key, description, agg_func, agg_weights)
        VALUES ('87b1300a-630a-4f9d-9088-ac2e35f826aa', 'sum_normalized_reward', 'Primary scenario score (raw values): sum_normalized_reward', NULL, NULL)
        ON CONFLICT(id) DO UPDATE SET key=EXCLUDED.key, description=EXCLUDED.description, agg_func=EXCLUDED.agg_func, agg_weights=EXCLUDED.agg_weights;

INSERT INTO field_definitions
        (id, key, description, agg_func, agg_weights)
        VALUES ('6cb29511-2f90-47f2-b45f-8b5b466abd44', 'success_rate', 'Secondary scenario score (raw values): success_rate', NULL, NULL)
        ON CONFLICT(id) DO UPDATE SET key=EXCLUDED.key, description=EXCLUDED.description, agg_func=EXCLUDED.agg_func, agg_weights=EXCLUDED.agg_weights;

INSERT INTO scenario_definitions
    (id, name, description, field_ids)
    VALUES ('de0a8389-d573-483c-811b-e7829bd58a54', 'Scenario 116 - Punctuality measures the percentage of trains arriving at their destinations on time (the train doesn’t arrive after planned arrival) and the train didn’t depart before planned departure time. The goal is to maintain a high level of reliability and minimize delays for passengers and freight services. ', 'This KPI contributes to evaluating Effectiveness of the AI-based assistant, as part of Task 4.1 evaluation objectives, and O2 main project objective:<br/>- Improve customer satisfaction by ensuring timely arrivals<br/>- Guarantee maximal planned connection<br/>- Minimize operational disruptions caused by delays<br/>- Meet regulatory and stakeholder benchmarks for punctuality<br/>This KPI is linked with project’s Long Term Expected Impacts (LTEI) (LTEI1)KPIS-3:<br/>- 10% increase in punctuality in long-range traffic<br/>- 5% increase in punctuality in regional traffic (with realistic disturbances)<br/>', array['81da31a3-2270-49f4-b493-a311cda33e36', '6c3d4ca6-5acc-4c20-b79e-f9a1e8ee2e79']::uuid[])
    ON CONFLICT(id) DO UPDATE SET name=EXCLUDED.name, description=EXCLUDED.description, field_ids=EXCLUDED.field_ids;

INSERT INTO field_definitions
        (id, key, description, agg_func, agg_weights)
        VALUES ('81da31a3-2270-49f4-b493-a311cda33e36', 'sum_normalized_reward', 'Primary scenario score (raw values): sum_normalized_reward', NULL, NULL)
        ON CONFLICT(id) DO UPDATE SET key=EXCLUDED.key, description=EXCLUDED.description, agg_func=EXCLUDED.agg_func, agg_weights=EXCLUDED.agg_weights;

INSERT INTO field_definitions
        (id, key, description, agg_func, agg_weights)
        VALUES ('6c3d4ca6-5acc-4c20-b79e-f9a1e8ee2e79', 'success_rate', 'Secondary scenario score (raw values): success_rate', NULL, NULL)
        ON CONFLICT(id) DO UPDATE SET key=EXCLUDED.key, description=EXCLUDED.description, agg_func=EXCLUDED.agg_func, agg_weights=EXCLUDED.agg_weights;

INSERT INTO scenario_definitions
    (id, name, description, field_ids)
    VALUES ('65b60f43-6a71-4c7b-805f-6c3f564c87bb', 'Scenario 117 - Punctuality measures the percentage of trains arriving at their destinations on time (the train doesn’t arrive after planned arrival) and the train didn’t depart before planned departure time. The goal is to maintain a high level of reliability and minimize delays for passengers and freight services. ', 'This KPI contributes to evaluating Effectiveness of the AI-based assistant, as part of Task 4.1 evaluation objectives, and O2 main project objective:<br/>- Improve customer satisfaction by ensuring timely arrivals<br/>- Guarantee maximal planned connection<br/>- Minimize operational disruptions caused by delays<br/>- Meet regulatory and stakeholder benchmarks for punctuality<br/>This KPI is linked with project’s Long Term Expected Impacts (LTEI) (LTEI1)KPIS-3:<br/>- 10% increase in punctuality in long-range traffic<br/>- 5% increase in punctuality in regional traffic (with realistic disturbances)<br/>', array['cf28792f-1ae3-4ec9-994a-e05860429de6', '78e05b9c-ca04-4258-8b6f-96cd3ae83f71']::uuid[])
    ON CONFLICT(id) DO UPDATE SET name=EXCLUDED.name, description=EXCLUDED.description, field_ids=EXCLUDED.field_ids;

INSERT INTO field_definitions
        (id, key, description, agg_func, agg_weights)
        VALUES ('cf28792f-1ae3-4ec9-994a-e05860429de6', 'sum_normalized_reward', 'Primary scenario score (raw values): sum_normalized_reward', NULL, NULL)
        ON CONFLICT(id) DO UPDATE SET key=EXCLUDED.key, description=EXCLUDED.description, agg_func=EXCLUDED.agg_func, agg_weights=EXCLUDED.agg_weights;

INSERT INTO field_definitions
        (id, key, description, agg_func, agg_weights)
        VALUES ('78e05b9c-ca04-4258-8b6f-96cd3ae83f71', 'success_rate', 'Secondary scenario score (raw values): success_rate', NULL, NULL)
        ON CONFLICT(id) DO UPDATE SET key=EXCLUDED.key, description=EXCLUDED.description, agg_func=EXCLUDED.agg_func, agg_weights=EXCLUDED.agg_weights;

INSERT INTO scenario_definitions
    (id, name, description, field_ids)
    VALUES ('8d1746ff-83c6-4675-acd7-01a2a654ec0a', 'Scenario 118 - Punctuality measures the percentage of trains arriving at their destinations on time (the train doesn’t arrive after planned arrival) and the train didn’t depart before planned departure time. The goal is to maintain a high level of reliability and minimize delays for passengers and freight services. ', 'This KPI contributes to evaluating Effectiveness of the AI-based assistant, as part of Task 4.1 evaluation objectives, and O2 main project objective:<br/>- Improve customer satisfaction by ensuring timely arrivals<br/>- Guarantee maximal planned connection<br/>- Minimize operational disruptions caused by delays<br/>- Meet regulatory and stakeholder benchmarks for punctuality<br/>This KPI is linked with project’s Long Term Expected Impacts (LTEI) (LTEI1)KPIS-3:<br/>- 10% increase in punctuality in long-range traffic<br/>- 5% increase in punctuality in regional traffic (with realistic disturbances)<br/>', array['b262d34b-e8da-4a01-8961-9f6f01112510', 'b6153738-6b5a-47e5-a5ef-b82c52277a95']::uuid[])
    ON CONFLICT(id) DO UPDATE SET name=EXCLUDED.name, description=EXCLUDED.description, field_ids=EXCLUDED.field_ids;

INSERT INTO field_definitions
        (id, key, description, agg_func, agg_weights)
        VALUES ('b262d34b-e8da-4a01-8961-9f6f01112510', 'sum_normalized_reward', 'Primary scenario score (raw values): sum_normalized_reward', NULL, NULL)
        ON CONFLICT(id) DO UPDATE SET key=EXCLUDED.key, description=EXCLUDED.description, agg_func=EXCLUDED.agg_func, agg_weights=EXCLUDED.agg_weights;

INSERT INTO field_definitions
        (id, key, description, agg_func, agg_weights)
        VALUES ('b6153738-6b5a-47e5-a5ef-b82c52277a95', 'success_rate', 'Secondary scenario score (raw values): success_rate', NULL, NULL)
        ON CONFLICT(id) DO UPDATE SET key=EXCLUDED.key, description=EXCLUDED.description, agg_func=EXCLUDED.agg_func, agg_weights=EXCLUDED.agg_weights;

INSERT INTO scenario_definitions
    (id, name, description, field_ids)
    VALUES ('011866d3-76a6-4b5a-9c42-447e2d567892', 'Scenario 119 - Punctuality measures the percentage of trains arriving at their destinations on time (the train doesn’t arrive after planned arrival) and the train didn’t depart before planned departure time. The goal is to maintain a high level of reliability and minimize delays for passengers and freight services. ', 'This KPI contributes to evaluating Effectiveness of the AI-based assistant, as part of Task 4.1 evaluation objectives, and O2 main project objective:<br/>- Improve customer satisfaction by ensuring timely arrivals<br/>- Guarantee maximal planned connection<br/>- Minimize operational disruptions caused by delays<br/>- Meet regulatory and stakeholder benchmarks for punctuality<br/>This KPI is linked with project’s Long Term Expected Impacts (LTEI) (LTEI1)KPIS-3:<br/>- 10% increase in punctuality in long-range traffic<br/>- 5% increase in punctuality in regional traffic (with realistic disturbances)<br/>', array['b1cf2122-c5f6-4623-ab6d-4a1d265dbee0', 'be23ebab-753d-47f7-84bc-1f105e54ec67']::uuid[])
    ON CONFLICT(id) DO UPDATE SET name=EXCLUDED.name, description=EXCLUDED.description, field_ids=EXCLUDED.field_ids;

INSERT INTO field_definitions
        (id, key, description, agg_func, agg_weights)
        VALUES ('b1cf2122-c5f6-4623-ab6d-4a1d265dbee0', 'sum_normalized_reward', 'Primary scenario score (raw values): sum_normalized_reward', NULL, NULL)
        ON CONFLICT(id) DO UPDATE SET key=EXCLUDED.key, description=EXCLUDED.description, agg_func=EXCLUDED.agg_func, agg_weights=EXCLUDED.agg_weights;

INSERT INTO field_definitions
        (id, key, description, agg_func, agg_weights)
        VALUES ('be23ebab-753d-47f7-84bc-1f105e54ec67', 'success_rate', 'Secondary scenario score (raw values): success_rate', NULL, NULL)
        ON CONFLICT(id) DO UPDATE SET key=EXCLUDED.key, description=EXCLUDED.description, agg_func=EXCLUDED.agg_func, agg_weights=EXCLUDED.agg_weights;

INSERT INTO scenario_definitions
    (id, name, description, field_ids)
    VALUES ('23d5ddd1-1fb0-4149-bf59-a2e7cd34213a', 'Scenario 120 - Punctuality measures the percentage of trains arriving at their destinations on time (the train doesn’t arrive after planned arrival) and the train didn’t depart before planned departure time. The goal is to maintain a high level of reliability and minimize delays for passengers and freight services. ', 'This KPI contributes to evaluating Effectiveness of the AI-based assistant, as part of Task 4.1 evaluation objectives, and O2 main project objective:<br/>- Improve customer satisfaction by ensuring timely arrivals<br/>- Guarantee maximal planned connection<br/>- Minimize operational disruptions caused by delays<br/>- Meet regulatory and stakeholder benchmarks for punctuality<br/>This KPI is linked with project’s Long Term Expected Impacts (LTEI) (LTEI1)KPIS-3:<br/>- 10% increase in punctuality in long-range traffic<br/>- 5% increase in punctuality in regional traffic (with realistic disturbances)<br/>', array['f2677147-bd17-4bd5-a88a-f9e98a0515f7', '3007cf78-0ad8-41d1-a24c-733b8633b62a']::uuid[])
    ON CONFLICT(id) DO UPDATE SET name=EXCLUDED.name, description=EXCLUDED.description, field_ids=EXCLUDED.field_ids;

INSERT INTO field_definitions
        (id, key, description, agg_func, agg_weights)
        VALUES ('f2677147-bd17-4bd5-a88a-f9e98a0515f7', 'sum_normalized_reward', 'Primary scenario score (raw values): sum_normalized_reward', NULL, NULL)
        ON CONFLICT(id) DO UPDATE SET key=EXCLUDED.key, description=EXCLUDED.description, agg_func=EXCLUDED.agg_func, agg_weights=EXCLUDED.agg_weights;

INSERT INTO field_definitions
        (id, key, description, agg_func, agg_weights)
        VALUES ('3007cf78-0ad8-41d1-a24c-733b8633b62a', 'success_rate', 'Secondary scenario score (raw values): success_rate', NULL, NULL)
        ON CONFLICT(id) DO UPDATE SET key=EXCLUDED.key, description=EXCLUDED.description, agg_func=EXCLUDED.agg_func, agg_weights=EXCLUDED.agg_weights;

INSERT INTO scenario_definitions
    (id, name, description, field_ids)
    VALUES ('1990750e-de0f-4789-9dcc-dae5b9b99173', 'Scenario 121 - Punctuality measures the percentage of trains arriving at their destinations on time (the train doesn’t arrive after planned arrival) and the train didn’t depart before planned departure time. The goal is to maintain a high level of reliability and minimize delays for passengers and freight services. ', 'This KPI contributes to evaluating Effectiveness of the AI-based assistant, as part of Task 4.1 evaluation objectives, and O2 main project objective:<br/>- Improve customer satisfaction by ensuring timely arrivals<br/>- Guarantee maximal planned connection<br/>- Minimize operational disruptions caused by delays<br/>- Meet regulatory and stakeholder benchmarks for punctuality<br/>This KPI is linked with project’s Long Term Expected Impacts (LTEI) (LTEI1)KPIS-3:<br/>- 10% increase in punctuality in long-range traffic<br/>- 5% increase in punctuality in regional traffic (with realistic disturbances)<br/>', array['373538d1-9184-4cc4-9075-f320c16358b7', '4ece88ad-dc7e-4a1e-a0e4-77feee4abf1c']::uuid[])
    ON CONFLICT(id) DO UPDATE SET name=EXCLUDED.name, description=EXCLUDED.description, field_ids=EXCLUDED.field_ids;

INSERT INTO field_definitions
        (id, key, description, agg_func, agg_weights)
        VALUES ('373538d1-9184-4cc4-9075-f320c16358b7', 'sum_normalized_reward', 'Primary scenario score (raw values): sum_normalized_reward', NULL, NULL)
        ON CONFLICT(id) DO UPDATE SET key=EXCLUDED.key, description=EXCLUDED.description, agg_func=EXCLUDED.agg_func, agg_weights=EXCLUDED.agg_weights;

INSERT INTO field_definitions
        (id, key, description, agg_func, agg_weights)
        VALUES ('4ece88ad-dc7e-4a1e-a0e4-77feee4abf1c', 'success_rate', 'Secondary scenario score (raw values): success_rate', NULL, NULL)
        ON CONFLICT(id) DO UPDATE SET key=EXCLUDED.key, description=EXCLUDED.description, agg_func=EXCLUDED.agg_func, agg_weights=EXCLUDED.agg_weights;

INSERT INTO scenario_definitions
    (id, name, description, field_ids)
    VALUES ('b127b87c-600d-4f28-b74a-e6c33d27e42f', 'Scenario 122 - Punctuality measures the percentage of trains arriving at their destinations on time (the train doesn’t arrive after planned arrival) and the train didn’t depart before planned departure time. The goal is to maintain a high level of reliability and minimize delays for passengers and freight services. ', 'This KPI contributes to evaluating Effectiveness of the AI-based assistant, as part of Task 4.1 evaluation objectives, and O2 main project objective:<br/>- Improve customer satisfaction by ensuring timely arrivals<br/>- Guarantee maximal planned connection<br/>- Minimize operational disruptions caused by delays<br/>- Meet regulatory and stakeholder benchmarks for punctuality<br/>This KPI is linked with project’s Long Term Expected Impacts (LTEI) (LTEI1)KPIS-3:<br/>- 10% increase in punctuality in long-range traffic<br/>- 5% increase in punctuality in regional traffic (with realistic disturbances)<br/>', array['b567915d-e9a8-4db1-ab27-77d10b00b23d', 'ad91df4b-2ee6-4552-8102-5649296b2f2f']::uuid[])
    ON CONFLICT(id) DO UPDATE SET name=EXCLUDED.name, description=EXCLUDED.description, field_ids=EXCLUDED.field_ids;

INSERT INTO field_definitions
        (id, key, description, agg_func, agg_weights)
        VALUES ('b567915d-e9a8-4db1-ab27-77d10b00b23d', 'sum_normalized_reward', 'Primary scenario score (raw values): sum_normalized_reward', NULL, NULL)
        ON CONFLICT(id) DO UPDATE SET key=EXCLUDED.key, description=EXCLUDED.description, agg_func=EXCLUDED.agg_func, agg_weights=EXCLUDED.agg_weights;

INSERT INTO field_definitions
        (id, key, description, agg_func, agg_weights)
        VALUES ('ad91df4b-2ee6-4552-8102-5649296b2f2f', 'success_rate', 'Secondary scenario score (raw values): success_rate', NULL, NULL)
        ON CONFLICT(id) DO UPDATE SET key=EXCLUDED.key, description=EXCLUDED.description, agg_func=EXCLUDED.agg_func, agg_weights=EXCLUDED.agg_weights;

INSERT INTO scenario_definitions
    (id, name, description, field_ids)
    VALUES ('bf0f6ceb-62fd-4a92-a7b0-29cf898b05e1', 'Scenario 123 - Punctuality measures the percentage of trains arriving at their destinations on time (the train doesn’t arrive after planned arrival) and the train didn’t depart before planned departure time. The goal is to maintain a high level of reliability and minimize delays for passengers and freight services. ', 'This KPI contributes to evaluating Effectiveness of the AI-based assistant, as part of Task 4.1 evaluation objectives, and O2 main project objective:<br/>- Improve customer satisfaction by ensuring timely arrivals<br/>- Guarantee maximal planned connection<br/>- Minimize operational disruptions caused by delays<br/>- Meet regulatory and stakeholder benchmarks for punctuality<br/>This KPI is linked with project’s Long Term Expected Impacts (LTEI) (LTEI1)KPIS-3:<br/>- 10% increase in punctuality in long-range traffic<br/>- 5% increase in punctuality in regional traffic (with realistic disturbances)<br/>', array['6de21d49-097b-41be-b2bb-a987ccc8fb56', '90f138c5-b7fe-4cf7-a518-f2296efe5451']::uuid[])
    ON CONFLICT(id) DO UPDATE SET name=EXCLUDED.name, description=EXCLUDED.description, field_ids=EXCLUDED.field_ids;

INSERT INTO field_definitions
        (id, key, description, agg_func, agg_weights)
        VALUES ('6de21d49-097b-41be-b2bb-a987ccc8fb56', 'sum_normalized_reward', 'Primary scenario score (raw values): sum_normalized_reward', NULL, NULL)
        ON CONFLICT(id) DO UPDATE SET key=EXCLUDED.key, description=EXCLUDED.description, agg_func=EXCLUDED.agg_func, agg_weights=EXCLUDED.agg_weights;

INSERT INTO field_definitions
        (id, key, description, agg_func, agg_weights)
        VALUES ('90f138c5-b7fe-4cf7-a518-f2296efe5451', 'success_rate', 'Secondary scenario score (raw values): success_rate', NULL, NULL)
        ON CONFLICT(id) DO UPDATE SET key=EXCLUDED.key, description=EXCLUDED.description, agg_func=EXCLUDED.agg_func, agg_weights=EXCLUDED.agg_weights;

INSERT INTO scenario_definitions
    (id, name, description, field_ids)
    VALUES ('103881e7-8415-4d6b-90c5-cef06f36b5b3', 'Scenario 124 - Punctuality measures the percentage of trains arriving at their destinations on time (the train doesn’t arrive after planned arrival) and the train didn’t depart before planned departure time. The goal is to maintain a high level of reliability and minimize delays for passengers and freight services. ', 'This KPI contributes to evaluating Effectiveness of the AI-based assistant, as part of Task 4.1 evaluation objectives, and O2 main project objective:<br/>- Improve customer satisfaction by ensuring timely arrivals<br/>- Guarantee maximal planned connection<br/>- Minimize operational disruptions caused by delays<br/>- Meet regulatory and stakeholder benchmarks for punctuality<br/>This KPI is linked with project’s Long Term Expected Impacts (LTEI) (LTEI1)KPIS-3:<br/>- 10% increase in punctuality in long-range traffic<br/>- 5% increase in punctuality in regional traffic (with realistic disturbances)<br/>', array['590d7c2b-c209-4419-918d-8cecfb12b089', 'd8d6beab-e1a9-42b3-9073-999693e9fd64']::uuid[])
    ON CONFLICT(id) DO UPDATE SET name=EXCLUDED.name, description=EXCLUDED.description, field_ids=EXCLUDED.field_ids;

INSERT INTO field_definitions
        (id, key, description, agg_func, agg_weights)
        VALUES ('590d7c2b-c209-4419-918d-8cecfb12b089', 'sum_normalized_reward', 'Primary scenario score (raw values): sum_normalized_reward', NULL, NULL)
        ON CONFLICT(id) DO UPDATE SET key=EXCLUDED.key, description=EXCLUDED.description, agg_func=EXCLUDED.agg_func, agg_weights=EXCLUDED.agg_weights;

INSERT INTO field_definitions
        (id, key, description, agg_func, agg_weights)
        VALUES ('d8d6beab-e1a9-42b3-9073-999693e9fd64', 'success_rate', 'Secondary scenario score (raw values): success_rate', NULL, NULL)
        ON CONFLICT(id) DO UPDATE SET key=EXCLUDED.key, description=EXCLUDED.description, agg_func=EXCLUDED.agg_func, agg_weights=EXCLUDED.agg_weights;

INSERT INTO scenario_definitions
    (id, name, description, field_ids)
    VALUES ('8c558c8b-1a04-4c38-9f98-20cd5c8195a7', 'Scenario 125 - Punctuality measures the percentage of trains arriving at their destinations on time (the train doesn’t arrive after planned arrival) and the train didn’t depart before planned departure time. The goal is to maintain a high level of reliability and minimize delays for passengers and freight services. ', 'This KPI contributes to evaluating Effectiveness of the AI-based assistant, as part of Task 4.1 evaluation objectives, and O2 main project objective:<br/>- Improve customer satisfaction by ensuring timely arrivals<br/>- Guarantee maximal planned connection<br/>- Minimize operational disruptions caused by delays<br/>- Meet regulatory and stakeholder benchmarks for punctuality<br/>This KPI is linked with project’s Long Term Expected Impacts (LTEI) (LTEI1)KPIS-3:<br/>- 10% increase in punctuality in long-range traffic<br/>- 5% increase in punctuality in regional traffic (with realistic disturbances)<br/>', array['a166354f-80be-4621-b485-1afa80ef42e2', '65011186-26f6-4e3d-8179-e2bd1f30fe21']::uuid[])
    ON CONFLICT(id) DO UPDATE SET name=EXCLUDED.name, description=EXCLUDED.description, field_ids=EXCLUDED.field_ids;

INSERT INTO field_definitions
        (id, key, description, agg_func, agg_weights)
        VALUES ('a166354f-80be-4621-b485-1afa80ef42e2', 'sum_normalized_reward', 'Primary scenario score (raw values): sum_normalized_reward', NULL, NULL)
        ON CONFLICT(id) DO UPDATE SET key=EXCLUDED.key, description=EXCLUDED.description, agg_func=EXCLUDED.agg_func, agg_weights=EXCLUDED.agg_weights;

INSERT INTO field_definitions
        (id, key, description, agg_func, agg_weights)
        VALUES ('65011186-26f6-4e3d-8179-e2bd1f30fe21', 'success_rate', 'Secondary scenario score (raw values): success_rate', NULL, NULL)
        ON CONFLICT(id) DO UPDATE SET key=EXCLUDED.key, description=EXCLUDED.description, agg_func=EXCLUDED.agg_func, agg_weights=EXCLUDED.agg_weights;

INSERT INTO scenario_definitions
    (id, name, description, field_ids)
    VALUES ('5c025c8a-a032-494f-8204-dd92b1067448', 'Scenario 126 - Punctuality measures the percentage of trains arriving at their destinations on time (the train doesn’t arrive after planned arrival) and the train didn’t depart before planned departure time. The goal is to maintain a high level of reliability and minimize delays for passengers and freight services. ', 'This KPI contributes to evaluating Effectiveness of the AI-based assistant, as part of Task 4.1 evaluation objectives, and O2 main project objective:<br/>- Improve customer satisfaction by ensuring timely arrivals<br/>- Guarantee maximal planned connection<br/>- Minimize operational disruptions caused by delays<br/>- Meet regulatory and stakeholder benchmarks for punctuality<br/>This KPI is linked with project’s Long Term Expected Impacts (LTEI) (LTEI1)KPIS-3:<br/>- 10% increase in punctuality in long-range traffic<br/>- 5% increase in punctuality in regional traffic (with realistic disturbances)<br/>', array['cf482281-7e9d-43b5-97b2-71fedd958471', 'd34deb20-1708-42fd-ad2d-2cd00e15c423']::uuid[])
    ON CONFLICT(id) DO UPDATE SET name=EXCLUDED.name, description=EXCLUDED.description, field_ids=EXCLUDED.field_ids;

INSERT INTO field_definitions
        (id, key, description, agg_func, agg_weights)
        VALUES ('cf482281-7e9d-43b5-97b2-71fedd958471', 'sum_normalized_reward', 'Primary scenario score (raw values): sum_normalized_reward', NULL, NULL)
        ON CONFLICT(id) DO UPDATE SET key=EXCLUDED.key, description=EXCLUDED.description, agg_func=EXCLUDED.agg_func, agg_weights=EXCLUDED.agg_weights;

INSERT INTO field_definitions
        (id, key, description, agg_func, agg_weights)
        VALUES ('d34deb20-1708-42fd-ad2d-2cd00e15c423', 'success_rate', 'Secondary scenario score (raw values): success_rate', NULL, NULL)
        ON CONFLICT(id) DO UPDATE SET key=EXCLUDED.key, description=EXCLUDED.description, agg_func=EXCLUDED.agg_func, agg_weights=EXCLUDED.agg_weights;

INSERT INTO scenario_definitions
    (id, name, description, field_ids)
    VALUES ('441fe9aa-79d7-4e27-8fb5-213c77c4f295', 'Scenario 127 - Punctuality measures the percentage of trains arriving at their destinations on time (the train doesn’t arrive after planned arrival) and the train didn’t depart before planned departure time. The goal is to maintain a high level of reliability and minimize delays for passengers and freight services. ', 'This KPI contributes to evaluating Effectiveness of the AI-based assistant, as part of Task 4.1 evaluation objectives, and O2 main project objective:<br/>- Improve customer satisfaction by ensuring timely arrivals<br/>- Guarantee maximal planned connection<br/>- Minimize operational disruptions caused by delays<br/>- Meet regulatory and stakeholder benchmarks for punctuality<br/>This KPI is linked with project’s Long Term Expected Impacts (LTEI) (LTEI1)KPIS-3:<br/>- 10% increase in punctuality in long-range traffic<br/>- 5% increase in punctuality in regional traffic (with realistic disturbances)<br/>', array['36ffcc4b-a24c-47f7-b903-493310d54981', '5d0d5e02-bbe2-4754-b9ac-6f52346a59ae']::uuid[])
    ON CONFLICT(id) DO UPDATE SET name=EXCLUDED.name, description=EXCLUDED.description, field_ids=EXCLUDED.field_ids;

INSERT INTO field_definitions
        (id, key, description, agg_func, agg_weights)
        VALUES ('36ffcc4b-a24c-47f7-b903-493310d54981', 'sum_normalized_reward', 'Primary scenario score (raw values): sum_normalized_reward', NULL, NULL)
        ON CONFLICT(id) DO UPDATE SET key=EXCLUDED.key, description=EXCLUDED.description, agg_func=EXCLUDED.agg_func, agg_weights=EXCLUDED.agg_weights;

INSERT INTO field_definitions
        (id, key, description, agg_func, agg_weights)
        VALUES ('5d0d5e02-bbe2-4754-b9ac-6f52346a59ae', 'success_rate', 'Secondary scenario score (raw values): success_rate', NULL, NULL)
        ON CONFLICT(id) DO UPDATE SET key=EXCLUDED.key, description=EXCLUDED.description, agg_func=EXCLUDED.agg_func, agg_weights=EXCLUDED.agg_weights;

INSERT INTO scenario_definitions
    (id, name, description, field_ids)
    VALUES ('b630c1ad-f3a1-41c3-8e34-735a78dec9d1', 'Scenario 128 - Punctuality measures the percentage of trains arriving at their destinations on time (the train doesn’t arrive after planned arrival) and the train didn’t depart before planned departure time. The goal is to maintain a high level of reliability and minimize delays for passengers and freight services. ', 'This KPI contributes to evaluating Effectiveness of the AI-based assistant, as part of Task 4.1 evaluation objectives, and O2 main project objective:<br/>- Improve customer satisfaction by ensuring timely arrivals<br/>- Guarantee maximal planned connection<br/>- Minimize operational disruptions caused by delays<br/>- Meet regulatory and stakeholder benchmarks for punctuality<br/>This KPI is linked with project’s Long Term Expected Impacts (LTEI) (LTEI1)KPIS-3:<br/>- 10% increase in punctuality in long-range traffic<br/>- 5% increase in punctuality in regional traffic (with realistic disturbances)<br/>', array['b71b7989-60b0-4d05-9eab-826c59bec671', '4597805c-46cd-49b0-9bba-9b0c2289f1e0']::uuid[])
    ON CONFLICT(id) DO UPDATE SET name=EXCLUDED.name, description=EXCLUDED.description, field_ids=EXCLUDED.field_ids;

INSERT INTO field_definitions
        (id, key, description, agg_func, agg_weights)
        VALUES ('b71b7989-60b0-4d05-9eab-826c59bec671', 'sum_normalized_reward', 'Primary scenario score (raw values): sum_normalized_reward', NULL, NULL)
        ON CONFLICT(id) DO UPDATE SET key=EXCLUDED.key, description=EXCLUDED.description, agg_func=EXCLUDED.agg_func, agg_weights=EXCLUDED.agg_weights;

INSERT INTO field_definitions
        (id, key, description, agg_func, agg_weights)
        VALUES ('4597805c-46cd-49b0-9bba-9b0c2289f1e0', 'success_rate', 'Secondary scenario score (raw values): success_rate', NULL, NULL)
        ON CONFLICT(id) DO UPDATE SET key=EXCLUDED.key, description=EXCLUDED.description, agg_func=EXCLUDED.agg_func, agg_weights=EXCLUDED.agg_weights;

INSERT INTO scenario_definitions
    (id, name, description, field_ids)
    VALUES ('3200dbee-2685-48c7-a7dc-2e780853efda', 'Scenario 129 - Punctuality measures the percentage of trains arriving at their destinations on time (the train doesn’t arrive after planned arrival) and the train didn’t depart before planned departure time. The goal is to maintain a high level of reliability and minimize delays for passengers and freight services. ', 'This KPI contributes to evaluating Effectiveness of the AI-based assistant, as part of Task 4.1 evaluation objectives, and O2 main project objective:<br/>- Improve customer satisfaction by ensuring timely arrivals<br/>- Guarantee maximal planned connection<br/>- Minimize operational disruptions caused by delays<br/>- Meet regulatory and stakeholder benchmarks for punctuality<br/>This KPI is linked with project’s Long Term Expected Impacts (LTEI) (LTEI1)KPIS-3:<br/>- 10% increase in punctuality in long-range traffic<br/>- 5% increase in punctuality in regional traffic (with realistic disturbances)<br/>', array['d49d49cf-7608-4ff0-8ac0-adb5d3ba4824', '00cd6ddb-ade1-40f0-84d6-aa4b1e817be2']::uuid[])
    ON CONFLICT(id) DO UPDATE SET name=EXCLUDED.name, description=EXCLUDED.description, field_ids=EXCLUDED.field_ids;

INSERT INTO field_definitions
        (id, key, description, agg_func, agg_weights)
        VALUES ('d49d49cf-7608-4ff0-8ac0-adb5d3ba4824', 'sum_normalized_reward', 'Primary scenario score (raw values): sum_normalized_reward', NULL, NULL)
        ON CONFLICT(id) DO UPDATE SET key=EXCLUDED.key, description=EXCLUDED.description, agg_func=EXCLUDED.agg_func, agg_weights=EXCLUDED.agg_weights;

INSERT INTO field_definitions
        (id, key, description, agg_func, agg_weights)
        VALUES ('00cd6ddb-ade1-40f0-84d6-aa4b1e817be2', 'success_rate', 'Secondary scenario score (raw values): success_rate', NULL, NULL)
        ON CONFLICT(id) DO UPDATE SET key=EXCLUDED.key, description=EXCLUDED.description, agg_func=EXCLUDED.agg_func, agg_weights=EXCLUDED.agg_weights;

INSERT INTO scenario_definitions
    (id, name, description, field_ids)
    VALUES ('46583ddd-855b-4e6d-8711-d7b5a4fd26c1', 'Scenario 130 - Punctuality measures the percentage of trains arriving at their destinations on time (the train doesn’t arrive after planned arrival) and the train didn’t depart before planned departure time. The goal is to maintain a high level of reliability and minimize delays for passengers and freight services. ', 'This KPI contributes to evaluating Effectiveness of the AI-based assistant, as part of Task 4.1 evaluation objectives, and O2 main project objective:<br/>- Improve customer satisfaction by ensuring timely arrivals<br/>- Guarantee maximal planned connection<br/>- Minimize operational disruptions caused by delays<br/>- Meet regulatory and stakeholder benchmarks for punctuality<br/>This KPI is linked with project’s Long Term Expected Impacts (LTEI) (LTEI1)KPIS-3:<br/>- 10% increase in punctuality in long-range traffic<br/>- 5% increase in punctuality in regional traffic (with realistic disturbances)<br/>', array['c795f997-0292-40fe-ae08-02a19d5f5fcd', 'b0d6d37d-b2d6-473e-8f28-9493a172b805']::uuid[])
    ON CONFLICT(id) DO UPDATE SET name=EXCLUDED.name, description=EXCLUDED.description, field_ids=EXCLUDED.field_ids;

INSERT INTO field_definitions
        (id, key, description, agg_func, agg_weights)
        VALUES ('c795f997-0292-40fe-ae08-02a19d5f5fcd', 'sum_normalized_reward', 'Primary scenario score (raw values): sum_normalized_reward', NULL, NULL)
        ON CONFLICT(id) DO UPDATE SET key=EXCLUDED.key, description=EXCLUDED.description, agg_func=EXCLUDED.agg_func, agg_weights=EXCLUDED.agg_weights;

INSERT INTO field_definitions
        (id, key, description, agg_func, agg_weights)
        VALUES ('b0d6d37d-b2d6-473e-8f28-9493a172b805', 'success_rate', 'Secondary scenario score (raw values): success_rate', NULL, NULL)
        ON CONFLICT(id) DO UPDATE SET key=EXCLUDED.key, description=EXCLUDED.description, agg_func=EXCLUDED.agg_func, agg_weights=EXCLUDED.agg_weights;

INSERT INTO scenario_definitions
    (id, name, description, field_ids)
    VALUES ('a497e35d-fd84-4be2-a45d-f847962cd5f8', 'Scenario 131 - Punctuality measures the percentage of trains arriving at their destinations on time (the train doesn’t arrive after planned arrival) and the train didn’t depart before planned departure time. The goal is to maintain a high level of reliability and minimize delays for passengers and freight services. ', 'This KPI contributes to evaluating Effectiveness of the AI-based assistant, as part of Task 4.1 evaluation objectives, and O2 main project objective:<br/>- Improve customer satisfaction by ensuring timely arrivals<br/>- Guarantee maximal planned connection<br/>- Minimize operational disruptions caused by delays<br/>- Meet regulatory and stakeholder benchmarks for punctuality<br/>This KPI is linked with project’s Long Term Expected Impacts (LTEI) (LTEI1)KPIS-3:<br/>- 10% increase in punctuality in long-range traffic<br/>- 5% increase in punctuality in regional traffic (with realistic disturbances)<br/>', array['5b85ebe9-f610-4a1a-8c71-ec6425a493dc', 'c0e63270-e320-4d5a-8f9c-89d27758a0d3']::uuid[])
    ON CONFLICT(id) DO UPDATE SET name=EXCLUDED.name, description=EXCLUDED.description, field_ids=EXCLUDED.field_ids;

INSERT INTO field_definitions
        (id, key, description, agg_func, agg_weights)
        VALUES ('5b85ebe9-f610-4a1a-8c71-ec6425a493dc', 'sum_normalized_reward', 'Primary scenario score (raw values): sum_normalized_reward', NULL, NULL)
        ON CONFLICT(id) DO UPDATE SET key=EXCLUDED.key, description=EXCLUDED.description, agg_func=EXCLUDED.agg_func, agg_weights=EXCLUDED.agg_weights;

INSERT INTO field_definitions
        (id, key, description, agg_func, agg_weights)
        VALUES ('c0e63270-e320-4d5a-8f9c-89d27758a0d3', 'success_rate', 'Secondary scenario score (raw values): success_rate', NULL, NULL)
        ON CONFLICT(id) DO UPDATE SET key=EXCLUDED.key, description=EXCLUDED.description, agg_func=EXCLUDED.agg_func, agg_weights=EXCLUDED.agg_weights;

INSERT INTO scenario_definitions
    (id, name, description, field_ids)
    VALUES ('295d5dc4-f4d4-4016-8fc0-4badd1b9c94e', 'Scenario 132 - Punctuality measures the percentage of trains arriving at their destinations on time (the train doesn’t arrive after planned arrival) and the train didn’t depart before planned departure time. The goal is to maintain a high level of reliability and minimize delays for passengers and freight services. ', 'This KPI contributes to evaluating Effectiveness of the AI-based assistant, as part of Task 4.1 evaluation objectives, and O2 main project objective:<br/>- Improve customer satisfaction by ensuring timely arrivals<br/>- Guarantee maximal planned connection<br/>- Minimize operational disruptions caused by delays<br/>- Meet regulatory and stakeholder benchmarks for punctuality<br/>This KPI is linked with project’s Long Term Expected Impacts (LTEI) (LTEI1)KPIS-3:<br/>- 10% increase in punctuality in long-range traffic<br/>- 5% increase in punctuality in regional traffic (with realistic disturbances)<br/>', array['2ad34efc-046d-42d1-b29e-6d2f5e76f5b1', '330941f5-2289-448f-86e1-ff5595f2b9df']::uuid[])
    ON CONFLICT(id) DO UPDATE SET name=EXCLUDED.name, description=EXCLUDED.description, field_ids=EXCLUDED.field_ids;

INSERT INTO field_definitions
        (id, key, description, agg_func, agg_weights)
        VALUES ('2ad34efc-046d-42d1-b29e-6d2f5e76f5b1', 'sum_normalized_reward', 'Primary scenario score (raw values): sum_normalized_reward', NULL, NULL)
        ON CONFLICT(id) DO UPDATE SET key=EXCLUDED.key, description=EXCLUDED.description, agg_func=EXCLUDED.agg_func, agg_weights=EXCLUDED.agg_weights;

INSERT INTO field_definitions
        (id, key, description, agg_func, agg_weights)
        VALUES ('330941f5-2289-448f-86e1-ff5595f2b9df', 'success_rate', 'Secondary scenario score (raw values): success_rate', NULL, NULL)
        ON CONFLICT(id) DO UPDATE SET key=EXCLUDED.key, description=EXCLUDED.description, agg_func=EXCLUDED.agg_func, agg_weights=EXCLUDED.agg_weights;

INSERT INTO scenario_definitions
    (id, name, description, field_ids)
    VALUES ('f8934f7d-e1f6-462e-8a12-dc82c440bc90', 'Scenario 133 - Punctuality measures the percentage of trains arriving at their destinations on time (the train doesn’t arrive after planned arrival) and the train didn’t depart before planned departure time. The goal is to maintain a high level of reliability and minimize delays for passengers and freight services. ', 'This KPI contributes to evaluating Effectiveness of the AI-based assistant, as part of Task 4.1 evaluation objectives, and O2 main project objective:<br/>- Improve customer satisfaction by ensuring timely arrivals<br/>- Guarantee maximal planned connection<br/>- Minimize operational disruptions caused by delays<br/>- Meet regulatory and stakeholder benchmarks for punctuality<br/>This KPI is linked with project’s Long Term Expected Impacts (LTEI) (LTEI1)KPIS-3:<br/>- 10% increase in punctuality in long-range traffic<br/>- 5% increase in punctuality in regional traffic (with realistic disturbances)<br/>', array['5f4d93ba-e8f1-4644-a2d0-0868cc8b932a', '1c1e81db-28fe-4f34-8a7e-99182c8ae009']::uuid[])
    ON CONFLICT(id) DO UPDATE SET name=EXCLUDED.name, description=EXCLUDED.description, field_ids=EXCLUDED.field_ids;

INSERT INTO field_definitions
        (id, key, description, agg_func, agg_weights)
        VALUES ('5f4d93ba-e8f1-4644-a2d0-0868cc8b932a', 'sum_normalized_reward', 'Primary scenario score (raw values): sum_normalized_reward', NULL, NULL)
        ON CONFLICT(id) DO UPDATE SET key=EXCLUDED.key, description=EXCLUDED.description, agg_func=EXCLUDED.agg_func, agg_weights=EXCLUDED.agg_weights;

INSERT INTO field_definitions
        (id, key, description, agg_func, agg_weights)
        VALUES ('1c1e81db-28fe-4f34-8a7e-99182c8ae009', 'success_rate', 'Secondary scenario score (raw values): success_rate', NULL, NULL)
        ON CONFLICT(id) DO UPDATE SET key=EXCLUDED.key, description=EXCLUDED.description, agg_func=EXCLUDED.agg_func, agg_weights=EXCLUDED.agg_weights;

INSERT INTO scenario_definitions
    (id, name, description, field_ids)
    VALUES ('30fd755b-9f29-4330-b4d3-8eccc44ffade', 'Scenario 134 - Punctuality measures the percentage of trains arriving at their destinations on time (the train doesn’t arrive after planned arrival) and the train didn’t depart before planned departure time. The goal is to maintain a high level of reliability and minimize delays for passengers and freight services. ', 'This KPI contributes to evaluating Effectiveness of the AI-based assistant, as part of Task 4.1 evaluation objectives, and O2 main project objective:<br/>- Improve customer satisfaction by ensuring timely arrivals<br/>- Guarantee maximal planned connection<br/>- Minimize operational disruptions caused by delays<br/>- Meet regulatory and stakeholder benchmarks for punctuality<br/>This KPI is linked with project’s Long Term Expected Impacts (LTEI) (LTEI1)KPIS-3:<br/>- 10% increase in punctuality in long-range traffic<br/>- 5% increase in punctuality in regional traffic (with realistic disturbances)<br/>', array['c7faaad0-fc28-4983-91da-d28db92bd1b0', '3b0b9a54-98a3-432e-aacf-f4d5116e3e39']::uuid[])
    ON CONFLICT(id) DO UPDATE SET name=EXCLUDED.name, description=EXCLUDED.description, field_ids=EXCLUDED.field_ids;

INSERT INTO field_definitions
        (id, key, description, agg_func, agg_weights)
        VALUES ('c7faaad0-fc28-4983-91da-d28db92bd1b0', 'sum_normalized_reward', 'Primary scenario score (raw values): sum_normalized_reward', NULL, NULL)
        ON CONFLICT(id) DO UPDATE SET key=EXCLUDED.key, description=EXCLUDED.description, agg_func=EXCLUDED.agg_func, agg_weights=EXCLUDED.agg_weights;

INSERT INTO field_definitions
        (id, key, description, agg_func, agg_weights)
        VALUES ('3b0b9a54-98a3-432e-aacf-f4d5116e3e39', 'success_rate', 'Secondary scenario score (raw values): success_rate', NULL, NULL)
        ON CONFLICT(id) DO UPDATE SET key=EXCLUDED.key, description=EXCLUDED.description, agg_func=EXCLUDED.agg_func, agg_weights=EXCLUDED.agg_weights;

INSERT INTO scenario_definitions
    (id, name, description, field_ids)
    VALUES ('a9cf3c28-8b08-451a-830f-b737936a9579', 'Scenario 135 - Punctuality measures the percentage of trains arriving at their destinations on time (the train doesn’t arrive after planned arrival) and the train didn’t depart before planned departure time. The goal is to maintain a high level of reliability and minimize delays for passengers and freight services. ', 'This KPI contributes to evaluating Effectiveness of the AI-based assistant, as part of Task 4.1 evaluation objectives, and O2 main project objective:<br/>- Improve customer satisfaction by ensuring timely arrivals<br/>- Guarantee maximal planned connection<br/>- Minimize operational disruptions caused by delays<br/>- Meet regulatory and stakeholder benchmarks for punctuality<br/>This KPI is linked with project’s Long Term Expected Impacts (LTEI) (LTEI1)KPIS-3:<br/>- 10% increase in punctuality in long-range traffic<br/>- 5% increase in punctuality in regional traffic (with realistic disturbances)<br/>', array['d8ea3306-2e4f-4cdb-9a82-5f0cf76113f2', 'c3c104fd-989c-4fe3-a751-be8b1079406c']::uuid[])
    ON CONFLICT(id) DO UPDATE SET name=EXCLUDED.name, description=EXCLUDED.description, field_ids=EXCLUDED.field_ids;

INSERT INTO field_definitions
        (id, key, description, agg_func, agg_weights)
        VALUES ('d8ea3306-2e4f-4cdb-9a82-5f0cf76113f2', 'sum_normalized_reward', 'Primary scenario score (raw values): sum_normalized_reward', NULL, NULL)
        ON CONFLICT(id) DO UPDATE SET key=EXCLUDED.key, description=EXCLUDED.description, agg_func=EXCLUDED.agg_func, agg_weights=EXCLUDED.agg_weights;

INSERT INTO field_definitions
        (id, key, description, agg_func, agg_weights)
        VALUES ('c3c104fd-989c-4fe3-a751-be8b1079406c', 'success_rate', 'Secondary scenario score (raw values): success_rate', NULL, NULL)
        ON CONFLICT(id) DO UPDATE SET key=EXCLUDED.key, description=EXCLUDED.description, agg_func=EXCLUDED.agg_func, agg_weights=EXCLUDED.agg_weights;

INSERT INTO scenario_definitions
    (id, name, description, field_ids)
    VALUES ('273b434f-74b7-4581-9d69-13f030b67313', 'Scenario 136 - Punctuality measures the percentage of trains arriving at their destinations on time (the train doesn’t arrive after planned arrival) and the train didn’t depart before planned departure time. The goal is to maintain a high level of reliability and minimize delays for passengers and freight services. ', 'This KPI contributes to evaluating Effectiveness of the AI-based assistant, as part of Task 4.1 evaluation objectives, and O2 main project objective:<br/>- Improve customer satisfaction by ensuring timely arrivals<br/>- Guarantee maximal planned connection<br/>- Minimize operational disruptions caused by delays<br/>- Meet regulatory and stakeholder benchmarks for punctuality<br/>This KPI is linked with project’s Long Term Expected Impacts (LTEI) (LTEI1)KPIS-3:<br/>- 10% increase in punctuality in long-range traffic<br/>- 5% increase in punctuality in regional traffic (with realistic disturbances)<br/>', array['22d8222b-1a16-4803-b1cf-8922ff4a51a6', '2b526862-acd5-412e-ae3f-154af9d93dc6']::uuid[])
    ON CONFLICT(id) DO UPDATE SET name=EXCLUDED.name, description=EXCLUDED.description, field_ids=EXCLUDED.field_ids;

INSERT INTO field_definitions
        (id, key, description, agg_func, agg_weights)
        VALUES ('22d8222b-1a16-4803-b1cf-8922ff4a51a6', 'sum_normalized_reward', 'Primary scenario score (raw values): sum_normalized_reward', NULL, NULL)
        ON CONFLICT(id) DO UPDATE SET key=EXCLUDED.key, description=EXCLUDED.description, agg_func=EXCLUDED.agg_func, agg_weights=EXCLUDED.agg_weights;

INSERT INTO field_definitions
        (id, key, description, agg_func, agg_weights)
        VALUES ('2b526862-acd5-412e-ae3f-154af9d93dc6', 'success_rate', 'Secondary scenario score (raw values): success_rate', NULL, NULL)
        ON CONFLICT(id) DO UPDATE SET key=EXCLUDED.key, description=EXCLUDED.description, agg_func=EXCLUDED.agg_func, agg_weights=EXCLUDED.agg_weights;

INSERT INTO scenario_definitions
    (id, name, description, field_ids)
    VALUES ('fcf115d7-4246-4790-a89d-666f368b3356', 'Scenario 137 - Punctuality measures the percentage of trains arriving at their destinations on time (the train doesn’t arrive after planned arrival) and the train didn’t depart before planned departure time. The goal is to maintain a high level of reliability and minimize delays for passengers and freight services. ', 'This KPI contributes to evaluating Effectiveness of the AI-based assistant, as part of Task 4.1 evaluation objectives, and O2 main project objective:<br/>- Improve customer satisfaction by ensuring timely arrivals<br/>- Guarantee maximal planned connection<br/>- Minimize operational disruptions caused by delays<br/>- Meet regulatory and stakeholder benchmarks for punctuality<br/>This KPI is linked with project’s Long Term Expected Impacts (LTEI) (LTEI1)KPIS-3:<br/>- 10% increase in punctuality in long-range traffic<br/>- 5% increase in punctuality in regional traffic (with realistic disturbances)<br/>', array['1e651fa2-d09d-4cfd-8920-ae87da82e8cd', '739ddb59-eeba-4cbe-b3fe-6ee6ffe64b54']::uuid[])
    ON CONFLICT(id) DO UPDATE SET name=EXCLUDED.name, description=EXCLUDED.description, field_ids=EXCLUDED.field_ids;

INSERT INTO field_definitions
        (id, key, description, agg_func, agg_weights)
        VALUES ('1e651fa2-d09d-4cfd-8920-ae87da82e8cd', 'sum_normalized_reward', 'Primary scenario score (raw values): sum_normalized_reward', NULL, NULL)
        ON CONFLICT(id) DO UPDATE SET key=EXCLUDED.key, description=EXCLUDED.description, agg_func=EXCLUDED.agg_func, agg_weights=EXCLUDED.agg_weights;

INSERT INTO field_definitions
        (id, key, description, agg_func, agg_weights)
        VALUES ('739ddb59-eeba-4cbe-b3fe-6ee6ffe64b54', 'success_rate', 'Secondary scenario score (raw values): success_rate', NULL, NULL)
        ON CONFLICT(id) DO UPDATE SET key=EXCLUDED.key, description=EXCLUDED.description, agg_func=EXCLUDED.agg_func, agg_weights=EXCLUDED.agg_weights;

INSERT INTO scenario_definitions
    (id, name, description, field_ids)
    VALUES ('c1306680-d5e0-4629-939d-ee9e3f4c439b', 'Scenario 138 - Punctuality measures the percentage of trains arriving at their destinations on time (the train doesn’t arrive after planned arrival) and the train didn’t depart before planned departure time. The goal is to maintain a high level of reliability and minimize delays for passengers and freight services. ', 'This KPI contributes to evaluating Effectiveness of the AI-based assistant, as part of Task 4.1 evaluation objectives, and O2 main project objective:<br/>- Improve customer satisfaction by ensuring timely arrivals<br/>- Guarantee maximal planned connection<br/>- Minimize operational disruptions caused by delays<br/>- Meet regulatory and stakeholder benchmarks for punctuality<br/>This KPI is linked with project’s Long Term Expected Impacts (LTEI) (LTEI1)KPIS-3:<br/>- 10% increase in punctuality in long-range traffic<br/>- 5% increase in punctuality in regional traffic (with realistic disturbances)<br/>', array['f80f23e3-9fad-45a7-ac66-54745c8894a8', '907f8a10-3697-44fd-8f53-cb3563bf3f93']::uuid[])
    ON CONFLICT(id) DO UPDATE SET name=EXCLUDED.name, description=EXCLUDED.description, field_ids=EXCLUDED.field_ids;

INSERT INTO field_definitions
        (id, key, description, agg_func, agg_weights)
        VALUES ('f80f23e3-9fad-45a7-ac66-54745c8894a8', 'sum_normalized_reward', 'Primary scenario score (raw values): sum_normalized_reward', NULL, NULL)
        ON CONFLICT(id) DO UPDATE SET key=EXCLUDED.key, description=EXCLUDED.description, agg_func=EXCLUDED.agg_func, agg_weights=EXCLUDED.agg_weights;

INSERT INTO field_definitions
        (id, key, description, agg_func, agg_weights)
        VALUES ('907f8a10-3697-44fd-8f53-cb3563bf3f93', 'success_rate', 'Secondary scenario score (raw values): success_rate', NULL, NULL)
        ON CONFLICT(id) DO UPDATE SET key=EXCLUDED.key, description=EXCLUDED.description, agg_func=EXCLUDED.agg_func, agg_weights=EXCLUDED.agg_weights;

INSERT INTO scenario_definitions
    (id, name, description, field_ids)
    VALUES ('a5cafc37-5ab6-40b2-8c1b-19089e724b1d', 'Scenario 139 - Punctuality measures the percentage of trains arriving at their destinations on time (the train doesn’t arrive after planned arrival) and the train didn’t depart before planned departure time. The goal is to maintain a high level of reliability and minimize delays for passengers and freight services. ', 'This KPI contributes to evaluating Effectiveness of the AI-based assistant, as part of Task 4.1 evaluation objectives, and O2 main project objective:<br/>- Improve customer satisfaction by ensuring timely arrivals<br/>- Guarantee maximal planned connection<br/>- Minimize operational disruptions caused by delays<br/>- Meet regulatory and stakeholder benchmarks for punctuality<br/>This KPI is linked with project’s Long Term Expected Impacts (LTEI) (LTEI1)KPIS-3:<br/>- 10% increase in punctuality in long-range traffic<br/>- 5% increase in punctuality in regional traffic (with realistic disturbances)<br/>', array['8620c1c3-60b1-4be2-8f51-43a6814eaa38', 'f7382c5d-b8a5-416b-ad9e-7640cebc3cf1']::uuid[])
    ON CONFLICT(id) DO UPDATE SET name=EXCLUDED.name, description=EXCLUDED.description, field_ids=EXCLUDED.field_ids;

INSERT INTO field_definitions
        (id, key, description, agg_func, agg_weights)
        VALUES ('8620c1c3-60b1-4be2-8f51-43a6814eaa38', 'sum_normalized_reward', 'Primary scenario score (raw values): sum_normalized_reward', NULL, NULL)
        ON CONFLICT(id) DO UPDATE SET key=EXCLUDED.key, description=EXCLUDED.description, agg_func=EXCLUDED.agg_func, agg_weights=EXCLUDED.agg_weights;

INSERT INTO field_definitions
        (id, key, description, agg_func, agg_weights)
        VALUES ('f7382c5d-b8a5-416b-ad9e-7640cebc3cf1', 'success_rate', 'Secondary scenario score (raw values): success_rate', NULL, NULL)
        ON CONFLICT(id) DO UPDATE SET key=EXCLUDED.key, description=EXCLUDED.description, agg_func=EXCLUDED.agg_func, agg_weights=EXCLUDED.agg_weights;

INSERT INTO scenario_definitions
    (id, name, description, field_ids)
    VALUES ('34606fe8-3ba5-4778-a7f0-0275c1def3b8', 'Scenario 140 - Punctuality measures the percentage of trains arriving at their destinations on time (the train doesn’t arrive after planned arrival) and the train didn’t depart before planned departure time. The goal is to maintain a high level of reliability and minimize delays for passengers and freight services. ', 'This KPI contributes to evaluating Effectiveness of the AI-based assistant, as part of Task 4.1 evaluation objectives, and O2 main project objective:<br/>- Improve customer satisfaction by ensuring timely arrivals<br/>- Guarantee maximal planned connection<br/>- Minimize operational disruptions caused by delays<br/>- Meet regulatory and stakeholder benchmarks for punctuality<br/>This KPI is linked with project’s Long Term Expected Impacts (LTEI) (LTEI1)KPIS-3:<br/>- 10% increase in punctuality in long-range traffic<br/>- 5% increase in punctuality in regional traffic (with realistic disturbances)<br/>', array['b142c94e-b58e-4a05-b4f1-60088e5c43d8', 'cc10b36a-186e-49a2-9488-8a4aeae83550']::uuid[])
    ON CONFLICT(id) DO UPDATE SET name=EXCLUDED.name, description=EXCLUDED.description, field_ids=EXCLUDED.field_ids;

INSERT INTO field_definitions
        (id, key, description, agg_func, agg_weights)
        VALUES ('b142c94e-b58e-4a05-b4f1-60088e5c43d8', 'sum_normalized_reward', 'Primary scenario score (raw values): sum_normalized_reward', NULL, NULL)
        ON CONFLICT(id) DO UPDATE SET key=EXCLUDED.key, description=EXCLUDED.description, agg_func=EXCLUDED.agg_func, agg_weights=EXCLUDED.agg_weights;

INSERT INTO field_definitions
        (id, key, description, agg_func, agg_weights)
        VALUES ('cc10b36a-186e-49a2-9488-8a4aeae83550', 'success_rate', 'Secondary scenario score (raw values): success_rate', NULL, NULL)
        ON CONFLICT(id) DO UPDATE SET key=EXCLUDED.key, description=EXCLUDED.description, agg_func=EXCLUDED.agg_func, agg_weights=EXCLUDED.agg_weights;

INSERT INTO scenario_definitions
    (id, name, description, field_ids)
    VALUES ('2d6ffd36-f33d-4a68-9868-53c7aa3f4011', 'Scenario 141 - Punctuality measures the percentage of trains arriving at their destinations on time (the train doesn’t arrive after planned arrival) and the train didn’t depart before planned departure time. The goal is to maintain a high level of reliability and minimize delays for passengers and freight services. ', 'This KPI contributes to evaluating Effectiveness of the AI-based assistant, as part of Task 4.1 evaluation objectives, and O2 main project objective:<br/>- Improve customer satisfaction by ensuring timely arrivals<br/>- Guarantee maximal planned connection<br/>- Minimize operational disruptions caused by delays<br/>- Meet regulatory and stakeholder benchmarks for punctuality<br/>This KPI is linked with project’s Long Term Expected Impacts (LTEI) (LTEI1)KPIS-3:<br/>- 10% increase in punctuality in long-range traffic<br/>- 5% increase in punctuality in regional traffic (with realistic disturbances)<br/>', array['d3f061d0-c59f-49e6-b12d-a935a00aa19f', '405cba12-df32-4e83-8066-019508c53c19']::uuid[])
    ON CONFLICT(id) DO UPDATE SET name=EXCLUDED.name, description=EXCLUDED.description, field_ids=EXCLUDED.field_ids;

INSERT INTO field_definitions
        (id, key, description, agg_func, agg_weights)
        VALUES ('d3f061d0-c59f-49e6-b12d-a935a00aa19f', 'sum_normalized_reward', 'Primary scenario score (raw values): sum_normalized_reward', NULL, NULL)
        ON CONFLICT(id) DO UPDATE SET key=EXCLUDED.key, description=EXCLUDED.description, agg_func=EXCLUDED.agg_func, agg_weights=EXCLUDED.agg_weights;

INSERT INTO field_definitions
        (id, key, description, agg_func, agg_weights)
        VALUES ('405cba12-df32-4e83-8066-019508c53c19', 'success_rate', 'Secondary scenario score (raw values): success_rate', NULL, NULL)
        ON CONFLICT(id) DO UPDATE SET key=EXCLUDED.key, description=EXCLUDED.description, agg_func=EXCLUDED.agg_func, agg_weights=EXCLUDED.agg_weights;

INSERT INTO scenario_definitions
    (id, name, description, field_ids)
    VALUES ('38e4e4d4-f801-42a0-8eac-a1a9a41a8a3e', 'Scenario 142 - Punctuality measures the percentage of trains arriving at their destinations on time (the train doesn’t arrive after planned arrival) and the train didn’t depart before planned departure time. The goal is to maintain a high level of reliability and minimize delays for passengers and freight services. ', 'This KPI contributes to evaluating Effectiveness of the AI-based assistant, as part of Task 4.1 evaluation objectives, and O2 main project objective:<br/>- Improve customer satisfaction by ensuring timely arrivals<br/>- Guarantee maximal planned connection<br/>- Minimize operational disruptions caused by delays<br/>- Meet regulatory and stakeholder benchmarks for punctuality<br/>This KPI is linked with project’s Long Term Expected Impacts (LTEI) (LTEI1)KPIS-3:<br/>- 10% increase in punctuality in long-range traffic<br/>- 5% increase in punctuality in regional traffic (with realistic disturbances)<br/>', array['c2335c97-56a7-44b5-a595-c6ed8b34c61b', '6ebf3466-fe97-4a5e-b0b6-668198637898']::uuid[])
    ON CONFLICT(id) DO UPDATE SET name=EXCLUDED.name, description=EXCLUDED.description, field_ids=EXCLUDED.field_ids;

INSERT INTO field_definitions
        (id, key, description, agg_func, agg_weights)
        VALUES ('c2335c97-56a7-44b5-a595-c6ed8b34c61b', 'sum_normalized_reward', 'Primary scenario score (raw values): sum_normalized_reward', NULL, NULL)
        ON CONFLICT(id) DO UPDATE SET key=EXCLUDED.key, description=EXCLUDED.description, agg_func=EXCLUDED.agg_func, agg_weights=EXCLUDED.agg_weights;

INSERT INTO field_definitions
        (id, key, description, agg_func, agg_weights)
        VALUES ('6ebf3466-fe97-4a5e-b0b6-668198637898', 'success_rate', 'Secondary scenario score (raw values): success_rate', NULL, NULL)
        ON CONFLICT(id) DO UPDATE SET key=EXCLUDED.key, description=EXCLUDED.description, agg_func=EXCLUDED.agg_func, agg_weights=EXCLUDED.agg_weights;

INSERT INTO scenario_definitions
    (id, name, description, field_ids)
    VALUES ('bec0103f-bdf4-42b5-b04e-a44528b8c8d1', 'Scenario 143 - Punctuality measures the percentage of trains arriving at their destinations on time (the train doesn’t arrive after planned arrival) and the train didn’t depart before planned departure time. The goal is to maintain a high level of reliability and minimize delays for passengers and freight services. ', 'This KPI contributes to evaluating Effectiveness of the AI-based assistant, as part of Task 4.1 evaluation objectives, and O2 main project objective:<br/>- Improve customer satisfaction by ensuring timely arrivals<br/>- Guarantee maximal planned connection<br/>- Minimize operational disruptions caused by delays<br/>- Meet regulatory and stakeholder benchmarks for punctuality<br/>This KPI is linked with project’s Long Term Expected Impacts (LTEI) (LTEI1)KPIS-3:<br/>- 10% increase in punctuality in long-range traffic<br/>- 5% increase in punctuality in regional traffic (with realistic disturbances)<br/>', array['6d055f50-8ae0-468d-9fb9-17937e07ac77', '0022129a-bc45-463f-89f4-9447b9f4368e']::uuid[])
    ON CONFLICT(id) DO UPDATE SET name=EXCLUDED.name, description=EXCLUDED.description, field_ids=EXCLUDED.field_ids;

INSERT INTO field_definitions
        (id, key, description, agg_func, agg_weights)
        VALUES ('6d055f50-8ae0-468d-9fb9-17937e07ac77', 'sum_normalized_reward', 'Primary scenario score (raw values): sum_normalized_reward', NULL, NULL)
        ON CONFLICT(id) DO UPDATE SET key=EXCLUDED.key, description=EXCLUDED.description, agg_func=EXCLUDED.agg_func, agg_weights=EXCLUDED.agg_weights;

INSERT INTO field_definitions
        (id, key, description, agg_func, agg_weights)
        VALUES ('0022129a-bc45-463f-89f4-9447b9f4368e', 'success_rate', 'Secondary scenario score (raw values): success_rate', NULL, NULL)
        ON CONFLICT(id) DO UPDATE SET key=EXCLUDED.key, description=EXCLUDED.description, agg_func=EXCLUDED.agg_func, agg_weights=EXCLUDED.agg_weights;

INSERT INTO scenario_definitions
    (id, name, description, field_ids)
    VALUES ('1e01bc5e-dcdb-4ef1-94a6-f4e3a77613b8', 'Scenario 144 - Punctuality measures the percentage of trains arriving at their destinations on time (the train doesn’t arrive after planned arrival) and the train didn’t depart before planned departure time. The goal is to maintain a high level of reliability and minimize delays for passengers and freight services. ', 'This KPI contributes to evaluating Effectiveness of the AI-based assistant, as part of Task 4.1 evaluation objectives, and O2 main project objective:<br/>- Improve customer satisfaction by ensuring timely arrivals<br/>- Guarantee maximal planned connection<br/>- Minimize operational disruptions caused by delays<br/>- Meet regulatory and stakeholder benchmarks for punctuality<br/>This KPI is linked with project’s Long Term Expected Impacts (LTEI) (LTEI1)KPIS-3:<br/>- 10% increase in punctuality in long-range traffic<br/>- 5% increase in punctuality in regional traffic (with realistic disturbances)<br/>', array['b1cccbf3-a1ac-44b3-ae33-f61d3b889dd3', 'd5b5c730-c9ba-4750-bc74-5ad758085cd3']::uuid[])
    ON CONFLICT(id) DO UPDATE SET name=EXCLUDED.name, description=EXCLUDED.description, field_ids=EXCLUDED.field_ids;

INSERT INTO field_definitions
        (id, key, description, agg_func, agg_weights)
        VALUES ('b1cccbf3-a1ac-44b3-ae33-f61d3b889dd3', 'sum_normalized_reward', 'Primary scenario score (raw values): sum_normalized_reward', NULL, NULL)
        ON CONFLICT(id) DO UPDATE SET key=EXCLUDED.key, description=EXCLUDED.description, agg_func=EXCLUDED.agg_func, agg_weights=EXCLUDED.agg_weights;

INSERT INTO field_definitions
        (id, key, description, agg_func, agg_weights)
        VALUES ('d5b5c730-c9ba-4750-bc74-5ad758085cd3', 'success_rate', 'Secondary scenario score (raw values): success_rate', NULL, NULL)
        ON CONFLICT(id) DO UPDATE SET key=EXCLUDED.key, description=EXCLUDED.description, agg_func=EXCLUDED.agg_func, agg_weights=EXCLUDED.agg_weights;

INSERT INTO scenario_definitions
    (id, name, description, field_ids)
    VALUES ('5debda2f-e5c1-447e-b025-d71252591074', 'Scenario 145 - Punctuality measures the percentage of trains arriving at their destinations on time (the train doesn’t arrive after planned arrival) and the train didn’t depart before planned departure time. The goal is to maintain a high level of reliability and minimize delays for passengers and freight services. ', 'This KPI contributes to evaluating Effectiveness of the AI-based assistant, as part of Task 4.1 evaluation objectives, and O2 main project objective:<br/>- Improve customer satisfaction by ensuring timely arrivals<br/>- Guarantee maximal planned connection<br/>- Minimize operational disruptions caused by delays<br/>- Meet regulatory and stakeholder benchmarks for punctuality<br/>This KPI is linked with project’s Long Term Expected Impacts (LTEI) (LTEI1)KPIS-3:<br/>- 10% increase in punctuality in long-range traffic<br/>- 5% increase in punctuality in regional traffic (with realistic disturbances)<br/>', array['a54e17a4-f6fe-4fd2-b229-1a3a62cc8021', '4ac2a873-ee4a-459a-9ab7-f7555a22d191']::uuid[])
    ON CONFLICT(id) DO UPDATE SET name=EXCLUDED.name, description=EXCLUDED.description, field_ids=EXCLUDED.field_ids;

INSERT INTO field_definitions
        (id, key, description, agg_func, agg_weights)
        VALUES ('a54e17a4-f6fe-4fd2-b229-1a3a62cc8021', 'sum_normalized_reward', 'Primary scenario score (raw values): sum_normalized_reward', NULL, NULL)
        ON CONFLICT(id) DO UPDATE SET key=EXCLUDED.key, description=EXCLUDED.description, agg_func=EXCLUDED.agg_func, agg_weights=EXCLUDED.agg_weights;

INSERT INTO field_definitions
        (id, key, description, agg_func, agg_weights)
        VALUES ('4ac2a873-ee4a-459a-9ab7-f7555a22d191', 'success_rate', 'Secondary scenario score (raw values): success_rate', NULL, NULL)
        ON CONFLICT(id) DO UPDATE SET key=EXCLUDED.key, description=EXCLUDED.description, agg_func=EXCLUDED.agg_func, agg_weights=EXCLUDED.agg_weights;

INSERT INTO scenario_definitions
    (id, name, description, field_ids)
    VALUES ('2d8872a4-f002-4294-9396-91d9cefabdb7', 'Scenario 146 - Punctuality measures the percentage of trains arriving at their destinations on time (the train doesn’t arrive after planned arrival) and the train didn’t depart before planned departure time. The goal is to maintain a high level of reliability and minimize delays for passengers and freight services. ', 'This KPI contributes to evaluating Effectiveness of the AI-based assistant, as part of Task 4.1 evaluation objectives, and O2 main project objective:<br/>- Improve customer satisfaction by ensuring timely arrivals<br/>- Guarantee maximal planned connection<br/>- Minimize operational disruptions caused by delays<br/>- Meet regulatory and stakeholder benchmarks for punctuality<br/>This KPI is linked with project’s Long Term Expected Impacts (LTEI) (LTEI1)KPIS-3:<br/>- 10% increase in punctuality in long-range traffic<br/>- 5% increase in punctuality in regional traffic (with realistic disturbances)<br/>', array['cd246af2-0ce5-4baa-bfce-c99cd7c16ec6', 'f5d587db-8ba3-4c4e-8cf5-b3ecc1a4eaf6']::uuid[])
    ON CONFLICT(id) DO UPDATE SET name=EXCLUDED.name, description=EXCLUDED.description, field_ids=EXCLUDED.field_ids;

INSERT INTO field_definitions
        (id, key, description, agg_func, agg_weights)
        VALUES ('cd246af2-0ce5-4baa-bfce-c99cd7c16ec6', 'sum_normalized_reward', 'Primary scenario score (raw values): sum_normalized_reward', NULL, NULL)
        ON CONFLICT(id) DO UPDATE SET key=EXCLUDED.key, description=EXCLUDED.description, agg_func=EXCLUDED.agg_func, agg_weights=EXCLUDED.agg_weights;

INSERT INTO field_definitions
        (id, key, description, agg_func, agg_weights)
        VALUES ('f5d587db-8ba3-4c4e-8cf5-b3ecc1a4eaf6', 'success_rate', 'Secondary scenario score (raw values): success_rate', NULL, NULL)
        ON CONFLICT(id) DO UPDATE SET key=EXCLUDED.key, description=EXCLUDED.description, agg_func=EXCLUDED.agg_func, agg_weights=EXCLUDED.agg_weights;

INSERT INTO scenario_definitions
    (id, name, description, field_ids)
    VALUES ('ac4adfe9-a213-45bd-843b-f346c9891b2c', 'Scenario 147 - Punctuality measures the percentage of trains arriving at their destinations on time (the train doesn’t arrive after planned arrival) and the train didn’t depart before planned departure time. The goal is to maintain a high level of reliability and minimize delays for passengers and freight services. ', 'This KPI contributes to evaluating Effectiveness of the AI-based assistant, as part of Task 4.1 evaluation objectives, and O2 main project objective:<br/>- Improve customer satisfaction by ensuring timely arrivals<br/>- Guarantee maximal planned connection<br/>- Minimize operational disruptions caused by delays<br/>- Meet regulatory and stakeholder benchmarks for punctuality<br/>This KPI is linked with project’s Long Term Expected Impacts (LTEI) (LTEI1)KPIS-3:<br/>- 10% increase in punctuality in long-range traffic<br/>- 5% increase in punctuality in regional traffic (with realistic disturbances)<br/>', array['fc8357db-964c-49ac-a72f-347ce4c70eb6', 'f61d83d5-1bc6-4bf5-ad03-e43d66c8aca7']::uuid[])
    ON CONFLICT(id) DO UPDATE SET name=EXCLUDED.name, description=EXCLUDED.description, field_ids=EXCLUDED.field_ids;

INSERT INTO field_definitions
        (id, key, description, agg_func, agg_weights)
        VALUES ('fc8357db-964c-49ac-a72f-347ce4c70eb6', 'sum_normalized_reward', 'Primary scenario score (raw values): sum_normalized_reward', NULL, NULL)
        ON CONFLICT(id) DO UPDATE SET key=EXCLUDED.key, description=EXCLUDED.description, agg_func=EXCLUDED.agg_func, agg_weights=EXCLUDED.agg_weights;

INSERT INTO field_definitions
        (id, key, description, agg_func, agg_weights)
        VALUES ('f61d83d5-1bc6-4bf5-ad03-e43d66c8aca7', 'success_rate', 'Secondary scenario score (raw values): success_rate', NULL, NULL)
        ON CONFLICT(id) DO UPDATE SET key=EXCLUDED.key, description=EXCLUDED.description, agg_func=EXCLUDED.agg_func, agg_weights=EXCLUDED.agg_weights;

INSERT INTO scenario_definitions
    (id, name, description, field_ids)
    VALUES ('b59c4643-2b45-45e4-89f7-007ef1955c9f', 'Scenario 148 - Punctuality measures the percentage of trains arriving at their destinations on time (the train doesn’t arrive after planned arrival) and the train didn’t depart before planned departure time. The goal is to maintain a high level of reliability and minimize delays for passengers and freight services. ', 'This KPI contributes to evaluating Effectiveness of the AI-based assistant, as part of Task 4.1 evaluation objectives, and O2 main project objective:<br/>- Improve customer satisfaction by ensuring timely arrivals<br/>- Guarantee maximal planned connection<br/>- Minimize operational disruptions caused by delays<br/>- Meet regulatory and stakeholder benchmarks for punctuality<br/>This KPI is linked with project’s Long Term Expected Impacts (LTEI) (LTEI1)KPIS-3:<br/>- 10% increase in punctuality in long-range traffic<br/>- 5% increase in punctuality in regional traffic (with realistic disturbances)<br/>', array['e3904655-f187-484c-ac97-50b955cbe50c', '8f4a8893-ae23-41bc-8abb-e15840bb8d71']::uuid[])
    ON CONFLICT(id) DO UPDATE SET name=EXCLUDED.name, description=EXCLUDED.description, field_ids=EXCLUDED.field_ids;

INSERT INTO field_definitions
        (id, key, description, agg_func, agg_weights)
        VALUES ('e3904655-f187-484c-ac97-50b955cbe50c', 'sum_normalized_reward', 'Primary scenario score (raw values): sum_normalized_reward', NULL, NULL)
        ON CONFLICT(id) DO UPDATE SET key=EXCLUDED.key, description=EXCLUDED.description, agg_func=EXCLUDED.agg_func, agg_weights=EXCLUDED.agg_weights;

INSERT INTO field_definitions
        (id, key, description, agg_func, agg_weights)
        VALUES ('8f4a8893-ae23-41bc-8abb-e15840bb8d71', 'success_rate', 'Secondary scenario score (raw values): success_rate', NULL, NULL)
        ON CONFLICT(id) DO UPDATE SET key=EXCLUDED.key, description=EXCLUDED.description, agg_func=EXCLUDED.agg_func, agg_weights=EXCLUDED.agg_weights;

INSERT INTO scenario_definitions
    (id, name, description, field_ids)
    VALUES ('f56f6f85-9aff-4f4e-bd84-8d763708e76f', 'Scenario 149 - Punctuality measures the percentage of trains arriving at their destinations on time (the train doesn’t arrive after planned arrival) and the train didn’t depart before planned departure time. The goal is to maintain a high level of reliability and minimize delays for passengers and freight services. ', 'This KPI contributes to evaluating Effectiveness of the AI-based assistant, as part of Task 4.1 evaluation objectives, and O2 main project objective:<br/>- Improve customer satisfaction by ensuring timely arrivals<br/>- Guarantee maximal planned connection<br/>- Minimize operational disruptions caused by delays<br/>- Meet regulatory and stakeholder benchmarks for punctuality<br/>This KPI is linked with project’s Long Term Expected Impacts (LTEI) (LTEI1)KPIS-3:<br/>- 10% increase in punctuality in long-range traffic<br/>- 5% increase in punctuality in regional traffic (with realistic disturbances)<br/>', array['cfb4b0f1-2d55-4457-9f7e-959fd19189d4', '3b63ceb3-1e82-467b-987f-61a62ccc355c']::uuid[])
    ON CONFLICT(id) DO UPDATE SET name=EXCLUDED.name, description=EXCLUDED.description, field_ids=EXCLUDED.field_ids;

INSERT INTO field_definitions
        (id, key, description, agg_func, agg_weights)
        VALUES ('cfb4b0f1-2d55-4457-9f7e-959fd19189d4', 'sum_normalized_reward', 'Primary scenario score (raw values): sum_normalized_reward', NULL, NULL)
        ON CONFLICT(id) DO UPDATE SET key=EXCLUDED.key, description=EXCLUDED.description, agg_func=EXCLUDED.agg_func, agg_weights=EXCLUDED.agg_weights;

INSERT INTO field_definitions
        (id, key, description, agg_func, agg_weights)
        VALUES ('3b63ceb3-1e82-467b-987f-61a62ccc355c', 'success_rate', 'Secondary scenario score (raw values): success_rate', NULL, NULL)
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
    VALUES ('437971ac-6616-429b-ad27-f8796772c570', 'Scenario 1 - The reduction in delay KPI aims to quantify the time gained overall and for each airplane, with the introduction of AI. ', 'This KPI aims to quantify the efficiency gains of AI integration by measuring how AI impacts execution time and delays. Specifically, it helps determine whether AI:<br/>- Reduces execution time deviations<br/>- Minimizes delays<br/>- Enhances consistency and reliability in operations.<br/>By evaluating these metrics, we can assess the AI’s effectiveness in improving human decision-making, reducing intervention time, and optimizing operational workflows.<br/>This KPI contributes to evaluating Effectiveness of the AI-based assistant, as part of Task 4.1 evaluation objectives, and O2 main project objective.<br/>This KPI is linked with project’s Long Term Expected Impact (LTEI) (LTEI1)KPIS-4, 3-6% improvement in flight capacity and mile extension. ', array['de36c069-a167-4c22-8b30-3f93e6588507']::uuid[])
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
    VALUES ('c5219c2e-c3b9-4e7a-aefc-b767a9b3005d', 'Scenario 1 - The Response Time KPI measures the time taken by the AI-assisted railway re-scheduling system to generate a new operational schedule in response to a disruption. This metric evaluates how quickly the system reacts to unexpected events, ensuring minimal delays and maintaining operational efficiency. ', 'This KPI contributes to evaluating Effectiveness of the AI-based assistant, as part of Task 4.1 evaluation objectives, and O2 main project objective:<br/>- To assess the speed of AI-assisted decision-making in railway operations.<br/>- To ensure rapid re-scheduling of trains in response to disturbances, minimizing the impact on passengers and freight.<br/>- To compare AI-assisted response times with traditional manual re-scheduling approaches. ', array['35d6834e-5f89-438b-adcc-326bbeda93e2']::uuid[])
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
    VALUES ('22ef21e7-d00d-4c3b-8484-7110e024a4f5', 'Scenario 1 - System efficiency measures the efficiency of the system in delivering trustworthy solutions requiring less effort and time to deliver an appropriate response by the operator.  ', 'The System efficiency KPI aims to evaluate the effectiveness of the AI solution in real operational conditions, considering not just its raw response time but also the quality and usability of its assistance. This includes how the AI presents its advice, its ease of use, the accuracy of its recommendations, and how well it integrates with existing data and workflows.<br/>The evaluation will measure the AI-human collaboration, focusing on:<br/>- Response efficiency: The time taken for the AI to generate advice and for the human operator to act on it.<br/>- Advice clarity & usability: How well structured, coherent, and understandable the AI’s suggestions are.<br/>- Data integration quality: How seamlessly the AI incorporates relevant information into its recommendations.<br/>- Human correction factor: Whether and how often the operator needs to correct or refine the AI’s output.<br/>- Decision-making speed: The overall reduction in response time achieved through AI-assisted operation.<br/>By considering these f', array['e11b124d-af80-42b7-86d1-355ce9ee83c9']::uuid[])
    ON CONFLICT(id) DO UPDATE SET name=EXCLUDED.name, description=EXCLUDED.description, field_ids=EXCLUDED.field_ids;

INSERT INTO field_definitions
        (id, key, description, agg_func, agg_weights)
        VALUES ('e11b124d-af80-42b7-86d1-355ce9ee83c9', 'primary', 'Scenario score (raw values)', NULL, NULL)
        ON CONFLICT(id) DO UPDATE SET key=EXCLUDED.key, description=EXCLUDED.description, agg_func=EXCLUDED.agg_func, agg_weights=EXCLUDED.agg_weights;

INSERT INTO test_definitions
    (id, name, description, field_ids, scenario_ids, loop, queue)
    VALUES ('58ce79e0-5c14-4c51-8d09-89f856361259', 'KPI-TS-035: Total decision time (Power Grid)', 'It is based on the overall time needed to decide, thus including the respective time taken by the AI assistant and human operator. This KPI can be detailed to specifically distinguish the time needed by the AI assistant to provide a recommendation.<br/>An assumption is that a Human Machine Interaction (HMI) module is available.  ', array['10aadaaf-daa4-4098-bd9d-2042ecb488e9']::uuid[], array['1294d425-66bd-4510-b4b3-d9f64ca0e4f9']::uuid[], 'INTERACTIVE', 'PowerGrid')
    ON CONFLICT(id) DO UPDATE SET name=EXCLUDED.name, description=EXCLUDED.description, field_ids=EXCLUDED.field_ids, scenario_ids=EXCLUDED.scenario_ids, loop=EXCLUDED.loop, queue=EXCLUDED.queue;

INSERT INTO field_definitions
        (id, key, description, agg_func, agg_weights)
        VALUES ('10aadaaf-daa4-4098-bd9d-2042ecb488e9', 'primary', 'Benchmark score (MEAN of test scores)', 'MEAN', NULL)
        ON CONFLICT(id) DO UPDATE SET key=EXCLUDED.key, description=EXCLUDED.description, agg_func=EXCLUDED.agg_func, agg_weights=EXCLUDED.agg_weights;

INSERT INTO scenario_definitions
    (id, name, description, field_ids)
    VALUES ('1294d425-66bd-4510-b4b3-d9f64ca0e4f9', 'Scenario 1 - It is based on the overall time needed to decide, thus including the respective time taken by the AI assistant and human operator. This KPI can be detailed to specifically distinguish the time needed by the AI assistant to provide a recommendation.<br/>An assumption is that a Human Machine Interaction (HMI) module is available.  ', 'This KPI addresses the following objectives:<br/>1. Given an alert, how much time is left until the problem occurs?<br/>The longer the better since it gives more time to make a decision.<br/>2. Given an alert, how much time does the AI assistant take to come up with its recommendations to mitigate the issue?<br/>The shorter the better.<br/>3. Given the recommendations by the AI assistant, how much time does the human operator take to make a final decision?<br/>The shorter the better since it indicates that the recommendations are clear and convincing for the human operator.<br/>In case there is no interaction possible between the AI assistant and the human operator, this overall split is not possible. Then there is only one overall time needed to decide, starting from the alert and ending with the final decision by the human operator.<br/>This KPI contributes to evaluating Effectiveness of the AI-based assistant, as part of Task 4.1 evaluation objectives, and O2 main project objective. ', array['fb1070a5-c929-4cd6-9723-1a5da97bfdf3']::uuid[])
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
    VALUES ('ab91af79-ffc3-4da7-916a-6574609dc1b6', 'KPI-CF-012: Carbon intensity (Power Grid)', 'Carbon intensity selectivity estimates the overall carbon intensity of the action recommendation provided by the AI assistant to the human operator: goal of carbon intensity KPI is to measure how much the actions will directly contribute to greenhouse gases emission, by focusing on CO2 (which is unfortunately not the only greenhouse gas).<br/><br/>which is calculated as the weighted averaged emission factor of generation variation, including:<br/><br/>Redispatching actions,<br/><br/>Curtailment actions. ', array['d63f9bce-a639-4d20-aece-c98a16ed1e7d']::uuid[], array['75d20248-740b-4d84-86e7-1de89f10fc1e']::uuid[], 'CLOSED', 'PowerGrid')
    ON CONFLICT(id) DO UPDATE SET name=EXCLUDED.name, description=EXCLUDED.description, field_ids=EXCLUDED.field_ids, scenario_ids=EXCLUDED.scenario_ids, loop=EXCLUDED.loop, queue=EXCLUDED.queue;

INSERT INTO field_definitions
        (id, key, description, agg_func, agg_weights)
        VALUES ('d63f9bce-a639-4d20-aece-c98a16ed1e7d', 'primary', 'Benchmark score (MEAN of test scores)', 'MEAN', NULL)
        ON CONFLICT(id) DO UPDATE SET key=EXCLUDED.key, description=EXCLUDED.description, agg_func=EXCLUDED.agg_func, agg_weights=EXCLUDED.agg_weights;

INSERT INTO scenario_definitions
    (id, name, description, field_ids)
    VALUES ('75d20248-740b-4d84-86e7-1de89f10fc1e', 'Scenario 1 - Carbon intensity selectivity estimates the overall carbon intensity of the action recommendation provided by the AI assistant to the human operator: goal of carbon intensity KPI is to measure how much the actions will directly contribute to greenhouse gases emission, by focusing on CO2 (which is unfortunately not the only greenhouse gas).<br/><br/>which is calculated as the weighted averaged emission factor of generation variation, including:<br/><br/>Redispatching actions,<br/><br/>Curtailment actions. ', 'This KPI is calculated to estimate the relative performance compared to a baseline.<br/>The main difficulty of evaluating and assessing this KPIs lies in the difficulty to establish a proper deadline:<br/>- There is no history of human actions on the digital environments used for evaluation (since they are synthetic ones),<br/>- Comparison with KPI calculated on real grid’s operations (TenneT or RTE) is not relevant since each grid has its own generation mix, and each TSO has its own operation policies (and own redispatching offers).<br/>This KPI contributes to evaluating Solution quality of the AI-based assistant, as part of Task 4.1 evaluation objectives, and O2 main project objective. ', array['e0902cd7-63b3-42ce-b8e4-5fc0dd1828b4']::uuid[])
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
    VALUES ('5dd33cc9-a4aa-4a61-bd3f-5fae1c1bf701', 'Scenario 1 - Topological action complexity KPI quantifies the topological utilization of the grid and gives insights into how many topological actions are utilized: performing too complex or too many topology actions can indeed navigate the grid into topologies that are either unknown or hard to recover from for operators. ', 'This KPI contributes to evaluating Solution quality of the AI-based assistant, as part of Task 4.1 evaluation objectives, and O2 main project objective. ', array['2cf2f20b-3970-4568-a8f4-26131ea05c52']::uuid[])
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
    VALUES ('fc090c38-8740-4911-96aa-2defd06f8715', 'Scenario 1 - The operation score KPI for operating a power grid includes the cost of a blackout, the cost of energy losses on the grid, and the cost of remedial actions. ', 'This KPI contributes to evaluating Solution quality of the AI-based assistant, as part of Task 4.1 evaluation objectives, and O2 main project objective.<br/><br/>This KPI is linked with project’s Long Term Expected Impacts (LTEI):<br/>- (LTEI1)KPIS-1, 15%-20% reduction in renewable energy curtailment due to optimal exploration of network flexibility with AI (see “Sum of curtailed RES energy volumes”)<br/>- (LTEI1)KPIS-2, 20%-30% avoided electricity demand shedding (see “Sum of remaining energy to be supplied in case of blackout”) ', array['c9b12bc9-ab15-4938-a0f1-1ca0d2434be6']::uuid[])
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
    VALUES ('bb6302f1-0dc2-43ed-976b-4e5d3126006a', 'Scenario 1 - The Network Impact Propagation KPI measures how disruptions in one part of the railway network affect the overall system, including delay propagation and congestion spillover. This KPI helps evaluate the cascading effects of local disturbances and the efficiency of AI-assisted re-scheduling in mitigating these effects. ', 'This KPI contributes to evaluating Solution quality of the AI-based assistant, as part of Task 4.1 evaluation objectives, and O2 main project objective.<br/>- To assess the ripple effects of disruptions across the railway network.<br/>- To quantify how effectively AI-assisted re-scheduling contains and mitigates propagation of delays.<br/>- To support decision-making in optimizing re-scheduling strategies for network-wide efficiency. ', array['87ca95f7-4d83-48ec-94d5-cc654e1b895e']::uuid[])
    ON CONFLICT(id) DO UPDATE SET name=EXCLUDED.name, description=EXCLUDED.description, field_ids=EXCLUDED.field_ids;

INSERT INTO field_definitions
        (id, key, description, agg_func, agg_weights)
        VALUES ('87ca95f7-4d83-48ec-94d5-cc654e1b895e', 'primary', 'Scenario score (raw values)', NULL, NULL)
        ON CONFLICT(id) DO UPDATE SET key=EXCLUDED.key, description=EXCLUDED.description, agg_func=EXCLUDED.agg_func, agg_weights=EXCLUDED.agg_weights;

INSERT INTO test_definitions
    (id, name, description, field_ids, scenario_ids, loop, queue)
    VALUES ('c69ff5e9-497b-41e8-adff-2221bb823365', 'KPI-AS-068: Assistant adaptation to user preferences (Power Grid)', 'Assistant adaptation to user preferences assesses how the AI assistant adapts to operator’s choices and preferences.<br/>The assistant provides several recommendations which represent different trade-offs of different objectives, and the operator eventually makes one single choice.<br/>This KPI assume that an estimation of epistemic uncertainty is calculated for each action recommendation, which can be used later by the human to select the action in a multi-objective setting.<br/>This KPIs thus aims at measuring:<br/>- Whether the choice that the operator makes is in the set of recommendations proposed by the assistant,<br/>- How is the recommendation chosen by the operator ranked compared to the other ones,<br/>- Whether the recommendation chosen by the operator has a high epistemic uncertainty compared to the other recommendations. ', array['c428c0f7-85d3-4f40-9710-6f8690f5cc9c']::uuid[], array['a68e7062-1329-4a34-ac44-4f6075929902']::uuid[], 'INTERACTIVE', 'PowerGrid')
    ON CONFLICT(id) DO UPDATE SET name=EXCLUDED.name, description=EXCLUDED.description, field_ids=EXCLUDED.field_ids, scenario_ids=EXCLUDED.scenario_ids, loop=EXCLUDED.loop, queue=EXCLUDED.queue;

INSERT INTO field_definitions
        (id, key, description, agg_func, agg_weights)
        VALUES ('c428c0f7-85d3-4f40-9710-6f8690f5cc9c', 'primary', 'Benchmark score (MEAN of test scores)', 'MEAN', NULL)
        ON CONFLICT(id) DO UPDATE SET key=EXCLUDED.key, description=EXCLUDED.description, agg_func=EXCLUDED.agg_func, agg_weights=EXCLUDED.agg_weights;

INSERT INTO scenario_definitions
    (id, name, description, field_ids)
    VALUES ('a68e7062-1329-4a34-ac44-4f6075929902', 'Scenario 1 - Assistant adaptation to user preferences assesses how the AI assistant adapts to operator’s choices and preferences.<br/>The assistant provides several recommendations which represent different trade-offs of different objectives, and the operator eventually makes one single choice.<br/>This KPI assume that an estimation of epistemic uncertainty is calculated for each action recommendation, which can be used later by the human to select the action in a multi-objective setting.<br/>This KPIs thus aims at measuring:<br/>- Whether the choice that the operator makes is in the set of recommendations proposed by the assistant,<br/>- How is the recommendation chosen by the operator ranked compared to the other ones,<br/>- Whether the recommendation chosen by the operator has a high epistemic uncertainty compared to the other recommendations. ', 'This KPI contributes to evaluating Solution quality of the AI-based assistant, as part of Task 4.1 evaluation objectives, and O2 main project objective. ', array['c4581424-f519-4f2f-9ca2-35e9aa85be3b']::uuid[])
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
    VALUES ('dddb0b01-6bab-408e-9b12-4d7ab8e3b542', 'Scenario 1 - This KPI represents human operators’ perceived autonomy over the process when working with the AI assistant measured with a questionnaire. ', 'This KPI contributes to evaluating AI-human task allocation balance of the AI-based assistant, as part of Task 4.3 evaluation objectives, and O3 main project objective.<br/>It is also relevant to protocols and concepts defined in D1.1 such as “Decision support for the human operator”, “Human Agency and Oversight”, “Human control/autonomy over the process”.  ', array['c4772e39-0e9e-4bb9-8fe6-24a900847f27']::uuid[])
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
    VALUES ('edcf64a8-f1b8-48ec-ab6a-229d5abc1be4', 'Scenario 1 - This KPI represents human operators’ perceived autonomy over the process when working with the AI assistant measured with a questionnaire. ', 'This KPI contributes to evaluating AI-human task allocation balance of the AI-based assistant, as part of Task 4.3 evaluation objectives, and O3 main project objective.<br/>It is also relevant to protocols and concepts defined in D1.1 such as “Decision support for the human operator”, “Human Agency and Oversight”, “Human control/autonomy over the process”.  ', array['e3b66c93-9e69-4ba7-a78f-b7fde9ad8138']::uuid[])
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
    VALUES ('3324347e-e4cb-42a2-9f53-430421090075', 'Scenario 1 - This KPI represents human operators’ perceived autonomy over the process when working with the AI assistant measured with a questionnaire. ', 'This KPI contributes to evaluating AI-human task allocation balance of the AI-based assistant, as part of Task 4.3 evaluation objectives, and O3 main project objective.<br/>It is also relevant to protocols and concepts defined in D1.1 such as “Decision support for the human operator”, “Human Agency and Oversight”, “Human control/autonomy over the process”.  ', array['32b83567-5e58-403c-b509-66a6a53d103c']::uuid[])
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
    VALUES ('e967a3b5-6d9b-41c2-9897-4e40a186e879', 'Scenario 1 - Impact on the workload KPI assesses operators’ perception of the system impact on their workload (either positive or negative)  ', 'This KPI compares if the inputs of the operators are according to their real psychophysiology. This can act as a verification methodology but also support the AI to adapt.<br/>This KPI will be analyzed together with the “Workload” KPI-WS-040.<br/>This KPI contributes to evaluating AI-human task allocation balance of the AI-based assistant, as part of Task 4.3 evaluation objectives, and O3 main project objective. ', array['d70b6f48-795a-430d-8c82-288190d35b78']::uuid[])
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
    VALUES ('df02b09a-b431-49ee-af6b-ffd709d47670', 'Scenario 1 - Impact on the workload KPI assesses operators’ perception of the system impact on their workload (either positive or negative)  ', 'This KPI compares if the inputs of the operators are according to their real psychophysiology. This can act as a verification methodology but also support the AI to adapt.<br/>This KPI will be analyzed together with the “Workload” KPI-WS-040.<br/>This KPI contributes to evaluating AI-human task allocation balance of the AI-based assistant, as part of Task 4.3 evaluation objectives, and O3 main project objective. ', array['bb67e013-b02d-460e-be59-e5ef3948e34b']::uuid[])
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
    VALUES ('fddeb18e-789e-40e0-9680-ca58ae10851f', 'Scenario 1 - Impact on the workload KPI assesses operators’ perception of the system impact on their workload (either positive or negative)  ', 'This KPI compares if the inputs of the operators are according to their real psychophysiology. This can act as a verification methodology but also support the AI to adapt.<br/>This KPI will be analyzed together with the “Workload” KPI-WS-040.<br/>This KPI contributes to evaluating AI-human task allocation balance of the AI-based assistant, as part of Task 4.3 evaluation objectives, and O3 main project objective. ', array['26c99c3e-8ad1-4241-954f-25f56fade8a0']::uuid[])
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
    VALUES ('dff7e358-ff14-45e7-bc22-aac2b50500f3', 'KPI-AF-050: AI-Agent Scalability Training (Railway)', 'AI-Agent Scalability Training measures the elapsed time required by an AI-agent to reach a predefined performance threshold. Time measured both as wallclock time (seconds) as well as steps or episodes according to the domain needs. The performance is defined by the native reward formulation defined by the digital environment or by domain experts.<br/>The time to threshold is measured across:<br/>(i) Different instance complexities;<br/>(ii) Different hardware availability.<br/>The performance threshold is set empirically and is defined by the cumulative reward formulation specific to the application domain. Note that the reward formulation used to train the agent may differ. For case (i), the type of hardware used should be logged to interpret the wallclock time measurements. ', array['91c4f865-5e81-46d3-bd23-990aa361a828']::uuid[], array['d7cea956-6803-488c-b402-079d13b892c6']::uuid[], 'CLOSED', 'Railway')
    ON CONFLICT(id) DO UPDATE SET name=EXCLUDED.name, description=EXCLUDED.description, field_ids=EXCLUDED.field_ids, scenario_ids=EXCLUDED.scenario_ids, loop=EXCLUDED.loop, queue=EXCLUDED.queue;

INSERT INTO field_definitions
        (id, key, description, agg_func, agg_weights)
        VALUES ('91c4f865-5e81-46d3-bd23-990aa361a828', 'primary', 'Benchmark score (MEAN of test scores)', 'MEAN', NULL)
        ON CONFLICT(id) DO UPDATE SET key=EXCLUDED.key, description=EXCLUDED.description, agg_func=EXCLUDED.agg_func, agg_weights=EXCLUDED.agg_weights;

INSERT INTO scenario_definitions
    (id, name, description, field_ids)
    VALUES ('d7cea956-6803-488c-b402-079d13b892c6', 'Scenario 1 - AI-Agent Scalability Training measures the elapsed time required by an AI-agent to reach a predefined performance threshold. Time measured both as wallclock time (seconds) as well as steps or episodes according to the domain needs. The performance is defined by the native reward formulation defined by the digital environment or by domain experts.<br/>The time to threshold is measured across:<br/>(i) Different instance complexities;<br/>(ii) Different hardware availability.<br/>The performance threshold is set empirically and is defined by the cumulative reward formulation specific to the application domain. Note that the reward formulation used to train the agent may differ. For case (i), the type of hardware used should be logged to interpret the wallclock time measurements. ', 'This KPI contributes to evaluating Scalability of the AI-based assistant, as part of Task 4.1 evaluation objectives, and O2 main project objective. ', array['c61d974a-44c7-44d9-8932-93654ed81ed9']::uuid[])
    ON CONFLICT(id) DO UPDATE SET name=EXCLUDED.name, description=EXCLUDED.description, field_ids=EXCLUDED.field_ids;

INSERT INTO field_definitions
        (id, key, description, agg_func, agg_weights)
        VALUES ('c61d974a-44c7-44d9-8932-93654ed81ed9', 'primary', 'Scenario score (raw values)', NULL, NULL)
        ON CONFLICT(id) DO UPDATE SET key=EXCLUDED.key, description=EXCLUDED.description, agg_func=EXCLUDED.agg_func, agg_weights=EXCLUDED.agg_weights;

INSERT INTO test_definitions
    (id, name, description, field_ids, scenario_ids, loop, queue)
    VALUES ('5af6ffd9-b0a6-4f53-94bf-058fc1383ecd', 'KPI-AF-050: AI-Agent Scalability Training (Power Grid)', 'AI-Agent Scalability Training measures the elapsed time required by an AI-agent to reach a predefined performance threshold. Time measured both as wallclock time (seconds) as well as steps or episodes according to the domain needs. The performance is defined by the native reward formulation defined by the digital environment or by domain experts.<br/>The time to threshold is measured across:<br/>(i) Different instance complexities;<br/>(ii) Different hardware availability.<br/>The performance threshold is set empirically and is defined by the cumulative reward formulation specific to the application domain. Note that the reward formulation used to train the agent may differ. For case (i), the type of hardware used should be logged to interpret the wallclock time measurements. ', array['a7c2bf7f-7845-4127-8c18-5eb820f5d317']::uuid[], array['7d2d75c8-49e0-433d-809d-b0811c8e2f06']::uuid[], 'CLOSED', 'PowerGrid')
    ON CONFLICT(id) DO UPDATE SET name=EXCLUDED.name, description=EXCLUDED.description, field_ids=EXCLUDED.field_ids, scenario_ids=EXCLUDED.scenario_ids, loop=EXCLUDED.loop, queue=EXCLUDED.queue;

INSERT INTO field_definitions
        (id, key, description, agg_func, agg_weights)
        VALUES ('a7c2bf7f-7845-4127-8c18-5eb820f5d317', 'primary', 'Benchmark score (MEAN of test scores)', 'MEAN', NULL)
        ON CONFLICT(id) DO UPDATE SET key=EXCLUDED.key, description=EXCLUDED.description, agg_func=EXCLUDED.agg_func, agg_weights=EXCLUDED.agg_weights;

INSERT INTO scenario_definitions
    (id, name, description, field_ids)
    VALUES ('7d2d75c8-49e0-433d-809d-b0811c8e2f06', 'Scenario 1 - AI-Agent Scalability Training measures the elapsed time required by an AI-agent to reach a predefined performance threshold. Time measured both as wallclock time (seconds) as well as steps or episodes according to the domain needs. The performance is defined by the native reward formulation defined by the digital environment or by domain experts.<br/>The time to threshold is measured across:<br/>(i) Different instance complexities;<br/>(ii) Different hardware availability.<br/>The performance threshold is set empirically and is defined by the cumulative reward formulation specific to the application domain. Note that the reward formulation used to train the agent may differ. For case (i), the type of hardware used should be logged to interpret the wallclock time measurements. ', 'This KPI contributes to evaluating Scalability of the AI-based assistant, as part of Task 4.1 evaluation objectives, and O2 main project objective. ', array['8232e73d-9f70-466d-ab53-c648efd58afb']::uuid[])
    ON CONFLICT(id) DO UPDATE SET name=EXCLUDED.name, description=EXCLUDED.description, field_ids=EXCLUDED.field_ids;

INSERT INTO field_definitions
        (id, key, description, agg_func, agg_weights)
        VALUES ('8232e73d-9f70-466d-ab53-c648efd58afb', 'primary', 'Scenario score (raw values)', NULL, NULL)
        ON CONFLICT(id) DO UPDATE SET key=EXCLUDED.key, description=EXCLUDED.description, agg_func=EXCLUDED.agg_func, agg_weights=EXCLUDED.agg_weights;

INSERT INTO test_definitions
    (id, name, description, field_ids, scenario_ids, loop, queue)
    VALUES ('4cba45eb-2512-4e8e-87da-d39a45e529f8', 'KPI-AF-050: AI-Agent Scalability Training (ATM)', 'AI-Agent Scalability Training measures the elapsed time required by an AI-agent to reach a predefined performance threshold. Time measured both as wallclock time (seconds) as well as steps or episodes according to the domain needs. The performance is defined by the native reward formulation defined by the digital environment or by domain experts.<br/>The time to threshold is measured across:<br/>(i) Different instance complexities;<br/>(ii) Different hardware availability.<br/>The performance threshold is set empirically and is defined by the cumulative reward formulation specific to the application domain. Note that the reward formulation used to train the agent may differ. For case (i), the type of hardware used should be logged to interpret the wallclock time measurements. ', array['0a42cb23-d3a2-4691-b430-61753b745806']::uuid[], array['89bbf582-bb03-4039-9318-1178da706760']::uuid[], 'CLOSED', 'ATM')
    ON CONFLICT(id) DO UPDATE SET name=EXCLUDED.name, description=EXCLUDED.description, field_ids=EXCLUDED.field_ids, scenario_ids=EXCLUDED.scenario_ids, loop=EXCLUDED.loop, queue=EXCLUDED.queue;

INSERT INTO field_definitions
        (id, key, description, agg_func, agg_weights)
        VALUES ('0a42cb23-d3a2-4691-b430-61753b745806', 'primary', 'Benchmark score (MEAN of test scores)', 'MEAN', NULL)
        ON CONFLICT(id) DO UPDATE SET key=EXCLUDED.key, description=EXCLUDED.description, agg_func=EXCLUDED.agg_func, agg_weights=EXCLUDED.agg_weights;

INSERT INTO scenario_definitions
    (id, name, description, field_ids)
    VALUES ('89bbf582-bb03-4039-9318-1178da706760', 'Scenario 1 - AI-Agent Scalability Training measures the elapsed time required by an AI-agent to reach a predefined performance threshold. Time measured both as wallclock time (seconds) as well as steps or episodes according to the domain needs. The performance is defined by the native reward formulation defined by the digital environment or by domain experts.<br/>The time to threshold is measured across:<br/>(i) Different instance complexities;<br/>(ii) Different hardware availability.<br/>The performance threshold is set empirically and is defined by the cumulative reward formulation specific to the application domain. Note that the reward formulation used to train the agent may differ. For case (i), the type of hardware used should be logged to interpret the wallclock time measurements. ', 'This KPI contributes to evaluating Scalability of the AI-based assistant, as part of Task 4.1 evaluation objectives, and O2 main project objective. ', array['6d8c4b1d-d30e-41e1-a0e5-dbd327af240f']::uuid[])
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
    VALUES ('1f2b1af1-dc36-49ae-9322-e61656951545', 'Scenario 1 - Compare multiple trained agents, RL-based or not, based on the average inference time to sample one or multiple actions while increasing the complexity of the scenario analysed. Complexity is a domain-relevant concept that must be defined. ', 'This KPI contributes to evaluating Scalability of the AI-based assistant, as part of Task 4.1 evaluation objectives, and O2 main project objective. ', array['60b8cf5e-e4bf-46a6-ba95-4efa12309373']::uuid[])
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
    VALUES ('547f8244-d091-40da-892d-ee24a26ee29f', 'Scenario 1 - Compare multiple trained agents, RL-based or not, based on the average inference time to sample one or multiple actions while increasing the complexity of the scenario analysed. Complexity is a domain-relevant concept that must be defined. ', 'This KPI contributes to evaluating Scalability of the AI-based assistant, as part of Task 4.1 evaluation objectives, and O2 main project objective. ', array['3f680640-3269-4678-bd28-3900b8dddd6a']::uuid[])
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
    VALUES ('b63f9a44-68e0-4850-b622-bac55d980b30', 'Scenario 1 - Compare multiple trained agents, RL-based or not, based on the average inference time to sample one or multiple actions while increasing the complexity of the scenario analysed. Complexity is a domain-relevant concept that must be defined. ', 'This KPI contributes to evaluating Scalability of the AI-based assistant, as part of Task 4.1 evaluation objectives, and O2 main project objective. ', array['51378548-5033-44f4-9578-703014cbc902']::uuid[])
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
    VALUES ('adb8b61b-6203-436d-9b40-8d4f95af7f43', 'Scenario 1 - The time or number of episodes required for the agent to regain a specific level of performance in the shifted domain after the domain shift has occurred. It can be used to evaluate how quickly an agent can adapt to new environmental conditions.  ', 'Domain adaptation (DA) is a sub-field of transfer learning. DA can be defined as the capability to deploy a model trained in one or more source domains into a different target domain. We consider that the source and target domains have the same feature space. In this sense, it is important for RL based agents to have a reasonable adaptation time to a new domain which may present a slight shift from the source domain. However, the adaptation time should also consider the performance drop into its computation, as a high performance drop after the adaptation could not be tolerated.<br/>This KPI contributes to evaluating Reliability of the AI-based assistant when dealing with real-world conditions which may be slightly different from source domain, as part of Task 4.2 evaluation objectives, and O4 main project objective. ', array['0b2b67e3-4d94-4006-9934-bbaf2184135c']::uuid[])
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
    VALUES ('81f18394-0164-4896-9408-4315bcfcc5e0', 'Scenario 1 - The time or number of episodes required for the agent to regain a specific level of performance in the shifted domain after the domain shift has occurred. It can be used to evaluate how quickly an agent can adapt to new environmental conditions.  ', 'Domain adaptation (DA) is a sub-field of transfer learning. DA can be defined as the capability to deploy a model trained in one or more source domains into a different target domain. We consider that the source and target domains have the same feature space. In this sense, it is important for RL based agents to have a reasonable adaptation time to a new domain which may present a slight shift from the source domain. However, the adaptation time should also consider the performance drop into its computation, as a high performance drop after the adaptation could not be tolerated.<br/>This KPI contributes to evaluating Reliability of the AI-based assistant when dealing with real-world conditions which may be slightly different from source domain, as part of Task 4.2 evaluation objectives, and O4 main project objective. ', array['3fdb69b7-1e58-4453-b2ca-0b559f83140a']::uuid[])
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
    VALUES ('c60afe79-dbc6-4c44-893e-387adf7bc02c', 'Scenario 1 - The time or number of episodes required for the agent to regain a specific level of performance in the shifted domain after the domain shift has occurred. It can be used to evaluate how quickly an agent can adapt to new environmental conditions.  ', 'Domain adaptation (DA) is a sub-field of transfer learning. DA can be defined as the capability to deploy a model trained in one or more source domains into a different target domain. We consider that the source and target domains have the same feature space. In this sense, it is important for RL based agents to have a reasonable adaptation time to a new domain which may present a slight shift from the source domain. However, the adaptation time should also consider the performance drop into its computation, as a high performance drop after the adaptation could not be tolerated.<br/>This KPI contributes to evaluating Reliability of the AI-based assistant when dealing with real-world conditions which may be slightly different from source domain, as part of Task 4.2 evaluation objectives, and O4 main project objective. ', array['059a334c-5dc9-4880-a4bc-0fbaab4a8135']::uuid[])
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
    VALUES ('d741cc0b-7dd9-4c2e-b23c-805b622c3878', 'Scenario 1 - Domain shift – generalization gap evaluates the absolute difference between the performance (e.g., rewards) in the training domain and the shifted domain. This metrics quantifies the extent of performance loss due to domain shift. ', 'The objective is to verify to which extent the AI-based assistant performance deteriorates when the target domain presents some changes in comparison to the source domain. If an agent can retain the same performance expectations in shifted domain, it will be qualified as reliable.<br/>This KPI contributes to evaluating Reliability of the AI-based assistant when dealing with real-world conditions which may be slightly different from source domain, as part of Task 4.2 evaluation objectives, and O4 main project objective. ', array['2cb1902a-32c0-4e53-a1f9-0edf1b7f5c33']::uuid[])
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
    VALUES ('9fdfbb00-0754-444a-88c8-c8549e2cc6f9', 'Scenario 1 - Domain shift – generalization gap evaluates the absolute difference between the performance (e.g., rewards) in the training domain and the shifted domain. This metrics quantifies the extent of performance loss due to domain shift. ', 'The objective is to verify to which extent the AI-based assistant performance deteriorates when the target domain presents some changes in comparison to the source domain. If an agent can retain the same performance expectations in shifted domain, it will be qualified as reliable.<br/>This KPI contributes to evaluating Reliability of the AI-based assistant when dealing with real-world conditions which may be slightly different from source domain, as part of Task 4.2 evaluation objectives, and O4 main project objective. ', array['9977d7d9-df1b-4842-a95a-5b8ea9a334b6']::uuid[])
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
    VALUES ('1f8238f7-f6b6-482c-96ad-f4e0880b801d', 'Scenario 1 - Domain shift – generalization gap evaluates the absolute difference between the performance (e.g., rewards) in the training domain and the shifted domain. This metrics quantifies the extent of performance loss due to domain shift. ', 'The objective is to verify to which extent the AI-based assistant performance deteriorates when the target domain presents some changes in comparison to the source domain. If an agent can retain the same performance expectations in shifted domain, it will be qualified as reliable.<br/>This KPI contributes to evaluating Reliability of the AI-based assistant when dealing with real-world conditions which may be slightly different from source domain, as part of Task 4.2 evaluation objectives, and O4 main project objective. ', array['7549c53f-8756-4b98-8c52-ba9aabc30bbf']::uuid[])
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
    VALUES ('8d292cff-0409-4ec7-83fb-3034c3a4106c', 'Scenario 1 - Domain shift – out of domain detection accuracy measures the accuracy with which the agent can detect whether it is operating in a domain that is different from the one it was trained on. It is useful for systems that need to switch strategies or request human intervention when a domain shift is detected. A recent paper proposed by Nasvytis et al. (2024) introduce various approaches for detection of OOD in RL. ', 'It is crucial for an AI-based assistant to determine whether it can make reliable decisions in a given configuration. AI algorithms tend to be more dependable when they have been trained on similar configurations. Therefore, if the AI assistant can accurately detect out-of-domain configurations, it can seek human feedback to reduce uncertainty, leading to more adapted and reliable decisions in future scenarios. This KPI allows to determine if AI-based system could detect the shift before decision making.<br/>This KPI contributes to evaluating Reliability of the AI-based assistant when dealing with real-world conditions which may be slightly different from source domain, as part of Task 4.2 evaluation objectives, and O4 main project objective. ', array['ba239c95-b828-40bd-98c8-ba673fa4b76b']::uuid[])
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
    VALUES ('747cba94-8353-4982-9964-ba0b8361e689', 'Scenario 1 - Domain shift – out of domain detection accuracy measures the accuracy with which the agent can detect whether it is operating in a domain that is different from the one it was trained on. It is useful for systems that need to switch strategies or request human intervention when a domain shift is detected. A recent paper proposed by Nasvytis et al. (2024) introduce various approaches for detection of OOD in RL. ', 'It is crucial for an AI-based assistant to determine whether it can make reliable decisions in a given configuration. AI algorithms tend to be more dependable when they have been trained on similar configurations. Therefore, if the AI assistant can accurately detect out-of-domain configurations, it can seek human feedback to reduce uncertainty, leading to more adapted and reliable decisions in future scenarios. This KPI allows to determine if AI-based system could detect the shift before decision making.<br/>This KPI contributes to evaluating Reliability of the AI-based assistant when dealing with real-world conditions which may be slightly different from source domain, as part of Task 4.2 evaluation objectives, and O4 main project objective. ', array['92ce6fe6-7144-42b1-a378-7b00ece4e84d']::uuid[])
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
    VALUES ('5b92361c-927e-4aaa-83c5-4413989282a2', 'Scenario 1 - Domain shift – out of domain detection accuracy measures the accuracy with which the agent can detect whether it is operating in a domain that is different from the one it was trained on. It is useful for systems that need to switch strategies or request human intervention when a domain shift is detected. A recent paper proposed by Nasvytis et al. (2024) introduce various approaches for detection of OOD in RL. ', 'It is crucial for an AI-based assistant to determine whether it can make reliable decisions in a given configuration. AI algorithms tend to be more dependable when they have been trained on similar configurations. Therefore, if the AI assistant can accurately detect out-of-domain configurations, it can seek human feedback to reduce uncertainty, leading to more adapted and reliable decisions in future scenarios. This KPI allows to determine if AI-based system could detect the shift before decision making.<br/>This KPI contributes to evaluating Reliability of the AI-based assistant when dealing with real-world conditions which may be slightly different from source domain, as part of Task 4.2 evaluation objectives, and O4 main project objective. ', array['57e71aab-13fd-475e-ab2c-5d6feee0ba84']::uuid[])
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
    VALUES ('4b42d9b8-9f27-4247-8bef-47ad3ce3a978', 'Scenario 1 - Domain shift – Policy robustness KPI calculates a ratio of the performance in the shifted domain to the performance in the original domain. A score close to 1 indicates high robustness, while a lower score indicates reduced performance due to the domain shift. It can be used to assess the generalization of a policy learned in a simulated environment when applied to a real-world scenario. ', 'To evaluate the robustness and generalization capability of a policy by measuring its performance ratio between a shifted domain and the original domain, ensuring that policies trained in simulated environments maintain high effectiveness when applied to real-world scenarios.<br/>This KPI contributes to evaluating Reliability of the AI-based assistant when dealing with real-world conditions which may be slightly different from source domain, as part of Task 4.2 evaluation objectives, and O4 main project objective. ', array['c4b39f46-f236-4521-abb8-b460a7893156']::uuid[])
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
    VALUES ('f393653b-850e-4c17-bed1-7fe1ca51c854', 'Scenario 1 - Domain shift – Policy robustness KPI calculates a ratio of the performance in the shifted domain to the performance in the original domain. A score close to 1 indicates high robustness, while a lower score indicates reduced performance due to the domain shift. It can be used to assess the generalization of a policy learned in a simulated environment when applied to a real-world scenario. ', 'To evaluate the robustness and generalization capability of a policy by measuring its performance ratio between a shifted domain and the original domain, ensuring that policies trained in simulated environments maintain high effectiveness when applied to real-world scenarios.<br/>This KPI contributes to evaluating Reliability of the AI-based assistant when dealing with real-world conditions which may be slightly different from source domain, as part of Task 4.2 evaluation objectives, and O4 main project objective. ', array['fb740fbf-675f-4f87-b280-1fcdfedf19ea']::uuid[])
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
    VALUES ('33e32b92-51a9-4531-8b5d-8655b758a958', 'Scenario 1 - Domain shift – Policy robustness KPI calculates a ratio of the performance in the shifted domain to the performance in the original domain. A score close to 1 indicates high robustness, while a lower score indicates reduced performance due to the domain shift. It can be used to assess the generalization of a policy learned in a simulated environment when applied to a real-world scenario. ', 'To evaluate the robustness and generalization capability of a policy by measuring its performance ratio between a shifted domain and the original domain, ensuring that policies trained in simulated environments maintain high effectiveness when applied to real-world scenarios.<br/>This KPI contributes to evaluating Reliability of the AI-based assistant when dealing with real-world conditions which may be slightly different from source domain, as part of Task 4.2 evaluation objectives, and O4 main project objective. ', array['ce3d2ed0-cb42-40e4-95e9-8a08b0eb2dfe']::uuid[])
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
    VALUES ('2238fa19-e337-49ce-a3b3-08abf85f1453', 'Scenario 1 - Robustness to domain parameters KPI evaluates the sensitivity of the agent’s performance (e.g., Reward) to changes in specific domain parameters (e.g., generators type including renewables in power grid domain). It helps to identify which environmental factors most affect the agent’s performance. ', 'To assess the sensitivity of the agent''s performance to variations in domain parameters, identifying key environmental factors that significantly impact the agent’s effectiveness and robustness, thereby guiding improvements in adaptability and resilience across different scenarios.<br/>This KPI contributes to evaluating Reliability of the AI-based assistant when dealing with real-world conditions which may be slightly different from source domain, as part of Task 4.2 evaluation objectives, and O4 main project objective. ', array['8c63f8fe-dfc7-4b94-944b-91edcc2d6762']::uuid[])
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
    VALUES ('82aed30d-9b28-4b8f-ba9a-fd05d6defec6', 'Scenario 1 - Robustness to domain parameters KPI evaluates the sensitivity of the agent’s performance (e.g., Reward) to changes in specific domain parameters (e.g., generators type including renewables in power grid domain). It helps to identify which environmental factors most affect the agent’s performance. ', 'To assess the sensitivity of the agent''s performance to variations in domain parameters, identifying key environmental factors that significantly impact the agent’s effectiveness and robustness, thereby guiding improvements in adaptability and resilience across different scenarios.<br/>This KPI contributes to evaluating Reliability of the AI-based assistant when dealing with real-world conditions which may be slightly different from source domain, as part of Task 4.2 evaluation objectives, and O4 main project objective. ', array['a2a276a5-d9ce-4d35-bc53-8b5775e01c7f']::uuid[])
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
    VALUES ('3f521f00-d5f7-4883-923a-1ec2a3022dcb', 'Scenario 1 - Robustness to domain parameters KPI evaluates the sensitivity of the agent’s performance (e.g., Reward) to changes in specific domain parameters (e.g., generators type including renewables in power grid domain). It helps to identify which environmental factors most affect the agent’s performance. ', 'To assess the sensitivity of the agent''s performance to variations in domain parameters, identifying key environmental factors that significantly impact the agent’s effectiveness and robustness, thereby guiding improvements in adaptability and resilience across different scenarios.<br/>This KPI contributes to evaluating Reliability of the AI-based assistant when dealing with real-world conditions which may be slightly different from source domain, as part of Task 4.2 evaluation objectives, and O4 main project objective. ', array['11395763-2f0e-477c-a790-244757521cd8']::uuid[])
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
    VALUES ('5d017ca4-f062-44c9-821c-31f85928903a', 'Scenario 1 - Domain shift – success rate drop KPI measures drop in the performance of the agent after the occurrence of a shift in the source domain. ', 'To quantify the decline in the agent''s performance after a shift in the source domain, providing insights into the agent''s ability to maintain effectiveness under altered conditions. This KPI helps in evaluating the agent''s resilience, adaptability, and the robustness of its training, facilitating the identification of weaknesses and the development of strategies to improve its performance in dynamic or unpredictable environments.<br/>This KPI contributes to evaluating Reliability of the AI-based assistant when dealing with real-world conditions which may be slightly different from source domain, as part of Task 4.2 evaluation objectives, and O4 main project objective. ', array['d71a4ce5-d954-4404-98a8-2f44df3c48eb']::uuid[])
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
    VALUES ('4d2b00cd-447a-4c7e-8cab-863f0402cb67', 'Scenario 1 - Domain shift – success rate drop KPI measures drop in the performance of the agent after the occurrence of a shift in the source domain. ', 'To quantify the decline in the agent''s performance after a shift in the source domain, providing insights into the agent''s ability to maintain effectiveness under altered conditions. This KPI helps in evaluating the agent''s resilience, adaptability, and the robustness of its training, facilitating the identification of weaknesses and the development of strategies to improve its performance in dynamic or unpredictable environments.<br/>This KPI contributes to evaluating Reliability of the AI-based assistant when dealing with real-world conditions which may be slightly different from source domain, as part of Task 4.2 evaluation objectives, and O4 main project objective. ', array['aa4a6491-cb70-4522-a1d4-c416c8efafb0']::uuid[])
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
    VALUES ('3ba0619c-8073-4e94-9c34-c3d5e17bcde8', 'Scenario 1 - Domain shift – success rate drop KPI measures drop in the performance of the agent after the occurrence of a shift in the source domain. ', 'To quantify the decline in the agent''s performance after a shift in the source domain, providing insights into the agent''s ability to maintain effectiveness under altered conditions. This KPI helps in evaluating the agent''s resilience, adaptability, and the robustness of its training, facilitating the identification of weaknesses and the development of strategies to improve its performance in dynamic or unpredictable environments.<br/>This KPI contributes to evaluating Reliability of the AI-based assistant when dealing with real-world conditions which may be slightly different from source domain, as part of Task 4.2 evaluation objectives, and O4 main project objective. ', array['e4db242e-60e9-4db0-bd6b-b14a4eb1ff65']::uuid[])
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
    VALUES ('cf7bb259-0ad4-4454-a9c8-eb8add0bec57', 'Scenario 1 - The rate at which an agent forgets its performance in the original domain after being exposed to a shifted domain. It helps to measure the extent to which learning in the new domain negatively impacts the agent’s ability to perform in the original domain. ', 'The objective of computing the Forgetting Rate in Domain Shift is to quantify the decline in an agent''s performance on the original domain after being trained or exposed to a shifted domain. This metric helps assess the extent of negative transfer, ensuring that adaptation to the new domain does not excessively degrade prior knowledge. A higher forgetting rate indicates a more significant loss of previously learned knowledge due to domain shift.<br/>This KPI contributes to evaluating Reliability of the AI-based assistant when dealing with real-world conditions which may be slightly different from source domain, as part of Task 4.2 evaluation objectives, and O4 main project objective. ', array['237806e9-50d9-4feb-a52d-e6359984b0e0']::uuid[])
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
    VALUES ('99dfde1e-2798-4741-b3eb-610a3e847bc8', 'Scenario 1 - The rate at which an agent forgets its performance in the original domain after being exposed to a shifted domain. It helps to measure the extent to which learning in the new domain negatively impacts the agent’s ability to perform in the original domain. ', 'The objective of computing the Forgetting Rate in Domain Shift is to quantify the decline in an agent''s performance on the original domain after being trained or exposed to a shifted domain. This metric helps assess the extent of negative transfer, ensuring that adaptation to the new domain does not excessively degrade prior knowledge. A higher forgetting rate indicates a more significant loss of previously learned knowledge due to domain shift.<br/>This KPI contributes to evaluating Reliability of the AI-based assistant when dealing with real-world conditions which may be slightly different from source domain, as part of Task 4.2 evaluation objectives, and O4 main project objective. ', array['47765b19-9357-47e2-8e9d-a97e86807170']::uuid[])
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
    VALUES ('3c03cc5e-f94e-4573-90a3-924b217442e6', 'Scenario 1 - The rate at which an agent forgets its performance in the original domain after being exposed to a shifted domain. It helps to measure the extent to which learning in the new domain negatively impacts the agent’s ability to perform in the original domain. ', 'The objective of computing the Forgetting Rate in Domain Shift is to quantify the decline in an agent''s performance on the original domain after being trained or exposed to a shifted domain. This metric helps assess the extent of negative transfer, ensuring that adaptation to the new domain does not excessively degrade prior knowledge. A higher forgetting rate indicates a more significant loss of previously learned knowledge due to domain shift.<br/>This KPI contributes to evaluating Reliability of the AI-based assistant when dealing with real-world conditions which may be slightly different from source domain, as part of Task 4.2 evaluation objectives, and O4 main project objective. ', array['ddde7763-4544-46dd-b2fa-36e340dfc58c']::uuid[])
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
    VALUES ('1cbf44c3-0c82-4f9e-9857-c7c1d96d3ab9', 'KPI-RS-058: Robustness to operator input (Railway)', 'The KPI should measure or evaluate how the trained agent behaves in terms of robustness if, during the decision-making process where a human operator makes the final decisions, a human operator occasionally intervenes and significantly overrides the autonomous decisions of the trained agent.<br/>For agents trained using machine learning methods, this can cause an offset between the type of states encountered in the training data and during deployment, especially for agents trained using reinforcement learning or similar methods where the agent itself decides which actions to execute. As a consequence of this offset, the agent might make poorer decisions if the human operator does not always follow the proposed actions of the agents.<br/>To measure how sensitive the agent is to such offsets, this KPI proposes to use a “simulated operator” that does not fully follow the course of actions suggested by the agents, and instead overwrites certain action variables set by the agents in a fraction of time steps. ', array['df5f8939-f85f-4fbb-9bea-017c46b2a8f7']::uuid[], array['7a1c9dac-ec75-42e1-9355-34d88eabc52f']::uuid[], 'INTERACTIVE', 'Railway')
    ON CONFLICT(id) DO UPDATE SET name=EXCLUDED.name, description=EXCLUDED.description, field_ids=EXCLUDED.field_ids, scenario_ids=EXCLUDED.scenario_ids, loop=EXCLUDED.loop, queue=EXCLUDED.queue;

INSERT INTO field_definitions
        (id, key, description, agg_func, agg_weights)
        VALUES ('df5f8939-f85f-4fbb-9bea-017c46b2a8f7', 'primary', 'Benchmark score (MEAN of test scores)', 'MEAN', NULL)
        ON CONFLICT(id) DO UPDATE SET key=EXCLUDED.key, description=EXCLUDED.description, agg_func=EXCLUDED.agg_func, agg_weights=EXCLUDED.agg_weights;

INSERT INTO scenario_definitions
    (id, name, description, field_ids)
    VALUES ('7a1c9dac-ec75-42e1-9355-34d88eabc52f', 'Scenario 1 - The KPI should measure or evaluate how the trained agent behaves in terms of robustness if, during the decision-making process where a human operator makes the final decisions, a human operator occasionally intervenes and significantly overrides the autonomous decisions of the trained agent.<br/>For agents trained using machine learning methods, this can cause an offset between the type of states encountered in the training data and during deployment, especially for agents trained using reinforcement learning or similar methods where the agent itself decides which actions to execute. As a consequence of this offset, the agent might make poorer decisions if the human operator does not always follow the proposed actions of the agents.<br/>To measure how sensitive the agent is to such offsets, this KPI proposes to use a “simulated operator” that does not fully follow the course of actions suggested by the agents, and instead overwrites certain action variables set by the agents in a fraction of time', 'Overall, this KPI contributes to evaluating Robustness of the AI-based assistant when dealing with real-world conditions, as part of Task 4.2 evaluation objectives, and O4 main project objective.<br/>The KPI is related to Tasks 3.1 and 3.3. Specifically, it is related to goal (4) of Task 3.1 (“Analysis of the impact of human intervention in the decision process on AI agents developed and trained towards fully autonomous behavior”), goal (1) of Task 3.3 (“Develop and expand order-agnostic network architectures adapted to the RL setting to use human-data or human-like perturbations and ensure the system can also make good decisions in the context where actions are partially chosen by the human partner”) and goal (2) of Task 3.4 (“Detect risks early on and potentially inform human supervisors, e.g. relinquish control to a human supervisor or transition into “safety mode” when necessary”).   ', array['65db1797-5f1c-4a20-9e79-f8ef95c22db5']::uuid[])
    ON CONFLICT(id) DO UPDATE SET name=EXCLUDED.name, description=EXCLUDED.description, field_ids=EXCLUDED.field_ids;

INSERT INTO field_definitions
        (id, key, description, agg_func, agg_weights)
        VALUES ('65db1797-5f1c-4a20-9e79-f8ef95c22db5', 'primary', 'Scenario score (raw values)', NULL, NULL)
        ON CONFLICT(id) DO UPDATE SET key=EXCLUDED.key, description=EXCLUDED.description, agg_func=EXCLUDED.agg_func, agg_weights=EXCLUDED.agg_weights;

INSERT INTO test_definitions
    (id, name, description, field_ids, scenario_ids, loop, queue)
    VALUES ('75cc9343-9371-4eb1-9613-22a26c67fc00', 'KPI-RS-058: Robustness to operator input (Power Grid)', 'The KPI should measure or evaluate how the trained agent behaves in terms of robustness if, during the decision-making process where a human operator makes the final decisions, a human operator occasionally intervenes and significantly overrides the autonomous decisions of the trained agent.<br/>For agents trained using machine learning methods, this can cause an offset between the type of states encountered in the training data and during deployment, especially for agents trained using reinforcement learning or similar methods where the agent itself decides which actions to execute. As a consequence of this offset, the agent might make poorer decisions if the human operator does not always follow the proposed actions of the agents.<br/>To measure how sensitive the agent is to such offsets, this KPI proposes to use a “simulated operator” that does not fully follow the course of actions suggested by the agents, and instead overwrites certain action variables set by the agents in a fraction of time steps. ', array['6e222adc-3153-4763-8bca-256cbb3d8716']::uuid[], array['0c0730f2-e795-4c9d-8220-9bee29c46dc6']::uuid[], 'INTERACTIVE', 'PowerGrid')
    ON CONFLICT(id) DO UPDATE SET name=EXCLUDED.name, description=EXCLUDED.description, field_ids=EXCLUDED.field_ids, scenario_ids=EXCLUDED.scenario_ids, loop=EXCLUDED.loop, queue=EXCLUDED.queue;

INSERT INTO field_definitions
        (id, key, description, agg_func, agg_weights)
        VALUES ('6e222adc-3153-4763-8bca-256cbb3d8716', 'primary', 'Benchmark score (MEAN of test scores)', 'MEAN', NULL)
        ON CONFLICT(id) DO UPDATE SET key=EXCLUDED.key, description=EXCLUDED.description, agg_func=EXCLUDED.agg_func, agg_weights=EXCLUDED.agg_weights;

INSERT INTO scenario_definitions
    (id, name, description, field_ids)
    VALUES ('0c0730f2-e795-4c9d-8220-9bee29c46dc6', 'Scenario 1 - The KPI should measure or evaluate how the trained agent behaves in terms of robustness if, during the decision-making process where a human operator makes the final decisions, a human operator occasionally intervenes and significantly overrides the autonomous decisions of the trained agent.<br/>For agents trained using machine learning methods, this can cause an offset between the type of states encountered in the training data and during deployment, especially for agents trained using reinforcement learning or similar methods where the agent itself decides which actions to execute. As a consequence of this offset, the agent might make poorer decisions if the human operator does not always follow the proposed actions of the agents.<br/>To measure how sensitive the agent is to such offsets, this KPI proposes to use a “simulated operator” that does not fully follow the course of actions suggested by the agents, and instead overwrites certain action variables set by the agents in a fraction of time', 'Overall, this KPI contributes to evaluating Robustness of the AI-based assistant when dealing with real-world conditions, as part of Task 4.2 evaluation objectives, and O4 main project objective.<br/>The KPI is related to Tasks 3.1 and 3.3. Specifically, it is related to goal (4) of Task 3.1 (“Analysis of the impact of human intervention in the decision process on AI agents developed and trained towards fully autonomous behavior”), goal (1) of Task 3.3 (“Develop and expand order-agnostic network architectures adapted to the RL setting to use human-data or human-like perturbations and ensure the system can also make good decisions in the context where actions are partially chosen by the human partner”) and goal (2) of Task 3.4 (“Detect risks early on and potentially inform human supervisors, e.g. relinquish control to a human supervisor or transition into “safety mode” when necessary”).   ', array['729d218a-950e-4aa3-8153-2643347869de']::uuid[])
    ON CONFLICT(id) DO UPDATE SET name=EXCLUDED.name, description=EXCLUDED.description, field_ids=EXCLUDED.field_ids;

INSERT INTO field_definitions
        (id, key, description, agg_func, agg_weights)
        VALUES ('729d218a-950e-4aa3-8153-2643347869de', 'primary', 'Scenario score (raw values)', NULL, NULL)
        ON CONFLICT(id) DO UPDATE SET key=EXCLUDED.key, description=EXCLUDED.description, agg_func=EXCLUDED.agg_func, agg_weights=EXCLUDED.agg_weights;

INSERT INTO test_definitions
    (id, name, description, field_ids, scenario_ids, loop, queue)
    VALUES ('07881948-f5e0-4772-83c9-3ca517ac245f', 'KPI-RS-058: Robustness to operator input (ATM)', 'The KPI should measure or evaluate how the trained agent behaves in terms of robustness if, during the decision-making process where a human operator makes the final decisions, a human operator occasionally intervenes and significantly overrides the autonomous decisions of the trained agent.<br/>For agents trained using machine learning methods, this can cause an offset between the type of states encountered in the training data and during deployment, especially for agents trained using reinforcement learning or similar methods where the agent itself decides which actions to execute. As a consequence of this offset, the agent might make poorer decisions if the human operator does not always follow the proposed actions of the agents.<br/>To measure how sensitive the agent is to such offsets, this KPI proposes to use a “simulated operator” that does not fully follow the course of actions suggested by the agents, and instead overwrites certain action variables set by the agents in a fraction of time steps. ', array['9916de43-06b8-413f-bc55-3ff7c10757ce']::uuid[], array['2d805705-e6b1-45e2-8511-39d3d23a9994']::uuid[], 'INTERACTIVE', 'ATM')
    ON CONFLICT(id) DO UPDATE SET name=EXCLUDED.name, description=EXCLUDED.description, field_ids=EXCLUDED.field_ids, scenario_ids=EXCLUDED.scenario_ids, loop=EXCLUDED.loop, queue=EXCLUDED.queue;

INSERT INTO field_definitions
        (id, key, description, agg_func, agg_weights)
        VALUES ('9916de43-06b8-413f-bc55-3ff7c10757ce', 'primary', 'Benchmark score (MEAN of test scores)', 'MEAN', NULL)
        ON CONFLICT(id) DO UPDATE SET key=EXCLUDED.key, description=EXCLUDED.description, agg_func=EXCLUDED.agg_func, agg_weights=EXCLUDED.agg_weights;

INSERT INTO scenario_definitions
    (id, name, description, field_ids)
    VALUES ('2d805705-e6b1-45e2-8511-39d3d23a9994', 'Scenario 1 - The KPI should measure or evaluate how the trained agent behaves in terms of robustness if, during the decision-making process where a human operator makes the final decisions, a human operator occasionally intervenes and significantly overrides the autonomous decisions of the trained agent.<br/>For agents trained using machine learning methods, this can cause an offset between the type of states encountered in the training data and during deployment, especially for agents trained using reinforcement learning or similar methods where the agent itself decides which actions to execute. As a consequence of this offset, the agent might make poorer decisions if the human operator does not always follow the proposed actions of the agents.<br/>To measure how sensitive the agent is to such offsets, this KPI proposes to use a “simulated operator” that does not fully follow the course of actions suggested by the agents, and instead overwrites certain action variables set by the agents in a fraction of time', 'Overall, this KPI contributes to evaluating Robustness of the AI-based assistant when dealing with real-world conditions, as part of Task 4.2 evaluation objectives, and O4 main project objective.<br/>The KPI is related to Tasks 3.1 and 3.3. Specifically, it is related to goal (4) of Task 3.1 (“Analysis of the impact of human intervention in the decision process on AI agents developed and trained towards fully autonomous behavior”), goal (1) of Task 3.3 (“Develop and expand order-agnostic network architectures adapted to the RL setting to use human-data or human-like perturbations and ensure the system can also make good decisions in the context where actions are partially chosen by the human partner”) and goal (2) of Task 3.4 (“Detect risks early on and potentially inform human supervisors, e.g. relinquish control to a human supervisor or transition into “safety mode” when necessary”).   ', array['d6eacff5-2331-4003-a5c7-fc1c78016062']::uuid[])
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
    VALUES ('74dd5830-6e59-423f-89f4-b050319db14e', 'Scenario 1 - Drop-off in reward calculates difference in reward between situation with perfect information and imperfect information either through natural malfunctions while measuring data or through intentional perturbations by an attacker. ', 'This KPI contributes to evaluating Robustness of the AI-based assistant, as part of Task 4.2 evaluation objectives, and O4 main project objective. ', array['6eefe84b-567f-4d82-9c90-d6b877f05cd8']::uuid[])
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
    VALUES ('900d5489-2539-4a49-b3fb-3ae2039be92f', 'Scenario 1 - Drop-off in reward calculates difference in reward between situation with perfect information and imperfect information either through natural malfunctions while measuring data or through intentional perturbations by an attacker. ', 'This KPI contributes to evaluating Robustness of the AI-based assistant, as part of Task 4.2 evaluation objectives, and O4 main project objective. ', array['128e21d2-c26e-44d8-b154-ea288187972a']::uuid[])
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
    VALUES ('532a18a1-5e58-45a4-830e-b5ca016499f9', 'Scenario 1 - Drop-off in reward calculates difference in reward between situation with perfect information and imperfect information either through natural malfunctions while measuring data or through intentional perturbations by an attacker. ', 'This KPI contributes to evaluating Robustness of the AI-based assistant, as part of Task 4.2 evaluation objectives, and O4 main project objective. ', array['b29bdff4-e173-469c-9a01-80656400b4b5']::uuid[])
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
    VALUES ('ffcadd8d-207a-49af-8b09-54e922642f01', 'Scenario 1 - Frequency changed output AI agent calculates the number of times the output of the AI agent (i.e. the action the agent chooses) is changed due to perturbations ', 'This KPI contributes to evaluating Robustness of the AI-based assistant, as part of Task 4.2 evaluation objectives, and O4 main project objective.  ', array['c695f336-10fc-41df-8376-33857fff1816']::uuid[])
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
    VALUES ('fdaac433-3ef0-4667-afb8-8014d0c1afa3', 'Scenario 1 - Frequency changed output AI agent calculates the number of times the output of the AI agent (i.e. the action the agent chooses) is changed due to perturbations ', 'This KPI contributes to evaluating Robustness of the AI-based assistant, as part of Task 4.2 evaluation objectives, and O4 main project objective.  ', array['44384196-3ffd-4df4-bd68-0e803f77757d']::uuid[])
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
    VALUES ('12c63b69-e6b1-4316-999b-7112e0b0c1d2', 'Scenario 1 - Frequency changed output AI agent calculates the number of times the output of the AI agent (i.e. the action the agent chooses) is changed due to perturbations ', 'This KPI contributes to evaluating Robustness of the AI-based assistant, as part of Task 4.2 evaluation objectives, and O4 main project objective.  ', array['35b65c55-13d4-4385-bff4-5c5ccfeb1077']::uuid[])
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
    VALUES ('588ae37c-f583-47df-9154-ca12c9ac134a', 'Scenario 1 - Severity of changed output AI agent KPI measures similarity of the action chosen by AI agent based on a perturbed input to the action chosen with perfect information. Average pre-defined similarity score per changed action indicating how different the new action is from the original one. ', 'This KPI contributes to evaluating Robustness of the AI-based assistant, as part of Task 4.2 evaluation objectives, and O4 main project objective. ', array['f28523cf-b708-4431-91c0-3b29056139f9']::uuid[])
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
    VALUES ('70d937d5-742b-4838-a456-4a95ff994788', 'Scenario 1 - Severity of changed output AI agent KPI measures similarity of the action chosen by AI agent based on a perturbed input to the action chosen with perfect information. Average pre-defined similarity score per changed action indicating how different the new action is from the original one. ', 'This KPI contributes to evaluating Robustness of the AI-based assistant, as part of Task 4.2 evaluation objectives, and O4 main project objective. ', array['eb411f0f-eb8a-47e1-9ba1-6a929449d59c']::uuid[])
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
    VALUES ('af261375-7fd2-4a89-92b6-3477b018a09d', 'Scenario 1 - Severity of changed output AI agent KPI measures similarity of the action chosen by AI agent based on a perturbed input to the action chosen with perfect information. Average pre-defined similarity score per changed action indicating how different the new action is from the original one. ', 'This KPI contributes to evaluating Robustness of the AI-based assistant, as part of Task 4.2 evaluation objectives, and O4 main project objective. ', array['4bb80a5b-6ed3-45f9-bab4-6a8ce1607721']::uuid[])
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
    VALUES ('8011c7bd-6082-4653-8d9d-887d23f1ec5c', 'Scenario 1 - Steps survived with perturbations KPI calculates the number of steps the AI agent is able to survive in environment with perturbation agent ', 'This KPI contributes to evaluating Robustness of the AI-based assistant, as part of Task 4.2 evaluation objectives, and O4 main project objective. ', array['10bb95e7-9938-468e-b6c2-ed7c5017fd3b']::uuid[])
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
    VALUES ('9cd1a5e0-8445-4b9d-859b-76b096d33049', 'Scenario 1 - Steps survived with perturbations KPI calculates the number of steps the AI agent is able to survive in environment with perturbation agent ', 'This KPI contributes to evaluating Robustness of the AI-based assistant, as part of Task 4.2 evaluation objectives, and O4 main project objective. ', array['2495463f-0168-438a-8b2c-65efbcfdb288']::uuid[])
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
    VALUES ('f903201d-a631-46c9-997f-f32bf7e3ff5d', 'Scenario 1 - Steps survived with perturbations KPI calculates the number of steps the AI agent is able to survive in environment with perturbation agent ', 'This KPI contributes to evaluating Robustness of the AI-based assistant, as part of Task 4.2 evaluation objectives, and O4 main project objective. ', array['86becfb7-36df-449f-aa44-e27aa8d9c5c8']::uuid[])
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
    VALUES ('47a11418-fad5-4d55-a637-6b90a8351500', 'Scenario 1 - Vulnerability to perturbation KPI measures vulnerability of specific value in observed state to perturbations, i.e. how likely it is that perturbing the value will result in a change in action chosen by the AI agent ', 'This KPI contributes to evaluating Robustness of the AI-based assistant, as part of Task 4.2 evaluation objectives, and O4 main project objective. ', array['ad276973-ba49-4688-91d1-1217b35b33e1']::uuid[])
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
    VALUES ('61063867-df62-4024-be42-c57507a15d7c', 'Scenario 1 - Vulnerability to perturbation KPI measures vulnerability of specific value in observed state to perturbations, i.e. how likely it is that perturbing the value will result in a change in action chosen by the AI agent ', 'This KPI contributes to evaluating Robustness of the AI-based assistant, as part of Task 4.2 evaluation objectives, and O4 main project objective. ', array['e4f93627-fb2a-4dc9-943b-77c8f224222c']::uuid[])
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
    VALUES ('3ced691e-d23c-47de-9967-5cf5d7be3e9e', 'Scenario 1 - Vulnerability to perturbation KPI measures vulnerability of specific value in observed state to perturbations, i.e. how likely it is that perturbing the value will result in a change in action chosen by the AI agent ', 'This KPI contributes to evaluating Robustness of the AI-based assistant, as part of Task 4.2 evaluation objectives, and O4 main project objective. ', array['48571925-e8a2-4329-8b58-1a9e6d9b0d1f']::uuid[])
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
    VALUES ('dc8195e4-266d-4afb-ba60-2659f59acfa4', 'Scenario 1 - Reward per action KPI calculates average reward obtained for each action performed by the AI agent ', 'This KPI contributes to evaluating Robustness of the AI-based assistant, as part of Task 4.2 evaluation objectives, and O4 main project objective. ', array['b82960af-30e3-4402-aea4-f129b8518ad9']::uuid[])
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
    VALUES ('a999eb93-2efe-4f73-a2d8-eab51f158ae8', 'Scenario 1 - Reward per action KPI calculates average reward obtained for each action performed by the AI agent ', 'This KPI contributes to evaluating Robustness of the AI-based assistant, as part of Task 4.2 evaluation objectives, and O4 main project objective. ', array['a904e4a5-a0bc-4dbc-af03-7f7d8af21a28']::uuid[])
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
    VALUES ('eeb9b483-616d-4508-85b8-812a09f93d23', 'Scenario 1 - Reward per action KPI calculates average reward obtained for each action performed by the AI agent ', 'This KPI contributes to evaluating Robustness of the AI-based assistant, as part of Task 4.2 evaluation objectives, and O4 main project objective. ', array['4cd393ef-cca3-4624-812e-02d69c32a22c']::uuid[])
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
    VALUES ('e36d1ef8-939c-4cd8-a660-0a224ce24aa0', 'Scenario 1 - The Explainability Robustness KPI evaluates the stability of explanations against small input perturbations, assuming the model’s output remains relatively unchanged. A robust explanation should not fluctuate significantly when the input is slightly modified. The Average Sensitivity Metric quantifies this stability by applying small perturbations to the input data and measuring how much the explanation changes. Since computing sensitivity over all possible perturbations is impractical, Monte Carlo sampling is used to estimate these variations efficiently. ', 'This KPI ensures that AI-driven explanations remain reliable and aligned with the actual decision-making process of the model. It helps evaluate interpretability methods in AI systems used in critical applications.<br/>This KPI contributes to evaluating AI trustworthiness, acceptability and trust of the AI-based assistant, as part of Task 4.3 evaluation objectives, and O4 main project objective.', array['17c72ca8-d2e0-4ff4-9c6c-c5d3b2391d63']::uuid[])
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
    VALUES ('53b0db0e-7092-455b-9e2c-327ee017f776', 'Scenario 1 - The Faithfulness KPI assesses whether the feature importance scores provided by an explanation method accurately reflect the model’s decision-making process. It systematically removes or alters features and measures the impact on the model’s predictions. The assumption is that if a feature is truly important, removing or altering it should significantly affect the model’s output. ', 'This KPI ensures that AI-driven explanations remain reliable and aligned with the actual decision-making process of the model. It helps evaluate interpretability methods in AI systems used in critical applications.<br/><br/>This KPI contributes to evaluating AI trustworthiness, acceptability and trust of the AI-based assistant, as part of Task 4.3 evaluation objectives, and O4 main project objective. ', array['9fc1e90a-54bb-4d43-8cf2-89f5b8751315']::uuid[])
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
    VALUES ('a9e3fbf7-b5d5-477d-a0c8-d23880237d2d', 'Scenario 1 - Area between reward curves calculates area between the curve corresponding to the reward obtained in each step in an environment where the AI agent has perfect information and the curve for an environment where the agent''s input is perturbed ', 'This KPI contributes to evaluating Resilience of the AI-based assistant, as part of Task 4.2 evaluation objectives, and O4 main project objective. ', array['0c62855e-4a6f-487f-a374-da6616523e78']::uuid[])
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
    VALUES ('bbcf8224-c768-4469-8ff5-939d977383b4', 'Scenario 1 - Area between reward curves calculates area between the curve corresponding to the reward obtained in each step in an environment where the AI agent has perfect information and the curve for an environment where the agent''s input is perturbed ', 'This KPI contributes to evaluating Resilience of the AI-based assistant, as part of Task 4.2 evaluation objectives, and O4 main project objective. ', array['7d47d27f-5210-4b32-af74-c675f01b7f34']::uuid[])
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
    VALUES ('e80a5e55-dc60-459f-bf22-26f196a4711a', 'Scenario 1 - Area between reward curves calculates area between the curve corresponding to the reward obtained in each step in an environment where the AI agent has perfect information and the curve for an environment where the agent''s input is perturbed ', 'This KPI contributes to evaluating Resilience of the AI-based assistant, as part of Task 4.2 evaluation objectives, and O4 main project objective. ', array['9aa013b5-5b38-40ee-ae5a-5a995ed848b5']::uuid[])
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
    VALUES ('dc03b9f1-bfb2-44b8-b124-f7eede10e0a7', 'Scenario 1 - Number of steps/episodes until reward reaches its lowest point after introducing perturbations to the input of the AI agent ', 'This KPI contributes to evaluating Resilience of the AI-based assistant, as part of Task 4.2 evaluation objectives, and O4 main project objective. ', array['6c5d2104-95b2-4dfb-af77-3eccd7416d33']::uuid[])
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
    VALUES ('b355482b-30a2-431e-9536-8e3dd29d06d1', 'Scenario 1 - Number of steps/episodes until reward reaches its lowest point after introducing perturbations to the input of the AI agent ', 'This KPI contributes to evaluating Resilience of the AI-based assistant, as part of Task 4.2 evaluation objectives, and O4 main project objective. ', array['e52742ce-a6f6-46c9-9806-83bd9d036cce']::uuid[])
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
    VALUES ('2aaed2a4-7dd9-4ea6-a2df-e3ef2207680a', 'Scenario 1 - Number of steps/episodes until reward reaches its lowest point after introducing perturbations to the input of the AI agent ', 'This KPI contributes to evaluating Resilience of the AI-based assistant, as part of Task 4.2 evaluation objectives, and O4 main project objective. ', array['23b4c9ee-0dec-4e36-b755-15aa29cf5b91']::uuid[])
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
    VALUES ('56160b90-a287-4dec-acc7-f40967d60fa0', 'Scenario 1 - Number of steps/episodes until reward recovers to its highest point after reaching the lowest point after introducing perturbations to the input of the AI agent ', 'This KPI contributes to evaluating Resilience of the AI-based assistant, as part of Task 4.2 evaluation objectives, and O4 main project objective. ', array['fb1b87be-26a3-48f2-bb69-d98e341ed128']::uuid[])
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
    VALUES ('2eaf04e3-090a-4c13-b923-ac86de1b6db1', 'Scenario 1 - Number of steps/episodes until reward recovers to its highest point after reaching the lowest point after introducing perturbations to the input of the AI agent ', 'This KPI contributes to evaluating Resilience of the AI-based assistant, as part of Task 4.2 evaluation objectives, and O4 main project objective. ', array['0c79911b-29de-4f7f-bca6-820ef7f28f34']::uuid[])
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
    VALUES ('00e749d7-baa3-4b24-8092-d3dd69cdea58', 'Scenario 1 - Number of steps/episodes until reward recovers to its highest point after reaching the lowest point after introducing perturbations to the input of the AI agent ', 'This KPI contributes to evaluating Resilience of the AI-based assistant, as part of Task 4.2 evaluation objectives, and O4 main project objective. ', array['b75f5075-8c72-49b2-bbb7-523cf3757b17']::uuid[])
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
    VALUES ('367a8b12-1b87-42f1-9400-4ecf96d6b617', 'Scenario 1 - Similarity state to unperturbed situation KPI measures similarity of the state in an environment where AI agent''s input is perturbed to the state in the same context of an environment with perfect information ', 'This KPI contributes to evaluating Resilience of the AI-based assistant, as part of Task 4.2 evaluation objectives, and O4 main project objective. ', array['7929ff8d-5b64-48e1-ab5c-ebb398917ce3']::uuid[])
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
    VALUES ('4523d73e-427a-42a1-b841-c9668373fafb', 'Scenario 1 - Similarity state to unperturbed situation KPI measures similarity of the state in an environment where AI agent''s input is perturbed to the state in the same context of an environment with perfect information ', 'This KPI contributes to evaluating Resilience of the AI-based assistant, as part of Task 4.2 evaluation objectives, and O4 main project objective. ', array['5e04f982-70cf-402b-aeac-ee1184c336ba']::uuid[])
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
    VALUES ('afc812fc-e4f3-4380-a856-9987bc557d5c', 'Scenario 1 - Similarity state to unperturbed situation KPI measures similarity of the state in an environment where AI agent''s input is perturbed to the state in the same context of an environment with perfect information ', 'This KPI contributes to evaluating Resilience of the AI-based assistant, as part of Task 4.2 evaluation objectives, and O4 main project objective. ', array['0bc0cca0-d4db-4d28-b5f9-74609d12fef8']::uuid[])
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
    VALUES ('e9e537cc-a8d0-4864-9460-9098c72b269f', 'Scenario 1 - This KPI represents self-reported human operators’ perception of the changes in their trust for the AI assistant over time (increased/decreased) on a Likert scale. ', 'This KPI contributes to evaluating Long-term consequences of AI assistants of the AI-based assistant, as part of Task 4.3 evaluation objectives, and O3 main project objective.<br/>It is also relevant to protocols and concepts defined in D1.1 such as “Transparency”, “Human Agency and Oversight”, “Credibility and Intimacy”. Furthermore, it is also relevant to the overall project KPI-ET-7 "% of acceptance of human operators regarding AI4REALNET solutions". ', array['90fb4912-29b4-468c-80f9-66221b97b575']::uuid[])
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
    VALUES ('b26f54c0-146a-473c-82a6-fcecbedc9cbc', 'Scenario 1 - This KPI represents self-reported human operators’ perception of the changes in their trust for the AI assistant over time (increased/decreased) on a Likert scale. ', 'This KPI contributes to evaluating Long-term consequences of AI assistants of the AI-based assistant, as part of Task 4.3 evaluation objectives, and O3 main project objective.<br/>It is also relevant to protocols and concepts defined in D1.1 such as “Transparency”, “Human Agency and Oversight”, “Credibility and Intimacy”. Furthermore, it is also relevant to the overall project KPI-ET-7 "% of acceptance of human operators regarding AI4REALNET solutions". ', array['ca679741-cbb3-4d96-b688-dd817693a94c']::uuid[])
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
    VALUES ('12e1531b-8525-408d-b800-1d0df54f84bb', 'Scenario 1 - This KPI represents self-reported human operators’ perception of the changes in their trust for the AI assistant over time (increased/decreased) on a Likert scale. ', 'This KPI contributes to evaluating Long-term consequences of AI assistants of the AI-based assistant, as part of Task 4.3 evaluation objectives, and O3 main project objective.<br/>It is also relevant to protocols and concepts defined in D1.1 such as “Transparency”, “Human Agency and Oversight”, “Credibility and Intimacy”. Furthermore, it is also relevant to the overall project KPI-ET-7 "% of acceptance of human operators regarding AI4REALNET solutions". ', array['89f5fc6a-2365-43d0-949d-63474e6bfc04']::uuid[])
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
    VALUES ('1ce89667-c4c2-483d-8ed1-c7add0a24b4b', 'Scenario 1 - This KPI represents self-reported human operators’ perception of the changes in their agency working with the AI assistant over time (increased/decreased) on a Likert scale. ', 'This KPI contributes to evaluating Long-term consequences of AI assistants of the AI-based assistant, as part of Task 4.3 evaluation objectives, and O3 main project objective.<br/>It is also relevant to protocols and concepts defined in D1.1 such as “Transparency”, “Decision support for the human operator”, “Human Agency and Oversight”.  ', array['9f07e590-75bd-4fe2-a0b7-fb4826d1280a']::uuid[])
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
    VALUES ('284e2178-d34c-4dcb-8868-21b4d2310744', 'Scenario 1 - This KPI represents self-reported human operators’ perception of the changes in their agency working with the AI assistant over time (increased/decreased) on a Likert scale. ', 'This KPI contributes to evaluating Long-term consequences of AI assistants of the AI-based assistant, as part of Task 4.3 evaluation objectives, and O3 main project objective.<br/>It is also relevant to protocols and concepts defined in D1.1 such as “Transparency”, “Decision support for the human operator”, “Human Agency and Oversight”.  ', array['f06cdfb0-7ba6-4463-8633-d38cc856c75a']::uuid[])
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
    VALUES ('5afb6acf-df83-47e9-9e7e-cdfb85a3c5de', 'Scenario 1 - This KPI represents self-reported human operators’ perception of the changes in their agency working with the AI assistant over time (increased/decreased) on a Likert scale. ', 'This KPI contributes to evaluating Long-term consequences of AI assistants of the AI-based assistant, as part of Task 4.3 evaluation objectives, and O3 main project objective.<br/>It is also relevant to protocols and concepts defined in D1.1 such as “Transparency”, “Decision support for the human operator”, “Human Agency and Oversight”.  ', array['ab2a6648-8405-4490-b868-5231ec741cc8']::uuid[])
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
    VALUES ('e283be95-96da-4f69-8869-06ab82ee2c45', 'Scenario 1 - This KPI represents self-reported human operators’ perception of the changes in their own skills working with the AI assistant over time (increased/decreased) on a Likert scale. ', 'This KPI contributes to evaluating Long-term consequences of AI assistants of the AI-based assistant, as part of Task 4.3 evaluation objectives, and O3 main project objective.<br/>It is also relevant to protocols and concepts defined in D1.1 such as “Mitigate de-skilling in the human operators”. ', array['a7c602c7-736c-4dd0-b4e4-f2199d1d6014']::uuid[])
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
    VALUES ('f253c68c-bd5e-43a2-8d72-77ab9caccb0d', 'Scenario 1 - This KPI represents self-reported human operators’ perception of the changes in their own skills working with the AI assistant over time (increased/decreased) on a Likert scale. ', 'This KPI contributes to evaluating Long-term consequences of AI assistants of the AI-based assistant, as part of Task 4.3 evaluation objectives, and O3 main project objective.<br/>It is also relevant to protocols and concepts defined in D1.1 such as “Mitigate de-skilling in the human operators”. ', array['1897db1b-869a-4100-8596-a983a5525cbf']::uuid[])
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
    VALUES ('e62d0769-c481-4641-b9d4-ad5586008e38', 'Scenario 1 - This KPI represents self-reported human operators’ perception of the changes in their own skills working with the AI assistant over time (increased/decreased) on a Likert scale. ', 'This KPI contributes to evaluating Long-term consequences of AI assistants of the AI-based assistant, as part of Task 4.3 evaluation objectives, and O3 main project objective.<br/>It is also relevant to protocols and concepts defined in D1.1 such as “Mitigate de-skilling in the human operators”. ', array['7cef4f40-a0a6-48e1-a4b9-a20f8bae0409']::uuid[])
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
    VALUES ('fbe33158-fb85-492d-9015-62b95f4658e8', 'Scenario 1 - This KPI represents self-reported human operators’ perception of their potential over-reliance on the AI assistant on a Likert scale. ', 'This KPI contributes to evaluating Long-term consequences of AI assistants of the AI-based assistant, as part of Task 4.3 evaluation objectives, and O3 main project objective.<br/>It is also relevant to protocols and concepts defined in D1.1 such as “Mitigate addictive behavior from humans”. ', array['06cb3d29-b11f-41cb-aa32-a0bab80f9e41']::uuid[])
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
    VALUES ('44daf1f7-1449-408e-baa6-9d5c29dc50f0', 'Scenario 1 - This KPI represents self-reported human operators’ perception of their potential over-reliance on the AI assistant on a Likert scale. ', 'This KPI contributes to evaluating Long-term consequences of AI assistants of the AI-based assistant, as part of Task 4.3 evaluation objectives, and O3 main project objective.<br/>It is also relevant to protocols and concepts defined in D1.1 such as “Mitigate addictive behavior from humans”. ', array['00ddf7a5-e115-485b-b60a-e20fe7e4a47b']::uuid[])
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
    VALUES ('a65a72e0-5ac4-4182-a919-da70d1241a59', 'Scenario 1 - This KPI represents self-reported human operators’ perception of their potential over-reliance on the AI assistant on a Likert scale. ', 'This KPI contributes to evaluating Long-term consequences of AI assistants of the AI-based assistant, as part of Task 4.3 evaluation objectives, and O3 main project objective.<br/>It is also relevant to protocols and concepts defined in D1.1 such as “Mitigate addictive behavior from humans”. ', array['48c96014-f53b-4245-a23b-e69235885b75']::uuid[])
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
    VALUES ('4a6d19a8-0d27-42d8-97af-9197987e64ce', 'Scenario 1 - This KPI represents self-reported human operators’ perception of the additional training necessary to adopt the AI assistant on a Likert scale. ', 'This KPI contributes to evaluating Long-term consequences of AI assistants of the AI-based assistant, as part of Task 4.3 evaluation objectives, and O3 main project objective.<br/>It is also relevant to protocols and concepts defined in D1.1 such as “Additional training about AI for human operators” and “Societal and Environmental Well-being”. ', array['125e2e59-23cc-4a2b-a964-bdb5ef835ef5']::uuid[])
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
    VALUES ('9cfb4458-2418-4a83-a7f3-0c27758c4752', 'Scenario 1 - This KPI represents self-reported human operators’ perception of the additional training necessary to adopt the AI assistant on a Likert scale. ', 'This KPI contributes to evaluating Long-term consequences of AI assistants of the AI-based assistant, as part of Task 4.3 evaluation objectives, and O3 main project objective.<br/>It is also relevant to protocols and concepts defined in D1.1 such as “Additional training about AI for human operators” and “Societal and Environmental Well-being”. ', array['64ec96be-c917-4d84-bea6-f1b3a1dbf810']::uuid[])
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
    VALUES ('e82bc94e-ed5e-403a-8dce-a4ed9c7cb63d', 'Scenario 1 - This KPI represents self-reported human operators’ perception of the additional training necessary to adopt the AI assistant on a Likert scale. ', 'This KPI contributes to evaluating Long-term consequences of AI assistants of the AI-based assistant, as part of Task 4.3 evaluation objectives, and O3 main project objective.<br/>It is also relevant to protocols and concepts defined in D1.1 such as “Additional training about AI for human operators” and “Societal and Environmental Well-being”. ', array['ec681c67-7748-4699-a7f9-346b81aa2c14']::uuid[])
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
    VALUES ('b646c5dd-20e5-4628-984c-0b6ab3156538', 'Scenario 1 - This KPI represents self-reported human operators’ perception of biased decisions potentially produced by the AI assistant with respect to gender/ethnicity/age or commercial interests on a Likert scale. ', 'This KPI contributes to evaluating Long-term consequences of AI assistants of the AI-based assistant, as part of Task 4.3 evaluation objectives, and O3 main project objective.<br/>It is also relevant to protocols and concepts defined in D1.1 such as “Diversity, Non-discrimination, and Fairness”. ', array['5a6f8659-28db-43ec-b112-d9f5aa9fd3a3']::uuid[])
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
    VALUES ('7dfff29e-c251-459e-b591-295d796b328a', 'Scenario 1 - This KPI represents self-reported human operators’ perception of biased decisions potentially produced by the AI assistant with respect to gender/ethnicity/age or commercial interests on a Likert scale. ', 'This KPI contributes to evaluating Long-term consequences of AI assistants of the AI-based assistant, as part of Task 4.3 evaluation objectives, and O3 main project objective.<br/>It is also relevant to protocols and concepts defined in D1.1 such as “Diversity, Non-discrimination, and Fairness”. ', array['b60958e0-1320-4afd-b080-4454ebe059c0']::uuid[])
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
    VALUES ('3c3dd29c-67f1-49fa-8aef-384c957acaa4', 'Scenario 1 - This KPI represents self-reported human operators’ perception of biased decisions potentially produced by the AI assistant with respect to gender/ethnicity/age or commercial interests on a Likert scale. ', 'This KPI contributes to evaluating Long-term consequences of AI assistants of the AI-based assistant, as part of Task 4.3 evaluation objectives, and O3 main project objective.<br/>It is also relevant to protocols and concepts defined in D1.1 such as “Diversity, Non-discrimination, and Fairness”. ', array['bb338017-71b2-4f70-80e2-4b425894cbc2']::uuid[])
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
    VALUES ('691ab2fd-9827-45f9-8d03-0878c1005144', 'Scenario 1 - This KPI represents predicted adoption of the AI assistant by users, stakeholders, or experts on a Likert scale. ', 'This KPI contributes to evaluating Long-term consequences of AI assistants of the AI-based assistant, as part of Task 4.3 evaluation objectives, and O3 main project objective.<br/>It is also relevant to protocols and concepts defined in D1.1 such as “Human Agency and Oversight”, “Societal and Environmental Well-being”. ', array['6134d787-1015-46f3-bb71-572fb747f71a']::uuid[])
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
    VALUES ('d885d30d-408c-4b88-9a25-add134aca45b', 'Scenario 1 - This KPI represents predicted adoption of the AI assistant by users, stakeholders, or experts on a Likert scale. ', 'This KPI contributes to evaluating Long-term consequences of AI assistants of the AI-based assistant, as part of Task 4.3 evaluation objectives, and O3 main project objective.<br/>It is also relevant to protocols and concepts defined in D1.1 such as “Human Agency and Oversight”, “Societal and Environmental Well-being”. ', array['15727caa-9a67-4397-9e08-14c6b1f4e236']::uuid[])
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
    VALUES ('664cd46e-7eac-480f-92da-79574b470da4', 'Scenario 1 - This KPI represents predicted adoption of the AI assistant by users, stakeholders, or experts on a Likert scale. ', 'This KPI contributes to evaluating Long-term consequences of AI assistants of the AI-based assistant, as part of Task 4.3 evaluation objectives, and O3 main project objective.<br/>It is also relevant to protocols and concepts defined in D1.1 such as “Human Agency and Oversight”, “Societal and Environmental Well-being”. ', array['524d2cef-fca0-42d8-ab3f-5abd20ab2c3e']::uuid[])
    ON CONFLICT(id) DO UPDATE SET name=EXCLUDED.name, description=EXCLUDED.description, field_ids=EXCLUDED.field_ids;

INSERT INTO field_definitions
        (id, key, description, agg_func, agg_weights)
        VALUES ('524d2cef-fca0-42d8-ab3f-5abd20ab2c3e', 'primary', 'Scenario score (raw values)', NULL, NULL)
        ON CONFLICT(id) DO UPDATE SET key=EXCLUDED.key, description=EXCLUDED.description, agg_func=EXCLUDED.agg_func, agg_weights=EXCLUDED.agg_weights;

