--
-- add campaign fields to benchmark_definitions
--
ALTER TABLE benchmark_definitions
  ADD COLUMN campaign_field_ids uuid[] NOT NULL DEFAULT array[]::uuid[];
