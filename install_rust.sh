#!/bin/bash
#
# Install several different versions of rust along with
# cross-toolchains for each according to the encoded matrix.
#

set -e
set -x

# All unixy targets on static.rust-lang.org
TARGETS=${TARGETS:-"aarch64-unknown-linux-gnu \
    arm-linux-androideabi \
    arm-unknown-linux-gnueabi \
    arm-unknown-linux-gnueabihf \
    i686-apple-darwin \
    i686-unknown-linux-gnu \
    mips-unknown-linux-gnu \
    mipsel-unknown-linux-gnu \
    x86_64-apple-darwin \
    x86_64-unknown-linux-gnu \
    x86_64-unknown-linux-musl"}

# Others (added in 1.6):
#
# aarch64-apple-ios
# armv7-applie-ios
# armv7-unknown-linux-gnueabihf
# armv7s-apple-ios
# i386-apple-ios
# powerpc-unknown-linux-gnu
# powerpc64-unknown-linux-gnu
# powerpc64le-unknown-linxu-gnu

# Only have cross-std starting with 1.5.0
VERSIONS=${VERSIONS:-"1.6.0 \
    1.7.0 \
    beta \
    nightly"}

install_multirust() {
    curl -sf https://raw.githubusercontent.com/brson/multirust/master/quick-install.sh | sh -s -- --yes
}

install_rustc_versions() {
    for version in ${VERSIONS}; do
        echo "INSTALL: version ${version}"
        multirust update "${version}"
    done
}

install_cross_std() {
    for version in ${VERSIONS}; do
        multirust override "${version}"
        for target in ${TARGETS}; do
            arc_basename="rust-std-${version}-${target}"
            curl https://static.rust-lang.org/dist/${arc_basename}.tar.gz | tar xz
            ${arc_basename}/install.sh --prefix=$(rustc --print sysroot)
            rm -rf ${arc_basename}
        done
    done
}

install_multirust
install_rustc_versions
install_cross_std
