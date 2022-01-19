#!/bin/bash
# Copyright (c) 2019-2020 P3TERX <https://p3terx.com>
# DIY扩展二合一了，在此处可以增加插件
# 自行拉取插件之前请SSH连接进入固件配置里面确认过没有你要的插件再单独拉取你需要的插件
# 不要一下就拉取别人一个插件包N多插件的，多了没用，增加编译错误，自己需要的才好
# 修改IP项的EOF于EOF之间请不要插入其他扩展代码，可以删除或注释里面原本的代码

# 选择argon为默认主题
#sed -i 's/luci-theme-bootstrap/luci-theme-argon/g' feeds/luci/collections/luci/Makefile

# 增加个性名字${Author}默认为你的github账号
sed -i "s/OpenWrt /AutoBuild Firmware Compiled By @waynesg build $(TZ=UTC-8 date "+%Y.%m.%d") @ OpenWrt /g" $ZZZ

# 默认内核
sed -i 's/PATCHVER:=5.10/PATCHVER:=5.15/g' target/linux/x86/Makefile 

# K3专用，编译K3的时候只会出K3固件
#sed -i 's|^TARGET_|# TARGET_|g; s|# TARGET_DEVICES += phicomm-k3|TARGET_DEVICES += phicomm-k3|' target/linux/bcm53xx/image/Makefile

# ttyd设置空密码
#sed -i 's/\/bin\/login/\/bin\/login -f root/' /etc/config/ttyd

# 修改连接数
sed -i '/customized in this file/a net.netfilter.nf_conntrack_max=165535' package/base-files/files/etc/sysctl.conf

echo 'Replace openwrt.org in diagnostics.htm with www.baidu.com...'
sed -i "/exit 0/d" package/lean/default-settings/files/zzz-default-settings
cat <<EOF >>package/lean/default-settings/files/zzz-default-settings
uci set luci.diag.ping=www.baidu.com
uci set luci.diag.route=www.baidu.com
uci set luci.diag.dns=www.baidu.com
uci commit luci
exit 0
EOF

sed -i 's/\"services\"/\"control\"/g' feeds/luci/applications/luci-app-wol/luasrc/controller/wol.lua

# 修改插件名字
echo 'Modify default name in system menu'
#system menu
sed -i 's/"Web 管理"/"Web管理"/g' `grep "Web 管理" -rl ./`
sed -i 's/"管理权"/"权限管理"/g' feeds/luci/modules/luci-base/po/zh-cn/base.po
sed -i 's/"重启"/"立即重启"/g' feeds/luci/modules/luci-base/po/zh-cn/base.po
#sed -i 's/"系统"/"系统设置"/g' feeds/luci/modules/luci-base/po/zh-cn/base.po
sed -i 's/"挂载点"/"挂载路径"/g' feeds/luci/modules/luci-base/po/zh-cn/base.po
sed -i 's/"启动项"/"启动管理"/g' feeds/luci/modules/luci-base/po/zh-cn/base.po
sed -i 's/"软件包"/"软件管理"/g' feeds/luci/modules/luci-base/po/zh-cn/base.po
sed -i 's/"TTYD 终端"/"命令终端"/g' package/lean/luci-app-ttyd/po/zh-cn/terminal.po
sed -i 's/"Argon 主题设置"/"主题设置"/g' `grep "Argon 主题设置" -rl ./`
echo 'Modify default name in control menu'
#others
sed -i 's/"网络存储"/"存储"/g' `grep "网络存储" -rl ./`
sed -i 's/"Turbo ACC 网络加速"/"网络加速"/g' package/lean/luci-app-turboacc/po/zh-cn/turboacc.po
sed -i 's/"实时流量监测"/"流量"/g' `grep "实时流量监测" -rl ./`
sed -i 's/"USB 打印服务器"/"打印服务"/g' `grep "USB 打印服务器" -rl ./`
sed -i 's/"带宽监控"/"监控"/g' `grep "带宽监控" -rl ./`
sed -i 's/"在线用户"/"在线设备"/g' package/waynesg/luci-app-onliner/luasrc/controller/onliner.lua
#sed -i 's/"autoipsetadder"/"自动设置IP"/g' `grep "autoipsetadder" -rl ./`
echo 'Modify default name in services menu'
#services menu
sed -i 's/"DDNS.to内网穿透"/"DDNSTO"/g' `grep "DDNS.to内网穿透" -rl ./`
sed -i 's/"解锁网易云灰色歌曲"/"网易音乐"/g' package/lean/luci-app-unblockmusic/po/zh-cn/unblockmusic.po
sed -i 's/天翼家庭云\/云盘提速/天翼云盘/g' package/lean/luci-app-familycloud/luasrc/controller/familycloud.lua
sed -i 's/"AdGuard Home"/"AdHome"/g' `grep "AdGuard Home" -rl ./`
sed -i 's/"Frp 内网穿透"/"Frp客户端"/g' `grep "Frp 内网穿透" -rl ./`
sed -i 's/ShadowSocksR Plus+/SSR Plus+/g' package/waynesg/luci-app-ssr-plus/luci-app-ssr-plus/luasrc/controller/shadowsocksr.lua
sed -i 's/msgstr "UPnP"/msgstr "UPnP服务"/g' feeds/luci/applications/luci-app-upnp/po/zh-cn/upnp.po
sed -i 's/Hello World/VisualSSR/g'  package/waynesg/luci-app-vssr/luasrc/controller/vssr.lua
#sed -i 's/Adblock Plus+/Adb Plus+/g'  package/waynesg/luci-app-adblock-plus/luasrc/controller/adblock.lua
#sed -i 's/CPU占用率限制/CPU调节/g' package/waynesg/luci-app-cpulimit/po/zh_Hans/cpulimit.po
#sed -i 's/"KMS 服务器"/"KMS激活"/g' `grep "KMS 服务器" -rl ./`
#sed -i 's/"WebGuide"/"网页导航"/g' package/waynesg/luci-app-webguide/luasrc/controller/webguide.lua
#sed -i 's/"iKoolProxy 滤广告"/"广告过滤"/g' package/waynesg/luci-app-ikoolproxy/luasrc/controller/koolproxy.lua
#sed -i 's/"TelegramBot"/"电报机器人"/g'  package/waynesg/luci-app-telegrambot/luasrc/controller/telegrambot.lua
#sed -i 's/"Nezha Agent"/"哪吒面板"/g'  package/waynesg/luci-app-nezha/luasrc/controller/nezha-agent.lua
#sed -i 's/"WebGuide"/"网页导航"/g'  package/waynesg/luci-app-webguide/luasrc/controller/webguide.lua
#sed -i 's/"Webd 网盘"/"WebDisk"/g'  package/waynesg/luci-app-webd/po/zh-cn/webd.po
#sed -i 's/"Go 阿里云盘 WebDAV"/"阿里云盘"/g' `grep "Go 阿里云盘 WebDAV" -rl ./`
#sed -i 's/"阿里云盘 WebDAV"/"阿里云盘"/g' `grep "阿里云盘 WebDAV" -rl ./`
#sed -i 's/京东签到服务/京东签到/g' package/lean/luci-app-jd-dailybonus/luasrc/controller/jd-dailybonus.lua
#sed -i 's/"UU游戏加速器"/"UU加速器"/g' `grep "UU游戏加速器" -rl ./`
#sed -i 's/UU游戏加速器/UU加速器/g' package/lean/luci-app-uugamebooster/po/zh-cn/uuplugin.po
#sed -i 's/"Rclone"/"Rclone挂载"/g' package/lean/luci-app-rclone/luasrc/controller/rclone.lua
echo 'Modify default name in network menu'
#network
sed -i 's/内网测速网页版/内网测速/g' package/waynesg/luci-app-speedtest-web/po/zh-cn/speedtest-web.po
sed -i 's/"IP\/MAC绑定"/"地址绑定"/g' package/lean/luci-app-arpbind/po/zh-cn/arpbind.po
