# AutoBuild-OpenWrt

> **当前仅维护：ImmortalWrt 24.10 (x86_64)**

---

## 构建状态 / 下载

| Target | Workflow | Status | Config |
|---|---|---|---|
| **ImmortalWrt 24.10 (x86_64)** | [build_x64_Immortal_24.10.yml](https://github.com/waynesg/AutoBuild-OpenWrt/blob/main/.github/workflows/build_x64_Immortal_24.10.yml) | [![](https://github.com/waynesg/AutoBuild-OpenWrt/actions/workflows/build_x64_Immortal_24.10.yml/badge.svg)](https://github.com/waynesg/AutoBuild-OpenWrt/actions/workflows/build_x64_Immortal_24.10.yml) | [build/Immortalwrt/.config](https://github.com/waynesg/AutoBuild-OpenWrt/blob/main/build/Immortalwrt/.config) |

> 旧版本 / 其它分支（如 23.05 / Lean 等）已移除，不再维护。

---

## Screenshot

![chrome-capture-2022-9-11 (2)](https://user-images.githubusercontent.com/82129072/195099530-6bf41731-bcf9-4fdf-9752-26f542330b03.gif)

---

## 使用一键更新固件脚本

```bash
bash /bin/AutoUpdate.sh             # 保留配置更新
bash /bin/AutoUpdate.sh -n          # 不保留配置更新
bash /bin/AutoUpdate.sh -g          # 切换到其它作者固件（前提：你编译了且带定时更新插件）
bash /bin/AutoUpdate.sh -c          # 更换 Github 地址
bash /bin/AutoUpdate.sh -t          # 测试模式（只运行不安装，查看流程）
bash /bin/AutoUpdate.sh -h          # 帮助
```

<img width="514" alt="image" src="https://user-images.githubusercontent.com/82129072/195095833-fd593e25-8310-43fe-9e91-4836bcb6ee2a.png">

---

## 使用 tools 固件工具箱

打开 `TTYD` 终端或者使用 `SSH`，执行 `tools` 或 `bash /bin/AutoBuild_Tools.sh` 即可启动。

当前支持：

- USB 扩展内部空间
- Samba 相关设置
- 打印端口占用详细列表
- 打印所有硬盘信息
- 网络检查（基础网络 | Google 连接检测）
- AutoBuild 固件环境修复
- 系统信息监控
- 打印在线设备列表

---

## 感谢

- [P3TERX 自动编译脚本](https://github.com/P3TERX/Actions-OpenWrt)
- [Hyy2001X 定时更新脚本](https://github.com/Hyy2001X/AutoBuild-Actions)
