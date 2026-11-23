#!/bin/sh
# 恢复 Carbon 主题原始图标
cp -f /etc/carbon-icons/brands.js.orig /www/luci-static/carbon/brands.js
rm -rf /tmp/luci-modulecache /tmp/luci-indexcache 2>/dev/null
echo "Device icons restored to theme default."
