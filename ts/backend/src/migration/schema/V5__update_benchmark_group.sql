--
-- For consistency, use top down linking in benchmark_groups too (i.e. an array of benchmark uuids).
-- Add display name and description to groups.
-- Drop and re-create for nicer results (no hanging constraints, consistent column order).
--

DROP TABLE IF EXISTS benchmark_groups;

DROP TABLE IF EXISTS benchmark_group_members;

CREATE TABLE IF NOT EXISTS benchmark_groups (
  id uuid PRIMARY KEY DEFAULT uuid_generate_v4(),
  name varchar(64) NOT NULL,
  description text NOT NULL,
  setup benchmark_group_setup NOT NULL,
  benchmark_definition_ids uuid[] NOT NULL DEFAULT array[]::uuid[]
);
