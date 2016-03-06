#
# Based off of rust-buildbot linux-cross
#
FROM ubuntu:15.10

RUN apt-get update && apt-get install -y --force-yes --no-install-recommends \
        curl make git wget file sudo \
        python-dev python-pip stunnel \
        g++ gcc libc6-dev \
        gcc-4.7-arm-linux-gnueabi libc6-dev-armel-cross \
        gcc-4.7-arm-linux-gnueabihf libc6-dev-armhf-cross \
        gcc-4.8-aarch64-linux-gnu libc6-dev-arm64-cross \
        gcc-4.8-powerpc-linux-gnu libc6-dev-powerpc-cross \
        gcc-4.8-powerpc64le-linux-gnu libc6-dev-ppc64el-cross \
        lib64gcc-4.8-dev-powerpc-cross libc6-dev-ppc64-powerpc-cross \
        software-properties-common

RUN add-apt-repository ppa:angelsl/mips-cross && apt-get update && \
    apt-get install -y --force-yes --no-install-recommends \
        gcc-5-mips-linux-gnu libc6-dev-mips-cross \
        gcc-5-mipsel-linux-gnu libc6-dev-mipsel-cross

RUN                                              \
  for f in `ls /usr/bin/mips*-linux-*-*-5`; do   \
    ln -vs $f `echo $f | sed -e 's/-5$//'`;      \
  done &&                                        \
  for f in `ls /usr/bin/*-linux-*-*-4.8`; do     \
    ln -vs $f `echo $f | sed -e 's/-4.8$//'`;    \
  done &&                                        \
  for f in `ls /usr/bin/*-linux-*-*-4.7`; do     \
    ln -vs $f `echo $f | sed -e 's/-4.7$//'`;    \
  done

# Install various versions of rust with std for each for
# use in cross compilation.  In the future, this may all
# be doable with multirust
RUN  mkdir -p /build
WORKDIR /build
COPY install_rust.sh /build
RUN  /bin/bash install_rust.sh
