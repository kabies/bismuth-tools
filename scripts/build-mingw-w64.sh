#!/bin/sh

REPOSITORY="https://github.com/mruby/mruby.git"
DIR="build/mingw-w64"
MRUBY_CONFIG="$PWD/source/build_config-mingw-w64.rb"
CROSS_TOOLS_PATH="/usr/local"

echo "MRUBY_CONFIG=$MRUBY_CONFIG"

mkdir -p "build"
git clone -b 1.4.0 $REPOSITORY $DIR

cd $DIR
env MACHTYPE=$MACHTYPE CROSS_TOOLS_PATH=$CROSS_TOOLS_PATH MRUBY_CONFIG=$MRUBY_CONFIG ruby minirake -v all
