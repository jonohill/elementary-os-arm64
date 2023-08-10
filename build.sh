#!/usr/bin/env bash

set -ex

cp build.conf os/build.conf
cd os

# Patch out mirror config because many don't have arm binaries
# shellcheck disable=SC2016
sed -i 's/".*mirrors.ubuntu.com.*"/"\$MIRROR_URL"/g' etc/auto/config

# Set bootloader (required because arm64?)
sed -i 's/"${@}"/--bootloader grub-efi "${@}"/g' etc/auto/config

# Remove packages unavailable for ARM
packages=(bcmwl-kernel-source intel-microcode iucode-tool lupin-support secureboot-db)
pool_files=(etc/config/package-lists/pool.list.binary)
for package in "${packages[@]}"; do
    for pool_file in "${pool_files[@]}"; do
        sed -i "/^${package}/d" "${pool_file}"
        
        # Insert ARM-specific packages
        cat <<EOF >> "${pool_file}"
#if ARCHITECTURES arm64
grub-efi-arm64
grub-efi-arm64-bin
grub-efi-arm64-signed
shim
shim-signed
#endif
EOF

    done
done

docker run --privileged --platform linux/arm64 -v /proc:/proc \
    -v "$(pwd):/working_dir" \
    -w /working_dir \
    debian:latest \
    ./build.sh build.conf

cd ..
