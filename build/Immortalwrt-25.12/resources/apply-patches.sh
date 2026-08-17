#!/bin/bash

set -e

PATCH_DIR="${PATH1}/patches"

apply_patch_if_needed() {
	local target="$1"
	local marker="$2"
	local patch_file="$3"

	if [[ -f "${target}" ]] && grep -q "${marker}" "${target}"; then
		patch -p1 < "${patch_file}"
	fi
}

apply_patch_if_needed \
	"feeds/luci/applications/luci-app-ddns/root/usr/share/rpcd/ucode/ddns.uc" \
	"??=" \
	"${PATCH_DIR}/ddns-ucode-compat.patch"

apply_patch_if_needed \
	"package/waynesg/luci-app-quickfile-go/luci-app-quickfile-go/htdocs/luci-static/resources/view/quickfile-go.js" \
	"theme: 'dark'" \
	"${PATCH_DIR}/quickfile-go-theme-sync.patch"

apply_patch_if_needed \
	"feeds/packages/utils/dockerd/Makefile" \
	"PKG_NAME:=dockerd" \
	"${PATCH_DIR}/dockerd-openwrt-cross-compile.patch"

apply_patch_if_needed \
	"package/waynesg/luci-theme-shadcn/Makefile" \
	"LUCI_DEPENDS:=+luci-base$" \
	"${PATCH_DIR}/shadcn-customizations.patch"
