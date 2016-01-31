#####################################################################
# test_null.rb
# 
# Test case for the File.null method. You should run this test via
# the 'rake test_null' task.
#####################################################################
require 'rubygems'
gem 'test-unit'

require 'test/unit'
require 'ptools'

class TC_FileNull < Test::Unit::TestCase
  def setup
    @nulls = ['/dev/null', 'NUL', 'NIL:', 'NL:']
  end

  test "null method basic functionality" do
    assert_respond_to(File, :null)
    assert_nothing_raised{ File.null }
  end

  test "null method returns expected results" do
    assert_kind_of(String, File.null)
    assert(@nulls.include?(File.null))
  end

  test "null method does not accept any arguments" do
    assert_raises(ArgumentError){ File.null(1) }
  end

  test "null_device is an alias for null" do
    assert_respond_to(File, :null_device)
    assert_alias_method(File, :null_device, :null)
  end

  def teardown
    @nulls = nil
  end
end
