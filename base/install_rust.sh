#!/bin/bash
#
# Install several different versions of rust along with
# cross-toolchains for each according to the encoded matrix.
#

set -ex

# x86_64 assumed to be present already
RUST_TARGETS=${RUST_TARGETS:-"aarch64-unknown-linux-gnu \
    arm-linux-androideabi \
    arm-unknown-linux-gnueabi \
    arm-unknown-linux-gnueabihf \
    i686-apple-darwin \
    i686-unknown-linux-gnu \
    mips-unknown-linux-gnu \
    mipsel-unknown-linux-gnu \
    x86_64-apple-darwin \
    x86_64-unknown-linux-musl"}

# Only have cross-std starting with 1.5.0
RUST_VERSIONS=${RUST_VERSIONS:-"\
    1.6.0 \
    1.7.0 \
    beta \
    nightly"}

export PATH=$PATH:$HOME/.cargo/bin

install_multirust() {
    # install multirust if not already installed (may be called multiple times)
    command -v rustup >/dev/null 2>&1 || {
        curl https://sh.rustup.rs -sSf | sh -s -- -y
    }
}

install_cross_std() {
    for version in ${RUST_VERSIONS}; do
        rustup install "${version}"
        for target in ${RUST_TARGETS}; do
            if echo ${version} | grep '.*-[0-9]*-[0-9]*-[0-9]*' >/dev/null 2>&1; then
                local parts=${version//-/ }
                local filename="rust-std-${parts[1]}-${target}"
                local dlpath="${parts[2]}-${parts[3]}-${parts[4]}/rust-std-${parts[1]}-${target}"
                curl https://static.rust-lang.org/dist/${dlpath}.tar.gz | tar xz
                ${filename}/install.sh --prefix=$(rustc --print sysroot)
                rm -rf ${filename}
            else
                local arc_basename="rust-std-${version}-${target}"
                curl https://static.rust-lang.org/dist/${arc_basename}.tar.gz | tar xz
                ${arc_basename}/install.sh --prefix=$(rustc --print sysroot)
                rm -rf ${arc_basename}
            fi
        done
    done
}

install_multirust
install_cross_std
