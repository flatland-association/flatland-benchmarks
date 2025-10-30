import { SubmissionScenarioScore, SubmissionScore, SubmissionTestScore } from './interfaces'

/**
 * Returns whether the item's primary score is numerical.
 */
export function isScored(itemScore?: SubmissionScore | SubmissionTestScore | SubmissionScenarioScore) {
  return typeof itemScore?.scorings[0].score === 'number'
}
