/* hostrand.c -- ホストの試験で accel_ops.c の ACCEL_OP_RANDOM に渡す乱数 (ファームでは firmware/src/accel.c の pico_rand) */
#include <stdint.h>
#include <stdlib.h>
#include <unistd.h>
#include <sys/random.h>
#include "../accel_ops.h"

void accel_random_bytes(uint8_t *p, int n)
{
  while (n > 0) {
    int k = n > 256 ? 256 : n;          /* getentropy は 1 回 256 バイトまで */
    if (getentropy(p, (size_t)k) != 0)
      abort();
    p += k;
    n -= k;
  }
}
