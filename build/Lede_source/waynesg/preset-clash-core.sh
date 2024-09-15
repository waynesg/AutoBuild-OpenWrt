#!/bin/bash
#=================================================
# File name: preset-clash-core.sh
# Usage: <preset-clash-core.sh $platform> | example: <preset-clash-core.sh armv8>
# System Required: Linux
# Version: 1.0
# Lisence: MIT
# Author: SuLingGG
# Blog: https://mlapp.cn
#=================================================

mkdir -p files/etc/openclash/core
mkdir -p files/usr/share/openclash/ui/yacd
mkdir -p files/usr/share/openclash/ui/dashboard
mkdir -p files/usr/share/openclash/ui/metacubexd

CORE_VER="https://raw.githubusercontent.com/vernesong/OpenClash/core/dev/core_version"
CORE_TYPE=$(echo $WRT_TARGET | grep -Eiq "64|86" && echo "amd64" || echo "arm64")
CORE_TUN_VER=$(curl -sL $CORE_VER | sed -n "2{s/\r$//;p;q}")

CLASH_DEV_URL="https://github.com/vernesong/OpenClash/raw/core/dev/dev/clash-linux-$CORE_TYPE.tar.gz"
CLASH_META_URL="https://github.com/vernesong/OpenClash/raw/core/dev/meta/clash-linux-$CORE_TYPE.tar.gz"
CLASH_TUN_URL="https://github.com/vernesong/OpenClash/raw/core/dev/premium/clash-linux-$CORE_TYPE-$CORE_TUN_VER.gz"

GEOIP_URL="https://github.com/Loyalsoldier/v2ray-rules-dat/releases/latest/download/geoip.dat"
GEOSITE_URL="https://github.com/Loyalsoldier/v2ray-rules-dat/releases/latest/download/geosite.dat"
GEO_MMDB="https://raw.githubusercontent.com/Loyalsoldier/geoip/release/Country-only-cn-private.mmdb"

YACD_META_URL="https://github.com/DustinWin/clash_singbox-tools/releases/download/Dashboard/Yacd-meta.tar.gz"
RAZORD_META_URL="https://github.com/DustinWin/clash_singbox-tools/releases/download/Dashboard/Razord-meta.tar.gz"
METACUBEXD_META_URL="https://github.com/DustinWin/clash_singbox-tools/releases/download/Dashboard/metacubexd.tar.gz"

               

wget -qO- $CLASH_DEV_URL | tar xOvz > files/etc/openclash/core/clash
wget -qO- $CLASH_TUN_URL | gunzip -c > files/etc/openclash/core/clash_tun
wget -qO- $CLASH_META_URL | tar xOvz > files/etc/openclash/core/clash_meta
wget -qO- $GEOIP_URL > files/etc/openclash/GeoIP.dat
wget -qO- $GEOSITE_URL > files/etc/openclash/GeoSite.dat
wget -qO- $GEO_MMDB > files/etc/openclash/Country-only-cn-private.mmdb
wget -qO- $YACD_META_URL | tar xvz -C files/usr/share/openclash/ui/yacd
wget -qO- $RAZORD_META_URL | tar xvz -C files/usr/share/openclash/ui/dashboard
wget -qO- $METACUBEXD_META_URL | tar xvz -C files/usr/share/openclash/ui/metacubexd


chmod +x files/etc/openclash/core/clash*
