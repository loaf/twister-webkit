#!/bin/bash
export TWISTER_WRAPPER="`readlink -f "$0"`"
HERE="`dirname "$TWISTER_WRAPPER"`"

if [ ! -f "$HERE/libudev.so.0" ]
then
  paths=(
    "/lib/x86_64-linux-gnu/libudev.so.1" # Ubuntu, Xubuntu, Mint
    "/usr/lib64/libudev.so.1" # SUSE, Fedora
    "/usr/lib/libudev.so.1" # Arch, Fedora 32bit
    "/lib/i386-linux-gnu/libudev.so.1" # Ubuntu 32bit
  )
  for i in "${paths[@]}"
  do
    if [ -f $i ]
    then
      ln -sn "$i" "$HERE/libudev.so.0"
      break
    fi
  done
fi

if [[ -n "$LD_LIBRARY_PATH" ]]; then
  LD_LIBRARY_PATH="$LD_LIBRARY_PATH:$HERE"
else
  LD_LIBRARY_PATH="$HERE"
fi
export LD_LIBRARY_PATH

exec -a "$0" "$HERE/twister" "$@"