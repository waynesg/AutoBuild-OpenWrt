#!/bin/sh

# Normalize dependency names after the 25.12 feed update and before feeds install.
# The custom Go feed provides golang/host, while some packages still refer to
# the versioned host alias. Lua package names likewise use the unversioned
# names in the current feed.
set -e

find feeds -type f \( -path '*/prosody/Makefile' -o \
    -path '*/tailscale/Makefile' -o -path '*/telegraf/Makefile' -o \
    -path '*/cloudflared/Makefile' \) -exec sed -i \
	-e 's|luafilesystem5\.4|luafilesystem|g' \
	-e 's|luaexpat5\.4|luaexpat|g' \
	-e 's|luasec5\.4|luasec|g' \
	-e 's|luasocket5\.4|luasocket|g' \
	-e 's|golang1\.27/host|golang/host|g' {} +
