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
#!/bin/bash
set -e

ARCH="${1:-amd64}"  # 默认为 amd64，可传参
echo ">>> 正在使用架构: $ARCH"

# 创建目录结构
mkdir -p files/etc/openclash/core
mkdir -p files/etc/openclash
mkdir -p files/usr/share/openclash/ui/{yacd,dashboard,metacubexd,zashboard}

# SMART核心
MIHOMO_PAGE="https://github.com/vernesong/mihomo/releases/expanded_assets/Prerelease-Alpha"
MIHOMO_URL=$(wget -qO- "$MIHOMO_PAGE" | grep -oE "/vernesong/mihomo/releases/download/[^\"']*mihomo-linux-${ARCH}-alpha-smart[^\"']*.gz" | head -n1)
MIHOMO_URL="https://github.com${MIHOMO_URL}"
echo ">>> 下载地址: $MIHOMO_URL"
# 面板下载链接
GEOIP_URL="https://github.com/Loyalsoldier/v2ray-rules-dat/releases/latest/download/geoip.dat"
GEOSITE_URL="https://github.com/Loyalsoldier/v2ray-rules-dat/releases/latest/download/geosite.dat"
GEO_MMDB_URL="https://raw.githubusercontent.com/Loyalsoldier/geoip/release/Country-only-cn-private.mmdb"

YACD_META_URL="https://github.com/DustinWin/proxy-tools/releases/download/Dashboard/Yacd-meta.tar.gz"
YACD_URL="https://github.com/DustinWin/proxy-tools/releases/download/Dashboard/yacd.tar.gz"
METACUBEXD_META_URL="https://github.com/DustinWin/proxy-tools/releases/download/Dashboard/metacubexd.tar.gz"
ZASHBOARD_META_URL="https://github.com/DustinWin/proxy-tools/releases/download/Dashboard/zashboard.tar.gz"

# 下载并解压 Mihomo 核心
echo ">>> 下载 Mihomo 核心..."
wget -qO- "$MIHOMO_URL" | gunzip -c > files/etc/openclash/core/clash_meta
chmod +x files/etc/openclash/core/clash_meta

# 下载 UI 面板
echo ">>> 下载 UI 面板..."
wget -qO- "$YACD_META_URL" | tar -xz -C files/usr/share/openclash/ui/yacd
wget -qO- "$YACD_URL" | tar -xz -C files/usr/share/openclash/ui/dashboard
wget -qO- "$METACUBEXD_META_URL" | tar -xz -C files/usr/share/openclash/ui/metacubexd
wget -qO- "$ZASHBOARD_META_URL" | tar -xz -C files/usr/share/openclash/ui/zashboard

# 下载 GEO 数据库
echo ">>> 下载 GEO 数据库..."
wget -qO files/etc/openclash/GeoIP.dat "$GEOIP_URL"
wget -qO files/etc/openclash/GeoSite.dat "$GEOSITE_URL"
wget -qO files/etc/openclash/Country-only-cn-private.mmdb "$GEO_MMDB_URL"

# 显示最终版本信息
echo -n ">>> 核心版本: "
files/etc/openclash/core/clash_meta -v || echo "执行失败"

echo "✅ 所有文件已准备完毕，将打入固件。"


# mkdir -p files/etc/openclash/core
# mkdir -p files/usr/share/openclash/ui/yacd
# mkdir -p files/usr/share/openclash/ui/dashboard
# mkdir -p files/usr/share/openclash/ui/metacubexd
# mkdir -p files/usr/share/openclash/ui/zashboard

# CLASH_META_URL="https://raw.githubusercontent.com/vernesong/OpenClash/master/core-lateset/meta/clash-linux-${1}.tar.gz"
# GEOIP_URL="https://github.com/Loyalsoldier/v2ray-rules-dat/releases/latest/download/geoip.dat"
# GEOSITE_URL="https://github.com/Loyalsoldier/v2ray-rules-dat/releases/latest/download/geosite.dat"
# GEO_MMDB_URL="https://raw.githubusercontent.com/Loyalsoldier/geoip/release/Country-only-cn-private.mmdb"

# YACD_META_URL="https://github.com/DustinWin/proxy-tools/releases/download/Dashboard/Yacd-meta.tar.gz"
# YACD_URL="https://github.com/DustinWin/proxy-tools/releases/download/Dashboard/yacd.tar.gz"
# METACUBEXD_META_URL="https://github.com/DustinWin/proxy-tools/releases/download/Dashboard/metacubexd.tar.gz"
# ZASHBOARD_META_URL="https://github.com/DustinWin/proxy-tools/releases/download/Dashboard/zashboard.tar.gz"

# wget -qO- $CLASH_META_URL | tar xOvz > files/etc/openclash/core/clash_meta
# wget -qO- $YACD_META_URL | tar xvz -C files/usr/share/openclash/ui/yacd
# wget -qO- $YACD_URL | tar xvz -C files/usr/share/openclash/ui/dashboard
# wget -qO- $METACUBEXD_META_URL | tar xvz -C files/usr/share/openclash/ui/metacubexd
# wget -qO- $ZASHBOARD_META_URL | tar xvz -C files/usr/share/openclash/ui/zashboard
# wget -qO- $GEOIP_URL > files/etc/openclash/GeoIP.dat
# wget -qO- $GEOSITE_URL > files/etc/openclash/GeoSite.dat
# wget -qO- $GEO_MMDB_URL > files/etc/openclash/Country-only-cn-private.mmdb

# chmod +x files/etc/openclash/core/clash*
