-- insert submission without score for results controller integration test
INSERT INTO submissions
  (id, benchmark_id, test_ids, name, description, submission_data_url, submitted_at, submitted_by_username, submitted_by, status, published)
VALUES
  ('4c5bd494-c5c8-4efc-9553-5a28794c5e5f', '255fb1e8-af57-45a0-97dc-ecc3e6721b4f', array['99f5a8f8-38d9-4a8c-9630-4789b0225ec0']::uuid[], 'Integration Test Submission', 'Submission for integration test of results controller', '', current_timestamp, 'Test User', '00000000-0000-0000-0000-000000000001', 'SUCCESS', false);