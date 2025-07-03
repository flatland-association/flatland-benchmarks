
ALTER TABLE benchmark_groups RENAME COLUMN benchmark_definition_ids TO benchmark_ids;

ALTER TABLE benchmark_definitions RENAME COLUMN test_definition_ids TO test_ids;
ALTER TABLE benchmark_definitions RENAME COLUMN field_definition_ids TO field_ids;

ALTER TABLE test_definitions RENAME COLUMN field_definition_ids TO field_ids;
ALTER TABLE test_definitions RENAME COLUMN scenario_definition_ids TO scenario_ids;

ALTER TABLE scenario_definitions RENAME COLUMN field_definition_ids TO field_ids;


ALTER TABLE submissions RENAME COLUMN test_definition_ids TO test_ids;
ALTER TABLE submissions RENAME COLUMN benchmark_definition_id TO benchmark_id;

ALTER TABLE results RENAME COLUMN scenario_definition_id TO scenario_id;
ALTER TABLE results RENAME COLUMN test_definition_id TO test_id;
