import '@testing-library/cypress/add-commands'

Cypress.Commands.add('resetDatabase', () => cy.exec(`psql postgres://relay_test:relay_test@localhost:5433/relay_test -c "TRUNCATE TABLE meta_data"`))