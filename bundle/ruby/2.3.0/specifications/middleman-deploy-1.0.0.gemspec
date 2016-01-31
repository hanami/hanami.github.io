# -*- encoding: utf-8 -*-
# stub: middleman-deploy 1.0.0 ruby lib

Gem::Specification.new do |s|
  s.name = "middleman-deploy"
  s.version = "1.0.0"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.require_paths = ["lib"]
  s.authors = ["Tom Vaughan", "Karl Freeman"]
  s.date = "2014-11-21"
  s.description = "Deploy a middleman built site over rsync, ftp, sftp, or git (e.g. gh-pages on github)."
  s.email = ["thomas.david.vaughan@gmail.com", "karlfreeman@gmail.com"]
  s.homepage = "https://github.com/karlfreeman/middleman-deploy"
  s.licenses = ["MIT"]
  s.required_ruby_version = Gem::Requirement.new(">= 1.9.3")
  s.rubygems_version = "2.5.1"
  s.summary = "Deploy a middleman built site over rsync, ftp, sftp, or git (e.g. gh-pages on github)."

  s.installed_by_version = "2.5.1" if s.respond_to? :installed_by_version

  if s.respond_to? :specification_version then
    s.specification_version = 4

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<middleman-core>, [">= 3.2"])
      s.add_runtime_dependency(%q<ptools>, [">= 0"])
      s.add_runtime_dependency(%q<net-sftp>, [">= 0"])
      s.add_development_dependency(%q<bundler>, ["~> 1.5"])
      s.add_development_dependency(%q<rake>, ["~> 10.0"])
      s.add_development_dependency(%q<kramdown>, [">= 0.14"])
      s.add_development_dependency(%q<rubocop>, ["~> 0.19"])
      s.add_development_dependency(%q<pry>, [">= 0"])
      s.add_development_dependency(%q<yard>, [">= 0"])
    else
      s.add_dependency(%q<middleman-core>, [">= 3.2"])
      s.add_dependency(%q<ptools>, [">= 0"])
      s.add_dependency(%q<net-sftp>, [">= 0"])
      s.add_dependency(%q<bundler>, ["~> 1.5"])
      s.add_dependency(%q<rake>, ["~> 10.0"])
      s.add_dependency(%q<kramdown>, [">= 0.14"])
      s.add_dependency(%q<rubocop>, ["~> 0.19"])
      s.add_dependency(%q<pry>, [">= 0"])
      s.add_dependency(%q<yard>, [">= 0"])
    end
  else
    s.add_dependency(%q<middleman-core>, [">= 3.2"])
    s.add_dependency(%q<ptools>, [">= 0"])
    s.add_dependency(%q<net-sftp>, [">= 0"])
    s.add_dependency(%q<bundler>, ["~> 1.5"])
    s.add_dependency(%q<rake>, ["~> 10.0"])
    s.add_dependency(%q<kramdown>, [">= 0.14"])
    s.add_dependency(%q<rubocop>, ["~> 0.19"])
    s.add_dependency(%q<pry>, [">= 0"])
    s.add_dependency(%q<yard>, [">= 0"])
  end
end
