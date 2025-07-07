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
# curl -o default-settings https://raw.githubusercontent.com/waynesg/scripts/main/others/default-settings
# cp -f default-settings package/emortal/default-settings/files/99-default-settings

sed -i "/^\. \/etc\/openwrt_release/a\\
sed -i '/DISTRIB_REVISION/d' /etc/openwrt_release\n\
echo \"DISTRIB_REVISION='v\$(date +'%Y.%m.%d')'\" >> /etc/openwrt_release\n\
sed -i '/DISTRIB_RELEASE/d' /etc/openwrt_release\n\
echo \"DISTRIB_RELEASE='v\$(date +'%Y.%m.%d')'\" >> /etc/openwrt_release\n\
 sed -i '/DISTRIB_DESCRIPTION/d' /etc/openwrt_release\n\
 echo \"DISTRIB_DESCRIPTION='AutoBuild Firmware Compiled By @waynesg Build \$(TZ=UTC-8 date \"+%Y.%m.%d\") @ OpenWrt '\" >> /etc/openwrt_release
" package/emortal/default-settings/files/99-default-settings

 curl -fsSL "https://raw.githubusercontent.com/waynesg/scripts/refs/heads/main/others/01_sysinfo" -o "target/linux/x86/base-files/lib/preinit/01_sysinfo"

#替换autocore
# rm -rf package/emortal/autocore
# git clone --depth=1 https://github.com/coolsnowwolf/lede.git temp_lede
# mv temp_lede/package/lean/autocore package/emortal/autocore
# rm -rf temp_lede

cat << 'EOF' > files/etc/uci-defaults/99-restore-shadow
#!/bin/sh
# Auto restore /etc/shadow from backup if present
[ -f /etc/.shadow.backup ] && cp -f /etc/.shadow.backup /etc/shadow && chmod 600 /etc/shadow
EOF

chmod +x files/etc/uci-defaults/99-restore-shadow

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
TIME y "ttyd自动登录"
sed -i "s?/bin/login?/usr/libexec/login.sh?g" feeds/packages/utils/ttyd/files/ttyd.config

echo
TIME y "修改最大连接数修改为65535"
sed -i '/customized in this file/a net.netfilter.nf_conntrack_max=65535' package/base-files/files/etc/sysctl.conf

echo
TIME y "更换golang版本"
rm -rf feeds/packages/lang/golang
git clone https://github.com/sbwml/packages_lang_golang -b 24.x feeds/packages/lang/golang

# echo
# TIME y "修改dashboard password"
# sed -i '/uci -q set openclash.config.dashboard_password/d' feeds/luci/applications/luci-app-openclash/root/etc/uci-defaults/luci-openclash
# sed -i '/uci add openclash/,/^md5sum /d' feeds/luci/applications/luci-app-openclash/root/etc/uci-defaults/luci-openclash



# echo
# TIME y "rpcd - fix timeout"
# sed -i 's/option timeout 30/option timeout 60/g' package/system/rpcd/files/rpcd.config
# sed -i 's#20) \* 1000#60) \* 1000#g' feeds/luci/modules/luci-base/htdocs/luci-static/resources/rpc.js

# echo
# TIME y "修正部分从第三方仓库拉取的软件 Makefile 路径问题"
# find package/*/ -maxdepth 2 -path "*/Makefile" | xargs -i sed -i 's/..\/..\/luci.mk/$(TOPDIR)\/feeds\/luci\/luci.mk/g' {}
# find package/*/ -maxdepth 2 -path "*/Makefile" | xargs -i sed -i 's/..\/..\/lang\/golang\/golang-package.mk/$(TOPDIR)\/feeds\/packages\/lang\/golang\/golang-package.mk/g' {}
# find package/*/ -maxdepth 2 -path "*/Makefile" | xargs -i sed -i 's/PKG_SOURCE_URL:=@GHREPO/PKG_SOURCE_URL:=https:\/\/github.com/g' {}
# find package/*/ -maxdepth 2 -path "*/Makefile" | xargs -i sed -i 's/PKG_SOURCE_URL:=@GHCODELOAD/PKG_SOURCE_URL:=https:\/\/codeload.github.com/g' {}
# ############################################################################################################################################################
# ############################################################################################################################################################
# echo
TIME b "汉化 调整..."
sed -i 's/CPU Load/处理器负载/g' package/waynesg/luci-app-cpu-status/htdocs/luci-static/resources/view/status/include/18_cpu.js
rm -rf package/waynesg/luci-app-cpu-status/po/zh_Hans/cpu-status.po
wget -O package/waynesg/luci-app-cpu-status/po/zh_Hans/cpu-status.po https://raw.githubusercontent.com/waynesg/scripts/main/others/cpu-status.po
sed -i "s/'user %'/'用户 %'/g" package/waynesg/luci-app-cpu-status/htdocs/luci-static/resources/view/status/include/18_cpu.js
sed -i "s/'nice %'/'调整优先级 %'/g" package/waynesg/luci-app-cpu-status/htdocs/luci-static/resources/view/status/include/18_cpu.js
sed -i "s/'system %'/'系统 %'/g" package/waynesg/luci-app-cpu-status/htdocs/luci-static/resources/view/status/include/18_cpu.js
sed -i "s/'idle %'/'空闲 %'/g" package/waynesg/luci-app-cpu-status/htdocs/luci-static/resources/view/status/include/18_cpu.js
sed -i "s/'iowait %'/'IO 等待 %'/g" package/waynesg/luci-app-cpu-status/htdocs/luci-static/resources/view/status/include/18_cpu.js
sed -i "s/'irq %'/'硬件中断 %'/g" package/waynesg/luci-app-cpu-status/htdocs/luci-static/resources/view/status/include/18_cpu.js
sed -i "s/'softirq %'/'软中断 %'/g" package/waynesg/luci-app-cpu-status/htdocs/luci-static/resources/view/status/include/18_cpu.js

#tn-netports调整
sed -i '/var title = E.*netports-title/,/);/c\var title = E('"'"'div'"'"', { class: '"'"'netports-title'"'"' }, [\n\t\t\t\tE('"'"'div'"'"', { class: '"'"'netports-buttons'"'"' }, buttons),\n\t\t\t\tE('"'"'div'"'"', { class: '"'"'netports-version'"'"' })\n\t\t\t]);' package/waynesg/luci-app-tn-netports/htdocs/luci-static/resources/netports.js
#删除首页端口状态
mv feeds/luci/modules/luci-mod-status/htdocs/luci-static/resources/view/status/include/29_ports.js feeds/luci/modules/luci-mod-status/htdocs/luci-static/resources/view/status/include/29_ports.js.del

echo
TIME b "菜单 调整..."
sed -i 's|/system/|/nas/|' feeds/luci/applications/luci-app-filemanager/root/usr/share/luci/menu.d/luci-app-filemanager.json
sed -i 's|/services/|/vpn/|' package/waynesg/luci-app-tailscale/root/usr/share/luci/menu.d/luci-app-tailscale.json
sed -i 's|/services/|/control/|' feeds/luci/applications/luci-app-wol/root/usr/share/luci/menu.d/luci-app-wol.json
sed -i 's/\"services\"/\"control\"/g'  package/waynesg/luci-app-oaf/luci-app-oaf/luasrc/controller/appfilter.lua
#sed -i 's|/services/|/network/|' feeds/luci/applications/luci-app-nlbwmon/root/usr/share/luci/menu.d/luci-app-nlbwmon.json
#sed -i 's|/services/|/nas/|' feeds/luci/applications/luci-app-alist/root/usr/share/luci/menu.d/luci-app-alist.json
sed -i '/"title": "SmartDNS",/a \        "order": 22,' feeds/luci/applications/luci-app-smartdns/root/usr/share/luci/menu.d/luci-app-smartdns.json
#sed -i '/"title": "Nikki",/a \        "order": -9,' package/waynesg/luci-app-nikki/luci-app-nikki/root/usr/share/luci/menu.d/luci-app-nikki.json
sed -i 's/("OpenClash"), 50)/("OpenClash"), -10)/g' feeds/luci/applications/luci-app-openclash/luasrc/controller/openclash.lua
#sed -i 's/("Pass Wall"), -1)/("Pass Wall"), -9)/g' package/waynesg/luci-app-passwall/luasrc/controller/passwall.lua
sed -i 's/("PassWall 2"), 0)/("PassWall 2"), -8)/g' package/waynesg/luci-app-passwall2/luci-app-passwall2/luasrc/controller/passwall2.lua
sed -i 's/"网络存储"/"存储"/g' `grep "网络存储" -rl ./`
sed -i 's/"软件包"/"软件管理"/g' `grep "软件包" -rl ./`

echo             
TIME b "插件 重命名..."
echo "重命名系统菜单"
#status menu
sed -i 's/"概览"/"系统概览"/g' feeds/luci/modules/luci-base/po/zh_Hans/base.po
sed -i 's/"路由"/"路由映射"/g' feeds/luci/modules/luci-base/po/zh_Hans/base.po
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
sed -i 's/"Argon 主题设置"/"主题设置"/g' package/waynesg/luci-app-argon-config/po/zh_Hans/argon-config.po

#Argon主题修改
sed -i 's/(<%= ver.luciversion %>)//g' package/waynesg/luci-theme-argon/luasrc/view/themes/argon/footer_login.htm
sed -i 's/<%= ver.distversion %>/Compiled By @waynesg/g' package/waynesg/luci-theme-argon/luasrc/view/themes/argon/footer_login.htm
echo "重命名服务菜单"

#services menu
sed -i 's/"解除网易云音乐播放限制"/"网易音乐"/g' feeds/luci/applications/luci-app-unblockneteasemusic/root/usr/share/luci/menu.d/luci-app-unblockneteasemusic.json
sed -i 's/"Vlmcsd KMS 服务器"/"KMS服务"/g' $(grep "KMS 服务器" -rl ./)
#sed -i 's/"短视频下载"/"视频下载"/g' package/waynesg/luci-app-yt-dlp/po/zh_Hans/yt-dlp.po
sed -i 's/"title": "subconverter"/"title": "节点订阅"/g'  package/waynesg/luci-app-subconverter/luci-app-subconverter/root/usr/share/luci/menu.d/luci-app-subconverter.json

echo "重命名网络菜单"
#network
#sed -i 's/"主机名"/"主机名称"/g' `grep "主机名" -rl ./`
sed -i 's/"接口"/"网络接口"/g' `grep "接口" -rl ./`
sed -i 's/"Socat"/"端口转发"/g'  package/waynesg/luci-app-socat/luasrc/controller/socat.lua
sed -i 's/DHCP\/DNS/DNS设定/g' feeds/luci/modules/luci-base/po/zh_Hans/base.po
sed -i 's/"USB 打印服务器"/"打印服务"/g' $(grep "USB 打印服务器" -rl ./)
sed -i "s/set network\.vpn0\.ifname='tun0'/set network.vpn0.device='tun0'/g" feeds/luci/applications/luci-app-openvpn-server/root/etc/uci-defaults/openvpn
sed -i 's/msgstr "UPnP IGD 和 PCP"/msgstr "UPnP服务"/g' feeds/luci/applications/luci-app-upnp/po/zh_Hans/upnp.po
sed -i 's|/services/|/network/|' feeds/luci/applications/luci-app-upnp/root/usr/share/luci/menu.d/luci-app-upnp.json

echo "重命名管控菜单"
#Control
sed -i '$a\msgid "Control"\nmsgstr "管控"' package/waynesg/luci-app-oaf/luci-app-oaf/po/zh_Hans/oaf.po


echo "重命名存储菜单"
#sed -i 's/"Alist 文件列表"/"Alist列表"/g' package/waynesg/luci-app-alist/luci-app-alist/po/zh_Hans/alist.po
sed -i 's/"USB 打印服务器"/"打印服务"/g' feeds/luci/applications/luci-app-usb-printer/po/zh_Hans/luci-app-usb-printer.po
sed -i 's/"FTP 服务器"/"FTP 服务"/g' feeds/luci/applications/luci-app-vsftpd/po/zh_Hans/vsftpd.po
sed -i 's/"文件管理器"/"文件管理"/g' feeds/luci/applications/luci-app-filemanager/po/zh_Hans/filemanager.po

echo "重命名VPN菜单"
#vpn
sed -i 's/"Cloudflare 零信任隧道"/"Cloudflare 云隧道"/g' feeds/luci/applications/luci-app-cloudflared/po/zh_Hans/cloudflared.po
sed -i 's/"ZeroTier"/"ZeroTier虚拟网络"/g' feeds/luci/applications/luci-app-zerotier/root/usr/share/luci/menu.d/luci-app-zerotier.json
sed -i 's/"OpenVPN"/"OpenVPN 客户端"/g' feeds/luci/applications/luci-app-openvpn/luasrc/controller/openvpn.lua
#sed -i 's/"IPSec VPN Server"/"IPSec VPN 服务器"/g' feeds/luci/applications/luci-app-ipsec-vpnd/root/usr/share/luci/menu.d/luci-app-ipsec-vpnd.json
sed -i 's/"Tailscale"/"TailScale虚拟网络"/g' package/waynesg/luci-app-tailscale/root/usr/share/luci/menu.d/luci-app-tailscale.json
TIME b "重命名 完成"

echo
chmod -R 755 package/waynesg
echo
TIME g "配置更新完成"
