--
-- known types of loop setups
--
CREATE TYPE loop AS ENUM ('CLOSED', 'INTERACTIVE', 'OFFLINE');

--
-- add loop setup property to test
--
ALTER TABLE test_definitions
  ADD COLUMN loop loop NOT NULL DEFAULT 'CLOSED';
