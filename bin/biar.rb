#!/usr/bin/env mruby

FourCC = "BIAR" # bismuth archive
VERSION = 1

dir = ARGV[0]
unless dir
  dir = "assets"
end

unless File.exists?(dir) and File.directory?(dir)
  STDERR.puts "#{dir} is not directory"
  exit 1
end

def files(dir)
  file_list = []
  if File.exists?(dir) and File.directory?(dir)
    Dir.foreach(dir){|f|
      # skip hidden files and current/parent directory
      next if f[0] == "."
      file = File.join dir, f
      if File.exist?(file)
        if File.file?(file)
          file_list << [file,File::size(file)]
        elsif File.directory?(file)
          file_list += files(file)
        end
      end
    }
  end
  file_list
end

file_list = files(dir)

File.open("assets.biar", "w") do |archive|
  archive.write FourCC
  archive.write [VERSION].pack "V"
  archive.write [file_list.size].pack "V"
  file_start = 0
  file_list.each{|filename,size|
    p [size, file_start, filename.length, filename]
    archive.write [size, file_start, filename.length].pack "VVV"
    archive.write filename
    file_start += size
  }

  file_list.each{|f,size|
    dat = File.read(f)
    archive.write dat
  }
end
