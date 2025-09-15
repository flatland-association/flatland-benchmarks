--
-- change setup name BENCHMARK to DEFAULT as per
-- https://github.com/flatland-association/flatland-benchmarks/issues/402
-- (this operation updates existing items too)
--
ALTER TYPE benchmark_group_setup RENAME VALUE 'BENCHMARK' TO 'DEFAULT';

--
-- change benchmark_group to suite as per
-- https://github.com/flatland-association/flatland-benchmarks/issues/402
--
ALTER TYPE benchmark_group_setup RENAME TO suite_setup;

ALTER TABLE benchmark_groups RENAME TO suites;
