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

set -e
ARCH="amd64"
OUT_PATH="files/etc/openclash/core/clash_meta"
CLASH_META_URL="https://github.com/vernesong/OpenClash/releases/download/Meta/clash-linux-${ARCH}.tar.gz"
echo ">>> 下载 Clash Meta 内核：$CLASH_META_URL"
curl -L "$CLASH_META_URL" | tar xOvz > "$OUT_PATH"
chmod +x "$OUT_PATH"
echo -n ">>> 当前核心版本："
"$OUT_PATH" -v

GEOIP_URL="https://github.com/Loyalsoldier/v2ray-rules-dat/releases/latest/download/geoip.dat"
GEOSITE_URL="https://github.com/Loyalsoldier/v2ray-rules-dat/releases/latest/download/geosite.dat"
GEO_MMDB="https://raw.githubusercontent.com/Loyalsoldier/geoip/release/Country-only-cn-private.mmdb"

YACD_META_URL="https://github.com/DustinWin/proxy-tools/releases/download/Dashboard/Yacd-meta.tar.gz"
YACD_URL="https://github.com/DustinWin/proxy-tools/releases/download/Dashboard/yacd.tar.gz"
METACUBEXD_META_URL="https://github.com/DustinWin/proxy-tools/releases/download/Dashboard/metacubexd.tar.gz"
ZASHBOARD_META_URL="https://github.com/DustinWin/proxy-tools/releases/download/Dashboard/zashboard.tar.gz"

               

#wget -qO- $CLASH_DEV_URL | tar xOvz > files/etc/openclash/core/clash
#wget -qO- $CLASH_TUN_URL | gunzip -c > files/etc/openclash/core/clash_tun
#wget -qO- $CLASH_META_URL | tar xOvz > files/etc/openclash/core/clash_meta
wget -qO- $GEOIP_URL > files/etc/openclash/GeoIP.dat
wget -qO- $GEOSITE_URL > files/etc/openclash/GeoSite.dat
wget -qO- $GEO_MMDB > files/etc/openclash/Country-only-cn-private.mmdb
wget -qO- $YACD_META_URL | tar xvz -C files/usr/share/openclash/ui/yacd
wget -qO- $YACD_URL | tar xvz -C files/usr/share/openclash/ui/dashboard
wget -qO- $METACUBEXD_META_URL | tar xvz -C files/usr/share/openclash/ui/metacubexd
wget -qO- $ZASHBOARD_META_URL | tar xvz -C files/usr/share/openclash/ui/zashboard

chmod +x files/etc/openclash/core/clash*
