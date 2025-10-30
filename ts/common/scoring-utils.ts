import { SubmissionScenarioScore, SubmissionScore, SubmissionTestScore } from './interfaces'

/**
 * Returns whether the item's primary score is numerical.
 */
export function isScored(itemScore?: SubmissionScore | SubmissionTestScore | SubmissionScenarioScore) {
  return typeof itemScore?.scorings[0].score === 'number'
}

/**
 * Returns whether all submission's scores are numerical.
 */
export function isSubmissionCompletelyScored(submissionScore?: SubmissionScore) {
  if (!submissionScore) return false
  return submissionScore.scorings.every((scoring) => typeof scoring.score === 'number')
}

/**
 * Returns whether all tests's scores are numerical.
 */
export function isTestCompletelyScored(testScore?: SubmissionTestScore) {
  if (!testScore) return false
  return testScore.scorings.every((scoring) => typeof scoring.score === 'number')
}

/**
 * Returns whether all scenario's scores are numerical.
 */
export function isScenarioCompletelyScored(scenarioScore?: SubmissionScenarioScore) {
  if (!scenarioScore) return false
  return scenarioScore.scorings.every((scoring) => typeof scoring.score === 'number')
}
