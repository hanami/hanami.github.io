require 'rubygems'
require 'rbconfig'

Gem::Specification.new do |gem|
  gem.name       = 'ptools'
  gem.version    = '1.3.2'
  gem.license    = 'Artistic 2.0'
  gem.author     = 'Daniel J. Berger'
  gem.email      = 'djberg96@gmail.com'
  gem.homepage   = 'https://github.com/djberg96/ptools'
  gem.summary    = 'Extra methods for the File class'
  gem.test_files = Dir['test/test*']
  gem.files      = Dir['**/*'] << '.gemtest'

  gem.extra_rdoc_files  = ['README', 'CHANGES', 'MANIFEST']

  gem.description = <<-EOF
    The ptools (power tools) library provides several handy methods to
    Ruby's core File class, such as File.which for finding executables,
    File.null to return the null device on your platform, and so on.
  EOF

  gem.add_development_dependency('rake')
  gem.add_development_dependency('test-unit', '>= 2.5.0')

  if File::ALT_SEPARATOR
    gem.platform = Gem::Platform.new(['universal', 'mingw32'])
    gem.add_dependency('win32-file', '>= 0.7.0')
  end
end
