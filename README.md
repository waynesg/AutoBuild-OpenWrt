使用 AutoUpdate 一键更新固件脚本
首先需要打开TTYD 终端或者使用SSH,按需输入下方指令:

更新固件: autoupdate或bash /bin/AutoUpdate.sh

更新固件(镜像加速 Ghproxy | FastGit): autoupdate -P <G | F>

更新固件(不保留配置): autoupdate -n

强制刷入固件: autoupdate -F

"我不管,我就是要更新!": autoupdate -f

查看所有可用参数: autoupdate --help

注意: 部分参数可一起使用,例如: autoupdate -n -P G -F --skip --path /mnt/sda1

使用 tools 固件工具箱
打开TTYD 终端或者使用SSH,执行指令tools或bash /bin/AutoBuild_Tools.sh即可启动固件工具箱

当前支持以下功能:

USB 扩展内部空间
Samba 相关设置
打印端口占用详细列表
打印所有硬盘信息
网络检查 (基础网络 | Google 连接检测)
AutoBuild 固件环境修复
系统信息监控
打印在线设备列表

# 感谢
- [大雕 源码仓库](https://github.com/coolsnowwolf/lede.git)
- [Lienol 源码仓库](https://github.com/Lienol/openwrt.git)
- [天灵 源码仓库](https://github.com/project-openwrt/openwrt.git)
- [P3TERX 自动编译脚本](https://github.com/P3TERX/Actions-OpenWrt)
- [Hyy2001X 定时更新脚本](https://github.com/Hyy2001X/AutoBuild-Actions)
