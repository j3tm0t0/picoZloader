# 他者のソフトウェア

このリポジトリのソースから作るバイナリには、次の他者のソフトウェアが入ります。各ライセンスの全文はこのディレクトリにあります。

## Pico 2 W のファーム (`firmware/`、x68kzremotedrv.uf2)

- x68kzremotedrv / x68kserremote / iconv_mini (yunkya2 さん、MIT): `../firmware/LICENSE`
- libsmb2 (Ronnie Sahlberg さんほか、**LGPL-2.1**): `libsmb2-COPYING.txt`。ソースはサブモジュール `firmware/libsmb2` (yunkya2/libsmb2 の 1fde603) です。差し替えて再リンクしたい場合は、このリポジトリからビルドできます。
- Raspberry Pi Pico SDK 2.1.1 (BSD-3-Clause): `pico-sdk-LICENSE.txt`
- TinyUSB (MIT): `tinyusb-LICENSE.txt`
- lwIP (BSD-3-Clause): `lwip-COPYING.txt`
- FreeRTOS kernel (raspberrypi/FreeRTOS-Kernel 4f7299d、MIT): `FreeRTOS-LICENSE.md`
- cyw43-driver (Raspberry Pi Ltd の条件: RP シリーズのマイコンで使う場合に限る): `cyw43-driver-LICENSE.txt`、`cyw43-driver-LICENSE.RP.txt`
- FatFs (ChaN さん、FatFs ライセンス): `FatFs-LICENSE.txt`
- no-OS-FatFS-SD-SDIO-SPI-RPi-Pico の SPI の部分 (Carl J Kugler III さん、Apache-2.0。SPI のドライバは Mbed OS の SDBlockDevice 由来、Apache-2.0): `no-OS-FatFS-SD-SPI-LICENSE.txt`。同じライブラリの SDIO ドライバは ZuluSCSI (GPL-3) 由来なので、ビルドに入れていません (`firmware/CMakeLists.txt`、`firmware/src/sd_nosdio.c`)。
- Monocypher 4.0.2 (Loup Vaillant さんほか、CC0-1.0 または BSD-2-Clause): `monocypher-LICENCE.md`

## ssh.x (Human68k)

- dropbear 2022.83 (Matt Johnston さんほか、MIT 系): `dropbear-LICENSE.txt`。同梱の libtomcrypt / libtommath は public domain (同じファイルに記載)。ソースは公式の tarball に `net/ssh/dropbear/patches` を当てたもの。
- Monocypher 4.0.2 (上記)
- Twemoji 15.1.0 の絵文字を 16x16・16 色に変換した表 (c) 2023 Twitter/X, jdecked/twemoji, **CC-BY 4.0** (https://creativecommons.org/licenses/by/4.0/)。縮小と減色をしています。
- elf2x68k (yunkya2 さん) のランタイム (newlib、libsocket): それぞれの配布条件

## zterm の補助プログラム (接続先で動く)

- Rust の crate: `zterm-rust-crates.txt` のとおり (MIT / Apache-2.0 / Unlicense のいずれか、またはその選択)
- Linux 版は musl libc (MIT) を静的にリンク

## 含まないもの

xip.x (ESP/X)、Human68k、XEiJ などの他者の配布物は含みません。
