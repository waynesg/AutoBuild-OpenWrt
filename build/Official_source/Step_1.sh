#!/bin/bash

latest_release="$(curl -s https://github.com/openwrt/openwrt/tags | grep -Eo "v[0-9\.]+\-*r*c*[0-9]*.tar.gz" | sed -n '/[2-9][0-9]/p' | sed -n 1p | sed 's/.tar.gz//g')"
#git clone --single-branch -b ${latest_release} https://github.com/openwrt/openwrt openwrt_release
git clone --single-branch -b openwrt-22.03 https://github.com/openwrt/openwrt openwrt
rm -rf immortalwrt

# 获取源代码
git clone -b master --depth 1 https://github.com/immortalwrt/immortalwrt.git immortalwrt
git clone -b openwrt-21.02 --depth 1 https://github.com/immortalwrt/immortalwrt.git immortalwrt_21
git clone -b master --depth 1 https://github.com/immortalwrt/packages.git immortalwrt_pkg
git clone -b master --depth 1 https://github.com/immortalwrt/luci.git immortalwrt_luci
git clone -b master --depth 1 https://github.com/coolsnowwolf/lede.git lede
git clone -b master --depth 1 https://github.com/coolsnowwolf/luci.git lede_luci
git clone -b master --depth 1 https://github.com/coolsnowwolf/packages.git lede_pkg
git clone -b master --depth 1 https://github.com/openwrt/openwrt.git openwrt_ma
git clone -b master --depth 1 https://github.com/openwrt/packages.git openwrt_pkg_ma
git clone -b master --depth 1 https://github.com/openwrt/luci.git openwrt_luci_ma
git clone -b master --depth 1 https://github.com/Lienol/openwrt.git Lienol
git clone -b main --depth 1 https://github.com/Lienol/openwrt-package Lienol_pkg
git clone -b js --depth 1 https://github.com/waynesg/OpenWrt-Software.git waynesg_pkg
git clone -b master --depth 1 https://github.com/nxhack/openwrt-node-packages.git openwrt-node
git clone -b packages --depth 1 https://github.com/xiaorouji/openwrt-passwall passwall_pkg
git clone -b luci-smartdns-new-version --depth 1 https://github.com/xiaorouji/openwrt-passwall passwall_luci
git clone -b main --depth 1 https://github.com/xiaorouji/openwrt-passwall2 passwall2_luci
git clone -b main --depth 1 https://github.com/jjm2473/openwrt-third openwrt-third
git clone -b master --depth 1 https://github.com/lisaac/luci-app-dockerman dockerman
git clone -b master --depth 1 https://github.com/lisaac/luci-app-diskman diskman
git clone -b master --depth 1 https://github.com/lisaac/luci-lib-docker docker_lib
git clone -b v5 --depth 1 https://github.com/sbwml/luci-app-mosdns mosdns
git clone -b master --depth 1 https://github.com/fw876/helloworld ssrp
git clone -b master --depth 1 https://github.com/zxlhhyccc/bf-package-master zxlhhyccc
git clone -b main --depth 1 https://github.com/linkease/openwrt-app-actions linkease
#git clone -b linksys-ea6350v3-mastertrack --depth 1 https://github.com/NoTengoBattery/openwrt NoTengoBattery
exit 0
