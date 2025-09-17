import { SubmissionScenarioScore, SubmissionScore, SubmissionTestScore } from './interfaces'

/**
 * Returns whether all submission's scenarios have non-null scores only.
 */
export function isSubmissionCompletelyScored(submissionScore?: SubmissionScore) {
  if (!submissionScore) return false
  const scenarioScorings = submissionScore.test_scorings.flatMap((test) =>
    test.scenario_scorings.map((scenario) => scenario.scorings),
  )
  return scenarioScorings.every((scoring) => {
    return scoring.every((s) => s.score !== null)
  })
}

/**
 * Returns whether all tests's scenarios have non-null scores only.
 */
export function isTestCompletelyScored(testScore?: SubmissionTestScore) {
  if (!testScore) return false
  const scenarioScorings = testScore.scenario_scorings.map((s) => s.scorings)
  return scenarioScorings.every((scoring) => {
    return scoring.every((s) => s.score !== null)
  })
}

/**
 * Returns whether a scenario has non-null scores only.
 */
export function isScenarioCompletelyScored(scenarioScore?: SubmissionScenarioScore) {
  if (!scenarioScore) return false
  const scoring = scenarioScore.scorings
  return scoring.every((s) => s.score !== null)
}
