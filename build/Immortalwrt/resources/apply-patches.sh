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
	"package/waynesg/luci-app-quickfile-go/luci-app-quickfile-go/htdocs/luci-static/resources/view/quickfile-go.js" \
	"theme: 'dark'" \
	"${PATCH_DIR}/quickfile-go-theme-sync.patch"

DOCKER_PATCH="feeds/packages/utils/dockerd/patches/999-openwrt-skip-host-binaries.patch"
if [[ -f "feeds/packages/utils/dockerd/Makefile" ]] && ! grep -q 'OpenWrt packages provide' "${DOCKER_PATCH}"; then
	patch -p1 < "${PATCH_DIR}/dockerd-openwrt-cross-compile.patch"
fi
DOCKER_MAKEFILE="feeds/packages/utils/dockerd/Makefile"
if [[ -f "${DOCKER_MAKEFILE}" ]] && ! grep -q 'OPENWRT_BUILD=1' "${DOCKER_MAKEFILE}"; then
	awk '/\$\(GO_PKG_VARS\)/ { print; print "\tOPENWRT_BUILD=1 \\"; next } { print }' "${DOCKER_MAKEFILE}" > "${DOCKER_MAKEFILE}.tmp"
	mv "${DOCKER_MAKEFILE}.tmp" "${DOCKER_MAKEFILE}"
fi
