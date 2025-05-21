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
set -e
# 设置架构和路径
ARCH="amd64"
TMP_DIR="/tmp/openclash"
CORE_DIR="package/waynesg/luci-app-openclash/luci-app-openclash/root/etc/openclash/core"
DATA_DIR="package/waynesg/luci-app-openclash/luci-app-openclash/root/etc/openclash"

# 核心下载链接
CLASH_META_URL="https://raw.githubusercontent.com/vernesong/OpenClash/core/dev/meta/clash-linux-${ARCH}.tar.gz"

# GEO 数据文件
GEOIP_URL="https://github.com/Loyalsoldier/v2ray-rules-dat/releases/latest/download/geoip.dat"
GEOSITE_URL="https://github.com/Loyalsoldier/v2ray-rules-dat/releases/latest/download/geosite.dat"
GEO_MMDB_URL="https://raw.githubusercontent.com/Loyalsoldier/geoip/release/Country-only-cn-private.mmdb"

# 创建临时目录
mkdir -p "$TMP_DIR"
mkdir -p "$CORE_DIR"
mkdir -p "$DATA_DIR"

# 下载 Clash Meta 核心
echo ">>> 下载 Clash Meta 内核..."
curl -sL --retry 3 -m 30 "$CLASH_META_URL" -o "$TMP_DIR/clash.tar.gz"
tar -xOzf "$TMP_DIR/clash.tar.gz" > "$CORE_DIR/clash_meta"
chmod +x "$CORE_DIR/clash_meta"

# 下载 GEO 文件
echo ">>> 下载 geoip.dat..."
curl -sL --retry 3 -m 30 "$GEOIP_URL" -o "$DATA_DIR/geoip.dat"

echo ">>> 下载 geosite.dat..."
curl -sL --retry 3 -m 30 "$GEOSITE_URL" -o "$DATA_DIR/geosite.dat"

echo ">>> 下载 Country.mmdb..."
curl -sL --retry 3 -m 30 "$GEO_MMDB_URL" -o "$DATA_DIR/Country.mmdb"

# 清理
rm -rf "$TMP_DIR"

# 显示版本
echo -n ">>> Clash Meta 核心版本："
"$CORE_DIR/clash_meta" -v || echo "执行失败"

echo "✅ 所有文件已成功下载并准备就绪。"


mkdir -p files/usr/share/openclash/ui/yacd
mkdir -p files/usr/share/openclash/ui/dashboard
mkdir -p files/usr/share/openclash/ui/metacubexd
mkdir -p files/usr/share/openclash/ui/zashboard

YACD_META_URL="https://github.com/DustinWin/proxy-tools/releases/download/Dashboard/Yacd-meta.tar.gz"
YACD_URL="https://github.com/DustinWin/proxy-tools/releases/download/Dashboard/yacd.tar.gz"
METACUBEXD_META_URL="https://github.com/DustinWin/proxy-tools/releases/download/Dashboard/metacubexd.tar.gz"
ZASHBOARD_META_URL="https://github.com/DustinWin/proxy-tools/releases/download/Dashboard/zashboard.tar.gz"

wget -qO- $YACD_META_URL | tar xvz -C files/usr/share/openclash/ui/yacd
wget -qO- $YACD_URL | tar xvz -C files/usr/share/openclash/ui/dashboard
wget -qO- $METACUBEXD_META_URL | tar xvz -C files/usr/share/openclash/ui/metacubexd
wget -qO- $ZASHBOARD_META_URL | tar xvz -C files/usr/share/openclash/ui/zashboard
