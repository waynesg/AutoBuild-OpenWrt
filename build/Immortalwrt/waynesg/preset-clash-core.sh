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
mkdir -p files/usr/share/openclash/ui/zashboard


CORE_VERSION_URL="https://raw.githubusercontent.com/vernesong/OpenClash/core/dev/core_version"
CLASH_META_VER=$(curl -sL $CORE_VERSION_URL | sed -n '3p')
echo ">>> 当前 Meta 核心版本：$CLASH_META_VER"
#CLASH_DEV_URL="https://github.com/vernesong/OpenClash/raw/core/dev/dev/clash-linux-$CORE_TYPE.tar.gz"
#CLASH_TUN_URL="https://github.com/vernesong/OpenClash/raw/core/dev/premium/clash-linux-$CORE_TYPE-$CORE_TUN_VER.gz"

CLASH_META_URL="https://github.com/vernesong/OpenClash/releases/download/mihomo/clash-linux-amd64.tar.gz"

GEOIP_URL="https://github.com/Loyalsoldier/v2ray-rules-dat/releases/latest/download/geoip.dat"
GEOSITE_URL="https://github.com/Loyalsoldier/v2ray-rules-dat/releases/latest/download/geosite.dat"
GEO_MMDB="https://raw.githubusercontent.com/Loyalsoldier/geoip/release/Country-only-cn-private.mmdb"

YACD_META_URL="https://github.com/DustinWin/proxy-tools/releases/download/Dashboard/Yacd-meta.tar.gz"
YACD_URL="https://github.com/DustinWin/proxy-tools/releases/download/Dashboard/yacd.tar.gz"
METACUBEXD_META_URL="https://github.com/DustinWin/proxy-tools/releases/download/Dashboard/metacubexd.tar.gz"
ZASHBOARD_META_URL="https://github.com/DustinWin/proxy-tools/releases/download/Dashboard/zashboard.tar.gz"

               

#wget -qO- $CLASH_DEV_URL | tar xOvz > files/etc/openclash/core/clash
#wget -qO- $CLASH_TUN_URL | gunzip -c > files/etc/openclash/core/clash_tun
wget -qO- $CLASH_META_URL | tar xOvz > files/etc/openclash/core/clash_meta
wget -qO- $GEOIP_URL > files/etc/openclash/GeoIP.dat
wget -qO- $GEOSITE_URL > files/etc/openclash/GeoSite.dat
wget -qO- $GEO_MMDB > files/etc/openclash/Country-only-cn-private.mmdb
wget -qO- $YACD_META_URL | tar xvz -C files/usr/share/openclash/ui/yacd
wget -qO- $YACD_URL | tar xvz -C files/usr/share/openclash/ui/dashboard
wget -qO- $METACUBEXD_META_URL | tar xvz -C files/usr/share/openclash/ui/metacubexd
wget -qO- $ZASHBOARD_META_URL | tar xvz -C files/usr/share/openclash/ui/zashboard

chmod +x files/etc/openclash/core/clash*
