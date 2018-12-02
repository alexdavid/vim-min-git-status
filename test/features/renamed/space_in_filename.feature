Feature: Working with files with spaces in their name

  Background:
    Given I have a committed file "hello world"
    And I rename "hello world" to "new name"
    And I remove "hello world" from the index
    And I add "new name" to the index
    And I run :Gministatus


  Scenario: Viewing
    Then I see
      """
      ## master
      R  "hello world" -> "new name"
      ~
      """


  Scenario: Unstaging
    When I type "j" to go down a line
    And I type "-" to toggle stage
    Then I see
      """
      ## master
       D "hello world"
      ?? new name
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
