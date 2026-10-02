#!/bin/sh
# Runs inside the builder container with cwd=/workspace (the repository root).
set -eu
cargo build --release --locked
