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

[rust-cross]: https://hub.docker.com/posborne/rust-cross

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
