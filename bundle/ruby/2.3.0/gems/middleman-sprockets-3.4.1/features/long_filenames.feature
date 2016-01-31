Feature: Long Filenames

  Scenario: Checking built folder for content
    Given a successfully built app at "long-filenames-app"
    When I cd to "build"
    Then the following files should exist:
      | images/00000000-0000-0000-0000-000000.svg |
      | images/00000000-0000-0000-0000-0000001.svg |
    And the file "images/00000000-0000-0000-0000-000000.svg" should contain "<svg xmlns"
    And the file "images/00000000-0000-0000-0000-0000001.svg" should contain "<svg xmlns"

  Scenario: Rendering html
    Given the Server is running at "long-filenames-app"
    When I go to "/images/00000000-0000-0000-0000-000000.svg"
    Then I should see "<svg xmlns"
    When I go to "/images/00000000-0000-0000-0000-0000001.svg"
    Then I should see "<svg xmlns"