# -*- encoding: utf-8 -*-
# stub: sprockets-helpers 1.1.0 ruby lib

Gem::Specification.new do |s|
  s.name = "sprockets-helpers"
  s.version = "1.1.0"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.require_paths = ["lib"]
  s.authors = ["Pete Browne"]
  s.date = "2013-11-03"
  s.description = "Asset path helpers for Sprockets 2.x applications"
  s.email = ["me@petebrowne.com"]
  s.homepage = "https://github.com/petebrowne/sprockets-helpers"
  s.rubyforge_project = "sprockets-helpers"
  s.rubygems_version = "2.5.1"
  s.summary = "Asset path helpers for Sprockets 2.x applications"

  s.installed_by_version = "2.5.1" if s.respond_to? :installed_by_version

  if s.respond_to? :specification_version then
    s.specification_version = 3

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<sprockets>, ["~> 2.0"])
      s.add_development_dependency(%q<appraisal>, ["~> 0.5"])
      s.add_development_dependency(%q<rspec>, ["~> 2.13"])
      s.add_development_dependency(%q<test-construct>, ["~> 1.2"])
      s.add_development_dependency(%q<sinatra>, ["~> 1.4"])
      s.add_development_dependency(%q<rake>, [">= 0"])
    else
      s.add_dependency(%q<sprockets>, ["~> 2.0"])
      s.add_dependency(%q<appraisal>, ["~> 0.5"])
      s.add_dependency(%q<rspec>, ["~> 2.13"])
      s.add_dependency(%q<test-construct>, ["~> 1.2"])
      s.add_dependency(%q<sinatra>, ["~> 1.4"])
      s.add_dependency(%q<rake>, [">= 0"])
    end
  else
    s.add_dependency(%q<sprockets>, ["~> 2.0"])
    s.add_dependency(%q<appraisal>, ["~> 0.5"])
    s.add_dependency(%q<rspec>, ["~> 2.13"])
    s.add_dependency(%q<test-construct>, ["~> 1.2"])
    s.add_dependency(%q<sinatra>, ["~> 1.4"])
    s.add_dependency(%q<rake>, [">= 0"])
  end
end
