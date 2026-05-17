INSERT INTO submissions
(id, benchmark_id, test_ids, name, description, submission_data_url, submitted_at, submitted_by, submitted_by_username, published)
VALUES ('c912c1fc-faa0-486c-b6f6-7f3411e4f307', 'c85d5fc2-15da-4a62-8e14-28d1261c29bd', array['39ae35d8-4b0f-467f-9ec4-ee19c3558c7f']::uuid[],
        'Submission 1', 'Submission 1', 'Submission Data Url 1', current_timestamp, '53e2038c-0c5f-4536-9a3c-71c82f49119a', 'User', true);


INSERT INTO results
  (scenario_id, test_id, submission_id, key, value)
VALUES ('ee155de0-14f1-4bd7-8cc6-9100276758fa', '39ae35d8-4b0f-467f-9ec4-ee19c3558c7f', 'c912c1fc-faa0-486c-b6f6-7f3411e4f307', 'normalized_reward', 0.8),
       ('ee155de0-14f1-4bd7-8cc6-9100276758fa', '39ae35d8-4b0f-467f-9ec4-ee19c3558c7f', 'c912c1fc-faa0-486c-b6f6-7f3411e4f307', 'percentage_complete', 1.0),
       ('1ee01690-3671-4bad-a8c6-52499e491a34', '39ae35d8-4b0f-467f-9ec4-ee19c3558c7f', 'c912c1fc-faa0-486c-b6f6-7f3411e4f307', 'normalized_reward', 0.33),
       ('1ee01690-3671-4bad-a8c6-52499e491a34', '39ae35d8-4b0f-467f-9ec4-ee19c3558c7f', 'c912c1fc-faa0-486c-b6f6-7f3411e4f307', 'percentage_complete', 0.8);

