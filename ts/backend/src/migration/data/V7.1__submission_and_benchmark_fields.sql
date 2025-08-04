--
-- prior to V7, campaign fields were defined in fields - reroute in affected
-- benchmarks and add field definition for submission score
--

INSERT INTO field_definitions
  (id, key, description, agg_func)
VALUES
  ('90a1d64a-fa23-49b8-b41d-e2ea974a8b42', 'primary', 'Primary submission score (NANSUM of test scores)', 'NANSUM');

UPDATE benchmark_definitions
SET
  campaign_field_ids = field_ids,
  field_ids = array['90a1d64a-fa23-49b8-b41d-e2ea974a8b42']::uuid[]
WHERE
  id = ANY(array['c5145011-ce69-4679-8694-e1dbeb1ee4bb', '74b5d783-54cd-4161-a974-8865118dc2f7', 'e49fe4e4-93b4-4f73-a4a2-fb63a5b166cf', '255fb1e8-af57-45a0-97dc-ecc3e6721b4f', '1df5f920-ed2c-4873-957b-723b4b5d81b1']::uuid[]);