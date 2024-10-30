|   序号    |     X86设备  |   X86设备编译状态及下载链接 |   插件配置   | 备注说明   |
| :-----------------: | :-------------: |:-----------------: | :-----------------: |  :-----------------: | 
| 1 |   [![](https://img.shields.io/badge/WayneSG%40OpenWrt-X86__64(Lean)-lightgrey)](https://github.com/waynesg/AutoBuild-OpenWrt/blob/main/.github/workflows/build_x64_lean_23.05.yml)    | [![](https://github.com/waynesg/AutoBuild-OpenWrt/workflows/lede/badge.svg)](https://github.com/waynesg/AutoBuild-OpenWrt/actions/workflows/build_x64_lean_23.05.yml) |[![](https://img.shields.io/badge/编译-配置-orange.svg)](https://github.com/waynesg/AutoBuild-OpenWrt/blob/main/build/Lede_source/.config) | ![](https://img.shields.io/github/last-commit/waynesg/AutoBuild-OpenWrt.svg)
| 2 |   [![](https://img.shields.io/badge/WayneSG%40OpenWrt-X86__64(Immortalwrt)-lightgrey)](https://github.com/waynesg/AutoBuild-OpenWrt/blob/main/.github/workflows/build_x64_immortal_23.05.yml)    | [![](https://github.com/waynesg/AutoBuild-OpenWrt/workflows/immortal/badge.svg)](https://github.com/waynesg/AutoBuild-OpenWrt/actions/workflows/build_x64_immortal_23.05.yml) |[![](https://img.shields.io/badge/编译-配置-orange.svg)](https://github.com/waynesg/AutoBuild-OpenWrt/blob/main/build/immortalwrt_source/.config) | ![](https://img.shields.io/github/last-commit/waynesg/AutoBuild-OpenWrt.svg)
| 3 |    [![](https://img.shields.io/badge/WayneSG%40OpenWrt-X86__64(Official)-lightgrey)](https://github.com/waynesg/AutoBuild-OpenWrt/blob/main/.github/workflows/build_x64_officail_22.03.yml)     |[![](https://github.com/waynesg/AutoBuild-OpenWrt/workflows/official/badge.svg)](https://github.com/waynesg/AutoBuild-OpenWrt/blob/main/.github/workflows/build_x64_official_22.03.yml) |[![](https://img.shields.io/badge/编译-配置-orange.svg)](https://github.com/waynesg/AutoBuild-OpenWrt/blob/main/build/Official_source/.config) | ![](https://img.shields.io/github/last-commit/waynesg/AutoBuild-OpenWrt.svg)

## Screenshot
![chrome-capture-2022-9-11 (2)](https://user-images.githubusercontent.com/82129072/195099530-6bf41731-bcf9-4fdf-9752-26f542330b03.gif)

## 使用一键更新固件脚本

bash /bin/AutoUpdate.sh				[保留配置更新]

bash /bin/AutoUpdate.sh	-n			[不保留配置更新]

bash /bin/AutoUpdate.sh	-g			[把固件更改成其他作者固件,前提是你编译了有附带定时更新插件的其他作者的固件]

bash /bin/AutoUpdate.sh	-c			[更换Github地址]

bash /bin/AutoUpdate.sh	-t			[执行测试模式(只运行,不安装,查看更新固件操作流程)]

bash /bin/AutoUpdate.sh	-h			[列出帮助信息]

<img width="514" alt="image" src="https://user-images.githubusercontent.com/82129072/195095833-fd593e25-8310-43fe-9e91-4836bcb6ee2a.png">

## 使用 tools 固件工具箱

   打开`TTYD 终端`或者使用`SSH`, 执行指令`tools`或`bash /bin/AutoBuild_Tools.sh`即可启动固件工具箱

   当前支持以下功能:

   - USB 扩展内部空间
   - Samba 相关设置
   - 打印端口占用详细列表
   - 打印所有硬盘信息
   - 网络检查 (基础网络 | Google 连接检测)
   - AutoBuild 固件环境修复
   - 系统信息监控
   - 打印在线设备列表

# 感谢
- [大雕 源码仓库](https://github.com/coolsnowwolf/lede.git)
- [Lienol 源码仓库](https://github.com/Lienol/openwrt.git)
- [天灵 源码仓库](https://github.com/project-openwrt/openwrt.git)
- [P3TERX 自动编译脚本](https://github.com/P3TERX/Actions-OpenWrt)
- [Hyy2001X 定时更新脚本](https://github.com/Hyy2001X/AutoBuild-Actions)
