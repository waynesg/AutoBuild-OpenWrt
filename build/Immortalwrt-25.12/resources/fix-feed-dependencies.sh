#!/bin/sh

# Normalize stale dependency names in the 25.12 feeds before feeds install.
set -e

find feeds -type f \( -path '*/prosody/Makefile' -o \
	-path '*/tailscale/Makefile' -o -path '*/telegraf/Makefile' \) \
	-exec sed -i \
	-e 's|luafilesystem5\.4|luafilesystem|g' \
	-e 's|luaexpat5\.4|luaexpat|g' \
	-e 's|luasec5\.4|luasec|g' \
	-e 's|luasocket5\.4|luasocket|g' \
	-e 's|golang1\.27/host|golang/host|g' {} +
