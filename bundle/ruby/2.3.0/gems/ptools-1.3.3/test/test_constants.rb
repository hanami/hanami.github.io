#####################################################################
# test_constants.rb
#
# Tests the constants that have been defined for our package. This
# test case should be run via the 'rake test_constants' task.
#####################################################################
require 'rubygems'
require 'test-unit'
require 'rbconfig'
require 'ptools'

class TC_Ptools_Constants < Test::Unit::TestCase
  def self.startup
    @@windows = File::ALT_SEPARATOR
  end

  test "PTOOLS_VERSION constant is set to expected value" do
    assert_equal('1.3.3', File::PTOOLS_VERSION)
  end

  test "IMAGE_EXT constant is set to array of values" do
    assert_equal(%w[.bmp .gif .jpeg .jpg .png], File::IMAGE_EXT.sort)
  end

  test "WINDOWS constant is defined on MS Windows" do
    omit_unless(@@windows, "Skipping on Unix systems")
    assert_not_nil(File::MSWINDOWS)
  end

  test "WIN32EXTS constant is defiend on MS Windows" do
    omit_unless(@@windows, "Skipping on Unix systems")
    assert_not_nil(File::WIN32EXTS)
  end

  def self.shutdown
    @@windows = nil
  end
end
