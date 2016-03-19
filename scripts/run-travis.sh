#!/bin/bash
#
# Script designed to be executed in a travis build environment with
# `sudo: true` and docker service enabled (required to use docker).
#

set -e

RUST_CROSS_REVISION=${RUST_CROSS_REVISION:-"master"}

maybe_download_ci_script() {
    if [ ! -r "ci/$1" ]; then
        curl -o "ci/$1" "https://raw.githubusercontent.com/rust-embedded/docker-rust-cross/${RUST_CROSS_REVISION}/scripts/$1"
    fi
    chmod +x "ci/$1"
}

# For projects that choose to not download directly from upstream, these
# scripts should be copied to the project directory as well.  Everything here
# assumes execution in a ci directory, so that is likely where you will want
# to put the scripts in your own code
download_run_scripts() {
    mkdir -p ./ci
    maybe_download_ci_script "run.sh"
    maybe_download_ci_script "run-docker.sh"
    maybe_download_ci_script "cargo-config"
}

do_host_build() {
    cargo test --verbose
}

discover_docker_image() {
    case "${RUST_TARGET}" in
        arm-linux-androideabi)
            echo "posborne/rust-cross:android"
            ;;
        mips-*)
            echo "posborne/rust-cross:mips"
            ;;
        mipsel-*)
            echo "posborne/rust-cross:mips"
            ;;
        arm-unknown-linux-*)
            echo "posborne/rust-cross:arm"
            ;;
        x86_64-*)
            echo "posborne/rust-cross:base"
            ;;
        *)
            echo "Cannot determine docker image for target: ${RUST_TARGET}" 1>&2
            exit 1
            ;;
    esac
}

do_docker_build() {
    # discover docker image based on target if not set
    if [ "$DOCKER_IMAGE" = "" ]; then
        DOCKER_IMAGE="$(discover_docker_image)"
    fi

    download_run_scripts

    export RUST_VERSION="${TRAVIS_RUST_VERSION}"
    export RUST_TARGET
    export DOCKER_IMAGE
    ./ci/run-docker.sh
}


# Determine if we are doing host or docker build and go for it
if [ "$RUST_TARGET" = "" ]; then
    do_host_build
else
    do_docker_build
fi
