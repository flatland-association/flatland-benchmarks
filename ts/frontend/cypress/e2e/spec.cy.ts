describe('Complete roundtrip', () => {
  it('should load the home view', () => {
    cy.visit('/')
    cy.contains('AI4REALNET Validation Campaign Hub')
    cy.contains('Welcome to the validation campaign hub.')
  })

  it('should navigate to the demo data campaign', () => {
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
    // TODO: login
  })
})
