--
-- add updated schemas
--

ALTER TABLE submission_statuses ALTER COLUMN message TYPE VARCHAR(2048);
ALTER TABLE submissions ALTER COLUMN tags TYPE VARCHAR(2048);
ALTER TABLE submissions ALTER COLUMN name TYPE VARCHAR(2048);
