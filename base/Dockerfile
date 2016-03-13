# Base image with compiler/rust for host
FROM ubuntu:15.10

WORKDIR /build

RUN apt-get -y update && \
    apt-get install -y --force-yes --no-install-recommends \
        curl file sudo g++ gcc libc6-dev git ca-certificates && \
    apt-get clean

# Install Rust Versions (x86_64/i686)
#
# Images inheriting from this one will also have /rust-cross/install_rust.sh
# available for installing additional rust versions and std targets
ADD install_rust.sh /rust-cross/
ENV RUST_TARGETS="x86_64-unknown-linux-gnu i686-unknown-linux-gnu x86_64-unknown-linux-musl" \
    RUST_VERSIONS="1.7.0"
RUN bash /rust-cross/install_rust.sh
