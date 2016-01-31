#####################################################################
# test_touch.rb
#
# Test case for the File.touch method. This test should be run
# via the 'rake test_touch task'.
#####################################################################
require 'test-unit'
require 'ptools'

class TC_FileTouch < Test::Unit::TestCase
  def self.startup
    @@dirname = File.dirname(__FILE__)
    @@xfile = File.join(@@dirname, 'test_file1.txt')
    File.open(@@xfile, 'w'){ |fh| 10.times{ |n| fh.puts "line #{n}" } }
  end

  def setup
    @test_file = File.join(@@dirname, 'delete.this')
    @xfile = File.join(@@dirname, 'test_file1.txt')
  end

  def test_touch_basic
    assert_respond_to(File, :touch)
    assert_nothing_raised{ File.touch(@test_file) }
  end

  def test_touch_expected_results
    assert_equal(File, File.touch(@test_file))
    assert_equal(true, File.exist?(@test_file))
    assert_equal(0, File.size(@test_file))
  end

  def test_touch_existing_file
    stat = File.stat(@xfile)
    sleep 1
    assert_nothing_raised{ File.touch(@xfile) }
    assert_equal(true, File.size(@xfile) == stat.size)
    assert_equal(false, File.mtime(@xfile) == stat.mtime)
  end

  def test_touch_expected_errors
    assert_raises(ArgumentError){ File.touch }
  end

  def teardown
    File.delete(@test_file) if File.exist?(@test_file)
    @test_file = nil
  end

  def self.shutdown
    File.delete(@@xfile) if File.exist?(@@xfile)
  end
end
