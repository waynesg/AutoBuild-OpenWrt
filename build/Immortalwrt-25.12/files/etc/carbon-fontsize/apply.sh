#!/bin/sh
awk -f /etc/carbon-fontsize/resize.awk /etc/carbon-fontsize/carbon.css.orig > /www/luci-static/carbon/carbon.css
rm -rf /tmp/luci-modulecache /tmp/luci-indexcache 2>/dev/null
echo "Carbon font size applied (vantage-level: 15px base)."
