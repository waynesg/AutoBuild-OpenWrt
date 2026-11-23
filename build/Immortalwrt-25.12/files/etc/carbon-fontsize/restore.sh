#!/bin/sh
cp -f /etc/carbon-fontsize/carbon.css.orig /www/luci-static/carbon/carbon.css
rm -rf /tmp/luci-modulecache /tmp/luci-indexcache 2>/dev/null
echo "Carbon font size restored to theme default."
