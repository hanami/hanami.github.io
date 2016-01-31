# -*- encoding: utf-8 -*-
# stub: middleman-syntax 2.1.0 ruby lib

Gem::Specification.new do |s|
  s.name = "middleman-syntax"
  s.version = "2.1.0"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.require_paths = ["lib"]
  s.authors = ["Ben Hollis"]
  s.date = "2015-12-19"
  s.description = "Code syntax highlighting plugin via rouge for Middleman"
  s.email = ["ben@benhollis.net"]
  s.homepage = "https://github.com/middleman/middleman-syntax"
  s.licenses = ["MIT"]
  s.rubygems_version = "2.5.1"
  s.summary = "Code syntax highlighting plugin via rouge for Middleman"

  s.installed_by_version = "2.5.1" if s.respond_to? :installed_by_version

  if s.respond_to? :specification_version then
    s.specification_version = 4

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<middleman-core>, [">= 3.2"])
      s.add_runtime_dependency(%q<rouge>, ["~> 1.0"])
      s.add_development_dependency(%q<aruba>, ["~> 0.5.1"])
      s.add_development_dependency(%q<cucumber>, ["~> 1.3.1"])
      s.add_development_dependency(%q<fivemat>, [">= 0"])
      s.add_development_dependency(%q<haml>, [">= 0"])
      s.add_development_dependency(%q<kramdown>, [">= 0"])
      s.add_development_dependency(%q<slim>, [">= 0"])
    else
      s.add_dependency(%q<middleman-core>, [">= 3.2"])
      s.add_dependency(%q<rouge>, ["~> 1.0"])
      s.add_dependency(%q<aruba>, ["~> 0.5.1"])
      s.add_dependency(%q<cucumber>, ["~> 1.3.1"])
      s.add_dependency(%q<fivemat>, [">= 0"])
      s.add_dependency(%q<haml>, [">= 0"])
      s.add_dependency(%q<kramdown>, [">= 0"])
      s.add_dependency(%q<slim>, [">= 0"])
    end
  else
    s.add_dependency(%q<middleman-core>, [">= 3.2"])
    s.add_dependency(%q<rouge>, ["~> 1.0"])
    s.add_dependency(%q<aruba>, ["~> 0.5.1"])
    s.add_dependency(%q<cucumber>, ["~> 1.3.1"])
    s.add_dependency(%q<fivemat>, [">= 0"])
    s.add_dependency(%q<haml>, [">= 0"])
    s.add_dependency(%q<kramdown>, [">= 0"])
    s.add_dependency(%q<slim>, [">= 0"])
  end
end
