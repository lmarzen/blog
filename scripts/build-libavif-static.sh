#!/bin/bash
# https://github.com/AOMediaCodec/libavif

WORK_DIR=$(realpath $(dirname "$0")/../.work)
INSTALL_PREFIX=$(realpath $(dirname "$0")/../.local)
mkdir -p $INSTALL_PREFIX

rm -rf $WORK_DIR
mkdir -p $WORK_DIR
cd $WORK_DIR

git clone -b v1.0.3 https://github.com/AOMediaCodec/libavif.git
cd libavif/ext
./aom.cmd
# ./libyuv.cmd
# ./libsharpyuv.cmd
# ./libjpeg.cmd
# ./zlibpng.cmd
cd ..
# cmake -S . -B build -DBUILD_SHARED_LIBS=OFF -DAVIF_CODEC_AOM=ON -DAVIF_LOCAL_AOM=ON -DAVIF_LOCAL_LIBYUV=ON -DAVIF_LOCAL_LIBSHARPYUV=ON -DAVIF_LOCAL_JPEG=ON -DAVIF_LOCAL_ZLIBPNG=ON -DAVIF_BUILD_APPS=ON -DCMAKE_INSTALL_PREFIX=$INSTALL_PREFIX -DAVIF_CODEC_AOM=LOCAL -AVIF_CODEC_DAV1D=LOCAL -AVIF_CODEC_LIBGAV1=LOCAL -AVIF_CODEC_RAV1E=LOCAL -AVIF_CODEC_SVT=LOCAL
#

cmake -S . -B build \
        -DCMAKE_INSTALL_PREFIX=$INSTALL_PREFIX \
        -DBUILD_SHARED_LIBS=OFF \
        -DAVIF_BUILD_APPS=ON \
        -DAVIF_CODEC_AOM=LOCAL \
        -DAVIF_LOCAL_AOM=ON \
# cmake -S . -B build \
#         -DCMAKE_INSTALL_PREFIX=$INSTALL_PREFIX \
#         -DBUILD_SHARED_LIBS=OFF \
#         -DAVIF_BUILD_APPS=ON \
#         -DAVIF_CODEC_AOM=LOCAL \
#         -DAVIF_CODEC_DAV1D=LOCAL \
#         -DAVIF_CODEC_RAV1E=LOCAL \
#         -DAVIF_CODEC_SVT=LOCAL
#         -DAVIF_LOCAL_AOM=ON \
#         -DAVIF_LOCAL_DAV1D=ON \
#         -DAVIF_LOCAL_RAV1E=ON \
#         -DAVIF_LOCAL_SVT=ON
# cmake -S . -B build \
#         -DCMAKE_INSTALL_PREFIX=$INSTALL_PREFIX \
#         -DBUILD_SHARED_LIBS=OFF \
#         -DAVIF_BUILD_APPS=ON \
#         -DAVIF_CODEC_AOM=LOCAL \
#         -DAVIF_CODEC_DAV1D=LOCAL \
#         -DAVIF_CODEC_RAV1E=LOCAL \
#         -DAVIF_CODEC_SVT=LOCAL
cmake --build build --parallel
cmake --install build

# -DAVIF_CODEC_LIBGAV1=LOCAL

# make -S . -B build -DAVIF_CODEC_AOM=LOCAL -DAVIF_CODEC_DAV1D=LOCAL  -DBUILD_SHARED_LIBS=OFF -DAVIF_LOCAL_JPEG=ON -DAVIF_LOCAL_ZLIBPNG=ON -DAVIF_LIBYUV=LOCAL -DAVIF_BUILD_APPS=ON -DAVIF_ENABLE_WERROR=ON -DCMAKE_INSTALL_PREFIX=$INSTALL_PREFIX

# rm -rf $WORK_DIR

