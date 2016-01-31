Feature: Sprockets Gems
  Scenario: Sprockets can pull jQuery from gem
    Given the Server is running at "sprockets-app"
    When I go to "/library/js/jquery_include.js"
    Then I should see "window.jQuery ="

  Scenario: Sprockets can pull CSS from gem
    Given the Server is running at "sprockets-app"
    When I go to "/library/css/bootstrap_include.css"
    Then I should see ".btn-default"

  Scenario: Sprockets can pull js from vendored assets
    Given the Server is running at "sprockets-app"
    When I go to "/library/js/vendored_include.js"
    Then I should see "var vendored_js_included = true;"

  Scenario: Sprockets can pull js from custom vendor dir
    Given the Server is running at "asset-paths-app"
    When I go to "/javascripts/vendored_include.js"
    Then I should see "var vendored_js_included = true;"

  Scenario: Proper reference to images from a gem, in preview
    Given the Server is running at "jquery-mobile-app"
    When I go to "/stylesheets/base.css"
    Then I should see 'url("/images/jquery-mobile/ajax-loader.gif")'

  Scenario: Proper reference to images from a gem, in build
    Given a successfully built app at "jquery-mobile-app"
    When I cd to "build"
    Then the following files should exist:
      | stylesheets/base.css |
      | images/jquery-mobile/ajax-loader.gif |
    And the file "stylesheets/base.css" should contain 'url("/images/jquery-mobile/ajax-loader.gif")'

  Scenario: Same thing, but with :relative_assets on
    Given a fixture app "jquery-mobile-app"
    And a file named "config.rb" with:
      """
      activate :relative_assets
      """
    Given the Server is running at "jquery-mobile-app"
    When I go to "/stylesheets/base.css"
    Then I should see 'url("../images/jquery-mobile/ajax-loader.gif")'

  Scenario: JS/CSS from gems aren't aumatically in the site
    Given the Server is running at "jquery-mobile-app"
    When I go to "/javascripts/jquery.mobile.js"
    Then I should get a response with status "404"

  Scenario: JS/CSS from gems can be declared to be accessible
    Given a fixture app "jquery-mobile-app"
    Given a file named "config.rb" with:
      """
      after_configuration do
        sprockets.import_asset 'jquery.mobile'
      end
      """
    And the Server is running at "jquery-mobile-app"
    When I go to "/javascripts/jquery.mobile.js"
    Then I should get a response with status "200"

  Scenario: JS/CSS from gems are accessible when debugging assets and they are required
    Given the Server is running at "sprockets-app-debug-assets"
    And the Server is running at "sprockets-app-debug-assets"
    When I go to "/index.html"
    When I go to "/javascripts/bootstrap/alert.js?body=1"
    Then I should get a response with status "200"
