--
-- known types of loop setups
--
CREATE TYPE loop_setup AS ENUM ('CLOSED', 'INTERACTIVE', 'OFFLINE');

--
-- add loop setup property to test
--
ALTER TABLE test_definitions
  ADD COLUMN setup loop_setup NOT NULL DEFAULT 'CLOSED';
