#!/bin/bash

# create directory
[[ ! -d package/waynesg ]] && mkdir -p package/waynesg

# Access Control
cp -rf ../immortalwrt-luci/applications/luci-app-accesscontrol package/waynesg/

# ADBYBY Plus +
# svn export -q https://github.com/coolsnowwolf/luci/trunk/applications/luci-app-adbyby-plus package/waynesg/luci-app-adbyby-plus
# cp -rf ../immortalwrt-packages/net/adbyby package/waynesg/

# arpbind
cp -rf ../immortalwrt-luci/applications/luci-app-arpbind package/waynesg/

# AutoCore
cp -rf ../immortalwrt/package/emortal/autocore package/waynesg/
cp -rf ../immortalwrt/package/utils/mhz package/utils/
cp -rf ../immortalwrt-luci/modules/luci-base/root/usr/share/rpcd/ucode/luci feeds/luci/modules/luci-base/root/usr/libexec/rpcd/
# grant getCPUUsage access
sed -i 's|"getTempInfo"|"getTempInfo", "getCPUBench", "getCPUUsage"|g' package/waynesg/autocore/files/generic/luci-mod-status-autocore.json

# automount
cp -rf ../lede/package/lean/automount package/waynesg/
cp -rf ../lede/package/lean/ntfs3-mount package/waynesg/
# backport ntfs3 patches
cp -rf ../lede/target/linux/generic/files-5.10 target/linux/generic/

# cpufreq
cp -rf ../immortalwrt-luci/applications/luci-app-cpufreq package/waynesg/

# DDNS
cp -rf ../immortalwrt-packages/net/ddns-scripts_{aliyun,dnspod} package/waynesg/

# dnsmasq: add filter aaa option
cp -rf ../build/Official/patches/910-add-filter-aaaa-option-support.patch package/network/services/dnsmasq/patches/
patch -p1 -i ../build/Official/patches/dnsmasq-add-filter-aaaa-option.patch
patch -d feeds/luci -p1 -i ../../../build/Official/patches/filter-aaaa-luci.patch

# dnsmasq: use nft ruleset for dns_redirect
patch -p1 -i ../build/Official/patches/dnsmasq-use-nft-ruleset-for-dns_redirect.patch

# Filetransfer
cp -rf ../immortalwrt-luci/applications/luci-app-filetransfer package/waynesg/
cp -rf ../immortalwrt-luci/libs/luci-lib-fs package/waynesg/

# FullCone nat for nftables
# patch kernel
cp -f ../immortalwrt/target/linux/generic/hack-5.10/952-net-conntrack-events-support-multiple-registrant.patch target/linux/generic/hack-5.10/
# fullconenat-nft
cp -rf ../immortalwrt/package/network/utils/fullconenat-nft package/network/utils/
# patch libnftnl
cp -rf ../immortalwrt/package/libs/libnftnl/patches package/libs/libnftnl/
sed -i '/PKG_INSTALL:=1/i\PKG_FIXUP:=autoreconf' package/libs/libnftnl/Makefile
# patch nftables
#cp -f ../immortalwrt/package/network/utils/nftables/patches/002-nftables-add-fullcone-expression-support.patch package/network/utils/nftables/patches/
rm -rf package/network/utils/nftables/
cp -rf ../immortalwrt/package/network/utils/nftables package/network/utils/
# patch firewall4
#cp -rf ../immortalwrt/package/network/config/firewall4/patches package/network/config/firewall4/
#sed -i 's|+kmod-nft-nat +kmod-nft-nat6|+kmod-nft-nat +kmod-nft-nat6 +kmod-nft-fullcone|g' package/network/config/firewall4/Makefile
# patch luci
patch -d feeds/luci -p1 -i ../../../build/Official/patches/fullconenat-luci.patch

# mbedtls
rm -rf package/libs/mbedtls
cp -rf ../immortalwrt/package/libs/mbedtls package/libs/

# OLED
# svn export -q https://github.com/NateLol/luci-app-oled/trunk package/waynesg/luci-app-oled

# OpenClash
# svn export -q https://github.com/vernesong/OpenClash/trunk/luci-app-openclash package/waynesg/luci-app-openclash

# Realtek R8125, RTL8152/8153, RTL8192EU
cp -rf ../immortalwrt/package/kernel/{r8125,r8152,rtl8192eu} package/waynesg/

# Release Ram
cp -rf ../immortalwrt-luci/applications/luci-app-ramfree package/waynesg/

# Scheduled Reboot
# cp -rf ../immortalwrt-luci/applications/luci-app-autoreboot package/waynesg/

# SeverChan
# svn export -q https://github.com/tty228/luci-app-serverchan/trunk package/waynesg/luci-app-serverchan

# ShadowsocksR Plus+
svn export -q https://github.com/fw876/helloworld/trunk package/helloworld
svn export -q https://github.com/coolsnowwolf/packages/trunk/net/shadowsocks-libev package/helloworld/shadowsocks-libev
rm -rf ./feeds/packages/net/{xray-core,shadowsocks-libev}

# USB Printer
cp -rf ../immortalwrt-luci/applications/luci-app-usb-printer package/waynesg/

# Zerotier
cp -rf ../immortalwrt-luci/applications/luci-app-zerotier package/waynesg/

# default settings and translation
cp -rf ../build/Official/default-settings package/waynesg/

# fix include luci.mk
find package/waynesg/ -type f -name Makefile -exec sed -i 's,../../luci.mk,$(TOPDIR)/feeds/luci/luci.mk,g' {} +
