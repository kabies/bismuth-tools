#!/usr/bin/env ruby
require 'erb'
require "FileUtils"
begin
  require 'dotenv'
  Dotenv.load
rescue LoadError
end

BISMUTH_PATH = ENV['BISMUTH_PATH']
BISMUTH_TOOLS_PATH = ENV['BISMUTH_TOOLS_PATH']
CROSS_TOOLS_PATH = ENV['CROSS_TOOLS_PATH']
p [BISMUTH_PATH,BISMUTH_TOOLS_PATH]
exit if not BISMUTH_PATH or not BISMUTH_TOOLS_PATH

ROOT_DIR = File.join File.expand_path(File.dirname(__FILE__)), "../"

def build_mruby
  Dir.chdir ROOT_DIR
  repository, dir = 'https://github.com/mruby/mruby.git', 'tmp/mruby-1.4.0'
  Dir.mkdir 'tmp' unless File.exist?('tmp')
  unless File.exist?(dir)
    system "git clone -b 1.4.0 #{repository} #{dir}"
  end
  config_file = "#{BISMUTH_TOOLS_PATH}/source/build_config-1.4.0.rb"
  system(%Q[cd #{dir}; MRUBY_CONFIG=#{config_file} ruby minirake -v all])
end

def build_mruby_w64(arch="i686")
  Dir.chdir ROOT_DIR
  repository, dir = 'https://github.com/mruby/mruby.git', "tmp/mruby-1.4.0-w64"
  Dir.mkdir 'tmp' unless File.exist?('tmp')
  unless File.exist?(dir)
    system "git clone -b 1.4.0 #{repository} #{dir}"
  end
  config_file = "#{BISMUTH_TOOLS_PATH}/source/build_config-1.4.0-w64.rb"
  system(%Q[cd #{dir}; MRUBY_CONFIG=#{config_file} ruby minirake -v all])
end

def build_w64_launcher(target="i686-w64-mingw32")
  Dir.chdir ROOT_DIR
  cc = "#{target}-gcc"
  windres = "#{target}-windres"
  dir = "tmp/launcher"
  FileUtils.mkdir_p dir
  `cp icon.png #{dir}`
  `cp #{BISMUTH_TOOLS_PATH}/source/launcher.c #{dir}`
  `cp #{BISMUTH_TOOLS_PATH}/source/resource.rc #{dir}`
  Dir.chdir dir
  `convert #{ROOT_DIR}/icon32.png icon.ico`
  `#{cc} -c launcher.c -o launcher.o -Wall`
  `#{windres} -o resource.o resource.rc`
  `#{cc} launcher.o resource.o -o launcher.exe  -mwindows`
end

def build_w64_template(target="i686-w64-mingw32")
  Dir.chdir ROOT_DIR
  dir = "tmp/w64_template"
  sysdir = "tmp/w64_template/system"
  FileUtils.mkdir_p sysdir

  `cp tmp/launcher/launcher.exe #{dir}`

  dir = "tmp/mruby-1.4.0-w64/build/#{target}/bin"
  `cp #{dir}/mruby.exe #{sysdir}`
  `cp #{CROSS_TOOLS_PATH}/#{target}/bin/*.dll #{sysdir}`
  `cp #{ROOT_DIR}/main.mrb #{sysdir}`
  `cp -R #{ROOT_DIR}/assets #{sysdir}`
end

def build_macos_icon
  Dir.chdir ROOT_DIR
  FileUtils.mkdir_p 'tmp/macOS'
  Dir.chdir 'tmp/macOS'
  FileUtils.mkdir_p "icon.iconset"
  original_icon = "#{ROOT_DIR}/icon.png"
  [
    ["16x16!","16x16"],
    ["32x32!","16x16@2x"],
    ["32x32!","32x32"],
    ["64x64!","32x32@2x"],
    ["128x128!","128x128"],
    ["256x256!","128x128@2x"],
    ["256x256!","256x256"],
    ["512x512!","256x256@2x"],
    ["512x512!","512x512"],
    ["1024x1024!","512x512@2x"],
  ].each{|size,name|
    `convert -resize #{size} #{original_icon} icon.iconset/icon_#{name}.png`
  }
  `iconutil -c icns icon.iconset`
end

def build_macos_template
  Dir.chdir ROOT_DIR
  app_name = "game"
  dir = "#{app_name}.app"

  executable = "game"
  name = "game"
  identifier = "game.foo.bar"
  version = "1.0.0"
  copyright = "copyright YOURNAME 2018"

  FileUtils.mkdir_p "tmp/macOS/#{dir}"
  FileUtils.mkdir_p "tmp/macOS/#{dir}/Contents/MacOS"
  FileUtils.mkdir_p "tmp/macOS/#{dir}/Contents/Resources"
  Dir.chdir "tmp/macOS/#{dir}"
  # Info.plist
  info_plist = ERB.new(File.read("#{BISMUTH_TOOLS_PATH}/source/Info.plist.erb")).result(binding)
  # `cp #{BISMUTH_TOOLS_PATH}/source/Info.plist Contents/Info.plist`
  File.write("Contents/Info.plist", info_plist)


  # executable
  `cp #{BISMUTH_TOOLS_PATH}/source/launch.sh Contents/MacOS/#{app_name}`
  `chmod 755 Contents/MacOS/#{app_name}`
  # icon
  `cp -R #{ROOT_DIR}/tmp/macOS/icon.icns Contents/Resources/AppIcon.icns`
  # resources
  `cp -R #{ROOT_DIR}/tmp/mruby-1.4.0/build/host/bin/mruby Contents/MacOS/mruby`
  `cp -R #{ROOT_DIR}/assets Contents/Resources`
  `cp #{ROOT_DIR}/main.mrb Contents/Resources`
end

build_mruby
build_mruby_w64
build_w64_launcher
build_w64_template
build_macos_icon
build_macos_template
