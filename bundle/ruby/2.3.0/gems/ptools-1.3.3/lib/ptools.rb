require 'rbconfig'
require 'win32/file' if File::ALT_SEPARATOR

class File
  # The version of the ptools library.
  PTOOLS_VERSION = '1.3.3'

  # :stopdoc:

  # The WIN32EXTS string is used as part of a Dir[] call in certain methods.
  if File::ALT_SEPARATOR
    MSWINDOWS = true
    if ENV['PATHEXT']
      WIN32EXTS = ('.{' + ENV['PATHEXT'].tr(';', ',').tr('.','') + '}').downcase
    else
      WIN32EXTS = '.{exe,com,bat}'
    end
  else
    MSWINDOWS = false
  end

  IMAGE_EXT = %w[.bmp .gif .jpg .jpeg .png]

  # :startdoc:

  # Returns whether or not the file is an image. Only JPEG, PNG, BMP and
  # GIF are checked against.
  #
  # This method does some simple read and extension checks. For a version
  # that is more robust, but which depends on a 3rd party C library (and is
  # difficult to build on MS Windows), see the 'filemagic' library.
  #
  # Examples:
  #
  #    File.image?('somefile.jpg') # => true
  #    File.image?('somefile.txt') # => false
  #--
  # The approach I used here is based on information found at
  # http://en.wikipedia.org/wiki/Magic_number_(programming)
  #
  def self.image?(file)
    bool = IMAGE_EXT.include?(File.extname(file).downcase)      # Match ext
    bool = bmp?(file) || jpg?(file) || png?(file) || gif?(file) || tiff?(file) # Check data
    bool
  end

  # Returns the name of the null device (aka bitbucket) on your platform.
  #
  # Examples:
  #
  #   # On Linux
  #   File.null # => '/dev/null'
  #
  #   # On MS Windows
  #   File.null # => 'NUL'
  #--
  # The values I used here are based on information from
  # http://en.wikipedia.org/wiki//dev/null
  #
  def self.null
    case RbConfig::CONFIG['host_os']
      when /mswin|win32|msdos|mingw|windows/i
        'NUL'
      when /amiga/i
        'NIL:'
      when /openvms/i
        'NL:'
      else
        '/dev/null'
    end
  end

  class << self
    alias null_device null
  end

  # Returns whether or not +file+ is a binary non-image file, i.e. executable,
  # shared object, ect. Note that this is NOT guaranteed to be 100% accurate.
  # It performs a "best guess" based on a simple test of the first
  # +File.blksize+ characters, or 4096, whichever is smaller.
  #
  # Example:
  #
  #   File.binary?('somefile.exe') # => true
  #   File.binary?('somefile.txt') # => false
  #--
  # Based on code originally provided by Ryan Davis (which, in turn, is
  # based on Perl's -B switch).
  #
  def self.binary?(file)
    return false if image?(file)
    bytes = File.stat(file).blksize
    bytes = 4096 if bytes > 4096
    s = (File.read(file, bytes) || "")
    s = s.encode('US-ASCII', :undef => :replace).split(//)
    ((s.size - s.grep(" ".."~").size) / s.size.to_f) > 0.30
  end

  # Looks for the first occurrence of +program+ within +path+.
  #
  # On Windows, it looks for executables ending with the suffixes defined
  # in your PATHEXT environment variable, or '.exe', '.bat' and '.com' if
  # that isn't defined, which you may optionally include in +program+.
  #
  # Returns nil if not found.
  #
  # Examples:
  #
  #   File.which('ruby') # => '/usr/local/bin/ruby'
  #   File.which('foo')  # => nil
  #
  def self.which(program, path=ENV['PATH'])
    if path.nil? || path.empty?
      raise ArgumentError, "path cannot be empty"
    end

    # Bail out early if an absolute path is provided.
    if program =~ /^\/|^[a-z]:[\\\/]/i
      program += WIN32EXTS if MSWINDOWS && File.extname(program).empty?
      found = Dir[program].first
      if found && File.executable?(found) && !File.directory?(found)
        return found
      else
        return nil
      end
    end

    # Iterate over each path glob the dir + program.
    path.split(File::PATH_SEPARATOR).each{ |dir|
      dir = File.expand_path(dir)

      next unless File.exist?(dir) # In case of bogus second argument
      file = File.join(dir, program)

      # Dir[] doesn't handle backslashes properly, so convert them. Also, if
      # the program name doesn't have an extension, try them all.
      if MSWINDOWS
        file = file.tr("\\", "/")
        file += WIN32EXTS if File.extname(program).empty?
      end

      found = Dir[file].first

      # Convert all forward slashes to backslashes if supported
      if found && File.executable?(found) && !File.directory?(found)
        found.tr!(File::SEPARATOR, File::ALT_SEPARATOR) if File::ALT_SEPARATOR
        return found
      end
    }

    nil
  end

  # Returns an array of each +program+ within +path+, or nil if it cannot
  # be found.
  #
  # On Windows, it looks for executables ending with the suffixes defined
  # in your PATHEXT environment variable, or '.exe', '.bat' and '.com' if
  # that isn't defined, which you may optionally include in +program+.
  #
  # Examples:
  #
  #   File.whereis('ruby') # => ['/usr/bin/ruby', '/usr/local/bin/ruby']
  #   File.whereis('foo')  # => nil
  #
  def self.whereis(program, path=ENV['PATH'])
    if path.nil? || path.empty?
      raise ArgumentError, "path cannot be empty"
    end

    paths = []

    # Bail out early if an absolute path is provided.
    if program =~ /^\/|^[a-z]:[\\\/]/i
      program += WIN32EXTS if MSWINDOWS && File.extname(program).empty?
      program = program.tr("\\", '/') if MSWINDOWS
      found = Dir[program]
      if found[0] && File.executable?(found[0]) && !File.directory?(found[0])
        if File::ALT_SEPARATOR
          return found.map{ |f| f.tr('/', "\\") }
        else
          return found
        end
      else
        return nil
      end
    end

    # Iterate over each path glob the dir + program.
    path.split(File::PATH_SEPARATOR).each{ |dir|
      next unless File.exist?(dir) # In case of bogus second argument
      file = File.join(dir, program)

      # Dir[] doesn't handle backslashes properly, so convert them. Also, if
      # the program name doesn't have an extension, try them all.
      if MSWINDOWS
        file = file.tr("\\", "/")
        file += WIN32EXTS if File.extname(program).empty?
      end

      found = Dir[file].first

      # Convert all forward slashes to backslashes if supported
      if found && File.executable?(found) && !File.directory?(found)
        found.tr!(File::SEPARATOR, File::ALT_SEPARATOR) if File::ALT_SEPARATOR
        paths << found
      end
    }

    paths.empty? ? nil : paths.uniq
  end

  # In block form, yields the first +num_lines+ from +filename+.  In non-block
  # form, returns an Array of +num_lines+
  #
  # Examples:
  #
  #  # Return an array
  #  File.head('somefile.txt') # => ['This is line1', 'This is line2', ...]
  #
  #  # Use a block
  #  File.head('somefile.txt'){ |line| puts line }
  #
  def self.head(filename, num_lines=10)
    a = []

    IO.foreach(filename){ |line|
      break if num_lines <= 0
      num_lines -= 1
      if block_given?
        yield line
      else
        a << line
      end
    }

    return a.empty? ? nil : a # Return nil in block form
  end

  # In block form, yields the last +num_lines+ of file +filename+.
  # In non-block form, it returns the lines as an array.
  #
  # Example:
  #
  #   File.tail('somefile.txt') # => ['This is line7', 'This is line8', ...]
  #
  # If you're looking for tail -f functionality, please use the file-tail
  # gem instead.
  #
  #--
  # Internally I'm using a 64 chunk of memory at a time. I may allow the size
  # to be configured in the future as an optional 3rd argument.
  #
  def self.tail(filename, num_lines=10)
    tail_size = 2**16 # 64k chunks

    # MS Windows gets unhappy if you try to seek backwards past the
    # end of the file, so we have some extra checks here and later.
    file_size  = File.size(filename)
    read_bytes = file_size % tail_size
    read_bytes = tail_size if read_bytes == 0

    line_sep = File::ALT_SEPARATOR ? "\r\n" : "\n"

    buf = ''

    # Open in binary mode to ensure line endings aren't converted.
    File.open(filename, 'rb'){ |fh|
      position = file_size - read_bytes # Set the starting read position

      # Loop until we have the lines or run out of file
      while buf.scan(line_sep).size <= num_lines and position >= 0
        fh.seek(position, IO::SEEK_SET)
        buf = fh.read(read_bytes) + buf
        read_bytes = tail_size
        position -= read_bytes
      end
    }

    lines = buf.split(line_sep).pop(num_lines)

    if block_given?
      lines.each{ |line| yield line  }
    else
      lines
    end
  end

  # Converts a text file from one OS platform format to another, ala
  # 'dos2unix'. The possible values for +platform+ include:
  #
  # * MS Windows -> dos, windows, win32, mswin
  # * Unix/BSD   -> unix, linux, bsd, osx, darwin, sunos, solaris
  # * Mac        -> mac, macintosh, apple
  #
  # You may also specify 'local', in which case your CONFIG['host_os'] value
  # will be used. This is the default.
  #
  # Note that this method is only valid for an ftype of "file". Otherwise a
  # TypeError will be raised. If an invalid format value is received, an
  # ArgumentError is raised.
  #
  def self.nl_convert(old_file, new_file = old_file, platform = 'local')
    unless File::Stat.new(old_file).file?
      raise ArgumentError, 'Only valid for plain text files'
    end

    format = nl_for_platform(platform)

    orig = $\ # $OUTPUT_RECORD_SEPARATOR
    $\ = format

    if old_file == new_file
      require 'fileutils'
      require 'tempfile'

      begin
        temp_name = Time.new.strftime("%Y%m%d%H%M%S")
        tf = Tempfile.new('ruby_temp_' + temp_name)
        tf.open

        IO.foreach(old_file){ |line|
          line.chomp!
          tf.print line
        }
      ensure
        tf.close if tf && !tf.closed?
      end

      File.delete(old_file)
      FileUtils.mv(tf.path, old_file)
    else
      begin
        nf = File.new(new_file, 'w')
        IO.foreach(old_file){ |line|
          line.chomp!
          nf.print line
        }
      ensure
        nf.close if nf && !nf.closed?
      end
    end

    $\ = orig
    self
  end

  # Changes the access and modification time if present, or creates a 0
  # byte file +filename+ if it doesn't already exist.
  #
  def self.touch(filename)
    if File.exist?(filename)
      time = Time.now
      File.utime(time, time, filename)
    else
      File.open(filename, 'w'){}
    end
    self
  end

  # With no arguments, returns a four element array consisting of the number
  # of bytes, characters, words and lines in filename, respectively.
  #
  # Valid options are 'bytes', 'characters' (or just 'chars'), 'words' and
  # 'lines'.
  #
  def self.wc(filename, option='all')
    option.downcase!
    valid = %w/all bytes characters chars lines words/

    unless valid.include?(option)
      raise ArgumentError, "Invalid option: '#{option}'"
    end

    n = 0

    if option == 'lines'
      IO.foreach(filename){ n += 1 }
      return n
    elsif option == 'bytes'
      File.open(filename){ |f|
        f.each_byte{ n += 1 }
      }
      return n
    elsif option == 'characters' || option == 'chars'
      File.open(filename){ |f|
        while f.getc
          n += 1
        end
      }
      return n
    elsif option == 'words'
      IO.foreach(filename){ |line|
        n += line.split.length
      }
      return n
    else
      bytes,chars,lines,words = 0,0,0,0
      IO.foreach(filename){ |line|
        lines += 1
        words += line.split.length
        chars += line.split('').length
      }
      File.open(filename){ |f|
        while f.getc
          bytes += 1
        end
      }
      return [bytes,chars,words,lines]
    end
  end

  # Already provided by win32-file on MS Windows
  unless respond_to?(:sparse?)
    # Returns whether or not +file+ is a sparse file.
    #
    # A sparse file is a any file where its size is greater than the number
    # of 512k blocks it consumes, i.e. its apparent and actual file size is
    # not the same.
    #
    # See http://en.wikipedia.org/wiki/Sparse_file for more information.
    #
    def self.sparse?(file)
      stats = File.stat(file)
      stats.size > stats.blocks * 512
    end
  end

  private

  def self.nl_for_platform(platform)
    platform = RbConfig::CONFIG["host_os"] if platform == 'local'

    case platform
      when /dos|windows|win32|mswin|mingw/i
        return "\cM\cJ"
      when /unix|linux|bsd|cygwin|osx|darwin|solaris|sunos/i
        return "\cJ"
      when /mac|apple|macintosh/i
        return "\cM"
      else
        raise ArgumentError, "Invalid platform string"
    end
  end

  def self.bmp?(file)
    IO.read(file, 3) == "BM6"
  end

  def self.jpg?(file)
    IO.read(file, 10, nil, :encoding => 'binary') == "\377\330\377\340\000\020JFIF".force_encoding(Encoding::BINARY)
  end

  def self.png?(file)
    IO.read(file, 4, nil, :encoding => 'binary') == "\211PNG".force_encoding(Encoding::BINARY)
  end

  def self.gif?(file)
    ['GIF89a', 'GIF97a'].include?(IO.read(file, 6))
  end

  def self.tiff?(file)
    return false if File.size(file) < 12

    bytes = IO.read(file, 4)

    # II is Intel, MM is Motorola
    if bytes[0..1] != 'II'&& bytes[0..1] != 'MM'
      return false
    end

    if bytes[0..1] == 'II' && bytes[2..3].ord != 42
      return false
    end

    if bytes[0..1] == 'MM' && bytes[2..3].reverse.ord != 42
      return false
    end

    true
  end
end
