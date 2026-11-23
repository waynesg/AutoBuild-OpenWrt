#!/bin/sh
# 主题升级后重跑：恢复设备型号图标 + 品牌 OUI
cp -f /etc/carbon-icons/brands.enhanced.js /www/luci-static/carbon/brands.js
rm -rf /tmp/luci-modulecache /tmp/luci-indexcache 2>/dev/null
echo "Device icons restored."
