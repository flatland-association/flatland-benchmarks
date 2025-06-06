INSERT INTO field_definitions
(id, key, description, agg_func)
VALUES
('b84d4c81-c0f6-4b74-a5a2-ba3fa0b68f8e', 'primary', 'Primary score (from evaluator)', NULL),
('046ff05d-8386-4d17-82b9-96f405a358f0', 'secondary', 'Secondary score (from evaluator)', NULL),
('68c1f46f-f69d-45fa-9693-23b60d5e7752', 'primary', 'Primary test score (aggregated)', 'NANSUM'),
('be4a7bb4-347b-43b8-a1a9-6bb20029078c', 'secondary', 'Secondary test score (aggregated)', 'NANSUM'),
('be7bf55a-9d79-4e89-8509-f8d2af9b3fad', 'primary', 'Primary submission score (aggregated)', 'NANSUM'),
('f6b23ac8-2f12-4e77-8de4-4939b818ca8e', 'secondary', 'Secondary submission score (aggregated)', 'NANSUM');

INSERT INTO scenario_definitions
(id, name, description, field_definition_ids)
VALUES
('1ae61e4f-201b-4e97-a399-5c33fb75c57e', 'Scenario 1', '10x10 grid, 10 agents', array['b84d4c81-c0f6-4b74-a5a2-ba3fa0b68f8e', '046ff05d-8386-4d17-82b9-96f405a358f0']::uuid[]),
('564ebb54-48f0-4837-8066-b10bb832af9d', 'Scenario 2', '10x10 grid, 20 agents', array['b84d4c81-c0f6-4b74-a5a2-ba3fa0b68f8e', '046ff05d-8386-4d17-82b9-96f405a358f0']::uuid[]);

INSERT INTO test_definitions
(id, name, description, field_definition_ids, scenario_definition_ids)
VALUES
('557d9a00-7e6d-410b-9bca-a017ca7fe3aa', 'Test 1', 'Domain X benchmark', array['68c1f46f-f69d-45fa-9693-23b60d5e7752', 'be4a7bb4-347b-43b8-a1a9-6bb20029078c']::uuid[], array['1ae61e4f-201b-4e97-a399-5c33fb75c57e', '564ebb54-48f0-4837-8066-b10bb832af9d']::uuid[]);

INSERT INTO benchmark_definitions
(id, name, description, field_definition_ids, test_definition_ids, docker_image, evaluator_data)
VALUES
('20ccc7c1-034c-4880-8946-bffc3fed1359', 'Benchmark 1', 'Domain X benchmark', array['be7bf55a-9d79-4e89-8509-f8d2af9b3fad', 'f6b23ac8-2f12-4e77-8de4-4939b818ca8e']::uuid[], array['557d9a00-7e6d-410b-9bca-a017ca7fe3aa']::uuid[], 'none', '{}');
