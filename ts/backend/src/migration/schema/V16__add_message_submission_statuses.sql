--
-- add updated schemas
--

ALTER TABLE submission_statuses
  ADD COLUMN message varchar(128);
