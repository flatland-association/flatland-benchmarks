INSERT INTO suites
  (id, setup, name, description, contents, benchmark_ids)
VALUES ('e50ddf17-c366-4f24-8e65-d82e71f53b19', 'DEFAULT', 'Post-ECML 2026',
        'Post-competition continuation of the AI4REALNET Railway Competition 2026 benchmark', '{}',
        array['8a4b14c6-4ef4-4672-96a9-57be0e292a06']::uuid[]) ON CONFLICT(id) DO
UPDATE SET setup=EXCLUDED.setup, name =EXCLUDED.name, description=EXCLUDED.description, contents=EXCLUDED.contents, benchmark_ids=EXCLUDED.benchmark_ids;

INSERT INTO benchmarks
  (id, name, description, field_ids, test_ids)
VALUES ('8a4b14c6-4ef4-4672-96a9-57be0e292a06', 'Post-ECML 2026', 'AI4REALNET Railway Competition 2026', array['3579d972-0c4d-4db9-9b17-c964a34be970',
        '38cb33d1-d7c7-4804-8664-c417b347d87b']::uuid[], array['092b4818-3b91-4b57-bab1-5d409f3f811d', '3f295192-1413-4bd5-a2c5-dced8ba0ae26',
        'f6d78d8e-aabb-4e24-b529-2001d6836def', '1fa91591-6ce3-45ea-9963-50af2b64fae4', 'f47e2af9-df9b-412e-a2cc-a5a59c9a5436',
        '9fd40851-b990-4359-9076-d40089afa8f7', '1f856e14-556d-410c-a281-74f74d213725']::uuid[]) ON CONFLICT(id) DO
UPDATE SET name=EXCLUDED.name, description=EXCLUDED.description, field_ids=EXCLUDED.field_ids, test_ids=EXCLUDED.test_ids;

INSERT INTO fields
  (id, key, description, agg_func, agg_fields)
VALUES ('3579d972-0c4d-4db9-9b17-c964a34be970', 'normalized_reward', 'Primary benchmark score (NANSUM of corresponding test scores)', 'NANSUM',
        '"normalized_reward"') ON CONFLICT(id) DO
UPDATE SET key =EXCLUDED.key, description=EXCLUDED.description, agg_func=EXCLUDED.agg_func, agg_fields=EXCLUDED.agg_fields;

INSERT INTO fields
  (id, key, description, agg_func, agg_fields)
VALUES ('38cb33d1-d7c7-4804-8664-c417b347d87b', 'percentage_complete', 'Secondary benchmark score (NANMEAN of corresponding test scores)', 'NANMEAN',
        '"percentage_complete"') ON CONFLICT(id) DO
UPDATE SET key =EXCLUDED.key, description=EXCLUDED.description, agg_func=EXCLUDED.agg_func, agg_fields=EXCLUDED.agg_fields;

INSERT INTO tests
  (id, name, description, field_ids, scenario_ids, loop, queue)
VALUES ('092b4818-3b91-4b57-bab1-5d409f3f811d', 'Test 0', 'Level 0', array['978bc744-57dc-487e-9c38-4362a8b6f308',
        '36aa6284-ace4-463c-a79b-a9f7542a1c20']::uuid[], array['fb3ceb9b-8ca5-467d-8a2a-90ea97f58e36', '8c5ecce8-8b98-4a5c-8b0a-0dcc1ae63671',
        '6b3ae2c5-91bb-487c-a985-b2a4ef539001', '586ef2f7-8e45-4237-968c-abdab17f86bf', '93ac30ae-488b-4e53-9f41-9e7ca36b8806']::uuid[], 'CLOSED',
        NULL) ON CONFLICT(id) DO
UPDATE SET name=EXCLUDED.name, description=EXCLUDED.description, field_ids=EXCLUDED.field_ids, scenario_ids=EXCLUDED.scenario_ids, loop=EXCLUDED.loop, queue=EXCLUDED.queue;

INSERT INTO fields
  (id, key, description, agg_func, agg_fields)
VALUES ('978bc744-57dc-487e-9c38-4362a8b6f308', 'normalized_reward', 'Primary test score (NANSUM of corresponding scenario scores)', 'NANSUM',
        '"normalized_reward"') ON CONFLICT(id) DO
UPDATE SET key =EXCLUDED.key, description=EXCLUDED.description, agg_func=EXCLUDED.agg_func, agg_fields=EXCLUDED.agg_fields;

INSERT INTO fields
  (id, key, description, agg_func, agg_fields)
VALUES ('36aa6284-ace4-463c-a79b-a9f7542a1c20', 'percentage_complete', 'Secondary test score (NANMEAN of corresponding scenario scores)', 'NANMEAN',
        '"percentage_complete"') ON CONFLICT(id) DO
UPDATE SET key =EXCLUDED.key, description=EXCLUDED.description, agg_func=EXCLUDED.agg_func, agg_fields=EXCLUDED.agg_fields;

INSERT INTO scenarios
  (id, name, description, field_ids)
VALUES ('fb3ceb9b-8ca5-467d-8a2a-90ea97f58e36', 'fb3ceb9b-8ca5-467d-8a2a-90ea97f58e36', 'fb3ceb9b-8ca5-467d-8a2a-90ea97f58e36',
        array['91c8162f-6cf3-42f8-98fa-21de3e367ec9', 'b777cadb-62dc-4cfc-9b62-e37995327d41']::uuid[]) ON CONFLICT(id) DO
UPDATE SET name=EXCLUDED.name, description=EXCLUDED.description, field_ids=EXCLUDED.field_ids;

INSERT INTO fields
  (id, key, description, agg_func, agg_weights)
VALUES ('91c8162f-6cf3-42f8-98fa-21de3e367ec9', 'normalized_reward', 'Primary raw scenario score.', NULL, NULL) ON CONFLICT(id) DO
UPDATE SET key =EXCLUDED.key, description=EXCLUDED.description, agg_func=EXCLUDED.agg_func, agg_weights=EXCLUDED.agg_weights;

INSERT INTO fields
  (id, key, description, agg_func, agg_weights)
VALUES ('b777cadb-62dc-4cfc-9b62-e37995327d41', 'percentage_complete', 'Secondary raw scenario score.', NULL, NULL) ON CONFLICT(id) DO
UPDATE SET key =EXCLUDED.key, description=EXCLUDED.description, agg_func=EXCLUDED.agg_func, agg_weights=EXCLUDED.agg_weights;

INSERT INTO scenarios
  (id, name, description, field_ids)
VALUES ('8c5ecce8-8b98-4a5c-8b0a-0dcc1ae63671', '8c5ecce8-8b98-4a5c-8b0a-0dcc1ae63671', '8c5ecce8-8b98-4a5c-8b0a-0dcc1ae63671',
        array['91c8162f-6cf3-42f8-98fa-21de3e367ec9', 'b777cadb-62dc-4cfc-9b62-e37995327d41']::uuid[]) ON CONFLICT(id) DO
UPDATE SET name=EXCLUDED.name, description=EXCLUDED.description, field_ids=EXCLUDED.field_ids;

INSERT INTO fields
  (id, key, description, agg_func, agg_weights)
VALUES ('91c8162f-6cf3-42f8-98fa-21de3e367ec9', 'normalized_reward', 'Primary raw scenario score.', NULL, NULL) ON CONFLICT(id) DO
UPDATE SET key =EXCLUDED.key, description=EXCLUDED.description, agg_func=EXCLUDED.agg_func, agg_weights=EXCLUDED.agg_weights;

INSERT INTO fields
  (id, key, description, agg_func, agg_weights)
VALUES ('b777cadb-62dc-4cfc-9b62-e37995327d41', 'percentage_complete', 'Secondary raw scenario score.', NULL, NULL) ON CONFLICT(id) DO
UPDATE SET key =EXCLUDED.key, description=EXCLUDED.description, agg_func=EXCLUDED.agg_func, agg_weights=EXCLUDED.agg_weights;

INSERT INTO scenarios
  (id, name, description, field_ids)
VALUES ('6b3ae2c5-91bb-487c-a985-b2a4ef539001', '6b3ae2c5-91bb-487c-a985-b2a4ef539001', '6b3ae2c5-91bb-487c-a985-b2a4ef539001',
        array['91c8162f-6cf3-42f8-98fa-21de3e367ec9', 'b777cadb-62dc-4cfc-9b62-e37995327d41']::uuid[]) ON CONFLICT(id) DO
UPDATE SET name=EXCLUDED.name, description=EXCLUDED.description, field_ids=EXCLUDED.field_ids;

INSERT INTO fields
  (id, key, description, agg_func, agg_weights)
VALUES ('91c8162f-6cf3-42f8-98fa-21de3e367ec9', 'normalized_reward', 'Primary raw scenario score.', NULL, NULL) ON CONFLICT(id) DO
UPDATE SET key =EXCLUDED.key, description=EXCLUDED.description, agg_func=EXCLUDED.agg_func, agg_weights=EXCLUDED.agg_weights;

INSERT INTO fields
  (id, key, description, agg_func, agg_weights)
VALUES ('b777cadb-62dc-4cfc-9b62-e37995327d41', 'percentage_complete', 'Secondary raw scenario score.', NULL, NULL) ON CONFLICT(id) DO
UPDATE SET key =EXCLUDED.key, description=EXCLUDED.description, agg_func=EXCLUDED.agg_func, agg_weights=EXCLUDED.agg_weights;

INSERT INTO scenarios
  (id, name, description, field_ids)
VALUES ('586ef2f7-8e45-4237-968c-abdab17f86bf', '586ef2f7-8e45-4237-968c-abdab17f86bf', '586ef2f7-8e45-4237-968c-abdab17f86bf',
        array['91c8162f-6cf3-42f8-98fa-21de3e367ec9', 'b777cadb-62dc-4cfc-9b62-e37995327d41']::uuid[]) ON CONFLICT(id) DO
UPDATE SET name=EXCLUDED.name, description=EXCLUDED.description, field_ids=EXCLUDED.field_ids;

INSERT INTO fields
  (id, key, description, agg_func, agg_weights)
VALUES ('91c8162f-6cf3-42f8-98fa-21de3e367ec9', 'normalized_reward', 'Primary raw scenario score.', NULL, NULL) ON CONFLICT(id) DO
UPDATE SET key =EXCLUDED.key, description=EXCLUDED.description, agg_func=EXCLUDED.agg_func, agg_weights=EXCLUDED.agg_weights;

INSERT INTO fields
  (id, key, description, agg_func, agg_weights)
VALUES ('b777cadb-62dc-4cfc-9b62-e37995327d41', 'percentage_complete', 'Secondary raw scenario score.', NULL, NULL) ON CONFLICT(id) DO
UPDATE SET key =EXCLUDED.key, description=EXCLUDED.description, agg_func=EXCLUDED.agg_func, agg_weights=EXCLUDED.agg_weights;

INSERT INTO scenarios
  (id, name, description, field_ids)
VALUES ('93ac30ae-488b-4e53-9f41-9e7ca36b8806', '93ac30ae-488b-4e53-9f41-9e7ca36b8806', '93ac30ae-488b-4e53-9f41-9e7ca36b8806',
        array['91c8162f-6cf3-42f8-98fa-21de3e367ec9', 'b777cadb-62dc-4cfc-9b62-e37995327d41']::uuid[]) ON CONFLICT(id) DO
UPDATE SET name=EXCLUDED.name, description=EXCLUDED.description, field_ids=EXCLUDED.field_ids;

INSERT INTO fields
  (id, key, description, agg_func, agg_weights)
VALUES ('91c8162f-6cf3-42f8-98fa-21de3e367ec9', 'normalized_reward', 'Primary raw scenario score.', NULL, NULL) ON CONFLICT(id) DO
UPDATE SET key =EXCLUDED.key, description=EXCLUDED.description, agg_func=EXCLUDED.agg_func, agg_weights=EXCLUDED.agg_weights;

INSERT INTO fields
  (id, key, description, agg_func, agg_weights)
VALUES ('b777cadb-62dc-4cfc-9b62-e37995327d41', 'percentage_complete', 'Secondary raw scenario score.', NULL, NULL) ON CONFLICT(id) DO
UPDATE SET key =EXCLUDED.key, description=EXCLUDED.description, agg_func=EXCLUDED.agg_func, agg_weights=EXCLUDED.agg_weights;

INSERT INTO tests
  (id, name, description, field_ids, scenario_ids, loop, queue)
VALUES ('3f295192-1413-4bd5-a2c5-dced8ba0ae26', 'Test 1', 'Level 1', array['978bc744-57dc-487e-9c38-4362a8b6f308',
        '36aa6284-ace4-463c-a79b-a9f7542a1c20']::uuid[], array['08108a2f-0b54-463f-b984-14d1a95c89e3', '2f544074-b4f3-46c8-99c5-12f119dcb99a',
        '1f62916f-be73-4dca-a9d0-fd6a07b9259f', '49de4bde-5af8-4039-af82-6c94c320a60b', '87859343-4a2a-4aba-9fca-4c2f84e21496']::uuid[], 'CLOSED',
        NULL) ON CONFLICT(id) DO
UPDATE SET name=EXCLUDED.name, description=EXCLUDED.description, field_ids=EXCLUDED.field_ids, scenario_ids=EXCLUDED.scenario_ids, loop=EXCLUDED.loop, queue=EXCLUDED.queue;

INSERT INTO fields
  (id, key, description, agg_func, agg_fields)
VALUES ('978bc744-57dc-487e-9c38-4362a8b6f308', 'normalized_reward', 'Primary test score (NANSUM of corresponding scenario scores)', 'NANSUM',
        '"normalized_reward"') ON CONFLICT(id) DO
UPDATE SET key =EXCLUDED.key, description=EXCLUDED.description, agg_func=EXCLUDED.agg_func, agg_fields=EXCLUDED.agg_fields;

INSERT INTO fields
  (id, key, description, agg_func, agg_fields)
VALUES ('36aa6284-ace4-463c-a79b-a9f7542a1c20', 'percentage_complete', 'Secondary test score (NANMEAN of corresponding scenario scores)', 'NANMEAN',
        '"percentage_complete"') ON CONFLICT(id) DO
UPDATE SET key =EXCLUDED.key, description=EXCLUDED.description, agg_func=EXCLUDED.agg_func, agg_fields=EXCLUDED.agg_fields;

INSERT INTO scenarios
  (id, name, description, field_ids)
VALUES ('08108a2f-0b54-463f-b984-14d1a95c89e3', '08108a2f-0b54-463f-b984-14d1a95c89e3', '08108a2f-0b54-463f-b984-14d1a95c89e3',
        array['91c8162f-6cf3-42f8-98fa-21de3e367ec9', 'b777cadb-62dc-4cfc-9b62-e37995327d41']::uuid[]) ON CONFLICT(id) DO
UPDATE SET name=EXCLUDED.name, description=EXCLUDED.description, field_ids=EXCLUDED.field_ids;

INSERT INTO fields
  (id, key, description, agg_func, agg_weights)
VALUES ('91c8162f-6cf3-42f8-98fa-21de3e367ec9', 'normalized_reward', 'Primary raw scenario score.', NULL, NULL) ON CONFLICT(id) DO
UPDATE SET key =EXCLUDED.key, description=EXCLUDED.description, agg_func=EXCLUDED.agg_func, agg_weights=EXCLUDED.agg_weights;

INSERT INTO fields
  (id, key, description, agg_func, agg_weights)
VALUES ('b777cadb-62dc-4cfc-9b62-e37995327d41', 'percentage_complete', 'Secondary raw scenario score.', NULL, NULL) ON CONFLICT(id) DO
UPDATE SET key =EXCLUDED.key, description=EXCLUDED.description, agg_func=EXCLUDED.agg_func, agg_weights=EXCLUDED.agg_weights;

INSERT INTO scenarios
  (id, name, description, field_ids)
VALUES ('2f544074-b4f3-46c8-99c5-12f119dcb99a', '2f544074-b4f3-46c8-99c5-12f119dcb99a', '2f544074-b4f3-46c8-99c5-12f119dcb99a',
        array['91c8162f-6cf3-42f8-98fa-21de3e367ec9', 'b777cadb-62dc-4cfc-9b62-e37995327d41']::uuid[]) ON CONFLICT(id) DO
UPDATE SET name=EXCLUDED.name, description=EXCLUDED.description, field_ids=EXCLUDED.field_ids;

INSERT INTO fields
  (id, key, description, agg_func, agg_weights)
VALUES ('91c8162f-6cf3-42f8-98fa-21de3e367ec9', 'normalized_reward', 'Primary raw scenario score.', NULL, NULL) ON CONFLICT(id) DO
UPDATE SET key =EXCLUDED.key, description=EXCLUDED.description, agg_func=EXCLUDED.agg_func, agg_weights=EXCLUDED.agg_weights;

INSERT INTO fields
  (id, key, description, agg_func, agg_weights)
VALUES ('b777cadb-62dc-4cfc-9b62-e37995327d41', 'percentage_complete', 'Secondary raw scenario score.', NULL, NULL) ON CONFLICT(id) DO
UPDATE SET key =EXCLUDED.key, description=EXCLUDED.description, agg_func=EXCLUDED.agg_func, agg_weights=EXCLUDED.agg_weights;

INSERT INTO scenarios
  (id, name, description, field_ids)
VALUES ('1f62916f-be73-4dca-a9d0-fd6a07b9259f', '1f62916f-be73-4dca-a9d0-fd6a07b9259f', '1f62916f-be73-4dca-a9d0-fd6a07b9259f',
        array['91c8162f-6cf3-42f8-98fa-21de3e367ec9', 'b777cadb-62dc-4cfc-9b62-e37995327d41']::uuid[]) ON CONFLICT(id) DO
UPDATE SET name=EXCLUDED.name, description=EXCLUDED.description, field_ids=EXCLUDED.field_ids;

INSERT INTO fields
  (id, key, description, agg_func, agg_weights)
VALUES ('91c8162f-6cf3-42f8-98fa-21de3e367ec9', 'normalized_reward', 'Primary raw scenario score.', NULL, NULL) ON CONFLICT(id) DO
UPDATE SET key =EXCLUDED.key, description=EXCLUDED.description, agg_func=EXCLUDED.agg_func, agg_weights=EXCLUDED.agg_weights;

INSERT INTO fields
  (id, key, description, agg_func, agg_weights)
VALUES ('b777cadb-62dc-4cfc-9b62-e37995327d41', 'percentage_complete', 'Secondary raw scenario score.', NULL, NULL) ON CONFLICT(id) DO
UPDATE SET key =EXCLUDED.key, description=EXCLUDED.description, agg_func=EXCLUDED.agg_func, agg_weights=EXCLUDED.agg_weights;

INSERT INTO scenarios
  (id, name, description, field_ids)
VALUES ('49de4bde-5af8-4039-af82-6c94c320a60b', '49de4bde-5af8-4039-af82-6c94c320a60b', '49de4bde-5af8-4039-af82-6c94c320a60b',
        array['91c8162f-6cf3-42f8-98fa-21de3e367ec9', 'b777cadb-62dc-4cfc-9b62-e37995327d41']::uuid[]) ON CONFLICT(id) DO
UPDATE SET name=EXCLUDED.name, description=EXCLUDED.description, field_ids=EXCLUDED.field_ids;

INSERT INTO fields
  (id, key, description, agg_func, agg_weights)
VALUES ('91c8162f-6cf3-42f8-98fa-21de3e367ec9', 'normalized_reward', 'Primary raw scenario score.', NULL, NULL) ON CONFLICT(id) DO
UPDATE SET key =EXCLUDED.key, description=EXCLUDED.description, agg_func=EXCLUDED.agg_func, agg_weights=EXCLUDED.agg_weights;

INSERT INTO fields
  (id, key, description, agg_func, agg_weights)
VALUES ('b777cadb-62dc-4cfc-9b62-e37995327d41', 'percentage_complete', 'Secondary raw scenario score.', NULL, NULL) ON CONFLICT(id) DO
UPDATE SET key =EXCLUDED.key, description=EXCLUDED.description, agg_func=EXCLUDED.agg_func, agg_weights=EXCLUDED.agg_weights;

INSERT INTO scenarios
  (id, name, description, field_ids)
VALUES ('87859343-4a2a-4aba-9fca-4c2f84e21496', '87859343-4a2a-4aba-9fca-4c2f84e21496', '87859343-4a2a-4aba-9fca-4c2f84e21496',
        array['91c8162f-6cf3-42f8-98fa-21de3e367ec9', 'b777cadb-62dc-4cfc-9b62-e37995327d41']::uuid[]) ON CONFLICT(id) DO
UPDATE SET name=EXCLUDED.name, description=EXCLUDED.description, field_ids=EXCLUDED.field_ids;

INSERT INTO fields
  (id, key, description, agg_func, agg_weights)
VALUES ('91c8162f-6cf3-42f8-98fa-21de3e367ec9', 'normalized_reward', 'Primary raw scenario score.', NULL, NULL) ON CONFLICT(id) DO
UPDATE SET key =EXCLUDED.key, description=EXCLUDED.description, agg_func=EXCLUDED.agg_func, agg_weights=EXCLUDED.agg_weights;

INSERT INTO fields
  (id, key, description, agg_func, agg_weights)
VALUES ('b777cadb-62dc-4cfc-9b62-e37995327d41', 'percentage_complete', 'Secondary raw scenario score.', NULL, NULL) ON CONFLICT(id) DO
UPDATE SET key =EXCLUDED.key, description=EXCLUDED.description, agg_func=EXCLUDED.agg_func, agg_weights=EXCLUDED.agg_weights;

INSERT INTO tests
  (id, name, description, field_ids, scenario_ids, loop, queue)
VALUES ('f6d78d8e-aabb-4e24-b529-2001d6836def', 'Test 2', 'Level 2', array['978bc744-57dc-487e-9c38-4362a8b6f308',
        '36aa6284-ace4-463c-a79b-a9f7542a1c20']::uuid[], array['20427420-5490-44ec-aa91-d93b2ab6856d', '231d302c-acfd-42c2-958d-610ea6f86b32',
        '0d21a800-6167-4740-8678-d9cda13f55e6', 'b16a32b9-b10f-4538-8205-a76f3a946022', '3828cf95-5768-4ee6-ab0a-5ada9b7dc0cc']::uuid[], 'CLOSED',
        NULL) ON CONFLICT(id) DO
UPDATE SET name=EXCLUDED.name, description=EXCLUDED.description, field_ids=EXCLUDED.field_ids, scenario_ids=EXCLUDED.scenario_ids, loop=EXCLUDED.loop, queue=EXCLUDED.queue;

INSERT INTO fields
  (id, key, description, agg_func, agg_fields)
VALUES ('978bc744-57dc-487e-9c38-4362a8b6f308', 'normalized_reward', 'Primary test score (NANSUM of corresponding scenario scores)', 'NANSUM',
        '"normalized_reward"') ON CONFLICT(id) DO
UPDATE SET key =EXCLUDED.key, description=EXCLUDED.description, agg_func=EXCLUDED.agg_func, agg_fields=EXCLUDED.agg_fields;

INSERT INTO fields
  (id, key, description, agg_func, agg_fields)
VALUES ('36aa6284-ace4-463c-a79b-a9f7542a1c20', 'percentage_complete', 'Secondary test score (NANMEAN of corresponding scenario scores)', 'NANMEAN',
        '"percentage_complete"') ON CONFLICT(id) DO
UPDATE SET key =EXCLUDED.key, description=EXCLUDED.description, agg_func=EXCLUDED.agg_func, agg_fields=EXCLUDED.agg_fields;

INSERT INTO scenarios
  (id, name, description, field_ids)
VALUES ('20427420-5490-44ec-aa91-d93b2ab6856d', '20427420-5490-44ec-aa91-d93b2ab6856d', '20427420-5490-44ec-aa91-d93b2ab6856d',
        array['91c8162f-6cf3-42f8-98fa-21de3e367ec9', 'b777cadb-62dc-4cfc-9b62-e37995327d41']::uuid[]) ON CONFLICT(id) DO
UPDATE SET name=EXCLUDED.name, description=EXCLUDED.description, field_ids=EXCLUDED.field_ids;

INSERT INTO fields
  (id, key, description, agg_func, agg_weights)
VALUES ('91c8162f-6cf3-42f8-98fa-21de3e367ec9', 'normalized_reward', 'Primary raw scenario score.', NULL, NULL) ON CONFLICT(id) DO
UPDATE SET key =EXCLUDED.key, description=EXCLUDED.description, agg_func=EXCLUDED.agg_func, agg_weights=EXCLUDED.agg_weights;

INSERT INTO fields
  (id, key, description, agg_func, agg_weights)
VALUES ('b777cadb-62dc-4cfc-9b62-e37995327d41', 'percentage_complete', 'Secondary raw scenario score.', NULL, NULL) ON CONFLICT(id) DO
UPDATE SET key =EXCLUDED.key, description=EXCLUDED.description, agg_func=EXCLUDED.agg_func, agg_weights=EXCLUDED.agg_weights;

INSERT INTO scenarios
  (id, name, description, field_ids)
VALUES ('231d302c-acfd-42c2-958d-610ea6f86b32', '231d302c-acfd-42c2-958d-610ea6f86b32', '231d302c-acfd-42c2-958d-610ea6f86b32',
        array['91c8162f-6cf3-42f8-98fa-21de3e367ec9', 'b777cadb-62dc-4cfc-9b62-e37995327d41']::uuid[]) ON CONFLICT(id) DO
UPDATE SET name=EXCLUDED.name, description=EXCLUDED.description, field_ids=EXCLUDED.field_ids;

INSERT INTO fields
  (id, key, description, agg_func, agg_weights)
VALUES ('91c8162f-6cf3-42f8-98fa-21de3e367ec9', 'normalized_reward', 'Primary raw scenario score.', NULL, NULL) ON CONFLICT(id) DO
UPDATE SET key =EXCLUDED.key, description=EXCLUDED.description, agg_func=EXCLUDED.agg_func, agg_weights=EXCLUDED.agg_weights;

INSERT INTO fields
  (id, key, description, agg_func, agg_weights)
VALUES ('b777cadb-62dc-4cfc-9b62-e37995327d41', 'percentage_complete', 'Secondary raw scenario score.', NULL, NULL) ON CONFLICT(id) DO
UPDATE SET key =EXCLUDED.key, description=EXCLUDED.description, agg_func=EXCLUDED.agg_func, agg_weights=EXCLUDED.agg_weights;

INSERT INTO scenarios
  (id, name, description, field_ids)
VALUES ('0d21a800-6167-4740-8678-d9cda13f55e6', '0d21a800-6167-4740-8678-d9cda13f55e6', '0d21a800-6167-4740-8678-d9cda13f55e6',
        array['91c8162f-6cf3-42f8-98fa-21de3e367ec9', 'b777cadb-62dc-4cfc-9b62-e37995327d41']::uuid[]) ON CONFLICT(id) DO
UPDATE SET name=EXCLUDED.name, description=EXCLUDED.description, field_ids=EXCLUDED.field_ids;

INSERT INTO fields
  (id, key, description, agg_func, agg_weights)
VALUES ('91c8162f-6cf3-42f8-98fa-21de3e367ec9', 'normalized_reward', 'Primary raw scenario score.', NULL, NULL) ON CONFLICT(id) DO
UPDATE SET key =EXCLUDED.key, description=EXCLUDED.description, agg_func=EXCLUDED.agg_func, agg_weights=EXCLUDED.agg_weights;

INSERT INTO fields
  (id, key, description, agg_func, agg_weights)
VALUES ('b777cadb-62dc-4cfc-9b62-e37995327d41', 'percentage_complete', 'Secondary raw scenario score.', NULL, NULL) ON CONFLICT(id) DO
UPDATE SET key =EXCLUDED.key, description=EXCLUDED.description, agg_func=EXCLUDED.agg_func, agg_weights=EXCLUDED.agg_weights;

INSERT INTO scenarios
  (id, name, description, field_ids)
VALUES ('b16a32b9-b10f-4538-8205-a76f3a946022', 'b16a32b9-b10f-4538-8205-a76f3a946022', 'b16a32b9-b10f-4538-8205-a76f3a946022',
        array['91c8162f-6cf3-42f8-98fa-21de3e367ec9', 'b777cadb-62dc-4cfc-9b62-e37995327d41']::uuid[]) ON CONFLICT(id) DO
UPDATE SET name=EXCLUDED.name, description=EXCLUDED.description, field_ids=EXCLUDED.field_ids;

INSERT INTO fields
  (id, key, description, agg_func, agg_weights)
VALUES ('91c8162f-6cf3-42f8-98fa-21de3e367ec9', 'normalized_reward', 'Primary raw scenario score.', NULL, NULL) ON CONFLICT(id) DO
UPDATE SET key =EXCLUDED.key, description=EXCLUDED.description, agg_func=EXCLUDED.agg_func, agg_weights=EXCLUDED.agg_weights;

INSERT INTO fields
  (id, key, description, agg_func, agg_weights)
VALUES ('b777cadb-62dc-4cfc-9b62-e37995327d41', 'percentage_complete', 'Secondary raw scenario score.', NULL, NULL) ON CONFLICT(id) DO
UPDATE SET key =EXCLUDED.key, description=EXCLUDED.description, agg_func=EXCLUDED.agg_func, agg_weights=EXCLUDED.agg_weights;

INSERT INTO scenarios
  (id, name, description, field_ids)
VALUES ('3828cf95-5768-4ee6-ab0a-5ada9b7dc0cc', '3828cf95-5768-4ee6-ab0a-5ada9b7dc0cc', '3828cf95-5768-4ee6-ab0a-5ada9b7dc0cc',
        array['91c8162f-6cf3-42f8-98fa-21de3e367ec9', 'b777cadb-62dc-4cfc-9b62-e37995327d41']::uuid[]) ON CONFLICT(id) DO
UPDATE SET name=EXCLUDED.name, description=EXCLUDED.description, field_ids=EXCLUDED.field_ids;

INSERT INTO fields
  (id, key, description, agg_func, agg_weights)
VALUES ('91c8162f-6cf3-42f8-98fa-21de3e367ec9', 'normalized_reward', 'Primary raw scenario score.', NULL, NULL) ON CONFLICT(id) DO
UPDATE SET key =EXCLUDED.key, description=EXCLUDED.description, agg_func=EXCLUDED.agg_func, agg_weights=EXCLUDED.agg_weights;

INSERT INTO fields
  (id, key, description, agg_func, agg_weights)
VALUES ('b777cadb-62dc-4cfc-9b62-e37995327d41', 'percentage_complete', 'Secondary raw scenario score.', NULL, NULL) ON CONFLICT(id) DO
UPDATE SET key =EXCLUDED.key, description=EXCLUDED.description, agg_func=EXCLUDED.agg_func, agg_weights=EXCLUDED.agg_weights;

INSERT INTO tests
  (id, name, description, field_ids, scenario_ids, loop, queue)
VALUES ('1fa91591-6ce3-45ea-9963-50af2b64fae4', 'Test 3', 'Level 3', array['978bc744-57dc-487e-9c38-4362a8b6f308',
        '36aa6284-ace4-463c-a79b-a9f7542a1c20']::uuid[], array['2b0260a7-20b0-4c44-a071-d24a4ca1a409', 'bae263a7-7fb7-4cf9-b794-19f23492b484',
        '8ab26dbb-c2cb-4f13-a7bc-2910514e1470', '84f7b0ab-d931-465d-8677-def5e0a21391', '65eccf10-3c72-4e25-99e5-a181807ac686']::uuid[], 'CLOSED',
        NULL) ON CONFLICT(id) DO
UPDATE SET name=EXCLUDED.name, description=EXCLUDED.description, field_ids=EXCLUDED.field_ids, scenario_ids=EXCLUDED.scenario_ids, loop=EXCLUDED.loop, queue=EXCLUDED.queue;

INSERT INTO fields
  (id, key, description, agg_func, agg_fields)
VALUES ('978bc744-57dc-487e-9c38-4362a8b6f308', 'normalized_reward', 'Primary test score (NANSUM of corresponding scenario scores)', 'NANSUM',
        '"normalized_reward"') ON CONFLICT(id) DO
UPDATE SET key =EXCLUDED.key, description=EXCLUDED.description, agg_func=EXCLUDED.agg_func, agg_fields=EXCLUDED.agg_fields;

INSERT INTO fields
  (id, key, description, agg_func, agg_fields)
VALUES ('36aa6284-ace4-463c-a79b-a9f7542a1c20', 'percentage_complete', 'Secondary test score (NANMEAN of corresponding scenario scores)', 'NANMEAN',
        '"percentage_complete"') ON CONFLICT(id) DO
UPDATE SET key =EXCLUDED.key, description=EXCLUDED.description, agg_func=EXCLUDED.agg_func, agg_fields=EXCLUDED.agg_fields;

INSERT INTO scenarios
  (id, name, description, field_ids)
VALUES ('2b0260a7-20b0-4c44-a071-d24a4ca1a409', '2b0260a7-20b0-4c44-a071-d24a4ca1a409', '2b0260a7-20b0-4c44-a071-d24a4ca1a409',
        array['91c8162f-6cf3-42f8-98fa-21de3e367ec9', 'b777cadb-62dc-4cfc-9b62-e37995327d41']::uuid[]) ON CONFLICT(id) DO
UPDATE SET name=EXCLUDED.name, description=EXCLUDED.description, field_ids=EXCLUDED.field_ids;

INSERT INTO fields
  (id, key, description, agg_func, agg_weights)
VALUES ('91c8162f-6cf3-42f8-98fa-21de3e367ec9', 'normalized_reward', 'Primary raw scenario score.', NULL, NULL) ON CONFLICT(id) DO
UPDATE SET key =EXCLUDED.key, description=EXCLUDED.description, agg_func=EXCLUDED.agg_func, agg_weights=EXCLUDED.agg_weights;

INSERT INTO fields
  (id, key, description, agg_func, agg_weights)
VALUES ('b777cadb-62dc-4cfc-9b62-e37995327d41', 'percentage_complete', 'Secondary raw scenario score.', NULL, NULL) ON CONFLICT(id) DO
UPDATE SET key =EXCLUDED.key, description=EXCLUDED.description, agg_func=EXCLUDED.agg_func, agg_weights=EXCLUDED.agg_weights;

INSERT INTO scenarios
  (id, name, description, field_ids)
VALUES ('bae263a7-7fb7-4cf9-b794-19f23492b484', 'bae263a7-7fb7-4cf9-b794-19f23492b484', 'bae263a7-7fb7-4cf9-b794-19f23492b484',
        array['91c8162f-6cf3-42f8-98fa-21de3e367ec9', 'b777cadb-62dc-4cfc-9b62-e37995327d41']::uuid[]) ON CONFLICT(id) DO
UPDATE SET name=EXCLUDED.name, description=EXCLUDED.description, field_ids=EXCLUDED.field_ids;

INSERT INTO fields
  (id, key, description, agg_func, agg_weights)
VALUES ('91c8162f-6cf3-42f8-98fa-21de3e367ec9', 'normalized_reward', 'Primary raw scenario score.', NULL, NULL) ON CONFLICT(id) DO
UPDATE SET key =EXCLUDED.key, description=EXCLUDED.description, agg_func=EXCLUDED.agg_func, agg_weights=EXCLUDED.agg_weights;

INSERT INTO fields
  (id, key, description, agg_func, agg_weights)
VALUES ('b777cadb-62dc-4cfc-9b62-e37995327d41', 'percentage_complete', 'Secondary raw scenario score.', NULL, NULL) ON CONFLICT(id) DO
UPDATE SET key =EXCLUDED.key, description=EXCLUDED.description, agg_func=EXCLUDED.agg_func, agg_weights=EXCLUDED.agg_weights;

INSERT INTO scenarios
  (id, name, description, field_ids)
VALUES ('8ab26dbb-c2cb-4f13-a7bc-2910514e1470', '8ab26dbb-c2cb-4f13-a7bc-2910514e1470', '8ab26dbb-c2cb-4f13-a7bc-2910514e1470',
        array['91c8162f-6cf3-42f8-98fa-21de3e367ec9', 'b777cadb-62dc-4cfc-9b62-e37995327d41']::uuid[]) ON CONFLICT(id) DO
UPDATE SET name=EXCLUDED.name, description=EXCLUDED.description, field_ids=EXCLUDED.field_ids;

INSERT INTO fields
  (id, key, description, agg_func, agg_weights)
VALUES ('91c8162f-6cf3-42f8-98fa-21de3e367ec9', 'normalized_reward', 'Primary raw scenario score.', NULL, NULL) ON CONFLICT(id) DO
UPDATE SET key =EXCLUDED.key, description=EXCLUDED.description, agg_func=EXCLUDED.agg_func, agg_weights=EXCLUDED.agg_weights;

INSERT INTO fields
  (id, key, description, agg_func, agg_weights)
VALUES ('b777cadb-62dc-4cfc-9b62-e37995327d41', 'percentage_complete', 'Secondary raw scenario score.', NULL, NULL) ON CONFLICT(id) DO
UPDATE SET key =EXCLUDED.key, description=EXCLUDED.description, agg_func=EXCLUDED.agg_func, agg_weights=EXCLUDED.agg_weights;

INSERT INTO scenarios
  (id, name, description, field_ids)
VALUES ('84f7b0ab-d931-465d-8677-def5e0a21391', '84f7b0ab-d931-465d-8677-def5e0a21391', '84f7b0ab-d931-465d-8677-def5e0a21391',
        array['91c8162f-6cf3-42f8-98fa-21de3e367ec9', 'b777cadb-62dc-4cfc-9b62-e37995327d41']::uuid[]) ON CONFLICT(id) DO
UPDATE SET name=EXCLUDED.name, description=EXCLUDED.description, field_ids=EXCLUDED.field_ids;

INSERT INTO fields
  (id, key, description, agg_func, agg_weights)
VALUES ('91c8162f-6cf3-42f8-98fa-21de3e367ec9', 'normalized_reward', 'Primary raw scenario score.', NULL, NULL) ON CONFLICT(id) DO
UPDATE SET key =EXCLUDED.key, description=EXCLUDED.description, agg_func=EXCLUDED.agg_func, agg_weights=EXCLUDED.agg_weights;

INSERT INTO fields
  (id, key, description, agg_func, agg_weights)
VALUES ('b777cadb-62dc-4cfc-9b62-e37995327d41', 'percentage_complete', 'Secondary raw scenario score.', NULL, NULL) ON CONFLICT(id) DO
UPDATE SET key =EXCLUDED.key, description=EXCLUDED.description, agg_func=EXCLUDED.agg_func, agg_weights=EXCLUDED.agg_weights;

INSERT INTO scenarios
  (id, name, description, field_ids)
VALUES ('65eccf10-3c72-4e25-99e5-a181807ac686', '65eccf10-3c72-4e25-99e5-a181807ac686', '65eccf10-3c72-4e25-99e5-a181807ac686',
        array['91c8162f-6cf3-42f8-98fa-21de3e367ec9', 'b777cadb-62dc-4cfc-9b62-e37995327d41']::uuid[]) ON CONFLICT(id) DO
UPDATE SET name=EXCLUDED.name, description=EXCLUDED.description, field_ids=EXCLUDED.field_ids;

INSERT INTO fields
  (id, key, description, agg_func, agg_weights)
VALUES ('91c8162f-6cf3-42f8-98fa-21de3e367ec9', 'normalized_reward', 'Primary raw scenario score.', NULL, NULL) ON CONFLICT(id) DO
UPDATE SET key =EXCLUDED.key, description=EXCLUDED.description, agg_func=EXCLUDED.agg_func, agg_weights=EXCLUDED.agg_weights;

INSERT INTO fields
  (id, key, description, agg_func, agg_weights)
VALUES ('b777cadb-62dc-4cfc-9b62-e37995327d41', 'percentage_complete', 'Secondary raw scenario score.', NULL, NULL) ON CONFLICT(id) DO
UPDATE SET key =EXCLUDED.key, description=EXCLUDED.description, agg_func=EXCLUDED.agg_func, agg_weights=EXCLUDED.agg_weights;

INSERT INTO tests
  (id, name, description, field_ids, scenario_ids, loop, queue)
VALUES ('f47e2af9-df9b-412e-a2cc-a5a59c9a5436', 'Test 4', 'Level 4', array['978bc744-57dc-487e-9c38-4362a8b6f308',
        '36aa6284-ace4-463c-a79b-a9f7542a1c20']::uuid[], array['5d8a44a3-d836-4d3a-baba-d0a993bd5c41', 'dfabc3f8-8f12-4f25-9b15-3692744bbe63',
        '49711a78-cb64-475b-8c95-05c74720aefa', 'a99d8665-fa3e-4726-b22e-a56db674ad9d', '3f8e1c7a-92cc-4423-ae95-1c26b6d0a2a7']::uuid[], 'CLOSED',
        NULL) ON CONFLICT(id) DO
UPDATE SET name=EXCLUDED.name, description=EXCLUDED.description, field_ids=EXCLUDED.field_ids, scenario_ids=EXCLUDED.scenario_ids, loop=EXCLUDED.loop, queue=EXCLUDED.queue;

INSERT INTO fields
  (id, key, description, agg_func, agg_fields)
VALUES ('978bc744-57dc-487e-9c38-4362a8b6f308', 'normalized_reward', 'Primary test score (NANSUM of corresponding scenario scores)', 'NANSUM',
        '"normalized_reward"') ON CONFLICT(id) DO
UPDATE SET key =EXCLUDED.key, description=EXCLUDED.description, agg_func=EXCLUDED.agg_func, agg_fields=EXCLUDED.agg_fields;

INSERT INTO fields
  (id, key, description, agg_func, agg_fields)
VALUES ('36aa6284-ace4-463c-a79b-a9f7542a1c20', 'percentage_complete', 'Secondary test score (NANMEAN of corresponding scenario scores)', 'NANMEAN',
        '"percentage_complete"') ON CONFLICT(id) DO
UPDATE SET key =EXCLUDED.key, description=EXCLUDED.description, agg_func=EXCLUDED.agg_func, agg_fields=EXCLUDED.agg_fields;

INSERT INTO scenarios
  (id, name, description, field_ids)
VALUES ('5d8a44a3-d836-4d3a-baba-d0a993bd5c41', '5d8a44a3-d836-4d3a-baba-d0a993bd5c41', '5d8a44a3-d836-4d3a-baba-d0a993bd5c41',
        array['91c8162f-6cf3-42f8-98fa-21de3e367ec9', 'b777cadb-62dc-4cfc-9b62-e37995327d41']::uuid[]) ON CONFLICT(id) DO
UPDATE SET name=EXCLUDED.name, description=EXCLUDED.description, field_ids=EXCLUDED.field_ids;

INSERT INTO fields
  (id, key, description, agg_func, agg_weights)
VALUES ('91c8162f-6cf3-42f8-98fa-21de3e367ec9', 'normalized_reward', 'Primary raw scenario score.', NULL, NULL) ON CONFLICT(id) DO
UPDATE SET key =EXCLUDED.key, description=EXCLUDED.description, agg_func=EXCLUDED.agg_func, agg_weights=EXCLUDED.agg_weights;

INSERT INTO fields
  (id, key, description, agg_func, agg_weights)
VALUES ('b777cadb-62dc-4cfc-9b62-e37995327d41', 'percentage_complete', 'Secondary raw scenario score.', NULL, NULL) ON CONFLICT(id) DO
UPDATE SET key =EXCLUDED.key, description=EXCLUDED.description, agg_func=EXCLUDED.agg_func, agg_weights=EXCLUDED.agg_weights;

INSERT INTO scenarios
  (id, name, description, field_ids)
VALUES ('dfabc3f8-8f12-4f25-9b15-3692744bbe63', 'dfabc3f8-8f12-4f25-9b15-3692744bbe63', 'dfabc3f8-8f12-4f25-9b15-3692744bbe63',
        array['91c8162f-6cf3-42f8-98fa-21de3e367ec9', 'b777cadb-62dc-4cfc-9b62-e37995327d41']::uuid[]) ON CONFLICT(id) DO
UPDATE SET name=EXCLUDED.name, description=EXCLUDED.description, field_ids=EXCLUDED.field_ids;

INSERT INTO fields
  (id, key, description, agg_func, agg_weights)
VALUES ('91c8162f-6cf3-42f8-98fa-21de3e367ec9', 'normalized_reward', 'Primary raw scenario score.', NULL, NULL) ON CONFLICT(id) DO
UPDATE SET key =EXCLUDED.key, description=EXCLUDED.description, agg_func=EXCLUDED.agg_func, agg_weights=EXCLUDED.agg_weights;

INSERT INTO fields
  (id, key, description, agg_func, agg_weights)
VALUES ('b777cadb-62dc-4cfc-9b62-e37995327d41', 'percentage_complete', 'Secondary raw scenario score.', NULL, NULL) ON CONFLICT(id) DO
UPDATE SET key =EXCLUDED.key, description=EXCLUDED.description, agg_func=EXCLUDED.agg_func, agg_weights=EXCLUDED.agg_weights;

INSERT INTO scenarios
  (id, name, description, field_ids)
VALUES ('49711a78-cb64-475b-8c95-05c74720aefa', '49711a78-cb64-475b-8c95-05c74720aefa', '49711a78-cb64-475b-8c95-05c74720aefa',
        array['91c8162f-6cf3-42f8-98fa-21de3e367ec9', 'b777cadb-62dc-4cfc-9b62-e37995327d41']::uuid[]) ON CONFLICT(id) DO
UPDATE SET name=EXCLUDED.name, description=EXCLUDED.description, field_ids=EXCLUDED.field_ids;

INSERT INTO fields
  (id, key, description, agg_func, agg_weights)
VALUES ('91c8162f-6cf3-42f8-98fa-21de3e367ec9', 'normalized_reward', 'Primary raw scenario score.', NULL, NULL) ON CONFLICT(id) DO
UPDATE SET key =EXCLUDED.key, description=EXCLUDED.description, agg_func=EXCLUDED.agg_func, agg_weights=EXCLUDED.agg_weights;

INSERT INTO fields
  (id, key, description, agg_func, agg_weights)
VALUES ('b777cadb-62dc-4cfc-9b62-e37995327d41', 'percentage_complete', 'Secondary raw scenario score.', NULL, NULL) ON CONFLICT(id) DO
UPDATE SET key =EXCLUDED.key, description=EXCLUDED.description, agg_func=EXCLUDED.agg_func, agg_weights=EXCLUDED.agg_weights;

INSERT INTO scenarios
  (id, name, description, field_ids)
VALUES ('a99d8665-fa3e-4726-b22e-a56db674ad9d', 'a99d8665-fa3e-4726-b22e-a56db674ad9d', 'a99d8665-fa3e-4726-b22e-a56db674ad9d',
        array['91c8162f-6cf3-42f8-98fa-21de3e367ec9', 'b777cadb-62dc-4cfc-9b62-e37995327d41']::uuid[]) ON CONFLICT(id) DO
UPDATE SET name=EXCLUDED.name, description=EXCLUDED.description, field_ids=EXCLUDED.field_ids;

INSERT INTO fields
  (id, key, description, agg_func, agg_weights)
VALUES ('91c8162f-6cf3-42f8-98fa-21de3e367ec9', 'normalized_reward', 'Primary raw scenario score.', NULL, NULL) ON CONFLICT(id) DO
UPDATE SET key =EXCLUDED.key, description=EXCLUDED.description, agg_func=EXCLUDED.agg_func, agg_weights=EXCLUDED.agg_weights;

INSERT INTO fields
  (id, key, description, agg_func, agg_weights)
VALUES ('b777cadb-62dc-4cfc-9b62-e37995327d41', 'percentage_complete', 'Secondary raw scenario score.', NULL, NULL) ON CONFLICT(id) DO
UPDATE SET key =EXCLUDED.key, description=EXCLUDED.description, agg_func=EXCLUDED.agg_func, agg_weights=EXCLUDED.agg_weights;

INSERT INTO scenarios
  (id, name, description, field_ids)
VALUES ('3f8e1c7a-92cc-4423-ae95-1c26b6d0a2a7', '3f8e1c7a-92cc-4423-ae95-1c26b6d0a2a7', '3f8e1c7a-92cc-4423-ae95-1c26b6d0a2a7',
        array['91c8162f-6cf3-42f8-98fa-21de3e367ec9', 'b777cadb-62dc-4cfc-9b62-e37995327d41']::uuid[]) ON CONFLICT(id) DO
UPDATE SET name=EXCLUDED.name, description=EXCLUDED.description, field_ids=EXCLUDED.field_ids;

INSERT INTO fields
  (id, key, description, agg_func, agg_weights)
VALUES ('91c8162f-6cf3-42f8-98fa-21de3e367ec9', 'normalized_reward', 'Primary raw scenario score.', NULL, NULL) ON CONFLICT(id) DO
UPDATE SET key =EXCLUDED.key, description=EXCLUDED.description, agg_func=EXCLUDED.agg_func, agg_weights=EXCLUDED.agg_weights;

INSERT INTO fields
  (id, key, description, agg_func, agg_weights)
VALUES ('b777cadb-62dc-4cfc-9b62-e37995327d41', 'percentage_complete', 'Secondary raw scenario score.', NULL, NULL) ON CONFLICT(id) DO
UPDATE SET key =EXCLUDED.key, description=EXCLUDED.description, agg_func=EXCLUDED.agg_func, agg_weights=EXCLUDED.agg_weights;

INSERT INTO tests
  (id, name, description, field_ids, scenario_ids, loop, queue)
VALUES ('9fd40851-b990-4359-9076-d40089afa8f7', 'Test 5', 'Level 5', array['978bc744-57dc-487e-9c38-4362a8b6f308',
        '36aa6284-ace4-463c-a79b-a9f7542a1c20']::uuid[], array['59e3f342-75ad-4fe5-a15e-dbac41ebd654', 'c91a33e0-51c8-46fa-95f2-cec4fdc00b37',
        'bcad3bb7-5a65-43ba-b330-81517b242add', '7eb19ef5-f932-443e-af87-c30516684ca6', '9cd47ddf-d5a7-480d-933b-b921dea5a835']::uuid[], 'CLOSED',
        NULL) ON CONFLICT(id) DO
UPDATE SET name=EXCLUDED.name, description=EXCLUDED.description, field_ids=EXCLUDED.field_ids, scenario_ids=EXCLUDED.scenario_ids, loop=EXCLUDED.loop, queue=EXCLUDED.queue;

INSERT INTO fields
  (id, key, description, agg_func, agg_fields)
VALUES ('978bc744-57dc-487e-9c38-4362a8b6f308', 'normalized_reward', 'Primary test score (NANSUM of corresponding scenario scores)', 'NANSUM',
        '"normalized_reward"') ON CONFLICT(id) DO
UPDATE SET key =EXCLUDED.key, description=EXCLUDED.description, agg_func=EXCLUDED.agg_func, agg_fields=EXCLUDED.agg_fields;

INSERT INTO fields
  (id, key, description, agg_func, agg_fields)
VALUES ('36aa6284-ace4-463c-a79b-a9f7542a1c20', 'percentage_complete', 'Secondary test score (NANMEAN of corresponding scenario scores)', 'NANMEAN',
        '"percentage_complete"') ON CONFLICT(id) DO
UPDATE SET key =EXCLUDED.key, description=EXCLUDED.description, agg_func=EXCLUDED.agg_func, agg_fields=EXCLUDED.agg_fields;

INSERT INTO scenarios
  (id, name, description, field_ids)
VALUES ('59e3f342-75ad-4fe5-a15e-dbac41ebd654', '59e3f342-75ad-4fe5-a15e-dbac41ebd654', '59e3f342-75ad-4fe5-a15e-dbac41ebd654',
        array['91c8162f-6cf3-42f8-98fa-21de3e367ec9', 'b777cadb-62dc-4cfc-9b62-e37995327d41']::uuid[]) ON CONFLICT(id) DO
UPDATE SET name=EXCLUDED.name, description=EXCLUDED.description, field_ids=EXCLUDED.field_ids;

INSERT INTO fields
  (id, key, description, agg_func, agg_weights)
VALUES ('91c8162f-6cf3-42f8-98fa-21de3e367ec9', 'normalized_reward', 'Primary raw scenario score.', NULL, NULL) ON CONFLICT(id) DO
UPDATE SET key =EXCLUDED.key, description=EXCLUDED.description, agg_func=EXCLUDED.agg_func, agg_weights=EXCLUDED.agg_weights;

INSERT INTO fields
  (id, key, description, agg_func, agg_weights)
VALUES ('b777cadb-62dc-4cfc-9b62-e37995327d41', 'percentage_complete', 'Secondary raw scenario score.', NULL, NULL) ON CONFLICT(id) DO
UPDATE SET key =EXCLUDED.key, description=EXCLUDED.description, agg_func=EXCLUDED.agg_func, agg_weights=EXCLUDED.agg_weights;

INSERT INTO scenarios
  (id, name, description, field_ids)
VALUES ('c91a33e0-51c8-46fa-95f2-cec4fdc00b37', 'c91a33e0-51c8-46fa-95f2-cec4fdc00b37', 'c91a33e0-51c8-46fa-95f2-cec4fdc00b37',
        array['91c8162f-6cf3-42f8-98fa-21de3e367ec9', 'b777cadb-62dc-4cfc-9b62-e37995327d41']::uuid[]) ON CONFLICT(id) DO
UPDATE SET name=EXCLUDED.name, description=EXCLUDED.description, field_ids=EXCLUDED.field_ids;

INSERT INTO fields
  (id, key, description, agg_func, agg_weights)
VALUES ('91c8162f-6cf3-42f8-98fa-21de3e367ec9', 'normalized_reward', 'Primary raw scenario score.', NULL, NULL) ON CONFLICT(id) DO
UPDATE SET key =EXCLUDED.key, description=EXCLUDED.description, agg_func=EXCLUDED.agg_func, agg_weights=EXCLUDED.agg_weights;

INSERT INTO fields
  (id, key, description, agg_func, agg_weights)
VALUES ('b777cadb-62dc-4cfc-9b62-e37995327d41', 'percentage_complete', 'Secondary raw scenario score.', NULL, NULL) ON CONFLICT(id) DO
UPDATE SET key =EXCLUDED.key, description=EXCLUDED.description, agg_func=EXCLUDED.agg_func, agg_weights=EXCLUDED.agg_weights;

INSERT INTO scenarios
  (id, name, description, field_ids)
VALUES ('bcad3bb7-5a65-43ba-b330-81517b242add', 'bcad3bb7-5a65-43ba-b330-81517b242add', 'bcad3bb7-5a65-43ba-b330-81517b242add',
        array['91c8162f-6cf3-42f8-98fa-21de3e367ec9', 'b777cadb-62dc-4cfc-9b62-e37995327d41']::uuid[]) ON CONFLICT(id) DO
UPDATE SET name=EXCLUDED.name, description=EXCLUDED.description, field_ids=EXCLUDED.field_ids;

INSERT INTO fields
  (id, key, description, agg_func, agg_weights)
VALUES ('91c8162f-6cf3-42f8-98fa-21de3e367ec9', 'normalized_reward', 'Primary raw scenario score.', NULL, NULL) ON CONFLICT(id) DO
UPDATE SET key =EXCLUDED.key, description=EXCLUDED.description, agg_func=EXCLUDED.agg_func, agg_weights=EXCLUDED.agg_weights;

INSERT INTO fields
  (id, key, description, agg_func, agg_weights)
VALUES ('b777cadb-62dc-4cfc-9b62-e37995327d41', 'percentage_complete', 'Secondary raw scenario score.', NULL, NULL) ON CONFLICT(id) DO
UPDATE SET key =EXCLUDED.key, description=EXCLUDED.description, agg_func=EXCLUDED.agg_func, agg_weights=EXCLUDED.agg_weights;

INSERT INTO scenarios
  (id, name, description, field_ids)
VALUES ('7eb19ef5-f932-443e-af87-c30516684ca6', '7eb19ef5-f932-443e-af87-c30516684ca6', '7eb19ef5-f932-443e-af87-c30516684ca6',
        array['91c8162f-6cf3-42f8-98fa-21de3e367ec9', 'b777cadb-62dc-4cfc-9b62-e37995327d41']::uuid[]) ON CONFLICT(id) DO
UPDATE SET name=EXCLUDED.name, description=EXCLUDED.description, field_ids=EXCLUDED.field_ids;

INSERT INTO fields
  (id, key, description, agg_func, agg_weights)
VALUES ('91c8162f-6cf3-42f8-98fa-21de3e367ec9', 'normalized_reward', 'Primary raw scenario score.', NULL, NULL) ON CONFLICT(id) DO
UPDATE SET key =EXCLUDED.key, description=EXCLUDED.description, agg_func=EXCLUDED.agg_func, agg_weights=EXCLUDED.agg_weights;

INSERT INTO fields
  (id, key, description, agg_func, agg_weights)
VALUES ('b777cadb-62dc-4cfc-9b62-e37995327d41', 'percentage_complete', 'Secondary raw scenario score.', NULL, NULL) ON CONFLICT(id) DO
UPDATE SET key =EXCLUDED.key, description=EXCLUDED.description, agg_func=EXCLUDED.agg_func, agg_weights=EXCLUDED.agg_weights;

INSERT INTO scenarios
  (id, name, description, field_ids)
VALUES ('9cd47ddf-d5a7-480d-933b-b921dea5a835', '9cd47ddf-d5a7-480d-933b-b921dea5a835', '9cd47ddf-d5a7-480d-933b-b921dea5a835',
        array['91c8162f-6cf3-42f8-98fa-21de3e367ec9', 'b777cadb-62dc-4cfc-9b62-e37995327d41']::uuid[]) ON CONFLICT(id) DO
UPDATE SET name=EXCLUDED.name, description=EXCLUDED.description, field_ids=EXCLUDED.field_ids;

INSERT INTO fields
  (id, key, description, agg_func, agg_weights)
VALUES ('91c8162f-6cf3-42f8-98fa-21de3e367ec9', 'normalized_reward', 'Primary raw scenario score.', NULL, NULL) ON CONFLICT(id) DO
UPDATE SET key =EXCLUDED.key, description=EXCLUDED.description, agg_func=EXCLUDED.agg_func, agg_weights=EXCLUDED.agg_weights;

INSERT INTO fields
  (id, key, description, agg_func, agg_weights)
VALUES ('b777cadb-62dc-4cfc-9b62-e37995327d41', 'percentage_complete', 'Secondary raw scenario score.', NULL, NULL) ON CONFLICT(id) DO
UPDATE SET key =EXCLUDED.key, description=EXCLUDED.description, agg_func=EXCLUDED.agg_func, agg_weights=EXCLUDED.agg_weights;

INSERT INTO tests
  (id, name, description, field_ids, scenario_ids, loop, queue)
VALUES ('1f856e14-556d-410c-a281-74f74d213725', 'Test 6', 'Level 6', array['978bc744-57dc-487e-9c38-4362a8b6f308',
        '36aa6284-ace4-463c-a79b-a9f7542a1c20']::uuid[], array['f4cc110b-ec79-4064-9d7b-2fd95cae059b', 'eb722f2c-befa-4302-945c-23554a3ae718',
        '50787ae1-f8ec-4280-8557-006f247d1717', '987f0125-d974-445f-b87c-19a0b987179a', '00b9ef59-0451-457d-8b4d-7dc651c6fd80']::uuid[], 'CLOSED',
        NULL) ON CONFLICT(id) DO
UPDATE SET name=EXCLUDED.name, description=EXCLUDED.description, field_ids=EXCLUDED.field_ids, scenario_ids=EXCLUDED.scenario_ids, loop=EXCLUDED.loop, queue=EXCLUDED.queue;

INSERT INTO fields
  (id, key, description, agg_func, agg_fields)
VALUES ('978bc744-57dc-487e-9c38-4362a8b6f308', 'normalized_reward', 'Primary test score (NANSUM of corresponding scenario scores)', 'NANSUM',
        '"normalized_reward"') ON CONFLICT(id) DO
UPDATE SET key =EXCLUDED.key, description=EXCLUDED.description, agg_func=EXCLUDED.agg_func, agg_fields=EXCLUDED.agg_fields;

INSERT INTO fields
  (id, key, description, agg_func, agg_fields)
VALUES ('36aa6284-ace4-463c-a79b-a9f7542a1c20', 'percentage_complete', 'Secondary test score (NANMEAN of corresponding scenario scores)', 'NANMEAN',
        '"percentage_complete"') ON CONFLICT(id) DO
UPDATE SET key =EXCLUDED.key, description=EXCLUDED.description, agg_func=EXCLUDED.agg_func, agg_fields=EXCLUDED.agg_fields;

INSERT INTO scenarios
  (id, name, description, field_ids)
VALUES ('f4cc110b-ec79-4064-9d7b-2fd95cae059b', 'f4cc110b-ec79-4064-9d7b-2fd95cae059b', 'f4cc110b-ec79-4064-9d7b-2fd95cae059b',
        array['91c8162f-6cf3-42f8-98fa-21de3e367ec9', 'b777cadb-62dc-4cfc-9b62-e37995327d41']::uuid[]) ON CONFLICT(id) DO
UPDATE SET name=EXCLUDED.name, description=EXCLUDED.description, field_ids=EXCLUDED.field_ids;

INSERT INTO fields
  (id, key, description, agg_func, agg_weights)
VALUES ('91c8162f-6cf3-42f8-98fa-21de3e367ec9', 'normalized_reward', 'Primary raw scenario score.', NULL, NULL) ON CONFLICT(id) DO
UPDATE SET key =EXCLUDED.key, description=EXCLUDED.description, agg_func=EXCLUDED.agg_func, agg_weights=EXCLUDED.agg_weights;

INSERT INTO fields
  (id, key, description, agg_func, agg_weights)
VALUES ('b777cadb-62dc-4cfc-9b62-e37995327d41', 'percentage_complete', 'Secondary raw scenario score.', NULL, NULL) ON CONFLICT(id) DO
UPDATE SET key =EXCLUDED.key, description=EXCLUDED.description, agg_func=EXCLUDED.agg_func, agg_weights=EXCLUDED.agg_weights;

INSERT INTO scenarios
  (id, name, description, field_ids)
VALUES ('eb722f2c-befa-4302-945c-23554a3ae718', 'eb722f2c-befa-4302-945c-23554a3ae718', 'eb722f2c-befa-4302-945c-23554a3ae718',
        array['91c8162f-6cf3-42f8-98fa-21de3e367ec9', 'b777cadb-62dc-4cfc-9b62-e37995327d41']::uuid[]) ON CONFLICT(id) DO
UPDATE SET name=EXCLUDED.name, description=EXCLUDED.description, field_ids=EXCLUDED.field_ids;

INSERT INTO fields
  (id, key, description, agg_func, agg_weights)
VALUES ('91c8162f-6cf3-42f8-98fa-21de3e367ec9', 'normalized_reward', 'Primary raw scenario score.', NULL, NULL) ON CONFLICT(id) DO
UPDATE SET key =EXCLUDED.key, description=EXCLUDED.description, agg_func=EXCLUDED.agg_func, agg_weights=EXCLUDED.agg_weights;

INSERT INTO fields
  (id, key, description, agg_func, agg_weights)
VALUES ('b777cadb-62dc-4cfc-9b62-e37995327d41', 'percentage_complete', 'Secondary raw scenario score.', NULL, NULL) ON CONFLICT(id) DO
UPDATE SET key =EXCLUDED.key, description=EXCLUDED.description, agg_func=EXCLUDED.agg_func, agg_weights=EXCLUDED.agg_weights;

INSERT INTO scenarios
  (id, name, description, field_ids)
VALUES ('50787ae1-f8ec-4280-8557-006f247d1717', '50787ae1-f8ec-4280-8557-006f247d1717', '50787ae1-f8ec-4280-8557-006f247d1717',
        array['91c8162f-6cf3-42f8-98fa-21de3e367ec9', 'b777cadb-62dc-4cfc-9b62-e37995327d41']::uuid[]) ON CONFLICT(id) DO
UPDATE SET name=EXCLUDED.name, description=EXCLUDED.description, field_ids=EXCLUDED.field_ids;

INSERT INTO fields
  (id, key, description, agg_func, agg_weights)
VALUES ('91c8162f-6cf3-42f8-98fa-21de3e367ec9', 'normalized_reward', 'Primary raw scenario score.', NULL, NULL) ON CONFLICT(id) DO
UPDATE SET key =EXCLUDED.key, description=EXCLUDED.description, agg_func=EXCLUDED.agg_func, agg_weights=EXCLUDED.agg_weights;

INSERT INTO fields
  (id, key, description, agg_func, agg_weights)
VALUES ('b777cadb-62dc-4cfc-9b62-e37995327d41', 'percentage_complete', 'Secondary raw scenario score.', NULL, NULL) ON CONFLICT(id) DO
UPDATE SET key =EXCLUDED.key, description=EXCLUDED.description, agg_func=EXCLUDED.agg_func, agg_weights=EXCLUDED.agg_weights;

INSERT INTO scenarios
  (id, name, description, field_ids)
VALUES ('987f0125-d974-445f-b87c-19a0b987179a', '987f0125-d974-445f-b87c-19a0b987179a', '987f0125-d974-445f-b87c-19a0b987179a',
        array['91c8162f-6cf3-42f8-98fa-21de3e367ec9', 'b777cadb-62dc-4cfc-9b62-e37995327d41']::uuid[]) ON CONFLICT(id) DO
UPDATE SET name=EXCLUDED.name, description=EXCLUDED.description, field_ids=EXCLUDED.field_ids;

INSERT INTO fields
  (id, key, description, agg_func, agg_weights)
VALUES ('91c8162f-6cf3-42f8-98fa-21de3e367ec9', 'normalized_reward', 'Primary raw scenario score.', NULL, NULL) ON CONFLICT(id) DO
UPDATE SET key =EXCLUDED.key, description=EXCLUDED.description, agg_func=EXCLUDED.agg_func, agg_weights=EXCLUDED.agg_weights;

INSERT INTO fields
  (id, key, description, agg_func, agg_weights)
VALUES ('b777cadb-62dc-4cfc-9b62-e37995327d41', 'percentage_complete', 'Secondary raw scenario score.', NULL, NULL) ON CONFLICT(id) DO
UPDATE SET key =EXCLUDED.key, description=EXCLUDED.description, agg_func=EXCLUDED.agg_func, agg_weights=EXCLUDED.agg_weights;

INSERT INTO scenarios
  (id, name, description, field_ids)
VALUES ('00b9ef59-0451-457d-8b4d-7dc651c6fd80', '00b9ef59-0451-457d-8b4d-7dc651c6fd80', '00b9ef59-0451-457d-8b4d-7dc651c6fd80',
        array['91c8162f-6cf3-42f8-98fa-21de3e367ec9', 'b777cadb-62dc-4cfc-9b62-e37995327d41']::uuid[]) ON CONFLICT(id) DO
UPDATE SET name=EXCLUDED.name, description=EXCLUDED.description, field_ids=EXCLUDED.field_ids;

INSERT INTO fields
  (id, key, description, agg_func, agg_weights)
VALUES ('91c8162f-6cf3-42f8-98fa-21de3e367ec9', 'normalized_reward', 'Primary raw scenario score.', NULL, NULL) ON CONFLICT(id) DO
UPDATE SET key =EXCLUDED.key, description=EXCLUDED.description, agg_func=EXCLUDED.agg_func, agg_weights=EXCLUDED.agg_weights;

INSERT INTO fields
  (id, key, description, agg_func, agg_weights)
VALUES ('b777cadb-62dc-4cfc-9b62-e37995327d41', 'percentage_complete', 'Secondary raw scenario score.', NULL, NULL) ON CONFLICT(id) DO
UPDATE SET key =EXCLUDED.key, description=EXCLUDED.description, agg_func=EXCLUDED.agg_func, agg_weights=EXCLUDED.agg_weights;

