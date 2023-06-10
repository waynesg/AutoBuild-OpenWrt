#!/bin/bash
# SPDX-License-Identifier: GPL-3.0-only
#
# Copyright (C) ImmortalWrt.org

docker rmi `docker images -q`
sudo -E rm -rf /usr/share/dotnet /etc/mysql /etc/php /etc/apt/sources.list.d /usr/local/lib/android
sudo -E apt-mark hold grub-efi-amd64-signed
sudo -E apt update
sudo -E apt -y purge azure-cli* docker* ghc* zulu* llvm* firefox google* dotnet* powershell* openjdk* mysql* php* mongodb* dotnet* moby* snap* || true
sudo -E apt -y full-upgrade
sudo -E apt -y install ack antlr3 aria2 asciidoc autoconf automake autopoint binutils bison build-essential bzip2 ccache cmake cpio curl device-tree-compiler fastjar flex gawk gettext gcc-multilib g++-multilib git gperf haveged help2man intltool libc6-dev-i386 libelf-dev libglib2.0-dev libgmp3-dev libltdl-dev libmpc-dev libmpfr-dev libncurses5-dev libncursesw5-dev libreadline-dev libssl-dev libtool lrzsz mkisofs msmtp nano ninja-build p7zip p7zip-full patch pkgconf python3 python3-pip libpython3-dev qemu-utils rsync scons squashfs-tools subversion swig texinfo uglifyjs upx-ucl unzip vim wget xmlto xxd zlib1g-dev
sudo -E apt-get -y install xsltproc zip grep python3-pip python3-ply libc6-dev libncurses5 libtinfo-dev libtinfo5 ncurses-doc python2.7 git-core wget curl rsync libfuse-dev rename
sudo -E systemctl daemon-reload
sudo -E apt -y autoremove --purge
sudo -E apt clean
