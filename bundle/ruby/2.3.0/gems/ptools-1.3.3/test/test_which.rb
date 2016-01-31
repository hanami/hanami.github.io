#####################################################################
# test_which.rb
#
# Test case for the File.which method. You should run this test
# via the 'rake test_which' rake task.
#
# NOTE: I make the assumption that Ruby (or JRuby) is in your
# PATH for these tests.
#####################################################################
require 'test-unit'
require 'rbconfig'
require 'fileutils'
require 'ptools'
require 'tempfile'

class TC_FileWhich < Test::Unit::TestCase
  def self.startup
    @@windows = File::ALT_SEPARATOR
    @@dir = File.join(Dir.pwd, 'tempdir')
    @@non_exe = File.join(Dir.pwd, 'tempfile')

    Dir.mkdir(@@dir) unless File.exist?(@@dir)
    FileUtils.touch(@@non_exe)
    File.chmod(775, @@dir)
    File.chmod(644, @@non_exe)
  end

  def setup
    @ruby = RUBY_PLATFORM.match('java') ? 'jruby' : 'ruby'
    @ruby = 'rbx' if defined?(Rubinius)

    @exe = File.join(
      RbConfig::CONFIG['bindir'],
      RbConfig::CONFIG['ruby_install_name']
    )

    if @@windows
      @exe.tr!('/','\\')
      @exe << ".exe"
    end
  end

  test "which method basic functionality" do
    assert_respond_to(File, :which)
    assert_nothing_raised{ File.which(@ruby) }
    assert_kind_of(String, File.which(@ruby))
  end

  test "which accepts an optional path to search" do
    assert_nothing_raised{ File.which(@ruby, "/usr/bin:/usr/local/bin") }
  end

  test "which returns nil if not found" do
    assert_equal(nil, File.which(@ruby, '/bogus/path'))
    assert_equal(nil, File.which('blahblahblah'))
  end

  test "which handles executables without extensions on windows" do
    omit_unless(@@windows, "test skipped unless MS Windows")
    assert_not_nil(File.which('ruby'))
    assert_not_nil(File.which('notepad'))
  end

  test "which handles executables that already contain extensions on windows" do
    omit_unless(@@windows, "test skipped unless MS Windows")
    assert_not_nil(File.which('ruby.exe'))
    assert_not_nil(File.which('notepad.exe'))
  end

  test "which returns argument if an existent absolute path is provided" do
    assert_equal(@exe, File.which(@ruby), "=> May fail on a symlink")
  end

  test "which returns nil if a non-existent absolute path is provided" do
    assert_nil(File.which('/foo/bar/baz/ruby'))
  end

  test "which does not pickup files that are not executable" do
    assert_nil(File.which(@@non_exe))
  end

  test "which does not pickup executable directories" do
    assert_nil(File.which(@@dir))
  end

  test "which accepts a minimum of one argument" do
    assert_raises(ArgumentError){ File.which }
  end

  test "which accepts a maximum of two arguments" do
    assert_raises(ArgumentError){ File.which(@ruby, "foo", "bar") }
  end

  test "the second argument cannot be nil or empty" do
    assert_raises(ArgumentError){ File.which(@ruby, nil) }
    assert_raises(ArgumentError){ File.which(@ruby, '') }
  end

  test "resolves with with ~" do
    omit_if(@@windows, "~ tests skipped on MS Windows")
    begin
      old_home = ENV['HOME']

      ENV['HOME'] = Dir::Tmpname.tmpdir
      program = Tempfile.new(['program', '.sh'])
      File.chmod(755, program.path)

      assert_not_nil(File.which(File.basename(program.path), '~/'))
    ensure
      ENV['HOME'] = old_home
    end
  end

  def teardown
    @exe  = nil
    @ruby = nil
  end

  def self.shutdown
    FileUtils.rm(@@non_exe)
    FileUtils.rm_rf(@@dir)
    @@windows = nil
    @@dir = nil
    @@non_exe = nil
  end
end
