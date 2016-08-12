#!/bin/bash

set -eu

TOPDIR=$(dirname "$0")
BASE_NAME="posborne/rust-cross-"

PLATFORMS=${PLATFORMS:-"\
  base \
  x86 \
  arm \
  mips \
  android \
"}

VERSIONS=${VERSIONS:-"\
  1.7.0 \
  1.8.0 \
  1.9.0 \
  1.10.0 \
"}

build_image() {
    local platform="$1"
    local rust_version="$2"
    local build_dir="$TOPDIR/build/${platform}:${rust_version}"

    echo "Building posborne/rust-cross-${platform}:${rust_version} ..."

    # prepare the build directory
    rm -rf ${build_dir}
    mkdir -p ${build_dir}

    # convert template for the platform
    cp -r ${TOPDIR}/${platform}/* ${build_dir}/
    mustache - ${TOPDIR}/${platform}/Dockerfile.${platform}.mustache >${build_dir}/Dockerfile <<EOF
rust_version: "${rust_version}"
EOF

    # build the image
    docker build \
           -t "${BASE_NAME}${platform}:${rust_version}" \
           "${build_dir}"
}

for platform in $PLATFORMS; do
    for version in $VERSIONS; do
        build_image ${platform} ${version}
        echo "Done with posborne/rust-cross-${platform}:${version} ... Waiting 30s before continuing"
    done
done
