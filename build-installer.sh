#!/usr/bin/env bash

set -ex

sudo apt-get update
sudo apt-get install -y \
    git \
    software-properties-common

# distinst is not in the ubuntu repos
sudo apt-key adv --keyserver keyserver.ubuntu.com --recv-keys 63C46DF0140D738961429F4E204DD8AEC33A7AFF
sudo add-apt-repository "deb http://apt.pop-os.org/release $(lsb_release -cs) main"
sudo apt-get update

git config --global --add safe.directory /__w/installer/installer
git checkout origin/deb-packaging -- debian

sed -i 's/amd64/arm64/g' debian/control
sudo apt-get --no-install-recommends -qq build-dep .

dpkg-buildpackage -us -uc
