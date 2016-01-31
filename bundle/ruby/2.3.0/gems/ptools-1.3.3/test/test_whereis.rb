######################################################################
# test_whereis.rb
#
# Tests for the File.whereis method.
######################################################################
require 'rubygems'
require 'test-unit'
require 'ptools'
require 'rbconfig'

class TC_Ptools_Whereis < Test::Unit::TestCase
  def self.startup
    @@windows = File::ALT_SEPARATOR
    @@ruby = RUBY_PLATFORM == 'java' ? 'jruby' : 'ruby'
  end

  def setup
    @bin_dir = RbConfig::CONFIG['bindir']
    @expected_locs = [File.join(@bin_dir, @@ruby)]

    if @@windows
      @expected_locs[0] << '.exe'
      @expected_locs[0].tr!("/", "\\")
    end

    unless @@windows
      @expected_locs << "/usr/local/bin/#{@@ruby}"
      @expected_locs << "/opt/sfw/bin/#{@@ruby}"
      @expected_locs << "/opt/bin/#{@@ruby}"
      @expected_locs << "/usr/bin/#{@@ruby}"
    end

    @actual_locs = nil
  end

  test "whereis basic functionality" do
    assert_respond_to(File, :whereis)
    assert_nothing_raised{ File.whereis('ruby') }
    assert_kind_of([Array, NilClass], File.whereis('ruby'))
  end

  test "whereis accepts an optional second argument" do
    assert_nothing_raised{ File.whereis('ruby', '/usr/bin:/usr/local/bin') }
  end

  test "whereis returns expected values" do
    assert_nothing_raised{ @actual_locs = File.whereis(@@ruby) }
    assert_kind_of(Array, @actual_locs)
    assert_true((@expected_locs & @actual_locs).size > 0)
  end

  test "whereis returns nil if program not found" do
    assert_nil(File.whereis('xxxyyy'))
  end

  test "whereis returns nil if program cannot be found in provided path" do
    assert_nil(File.whereis(@@ruby, '/foo/bar'))
  end

  test "whereis returns single element array or nil if absolute path is provided" do
    absolute = File.join(@bin_dir, @@ruby)
    absolute << '.exe' if @@windows

    assert_equal([absolute], File.whereis(absolute))
    assert_nil(File.whereis("/foo/bar/baz/#{@@ruby}"))
  end

  test "whereis works with an explicit extension on ms windows" do
    omit_unless(@@windows, 'test skipped except on MS Windows')
    assert_not_nil(File.whereis(@@ruby + '.exe'))
  end

  test "whereis requires at least one argument" do
    assert_raise(ArgumentError){ File.whereis }
  end

  test "whereis returns unique paths only" do
    assert_true(File.whereis(@@ruby) == File.whereis(@@ruby).uniq)
  end

  test "whereis accepts a maximum of two arguments" do
    assert_raise(ArgumentError){ File.whereis(@@ruby, 'foo', 'bar') }
  end

  test "the second argument to whereis cannot be nil or empty" do
    assert_raise(ArgumentError){ File.whereis(@@ruby, nil) }
    assert_raise(ArgumentError){ File.whereis(@@ruby, '') }
  end

  def teardown
    @expected_locs = nil
    @actual_locs = nil
  end

  def self.shutdown
    @@windows = nil
  end
end
