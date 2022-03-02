#!/usr/bin/env bash

set -e

cp build.conf os/build.conf
cd os

# Patch out mirror config because many don't have arm binaries
# shellcheck disable=SC2016
sed -i 's/".*mirrors.ubuntu.com.*"/"\$MIRROR_URL"/g' etc/auto/config

docker run --privileged --platform linux/arm64 -v /proc:/proc \
    -v "$(pwd):/working_dir" \
    -w /working_dir \
    debian:latest \
    ./build.sh build.conf

cd ..
