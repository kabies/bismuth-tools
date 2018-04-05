# Tools for Bismuth Game Engine

this repository includes several support tools for [bismuth](https://github.com/kabies/bismuth).

 - mruby build script (for macOS,Linux,mingw-w64)
 - assets archiver and unarchiver
 - macOS application bundle(.app) builder
 - launcher for windows

# Related Projects

 - bismuth <https://github.com/kabies/bismuth>
 - bismuth-examples <https://github.com/kabies/bismuth-examples>

# Install

run `./scripts/build-(linux|macos|mingw-w64).sh` to build mruby, and add `bin` directory to your PATH.

# Usage

## 1. Make project directory

`mkdir myGame` in anywhere you like.

## 2. Write a config file

configuration file of bismuth is similar to dotenv.

edit `.env` file in `myGame`.

```
# for bismuth-build.rb
BISMUTH_TOOLS_PATH=/path/to/bismuth-tools
# if you use macOS, you must install SDL frameworks and specify here.
FRAMEWORKS_PATH=/Users/USER_NAME/Library/Frameworks

# for bismuth.rb
BISMUTH_LOAD_PATH=/path/to/bismuth
```

## 3. Write a code

edit `main.rb`:

```
require "bismuth"

class GameScene < Bi::Scene
end

Bi::System.init
Bi::Window.make_window( 640, 480)
Bi::RunLoop.instance.run_with_scene GameScene.new
```

## 4. Run

run `bismuth.rb main.rb` in `myGame` directory.

