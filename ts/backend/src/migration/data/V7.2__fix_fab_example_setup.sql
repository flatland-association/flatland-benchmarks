--
-- prior to V7, campaign fields were defined in fields - reroute in affected
-- benchmarks and add field definition for submission score
--

UPDATE benchmark_groups
SET
  setup = 'BENCHMARK'
WHERE
  id = '02d6cb3c-b83c-459c-9f32-4a63fa128ce7';