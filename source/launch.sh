#!/bin/sh

tmp="$0"
tmp=`dirname "$tmp"`
tmp=`dirname "$tmp"`
bundle=`dirname "$tmp"`
bundle_contents="$bundle"/Contents
bundle_res="$bundle_contents"/Resources

MRUBY="$bundle_contents/MacOS/mruby"
entry_script="$bundle_res/main.mrb"

#
# date >> /tmp/test.log
# pwd >> /tmp/test.log
# echo "booting mruby: $MRUBY" >> /tmp/test.log
# echo "bundle resources: $bundle_res" >> /tmp/test.log
# echo "entry script: $entry_script" >> /tmp/test.log
# echo "Launching mruby..." >> /tmp/test.log
cd $bundle_res
# pwd >> /tmp/test.log
# exec "$MRUBY" -b "$entry_script" >> /tmp/test.log
exec "$MRUBY" -b "$entry_script"