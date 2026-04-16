--
-- add updated schemas
--
ALTER TABLE submissions
  ADD COLUMN tags varchar(128);
