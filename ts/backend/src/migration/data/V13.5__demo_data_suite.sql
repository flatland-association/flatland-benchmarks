INSERT INTO suites
    (id, setup, name, description, contents, benchmark_ids)
    VALUES ('845e4cff-cf74-4382-9829-0facf11c5794', 'CAMPAIGN', 'Some Validation Campaign', 'Dummy validation campaign for benchmark.', '{}', array['20ccc7c1-034c-4880-8946-bffc3fed1359']::uuid[])
    ON CONFLICT(id) DO UPDATE SET setup=EXCLUDED.setup, name=EXCLUDED.name, description=EXCLUDED.description, benchmark_ids=EXCLUDED.benchmark_ids;
