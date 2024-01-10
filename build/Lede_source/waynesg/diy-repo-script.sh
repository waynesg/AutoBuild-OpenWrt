#!/bin/bash
function mvdir() {
mv -n `find $1/* -maxdepth 0 -type d` ./
rm -rf $1
}

CURRENT_PATH=$(pwd)

clone_or_update_git_repo() {
  # 参数检查
  if [ "$#" -lt 2 ]; then
    echo "Usage: clone_or_update_git_repo <git_url> <target_directory> [branch] [subdirectory]"
    return 1
  fi

  local git_url="$1"
  local source_target_directory="$2"
  local target_directory="$2"
  local branch="$3"
  local subdirectory="$4"

  if [ -n "$subdirectory" ]; then
    target_directory=$CURRENT_PATH/repos/$(echo "$git_url" | awk -F'/' '{print $(NF-1)"-"$NF}')
  fi

  # 检查目标目录是否存在
  if [ -d "$target_directory" ]; then
    pushd "$target_directory" || return 1
    git pull
    popd
  else
    if [ -n "$branch" ]; then
      git clone --depth=1 -b "$branch" "$git_url" "$target_directory"
    else
      git clone --depth=1 "$git_url" "$target_directory"
    fi
  fi

  if [ -n "$subdirectory" ]; then
    cp -a $target_directory/$subdirectory $source_target_directory
  fi
}

# theme
git clone --depth=1 -b 18.06 https://github.com/jerrykuku/luci-theme-argon waynesg/luci-theme-argon
git clone --depth=1 https://github.com/sirpdboy/luci-theme-opentopd waynesg/luci-theme-opentopd
git clone --depth=1 -b 18.06 https://github.com/kiddin9/luci-theme-edge waynesg/luci-theme-edge
git clone --depth=1 https://github.com/thinktip/luci-theme-neobird.git waynesg/luci-theme-neobird
clone_or_update_git_repo https://github.com/sirpdboy/sirpdboy-package waynesg/luci-theme-opentomcat "" luci-theme-opentomcat
# argon-theme-config
git clone --depth=1 -b 18.06 https://github.com/jerrykuku/luci-app-argon-config waynesg/luci-app-argon-config
#mosdns
git clone --depth=1 -b v5 https://github.com/sbwml/luci-app-mosdns waynesg/luci-app-mosdns
#ssr-plus
clone_or_update_git_repo https://github.com/fw876/helloworld waynesg/luci-app-ssr-plus master luci-app-ssr-plus
#passwall
clone_or_update_git_repo https://github.com/xiaorouji/openwrt-passwall waynesg/luci-app-passwall luci-smartdns-dev luci-app-passwall
#git clone --depth 1 https://github.com/xiaorouji/openwrt-passwall -b luci-smartdns-dev openwrt-passwall && mv openwrt-passwall waynesg/luci-app-passwall
git clone --depth=1 https://github.com/xiaorouji/openwrt-passwall2 waynesg/luci-app-passwall2
git clone --depth=1 https://github.com/xiaorouji/openwrt-passwall-packages waynesg/luci-app-dependence
git clone --depth=1 https://github.com/jerrykuku/node-request waynesg/luci-app-dependence/node-request
git clone --depth=1 https://github.com/jerrykuku/lua-maxminddb waynesg/lua-maxminddb
clone_or_update_git_repo https://github.com/fw876/helloworld waynesg/luci-app-dependence/lua-neturl master lua-neturl
clone_or_update_git_repo https://github.com/fw876/helloworld waynesg/luci-app-dependence/shadow-tls master shadow-tls    
clone_or_update_git_repo https://github.com/kenzok8/small waynesg/luci-app-dependence/redsocks2 "" redsocks2
clone_or_update_git_repo https://github.com/kiddin9/openwrt-packages waynesg/luci-app-dependence/wrtbwmon "" wrtbwmon
#openclash
git clone --depth=1 -b dev https://github.com/vernesong/OpenClash waynesg/luci-app-openclash
#serverchan
git clone --depth 1 https://github.com/tty228/luci-app-serverchan waynesg/luci-app-serverchan
#poweroff
git clone --depth=1 https://github.com/esirplayground/luci-app-poweroff waynesg/luci-app-poweroff
#openappfilter
git clone --depth=1 https://github.com/destan19/OpenAppFilter waynesg/luci-app-oaf
#advanced
clone_or_update_git_repo https://github.com/sirpdboy/sirpdboy-package waynesg/luci-app-advanced "" luci-app-advanced
#speedlimited
clone_or_update_git_repo https://github.com/sirpdboy/sirpdboy-package waynesg/luci-app-control-speedlimit "" luci-app-control-speedlimit
#filebrowser
clone_or_update_git_repo https://github.com/Lienol/openwrt-package waynesg/luci-app-filebrowser "" luci-app-filebrowser
#fileassistant
clone_or_update_git_repo https://github.com/sirpdboy/sirpdboy-package waynesg/luci-app-fileassistant "" luci-app-fileassistant
#timewol
clone_or_update_git_repo https://github.com/kiddin9/openwrt-packages waynesg/luci-app-control-timewol "" luci-app-control-timewol
#weburl
clone_or_update_git_repo https://github.com/kiddin9/openwrt-packages waynesg/luci-app-control-weburl "" luci-app-control-weburl
#webrestriction
clone_or_update_git_repo https://github.com/kiddin9/openwrt-packages waynesg/luci-app-control-webrestriction "" luci-app-control-webrestriction
#speedlimited
clone_or_update_git_repo https://github.com/kiddin9/openwrt-packages waynesg/luci-app-control-speedlimit "" luci-app-control-speedlimit
#ikoolproxy
git clone --depth=1 https://github.com/iyaof/luci-app-ikoolproxy waynesg/luci-app-ikoolproxy
#unblockneteasemusic
git clone -depth=1 -b master https://github.com/UnblockNeteaseMusic/luci-app-unblockneteasemusic waynesg/luci-app-unblockneteasemusic
#pushbot
git clone -depth=1 https://github.com/zzsj0928/luci-app-pushbot waynesg/luci-app-pushbot
#iptv
git clone -depth=1 https://github.com/riverscn/openwrt-iptvhelper waynesg/luci-app-iptvhelper
git clone -depth=1 -b 18.06 https://github.com/riverscn/luci-app-omcproxy waynesg/luci-app-omcproxy
#cloudflareSppedtest
clone_or_update_git_repo https://github.com/kiddin9/openwrt-packages waynesg/luci-app-cloudflarespeedtest "" luci-app-cloudflarespeedtest
clone_or_update_git_repo https://github.com/immortalwrt-collections/openwrt-cdnspeedtest waynesg/luci-app-cloudflarespeedtest/cdnspeedtest "" cdnspeedtest
#speedtest
git clone -depth=1 https://github.com/sirpdboy/netspeedtest waynesg/luci-app-netspeedtest
#onliner
clone_or_update_git_repo https://github.com/Hyy2001X/AutoBuild-Packages waynesg/luci-app-onliner "" luci-app-onliner
#alist
git clone -depth=1 https://github.com/sbwml/luci-app-alist waynesg/luci-app-alist
#parents-control
git clone -depth=1 https://github.com/sirpdboy/luci-app-parentcontrol waynesg/luci-app-parentcontrol
#msd_lite
git clone -depth=1 https://github.com/ximiTech/luci-app-msd_lite waynesg/luci-app-msd_lite
git clone -depth=1 https://github.com/ximiTech/msd_lite waynesg/luci-app-msd_lite/msd_lite
#airconnect
git clone -depth=1 https://github.com/sbwml/luci-app-airconnect waynesg/luci-app-airconnect
#eqosplus
git clone -depth=1 https://github.com/sirpdboy/luci-app-eqosplus waynesg/luci-app-eqosplus
#homeproxy
git clone --depth=1 https://github.com/immortalwrt/homeproxy waynesg/luci-app-homeproxy
#subconverter
git clone --depth=1 https://github.com/tindy2013/openwrt-subconverter ./luci-app-subconverter


