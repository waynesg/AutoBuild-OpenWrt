# AutoBuild-OpenWrt 维护记录

整理日期：2026-08-10

本文件记录本项目近期围绕 ImmortalWrt 24.10 / 25.12 编译、插件、LuCI、路由器现场配置所做的排查和改动。路由器密码、Token 等敏感信息不写入仓库。

## 设备记录

| 场景 | 地址 | SSH 端口 | 说明 |
| --- | --- | --- | --- |
| 公司路由器 | 192.168.10.1 | 1022 | 主要用于 25.12 固件现场验证、AdBlock-Fast、MOTD、OpenClash 等配置 |
| 家里路由器 | 192.168.1.1 | 1221 | 配置过 AdBlock-Fast 和 LED |
| 另一台路由器 | 10.10.10.1 | 未记录 | 曾要求同样处理 nginx/HTTPS 问题 |

## 主要结论

- 25.12 不是 OpenWrt 官方稳定版命名，当前仓库按 ImmortalWrt 25.12 分支/快照结构维护。
- 25.12 编译目录已经按 24.10 结构新增，并尽量保持插件和定制一致。
- 25.12 已从 `opkg` 切到 `apk`，因此 autoupdate、登录提示、包管理相关脚本需要兼容。
- 24.10 最近一次超时不是明确的缺依赖失败，而是 GitHub Actions 6 小时超时；日志里 `uwsgi` 编译耗时很长。
- 25.12 的 autoupdate 升级状态改动已放到 `build/common`，24.10 构建时也会继承。

## 仓库结构相关

- 新增并维护 `build/Immortalwrt-25.12`，用于 ImmortalWrt 25.12 x86-64 编译。
- 保留 `build/Immortalwrt` 作为 24.10 编译目录。
- 公共脚本、autoupdate LuCI 页面和控制器放在 `build/common`，由各版本构建复用。
- `compile.yml` 工作流修复过显示名称，避免出现 `25.12-25.12` 重复。
- 缓存曾关闭用于排查问题，之后重新开启，并按目标/分支隔离，避免 24.10 缓存污染 25.12。
- Release 页面里“编译版本”为空的问题已修复。
- README 已补充维护 24.10 和 25.12 的说明。

## 24.10 记录

- 24.10 原本插件更多，包含 Docker、OpenClash、HomeProxy、UnblockNeteaseMusic、Subconverter、Ruby、Node 等。
- 最近一次 24.10 编译运行 `30682220286` 在 6 小时超时，被 GitHub Actions 取消。
- 日志重点：
  - `feeds/packages/net/uwsgi compile` 耗时约 1 小时 12 分钟。
  - 后续进入 `ruby`、`luci-app-openclash` 编译时到达 6 小时限制。
  - 看到 `luci-theme-argon` 依赖 `wget-any` 的警告。
- 已处理：
  - 删除 24.10 `.config` 中显式选择的 `uwsgi`、`uwsgi-cgi-plugin`、`uwsgi-luci-support`、`uwsgi-syslog-plugin`。
  - 在 24.10 `diy-part.sh` 中把 Argon 主题 Makefile 的 `wget-any` 替换为 `wget-ssl`。
  - 25.12 的 autoupdate 升级状态改动确认已通过 `build/common` 同步到 24.10。

## 25.12 记录

- 新增 25.12 编译目录后，重点保持 24.10 现有插件和自定义配置。
- 修复过工作流名称重复 `25.12-25.12`。
- 编译超时排查：
  - 起初怀疑 Docker、插件数量或缓存导致。
  - 后续确认 25.12 的主要问题包含 Ruby YJIT、OpenVPN 包冲突、subconverter 依赖、uwsgi/nginx 相关依赖等。
  - 25.12 中已移除/规避 `uwsgi` nginx 支持。
- OpenVPN Server：
  - 25.12 初期缺失或冲突，后续恢复支持并处理包冲突。
  - 添加默认配置兼容。
- Subconverter：
  - 新增 `kiddin9/openwrt-subconverter`。
  - 添加相关依赖。
  - 讨论过 `sub-web` 编译时间，认为会增加一定耗时。
- PassWall：
  - 曾准备取消 `passwall2` 拉取，改用上游 `passwall`。
  - 后续因不是刚需，取消 PassWall 编译。
- AdBlock-Fast：
  - 添加 `luci-app-adblock-fast` 编译。
  - 菜单名改为“广告拦截”。
  - 添加中文社区广告规则，包括 AWAvenue / 秋风广告规则。
- DNS：
  - 25.12 防火墙菜单栏下的 `DNS` 改为“DNS设定”。
- DDNS：
  - 25.12 LuCI DDNS 页面出现 `RPC call to luci.ddns/get_services_status failed with error -32000: Object not found`。
  - 曾先撤销 DDNS 修改以等待上游。
  - 后续做过 `ucode` 兼容修复。
- 网络接口：
  - 25.12 刷机后 LuCI 弹出 `ifname` 配置迁移提示。
  - 已在构建脚本中处理网络配置从 `ifname` 到 `device` 的迁移。
- 包管理提示：
  - SSH 登录时出现 OpenWrt `apk` 包管理迁移提示。
  - 已在 25.12 固件中抑制该提示。
  - 公司路由器现场也删除过该提示。

## autoupdate 记录

- 25.12 中 `opkg` 不存在，autoupdate 最初报错：
  - `/bin/AutoUpdate.sh: line 80: opkg: command not found`
  - `/usr/lib/opkg/info/kernel.control: No such file or directory`
  - 固件文件下载失败后 `md5sum` / `sha256sum` 找不到目标文件。
- 已修复：
  - 兼容 25.12 `apk` 包管理。
  - 修复手动更新时固件缺失仍继续校验的问题。
  - 修复内核版本显示，目标格式为 `6.12.94 - 25.12`。
  - 添加 LuCI 升级状态区域，显示后台升级进度。
  - `Upgrade Status` 已汉化为“升级状态”。
  - 触发升级改为后台执行，浏览器不会一直 loading；页面通过状态文本反馈升级过程。
- 24.10 同步：
  - autoupdate 的 LuCI 页面、控制器和脚本放在 `build/common`。
  - 24.10 和 25.12 都会从公共目录复制新版 autoupdate 文件。

## LuCI 界面记录

- 登录页品牌 `WayNe-OpenWrt-SANY` 字体多次调整。
- 最终登录页标题大小调整为 `32px`。
- 登录后左上角标题大小保持不影响布局。
- 24.10 已同步登录页标题大小。
- 删除 24.10 和 25.12 Argon 背景目录下的 `4.mp4`。
- QuickFile-Go：
  - 起初想固化浅色模式。
  - 后续改为跟随系统深浅模式。
  - 已在构建脚本中修复主题检测逻辑。

## 插件取舍记录

- Docker：
  - 25.12 为控制编译时间和固件大小，曾讨论取消 Docker。
  - 24.10 仍保留 Docker。
- OpenVPN Server：
  - 仍然需要，已恢复 25.12 支持。
- AdBlock-Fast：
  - 已加入 25.12，适合做 DNS 级广告拦截。
  - 对手机广告有一定作用，但 App 内置广告、HTTPS 内嵌请求、同域广告不一定能完全拦截。
- OpenClash：
  - 查看过配置和分流思路。
  - IPv6 需求为“只让 IPv6 解析国内，代理仍走 IPv4”。
- nlbwmon：
  - 曾加入 25.12，并改名为“带宽监控”。
  - 菜单位置最终放回“服务”菜单。
  - 后续反馈不工作。
- vnstat2：
  - 曾用 `luci-app-vnstat2` 替换 nlbwmon。
  - 后续反馈不好用，已删除。
- Samba4：
  - 讨论过编译耗时，结论是会增加明显编译时间，尤其依赖较多时。
- Spotifyd：
  - 解释过是把路由器作为 Spotify Connect 播放端使用，不是刚需。

## 路由器现场配置记录

- 公司路由器：
  - 曾处理 nginx/HTTPS 登录冲突问题。
  - 配置过 AdBlock-Fast。
  - 删除过 SSH 登录中的 `apk` 包管理迁移提示。
  - 测试过 MOTD 美化，表格框右侧不闭合，最终回退到最初样式。
- 家里路由器：
  - 配置过 AdBlock-Fast。
  - 启用 AWAvenue / 秋风广告规则。
  - 配置过 LED。
- OpenClash：
  - 曾建议按国内 DNS / IPv6 解析与代理出口分开处理。
  - 用户目标是国内 IPv6 解析保留，代理流量仍走 IPv4。

## MOTD / SSH 登录记录

- 25.12 SSH 登录信息曾包含：
  - OpenWrt 25.12-SNAPSHOT
  - 内核版本
  - 设备信息
  - CPU、温度、负载、运行时间
  - 内存、IP、启动存储、系统存储
- 尝试过“极客风”美化。
- 尝试过表格框显示，但右侧无法稳定闭合。
- 最终回退到最初颜色和样式。
- GitHub 仓库也同步恢复。

## 图片处理记录

- 曾处理 `微信图片_20260710150407_8559_135.png`：
  - 去掉白色背景。
  - 转为矢量 SVG。
  - Photoshop 打开 SVG 时显示成整块蓝色，说明 SVG 结构或填充方式对 Photoshop 兼容性不理想。

## 最近提交参考

- `b5e1869 fix: reduce 24.10 build timeout`
- `5bdc6cc revert: restore 25.12 ssh motd style`
- `9eec0d1 fix: suppress apk cheatsheet motd on 25.12`
- `51e4356 fix: sync quickfile-go with luci theme`
- `eef16b9 chore: remove vnstat2 from 25.12`
- `76b2ff1 fix: migrate 25.12 network ifname options`
- `4a87f86 fix: enable 25.12 cache and release metadata`
- `c6d0d87 chore: remove argon background video`
- `4bdda2e chore: reduce luci login brand title size`
- `60aca6d fix: make ddns rpc compatible with 25.12 ucode`
- `7944536 feat: add nlbwmon to 25.12`
- `58663be chore: localize adblock-fast menu on 25.12`
- `a5f2535 fix: load autoupdate luci assets from common directory`
- `b9f6d2e chore: disable passwall on 25.12`
- `fa5e171 feat: add adblock-fast and upstream passwall to 25.12`
- `42f6fe1 fix: localize autoupdate status label`
- `80fb054 feat: show autoupdate upgrade progress in luci`
- `b5a4d01 fix: remove uwsgi nginx support from 25.12`
- `a6bf9de fix: stop autoupdate when firmware download is missing`
- `3f6a9e3 fix: make autoupdate manual upgrade work on 25.12`
- `dcc8b7c fix: support subconverter and kernel version on 25.12`
- `806b629 feat: include subconverter web dependencies`
- `61a8c5c fix: restore OpenVPN server support on 25.12`
- `00f6299 fix: avoid OpenVPN package conflict on 25.12`
- `4c43048 fix: isolate build cache by target and branch`
- `45f889f fix: disable Ruby YJIT for 25.12 builds`
- `6effc29 fix: streamline ImmortalWrt 25.12 builds`
- `a13debd feat: add ImmortalWrt 25.12 build profile`

## 待验证事项

- 重新触发 24.10 编译，确认移除 `uwsgi` 后能否在 6 小时内完成。
- 刷入新版 24.10 后，确认 autoupdate LuCI 升级状态是否与 25.12 一致。
- 继续观察 25.12 DDNS 上游是否修复；当前仓库已有兼容性处理。
- AdBlock-Fast 规则启用后，建议分别用 DNS 查询和手机 App 实测拦截效果。
