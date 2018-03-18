#!/usr/bin/env mruby

file = ARGV[0]

if file.to_s.end_with? ".rb"
  puts `bismuth-compile.rb #{file}`
  file = "main.mrb"
end

if file.to_s.empty? and File.exist? "main.mrb"
  file = "main.mrb"
end

unless file
  STDERR.puts "file not specified."
  exit 1
end

error_logs = []
IO.pipe do |r, w|
  # p [Time.now, :start, file]
  IO.popen("mruby -b #{file}", "r", err: w) do |i|
    loop do
      STDOUT.write i.readline
    end
  rescue EOFError => e
    # done
  end
  # p [Time.now, :done]
  w.close
  r.each_line{|l|
    error_logs << l
  }
end

messages = []
error_logs.each{|l|
  print "< #{l}"
  m = l.chomp.split(":")
  if m.size < 2
    # print "< #{l}"
  else
    messages << [ m[1].to_i, m[2..-1].join(':') ]
  end
}

index = []
JSON.parse(File.read("tmp/index.json")).reverse_each{|i|
  filename = i[0]
  start_line = i[1]
  end_line = i[2]

  index.fill filename, (start_line..end_line)
}

line_count = {}
index.each.with_index{|filename,i|
  line_count[filename] ||= []
  line_count[filename] << i
}

messages.each_with_index{|v,i|
  line = v[0]
  message = v[1]
  filename = index[line]
  original_line_number = line_count[filename].index line
  puts "#{filename}:#{original_line_number}:#{message}"
}
