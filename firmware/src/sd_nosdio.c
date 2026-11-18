/*
 * sd_nosdio.c -- lib/FatFs_SD を SPI だけで使うための空の関数。
 *
 * lib/FatFs_SD の SDIO ドライバ (sd_driver/SDIO/) は ZuluSCSI (GPL-3) 由来なのでビルドに入れない。
 * sd_card.c は SDIO のカードのときだけ次の 2 つを呼ぶ。hw_config.c は SPI のカードしか作らないので呼ばれない。
 */
#include <stdbool.h>
#include <stdlib.h>
#include <stdio.h>

struct sd_card_t;

void sd_sdio_ctor(struct sd_card_t *sd_card_p) {
    (void)sd_card_p;
    printf("sd_nosdio: SDIO is not built in\n");
    abort();
}

bool rp2040_sdio_get_sd_status(struct sd_card_t *sd_card_p, unsigned char response[64]) {
    (void)sd_card_p; (void)response;
    return false;
}
