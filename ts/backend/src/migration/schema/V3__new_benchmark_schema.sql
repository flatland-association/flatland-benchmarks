--
-- New definition schemas
--

--
-- known aggregation functions for field definitions
--
CREATE TYPE agg_func AS ENUM ('SUM', 'NANSUM', 'MEAN', 'NANMEAN', 'MEADIAN', 'NANMEDIAN');

--
-- field / KPI
--
CREATE TABLE IF NOT EXISTS field_definitions (
  id uuid PRIMARY KEY DEFAULT uuid_generate_v4(),
  name varchar(32) NOT NULL,
  description text NOT NULL,
  agg_func agg_func,
  agg_fields json,
  agg_weights double precision[],
  agg_lateral boolean 
);

--
-- scenarios
--
CREATE TABLE IF NOT EXISTS scenario_definitions (
  id uuid PRIMARY KEY DEFAULT uuid_generate_v4(),
  name varchar(64) NOT NULL,
  description text NOT NULL,
  field_definitions uuid[] NOT NULL DEFAULT array[]::uuid[]
);

--
-- tests
--
CREATE TABLE IF NOT EXISTS test_definitions (
  id uuid PRIMARY KEY DEFAULT uuid_generate_v4(),
  name varchar(64) NOT NULL,
  description text NOT NULL,
  field_definitions uuid[] NOT NULL DEFAULT array[]::uuid[],
  scenario_definitions uuid[] NOT NULL DEFAULT array[]::uuid[]
);

--
-- benchmarks
--
CREATE TABLE IF NOT EXISTS benchmark_definitions (
  id uuid PRIMARY KEY DEFAULT uuid_generate_v4(),
  name varchar(64) NOT NULL,
  description text NOT NULL,
  field_definitions uuid[] NOT NULL DEFAULT array[]::uuid[],
  test_definitions uuid[] NOT NULL DEFAULT array[]::uuid[]
);

--
-- known types of benchmark groups
--
CREATE TYPE benchmark_group_setup AS ENUM ('BENCHMARK', 'COMPETITION', 'CAMPAIGN');

--
-- benchmark groups
--
CREATE TABLE IF NOT EXISTS benchmark_groups (
  id uuid PRIMARY KEY DEFAULT uuid_generate_v4(),
  setup benchmark_group_setup NOT NULL
);

--
-- benchmark group members
--
CREATE TABLE IF NOT EXISTS benchmark_group_members (
  benchmark_group uuid,
  benchmark_definition uuid
);

ALTER TABLE benchmark_group_members
  ADD PRIMARY KEY (benchmark_group, benchmark_definition);

CREATE INDEX IF NOT EXISTS benchmark_group_members_group_idx ON benchmark_group_members (benchmark_group);

CREATE INDEX IF NOT EXISTS benchmark_group_members_benchmark_idx ON benchmark_group_members (benchmark_definition);

--
-- Update existing schemas for new definitions
--

CREATE TYPE submission_status AS ENUM ('SUBMITTED', 'RUNNING', 'SUCCESS', 'FAILURE');

--
-- submissions
--
ALTER TABLE submissions
  -- drop integer based ids and refs
  DROP COLUMN id,
  DROP COLUMN benchmark,
  DROP COLUMN tests,
  -- add new uuid based refs
  ADD COLUMN benchmark_definition uuid NOT NULL,
  ADD COLUMN test_definitions uuid[] NOT NULL,
  -- misc new fields
  ADD COLUMN description text,
  ADD COLUMN status submission_status NOT NULL DEFAULT 'SUBMITTED',
  ADD COLUMN published boolean NOT NULL DEFAULT FALSE;

ALTER TABLE submissions
  -- rename uuid column to id column (distinction not necessary any longer)
  RENAME COLUMN uuid TO id;

--
-- results
--
DROP TABLE results;

CREATE TABLE results (
  scenario_definition uuid NOT NULL,
  submission uuid NOT NULL,
  key varchar(32) NOT NULL,
  value double precision
);

ALTER TABLE results
  ADD PRIMARY KEY (scenario_definition, submission);
