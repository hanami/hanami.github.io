# -*- encoding: utf-8 -*-
# stub: ptools 1.3.2 ruby lib

Gem::Specification.new do |s|
  s.name = "ptools"
  s.version = "1.3.2"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.require_paths = ["lib"]
  s.authors = ["Daniel J. Berger"]
  s.date = "2014-12-11"
  s.description = "    The ptools (power tools) library provides several handy methods to\n    Ruby's core File class, such as File.which for finding executables,\n    File.null to return the null device on your platform, and so on.\n"
  s.email = "djberg96@gmail.com"
  s.extra_rdoc_files = ["README", "CHANGES", "MANIFEST"]
  s.files = ["CHANGES", "MANIFEST", "README"]
  s.homepage = "https://github.com/djberg96/ptools"
  s.licenses = ["Artistic 2.0"]
  s.rubygems_version = "2.5.1"
  s.summary = "Extra methods for the File class"

  s.installed_by_version = "2.5.1" if s.respond_to? :installed_by_version

  if s.respond_to? :specification_version then
    s.specification_version = 4

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_development_dependency(%q<rake>, [">= 0"])
      s.add_development_dependency(%q<test-unit>, [">= 2.5.0"])
    else
      s.add_dependency(%q<rake>, [">= 0"])
      s.add_dependency(%q<test-unit>, [">= 2.5.0"])
    end
  else
    s.add_dependency(%q<rake>, [">= 0"])
    s.add_dependency(%q<test-unit>, [">= 2.5.0"])
  end
end
