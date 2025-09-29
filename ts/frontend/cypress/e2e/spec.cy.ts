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
    // navigate to suite (by id for test stability, because the name is shared)
    cy.get(`[data-link*=${submission.suiteId}]`).click()
    // navigate to benchmark
    cy.contains('[data-link]', submission.benchmark).as('objectiveRow').click()
    // navigate to KPI
    cy.contains('[data-link]', submission.test).click()
    // start submission
    cy.get('[data-btn-new-submission]').click()
    // enter details and submit
    cy.get('[data-input-submission-name]').type(submissionName)
    cy.get('[data-btn-submit]').click()
    // navigate to scenario
    cy.contains('[data-link]', submission.scenario).click()
    // enter score and submit
    cy.get('[data-input-cell-number]').type(submission.score)
    cy.get('[data-btn-submit]').click()
    // navigate back to submission via breadcrumb
    cy.get('app-breadcrumbs').contains('a', submissionName).click()
    // assert it's been successfully score and publish
    cy.get('[data-text-success]')
    cy.get('[data-btn-publish]').click()
    // navigate back to KPI via breadcrumb
    cy.get('app-breadcrumbs').contains('a', submission.benchmark).click()
    // assert it's been published by visiting the KPI and looking for it
    cy.contains('[data-link]', submission.test).click()
    cy.contains('tr', submissionName)
  })
})
