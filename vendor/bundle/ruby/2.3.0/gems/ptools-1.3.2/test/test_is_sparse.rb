#####################################################################
# test_is_sparse.rb
#
# Test case for the File.sparse? method. You should run this test
# via the 'rake test:is_sparse' task.
#####################################################################
require 'test-unit'
require 'ptools'

class TC_IsSparse < Test::Unit::TestCase
  def self.startup
    Dir.chdir("test") if File.exist?("test")
    @@win = File::ALT_SEPARATOR
    @@osx = RbConfig::CONFIG['host_os'] =~ /darwin|osx/i
    system("dd of=test_sparse bs=1k seek=5120 count=0 2>/dev/null") unless @@win
  end

  def setup
    @sparse_file = 'test_sparse'
    @non_sparse_file = File.expand_path(File.basename(__FILE__))
  end

  test "is_sparse basic functionality" do
    omit_if(@@win, "File.sparse? tests skipped on MS Windows")
    omit_if(@@osx, "File.sparse? tests skipped on OS X")

    assert_respond_to(File, :sparse?)
    assert_nothing_raised{ File.sparse?(@sparse_file) }
    assert_boolean(File.sparse?(@sparse_file))
  end

  test "is_sparse returns the expected results" do
    omit_if(@@win, "File.sparse? tests skipped on MS Windows")
    omit_if(@@osx, "File.sparse? tests skipped on OS X")

    assert_true(File.sparse?(@sparse_file))
    assert_false(File.sparse?(@non_sparse_file))
  end

  test "is_sparse only accepts one argument" do
    omit_if(@@win, "File.sparse? tests skipped on MS Windows")
    assert_raise(ArgumentError){ File.sparse?(@sparse_file, @sparse_file) }
  end

  def teardown
    @sparse_file = nil
    @non_sparse_file = nil
  end

  def self.shutdown
    File.delete('test_sparse') if File.exist?('test_sparse')
  end
end
