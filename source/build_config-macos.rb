#
# for x86_64-apple-darwin
#
MRuby::Build.new do |conf|
  toolchain :gcc
  conf.enable_test

  conf.gem github:'mruby-sdl2/mruby-sdl2' do |g|
    if ENV['FRAMEWORKS_PATH']
      g.cc.flags << "-F#{ENV['FRAMEWORKS_PATH']} -framework SDL2"
      g.cc.include_paths << "#{ENV['FRAMEWORKS_PATH']}/SDL2.framework/Headers/"
    end
  end

  conf.gem github:'mruby-sdl2/mruby-sdl2-image' do |g|
    g.cc.flags << "-F#{ENV['FRAMEWORKS_PATH']} -framework SDL2 -framework SDL2_image"
    g.cc.include_paths << "#{ENV['FRAMEWORKS_PATH']}/SDL2.framework/Headers/"
    g.cc.include_paths << "#{ENV['FRAMEWORKS_PATH']}/SDL2_image.framework/Headers/"
  end

  conf.gem github:'mruby-sdl2/mruby-sdl2-ttf' do |g|
    g.cc.flags << "-F#{ENV['FRAMEWORKS_PATH']} -framework SDL2 -framework SDL2_ttf"
    g.cc.include_paths << "#{ENV['FRAMEWORKS_PATH']}/SDL2.framework/Headers/"
    g.cc.include_paths << "#{ENV['FRAMEWORKS_PATH']}/SDL2_ttf.framework/Headers/"
  end

  conf.gem github:'mruby-sdl2/mruby-sdl2-mixer' do |g|
    g.cc.flags << "-F#{ENV['FRAMEWORKS_PATH']} -framework SDL2 -framework SDL2_mixer"
    g.cc.include_paths << "#{ENV['FRAMEWORKS_PATH']}/SDL2.framework/Headers/"
    g.cc.include_paths << "#{ENV['FRAMEWORKS_PATH']}/SDL2_mixer.framework/Headers/"
  end

  conf.gem github:'mruby-sdl2/mruby-sdl2-scene-graph' do |g|
    g.cc.flags << "-F#{ENV['FRAMEWORKS_PATH']} -framework SDL2"
    g.cc.include_paths << "#{ENV['FRAMEWORKS_PATH']}/SDL2.framework/Headers/"
  end

  conf.gem github:'mruby-sdl2/mruby-sdl2-partial-rwops' do |g|
    g.cc.flags << "-F#{ENV['FRAMEWORKS_PATH']} -framework SDL2"
    g.cc.include_paths << "#{ENV['FRAMEWORKS_PATH']}/SDL2.framework/Headers/"
    g.cc.include_paths << "#{ENV['FRAMEWORKS_PATH']}/SDL2_mixer.framework/Headers/"
    g.cc.include_paths << "#{ENV['FRAMEWORKS_PATH']}/SDL2_image.framework/Headers/"
  end

  conf.gem github:'mruby-sdl2/mruby-sdl2-screenshot' do |g|
    if ENV['FRAMEWORKS_PATH']
      g.cc.flags << "-F#{ENV['FRAMEWORKS_PATH']} -framework SDL2"
      g.cc.include_paths << "#{ENV['FRAMEWORKS_PATH']}/SDL2.framework/Headers/"
    end
  end

  # conf.gem github: 'mruby-sdl2/mruby-sdl2-cocoa'

  conf.gem github: 'kabies/mruby-stable-sort'
  # conf.gem github: 'kabies/mruby-simple-cellular-automaton'

  conf.gem :mgem => 'mruby-singleton'
  conf.gem :github => 'matsumoto-r/mruby-sleep'
  conf.gem :github => 'iij/mruby-iijson'
  conf.gem :github => 'iij/mruby-dir'
  conf.gem :github => 'iij/mruby-env'
  # conf.gem :github => 'AndrewBelt/mruby-yaml' # incompatible for crosscompile
  conf.gem :github => 'mruby-Forum/mruby-yaml', :branch => 'fix-build'

  conf.gem :core => 'mruby-io'
  conf.gem :core => 'mruby-pack'
  conf.gem :core => 'mruby-socket'
  conf.gem :core => 'mruby-exit'

  conf.gembox 'default'

  conf.cc do |cc|
    cc.command = ENV['CC'] || "gcc"
    cc.defines << 'MRB_UTF8_STRING'
    cc.defines << 'MRB_32BIT' # default 64bit in mruby 1.4.0?
    # cc.defines += %w(MRB_METHOD_TABLE_INLINE MRB_METHOD_CACHE) # for 1.4.0
  end

  conf.objc do |cc|
    cc.command = "clang"
    cc.defines += %w(MRB_UTF8_STRING)
    cc.flags << "-O2"
  end

  conf.linker do |linker|
    linker.command = ENV['CC'] || "gcc"
    if ENV['FRAMEWORKS_PATH']
      linker.flags << "-F#{ENV['FRAMEWORKS_PATH']}"
      linker.flags << "-framework SDL2"
      linker.flags << "-framework SDL2_image"
      linker.flags << "-framework SDL2_ttf"
      linker.flags << "-framework SDL2_mixer"
    end
  end
end
