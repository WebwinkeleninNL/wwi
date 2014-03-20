Feature: Merchant fn

  Background:
    Given system has following merchants
    | name |
    | Mark |
    | John |

  Scenario: merchant can create a product that visible only for him.
    Given merchant 'Mark' create a product
    When another merchant 'John' login to Merchant system
    And visit admin products page
    Then see an empty list of products
