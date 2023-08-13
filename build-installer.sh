#!/usr/bin/env bash

set -ex

apt-get update
apt-get install -y \
    git \
    software-properties-common

# distinst is not in the ubuntu repos
apt-key adv --keyserver keyserver.ubuntu.com --recv-keys 63C46DF0140D738961429F4E204DD8AEC33A7AFF
add-apt-repository "deb http://apt.pop-os.org/release $(lsb_release -cs) main"
apt-get update

git config --global --add safe.directory "$(pwd)/installer"
git config --global --add safe.directory /__w/installer/installer

cd installer
pwd
git config remote.origin.fetch "+refs/heads/*:refs/remotes/origin/*"
git fetch --all
git branch -a
git checkout 1.1.0
git checkout origin/deb-packaging -- debian

sed -i 's/amd64/arm64/g' debian/control
DEBIAN_FRONTEND=noninteractive apt-get -y --no-install-recommends build-dep .

dpkg-buildpackage -us -uc

cd -
