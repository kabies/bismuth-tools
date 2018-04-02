#!/usr/bin/env mruby
FourCC = "BIAR"
VERSION = 1

class Unarchiver
  def initialize(archivename)
    File.open(archivename, "r"){|archive|
      four_cc = archive.sysread(4)
      version = archive.sysread(4).unpack("V").first
      if four_cc != FourCC or version != 1
        raise "version error: #{four_cc} #{version}"
      end
      @list_size = archive.sysread(4).unpack("V").first
      # puts "list size #{@list_size}"
      @file_addresses = {}
      @data_start = 4 + 4 + 4 # four_cc + version + list_size
      @list_size.times do
        tmp = archive.sysread(4*3)
        @data_start += 4*3
        # p [:data_start, @data_start, :archive_tell, archive.pos]
        size, file_start, filename_length = tmp.unpack("VVV")
        filename = archive.sysread(filename_length)
        # p [size, file_start, filename_length, filename.length, filename[0..30]]
        @file_addresses[filename] = [file_start,size]
        @data_start += filename_length
      end

      @files = {}
      @file_addresses.each{|name,address|
        start = address.first
        size = address.last
        pos = (@data_start+start).to_i
        archive.seek( pos, 0)
        # p [pos, archive.tell]
        @files[name] = archive.sysread size
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
