#!/usr/bin/env mruby

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

def build_mingw_w64
  Dir.chdir ROOT_DIR
  target="i686-w64-mingw32"
  cc = "#{target}-gcc"
  windres = "#{target}-windres"
  dir = "tmp/mingw-w64/game"
  sysdir = "tmp/mingw-w64/game/system"
  launcher_dir = "tmp/mingw-w64/launcher"
  `mkdir -p #{sysdir}`
  `mkdir -p #{launcher_dir}`

  unless File.exists? "#{launcher_dir}/launcher.exe"
    if File.exists? "icon.ico"
      original_icon = "icon.ico"
    else
      original_icon = "#{BISMUTH_TOOLS_PATH}/source/icon.ico"
    end
    Dir.chdir(ROOT_DIR) do
      `cp #{original_icon} #{launcher_dir}`
      `cp #{BISMUTH_TOOLS_PATH}/source/launcher.c #{launcher_dir}`
      `cp #{BISMUTH_TOOLS_PATH}/source/resource.rc #{launcher_dir}`
      Dir.chdir(launcher_dir) do
        `#{cc} -c launcher.c -o launcher.o -Wall`
        `#{windres} -o resource.o resource.rc`
        `#{cc} launcher.o resource.o -o launcher.exe  -mwindows`
      end
    end
  end

  `cp #{launcher_dir}/launcher.exe #{dir}/game.exe`

  `cp #{BISMUTH_TOOLS_PATH}/build/mingw-w64/build/#{target}/bin/mruby.exe #{sysdir}`
  `cp #{CROSS_TOOLS_PATH}/#{target}/bin/*.dll #{sysdir}`
  `cp main.mrb #{sysdir}`
  `cp -R assets #{sysdir}`
end

def build_macos
  Dir.chdir ROOT_DIR
  app_name = "game"
  dir = "tmp/macOS/#{app_name}.app"

  executable = "game"
  name = "game"
  identifier = "game.foo.bar"
  version = "1.0.0"
  copyright = "copyright YOURNAME 2018"

  `mkdir -p #{dir}/Contents/MacOS`
  `mkdir -p #{dir}/Contents/Resources`
  `mkdir -p #{dir}/Contents/Frameworks`

  # Info.plist
  `cp #{BISMUTH_TOOLS_PATH}/source/Info.plist #{dir}/Contents/Info.plist`

  # executable
  `cp #{BISMUTH_TOOLS_PATH}/source/launch.sh #{dir}/Contents/MacOS/#{app_name}`
  `chmod 755 #{dir}/Contents/MacOS/#{app_name}`

  # icon
  unless File.exists? "tmp/macOS/icon.icns"
    `mkdir -p tmp/macOS/icon.iconset`
    if File.exists? "icon.png"
      original_icon = "icon.png"
    else
      original_icon = "#{BISMUTH_TOOLS_PATH}/source/icon.png"
    end
    [
      ["16 16","16x16"],
      ["32 32","16x16@2x"],
      ["32 32","32x32"],
      ["64 64","32x32@2x"],
      ["128 128","128x128"],
      ["256 256","128x128@2x"],
      ["256 256","256x256"],
      ["512 512","256x256@2x"],
      ["512 512","512x512"],
      ["1024 1024","512x512@2x"],
    ].each{|size,name|
      `sips -z #{size} #{original_icon} --out tmp/macOS/icon.iconset/icon_#{name}.png`
    }
    `iconutil -c icns tmp/macOS/icon.iconset`
  end

  `cp -R tmp/macOS/icon.icns #{dir}/Contents/Resources/AppIcon.icns`
  # resources
  `cp -R #{BISMUTH_TOOLS_PATH}/build/macos/build/host/bin/mruby #{dir}/Contents/MacOS/mruby`
  `cp -R assets #{dir}/Contents/Resources`
  `cp main.mrb #{dir}/Contents/Resources`
  # Frameworks
  [
    'SDL2',
    'SDL2_image',
    'SDL2_ttf',
    'SDL2_mixer'
  ].each{|f|
    unless File.exists? "#{dir}/Contents/Frameworks/#{f}.framework"
      `cp -R #{FRAMEWORKS_PATH}/#{f}.framework #{dir}/Contents/Frameworks`
    end
    original_path = "@rpath/#{f}.framework/Versions/A/#{f}"
    bundled_path = "@executable_path/../Frameworks/#{f}.framework/Versions/A/#{f}"
    `install_name_tool -change #{original_path} #{bundled_path} #{dir}/Contents/MacOS/mruby`
  }
  puts `otool -L #{dir}/Contents/MacOS/mruby`
end

if $0==__FILE__
  Dotenv.load

  BISMUTH_TOOLS_PATH = ENV['BISMUTH_TOOLS_PATH']
  CROSS_TOOLS_PATH = ENV['CROSS_TOOLS_PATH']
  FRAMEWORKS_PATH = ENV['FRAMEWORKS_PATH']

  exit unless BISMUTH_TOOLS_PATH

  ROOT_DIR = File.expand_path("./")

  case ARGV[0]
  when 'macos'
    build_macos
  when 'mingw-w64'
    build_mingw_w64
  end
end
