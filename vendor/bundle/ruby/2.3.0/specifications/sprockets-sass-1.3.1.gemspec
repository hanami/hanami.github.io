# -*- encoding: utf-8 -*-
# stub: sprockets-sass 1.3.1 ruby lib

Gem::Specification.new do |s|
  s.name = "sprockets-sass"
  s.version = "1.3.1"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.require_paths = ["lib"]
  s.authors = ["Pete Browne"]
  s.date = "2014-12-31"
  s.description = "When using Sprockets 2.0 with Sass you will eventually run into a pretty big issue. `//= require` directives will not allow Sass mixins, variables, etc. to be shared between files. So you'll try to use `@import`, and that'll also blow up in your face. `sprockets-sass` fixes all of this by creating a Sass::Importer that is Sprockets aware."
  s.email = ["me@petebrowne.com"]
  s.homepage = "http://github.com/petebrowne/sprockets-sass"
  s.rubyforge_project = "sprockets-sass"
  s.rubygems_version = "2.5.1"
  s.summary = "Better Sass integration with Sprockets 2.0"

  s.installed_by_version = "2.5.1" if s.respond_to? :installed_by_version

  if s.respond_to? :specification_version then
    s.specification_version = 3

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<sprockets>, ["~> 2.0"])
      s.add_runtime_dependency(%q<tilt>, ["~> 1.1"])
      s.add_development_dependency(%q<appraisal>, ["~> 0.5"])
      s.add_development_dependency(%q<rspec>, ["~> 2.13"])
      s.add_development_dependency(%q<test_construct>, ["~> 2.0"])
      s.add_development_dependency(%q<sprockets-helpers>, ["~> 1.0"])
      s.add_development_dependency(%q<sass>, ["~> 3.3"])
      s.add_development_dependency(%q<compass>, ["~> 1.0.0.alpha.19"])
      s.add_development_dependency(%q<rake>, [">= 0"])
      s.add_development_dependency(%q<pry>, [">= 0"])
    else
      s.add_dependency(%q<sprockets>, ["~> 2.0"])
      s.add_dependency(%q<tilt>, ["~> 1.1"])
      s.add_dependency(%q<appraisal>, ["~> 0.5"])
      s.add_dependency(%q<rspec>, ["~> 2.13"])
      s.add_dependency(%q<test_construct>, ["~> 2.0"])
      s.add_dependency(%q<sprockets-helpers>, ["~> 1.0"])
      s.add_dependency(%q<sass>, ["~> 3.3"])
      s.add_dependency(%q<compass>, ["~> 1.0.0.alpha.19"])
      s.add_dependency(%q<rake>, [">= 0"])
      s.add_dependency(%q<pry>, [">= 0"])
    end
  else
    s.add_dependency(%q<sprockets>, ["~> 2.0"])
    s.add_dependency(%q<tilt>, ["~> 1.1"])
    s.add_dependency(%q<appraisal>, ["~> 0.5"])
    s.add_dependency(%q<rspec>, ["~> 2.13"])
    s.add_dependency(%q<test_construct>, ["~> 2.0"])
    s.add_dependency(%q<sprockets-helpers>, ["~> 1.0"])
    s.add_dependency(%q<sass>, ["~> 3.3"])
    s.add_dependency(%q<compass>, ["~> 1.0.0.alpha.19"])
    s.add_dependency(%q<rake>, [">= 0"])
    s.add_dependency(%q<pry>, [">= 0"])
  end
end
