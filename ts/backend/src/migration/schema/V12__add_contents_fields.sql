--
-- Add free form* contents field to suites and benchmarks.
-- *) Actual interface described in ts, see:
-- ts\common\interfaces.ts
--
ALTER TABLE suites
  ADD COLUMN contents json;

ALTER TABLE benchmark_definitions
  ADD COLUMN contents json;
