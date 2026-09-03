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

# The packages feed changes its Makefile layout independently of OpenWrt 24.10.
# Keep this edit context-free so a feed update cannot reject the build patch.
DOCKER_MAKEFILE="feeds/packages/utils/dockerd/Makefile"
DOCKER_PATCH_DIR="feeds/packages/utils/dockerd/patches"
DOCKER_PATCH="${DOCKER_PATCH_DIR}/999-openwrt-skip-host-binaries.patch"
if [[ -f "${DOCKER_MAKEFILE}" ]]; then
	mkdir -p "${DOCKER_PATCH_DIR}"
	if ! grep -q 'OpenWrt supplies target binaries' "${DOCKER_PATCH}" 2>/dev/null; then
		cat > "${DOCKER_PATCH}" <<'EOF'
--- a/hack/make/binary-daemon
+++ b/hack/make/binary-daemon
@@ -4,6 +4,11 @@ set -e
 copy_binaries() {
	local dir="${1:?}"

+	# OpenWrt supplies target binaries as separate packages.
+	if [ "${OPENWRT_BUILD:-}" = "1" ]; then
+		return
+	fi
+
 	# Add nested executables to bundle dir so we have complete set of
EOF
	fi
	if ! grep -q '^[[:space:]]*OPENWRT_BUILD=1' "${DOCKER_MAKEFILE}"; then
		awk '/\$\(GO_PKG_VARS\)/ && !done { print; print "\t\tOPENWRT_BUILD=1 \\"; done=1; next } { print }' \
			"${DOCKER_MAKEFILE}" > "${DOCKER_MAKEFILE}.tmp"
		mv "${DOCKER_MAKEFILE}.tmp" "${DOCKER_MAKEFILE}"
	fi
fi
