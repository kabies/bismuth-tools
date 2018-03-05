
FourCC = "CNBR"
VERSION = 1

dir = ARGV[0]
target_dir = File.join dir, "assets"

file_list = []
Dir.foreach(target_dir){|f|
  next if f[0] == "."
  file = File.join target_dir, f
  if File.exist?(file) and File.file?(file)
    file_list << [f,File::size(file)]
  end
}

archive = File.open "archive", "w"

archive.write FourCC
archive.write [VERSION].pack "V"
archive.write [file_list.size].pack "V"
file_start = 0
file_list.each{|f,size|
  filename_length = f.size
  p [size, file_start, filename_length, f]
  archive.write [size, file_start, filename_length].pack "VVV"
  archive.write f
  file_start += size
}

file_list.each{|f,size|
  file = File.join target_dir, f
  dat = File.read file
  archive.write dat
}

archive.close
