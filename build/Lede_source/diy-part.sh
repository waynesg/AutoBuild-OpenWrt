#!/bin/bash
# Copyright (c) 2019-2020 P3TERX <https://p3terx.com>
# DIY扩展二合一了，在此处可以增加插件
# 自行拉取插件之前请SSH连接进入固件配置里面确认过没有你要的插件再单独拉取你需要的插件
# 不要一下就拉取别人一个插件包N多插件的，多了没用，增加编译错误，自己需要的才好
# 修改IP项的EOF于EOF之间请不要插入其他扩展代码，可以删除或注释里面原本的代码

TIME() {
[[ -z "$1" ]] && {
	echo -ne " "
} || {
     case $1 in
	r) export Color="\e[31;1m";;
	g) export Color="\e[32;1m";;
	b) export Color="\e[34;1m";;
	y) export Color="\e[33;1m";;
	z) export Color="\e[35;1m";;
	l) export Color="\e[36;1m";;
      esac
	[[ $# -lt 2 ]] && echo -e "\e[36m\e[0m ${1}" || {
		echo -e "\e[36m\e[0m ${Color}${2}\e[0m"
	 }
      }
}

# echo 
# TIME y "更新固件编译日期"
# sed -i "s/2022.02.01/$(TZ=UTC-8 date "+%Y.%m.%d")/g" package/lean/autocore/files/x86/index.htm

echo 
TIME y "自定义固件版本名字"
# sed -i "s/'LEDE ' /AutoBuild Firmware Compiled By @waynesg build $(TZ=UTC-8 date "+%Y.%m.%d") @ OpenWrt /g" $ZZZ
sed -i "s/DISTRIB_DESCRIPTION=' *LEDE *'/DISTRIB_DESCRIPTION='AutoBuild Firmware Compiled By @waynesg'/" $ZZZ
sed -i "s/DISTRIB_REVISION='R24.10.24'/DISTRIB_REVISION='build $(TZ=UTC-8 date "+%Y.%m.%d") @ LEDE'/" $ZZZ

echo 
TIME y "调整网络诊断地址到baidu.com"
sed -i "/exit 0/d" package/lean/default-settings/files/zzz-default-settings
cat <<EOF >>package/lean/default-settings/files/zzz-default-settings
uci set luci.diag.ping=www.baidu.com
uci set luci.diag.route=www.baidu.com
uci set luci.diag.dns=www.baidu.com
uci commit luci
exit 0
EOF

echo 
TIME y "已关闭开机串口跑码"
sed -i 's/console=tty0//g'  target/linux/x86/image/Makefile

echo 
TIME y "ttyd自动登录"
sed -i "s?/bin/login?/usr/libexec/login.sh?g" feeds/packages/utils/ttyd/files/ttyd.config

echo 
TIME y "samba解除root限制"
sed -i 's/invalid users = root/#&/g' feeds/packages/net/samba4/files/smb.conf.template

echo 
TIME y "修改连接数"
sed -i '/customized in this file/a net.netfilter.nf_conntrack_max=165535' package/base-files/files/etc/sysctl.conf

echo 
TIME y "下载UnblockNeteaseMusic内核"
NAME=$"package/waynesg/luci-app-unblockneteasemusic/root/usr/share/unblockneteasemusic" && mkdir -p $NAME/core
curl 'https://api.github.com/repos/UnblockNeteaseMusic/server/commits?sha=enhanced&path=precompiled' -o commits.json
echo "$(grep sha commits.json | sed -n "1,1p" | cut -c 13-52)">"$NAME/core_local_ver"
curl -L https://github.com/UnblockNeteaseMusic/server/raw/enhanced/precompiled/app.js -o $NAME/core/app.js
curl -L https://github.com/UnblockNeteaseMusic/server/raw/enhanced/precompiled/bridge.js -o $NAME/core/bridge.js
curl -L https://github.com/UnblockNeteaseMusic/server/raw/enhanced/ca.crt -o $NAME/core/ca.crt
curl -L https://github.com/UnblockNeteaseMusic/server/raw/enhanced/server.crt -o $NAME/core/server.crt
curl -L https://github.com/UnblockNeteaseMusic/server/raw/enhanced/server.key -o $NAME/core/server.key

echo
TIME y "修改dashboard password"
sed -i '/uci -q set openclash.config.dashboard_password/d' package/waynesg/luci-app-openclash/luci-app-openclash/root/etc/uci-defaults/luci-openclash
sed -i '/uci add openclash/,/^md5sum /d' package/waynesg/luci-app-openclash/luci-app-openclash/root/etc/uci-defaults/luci-openclash

echo
TIME y "更换golang版本"
rm -rf feeds/packages/lang/golang
git clone https://github.com/sbwml/packages_lang_golang -b 22.x feeds/packages/lang/golang

#echo 
#TIME y "更换内核"
#sed -i 's/KERNEL_PATCHVER:=6.6/KERNEL_PATCHVER:=6.6/g' ./target/linux/x86/Makefile
#sed -i 's/LINUX_VERSION-6.6 = .50/LINUX_VERSION-6.6 = .46/g' ./include/kernel-6.6
#sed -i 's/LINUX_KERNEL_HASH-6.6.50 = c065e36daf28210060c91a37ef3e92ac5814784e634577e04e406297ead2e86e/LINUX_KERNEL_HASH-6.6.46 = 052f932396d9c7d84ceeda91226a8ef797c12188bde41e6c419602d990dd45f2/g' ./include/kernel-6.6

echo
TIME y "添加upx"
#sed -i 's/"PKG_BUILD_DEPENDS:=golang\/host homebox\/host"/"PKG_BUILD_DEPENDS:=golang\/host homebox\/host upx\/host"/g' package/waynesg/luci-app-netspeedtest/homebox/Makefile
sed -i 's/"PKG_BUILD_DEPENDS:=golang\/host"/"PKG_BUILD_DEPENDS:=golang\/host upx\/host"/g' package/waynesg/luci-app-mosdns/mosdns/Makefile

echo
TIME b "汉化 调整..."
sed -i 's/CPU Load/处理器负载/g' package/waynesg/luci-app-cpu-status/htdocs/luci-static/resources/view/status/include/18_cpu.js
rm -rf package/waynesg/luci-app-cpu-status/po/zh_Hans/cpu-status.po
wget -O package/waynesg/luci-app-cpu-status/po/zh_Hans/cpu-status.po https://raw.githubusercontent.com/waynesg/scripts/main/others/cpu-status.po
#tn-netports调整
sed -i '/var title = E.*netports-title/,/);/c\var title = E('"'"'div'"'"', { class: '"'"'netports-title'"'"' }, [\n\t\t\t\tE('"'"'div'"'"', { class: '"'"'netports-buttons'"'"' }, buttons),\n\t\t\t\tE('"'"'div'"'"', { class: '"'"'netports-version'"'"' })\n\t\t\t]);' package/waynesg/luci-app-tn-netports/htdocs/luci-static/resources/netports.js
################################################################################################################
echo
TIME b "菜单 调整..."
# 调整菜单路径
echo "调整菜单路径..."
sed -i 's|/services/|/system/|' feeds/luci/applications/luci-app-ttyd/root/usr/share/luci/menu.d/luci-app-ttyd.json
sed -i 's|/services/|/nas/|' feeds/luci/applications/luci-app-alist/root/usr/share/luci/menu.d/luci-app-alist.json
sed -i 's|/services/|/nas/|' feeds/luci/applications/luci-app-samba4/root/usr/share/luci/menu.d/luci-app-samba4.json
sed -i 's|/services/|/network/|' feeds/luci/applications/luci-app-nlbwmon/root/usr/share/luci/menu.d/luci-app-nlbwmon.json
sed -i 's|/services/|/network/|' feeds/luci/applications/luci-app-upnp/root/usr/share/luci/menu.d/luci-app-upnp.json

# 重命名系统菜单
echo "重命名系统菜单..."
sed -i 's/"概览"/"系统概览"/g' feeds/luci/modules/luci-base/po/zh_Hans/base.po
sed -i 's/"备份与升级"/"备份升级"/g' feeds/luci/modules/luci-base/po/zh_Hans/base.po
sed -i 's/"路由"/"路由映射"/g' feeds/luci/modules/luci-base/po/zh_Hans/base.po
sed -i 's/"管理权"/"权限管理"/g' feeds/luci/modules/luci-base/po/zh_Hans/base.po
sed -i 's/"重启"/"立即重启"/g' feeds/luci/modules/luci-base/po/zh_Hans/base.po
sed -i 's/"挂载点"/"挂载路径"/g' feeds/luci/modules/luci-base/po/zh_Hans/base.po
sed -i 's/"启动项"/"启动管理"/g' feeds/luci/modules/luci-base/po/zh_Hans/base.po
sed -i 's/"软件包"/"软件管理"/g' $(grep "软件包" -rl ./)
sed -i 's/"终端"/"命令终端"/g' feeds/luci/applications/luci-app-ttyd/po/zh_Hans/ttyd.po
sed -i 's/"在线用户"/"在线设备"/g' package/waynesg/luci-app-onliner/luasrc/controller/onliner.lua
sed -i 's/"Argon 主题设置"/"主题设置"/g' package/waynesg/luci-app-argon-config/po/zh_Hans/argon-config.po

# 重命名控制菜单
echo "重命名控制菜单..."
sed -i 's/"网络存储"/"存储"/g' $(grep "网络存储" -rl ./)
sed -i 's/"Turbo ACC 网络加速"/"网络加速"/g' feeds/luci/applications/luci-app-turboacc/po/zh_Hans/turboacc.po
sed -i 's/"实时流量监测"/"流量"/g' $(grep "实时流量监测" -rl ./)
sed -i 's/"USB 打印服务器"/"打印服务"/g' $(grep "USB 打印服务器" -rl ./)

# 重命名服务菜单
echo "重命名服务菜单..."
sed -i 's/"AirConnect"/"隔空传送"/g' package/waynesg/luci-app-airconnect/luci-app-airconnect/root/usr/share/luci/menu.d/luci-app-airconnect.json
#sed -i '/"admin\/services\/smartdns": {/,/}/s/"depends": {/"order": 10,\n            "depends": {/' feeds/luci/applications/luci-app-smartdns/root/usr/share/luci/menu.d/luci-app-smartdns.json
#sed -i 's/\(entry({\"admin\", \"services\", appname\}.*,\s*\)\([0-9-]\+\)\s*)/0)/' feeds/luci/applications/luci-app-passwall2/luasrc/controller/passwall2.lua
sed -i 's/"order": 30,/"order": 60,/' package/waynesg/luci-app-wechatpush/root/usr/share/luci/menu.d/luci-app-wechatpush.json
sed -i 's/"解除网易云音乐播放限制"/"网易音乐"/g' package/waynesg/luci-app-unblockneteasemusic/root/usr/share/luci/menu.d/luci-app-unblockneteasemusic.json
sed -i 's/msgstr "UPnP"/msgstr "UPnP服务"/g' feeds/luci/applications/luci-app-upnp/po/zh_Hans/upnp.po
sed -i 's/"KMS 服务器"/"KMS服务"/g' $(grep "KMS 服务器" -rl ./)

# 重命名网络菜单
echo "重命名网络菜单..."
sed -i 's/DHCP\/DNS/DNS设定/g' feeds/luci/modules/luci-base/po/zh_Hans/base.po
sed -i 's/"接口"/"网络接口"/g' $(grep "接口" -rl ./)
sed -i 's/"Socat"/"端口转发"/g' $(grep "Socat" -rl ./)
sed -i "s/set network\.vpn0\.ifname='tun0'/set network.vpn0.device='tun0'/g" feeds/luci/applications/luci-app-openvpn-server/root/etc/uci-defaults/openvpn

# 重命名管控菜单
echo "重命名管控菜单..."
sed -i '$a msgid "Control"' package/waynesg/luci-app-oaf/luci-app-oaf/po/zh_Hans/oaf.po
sed -i '$a msgstr "管控"' package/waynesg/luci-app-oaf/luci-app-oaf/po/zh_Hans/oaf.po
sed -i 's/"services"/"control"/g' package/waynesg/luci-app-oaf/luci-app-oaf/luasrc/controller/appfilter.lua
sed -i 's|/services/|/control/|' feeds/luci/applications/luci-app-wol/root/usr/share/luci/menu.d/luci-app-wol.json

# 重命名存储菜单
echo "重命名存储菜单..."
sed -i 's/"USB 打印服务器"/"打印服务"/g' feeds/luci/applications/luci-app-usb-printer/po/zh_Hans/luci-app-usb-printer.po
sed -i 's/"FTP 服务器"/"FTP 服务"/g' feeds/luci/applications/luci-app-vsftpd/po/zh_Hans/vsftpd.po
sed -i 's/"AList"/"Alist列表"/g' feeds/luci/applications/luci-app-alist/root/usr/share/luci/menu.d/luci-app-alist.json

# 重命名VPN菜单
echo "重命名VPN菜单..."
sed -i 's/"ZeroTier"/"ZeroTier虚拟网络"/g' feeds/luci/applications/luci-app-zerotier/root/usr/share/luci/menu.d/luci-app-zerotier.json
sed -i 's/"OpenVPN"/"OpenVPN 客户端"/g' feeds/luci/applications/luci-app-openvpn/luasrc/controller/openvpn.lua
TIME b "重命名 完成"
echo
chmod -R 755 package/waynesg
echo
TIME g "配置更新完成"
