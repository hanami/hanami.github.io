require 'bundler'
Bundler::GemHelper.install_tasks

require 'cucumber/rake/task'
require 'rspec/core/rake_task'

require 'middleman-core/version'

Cucumber::Rake::Task.new(:cucumber, 'Run features that should pass') do |t|
  exempt_tags = ["--tags ~@wip"]
  exempt_tags << "--tags ~@new " unless Middleman::VERSION.start_with?("3.1")
  exempt_tags << "--tags ~@old " unless Middleman::VERSION.start_with?("3.0")
  t.cucumber_opts = "--color #{exempt_tags.join(" ")} --strict --format #{ENV['CUCUMBER_FORMAT'] || 'Fivemat'}"
end

RSpec::Core::RakeTask.new(:spec) do |t|
  if RUBY_VERSION < '2.0'
    t.rspec_opts = '--tag ~@skip:one-nine'
  end
end

require 'rake/clean'

task :test => [:destroy_sass_cache, "cucumber", "spec"]

desc "Build HTML documentation"
task :doc do
  sh 'bundle exec yard'
end

begin
  require 'cane/rake_task'

  desc "Run cane to check quality metrics"
  Cane::RakeTask.new(:quality) do |cane|
    cane.no_style = true
    cane.no_doc = true
    cane.abc_glob = "lib/middleman-sprockets/**/*.rb"
  end
rescue LoadError
  # warn "cane not available, quality task not provided."
end

desc "Destroy the sass cache from fixtures in case it messes with results"
task :destroy_sass_cache do
  Dir["fixtures/*/.sass-cache"].each do |dir|
    rm_rf dir
  end
end
