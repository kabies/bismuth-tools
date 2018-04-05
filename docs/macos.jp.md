# macOSでのはじめかた

Xcodeをインストールしておく。

SDLのmacOS向けフレームワークを以下から入手し、 `~/Library/Frameworks/` へコピーしておく。

 - [SDL](https://www.libsdl.org/download-2.0.php)
 - [SDL_image](https://www.libsdl.org/projects/SDL_image/)
 - [SDL_ttf](https://www.libsdl.org/projects/SDL_ttf/)
 - [SDL_mixer](https://www.libsdl.org/projects/SDL_mixer/)

## bismuthのインストール

[bismuth-tools](https://github.com/kabies/bismuth-tools) と
[bismuth本体](https://github.com/kabies/bismuth) を、適当なところ ( 例えば `~/Library/` ) へコピー。

`bismuth-tools/bin` にパスを通しておく。

`bismuth-tools` 内で `./scripts/build-macos.sh` を実行して、mrubyをビルドする。

## プロジェクトの作成

`mkdir myGame` などとして、適当なプロジェクトのディレクトリを作る。

`.env` ファイルに、以下のように環境変数を指定する。

```
# for bismuth-build.rb
BISMUTH_TOOLS_PATH=/path/to/bismuth-tools
FRAMEWORKS_PATH=/Users/USER_NAME/Library/Frameworks

# for bismuth.rb
BISMUTH_LOAD_PATH=/path/to/bismuth
```

`icon.png` を用意しておくとアイコンとして使われる。
用意しなければ、bismuthデフォルトのものが使われる。

`main.rb` に以下のようにウインドウを出すだけのコードを書く。

```
require "bismuth"

class GameScene < Bi::Scene
end

Bi::System.init
Bi::Window.make_window( 640, 480)
Bi::RunLoop.instance.run_with_scene GameScene.new
```

`bismuth.rb` を実行すると `main.rb` が `main.mrb` にコンパイルされたのち、実行される。

コンパイルだけしたい場合は `bismuth.rb -c main.rb` とする。

コンパイル済みの `main.mrb` の実行のみしたい場合は `bismuth.rb main.mrb` とする。

`bismuth-build.rb macos` で、実行ファイル `tmp/macOS/game.app` が作られる。
