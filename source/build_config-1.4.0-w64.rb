
MRuby::Build.new do |conf|
  toolchain :gcc
end

#
# mingw cross compile 64bit
#   "x86_64-w64-mingw32" or "i686-w64-mingw32"
#
MRuby::CrossBuild.new("i686-w64-mingw32") do |conf|
  conf.host_target = "i686-w64-mingw32"
  conf.build_target = "x86_64-apple-darwin"
  toolchain :gcc

  SDL2_CONFIG = "/usr/local/cross-tools/#{conf.host_target}/bin/sdl2-config"

  conf.gem github: 'mruby-sdl2/mruby-sdl2' do |g|
    g.cc.flags << "`#{SDL2_CONFIG} --cflags`"
    g.linker.flags_before_libraries << "`#{SDL2_CONFIG} --libs`"
  end

  conf.gem github: 'mruby-sdl2/mruby-sdl2-mixer' do |g|
    g.cc.flags << "`#{SDL2_CONFIG} --cflags`"
  end

  conf.gem github: 'mruby-sdl2/mruby-sdl2-ttf' do |g|
    g.cc.flags << "`#{SDL2_CONFIG} --cflags`"
  end

  conf.gem github: 'mruby-sdl2/mruby-sdl2-image' do |g|
    g.cc.flags << "`#{SDL2_CONFIG} --cflags`"
  end

  conf.gem github: 'mruby-sdl2/mruby-sdl2-partial-rwops' do |g|
    g.cc.flags << "`#{SDL2_CONFIG} --cflags`"
  end

  conf.gem github: 'mruby-sdl2/mruby-sdl2-scene-graph' do |g|
    g.cc.flags << "`#{SDL2_CONFIG} --cflags`"
  end

  conf.gem github: 'kabies/mruby-stable-sort'

  # conf.gem :github => 'AndrewBelt/mruby-yaml' # incompatible for crosscompile
  # conf.gem :mgem => 'mruby-yaml' # incompatible 1.4.0
  conf.gem :github => 'mruby-Forum/mruby-yaml', :branch => 'fix-build'

  conf.gem :mgem => 'mruby-singleton'
  conf.gem :github => 'matsumoto-r/mruby-sleep'
  conf.gem :github => 'iij/mruby-env'
  conf.gem :github => 'iij/mruby-iijson'
  conf.gem :github => 'iij/mruby-dir'
  conf.gem :core => 'mruby-io'
  conf.gem :core => 'mruby-pack'
  conf.gem :core => 'mruby-socket'
  conf.gem :core => 'mruby-exit'
  conf.gembox 'default'

  #
  # compiler settings
  #

  conf.cc do |cc|
    cc.command = "#{conf.host_target}-gcc"
    cc.defines += %w(MRB_UTF8_STRING MRB_32BIT)
    cc.flags = %w(-O2 -std=gnu99 -Wall -Werror-implicit-function-declaration -Wdeclaration-after-statement -Wwrite-strings)
  end

  conf.archiver do |archiver|
    archiver.command = "#{conf.host_target}-ar"
  end

  conf.linker do |linker|
    linker.command = "#{conf.host_target}-gcc"
    # linker.flags << "-static"
  end

  # bintest
  conf.enable_bintest = false

  conf.exts.executable = ".exe"
end
