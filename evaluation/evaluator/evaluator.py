from flatland.evaluators.service import FlatlandRemoteEvaluationService

if __name__ == '__main__':
  print("/ start grader", flush=True)
  grader = FlatlandRemoteEvaluationService(
    # flatland_rl_service_id=service_id,
    visualize=False,
    # result_output_path=results_path,
    verbose=False,
    # shuffle=shuffle,
    # disable_timeouts=disable_timeouts
  )
  grader.run()
  print("\\ end grader", flush=True)
