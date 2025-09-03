-- generated with gen_flatland3_benchmarks_sql.py

INSERT INTO field_definitions
  (id, key, description, agg_func, agg_weights, agg_fields)
  VALUES
  ('5ee7e465-5d28-4207-9a70-9d74698caad4', 'normalized_reward', 'Scenario score (raw primary values)', NULL, NULL, NULL),
  ('855b50f1-257a-4077-b4b9-a92300dc37bd', 'sum_normalized_reward', 'Test score (NANSUM of primary scenario scores)', 'NANSUM', NULL, '"normalized_reward"'),
  ('e9680c38-4e79-4950-a555-469b156d9ca2', 'sum_normalized_reward', 'Benchmark score (NANSUM of primary test scores)', 'NANSUM', NULL, '"sum_normalized_reward"'),
  ('ca65bb4c-79b0-4603-a642-81eba7a9cebb', 'percentage_complete', 'Scenario score (raw values)', NULL, NULL, NULL),
  ('2a5acb41-bb10-45d6-86de-fb3181048e1a', 'mean_percentage_complete', 'Test score (MEAN of scenario scores)', 'NANMEAN', NULL, '"percentage_complete"'),
  ('0128f4b5-71b2-4ee4-b6db-f566a7e88e62', 'mean_percentage_complete', 'Benchmark score (NANMEAN of test scores)', 'NANMEAN', NULL, '"mean_percentage_complete"');


INSERT INTO scenario_definitions
  (id, name, description, field_ids)
  VALUES
  ('d99f4d35-aec5-41c1-a7b0-64f78b35d7ef', 'Test 0 Level 0', 'Test 0 Level 0', array['5ee7e465-5d28-4207-9a70-9d74698caad4', 'ca65bb4c-79b0-4603-a642-81eba7a9cebb']::uuid[]),
  ('04d618b8-84df-406b-b803-d516c7425537', 'Test 0 Level 1', 'Test 0 Level 1', array['5ee7e465-5d28-4207-9a70-9d74698caad4', 'ca65bb4c-79b0-4603-a642-81eba7a9cebb']::uuid[]),
  ('6f3ad83c-3312-4ab3-9740-cbce80feea91', 'Test 1 Level 0', 'Test 1 Level 0', array['5ee7e465-5d28-4207-9a70-9d74698caad4', 'ca65bb4c-79b0-4603-a642-81eba7a9cebb']::uuid[]),
  ('f954a860-e963-431e-a09d-5b1040948f2d', 'Test 1 Level 1', 'Test 1 Level 1', array['5ee7e465-5d28-4207-9a70-9d74698caad4', 'ca65bb4c-79b0-4603-a642-81eba7a9cebb']::uuid[]),
  ('f92bfe0c-5347-4d89-bc17-b6f86d514ef8', 'Test 1 Level 2', 'Test 1 Level 2', array['5ee7e465-5d28-4207-9a70-9d74698caad4', 'ca65bb4c-79b0-4603-a642-81eba7a9cebb']::uuid[]);
INSERT INTO test_definitions
  (id, name, description, field_ids, scenario_ids, loop)
VALUES
  ('4ecdb9f4-e2ff-41ff-9857-abe649c19c50', 'Test 0', '5 agents, 25x25, 2 cities, 2 seeds', array['855b50f1-257a-4077-b4b9-a92300dc37bd', '2a5acb41-bb10-45d6-86de-fb3181048e1a']::uuid[], array['d99f4d35-aec5-41c1-a7b0-64f78b35d7ef', '04d618b8-84df-406b-b803-d516c7425537', '942ef955-514f-4358-b8ef-40da4807120f']::uuid[], 'CLOSED'),
  ('5206f2ee-d0a9-405b-8da3-93625e169811', 'Test 1', '2 agents, 30x30, 3 cities, 3 seeds', array['855b50f1-257a-4077-b4b9-a92300dc37bd', '2a5acb41-bb10-45d6-86de-fb3181048e1a']::uuid[], array['6f3ad83c-3312-4ab3-9740-cbce80feea91', 'f954a860-e963-431e-a09d-5b1040948f2d', 'f92bfe0c-5347-4d89-bc17-b6f86d514ef8']::uuid[], 'CLOSED');
INSERT INTO benchmark_definitions
  (id, name, description, field_ids, test_ids)
VALUES
  ('f669fb8d-80ac-4ba7-8875-0a33ed5d30b9', 'Round 1', 'Round 1', array['e9680c38-4e79-4950-a555-469b156d9ca2', '0128f4b5-71b2-4ee4-b6db-f566a7e88e62']::uuid[], array['4ecdb9f4-e2ff-41ff-9857-abe649c19c50', '5206f2ee-d0a9-405b-8da3-93625e169811']::uuid[]);

-- currently use CAMPAIGN as BENCHMARK seems not to work yet in frontend
-- see https://github.com/flatland-association/flatland-benchmarks/issues/347
-- fixed V7.2__fix_fab_example_setup.sql
INSERT INTO benchmark_groups
  (id, setup, name, description, benchmark_ids)
VALUES
  ('02d6cb3c-b83c-459c-9f32-4a63fa128ce7', 'CAMPAIGN', 'Flatland 3 Benchmarks', 'The Flatland 3 Benchmarks.', array['f669fb8d-80ac-4ba7-8875-0a33ed5d30b9']::uuid[]);
