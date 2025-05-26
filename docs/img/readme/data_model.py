import json

import numpy as np
import pandas as pd

if __name__ == '__main__':
  # Mapping Flatland 3 to generic data model if only one submission
  # - scenario run ID -> submission_id
  # TODO generalize to multiple submissions aka. scenario runs?
  # - metric          -> (submission_id,test_id,env_id, "normalized_reward")
  # - kpi             -> (submission_id, test_id, "normalized_reward_test")
  # - objective       -> (submission_id, "normalized_reward_all_tests")

  # =======================================================
  # Scenario Run Evaluation
  # =======================================================
  # filename,Unnamed: 0,test_id,env_id,n_agents,x_dim,y_dim,n_cities,max_rail_pairs_in_city,n_envs_run,seed,grid_mode,max_rails_between_cities,malfunction_duration_min,malfunction_duration_max,malfunction_interval,speed_ratios,reward,normalized_reward,percentage_complete,steps,simulation_time,nb_malfunctioning_trains,nb_deadlocked_trains,controller_inference_time_min,controller_inference_time_mean,controller_inference_time_max
  stats = json.load(open("sub-37557fc0-222e-4398-81d6-eade2892c9f6.json"))
  df = pd.read_csv("sub-37557fc0-222e-4398-81d6-eade2892c9f6.csv")
  print(stats)
  # {'state': 'FINISHED', 'progress': 1.0, 'simulation_count': 50, 'total_simulation_count': 150, 'score': {'score': 41.62435556467708, 'score_secondary': 0.597},
  #  'meta': {'normalized_reward': 0.83249,
  #           'termination_cause': 'The mean percentage of done agents during the last Test (10 environments) was too low: 0.176 < 0.25',
  #           'private_metadata_s3_key': 'results/sub-37557fc0-222e-4398-81d6-eade2892c9f6.csv', 'reward': -3859.26, 'percentage_complete': 0.597}}

  # score == normalized_reward.sum()
  sum_normalized_reward = df["normalized_reward"].sum()
  assert stats["score"]["score"] == sum_normalized_reward

  # secondary_score == percentage_complete.mean()
  mean_percentage_complete = df["percentage_complete"].mean()
  assert np.isclose(stats["score"]["score_secondary"], mean_percentage_complete, rtol=0.001)

  # normalized_reward == normalized_reward.mean()
  mean_normalized_reward = df["normalized_reward"].mean()
  # mean_normalized_reward round-off 5 digits
  assert np.isclose(stats["meta"]["normalized_reward"], mean_normalized_reward, rtol=0.00001)

  # reward == reward.mean()
  assert np.isclose(stats["meta"]["reward"], df["reward"].mean()), df["reward"].mean()

  # percentage_complete == percentage_complete.mean()
  assert np.isclose(stats["meta"]["percentage_complete"], mean_percentage_complete, rtol=0.001)

  # =======================================================
  # Validation Campaign (Definition)
  # =======================================================
  # Validation Campaign, Objective, KPI, sub-metrics all have the same structure....
  kpi_config = {
    "name": "normalized_reward_test",
    "metric": "normalized_reward",
    "weight": [1] * 10,
    "agg": np.sum,
    "threshold": 0.25,
    # "threshold_sign":,
    "threshold_agg": np.all
  }

  objective_config = {
    "name": "normalized_reward_all_tests",
    "metric": "normalized_reward_test",
    "weight": [1] * 15,
    "agg": np.sum,
    "threshold": 0.25,
    # "threshold_sign":,
    "threshold_agg": np.all
  }


  # =======================================================
  # Validation Campaign Evaluation
  # =======================================================
  # Validation Campaign, Objective, KPI, sub-metrics all can all be evaluated the same way....
  def eval_data(config, df):
    name = config["name"]
    agg = config["agg"]
    weights = config["weight"]
    metric = config["metric"]
    data = df[metric]
    threshold_agg_ = config["threshold_agg"]
    threshold_ = config["threshold"]
    return {
      name: agg(data * weights),
      "success": threshold_agg_(data > threshold_)
    }


  kpi_evaluation = pd.DataFrame.from_records([
    eval_data(kpi_config, df[df["test_id"] == f"Test_{i:02d}"]) for i in range(15)
  ])
  print(kpi_evaluation)
  #   normalized_reward_test  success
  # 0                 9.134868     True
  # 1                 9.682739     True
  # 2                 8.566212     True
  # 3                 7.427277     True
  # 4                 6.813260     True
  # 5                 0.000000    False
  # 6                 0.000000    False
  # 7                 0.000000    False
  # 8                 0.000000    False
  # 9                 0.000000    False
  # 10                0.000000    False
  # 11                0.000000    False
  # 12                0.000000    False
  # 13                0.000000    False
  # 14                0.000000    False

  objective_evaluation = pd.DataFrame.from_records([eval_data(objective_config, kpi_evaluation)])
  print(objective_evaluation)
  #   normalized_reward_all_tests  success
  # 0                    41.624356    False

  # TODO there might be more general aggregation/threshold schemes, e.g. "The mean percentage of done agents during the last Test (10 environments) was too low: 0.176 < 0.25"
  # TODO generalize the evaluation, the pd.DataFrame.from_records part
