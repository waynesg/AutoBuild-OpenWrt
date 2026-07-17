#!/bin/bash
set -e

ARCH="${1:-amd64}"

echo ">>> 正在使用架构: ${ARCH}"

mkdir -p files/etc/openclash/core
mkdir -p files/etc/openclash
mkdir -p files/usr/share/openclash/ui/{yacd,dashboard,metacubexd,zashboard}

MIHOMO_PAGE="https://github.com/vernesong/mihomo/releases/expanded_assets/Prerelease-Alpha"

echo ">>> 正在获取 Mihomo 下载链接..."

MIHOMO_PATH=$(wget -qO- "$MIHOMO_PAGE" \
  | grep -oE "/vernesong/mihomo/releases/download/[^\"']*mihomo-linux-${ARCH}[^\"']*\.gz" \
  | grep -vE "\.(deb|rpm)$" \
  | head -n1)

if [ -z "$MIHOMO_PATH" ]; then
  echo "❌ 未找到 Mihomo 核心下载链接，架构: ${ARCH}"
  exit 1
fi

MIHOMO_URL="https://github.com${MIHOMO_PATH}"

echo ">>> 下载地址: ${MIHOMO_URL}"

GEOIP_URL="https://github.com/Loyalsoldier/v2ray-rules-dat/releases/latest/download/geoip.dat"
GEOSITE_URL="https://github.com/Loyalsoldier/v2ray-rules-dat/releases/latest/download/geosite.dat"
GEO_MMDB_URL="https://raw.githubusercontent.com/Loyalsoldier/geoip/release/Country-only-cn-private.mmdb"

YACD_META_URL="https://github.com/DustinWin/proxy-tools/releases/download/Dashboard/Yacd-meta.tar.gz"
METACUBEXD_META_URL="https://github.com/DustinWin/proxy-tools/releases/download/Dashboard/metacubexd.tar.gz"
ZASHBOARD_META_URL="https://github.com/DustinWin/proxy-tools/releases/download/Dashboard/zashboard.tar.gz"

echo ">>> 下载 Mihomo 核心..."

wget -O /tmp/mihomo.gz "$MIHOMO_URL"

if ! file /tmp/mihomo.gz | grep -qi "gzip compressed data"; then
  echo "❌ 下载到的不是 gzip 文件，请检查下载地址："
  echo "$MIHOMO_URL"
  file /tmp/mihomo.gz
  exit 1
fi

gunzip -c /tmp/mihomo.gz > files/etc/openclash/core/clash_meta
chmod +x files/etc/openclash/core/clash_meta

echo ">>> 下载 UI 面板..."

wget -qO- "$YACD_META_URL" | tar -xz -C files/usr/share/openclash/ui/yacd
wget -qO- "$METACUBEXD_META_URL" | tar -xz -C files/usr/share/openclash/ui/metacubexd
wget -qO- "$ZASHBOARD_META_URL" | tar -xz -C files/usr/share/openclash/ui/zashboard

echo ">>> 下载 GEO 数据库..."

wget -qO files/etc/openclash/GeoIP.dat "$GEOIP_URL"
wget -qO files/etc/openclash/GeoSite.dat "$GEOSITE_URL"
wget -qO files/etc/openclash/Country-only-cn-private.mmdb "$GEO_MMDB_URL"

echo -n ">>> 核心版本: "
files/etc/openclash/core/clash_meta -v || echo "执行失败"

echo "✅ 所有文件已准备完毕，将打入固件。"
