#!/bin/sh

REPOSITORY="https://github.com/mruby/mruby.git"
DIR="build/linux"
MRUBY_CONFIG="$PWD/source/build_config-linux.rb"

echo "MRUBY_CONFIG=$MRUBY_CONFIG"

mkdir -p "build"
git clone -b 1.4.0 $REPOSITORY $DIR

cd $DIR
env FRAMEWORKS_PATH=$FRAMEWORKS_PATH MRUBY_CONFIG=$MRUBY_CONFIG ruby minirake -v all

cd -
cp build/linux/build/host/bin/mruby bin/mruby
cp build/linux/build/host/bin/mirb bin/mirb
cp build/linux/build/host/bin/mrbc bin/mrbc