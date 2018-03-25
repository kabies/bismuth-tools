#!/usr/bin/env mruby

#
# require environment variable BISMUTH_LOAD_PATH:
#   export BISMUTH_LOAD_PATH=/path/to/bismuth
#
# compile and run: bismuth.rb foobar.rb
# compile only:    bismuth.rb -c foobar.rb
# run only:        bismuth.rb foobar.mrb
#
# default compile target is "main.rb".
# default run target is "main.mrb".
#

class BismuthCompile
  attr_reader :included_files, :line_count, :index
  def initialize(mainfile,load_path)
    @mainfile = mainfile
    @load_path = load_path
    @included_files = {}
    @index = []
    @line_count = 0
  end
  def run
    if File.exists? @mainfile
      Dir.mkdir "tmp" unless File.exists? "tmp"
      @file = File.open("tmp/out.rb","w")
      read @mainfile
    end
  end
  def write(line)
    @file.puts line
    @line_count += 1
  end
  def memory(file)
    path = File.expand_path file
    return false if @included_files[path]
    @included_files[path] = true
  end
  def add_index(file,start_line,end_line)
    @index << [file,start_line,end_line]
  end
  def read(filename)
    filename = filename+".rb" unless filename.end_with? ".rb"

    filepath = nil
    @load_path.find{|l|
      f = File.join(l,filename)
      if File.exists? f
        filepath = f
        break
      end
    }

    if filepath
      puts "read #{filepath}"
    else
      puts "#{filename} not found"
      return
    end

    unless memory filepath
      puts "#{filepath} already included."
      return
    end

    s = File.read filepath
    start_line = @line_count
    s.each_line{|l|
      if l.start_with? "$LOAD_PATH"
        write "# #{l}"
      elsif l.start_with? "require"
        next_file = l.chomp
        next_file.slice! "require"
        next_file.gsub! '"', ''
        next_file.gsub! "'", ''
        next_file.gsub! ' ', ''
        write "\n"
        self.read next_file
        write "\n"
      else
        write l
      end
    }
    end_line = @line_count
    add_index filename,start_line,end_line
  end
end

class Restorer
  def initialize
    tmp = []
    JSON.parse(File.read("tmp/index.json")).reverse_each{|i|
      filename = i[0]
      start_line = i[1]
      end_line = i[2]
      tmp.fill filename, (start_line..end_line)
    }

    fileline = {}
    @index = tmp.each.with_index.map{|filename,i|
      fileline[filename] = fileline[filename].to_i + 1
      "#{filename}:#{fileline[filename]}"
    }
  end

  def restore(message)
    m = message.chomp.split(":")
    if m.size < 2
      print "#{message}"
    else
      line = m[1].to_i - 1
      text = m[2..-1].join(":")
      puts "#{@index[line]}:#{text}"
    end
  end
end

class Dotenv # pseudo Dotenv
  def self.load
    if File.exists? ".env"
      File.open(".env"){|f|
        f.each_line{|l|
          l.strip!
          next if l.empty?
          next if l.start_with? "#"
          name,value = l.split("=").map(&:strip)
          if value.start_with?('"') and value.end_with?('"')
            value = value[1..-2]
          end
          if value.start_with?("'") and value.end_with?("'")
            value = value[1..-2]
          end
          ENV[name] = value unless ENV[name]
        }
      }
    end
  end
end

def compile(file)
  return file unless file.end_with? ".rb"

  puts "#{Time.now} compile #{file}"
  load_path = %w(./ src) + ENV['BISMUTH_LOAD_PATH'].split(':')

  u = BismuthCompile.new file, load_path
  u.run
  File.open("tmp/index.json","w"){|f| f.write u.index.to_json }
  puts "total #{u.line_count} lines united."
  `mrbc -g -o main.mrb tmp/out.rb 2> tmp/compile_error.log`

  if $? != 0
    puts "compile failed..."
    r = Restorer.new
    File.open("tmp/compile_error.log","r"){|f|
      f.each_line{|l| r.restore l }
    }
    exit 1
  end

  "main.mrb"
end

def run(file)
  return file unless file.end_with? ".mrb"

  puts "#{Time.now} run #{file}"
  error_logs = []
  IO.pipe do |r, w|
    IO.popen("mruby -b #{file}", "r", err: w) do |i|
      loop do
        STDOUT.write i.readline
      end
    rescue EOFError => e
      # done
    end
    w.close
    r.each_line{|l|
      error_logs << l
    }
  end

  r = Restorer.new
  error_logs.each{|l| r.restore l }
end

if $0 == __FILE__
  Dotenv.load

  #
  # parse options
  #
  opts = {}
  if ARGV.include? "-c"
    ARGV.delete "-c"
    opts[:c] = true
  end

  #
  # Choose file
  #
  file = ARGV[-1]
  if file.to_s.empty?
    if File.exists? "main.rb"
      file = "main.rb"
    elsif File.exists? "main.mrb"
      file = "main.mrb"
    end
  end

  if file.to_s.empty?
    STDERR.puts "file not specified"
    exit 1
  end

  if opts[:c]
    if file.end_with? ".rb"
      compile file
    else
      puts ".rb file not specified."
      exit 1
    end
  else
    run compile file
  end
end
