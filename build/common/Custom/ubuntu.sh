sudo rm -rf /etc/apt/sources.list.d/* /usr/share/dotnet /usr/local/lib/android /opt/ghc
sudo -E apt-get -qq update
sudo -E apt-get -qq full-upgrade
sudo -E apt -y install ack antlr3 aria2 asciidoc autoconf automake autopoint binutils bison build-essential bzip2 ccache clang cmake cpio curl device-tree-compiler dos2unix ecj fakeroot fastjar flex g++-multilib gawk gcc-multilib genisoimage gettext git gnutls-dev gperf haveged help2man intltool jq lib32gcc-s1 libc6-dev-i386 libelf-dev libfuse-dev libglib2.0-dev libgmp3-dev libltdl-dev libmpc-dev libmpfr-dev libncurses5-dev libncursesw5 libncursesw5-dev libpython3-dev libreadline-dev libssl-dev libtool libyaml-dev libz-dev lld llvm lrzsz mkisofs msmtp nano ninja-build p7zip p7zip-full patch pigz pkgconf python2 python2.7 python3 python3-docutils python3-pip python3-ply python3-pyelftools qemu-utils quilt re2c rename rsync scons squashfs-tools subversion swig texinfo uglifyjs unzip upx upx-ucl vim wget xmlto xxd zlib1g-dev zstd
sudo -E apt-get -qq autoremove --purge
sudo -E apt clean
