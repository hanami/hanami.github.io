# -*- encoding: utf-8 -*-
# stub: middleman-search_engine_sitemap 1.3.0 ruby lib

Gem::Specification.new do |s|
  s.name = "middleman-search_engine_sitemap"
  s.version = "1.3.0"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.require_paths = ["lib"]
  s.authors = ["Pete Nicholls"]
  s.date = "2014-11-29"
  s.description = "Adds a sitemap.xml file (following the sitemaps.org protocol) to your Middleman site for major search engines including Google."
  s.email = ["pete@metanation.com"]
  s.homepage = "https://github.com/Aupajo/middleman-search_engine_sitemap"
  s.licenses = ["MIT"]
  s.rubygems_version = "2.5.1"
  s.summary = "Adds a sitemap.xml file to your Middleman site for search engines."

  s.installed_by_version = "2.5.1" if s.respond_to? :installed_by_version

  if s.respond_to? :specification_version then
    s.specification_version = 4

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<middleman-core>, ["~> 3.2"])
      s.add_runtime_dependency(%q<builder>, [">= 0"])
      s.add_development_dependency(%q<bundler>, ["~> 1.5"])
      s.add_development_dependency(%q<rake>, [">= 0"])
      s.add_development_dependency(%q<rspec>, [">= 0"])
      s.add_development_dependency(%q<nokogiri>, [">= 0"])
    else
      s.add_dependency(%q<middleman-core>, ["~> 3.2"])
      s.add_dependency(%q<builder>, [">= 0"])
      s.add_dependency(%q<bundler>, ["~> 1.5"])
      s.add_dependency(%q<rake>, [">= 0"])
      s.add_dependency(%q<rspec>, [">= 0"])
      s.add_dependency(%q<nokogiri>, [">= 0"])
    end
  else
    s.add_dependency(%q<middleman-core>, ["~> 3.2"])
    s.add_dependency(%q<builder>, [">= 0"])
    s.add_dependency(%q<bundler>, ["~> 1.5"])
    s.add_dependency(%q<rake>, [">= 0"])
    s.add_dependency(%q<rspec>, [">= 0"])
    s.add_dependency(%q<nokogiri>, [">= 0"])
  end
end
