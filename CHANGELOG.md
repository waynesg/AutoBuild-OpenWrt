# AutoBuild-OpenWrt Changes

## 2026-08-19

- Added official Passwall2 to both ImmortalWrt 25.12 builds, with the LuCI menu named `Passwall`.
- Prefer dependencies from `Openwrt-Passwall/openwrt-passwall-packages` and remove same-named feed packages during the build.
- Disabled Passwall2 Shadowsocks Rust client and server by default to keep GitHub Actions builds within the time limit; Xray, Sing-box, and Hysteria remain enabled.
- Randomized the Shadcn login background selection and prevented consecutive repeats, with the built-in fallback retained for download failures.
- Kept Docker firmware updates on the separate `AutoUpdate-Docker` channel without creating extra dated Docker releases.
