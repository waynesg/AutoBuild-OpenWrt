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



echo 
TIME y "自定义固件版本名字"
#sed -i "s/'%D %V %C'/AutoBuild Firmware Compiled By @waynesg build $(TZ=UTC-8 date '+%Y.%m.%d') @ OpenWrt/g" package/base-files/files/etc/openwrt_release
sed -i "s/DISTRIB_DESCRIPTION='.*'/DISTRIB_DESCRIPTION='AutoBuild Firmware Compiled By @waynesg build $(TZ=UTC-8 date '+%Y.%m.%d') @ OpenWrt'/g" package/base-files/files/etc/openwrt_release

echo 
TIME y "调整网络诊断地址到www.baidu.com"
sed -i "/exit 0/d" package/emortal/default-settings/files/99-default-settings
cat <<EOF >>package/emortal/default-settings/files/99-default-settings
uci set luci.diag.ping=www.baidu.com
uci set luci.diag.route=www.baidu.com
uci set luci.diag.dns=www.baidu.com
uci commit luci
exit 0
EOF

#echo 
#TIME y ”关闭开机串口跑码“
#sed -i 's/GRUB_CONSOLE_CMDLINE += console=tty1/GRUB_CONSOLE_CMDLINE += console=tty0/' target/linux/x86/image/Makefile

echo
TIME y "修改最大连接数修改为65535"
sed -i '/customized in this file/a net.netfilter.nf_conntrack_max=65535' package/base-files/files/etc/sysctl.conf

echo
TIME y "修复上移下移按钮翻译"
sed -i 's/<%:Up%>/<%:Move up%>/g' feeds/luci/modules/luci-compat/luasrc/view/cbi/tblsection.htm
sed -i 's/<%:Down%>/<%:Move down%>/g' feeds/luci/modules/luci-compat/luasrc/view/cbi/tblsection.htm

echo
TIME y "更换golang版本"
rm -rf feeds/packages/lang/golang
git clone --depth=1 https://github.com/sbwml/packages_lang_golang feeds/packages/lang/golang

echo
TIME y "修改dashboard password"
sed -i '/uci -q set openclash.config.dashboard_password/d' package/waynesg/luci-app-openclash/luci-app-openclash/root/etc/uci-defaults/luci-openclash
sed -i '/uci add openclash/,/^md5sum /d' package/waynesg/luci-app-openclash/luci-app-openclash/root/etc/uci-defaults/luci-openclash

echo
TIME y "ppp - 2.5.0"
rm -rf package/network/services/ppp
git clone https://github.com/sbwml/package_network_services_ppp package/network/services/ppp

echo
TIME y "添加upx"
sed -i 's/"PKG_BUILD_DEPENDS:=golang\/host"/"PKG_BUILD_DEPENDS:=golang\/host upx\/host"/g' package/waynesg/luci-app-mosdns/mosdns/Makefile

echo
TIME y "防火墙4添加自定义nft命令支持"
curl -s https://$mirror/openwrt/patch/firewall4/100-openwrt-firewall4-add-custom-nft-command-support.patch | patch -p1

pushd feeds/luci
	# 防火墙4添加自定义nft命令选项卡
	curl -s https://$mirror/openwrt/patch/firewall4/0004-luci-add-firewall-add-custom-nft-rule-support.patch | patch -p1
	# 状态-防火墙页面去掉iptables警告，并添加nftables、iptables标签页
	curl -s https://$mirror/openwrt/patch/luci/0004-luci-mod-status-firewall-disable-legacy-firewall-rul.patch | patch -p1
popd

echo
TIME y "补充 firewall4 luci 中文翻译"
cat >> "feeds/luci/applications/luci-app-firewall/po/zh_Hans/firewall.po" <<-EOF
	
	msgid ""
	"Custom rules allow you to execute arbitrary nft commands which are not "
	"otherwise covered by the firewall framework. The rules are executed after "
	"each firewall restart, right after the default ruleset has been loaded."
	msgstr ""
	"自定义规则允许您执行不属于防火墙框架的任意 nft 命令。每次重启防火墙时，"
	"这些规则在默认的规则运行后立即执行。"
	
	msgid ""
	"Applicable to internet environments where the router is not assigned an IPv6 prefix, "
	"such as when using an upstream optical modem for dial-up."
	msgstr ""
	"适用于路由器未分配 IPv6 前缀的互联网环境，例如上游使用光猫拨号时。"

	msgid "NFtables Firewall"
	msgstr "NFtables 防火墙"

	msgid "IPtables Firewall"
	msgstr "IPtables 防火墙"
EOF

echo
TIME y "rpcd - fix timeout"
sed -i 's/option timeout 30/option timeout 60/g' package/system/rpcd/files/rpcd.config
sed -i 's#20) \* 1000#60) \* 1000#g' feeds/luci/modules/luci-base/htdocs/luci-static/resources/rpc.js

echo
TIME y "修正部分从第三方仓库拉取的软件 Makefile 路径问题"
find package/*/ -maxdepth 2 -path "*/Makefile" | xargs -i sed -i 's/..\/..\/luci.mk/$(TOPDIR)\/feeds\/luci\/luci.mk/g' {}
find package/*/ -maxdepth 2 -path "*/Makefile" | xargs -i sed -i 's/..\/..\/lang\/golang\/golang-package.mk/$(TOPDIR)\/feeds\/packages\/lang\/golang\/golang-package.mk/g' {}
find package/*/ -maxdepth 2 -path "*/Makefile" | xargs -i sed -i 's/PKG_SOURCE_URL:=@GHREPO/PKG_SOURCE_URL:=https:\/\/github.com/g' {}
find package/*/ -maxdepth 2 -path "*/Makefile" | xargs -i sed -i 's/PKG_SOURCE_URL:=@GHCODELOAD/PKG_SOURCE_URL:=https:\/\/codeload.github.com/g' {}
############################################################################################################################################################
############################################################################################################################################################
echo
TIME b "汉化 调整..."
sed -i 's/CPU Load/处理器负载/g' package/waynesg/luci-app-cpu-status/htdocs/luci-static/resources/view/status/include/18_cpu.js
rm -rf package/waynesg/luci-app-cpu-status/po/zh_Hans/cpu-status.po
wget -O package/waynesg/luci-app-cpu-status/po/zh_Hans/cpu-status.po https://raw.githubusercontent.com/waynesg/scripts/main/others/cpu-status.po
#tn-netports调整
sed -i '/var title = E.*netports-title/,/);/c\var title = E('"'"'div'"'"', { class: '"'"'netports-title'"'"' }, [\n\t\t\t\tE('"'"'div'"'"', { class: '"'"'netports-buttons'"'"' }, buttons),\n\t\t\t\tE('"'"'div'"'"', { class: '"'"'netports-version'"'"' })\n\t\t\t]);' package/waynesg/luci-app-tn-netports/htdocs/luci-static/resources/netports.js
#删除首页端口状态
mv feeds/luci/modules/luci-mod-status/htdocs/luci-static/resources/view/status/include/29_ports.js feeds/luci/modules/luci-mod-status/htdocs/luci-static/resources/view/status/include/29_ports.js.del

echo
TIME b "菜单 调整..."
sed -i 's|/services/|/control/|' feeds/luci/applications/luci-app-wol/root/usr/share/luci/menu.d/luci-app-wol.json
sed -i 's/\"services\"/\"control\"/g'  package/waynesg/luci-app-oaf/luci-app-oaf/luasrc/controller/appfilter.lua
sed -i 's|/services/|/network/|' feeds/luci/applications/luci-app-nlbwmon/root/usr/share/luci/menu.d/luci-app-nlbwmon.json
sed -i 's|/services/|/nas/|' feeds/luci/applications/luci-app-alist/root/usr/share/luci/menu.d/luci-app-alist.json
sed -i '/"title": "SmartDNS",/a \        "order": 22,' feeds/luci/applications/luci-app-smartdns/root/usr/share/luci/menu.d/luci-app-smartdns.json
sed -i '/"title": "MihomoTProxy",/a \        "order": 15,' package/waynesg/luci-app-mihomo/luci-app-mihomo/root/usr/share/luci/menu.d/luci-app-mihomo.json
sed -i 's/_("OpenClash"), 50/_("OpenClash"), 20/g' package/waynesg/luci-app-openclash/luci-app-openclash/luasrc/controller/openclash.lua
sed -i 's/services/network/g' feeds/luci/applications/luci-app-upnp/root/usr/share/luci/menu.d/luci-app-upnp.json
sed -i 's/"网络存储"/"存储"/g' `grep "网络存储" -rl ./`
sed -i 's/"软件包"/"软件管理"/g' `grep "软件包" -rl ./`

echo             
TIME b "插件 重命名..."
echo "重命名系统菜单"
#status menu
sed -i 's/"概览"/"系统概览"/g' feeds/luci/modules/luci-base/po/zh_Hans/base.po
sed -i 's/"路由"/"路由映射"/g' feeds/luci/modules/luci-base/po/zh_Hans/base.po
sed -i 's/"防火墙"/"安全防护"/g' feeds/luci/modules/luci-base/po/zh_Hans/base.po
sed -i 's/"在线用户"/"在线设备"/g' package/waynesg/luci-app-onliner/luasrc/controller/onliner.lua
#system menu
#sed -i 's/"系统"/"系统设置"/g' feeds/luci/modules/luci-base/po/zh_Hans/base.po
sed -i 's/"管理权"/"权限管理"/g' feeds/luci/modules/luci-base/po/zh_Hans/base.po
sed -i 's/"重启"/"立即重启"/g' feeds/luci/modules/luci-base/po/zh_Hans/base.po
sed -i 's/"备份与升级"/"备份升级"/g' feeds/luci/modules/luci-base/po/zh_Hans/base.po
sed -i 's/"挂载点"/"挂载路径"/g' feeds/luci/modules/luci-base/po/zh_Hans/base.po
sed -i 's/"启动项"/"启动管理"/g' feeds/luci/modules/luci-base/po/zh_Hans/base.po
sed -i 's/"软件包"/"软件管理"/g' feeds/luci/modules/luci-base/po/zh_Hans/base.po
sed -i 's/"终端"/"命令终端"/g' feeds/luci/applications/luci-app-ttyd/po/zh_Hans/ttyd.po
sed -i 's/"Argon 主题设置"/"主题设置"/g' feeds/luci/applications/luci-app-argon-config/po/zh_Hans/argon-config.po

echo "重命名服务菜单"
#services menu
sed -i 's/"解除网易云音乐播放限制"/"网易音乐"/g' feeds/luci/applications/luci-app-unblockneteasemusic/root/usr/share/luci/menu.d/luci-app-unblockneteasemusic.json
sed -i 's/msgstr "UPnP"/msgstr "UPnP服务"/g' feeds/luci/applications/luci-app-upnp/po/zh_Hans/upnp.po
sed -i 's/"MihomoTProxy"/"MiHoMo"/g' package/waynesg/luci-app-mihomo/luci-app-mihomo/root/usr/share/luci/menu.d/luci-app-mihomo.json

echo "重命名网络菜单"
#network
#sed -i 's/"主机名"/"主机名称"/g' `grep "主机名" -rl ./`
sed -i 's/"接口"/"网络接口"/g' `grep "接口" -rl ./`
sed -i 's/"Socat"/"端口转发"/g'  feeds/luci/applications/luci-app-socat/luasrc/controller/socat.lua
#sed -i 's/"IP\/MAC绑定"/"地址绑定"/g' feeds/luci/applications/luci-app-arpbind/po/zh_Hans/arpbind.po
#sed -i 's/"IP\/MAC绑定"/"地址绑定"/g' `grep "IP\/MAC绑定" -rl ./`


echo "重命名存储菜单"
sed -i 's/"AList"/"Alist列表"/g' feeds/luci/applications/luci-app-alist/root/usr/share/luci/menu.d/luci-app-alist.json
sed -i 's/"USB 打印服务器"/"打印服务"/g' feeds/luci/applications/luci-app-usb-printer/po/zh_Hans/luci-app-usb-printer.po
sed -i 's/"FTP 服务器"/"FTP 服务"/g' feeds/luci/applications/luci-app-vsftpd/po/zh_Hans/vsftpd.po

#vpn
sed -i 's/"ZeroTier"/"ZeroTier虚拟网络"/g' feeds/luci/applications/luci-app-zerotier/root/usr/share/luci/menu.d/luci-app-zerotier.json
sed -i 's/"OpenVPN"/"OpenVPN 客户端"/g' feeds/luci/applications/luci-app-openvpn/luasrc/controller/openvpn.lua
TIME b "重命名 完成"

echo
chmod -R 755 package/waynesg
echo
TIME g "配置更新完成"
