import os

from flatland.evaluators.service import FlatlandRemoteEvaluationService

if __name__ == '__main__':
  print("/ start grader", flush=True)
  submission_id = os.getenv("AICROWD_SUBMISSION_ID", "T12345")
  grader = FlatlandRemoteEvaluationService(
    visualize=False,
    result_output_path=f"/tmp/results/results-{submission_id}.csv",
    verbose=True,
  )
  grader.run()
  print("\\ end grader", flush=True)
