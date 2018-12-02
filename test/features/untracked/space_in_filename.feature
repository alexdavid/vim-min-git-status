Feature: Working with files with spaces in their name

  Background:
    Given I have an untracked file "hello world"
    And I run :Gministatus


  Scenario: Viewing
    Then I see
      """
      ## Initial commit on master
      ?? hello world
      ~
      """


  Scenario: Staging
    When I type "j" to go down a line
    And I type "-" to toggle stage
    Then I see
      """
      ## Initial commit on master
      A  "hello world"
      ~
      """


  Scenario: Opening
    When I type "j" to go down a line
    And I wait a second
    And I type "o" to open the file
    Then I see
      """
      Initial content for hello world
      """
