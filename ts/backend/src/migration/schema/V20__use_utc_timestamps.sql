-- `timestamp without time zone AT TIME ZONE zone` interprets the bare value as being in `zone`
-- and returns a `timestamptz` (PostgreSQL stores timestamptz internally as UTC).
-- Example: '14:00:00' AT TIME ZONE 'Europe/Zurich' → 13:00:00+00 (UTC)
-- Example: '14:00:00' AT TIME ZONE 'UTC'            → 14:00:00+00 (value unchanged, type changes)
-- Requirement: current_setting('TIMEZONE') must match the timezone active when rows were written.

ALTER TABLE submissions
ALTER
COLUMN submitted_at TYPE TIMESTAMPTZ
  USING submitted_at AT TIME ZONE current_setting('TIMEZONE');

ALTER TABLE submission_statuses
ALTER
COLUMN "timestamp" TYPE TIMESTAMPTZ
  USING "timestamp" AT TIME ZONE current_setting('TIMEZONE');

