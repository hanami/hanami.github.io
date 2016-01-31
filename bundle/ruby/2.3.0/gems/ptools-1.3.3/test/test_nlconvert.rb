#####################################################################
# test_nlconvert.rb
#
# Test case for the File.nl_convert method. You should run this
# test via the 'rake test_nlconvert' task.
#####################################################################
require 'rubygems'
require 'test-unit'
require 'ptools'

class TC_Ptools_NLConvert < Test::Unit::TestCase
  def self.startup
    @@dirname = File.dirname(__FILE__)
    @@test_file1 = File.join(@@dirname, 'test_nl_convert1.txt')
    @@test_file2 = File.join(@@dirname, 'test_nl_convert2.txt')
    File.open(@@test_file1, 'w'){ |fh| 10.times{ |n| fh.puts "line #{n}" } }
    File.open(@@test_file2, 'w'){ |fh| 10.times{ |n| fh.puts "line #{n}" } }
  end

  def setup
    @test_file1 = File.join(@@dirname, 'test_nl_convert1.txt')
    @test_file2 = File.join(@@dirname, 'test_nl_convert2.txt')
    @dos_file   = File.join(@@dirname, 'dos_test_file.txt')
    @mac_file   = File.join(@@dirname, 'mac_test_file.txt')
    @unix_file  = 'nix_test_file.txt'
  end

  test "nl_for_platform basic functionality" do
    assert_respond_to(File, :nl_for_platform)
  end

  test "nl_for_platform" do
    assert_equal( "\cM\cJ", File.nl_for_platform('dos') )
    assert_equal( "\cJ",    File.nl_for_platform('unix') )
    assert_equal( "\cM",    File.nl_for_platform('mac') )
    assert_nothing_raised{ File.nl_for_platform('local') }
  end

  test "nl_convert basic functionality" do
    assert_respond_to(File, :nl_convert)
  end

  test "nl_convert accepts one, two or three arguments" do
    assert_nothing_raised{ File.nl_convert(@test_file2) }
    assert_nothing_raised{ File.nl_convert(@test_file2, @test_file2) }
    assert_nothing_raised{ File.nl_convert(@test_file2, @test_file2, "unix") }
  end

  test "nl_convert with dos platform argument works as expected" do
    msg = "dos file should be larger, but isn't"

    assert_nothing_raised{ File.nl_convert(@test_file1, @dos_file, "dos") }
    assert_true(File.size(@dos_file) > File.size(@test_file1), msg)
    assert_equal(["\cM","\cJ"], IO.readlines(@dos_file).first.split("")[-2..-1])
  end

  test "nl_convert with mac platform argument works as expected" do
    assert_nothing_raised{ File.nl_convert(@test_file1, @mac_file, 'mac') }
    assert_equal("\cM", IO.readlines(@mac_file).first.split("").last)

    omit_if(File::ALT_SEPARATOR)
    msg = "=> Mac file should be the same size (or larger), but isn't"
    assert_true(File.size(@mac_file) == File.size(@test_file1), msg)
  end

  test "nl_convert with unix platform argument works as expected" do
    msg = "unix file should be the same size (or smaller), but isn't"

    assert_nothing_raised{ File.nl_convert(@test_file1, @unix_file, "unix") }
    assert_equal("\n", IO.readlines(@unix_file).first.split("").last)

    if File::ALT_SEPARATOR
      assert_true(File.size(@unix_file) >= File.size(@test_file1), msg)
    else
      assert_true(File.size(@unix_file) <= File.size(@test_file1), msg)
    end
  end

  test "nl_convert requires at least one argument" do
    assert_raise(ArgumentError){ File.nl_convert }
  end

  test "nl_convert requires a valid platform string" do
    assert_raise(ArgumentError){ File.nl_convert(@test_file1, "bogus.txt", "blah") }
  end

  test "nl_convert accepts a maximum of three arguments" do
    assert_raise(ArgumentError){ File.nl_convert(@test_file1, @test_file2, 'dos', 1) }
  end

  test "nl_convert will fail on anything but plain files" do
    assert_raise(ArgumentError){ File.nl_convert(File.null_device, @test_file1) }
  end

  def teardown
    [@dos_file, @mac_file, @unix_file].each{ |file|
      File.delete(file) if File.exist?(file)
    }
    @dos_file   = nil
    @mac_file   = nil
    @unix_file  = nil
    @test_file1 = nil
    @test_file2 = nil
  end

  def self.shutdown
    File.delete(@@test_file1) if File.exist?(@@test_file1)
    File.delete(@@test_file2) if File.exist?(@@test_file2)
  end
end
