CREATE EXTENSION IF NOT EXISTS "uuid-ossp";

--
-- benchmarks
--
CREATE TABLE IF NOT EXISTS benchmarks (
  id integer PRIMARY KEY GENERATED BY DEFAULT AS IDENTITY,
  name varchar(64) NOT NULL,
  description text NOT NULL,
  docker_image varchar(2048) NOT NULL,
  tests integer[] NOT NULL DEFAULT ARRAY[]::integer[]
);

--
-- tests
--
CREATE TABLE IF NOT EXISTS tests (
  id integer PRIMARY KEY GENERATED BY DEFAULT AS IDENTITY,
  name varchar(64) NOT NULL,
  description text NOT NULL
);

--
-- submissions
--
CREATE TABLE IF NOT EXISTS submissions (
  id integer GENERATED BY DEFAULT AS IDENTITY,
  benchmark integer NOT NULL,
  submission_image varchar(2048) NOT NULL,
  code_repository varchar(2048),
  tests integer[] NOT NULL,
  submitted_at timestamp without time zone,
  submitted_by uuid,
  submitted_by_username varchar(64),
  uuid uuid PRIMARY KEY DEFAULT uuid_generate_v4(),
  name varchar(64)
);

--
-- results
--
CREATE TABLE IF NOT EXISTS results (
  id integer GENERATED BY DEFAULT AS IDENTITY,
  submission integer NOT NULL,
  created_at timestamp without time zone DEFAULT current_timestamp,
  done_at timestamp without time zone,
  success boolean,
  scores double precision[],
  results_str text,
  public boolean,
  uuid uuid PRIMARY KEY DEFAULT uuid_generate_v4(),
  submission_uuid uuid NOT NULL
);

CREATE INDEX IF NOT EXISTS submission_idx ON results (submission) WITH (deduplicate_items = off);

CREATE INDEX IF NOT EXISTS submission_uuid_idx ON results (submission_uuid) WITH (deduplicate_items = off);