#!/bin/sh
# 主题升级后重跑：统一设备图标为白底黑标/黑底白标 + 圆形边界 + 轮廓
# 幂等：先移除旧覆盖层，再追加新片段
TARGET=/www/luci-static/carbon/carbon.css
FRAG=/etc/carbon-icons/icon-style.css
[ -f "$TARGET" ] || exit 1
# 移除旧覆盖段（从标记起至文件末），旧版样式都追加在末尾
if grep -q 'device icon uniform style' "$TARGET" 2>/dev/null; then
  awk '/\/\* === device icon uniform style/{exit} {print}' "$TARGET" > /tmp/.carbon_base.css
  cp -f /tmp/.carbon_base.css "$TARGET"
  rm -f /tmp/.carbon_base.css
fi
cat "$FRAG" >> "$TARGET"
rm -rf /tmp/luci-modulecache /tmp/luci-indexcache 2>/dev/null
echo "Icon style v2 applied."
