# Toolchain only: the repository is mounted at /workspace when the build runs,
# and the build context is this directory, so nothing is copied in.
FROM rust:1.89-alpine
RUN apk add --no-cache musl-dev
WORKDIR /workspace
CMD ["./build.sh"]
