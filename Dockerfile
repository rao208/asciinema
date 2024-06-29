# Stage 1: Clone the repository
FROM alpine:latest as cloner
RUN apk add --no-cache git openssh

# Clone the repository
RUN git clone git@github.com:rao208/asciinema.git .

# Stage 2: Build the project
ARG RUST_VERSION=1.70.0
FROM rust:${RUST_VERSION}-bookworm as builder
WORKDIR /app

# Copy the source code from the cloned repository
COPY --from=cloner /app /app

# Install necessary dependencies
RUN apt-get update && apt-get install -y curl

# Install Rust toolchain
RUN curl -sSL https://sh.rustup.rs | sh -s -- -y

# Build the project with cargo
RUN cargo build --locked --release --verbose

# Stage 3: Create the runtime image
FROM debian:bookworm-slim as runtime
WORKDIR /usr/local/bin

# Find the binary name from the Cargo.toml
# Here we assume the binary is named `asciinema` as per common convention
# If the binary name is different, adjust the following COPY command accordingly
COPY --from=builder /app/target/release/asciinema .

# Set the entry point to the binary
ENTRYPOINT ["./asciinema"]
