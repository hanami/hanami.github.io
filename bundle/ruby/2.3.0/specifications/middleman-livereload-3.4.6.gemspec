# -*- encoding: utf-8 -*-
# stub: middleman-livereload 3.4.6 ruby lib

Gem::Specification.new do |s|
  s.name = "middleman-livereload"
  s.version = "3.4.6"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.require_paths = ["lib"]
  s.authors = ["Thomas Reynolds", "Ben Hollis", "Karl Freeman"]
  s.date = "2016-01-05"
  s.description = "LiveReload support for Middleman"
  s.email = ["me@tdreyno.com", "ben@benhollis.net", "karlfreeman@gmail.com"]
  s.homepage = "https://github.com/middleman/middleman-livereload"
  s.licenses = ["MIT"]
  s.required_ruby_version = Gem::Requirement.new(">= 1.9.3")
  s.rubygems_version = "2.5.1"
  s.summary = "LiveReload support for Middleman"

  s.installed_by_version = "2.5.1" if s.respond_to? :installed_by_version

  if s.respond_to? :specification_version then
    s.specification_version = 4

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<middleman-core>, [">= 3.3"])
      s.add_runtime_dependency(%q<rack-livereload>, ["~> 0.3.15"])
      s.add_runtime_dependency(%q<em-websocket>, ["~> 0.5.1"])
    else
      s.add_dependency(%q<middleman-core>, [">= 3.3"])
      s.add_dependency(%q<rack-livereload>, ["~> 0.3.15"])
      s.add_dependency(%q<em-websocket>, ["~> 0.5.1"])
    end
  else
    s.add_dependency(%q<middleman-core>, [">= 3.3"])
    s.add_dependency(%q<rack-livereload>, ["~> 0.3.15"])
    s.add_dependency(%q<em-websocket>, ["~> 0.5.1"])
  end
end
