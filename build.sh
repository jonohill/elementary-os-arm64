#!/usr/bin/env bash

set -e

cp build.conf os/build.conf
cd os

# Patch out mirror config because many don't have arm binaries
# shellcheck disable=SC2016
sed -i 's/".*mirrors.ubuntu.com.*"/"\$MIRROR_URL"/g' etc/auto/config

sudo ./build.sh build.conf

cd ..
