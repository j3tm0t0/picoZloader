#!/usr/bin/env bash
# CI: net/tistack の picosim が使う lwIP を固定コミットで取ってくる (pico-sdk 2.0.0 の lib/lwip と同じ)。
# 使い方: lwip.sh DEST   -> LWIP=DEST
set -euo pipefail
DEST=$1; REV=0a0452b2c39bdd91e252aef045c115f88f6ca773
rm -rf "$DEST"; git init -q "$DEST"
git -C "$DEST" fetch -q --depth 1 https://github.com/lwip-tcpip/lwip.git $REV
git -C "$DEST" -c advice.detachedHead=false checkout -q FETCH_HEAD
[ "$(git -C "$DEST" rev-parse HEAD)" = "$REV" ]
echo "lwip.sh: lwIP $REV -> $DEST"
