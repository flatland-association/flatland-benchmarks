--
-- add updated schemas
--

ALTER TABLE submission_statuses ALTER COLUMN message TYPE VARCHAR(1024);
ALTER TABLE submission_statuses ALTER COLUMN tags TYPE VARCHAR(1024);
