#!/usr/bin/env bash
# Pico 2 W 向けのファームを組み立てる。
#   firmware/build-pico2w.sh WORK [cmake の追加の -D...]
# WORK に pico-sdk 2.1.1 と raspberrypi/FreeRTOS-Kernel (RP2350 の port) を取ってくる
# (firmware/ のサブモジュールの pico-sdk・FreeRTOS-Kernel は本家のままの古い版なので使わない)。
# PICO_SDK_PATH / FREERTOS_KERNEL_PATH が既にあれば、それを使う。
# 要るもの: cmake、arm-none-eabi-gcc、m68k-xelf-gcc (driver/ の 68000 側)、python3。
# 例: SD カードのピンが GP16 MISO / GP17 CS の基板は  firmware/build-pico2w.sh /tmp/fw -DSD_PINS=header "-DCMAKE_C_FLAGS=-DSD_MISO=16 -DSD_CS=17"
set -euo pipefail
FW=$(cd "$(dirname "$0")" && pwd); TOP=$(cd "$FW/.." && pwd)
WORK=$1; shift; mkdir -p "$WORK"; WORK=$(cd "$WORK" && pwd)
SDK_REV=bddd20f928ce76142793bef434d4f75f4af6e433      # pico-sdk 2.1.1
RTOS_REV=4f7299d6ea746b27a9dd19e87af568e34bd65b15     # raspberrypi/FreeRTOS-Kernel
fetch() {   # fetch URL REV DIR
  [ -d "$3/.git" ] && [ "$(git -C "$3" rev-parse HEAD)" = "$2" ] && return
  rm -rf "$3"; git init -q "$3"
  git -C "$3" fetch -q --depth 1 "$1" "$2"
  git -C "$3" -c advice.detachedHead=false checkout -q FETCH_HEAD
}
if [ -z "${PICO_SDK_PATH:-}" ]; then
  fetch https://github.com/raspberrypi/pico-sdk.git $SDK_REV "$WORK/pico-sdk"
  git -C "$WORK/pico-sdk" submodule update -q --init --depth 1 lib/tinyusb lib/cyw43-driver lib/lwip lib/btstack lib/mbedtls
  PICO_SDK_PATH=$WORK/pico-sdk
fi
if [ -z "${FREERTOS_KERNEL_PATH:-}" ]; then
  fetch https://github.com/raspberrypi/FreeRTOS-Kernel.git $RTOS_REV "$WORK/FreeRTOS-Kernel"
  FREERTOS_KERNEL_PATH=$WORK/FreeRTOS-Kernel
fi
git -C "$TOP" submodule update -q --init --depth 1 firmware/libsmb2 firmware/x68kserremote firmware/lib/FatFs_SD
mkdir -p "$WORK/build"; cd "$WORK/build"
CFLAGS="-include time.h -Wno-error=implicit-function-declaration -Wno-error=incompatible-pointer-types -Wno-error=int-conversion" \
  cmake -DPICO_BOARD=pico2_w -DPICO_PLATFORM=rp2350 -DPICO_SDK_PATH="$PICO_SDK_PATH" -DFREERTOS_KERNEL_PATH="$FREERTOS_KERNEL_PATH" \
        -DHID_KEYBOARD=ON "$@" "$FW" > cmake.log
make -j"$(getconf _NPROCESSORS_ONLN 2>/dev/null || echo 4)" > make.log 2>&1 || { tail -40 make.log; exit 1; }
ls -l "$WORK/build/x68kzremotedrv.uf2"
