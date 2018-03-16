# Ubuntuでのはじめかた

開発用パッケージをインストールする。

```
sudo apt-get install build-essential bison ruby libsdl2-dev libsdl2-image-dev libsdl2-ttf-dev libsdl2-mixer-dev
```

## bismuthのインストール

[bismuth-tools](https://github.com/kabies/bismuth-tools) と
[bismuth本体](https://github.com/kabies/bismuth) を適当なところへコピーしておく。

`bismuth-tools/bin` にパスを通しておく。

`bismuth-tools` 内で `./scripts/build-linux.sh` を実行して、mrubyをビルドする。

## プロジェクトの作成

`mkdir myGame` などとして、適当なプロジェクトのディレクトリを作る。

`.env` ファイルに、以下のように環境変数を指定する。

```
# for bismuth-build
BISMUTH_TOOLS_PATH=/path/to/bismuth-tools

# for bismuth-compile
BISMUTH_LOAD_PATH=/path/to/bismuth
```

`main.rb` に以下のようにウインドウを出すだけのコードを書く。

```
require "bismuth"

class GameScene < Bi::Scene
end

Bi::System.init
Bi::Window.make_window( 640, 480)
Bi::RunLoop.instance.run_with_scene GameScene.new
```

`bismuth-compile.rb` を実行すると `main.mrb` ファイルが作られる。

`bismuth-run.rb` を実行すると `main.mrb` が実行され、空っぽのウインドウが表示される。
