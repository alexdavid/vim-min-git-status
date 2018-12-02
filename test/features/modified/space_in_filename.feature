Feature: Working with files with spaces in their name

  Background:
    Given I have a committed file "hello world"
    And I modify "hello world"


  Scenario: Viewing
    When I run :Gministatus
    Then I see
      """
      ## master
       M "hello world"
      ~
      """


  Scenario: Staging
    When I run :Gministatus
    And I type "j" to go down a line
    And I type "-" to toggle stage
    Then I see
      """
      ## master
      M  "hello world"
      ~
      """


  Scenario: Unstaging
    When I add "hello world" to the index
    And I run :Gministatus
    And I type "j" to go down a line
    And I type "-" to toggle stage
    Then I see
      """
      ## master
       M "hello world"
      ~
      """


  Scenario: Opening
    When I run :Gministatus
    And I type "j" to go down a line
    And I wait a second
    And I type "o" to open the file
    Then I see
      """
      Initial content for hello world
      """
