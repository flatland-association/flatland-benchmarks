import submission from '../fixtures/submission.json'

describe('Complete roundtrip', () => {
  it('should load the home view', () => {
    cy.visit('/')
    cy.contains('AI4REALNET Validation Campaign Hub')
    cy.contains('Welcome to the validation campaign hub.')
  })

  it('should navigate to the demo data campaign, make, score and publish submission', () => {
    // Using time of day in submission name to further identify it.
    // This makes it possible to run e2e tests multiple times a day without
    // having to wipe the dev DB.
    const timeSuffix = new Date().toISOString().substring(11, 19)
    const submissionName = `${submission.name} (${timeSuffix})`
    cy.kcLogin('user')
    cy.visit('/')
    // navigate to suite
    cy.get('app-benchmark-group-card > div').first().click()
    // navigate to benchmark
    cy.contains('tr', submission.benchmark).as('objectiveRow').click()
    // navigate to KPI
    cy.contains('tr', submission.test).click()
    // start submission
    cy.contains('button', 'Submit').click() // TODO: identify by data-* attribute
    // enter details and submit
    cy.get('input#submission-name').type(submissionName)
    cy.contains('button', 'Submit').click() // TODO: identify by data-* attribute
    // navigate to scenario
    cy.contains('tr', submission.scenario).click()
    // enter score and submit
    cy.get('input[type=number]').type(submission.score)
    cy.contains('button', 'Submit').click() // TODO: identify by data-* attribute
    // navigate back to submission via breadcrumb
    cy.get('app-breadcrumbs').contains('a', submissionName).click()
    // assert it's been successfully score and publish
    cy.contains('This submission has been successfully scored.')
    cy.contains('button', 'Publish').click() // TODO: identify by data-* attribute
    // navigate back to KPI via breadcrumb
    cy.get('app-breadcrumbs').contains('a', 'AI-human learning curves').click()
    // assert it's been published by visiting the KPI and looking for it
    cy.contains('tr', submission.test).click()
    cy.contains('tr', submissionName)
  })
})
