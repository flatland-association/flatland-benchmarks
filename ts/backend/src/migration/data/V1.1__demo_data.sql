INSERT INTO benchmarks
  (name, description, docker_image, tests)
VALUES
  ('Flatland 3', 'This is the first permanent Flatland benchmark.', 'ghcr.io/flatland-association/fab-flatland-evaluator:latest', ARRAY[1,2]);

INSERT INTO tests
  (name, description)
VALUES
  ('Test_0', '5 agents, 25x25, 2 cities, 2 seeds'),
  ('Test_1', '2 agents, 30x30, 3 cities, 3 seeds');