#include <stdio.h>
#include <sys/mman.h>
#include <fcntl.h>
#include "xllfifo.h"

int main(void) {

    int fd = open("/dev/mem", O_RDWR | O_SYNC);
    if (fd < 0) {
        perror("open");
        return -1;
    }

    void *map = mmap(NULL,
                     0x10000,
                     PROT_READ | PROT_WRITE,
                     MAP_SHARED,
                     fd,
                     0x43c10000);

    if (map == MAP_FAILED) {
        perror("mmap");
        return -1;
    }

    volatile uint32_t *fifo_ptr = (volatile uint32_t *)map;

    puts("Hello world!");
    XLlFifo fifo;
    XLlFifo_Initialize(&fifo, (unsigned int) fifo_ptr);
    puts("Passed initialization!");

    // int occ = XLlFifo_RxOccupancy(&fifo);
    // printf("RX Occupancy: %d\n", occ);

}
