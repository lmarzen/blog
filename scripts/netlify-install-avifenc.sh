#!/bin/bash

cd "$(dirname "$0")"
cd ..


if [ "$NETLIFY" = "true" ];
then
    wget -O libavif.pkg.tar.zst https://archlinux.org/packages/extra/x86_64/libavif/download/
    mkdir -p libavif.pkg
    tar --use-compress-program=unzstd -xvf libavif.pkg.tar.zst -C libavif.pkg


    # chmod 755 parallel
    # cp parallel sem
    # mkdir ~/bin
    # mv parallel sem ~/bin/
    # source ~/.profile
fi
