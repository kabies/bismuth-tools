#!/usr/bin/env mruby
FourCC = "CNBR"
VERSION = 1

class Unarchiver
  def initialize(archivename)
    File.open(archivename, "r"){|archive|
      four_cc = archive.read(4)
      version = archive.read(4).unpack("V").first
      if four_cc != FourCC or version != 1
        raise "version error: #{four_cc} #{version}"
      end
      @list_size = archive.read(4).unpack("V").first
      # puts "list size #{@list_size}"
      @file_addresses = {}
      @data_start = 4 + 4 + 4 # four_cc + version + list_size
      @list_size.times do
        size, file_start, filename_length = archive.read(4*3).unpack("VVV")
        # p [size, file_start, filename_length]
        filename = archive.read(filename_length)
        @file_addresses[filename] = [file_start,size]
        @data_start += 4*3 + filename_length
      end

      # XXX: mruby-io incorrect tell...
      # @data_start = archive.tell
      # puts "tell:#{archive.tell} data start at #{@data_start}"

      @files = {}
      @file_addresses.each{|name,address|
        start = address.first
        size = address.last
        pos = (@data_start+start).to_i
        archive.seek( pos, 0)
        p [pos, archive.tell]
        @files[name] = archive.read size
      }
    }
  end
  def files()
    @file_addresses
  end
  def write(filename)
    File.open(filename,"w"){|f|
      puts @files[filename].length
      puts f.write @files[filename]
    }
  end
end

archivename = ARGV[0]
filename = ARGV[1]
u = Unarchiver.new archivename
if filename
  u.write filename
else
  p u.files
end
