# Stage 1: Clone the repository and build the project
FROM alpine:latest as builder
RUN apk add --no-cache git openssh

# Clone the repository
RUN git clone git@github.com:rao208/asciinema.git .
WORKDIR /asciinema

# Build the project using the Dockerfile from the repository
COPY --from=builder /app/docker/Dockerfile ./Dockerfile
RUN docker build -t asciinema-app-image .

# Stage 2: Create the final runtime image
FROM alpine:latest
WORKDIR /app

# Copy the built binary from the builder stage
COPY --from=builder /app/target/release/asciinema /usr/local/bin

# Set the entry point to the built binary
ENTRYPOINT ["/usr/local/bin/asciinema"]
