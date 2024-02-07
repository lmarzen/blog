#!/bin/bash
# This script is a work in progress.
# The idea was to download and install locally all the dependencies for libavif (and libavif itself).
# This proved way more annoying than just statically compiling libavif.
# Add this as a build variable to netlify.toml. It doesn't work in scripts ugh.
#     LD_LIBRARY_PATH = "/opt/buildhome/.local/usr/lib/x86_64-linux-gnu"

set -x

cd "$(dirname "$0")"
cd ..


if [ "$NETLIFY" = "true" ];
then
    INSTALL_PREFIX=$HOME/.local
    mkdir -p $INSTALL_PREFIX

    LIBAVIFBIN_LATEST=$(wget -qO- http://archive.ubuntu.com/ubuntu/pool/universe/liba/libavif/ | grep -o 'libavif-bin_[0-9][^"]*amd64.deb' | sort -V | tail -n1)
    LIBAVIF_LATEST=$(wget -qO- http://archive.ubuntu.com/ubuntu/pool/universe/liba/libavif/ | grep -o 'libavif[0-9][^"]*amd64.deb' | sort -V | tail -n1)
    LIBDAV1D_LATEST=$(wget -qO- http://archive.ubuntu.com/ubuntu/pool/universe/d/dav1d/ | grep -o 'libdav1d[0-9][^"]*amd64.deb' | sort -V | tail -n1)
    LIBGAV1_LATEST=$(wget -qO- http://archive.ubuntu.com/ubuntu/pool/universe/libg/libgav1/ | grep -o 'libgav1-[0-9][^"]*amd64.deb' | sort -V | tail -n1)
    LIBRAV1E_LATEST=$(wget -qO- http://archive.ubuntu.com/ubuntu/pool/universe/r/rust-rav1e/ | grep -o 'librav1e[0-9][^"]*amd64.deb' | sort -V | tail -n1)
    LIBSVTAV1ENC_LATEST=$(wget -qO- http://archive.ubuntu.com/ubuntu/pool/universe/s/svt-av1/ | grep -o 'libsvtav1enc1d[0-9][^"]*amd64.deb' | sort -V | tail -n1)
    LIBAOM_LATEST=$(wget -qO- http://archive.ubuntu.com/ubuntu/pool/universe/a/aom/ | grep -o 'libaom[0-9][^"]*amd64.deb' | sort -V | tail -n1)
    LIBYUV_LATEST=$(wget -qO- http://archive.ubuntu.com/ubuntu/pool/universe/liby/libyuv/ | grep -o 'libyuv[0-9][^"]*amd64.deb' | sort -V | tail -n1)
    LIBSHARPYUV_LATEST=$(wget -qO- http://archive.ubuntu.com/ubuntu/pool/universe/libw/libwebp/ | grep -o 'webp_[0-9][^"]*amd64.deb' | sort -V | tail -n1)


    wget http://archive.ubuntu.com/ubuntu/pool/universe/liba/libavif/$LIBAVIFBIN_LATEST
    wget http://archive.ubuntu.com/ubuntu/pool/universe/liba/libavif/$LIBAVIF_LATEST
    wget http://archive.ubuntu.com/ubuntu/pool/universe/d/dav1d/$LIBDAV1D_LATEST
    wget http://archive.ubuntu.com/ubuntu/pool/universe/libg/libgav1/$LIBGAV1_LATEST
    wget http://archive.ubuntu.com/ubuntu/pool/universe/r/rust-rav1e/$LIBRAV1E_LATEST
    wget http://archive.ubuntu.com/ubuntu/pool/universe/s/svt-av1/$LIBSVTAV1ENC_LATEST
    wget http://archive.ubuntu.com/ubuntu/pool/universe/a/aom/$LIBAOM_LATEST
    wget http://archive.ubuntu.com/ubuntu/pool/universe/liby/libyuv/$LIBYUV_LATEST
    wget http://archive.ubuntu.com/ubuntu/pool/universe/liby/libyuv/$LIBYUV_LATEST
    dpkg -x $LIBAVIFBIN_LATEST $INSTALL_PREFIX
    dpkg -x $LIBAVIF_LATEST $INSTALL_PREFIX
    dpkg -x $LIBDAV1D_LATEST $INSTALL_PREFIX
    dpkg -x $LIBGAV1_LATEST $INSTALL_PREFIX
    dpkg -x $LIBRAV1E_LATEST $INSTALL_PREFIX
    dpkg -x $LIBSVTAV1ENC_LATEST $INSTALL_PREFIX
    dpkg -x $LIBAOM_LATEST $INSTALL_PREFIX
    dpkg -x $LIBYUV_LATEST $INSTALL_PREFIX
    dpkg -x $LIBYUV_LATEST $INSTALL_PREFIX
fi
