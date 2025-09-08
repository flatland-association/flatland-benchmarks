import { FieldDefinitionRow, Scorings } from './interfaces'

/**
 * Returns the `Scoring` object that represents the primary scoring in scorings.
 * Requires field definitions to determine primary field.
 */
export function getPrimaryScoring(scorings: Scorings, fields?: FieldDefinitionRow[]) {
  const primaryField = fields?.at(0)
  if (!primaryField) return undefined
  return scorings[primaryField.key]
}
