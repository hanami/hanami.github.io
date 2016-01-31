Feature: Bower
  Scenario: Sprockets can pull underscore from bower
    Given the Server is running at "bower-app"
    When I go to "/javascripts/application.js"
    Then I should see "return _;"

  Scenario: Sprockets can build underscore from bower
    Given a successfully built app at "bower-app"
    When I cd to "build"
    Then the following files should exist:
      | javascripts/application.js |
    And the file "javascripts/application.js" should contain "return _;"

  Scenario: Sprockets should not mess with bower.json
    Given a successfully built app at "bower-json-app"
    When I cd to "build"
    Then the following files should exist:
      | javascripts/bower.json |
    And the file "javascripts/bower.json" should contain '"name": "my-project",'

  Scenario: Assets can be added to the build with import_asset from bower dir
    Given a successfully built app at "bower-app"
    When I cd to "build"
    Then a file named "javascripts/underscore/underscore.js" should exist

  Scenario: Multiple assets can be added to the build with import_asset from bower dir and are placed in the correct directory
    Given a successfully built app at "bower-multiple-assets-app"
    When I cd to "build"
    Then a file named "images/lightbox2/img/close.png" should exist
    Then a file named "javascripts/lightbox2/js/lightbox.js" should exist

  Scenario: Assets which haven't been imported don't appear in output directory
    Given a successfully built app at "bower-multiple-assets-app"
    When I cd to "build"
    Then a file named "images/lightbox2/img/open.png" should not exist

  Scenario: Assets can have an individual output directory
    Given a successfully built app at "bower-individual-outputdir-app"
    When I cd to "build"
    Then a file named "underscore.js" should exist
    And a file named "hello_world/lightbox2/img/close.png" should exist
    And a file named "javascripts/lightbox2/js/lightbox.js" should exist
