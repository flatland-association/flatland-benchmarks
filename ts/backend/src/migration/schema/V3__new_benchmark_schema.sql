--
-- New definition schemas
--

--
-- known aggregation functions for field definitions
--
CREATE TYPE agg_func AS ENUM ('SUM', 'NANSUM', 'MEAN', 'NANMEAN', 'MEADIAN', 'NANMEDIAN');

--
-- field
--
CREATE TABLE IF NOT EXISTS field_definitions (
  id uuid PRIMARY KEY DEFAULT uuid_generate_v4(),
  key varchar(32) NOT NULL,
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
  field_definition_ids uuid[] NOT NULL DEFAULT array[]::uuid[]
);

--
-- tests
--
CREATE TABLE IF NOT EXISTS test_definitions (
  id uuid PRIMARY KEY DEFAULT uuid_generate_v4(),
  name varchar(64) NOT NULL,
  description text NOT NULL,
  field_definition_ids uuid[] NOT NULL DEFAULT array[]::uuid[],
  scenario_definition_ids uuid[] NOT NULL DEFAULT array[]::uuid[]
);

--
-- benchmarks
--
CREATE TABLE IF NOT EXISTS benchmark_definitions (
  id uuid PRIMARY KEY DEFAULT uuid_generate_v4(),
  name varchar(64) NOT NULL,
  description text NOT NULL,
  field_definition_ids uuid[] NOT NULL DEFAULT array[]::uuid[],
  test_definition_ids uuid[] NOT NULL DEFAULT array[]::uuid[],
  docker_image varchar(2048),
  evaluator_data json
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
  benchmark_group_id uuid,
  benchmark_definition_id uuid
);

ALTER TABLE benchmark_group_members
  ADD PRIMARY KEY (benchmark_group_id, benchmark_definition_id);

CREATE INDEX IF NOT EXISTS benchmark_group_members_group_idx ON benchmark_group_members (benchmark_group_id);

CREATE INDEX IF NOT EXISTS benchmark_group_members_benchmark_idx ON benchmark_group_members (benchmark_definition_id);

--
-- Update existing schemas for new definitions
--

CREATE TYPE submission_status AS ENUM ('SUBMITTED', 'RUNNING', 'SUCCESS', 'FAILURE');

--
-- submissions
--
DROP TABLE submissions;

CREATE TABLE submissions (
  id uuid PRIMARY KEY DEFAULT uuid_generate_v4(),
  benchmark_definition_id uuid NOT NULL,
  test_definition_ids uuid[] NOT NULL,
  name varchar(64) NOT NULL,
  description text,
  submission_data_url varchar(2048) NOT NULL,
  code_repository varchar(2048),
  submitted_at timestamp without time zone,
  submitted_by uuid,
  submitted_by_username varchar(64),
  status submission_status NOT NULL DEFAULT 'SUBMITTED',
  published boolean NOT NULL DEFAULT FALSE
);

--
-- results
--
DROP TABLE results;

CREATE TABLE results (
  scenario_definition_id uuid NOT NULL,
  test_definition_id uuid NOT NULL,
  submission_id uuid NOT NULL,
  key varchar(32) NOT NULL,
  value double precision
);

ALTER TABLE results
  ADD PRIMARY KEY (scenario_definition_id, test_definition_id, submission_id, key);
