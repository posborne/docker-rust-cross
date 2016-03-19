Rust Cross Compilation Docker Images
====================================

Overview
--------

This repo contains the Dockerfile and related scripts for building
[posborne/rust-cross][rust-cross].  These images contain a Linux
environment with several versions of rust (managed with multirust)
along with `std` for a number of different architectures.

These were created in order to make it significantly easier for crate
authors to build and (for some architectures) run tests for
architectures that they may not have set up on their own development
machines.

[rust-cross]: https://hub.docker.com/r/posborne/rust-cross/

Continuous Integration
----------------------

This repo includes a scripts for easily performing cross-compilation
and testing in CI environments supporting docker such as
[TravisCI][travisci].  Here's a sample `.travis.yml` configuration
which can be used to test an archetypical rust project on a number of
different platforms.

Note that containerized builds are still used for testing on the host
platform and sudo is only specified for builds requiring docker
support.

```yaml
sudo: false
language: rust

# The travis script will start up the specified container and do the following
# - Build code/tests for the specified target with the specified version
# - Run the tests using the appropriate emulator for the given target
#
# Projects are encouraged to move this script into their own project if modifications
# are required or the project wants assurances that upstream changes will not
# break the build for your project.  Use in this form at your own risk!
script:
   - curl https://raw.githubusercontent.com/rust-embedded/docker-rust-cross/master/scripts/run-travis.sh | bash

matrix:
  # Main parts of the matrix will execute on the host without container pull
  rust:
    - stable
    - beta
    - nightly

  # Script will attempt to pick best docker container to use based on target/version, but
  # it can be specified via DOCKER_IMAGE if desired
  include:
    - ENV: RUST_TARGET=arm-unknown-linux-gnueabihf
      rust: 1.7.0
      sudo: true
    - ENV: RUST_TARGET=aarch64-unknown-linux-gnu
      rust: 1.7.0
      sudo: true
    - ENV: RUST_TARGET=mips-unknown-linux-gnu
      rust: 1.7.0
      sudo: true
    - ENV: RUST_TARGET=arm-linux-androideabi
      rust: 1.7.0
      sudo: true
```

[travisci]: https://travis-ci.org/

License
-------

```
Copyright (c) 2016, Paul Osborne <ospbau@gmail.com>

Licensed under the Apache License, Version 2.0 <LICENSE-APACHE or
http://www.apache.org/license/LICENSE-2.0> or the MIT license
<LICENSE-MIT or http://opensource.org/licenses/MIT>, at your
option.  This file may not be copied, modified, or distributed
except according to those terms.
```
