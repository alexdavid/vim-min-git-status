Feature: Working with untracked files in the working tree

  Background:
    Given I have an untracked file "foo"
    When I run :Gministatus


  Scenario: Viewing
    Then I see
      """
      ## Initial commit on master
      ?? foo
      ~
      """


  Scenario: Staging
    When I type "j" to go down
    And I type "-" to toggle stage
    Then I see
      """
      ## Initial commit on master
      A  foo
      ~
      """
