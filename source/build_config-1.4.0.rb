MRuby::Build.new do |conf|
  toolchain :gcc
  conf.enable_test

  conf.gem github: 'mruby-sdl2/mruby-sdl2'
  conf.gem github: 'mruby-sdl2/mruby-sdl2-scene-graph'
  conf.gem github: 'mruby-sdl2/mruby-sdl2-partial-rwops'
  conf.gem github: 'mruby-sdl2/mruby-sdl2-mixer'
  conf.gem github: 'mruby-sdl2/mruby-sdl2-ttf'
  conf.gem github: 'mruby-sdl2/mruby-sdl2-image'
  # conf.gem github: 'mruby-sdl2/mruby-sdl2-cocoa'

  conf.gem github: 'kabies/mruby-stable-sort'
  # conf.gem github: 'kabies/mruby-simple-cellular-automaton'

  conf.gem :mgem => 'mruby-singleton'
  conf.gem :github => 'matsumoto-r/mruby-sleep'
  conf.gem :github => 'iij/mruby-iijson'
  conf.gem :github => 'iij/mruby-dir'
  conf.gem :github => 'iij/mruby-env'
  conf.gem :github => 'AndrewBelt/mruby-yaml' # incompatible for crosscompile

  conf.gem :core => 'mruby-io'
  conf.gem :core => 'mruby-pack'
  conf.gem :core => 'mruby-socket'
  conf.gem :core => 'mruby-exit'
  conf.gembox 'default'

  conf.cc do |cc|
    cc.command = ENV['CC'] || "gcc-mp-7"
    cc.defines << 'MRB_UTF8_STRING'
    cc.defines << 'MRB_32BIT' # default 64bit in mruby 1.4.0?
    # cc.defines += %w(MRB_METHOD_TABLE_INLINE MRB_METHOD_CACHE) # for 1.4.0
    cc.flags = %w(-O3 -std=gnu99 -Wall -Werror-implicit-function-declaration -Wdeclaration-after-statement -Wwrite-strings)
    cc.include_paths << "/opt/local/include" # for macports
  end
  conf.objc do |cc|
    cc.command = "clang"
    cc.defines += %w(MRB_UTF8_STRING)
    cc.flags << "-O2"
  end

  conf.linker do |linker|
    linker.library_paths << "/opt/local/lib" # for macports
  end
end
