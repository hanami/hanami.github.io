# -*- encoding: utf-8 -*-
# stub: middleman-blog 3.5.3 ruby lib

Gem::Specification.new do |s|
  s.name = "middleman-blog"
  s.version = "3.5.3"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.require_paths = ["lib"]
  s.authors = ["Thomas Reynolds", "Ben Hollis"]
  s.date = "2014-05-24"
  s.description = "Blog engine for Middleman"
  s.email = ["me@tdreyno.com", "ben@benhollis.net"]
  s.homepage = "https://github.com/middleman/middleman-blog"
  s.licenses = ["MIT"]
  s.required_ruby_version = Gem::Requirement.new(">= 1.9.3")
  s.rubygems_version = "2.5.1"
  s.summary = "Blog engine for Middleman"

  s.installed_by_version = "2.5.1" if s.respond_to? :installed_by_version

  if s.respond_to? :specification_version then
    s.specification_version = 4

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<middleman-core>, ["~> 3.2"])
      s.add_runtime_dependency(%q<tzinfo>, [">= 0.3.0"])
      s.add_runtime_dependency(%q<addressable>, ["~> 2.3.5"])
    else
      s.add_dependency(%q<middleman-core>, ["~> 3.2"])
      s.add_dependency(%q<tzinfo>, [">= 0.3.0"])
      s.add_dependency(%q<addressable>, ["~> 2.3.5"])
    end
  else
    s.add_dependency(%q<middleman-core>, ["~> 3.2"])
    s.add_dependency(%q<tzinfo>, [">= 0.3.0"])
    s.add_dependency(%q<addressable>, ["~> 2.3.5"])
  end
end
