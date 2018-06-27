#!/bin/sh

REPOSITORY="https://github.com/mruby/mruby.git"
DIR="build/macos"
MRUBY_CONFIG="$PWD/source/build_config-macos.rb"
FRAMEWORKS_PATH="$HOME/Library/Frameworks"

echo "MRUBY_CONFIG=$MRUBY_CONFIG"

mkdir -p "build"
git clone -b 1.4.1 $REPOSITORY $DIR

cd $DIR
env FRAMEWORKS_PATH=$FRAMEWORKS_PATH MRUBY_CONFIG=$MRUBY_CONFIG ruby minirake -v all

cd -
cp build/macos/build/host/bin/mruby bin/mruby
cp build/macos/build/host/bin/mirb bin/mirb
cp build/macos/build/host/bin/mrbc bin/mrbc
