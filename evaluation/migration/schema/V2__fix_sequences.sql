-- Initial schema setup inserted data without updating sequences. This
-- migration updates the sequences in question by setting the current sequence
-- value to the highest id in the respective table, causing the next auto-value
-- to be MAX(id)+1.
-- This is necessary to get auto-generated ids working again.

-- sync benchmarks sequence
SELECT setval('benchmarks_id_seq', (SELECT MAX(id) FROM benchmarks));

-- sync tests sequence
SELECT setval('tests_id_seq', (SELECT MAX(id) FROM tests));