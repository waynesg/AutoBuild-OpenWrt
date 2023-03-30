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
TIME y "添加软件包"
rm -rf package/waynesg && git clone -b js https://github.com/waynesg/OpenWrt-Software package/waynesg

echo
TIME r "删除无用主题"
rm -rf ./feeds/luci/themes/luci-theme-argon
rm -rf ./feeds/luci/themes/luci-theme-material
TIME r "删除重复插件"
rm -rf ./feeds/luci/applications/luci-app-argon-config
rm -rf package/waynesg/luci-app-netdata
rm -rf ./feeds/luci/applications/luci-app-serverchan
rm -rf ./feeds/luci/applications/luci-app-pushbot
rm -rf ./feeds/luci/applications/luci-app-mosdns
rm -rf ./feeds/luci/applications/luci-app-omcproxy
rm -rf ./feeds/luci/applications/luci-app-cpufreq
rm -rf ./feeds/luci/applications/luci-app-cpulimit
rm -rf ./feeds/packages/net/mosdns
rm -rf ./feeds/packages/net/alist
rm -rf ./feeds/packages/net/brook
rm -rf ./feeds/packages/net/cdnspeedtest
rm -rf ./feeds/packages/net/chinadns-ng
rm -rf ./feeds/packages/net/dns2socks
rm -rf ./feeds/packages/net/dns2tcp
rm -rf ./feeds/packages/net/dnsforwarder
rm -rf ./feeds/packages/net/hysteria
rm -rf ./feeds/packages/net/microsocks
rm -rf ./feeds/packages/net/naiveproxy
rm -rf ./feeds/packages/net/open-app-filter
rm -rf ./feeds/packages/net/shadowsocks-rust
rm -rf ./feeds/packages/net/shadowsocksr-libev
rm -rf ./feeds/packages/net/simple-obfs
rm -rf ./feeds/packages/net/subconverter
rm -rf ./feeds/packages/net/trojan
rm -rf ./feeds/packages/net/trojan-go
rm -rf ./feeds/packages/net/trojan-plus
rm -rf ./feeds/packages/net/v2ray-core
rm -rf ./feeds/packages/net/v2ray-plugin
rm -rf ./feeds/packages/net/xray-core
rm -rf ./feeds/packages/net/xray-plugin
rm -rf ./feeds/packages/net/tcping
rm -rf ./feeds/packages/net/ipt2socks
rm -rf ./feeds/packages/net/adguardhome
rm -rf ./feeds/packages/net/go-aliyundrive-webdav
rm -rf ./feeds/packages/net/msd_lite
rm -rf ./feeds/packages/net/pdnsd-alt
rm -rf ./feeds/packages/net/v2ray-geodata
rm -rf ./feeds/packages/utils/cpulimit
rm -rf ./feeds/packages/net/kcptun
rm -rf ./feeds/packages/lang/lua-neturl
rm -rf ./feeds/packages/lang/lua-maxminddb
rm -rf ./feeds/packages/libs/quickjspp
rm -rf ./feeds/packages/libs/libcron
rm -rf ./feeds/packages/libs/rapidjson
rm -rf ./feeds/packages/libs/toml11
rm -rf ./feeds/luci/libs/luci-lib-ipkg
rm -rf package/waynesg/luci-app-diskman
rm -rf package/waynesg/luci-app-eqos
rm -rf package/waynesg/luci-app-fileassistant
rm -rf package/waynesg/luci-app-filebrowser
rm -rf package/waynesg/luci-app-gowebdav
rm -rf package/waynesg/luci-app-ipsec-vpnserver-manyusers
rm -rf package/waynesg/luci-app-iptvhelper
rm -rf package/waynesg/luci-app-msd_lite
rm -rf package/waynesg/luci-app-openvpn-server
rm -rf ./feeds/luci/applications/luci-app-passwall
rm -rf package/waynesg/luci-app-socat
rm -rf package/waynesg/luci-app-ssr-plus
rm -rf ./feeds/luci/applications/luci-app-turboacc
rm -rf package/waynesg/luci-app-unblockneteasemusic
rm -rf package/waynesg/luci-app-usb-printer
rm -rf package/waynesg/luci-app-vsftpd
rm -rf ./feeds/luci/applications/luci-app-vssr
rm -rf package/waynesg/luci-app-zerotier

echo
TIME b "修改 系统文件..."
# curl -fsSL https://raw.githubusercontent.com/waynesg/OpenWrt-Software/main/openwrt-diy/zzz-default-settings > ./package/lean/default-settings/files/zzz-default-settings
# curl -fsSL https://raw.githubusercontent.com/waynesg/OpenWrt-Software/main/openwrt-diy/index.htm > ./package/emortal/autocore/files/x86/index.htm
# curl -fsSL https://raw.githubusercontent.com/waynesg/OpenWrt-Software/main/openwrt-diy/ethinfo > ./package/emortal/autocore/files/x86/sbin/ethinfo
# curl -fsSL https://raw.githubusercontent.com/waynesg/OpenWrt-Software/main/openwrt-diy/autocore > ./package/lean/autocore/files/x86/autocore
# curl -fsSL https://raw.githubusercontent.com/waynesg/OpenWrt-Software/main/openwrt-diy/tempinfo > ./package/lean/autocore/files/x86/sbin/tempinfo
# curl -fsSL https://raw.githubusercontent.com/waynesg/OpenWrt-Software/main/openwrt-diy/cntime > ./package/lean/autocore/files/x86/sbin/cntime
# curl -fsSL https://raw.githubusercontent.com/waynesg/OpenWrt-Software/main/openwrt-diy/cpuinfo > ./package/lean/autocore/files/x86/sbin/cpuinfo
# curl -fsSL https://raw.githubusercontent.com/immortalwrt/packages/master/net/dnsproxy/Makefile > feeds/packages/net/dnsproxy/Makefile
# rm -rf ./package/lean/autocore/files/x86/sbin/getcpu
TIME b "系统文件 修改完成"

#echo 
#TIME y "更换内核为5.4"
#sed -i 's/KERNEL_PATCHVER:=5.15/KERNEL_PATCHVER:=5.4/g' ./target/linux/x86/Makefile

#echo 
#TIME y "更新固件 编译日期"
#sed -i "s/2022.02.01/$(TZ=UTC-8 date "+%Y.%m.%d")/g" package/emortal/autocore/files/x86/index.htm

echo 
TIME y "自定义固件版本名字"
sed -i "s/OpenWrt /AutoBuild Firmware Compiled By @waynesg build $(TZ=UTC-8 date "+%Y.%m.%d") @ OpenWrt /g" $ZZZ

echo
TIME y "更换golang版本"
rm -rf feeds/packages/lang/golang
svn export https://github.com/sbwml/packages_lang_golang/branches/19.x feeds/packages/lang/golang

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

echo 
TIME y ”关闭开机串口跑码“
sed -i 's/console=tty0//g'  target/linux/x86/image/Makefile

# ttyd设置空密码
#sed -i 's/\/bin\/login/\/bin\/login -f root/' /etc/config/ttyd

echo 
TIME y "修改连接数"
sed -i '/customized in this file/a net.netfilter.nf_conntrack_max=165535' package/base-files/files/etc/sysctl.conf

## containerd临时关闭hash验证
#sed -i 's/PKG_HASH.*/PKG_HASH:=skip/' feeds/packages/utils/containerd/Makefile

echo
TIME y "添加upx"
sed -i 's/"PKG_BUILD_DEPENDS:=golang\/host homebox\/host"/"PKG_BUILD_DEPENDS:=golang\/host homebox\/host upx\/host"/g' package/waynesg/luci-app-netspeedtest/homebox/Makefile
sed -i 's/"PKG_BUILD_DEPENDS:=golang\/host"/"PKG_BUILD_DEPENDS:=golang\/host upx\/host"/g' package/waynesg/luci-app-mosdns/mosdns/Makefile

echo
TIME b "菜单 调整..."
#sed -i 's/\"services\"/\"control\"/g' feeds/luci/applications/luci-app-wol/luasrc/controller/wol.lua
#sed -i 's/\"services\"/\"control\"/g' package/waynesg/luci-app-accesscontrol-plus/luasrc/controller/miaplus.lua
sed -i 's/\"network\"/\"control\"/g'  package/waynesg/luci-app-oaf/luci-app-oaf/luasrc/controller/appfilter.lua

echo
TIME b "自定义文件修复权限"
chmod -R 755 package/waynesg
echo
TIME g "配置更新完成"