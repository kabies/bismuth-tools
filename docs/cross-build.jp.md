# クロスコンパイル

mingw-w64をインストールしておく。
macOSでは [MacPorts](https://www.macports.org) を使い、`sudo port install -b mingw-w64` でインストールできる。
Ubuntuでは `sudo apt-get install mingw-w64` 。

クロスコンパイル用のSDLを以下から入手する。

 - [SDL](https://www.libsdl.org/download-2.0.php)
 - [SDL_image](https://www.libsdl.org/projects/SDL_image/)
 - [SDL_ttf](https://www.libsdl.org/projects/SDL_ttf/)
 - [SDL_mixer](https://www.libsdl.org/projects/SDL_mixer/)

`sudo make cross` でインストールできる。
インストール先が `/usr/local/cross-tools` の場合と `/usr/local` の場合があるので、
必要なら `Makefile` を編集して `/usr/local` に揃える。

## bismuthのインストール

通常の手順に加えて、 `bismuth-tools` 内で `./scripts/build-mingw-w64.sh` を実行する。

## プロジェクトのビルド

プロジェクトの `.env` ファイルに、 `CROSS_TOOLS_PATH=/usr/local` としてクロスコンパイル用SDLのパスを追記しておく。

`bismuth-build.rb mingw-w64` を実行すると `tmp/mingw-w64/game` 以下に実行ファイルが作られる。

`icon.ico` を用意しておくとアイコンとして使われる。