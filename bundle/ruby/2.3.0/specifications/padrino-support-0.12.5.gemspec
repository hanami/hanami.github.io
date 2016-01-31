# -*- encoding: utf-8 -*-
# stub: padrino-support 0.12.5 ruby lib

Gem::Specification.new do |s|
  s.name = "padrino-support"
  s.version = "0.12.5"

  s.required_rubygems_version = Gem::Requirement.new(">= 1.3.6") if s.respond_to? :required_rubygems_version=
  s.require_paths = ["lib"]
  s.authors = ["Padrino Team", "Nathan Esquenazi", "Davide D'Agostino", "Arthur Chiu", "Igor Bochkariov"]
  s.date = "2015-03-04"
  s.description = "A number of support methods and extensions for Padrino framework"
  s.email = "padrinorb@gmail.com"
  s.homepage = "http://www.padrinorb.com"
  s.licenses = ["MIT"]
  s.rdoc_options = ["--charset=UTF-8"]
  s.rubyforge_project = "padrino-support"
  s.rubygems_version = "2.5.1"
  s.summary = "Support for padrino"

  s.installed_by_version = "2.5.1" if s.respond_to? :installed_by_version

  if s.respond_to? :specification_version then
    s.specification_version = 4

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<activesupport>, [">= 3.1"])
    else
      s.add_dependency(%q<activesupport>, [">= 3.1"])
    end
  else
    s.add_dependency(%q<activesupport>, [">= 3.1"])
  end
end
