require 'rake'
require 'rake/clean'
require 'rake/testtask'
require 'rbconfig'
include RbConfig

CLEAN.include("**/*.gem", "**/*.rbc", "**/*coverage*")

desc 'Install the ptools package (non-gem)'
task :install do
   sitelibdir = CONFIG["sitelibdir"]
   file = "lib/ptools.rb"
   FileUtils.cp(file, sitelibdir, :verbose => true)
end

namespace 'gem' do
  desc 'Create the ptools gem'
  task :create => [:clean] do
    require 'rubygems/package'
    spec = eval(IO.read('ptools.gemspec'))
    spec.signing_key = File.join(Dir.home, '.ssh', 'gem-private_key.pem')
    Gem::Package.build(spec)
  end

  desc 'Install the ptools gem'
  task :install => [:create] do
    file = Dir["*.gem"].first
    if RUBY_PLATFORM == 'java'
      sh "jruby -S gem install -l #{file}"
    else
      sh "gem install -l #{file}"
    end
  end
end

Rake::TestTask.new do |t|
  task :test => :clean
  t.verbose = true
  t.warning = true
end

namespace 'test' do
  desc "Check test coverage using rcov"
  task :coverage => [:clean] do
    require 'rcov'
    rm_rf 'coverage'
    sh "rcov -Ilib test/test*.rb" 
  end

  Rake::TestTask.new('binary') do |t|
    t.libs << 'test'
    t.verbose = true
    t.warning = true
    t.test_files = FileList['test/test_binary.rb']
  end

  Rake::TestTask.new('constants') do |t|
    t.libs << 'test'
    t.verbose = true
    t.warning = true
    t.test_files = FileList['test/test_constants.rb']
  end

  Rake::TestTask.new('head') do |t|
    t.libs << 'test'
    t.verbose = true
    t.warning = true
    t.test_files = FileList['test/test_head.rb']
  end

  Rake::TestTask.new('image') do |t|
    t.libs << 'test'
    t.verbose = true
    t.warning = true
    t.test_files = FileList['test/test_image.rb']
  end

  Rake::TestTask.new('nlconvert') do |t|
    t.libs << 'test'
    t.verbose = true
    t.warning = true
    t.test_files = FileList['test/test_nlconvert.rb']
  end

  Rake::TestTask.new('null') do |t|
    t.libs << 'test'
    t.verbose = true
    t.warning = true
    t.test_files = FileList['test/test_null.rb']
  end

  Rake::TestTask.new('sparse') do |t|
    t.libs << 'test'
    t.verbose = true
    t.warning = true
    t.test_files = FileList['test/test_is_sparse.rb']
  end

  Rake::TestTask.new('tail') do |t|
    t.libs << 'test'
    t.verbose = true
    t.warning = true
    t.test_files = FileList['test/test_tail.rb']
  end

  Rake::TestTask.new('touch') do |t|
    t.libs << 'test'
    t.verbose = true
    t.warning = true
    t.test_files = FileList['test/test_touch.rb']
  end

  Rake::TestTask.new('wc') do |t|
    t.libs << 'test'
    t.verbose = true
    t.warning = true
    t.test_files = FileList['test/test_wc.rb']
  end

  Rake::TestTask.new('whereis') do |t|
    t.libs << 'test'
    t.verbose = true
    t.warning = true
    t.test_files = FileList['test/test_whereis.rb']
  end

  Rake::TestTask.new('which') do |t|
    t.libs << 'test'
    t.verbose = true
    t.warning = true
    t.test_files = FileList['test/test_which.rb']
  end
end

task :default => :test
