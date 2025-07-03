

ALTER TABLE benchmark_definitions RENAME COLUMN test_definition_ids TO test_ids;
ALTER TABLE submissions RENAME COLUMN test_definition_ids TO test_ids;
ALTER TABLE submissions RENAME COLUMN benchmark_definition_id TO benchmark_id;
