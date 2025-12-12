--
-- remove deprecated schemas
--
ALTER TABLE submissions
  DROP COLUMN IF EXISTS status;

DROP TYPE submission_status;

--
-- add updated schemas
--
CREATE TYPE submission_status AS ENUM ('SUBMITTED', 'STARTED', 'SUCCESS', 'FAILURE');

CREATE TABLE IF NOT EXISTS submission_statuses (
  submission_id uuid NOT NULL,
  status submission_status NOT NULL,
  timestamp timestamp without time zone
);

ALTER TABLE submission_statuses
  ADD PRIMARY KEY (submission_id, timestamp);

CREATE INDEX IF NOT EXISTS submission_statuses_idx ON submission_statuses (submission_id);
