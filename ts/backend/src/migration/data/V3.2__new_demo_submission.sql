INSERT INTO submissions
(id, benchmark_definition_id, test_definition_ids, name, description, submission_data_url, submitted_at, submitted_by_username, status, published)
VALUES
('db5eaa85-3304-4804-b76f-14d23adb5d4c', '20ccc7c1-034c-4880-8946-bffc3fed1359', array['557d9a00-7e6d-410b-9bca-a017ca7fe3aa']::uuid[], 'Submission 1', 'Submission 1 for test 1', '', current_timestamp, 'Tester', 'SUCCESS', true);

INSERT INTO results
(scenario_definition_id, test_definition_id, submission_id, key, value)
VALUES
('1ae61e4f-201b-4e97-a399-5c33fb75c57e', '557d9a00-7e6d-410b-9bca-a017ca7fe3aa', 'db5eaa85-3304-4804-b76f-14d23adb5d4c', 'primary', 100),
('1ae61e4f-201b-4e97-a399-5c33fb75c57e', '557d9a00-7e6d-410b-9bca-a017ca7fe3aa', 'db5eaa85-3304-4804-b76f-14d23adb5d4c', 'secondary', 1.0),
('564ebb54-48f0-4837-8066-b10bb832af9d', '557d9a00-7e6d-410b-9bca-a017ca7fe3aa', 'db5eaa85-3304-4804-b76f-14d23adb5d4c', 'primary', 100),
('564ebb54-48f0-4837-8066-b10bb832af9d', '557d9a00-7e6d-410b-9bca-a017ca7fe3aa', 'db5eaa85-3304-4804-b76f-14d23adb5d4c', 'secondary', 0.8);
