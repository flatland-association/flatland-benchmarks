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
    const timeInfix = new Date().toISOString().substring(11, 19)
    const submissionName = `E2E Submission (${timeInfix})`
    cy.kcLogin('user')
    cy.visit('/')
    cy.get('app-benchmark-group-card > div').first().click()
    // the demo data campaign will have zero submissions for AI-human learning
    // curves yet - otherwise fail fast (setup not clean)
    cy.contains('tr', 'AI-human learning curves').as('objectiveRow')
    cy.get('@objectiveRow')
      .children('td')
      .eq(2)
      .should((el) => expect(el.text().trim()).equal(''))
    cy.get('@objectiveRow').click()
    // navigate to KPI
    cy.contains('tr', 'KPI-AS-006').click()
    // start submission
    cy.contains('button', 'Submit').click()
    // enter details and submit
    cy.get('input#submission-name').type(submissionName)
    cy.contains('button', 'Submit').click()
    // navigate to scenario
    cy.contains('tr', 'KPI-AS-006-1').click()
    // enter score and submit
    cy.get('input[type=number]').type('500')
    cy.contains('button', 'Submit').click()
    // navigate back to submission via breadcrumb
    cy.get('app-breadcrumbs').contains('a', submissionName).click()
    // assert it's been successfully score and publish
    cy.contains('This submission has been successfully scored.')
    cy.contains('button', 'Publish').click()
    // navigate back to KPI via breadcrumb
    cy.get('app-breadcrumbs').contains('a', 'AI-human learning curves').click()
    // assert it's been published by visiting the KPI and looking for it
    cy.contains('tr', 'KPI-AS-006').click()
    cy.contains('tr', submissionName)
  })
})
