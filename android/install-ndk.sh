#!/bin/sh

set -ex

NDK_REVISION="r10e"

# Prep the Android NDK
#
# See https://github.com/servo/servo/wiki/Building-for-Android
curl -O http://dl.google.com/android/ndk/android-ndk-${NDK_REVISION}-linux-x86_64.bin
chmod +x ./android-ndk-${NDK_REVISION}-linux-x86_64.bin
./android-ndk-${NDK_REVISION}-linux-x86_64.bin > /dev/null
bash android-ndk-${NDK_REVISION}/build/tools/make-standalone-toolchain.sh \
        --platform=android-21 \
        --toolchain=arm-linux-androideabi-4.8 \
        --install-dir=/android/ndk-arm \
        --ndk-dir=/android/android-ndk-r10e \
        --arch=arm

rm -rf ./android-ndk-${NDK_REVISION}-linux-x86_64.bin ./android-ndk-${NDK_REVISION}
