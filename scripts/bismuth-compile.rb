#!/usr/bin/env mruby

# example:
#    BISMUTH_LOAD_PATH=/path/to/bismuth bismuth-compile.rb test.rb
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

Dotenv.load

file = ARGV[0]
if file.to_s.empty? and File.exists? "main.rb"
  file = "main.rb"
end
if file.to_s.empty?
  STDERR.puts "file not specified"
  exit 1
end

load_path = %w(./ src) + ENV['BISMUTH_LOAD_PATH'].split(':')
u = BismuthCompile.new file, load_path
u.run
File.open("tmp/index.json","w"){|f| f.write u.index.to_json }
puts "total #{u.line_count} lines united."
`mrbc -g -o main.mrb tmp/out.rb 2> tmp/compile_error.log`
if $? != 0
  puts "compile failed."
  puts `cat tmp/compile_error.log | mrbindex.rb`
  exit 1
end
