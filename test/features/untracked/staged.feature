Feature: Working with untracked files in the index

  Background:
    Given I have an untracked file "foo"
    When I add "foo" to the index
    And I run :Gministatus


  Scenario: Viewing
    Then I see
      """
      ## Initial commit on master
      A  foo
      ~
      """


  Scenario: Unstaging
    When I type "j" to go down
    And I type "-" to toggle stage
    Then I see
      """
      ## Initial commit on master
      ?? foo
      ~
      """
