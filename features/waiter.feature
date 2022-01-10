Feature: Waiter
  In order to portray or pluralize food
  As a CLI
  I want to be as objective as possible

  Scenario: Broccoli is gross
    When I run `alacarte portray broccoli`
    Then the output should contain "Gross!"

  Scenario: waiter takes order
    When I run `alacarte waiter`
    Then the output should contain "Welcome to Alacarte"

