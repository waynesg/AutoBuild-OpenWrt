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

# OpenWrt packages the target daemon separately; skip Docker's host-binary
# bundling step, which otherwise tries to copy an empty cross-compiled path.
DOCKER_MAKEFILE="feeds/packages/utils/dockerd/Makefile"
DOCKER_PATCH_DIR="feeds/packages/utils/dockerd/patches"
DOCKER_PATCH="${DOCKER_PATCH_DIR}/999-openwrt-skip-host-binaries.patch"
if [[ -f "${DOCKER_MAKEFILE}" ]]; then
	mkdir -p "${DOCKER_PATCH_DIR}"
	if [[ ! -f "${DOCKER_PATCH}" ]] || ! grep -q 'OpenWrt packages provide' "${DOCKER_PATCH}"; then
		cat > "${DOCKER_PATCH}" <<'EOF'
--- a/hack/make/binary-daemon
+++ b/hack/make/binary-daemon
@@ -4,6 +4,16 @@ set -e
 copy_binaries() {
	local dir="${1:?}"

+	# OpenWrt packages provide these binaries separately for the target.
+	if [ "${OPENWRT_BUILD:-}" = "1" ]; then
+		return
+	fi

	# Never copy an unset command path in cross-build environments.
	if [ "$(go env GOOS)/$(go env GOARCH)" != "$(go env GOHOSTOS)/$(go env GOHOSTARCH)" ] || [ ! -x /usr/local/bin/runc ]; then
		return
	fi

	# Add nested executables to bundle dir so we have complete set of
EOF
	fi
	if ! grep -q 'OPENWRT_BUILD=1' "${DOCKER_MAKEFILE}"; then
		awk '/\$\(GO_PKG_VARS\)/ { print; print "\tOPENWRT_BUILD=1 \\"; next } { print }' "${DOCKER_MAKEFILE}" > "${DOCKER_MAKEFILE}.tmp"
		mv "${DOCKER_MAKEFILE}.tmp" "${DOCKER_MAKEFILE}"
	fi
fi
