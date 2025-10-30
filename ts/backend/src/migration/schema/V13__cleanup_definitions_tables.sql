--
-- rename old (no longer used) tables to _deprecated
--
ALTER TABLE benchmarks RENAME TO benchmarks_deprecated;

ALTER TABLE tests RENAME TO tests_deprecated;

--
-- rename current tables - drop _definitions suffix
--
ALTER TABLE benchmark_definitions RENAME TO benchmarks;

ALTER TABLE field_definitions RENAME TO fields;

ALTER TABLE scenario_definitions RENAME TO scenarios;

ALTER TABLE test_definitions RENAME TO tests;
