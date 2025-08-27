--
-- make name column longer
--

ALTER TABLE field_definitions ALTER COLUMN key TYPE VARCHAR(128);
ALTER TABLE scenario_definitions ALTER COLUMN name TYPE VARCHAR(128);
ALTER TABLE test_definitions ALTER COLUMN name TYPE VARCHAR(128);
ALTER TABLE benchmark_definitions ALTER COLUMN name TYPE VARCHAR(128);
