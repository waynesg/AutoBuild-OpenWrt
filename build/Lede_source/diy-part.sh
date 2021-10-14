#!/bin/bash
# Copyright (c) 2019-2020 P3TERX <https://p3terx.com>
# DIY扩展二合一了，在此处可以增加插件
# 自行拉取插件之前请SSH连接进入固件配置里面确认过没有你要的插件再单独拉取你需要的插件
# 不要一下就拉取别人一个插件包N多插件的，多了没用，增加编译错误，自己需要的才好
# 修改IP项的EOF于EOF之间请不要插入其他扩展代码，可以删除或注释里面原本的代码


sed -i 's/luci-theme-bootstrap/luci-theme-argon/g' feeds/luci/collections/luci/Makefile           # 选择argon为默认主题

sed -i "s/OpenWrt /AutoBuild Firmware Compiled By @waynesg build $(TZ=UTC-8 date "+%Y.%m.%d") @ OpenWrt /g" $ZZZ          # 增加个性名字${Author}默认为你的github账号

#sed -i 's/PATCHVER:=4.14/PATCHVER:=4.19/g' target/linux/x86/Makefile                             # 默认内核为4.14，修改内核为4.19
# K3专用，编译K3的时候只会出K3固件
#sed -i 's|^TARGET_|# TARGET_|g; s|# TARGET_DEVICES += phicomm-k3|TARGET_DEVICES += phicomm-k3|' target/linux/bcm53xx/image/Makefile
# 修改插件名字
sed -i 's/"网络存储"/"存储"/g' `grep "网络存储" -rl ./`
sed -i 's/"Turbo ACC 网络加速"/"网络加速"/g' `grep "Turbo ACC 网络加速" -rl ./`
sed -i 's/"实时流量监测"/"流量"/g' `grep "实时流量监测" -rl ./`
sed -i 's/"KMS 服务器"/"KMS激活"/g' `grep "KMS 服务器" -rl ./`
sed -i 's/"TTYD 终端"/"系统终端"/g' `grep "TTYD 终端" -rl ./`
sed -i 's/"USB 打印服务器"/"打印服务"/g' `grep "USB 打印服务器" -rl ./`
sed -i 's/"带宽监控"/"监控"/g' `grep "带宽监控" -rl ./`
sed -i 's/"阿里云盘 WebDAV"/"阿里云盘"/g' `grep "阿里云盘 WebDAV" -rl ./`
sed -i 's/"京东签到服务"/"京东签到"/g' `grep "京东签到服务" -rl ./`
sed -i 's/"DDNS.to内网穿透"/"DDNSTO"/g' `grep "DDNS.to内网穿透" -rl ./`
sed -i 's/"解锁网易云灰色歌曲"/"网易音乐"/g' `grep "解锁网易云灰色歌曲" -rl ./`
sed -i 's/"天翼家庭云/云盘提速"/"天翼云盘"/g' `grep "天翼家庭云/天翼云盘提速" -rl ./`
sed -i 's/"Argon 主题设置"/"主题设置"/g' `grep "Argon 主题设置" -rl ./`
sed -i 's/"重启"/"重启路由"/g' `grep "重启" -rl ./`
sed -i 's/"Web 管理"/"页面管理"/g' `grep "Web 管理" -rl ./`
sed -i 's/"ShadowSocksR Plus+"/"SSR Plus+"/g' `grep "ShadowSocksR Plus+" -rl ./`
sed -i 's/"UU游戏加速器"/"游戏加速"/g' `grep "UU游戏加速器" -rl ./`
sed -i 's/"Frp 内网穿透"/"内网穿透"/g' `grep "Frp 内网穿透" -rl ./`
