source "https://rubygems.org"

gem "middleman-core", :github => "middleman/middleman", :branch => "v3-stable"

# Specify your gem's dependencies in middleman-sprockets.gemspec
gemspec

gem "rake", "~> 10.0.3", :require => false
gem "yard", "~> 0.8.0", :require => false

# Test tools
gem "cucumber"
gem "fivemat", "~> 1.2.1"
gem "aruba"
gem "rspec", "~> 3.0"
gem "builder", "~> 3.0"
gem "simplecov"

# For actual tests
# Make sure to lock down the versions of the asset gems
# so they don't cause asset hashes to change.
gem "railties", "~> 4.1.0"
gem "jquery-rails", "3.1.0", :require => false
gem "bootstrap-sass", "3.1.1.0", :require => false
gem "jquery_mobile_rails", "1.4.1", :require => false

gem "ejs", "~> 1.1.1"
gem "eco", "~> 1.0.0"
gem "erubis", "~> 2.7.0"

# Code Quality
gem "cane", :platforms => [:mri_19, :mri_20], :require => false
