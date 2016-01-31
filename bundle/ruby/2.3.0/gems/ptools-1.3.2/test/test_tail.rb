#####################################################################
# test_tail.rb
#
# Test case for the File.tail method. This test should be run via
# the 'rake test_tail' task.
#####################################################################
require 'test-unit'
require 'ptools'

class TC_FileTail < Test::Unit::TestCase
  def self.startup
    @@dirname = File.dirname(__FILE__)

    @@test_file1   = File.join(@@dirname, 'test_file1.txt')
    @@test_file64  = File.join(@@dirname, 'test_file64.txt')
    @@test_file128 = File.join(@@dirname, 'test_file128.txt')

    @@test_file_trail = File.join(@@dirname, 'test_file_trail.txt')
    @@test_file_trail_nl = File.join(@@dirname, 'test_file_trail_nl.txt')

    File.open(@@test_file1, 'w'){ |fh|
      25.times{ |n| fh.puts "line#{n+1}" }
    }

    # Trailing newline test
    File.open(@@test_file_trail, 'w'){ |fh|
      2.times{ |n| fh.puts "trail#{n+1}" }
      fh.write "trail3"
    }
    File.open(@@test_file_trail_nl, 'w'){ |fh|
      3.times{ |n| fh.puts "trail#{n+1}" }
    }

    # Larger files
    test_tail_fmt_str = "line data data data data data data data %5s"

    File.open(@@test_file64, 'w'){ |fh|
      2000.times{ |n|
        fh.puts test_tail_fmt_str % (n+1).to_s
      }
    }

    File.open(@@test_file128, 'w'){ |fh|
      4500.times{ |n|
        fh.puts test_tail_fmt_str % (n+1).to_s
      }
    }
  end

  def setup
    @test_file     = @@test_file1
    @test_trail    = @@test_file_trail
    @test_trail_nl = @@test_file_trail_nl
    @test_file_64  = @@test_file64
    @test_file_128 = @@test_file128

    @expected_tail1 = %w{
      line16 line17 line18 line19 line20
      line21 line22 line23 line24 line25
    }

    @expected_tail2 = ["line21","line22","line23","line24","line25"]

    @expected_tail_more = []
    25.times{ |n| @expected_tail_more.push "line#{n+1}" }

    @expected_tail_trail = %w{ trail2 trail3 }

    @test_tail_fmt_str = "line data data data data data data data %5s"
  end

  def test_tail_basic
    assert_respond_to(File, :tail)
    assert_nothing_raised{ File.tail(@test_file) }
    assert_nothing_raised{ File.tail(@test_file, 5) }
    assert_nothing_raised{ File.tail(@test_file){} }
  end

  def test_tail_expected_return_values
    assert_kind_of(Array, File.tail(@test_file))
    assert_equal(@expected_tail1, File.tail(@test_file))
    assert_equal(@expected_tail2, File.tail(@test_file, 5))
  end

  def test_more_lines_than_file
    assert_equal( @expected_tail_more, File.tail(@test_file, 30) )
  end

  def test_tail_expected_errors
    assert_raises(ArgumentError){ File.tail }
    assert_raises(ArgumentError){ File.tail(@test_file, 5, 5) }
  end

  def test_no_trailing_newline
    assert_equal( @expected_tail_trail, File.tail(@test_trail, 2) )
    assert_equal( @expected_tail_trail, File.tail(@test_trail_nl, 2) )
  end

  def test_tail_larger_than_64k
    expected_tail_64k=[]
    2000.times{ |n| expected_tail_64k.push( @test_tail_fmt_str % (n+1).to_s ) }
    assert_equal( expected_tail_64k, File.tail(@test_file_64, 2000) )
  end

  def test_tail_larger_than_128k
    expected_tail_128k = []
    4500.times{ |n| expected_tail_128k.push( @test_tail_fmt_str % (n+1).to_s ) }
    assert_equal( expected_tail_128k, File.tail(@test_file_128, 4500) )
  end

  def teardown
    @test_file = nil
    @expected_tail1 = nil
    @expected_tail2 = nil
  end

  def self.shutdown
    File.delete(@@test_file1) if File.exist?(@@test_file1)
    File.delete(@@test_file64) if File.exist?(@@test_file64)
    File.delete(@@test_file128) if File.exist?(@@test_file128)
    File.delete(@@test_file_trail_nl) if File.exist?(@@test_file_trail_nl)
    File.delete(@@test_file_trail) if File.exist?(@@test_file_trail)
  end
end
