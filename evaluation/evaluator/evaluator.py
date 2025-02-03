from flatland.evaluators.service import FlatlandRemoteEvaluationService

if __name__ == '__main__':
  print("/ start grader", flush=True)
  grader = FlatlandRemoteEvaluationService(
    visualize=False,
    result_output_path="/tmp/results/results.csv",
    verbose=True,
  )
  grader.run()
  print("\\ end grader", flush=True)
