import {
  FieldDefinitionRow,
  Scorings,
  SubmissionScenarioScore,
  SubmissionScore,
  SubmissionTestScore,
} from './interfaces'

/**
 * Returns the `Scoring` object that represents the primary scoring in scorings.
 * Requires field definitions to determine primary field.
 */
export function getPrimaryScoring(scorings: Scorings, fields?: FieldDefinitionRow[]) {
  const primaryField = fields?.at(0)
  if (!primaryField) return undefined
  return scorings[primaryField.key]
}

/**
 * Returns whether all submission's scenarios have non-null scores only.
 */
export function isSubmissionCompletelyScored(submissionScore?: SubmissionScore) {
  if (!submissionScore) return false
  const scenarioScorings = submissionScore.test_scorings.flatMap((test) =>
    test.scenario_scorings.map((scenario) => scenario.scorings),
  )
  return scenarioScorings.every((scoring) => {
    const keys = Object.keys(scoring)
    return keys.every((key) => scoring[key]?.score !== null)
  })
}

/**
 * Returns whether all tests's scenarios have non-null scores only.
 */
export function isTestCompletelyScored(testScore?: SubmissionTestScore) {
  if (!testScore) return false
  const scenarioScorings = testScore.scenario_scorings.map((s) => s.scorings)
  return scenarioScorings.every((scoring) => {
    const keys = Object.keys(scoring)
    return keys.every((key) => scoring[key]?.score !== null)
  })
}

/**
 * Returns whether a scenario has non-null scores only.
 */
export function isScenarioCompletelyScored(scenarioScore?: SubmissionScenarioScore) {
  if (!scenarioScore) return false
  const scoring = scenarioScore.scorings
  const keys = Object.keys(scoring)
  return keys.every((key) => scoring[key]?.score !== null)
}
