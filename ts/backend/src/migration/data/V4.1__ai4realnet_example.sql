INSERT INTO field_definitions
  (id, key, description, agg_func, agg_weights)
VALUES
  ('9d6da5c3-1cfc-4f87-8b57-607a0ce02b2b', 'primary', 'Primary scenario score (from evaluator)', NULL, NULL),
  ('a2202f68-29fb-41ca-8761-81a75942e2ec', 'primary', 'Primary KPI score (NANSUM of scenario scores)', 'NANSUM', NULL),
  ('90c8ac1d-10e4-400c-9893-6caaa2a1f2a9', 'primary', 'Primary objective score', 'NANSUM', NULL),
  ('316b5e38-44ac-48b7-b894-c25f13dddfb2', 'primary', 'Effectiveness', 'NANSUM', array[0.11, 0.11, 0.11, 0.11, 0.17, 0.11, 0.17, 0.11]),
  ('a294a990-a400-45dc-ade2-6b88a5da0808', 'primary', 'Resilience', 'NANSUM', array[0.25, 0.25, 0.25, 0.25]);

INSERT INTO scenario_definitions
  (id, name, description, field_definition_ids)
VALUES
  ('8fba6834-cd86-4bca-b3b5-f14d6c54d92f', 'KPI-AF-008-1', 'Assistant alert accuracy, scenario 1', array['9d6da5c3-1cfc-4f87-8b57-607a0ce02b2b']::uuid[]),
  ('94547c7d-80ec-47ac-9146-80da362b79fa', 'KPI-DF-016-1', 'Delay reduction efficiency, scenario 1', array['9d6da5c3-1cfc-4f87-8b57-607a0ce02b2b']::uuid[]),
  ('edf822cf-c11d-471e-86df-723ad1f56e00', 'KPI-NF-024-1', 'Network utilization, scenario 1', array['9d6da5c3-1cfc-4f87-8b57-607a0ce02b2b']::uuid[]),
  ('69fdd7b7-5f66-40b6-8dc5-92a8a7b0ba68', 'KPI-PF-026-1', 'Punctuality, scenario 1', array['9d6da5c3-1cfc-4f87-8b57-607a0ce02b2b']::uuid[]),
  ('dd1aed5d-f411-491e-ae3f-88b1cce596f6', 'KPI-RF-027-1', 'Reduction in delay, scenario 1', array['9d6da5c3-1cfc-4f87-8b57-607a0ce02b2b']::uuid[]),
  ('cdcbfdac-1886-4d97-9994-972a25c49903', 'KPI-AF-029-1', 'AI Response time, scenario 1', array['9d6da5c3-1cfc-4f87-8b57-607a0ce02b2b']::uuid[]),
  ('7f4ebf12-ea7d-4722-ae4b-bee551a16b51', 'KPI-SS-032-1', 'System efficiency, scenario 1', array['9d6da5c3-1cfc-4f87-8b57-607a0ce02b2b']::uuid[]),
  ('5bd5fdac-5311-41fe-bcfd-705daed0bf9e', 'KPI-TS-035-1', 'Total decision time, scenario 1', array['9d6da5c3-1cfc-4f87-8b57-607a0ce02b2b']::uuid[]),
  ('aa9e0da1-0c72-429b-a9fb-02c04206a421', 'KPI-CF-012-1', 'Carbon intensity, scenario 1', array['9d6da5c3-1cfc-4f87-8b57-607a0ce02b2b']::uuid[]),
  ('844bd6ea-e547-4469-b209-db9e26e65d98', 'KPI-TF-034-1', 'Topological action complexity, scenario 1', array['9d6da5c3-1cfc-4f87-8b57-607a0ce02b2b']::uuid[]),
  ('e0f49e9f-359e-48c9-a64f-3bf190bb3c1d', 'KPI-OF-036-1', 'Operation score, scenario 1', array['9d6da5c3-1cfc-4f87-8b57-607a0ce02b2b']::uuid[]),
  ('4aa92f3f-e469-410c-b95d-bfa05395c5c7', 'KPI-NF-045-1', 'Network Impact Propagation, scenario 1', array['9d6da5c3-1cfc-4f87-8b57-607a0ce02b2b']::uuid[]),
  ('f28195c2-4115-4114-a2c1-29c3fed83f9c', 'KPI-AS-068-1', 'Assistant adaptation to user preferences, scenario 1', array['9d6da5c3-1cfc-4f87-8b57-607a0ce02b2b']::uuid[]),
  ('8e28b762-fcaf-403d-b573-38947f09fe76', 'KPI-AF-050-1', 'AI-Agent Scalability Training, scenario 1', array['9d6da5c3-1cfc-4f87-8b57-607a0ce02b2b']::uuid[]),
  ('38480e7e-9b31-47be-b43f-d033f31e7316', 'KPI-AF-051-1', 'AI-Agent Scalability Testing, scenario 1', array['9d6da5c3-1cfc-4f87-8b57-607a0ce02b2b']::uuid[]),
  ('b074d47e-a769-4ecc-b61a-c7efdd39d12a', 'KPI-AS-006-1', 'AI co-learning capability, scenario 1', array['9d6da5c3-1cfc-4f87-8b57-607a0ce02b2b']::uuid[]),
  ('5b6d1893-31e4-4ae3-9d97-211436851db8', 'KPI-HS-021-1', 'Human learning, scenario 1', array['9d6da5c3-1cfc-4f87-8b57-607a0ce02b2b']::uuid[]),
  -- KPIs for objectives 'AI-human task allocation balance' to and including 'Robustness' left out for brevity
  ('a40de74a-1ecd-4ee7-be64-9ccbeb5b03de', 'KPI-AF-074-1', 'Area between reward curves, scenario 1', array['9d6da5c3-1cfc-4f87-8b57-607a0ce02b2b']::uuid[]),
  ('d9158b08-da9d-44b7-ac0c-881e41bd29e1', 'KPI-DF-075-1', 'Degradation time, scenario 1', array['9d6da5c3-1cfc-4f87-8b57-607a0ce02b2b']::uuid[]),
  ('ae41ace9-1781-4ee7-9eee-407472d1d9b3', 'KPI-RF-076-1', 'Restorative time, scenario 1', array['9d6da5c3-1cfc-4f87-8b57-607a0ce02b2b']::uuid[]),
  ('db6a239b-ead8-48f7-8a65-02a676c72cd6', 'KPI-SF-077-1', 'Similarity state to unperturbed situation, scenario 1', array['9d6da5c3-1cfc-4f87-8b57-607a0ce02b2b']::uuid[]);

INSERT INTO test_definitions
  (id, name, description, field_definition_ids, scenario_definition_ids, loop)
VALUES
  ('aeabd5b9-4e86-4c7a-859f-a32ff1be5516', 'KPI-AF-008', 'Assistant alert accuracy', array['a2202f68-29fb-41ca-8761-81a75942e2ec']::uuid[], array['8fba6834-cd86-4bca-b3b5-f14d6c54d92f']::uuid[], 'CLOSED'),
  ('42fbb160-a300-43f7-9268-e290f6daad9c', 'KPI-DF-016', 'Delay reduction efficiency', array['a2202f68-29fb-41ca-8761-81a75942e2ec']::uuid[], array['94547c7d-80ec-47ac-9146-80da362b79fa']::uuid[], 'CLOSED'),
  ('a40240d3-580e-4bad-a90d-608743600422', 'KPI-NF-024', 'Network utilization', array['a2202f68-29fb-41ca-8761-81a75942e2ec']::uuid[], array['edf822cf-c11d-471e-86df-723ad1f56e00']::uuid[], 'CLOSED'),
  ('cba954e0-a48b-473a-bf9d-d12a1b5e946f', 'KPI-PF-026', 'Punctuality', array['a2202f68-29fb-41ca-8761-81a75942e2ec']::uuid[], array['69fdd7b7-5f66-40b6-8dc5-92a8a7b0ba68']::uuid[], 'CLOSED'),
  ('7f5bf3a1-ac9e-443f-8607-eaa51d80c85e', 'KPI-RF-027', 'Reduction in delay', array['a2202f68-29fb-41ca-8761-81a75942e2ec']::uuid[], array['dd1aed5d-f411-491e-ae3f-88b1cce596f6']::uuid[], 'CLOSED'),
  ('4f0ea3a1-71df-4528-ac0e-b3df1488e970', 'KPI-AF-029', 'AI Response time', array['a2202f68-29fb-41ca-8761-81a75942e2ec']::uuid[], array['cdcbfdac-1886-4d97-9994-972a25c49903']::uuid[], 'CLOSED'),
  ('687a01f3-4dc5-4926-a862-7f307c3df597', 'KPI-SS-032', 'System efficiency', array['a2202f68-29fb-41ca-8761-81a75942e2ec']::uuid[], array['7f4ebf12-ea7d-4722-ae4b-bee551a16b51']::uuid[], 'INTERACTIVE'),
  ('836bfb70-1366-4e27-aca5-2bd0aeaeb366', 'KPI-TS-035', 'Total decision time', array['a2202f68-29fb-41ca-8761-81a75942e2ec']::uuid[], array['5bd5fdac-5311-41fe-bcfd-705daed0bf9e']::uuid[], 'INTERACTIVE'),
  ('7c0b7586-a36f-4787-bfe3-b9739938b622', 'KPI-CF-012', 'Carbon intensity', array['a2202f68-29fb-41ca-8761-81a75942e2ec']::uuid[], array['aa9e0da1-0c72-429b-a9fb-02c04206a421']::uuid[], 'CLOSED'),
  ('86410bb1-a118-491a-8905-03d6e1917818', 'KPI-TF-034', 'Topological action complexity', array['a2202f68-29fb-41ca-8761-81a75942e2ec']::uuid[], array['844bd6ea-e547-4469-b209-db9e26e65d98']::uuid[], 'CLOSED'),
  ('06d84884-1289-414f-a4b6-444e983f8f81', 'KPI-OF-036', 'Operation score', array['a2202f68-29fb-41ca-8761-81a75942e2ec']::uuid[], array['e0f49e9f-359e-48c9-a64f-3bf190bb3c1d']::uuid[], 'CLOSED'),
  ('0f9a514e-78e7-405d-bcee-c3b9b3463c68', 'KPI-NF-045', 'Network Impact Propagation', array['a2202f68-29fb-41ca-8761-81a75942e2ec']::uuid[], array['4aa92f3f-e469-410c-b95d-bfa05395c5c7']::uuid[], 'CLOSED'),
  ('8112102c-69b3-45cc-9b8e-67d5d8b65c4c', 'KPI-AS-068', 'Assistant adaptation to user preferences', array['a2202f68-29fb-41ca-8761-81a75942e2ec']::uuid[], array['f28195c2-4115-4114-a2c1-29c3fed83f9c']::uuid[], 'INTERACTIVE'),
  ('e5fa0a00-d169-4084-83c1-a6088765453c', 'KPI-AF-050', 'AI-Agent Scalability Training', array['a2202f68-29fb-41ca-8761-81a75942e2ec']::uuid[], array['8e28b762-fcaf-403d-b573-38947f09fe76']::uuid[], 'CLOSED'),
  ('e5dafe01-e9a1-4d7e-a7c0-085b80315dcc', 'KPI-AF-051', 'AI-Agent Scalability Testing', array['a2202f68-29fb-41ca-8761-81a75942e2ec']::uuid[], array['38480e7e-9b31-47be-b43f-d033f31e7316']::uuid[], 'CLOSED'),
  ('99f5a8f8-38d9-4a8c-9630-4789b0225ec0', 'KPI-AS-006', 'AI co-learning capability', array['a2202f68-29fb-41ca-8761-81a75942e2ec']::uuid[], array['b074d47e-a769-4ecc-b61a-c7efdd39d12a']::uuid[], 'OFFLINE'),
  ('f23794a2-dcf2-4699-bb5f-534bcea5ecf0', 'KPI-HS-021', 'Human learning', array['a2202f68-29fb-41ca-8761-81a75942e2ec']::uuid[], array['5b6d1893-31e4-4ae3-9d97-211436851db8']::uuid[], 'OFFLINE'),
  -- KPIs for objectives 'AI-human task allocation balance' to and including 'Robustness' left out for brevity
  ('6f25b647-0a2a-4e28-99b9-e1feacbdf4ad', 'KPI-AF-074', 'Area between reward curves', array['a2202f68-29fb-41ca-8761-81a75942e2ec']::uuid[], array['a40de74a-1ecd-4ee7-be64-9ccbeb5b03de']::uuid[], 'CLOSED'),
  ('c4f3c534-e74c-491c-8044-b5529f6a42e0', 'KPI-DF-075', 'Degradation time', array['a2202f68-29fb-41ca-8761-81a75942e2ec']::uuid[], array['d9158b08-da9d-44b7-ac0c-881e41bd29e1']::uuid[], 'CLOSED'),
  ('29bd7f2f-5cdd-4298-8e48-4bf55f52b251', 'KPI-RF-076', 'Restorative time', array['a2202f68-29fb-41ca-8761-81a75942e2ec']::uuid[], array['ae41ace9-1781-4ee7-9eee-407472d1d9b3']::uuid[], 'CLOSED'),
  ('c3b8a91e-2fc2-4c42-b802-8e5092a4f8c6', 'KPI-SF-077', 'Similarity state to unperturbed situation', array['a2202f68-29fb-41ca-8761-81a75942e2ec']::uuid[], array['db6a239b-ead8-48f7-8a65-02a676c72cd6']::uuid[], 'CLOSED');

INSERT INTO benchmark_definitions
  (id, name, description, field_definition_ids, test_definition_ids)
VALUES
  ('c5145011-ce69-4679-8694-e1dbeb1ee4bb', 'Effectiveness', 'Effectiveness', array['316b5e38-44ac-48b7-b894-c25f13dddfb2']::uuid[], array['aeabd5b9-4e86-4c7a-859f-a32ff1be5516', '42fbb160-a300-43f7-9268-e290f6daad9c', 'a40240d3-580e-4bad-a90d-608743600422', 'cba954e0-a48b-473a-bf9d-d12a1b5e946f', '7f5bf3a1-ac9e-443f-8607-eaa51d80c85e', '4f0ea3a1-71df-4528-ac0e-b3df1488e970', '687a01f3-4dc5-4926-a862-7f307c3df597', '836bfb70-1366-4e27-aca5-2bd0aeaeb366']::uuid[]),
  ('74b5d783-54cd-4161-a974-8865118dc2f7', 'Solution quality', 'Solution quality', array['90c8ac1d-10e4-400c-9893-6caaa2a1f2a9']::uuid[], array['7c0b7586-a36f-4787-bfe3-b9739938b622', '86410bb1-a118-491a-8905-03d6e1917818', '06d84884-1289-414f-a4b6-444e983f8f81', '0f9a514e-78e7-405d-bcee-c3b9b3463c68', '8112102c-69b3-45cc-9b8e-67d5d8b65c4c']::uuid[]),
  ('e49fe4e4-93b4-4f73-a4a2-fb63a5b166cf', 'Scalability', 'Scalability', array['90c8ac1d-10e4-400c-9893-6caaa2a1f2a9']::uuid[], array['e5fa0a00-d169-4084-83c1-a6088765453c', 'e5dafe01-e9a1-4d7e-a7c0-085b80315dcc']::uuid[]),
  ('255fb1e8-af57-45a0-97dc-ecc3e6721b4f', 'AI-human learning curves', 'AI-human learning curves', array['90c8ac1d-10e4-400c-9893-6caaa2a1f2a9']::uuid[], array['99f5a8f8-38d9-4a8c-9630-4789b0225ec0', 'f23794a2-dcf2-4699-bb5f-534bcea5ecf0']::uuid[]),
  ('1df5f920-ed2c-4873-957b-723b4b5d81b1', 'Resilience', 'Resilience', array['a294a990-a400-45dc-ade2-6b88a5da0808']::uuid[], array['6f25b647-0a2a-4e28-99b9-e1feacbdf4ad', 'c4f3c534-e74c-491c-8044-b5529f6a42e0', '29bd7f2f-5cdd-4298-8e48-4bf55f52b251', 'c3b8a91e-2fc2-4c42-b802-8e5092a4f8c6']::uuid[]);

-- insert one submission per kpi and additional ones for testing (top solution, published...)
INSERT INTO submissions
  (id, benchmark_definition_id, test_definition_ids, name, description, submission_data_url, submitted_at, submitted_by_username, status, published)
VALUES
  -- Effectiveness
  ('cd4d44bc-d40e-4173-bccb-f04e0be1b2ae', 'c5145011-ce69-4679-8694-e1dbeb1ee4bb', array['aeabd5b9-4e86-4c7a-859f-a32ff1be5516']::uuid[], 'AI4REALNET Ex 1', 'AI4REALNET example submission 1', '', current_timestamp, 'Example', 'SUCCESS', true),
  ('ca001ce9-f10f-4dea-a299-2a0efce0f00d', 'c5145011-ce69-4679-8694-e1dbeb1ee4bb', array['42fbb160-a300-43f7-9268-e290f6daad9c']::uuid[], 'AI4REALNET Ex 2', 'AI4REALNET example submission 2', '', current_timestamp, 'Example', 'SUCCESS', true),
  ('0f4ecf0f-c0a8-4141-9b28-1cb488808e14', 'c5145011-ce69-4679-8694-e1dbeb1ee4bb', array['a40240d3-580e-4bad-a90d-608743600422']::uuid[], 'AI4REALNET Ex 3', 'AI4REALNET example submission 3', '', current_timestamp, 'Example', 'SUCCESS', true),
  ('d3408a40-c7b5-4d34-9f89-fd0322114273', 'c5145011-ce69-4679-8694-e1dbeb1ee4bb', array['cba954e0-a48b-473a-bf9d-d12a1b5e946f']::uuid[], 'AI4REALNET Ex 4', 'AI4REALNET example submission 4', '', current_timestamp, 'Example', 'SUCCESS', true),
  ('392b0c0a-5ea0-45c9-86c7-50d16c35271b', 'c5145011-ce69-4679-8694-e1dbeb1ee4bb', array['7f5bf3a1-ac9e-443f-8607-eaa51d80c85e']::uuid[], 'AI4REALNET Ex 5', 'AI4REALNET example submission 5', '', current_timestamp, 'Example', 'SUCCESS', true),
  ('c0781558-f35a-4f06-8bf4-6cff18b165e0', 'c5145011-ce69-4679-8694-e1dbeb1ee4bb', array['4f0ea3a1-71df-4528-ac0e-b3df1488e970']::uuid[], 'AI4REALNET Ex 6', 'AI4REALNET example submission 6', '', current_timestamp, 'Example', 'SUCCESS', true),
  ('398684ee-fb13-4a73-95ac-f5a6584bb9ea', 'c5145011-ce69-4679-8694-e1dbeb1ee4bb', array['687a01f3-4dc5-4926-a862-7f307c3df597']::uuid[], 'AI4REALNET Ex 7', 'AI4REALNET example submission 7', '', current_timestamp, 'Example', 'SUCCESS', true),
  ('fb655288-2b79-4a1f-a9a7-bf449ffa3f70', 'c5145011-ce69-4679-8694-e1dbeb1ee4bb', array['836bfb70-1366-4e27-aca5-2bd0aeaeb366']::uuid[], 'AI4REALNET Ex 8', 'AI4REALNET example submission 8', '', current_timestamp, 'Example', 'SUCCESS', true),
  -- Effectiveness, additional
  ('5fa91da5-127b-408c-8863-a3ac670030b3', 'c5145011-ce69-4679-8694-e1dbeb1ee4bb', array['aeabd5b9-4e86-4c7a-859f-a32ff1be5516']::uuid[], 'AI4REALNET Ex 9', 'AI4REALNET example submission 9', '', current_timestamp, 'Example', 'SUCCESS', true),
  ('06ad18b5-e697-4684-aa7b-76b5c82c4307', 'c5145011-ce69-4679-8694-e1dbeb1ee4bb', array['aeabd5b9-4e86-4c7a-859f-a32ff1be5516']::uuid[], 'AI4REALNET Ex 10', 'AI4REALNET example submission 10', '', current_timestamp, 'Example', 'SUCCESS', false),
  -- Resilience
  ('a8bb32be-a596-4636-898d-7e1fe7c7492d', '1df5f920-ed2c-4873-957b-723b4b5d81b1', array['6f25b647-0a2a-4e28-99b9-e1feacbdf4ad']::uuid[], 'AI4REALNET Ex 11', 'AI4REALNET example submission 11', '', current_timestamp, 'Example', 'SUCCESS', true),
  ('6d7784d0-cce3-4360-a5ec-5576107107b4', '1df5f920-ed2c-4873-957b-723b4b5d81b1', array['c4f3c534-e74c-491c-8044-b5529f6a42e0']::uuid[], 'AI4REALNET Ex 12', 'AI4REALNET example submission 12', '', current_timestamp, 'Example', 'SUCCESS', true),
  ('0b545681-3298-4a05-867a-9562edcebe7d', '1df5f920-ed2c-4873-957b-723b4b5d81b1', array['29bd7f2f-5cdd-4298-8e48-4bf55f52b251']::uuid[], 'AI4REALNET Ex 13', 'AI4REALNET example submission 13', '', current_timestamp, 'Example', 'SUCCESS', true),
  ('4da2f15b-3a55-474a-a9a2-5c7481aef4e1', '1df5f920-ed2c-4873-957b-723b4b5d81b1', array['c3b8a91e-2fc2-4c42-b802-8e5092a4f8c6']::uuid[], 'AI4REALNET Ex 14', 'AI4REALNET example submission 14', '', current_timestamp, 'Example', 'SUCCESS', true);

-- insert one result per submission (because there's only one test per submission and one scenario each)
INSERT INTO results
  (scenario_definition_id, test_definition_id, submission_id, key, value)
VALUES
  -- Effectiveness
  ('8fba6834-cd86-4bca-b3b5-f14d6c54d92f', 'aeabd5b9-4e86-4c7a-859f-a32ff1be5516', 'cd4d44bc-d40e-4173-bccb-f04e0be1b2ae', 'primary', 0.86),
  ('94547c7d-80ec-47ac-9146-80da362b79fa', '42fbb160-a300-43f7-9268-e290f6daad9c', 'ca001ce9-f10f-4dea-a299-2a0efce0f00d', 'primary', 0.45),
  ('edf822cf-c11d-471e-86df-723ad1f56e00', 'a40240d3-580e-4bad-a90d-608743600422', '0f4ecf0f-c0a8-4141-9b28-1cb488808e14', 'primary', 0.90),
  ('69fdd7b7-5f66-40b6-8dc5-92a8a7b0ba68', 'cba954e0-a48b-473a-bf9d-d12a1b5e946f', 'd3408a40-c7b5-4d34-9f89-fd0322114273', 'primary', 0.92),
  ('dd1aed5d-f411-491e-ae3f-88b1cce596f6', '7f5bf3a1-ac9e-443f-8607-eaa51d80c85e', '392b0c0a-5ea0-45c9-86c7-50d16c35271b', 'primary', 0.63),
  ('cdcbfdac-1886-4d97-9994-972a25c49903', '4f0ea3a1-71df-4528-ac0e-b3df1488e970', 'c0781558-f35a-4f06-8bf4-6cff18b165e0', 'primary', 0.72),
  ('7f4ebf12-ea7d-4722-ae4b-bee551a16b51', '687a01f3-4dc5-4926-a862-7f307c3df597', '398684ee-fb13-4a73-95ac-f5a6584bb9ea', 'primary', 0.53),
  ('5bd5fdac-5311-41fe-bcfd-705daed0bf9e', '836bfb70-1366-4e27-aca5-2bd0aeaeb366', 'fb655288-2b79-4a1f-a9a7-bf449ffa3f70', 'primary', 0.81),
  -- Effectiveness, additional one for first KPI with lower score
  ('8fba6834-cd86-4bca-b3b5-f14d6c54d92f', 'aeabd5b9-4e86-4c7a-859f-a32ff1be5516', '5fa91da5-127b-408c-8863-a3ac670030b3', 'primary', 0.20),
  -- Effectiveness, additional one for first KPI with higher score but unpublished
  ('8fba6834-cd86-4bca-b3b5-f14d6c54d92f', 'aeabd5b9-4e86-4c7a-859f-a32ff1be5516', '06ad18b5-e697-4684-aa7b-76b5c82c4307', 'primary', 0.99),
  -- Resilience
  ('a40de74a-1ecd-4ee7-be64-9ccbeb5b03de', '6f25b647-0a2a-4e28-99b9-e1feacbdf4ad', 'a8bb32be-a596-4636-898d-7e1fe7c7492d', 'primary', 0.85),
  ('d9158b08-da9d-44b7-ac0c-881e41bd29e1', 'c4f3c534-e74c-491c-8044-b5529f6a42e0', '6d7784d0-cce3-4360-a5ec-5576107107b4', 'primary', 0.77),
  ('ae41ace9-1781-4ee7-9eee-407472d1d9b3', '29bd7f2f-5cdd-4298-8e48-4bf55f52b251', '0b545681-3298-4a05-867a-9562edcebe7d', 'primary', 0.93),
  ('db6a239b-ead8-48f7-8a65-02a676c72cd6', 'c3b8a91e-2fc2-4c42-b802-8e5092a4f8c6', '4da2f15b-3a55-474a-a9a2-5c7481aef4e1', 'primary', 0.72);