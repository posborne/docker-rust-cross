#
# Based off of rust-buildbot linux-cross
#
FROM ubuntu:15.10

WORKDIR /build

# Setup PATH to allow running android tools.
ENV PATH=$PATH:/android/ndk-arm/bin:\
/android/ndk-aarch64/bin:\
/android/ndk-x86:\
/android/sdk/tools:\
/android/sdk/platform-tools

# Not sure how to install 64-bit binaries in the sdk?
ENV ANDROID_EMULATOR_FORCE_32BIT=true

RUN dpkg --add-architecture i386 && \
    apt-get -y update && \
    apt-get install -y --force-yes --no-install-recommends \
        curl make git wget file sudo \
        python-dev python-pip stunnel \
        g++ gcc libc6-dev \
        gcc-4.7-arm-linux-gnueabi libc6-dev-armel-cross \
        gcc-4.7-arm-linux-gnueabihf libc6-dev-armhf-cross \
        gcc-4.8-aarch64-linux-gnu libc6-dev-arm64-cross \
        gcc-4.8-powerpc-linux-gnu libc6-dev-powerpc-cross \
        gcc-4.8-powerpc64le-linux-gnu libc6-dev-ppc64el-cross \
        lib64gcc-4.8-dev-powerpc-cross libc6-dev-ppc64-powerpc-cross \
        software-properties-common \
        qemu qemu-system-arm qemu-system-aarch64 \
        qemu-system-ppc qemu-system-sparc \
        qemu-system-x86 qemu-user qemu-utils \
        expect \
        libncurses5:i386 libstdc++6:i386 zlib1g:i386 \
        openjdk-6-jre psmisc \
        && \
    add-apt-repository ppa:angelsl/mips-cross && apt-get update && \
    apt-get install -y --force-yes --no-install-recommends \
        gcc-5-mips-linux-gnu libc6-dev-mips-cross \
        gcc-5-mipsel-linux-gnu libc6-dev-mipsel-cross && \
    apt-get clean

# Install NDK/SDK
ADD android/install-ndk.sh /android/
RUN cd /android && sh /android/install-ndk.sh
ADD android/install-sdk.sh android/accept-licenses.sh /android/
RUN cd /android && sh /android/install-sdk.sh

# Install Rust Versions
ADD install_rust.sh /build
RUN /bin/bash /build/install_rust.sh
