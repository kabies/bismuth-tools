
MRuby::Build.new do |conf|
  toolchain :gcc

  conf.gem github: 'mruby-sdl2/mruby-sdl2'
  conf.gem github: 'mruby-sdl2/mruby-sdl2-mixer'
  conf.gem github: 'mruby-sdl2/mruby-sdl2-ttf'
  conf.gem github: 'mruby-sdl2/mruby-sdl2-image'
  conf.gem github: 'mruby-sdl2/mruby-sdl2-partial-rwops'
  conf.gem github: 'mruby-sdl2/mruby-sdl2-scene-graph'

  conf.gem github: 'kabies/mruby-stable-sort'
  conf.gem github: 'kabies/mruby-cellular-automaton'

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
    cc.defines += %w(MRB_UTF8_STRING MRB_32BIT)
  end

end
