ARG RUST_VERSION=1.70.0
FROM rust:${RUST_VERSION}-bookworm as builder
WORKDIR /app

# Copy source files to the container
COPY src ./src
COPY Cargo.toml Cargo.toml
COPY Cargo.lock Cargo.lock

# Install necessary dependencies
# RUN apt-get update && apt-get install -y build-essential libssl-dev pkg-config

#RUN apt-get update && apt-get install -y curl && \
#    curl -sSL https://sh.rustup.rs | sh -s -- -y

RUN rustup target add x86_64-unknown-linux-musl && \
cargo build --locked --release --verbose

# Use cargo to build the project with verbose output
# RUN cargo build --locked --release --verbose

# Use cargo to build the project
# RUN cargo build --locked --release

# Copy the built binary to /usr/local/bin
RUN cp ./target/release/asciinema /usr/local/bin/

FROM debian:bookworm-slim as run
COPY --from=builder /usr/local/bin/asciinema /usr/local/bin
ENTRYPOINT ["/usr/local/bin/asciinema"]
