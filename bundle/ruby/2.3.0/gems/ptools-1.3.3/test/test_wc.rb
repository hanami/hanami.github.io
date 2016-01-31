#####################################################################
# test_wc.rb
#
# Test case for the File.wc method. This test should be run via
# the 'rake test_wc' task.
#####################################################################
require 'test-unit'
require 'ptools'

class TC_FileWC < Test::Unit::TestCase
  def self.startup
    Dir.chdir('test') if File.exist?('test')
    File.open('test_file1.txt', 'w'){ |fh| 25.times{ |n| fh.puts "line#{n+1}" } }
    @@test_file = 'test_file1.txt'
  end

  def setup
    @test_file = 'test_file1.txt'
  end

  test "wc method basic functionality" do
    assert_respond_to(File, :wc)
    assert_nothing_raised{ File.wc(@test_file) }
  end

  test "wc accepts specific optional arguments" do
    assert_nothing_raised{ File.wc(@test_file, 'bytes') }
    assert_nothing_raised{ File.wc(@test_file, 'chars') }
    assert_nothing_raised{ File.wc(@test_file, 'words') }
    assert_nothing_raised{ File.wc(@test_file, 'lines') }
  end

  test "argument to wc ignores the case of the option argument" do
    assert_nothing_raised{ File.wc(@test_file, 'LINES') }
  end

  test "wc with no option returns expected results" do
    assert_kind_of(Array, File.wc(@test_file))
    assert_equal([166,166,25,25], File.wc(@test_file))
  end

  test "wc with bytes option returns the expected result" do
    assert_equal(166, File.wc(@test_file, 'bytes'), "Wrong number of bytes")
  end

  test "wc with chars option returns the expected result" do
    assert_equal(166, File.wc(@test_file, 'chars'), "Wrong number of chars")
  end

  test "wc with words option returns the expected result" do
    assert_equal(25, File.wc(@test_file, 'words'), "Wrong number of words")
  end

  test "wc with lines option returns the expected result" do
    assert_equal(25, File.wc(@test_file, 'lines'), "Wrong number of lines")
  end

  test "wc requires at least on argument" do
    assert_raises(ArgumentError){ File.wc }
  end

  test "an invalid option raises an error" do
    assert_raises(ArgumentError){ File.wc(@test_file, 'bogus') }
  end

  def teardown
    @test_file = nil
  end

  def self.shutdown
    File.delete(@@test_file) if File.exist?(@@test_file)
  end
end
