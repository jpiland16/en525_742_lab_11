#include <stdio.h>
#include <sys/mman.h>
#include <fcntl.h>
#include "xllfifo.h"
#include <stdlib.h>


#define USAGE "\
usage: ./fiforeader <number_of_words> \n\
  - Reads <number_of_words> 4-byte words from the AXI-Stream FIFO in the PL\
"

int main(int argc, char* argv[]) {

    if (argc != 2) {
        puts(USAGE);
        return EXIT_FAILURE;
    }

    int num_words_to_read = atoi(argv[1]);

    int fd = open("/dev/mem", O_RDWR | O_SYNC);
    if (fd < 0) {
        perror("open");
        return -1;
    }

    void *map = mmap(NULL,
                     XPAR_AXI_FIFO_MM_S_0_HIGHADDR - XPAR_AXI_FIFO_MM_S_0_BASEADDR + 1,
                     PROT_READ | PROT_WRITE,
                     MAP_SHARED,
                     fd,
                     XPAR_AXI_FIFO_MM_S_0_BASEADDR);

    if (map == MAP_FAILED) {
        perror("mmap");
        return -1;
    }

    volatile uint32_t *fifo_ptr = (volatile uint32_t *)map;

    puts("Initializing FIFO...");
    XLlFifo fifo;
    XLlFifo_Initialize(&fifo, (unsigned int) fifo_ptr);
    printf("Initialization complete! Reading %d 4-byte words...\n", num_words_to_read);
    fflush(stdout); // To ensure that timing can be reviewed accurately


    // for (int i = 0; i < 17; i++) {
    //     printf(" - fifo[BASE + 0x%02x] = 0x%08x\n", i * 4, fifo_ptr[i]);
    // }

    // for (int i = 0; i < 10; i++) {
    //     int occ = XLlFifo_iRxOccupancy(&fifo);
    //     printf("RX Occupancy: %d\n", occ);
    // }

    // unsigned int len = (XLlFifo_iRxGetLen(&fifo) & 0x3FFFF) >> 2;

    unsigned int num_words_read = 0;
    unsigned int single_sample;
    
    while (num_words_read < num_words_to_read) {
        if (((XLlFifo_iRxGetLen(&fifo) & 0x3FFFF) >> 2) > 0) {
            // There are bytes available in the FIFO, read them now
            XLlFifo_Read(&fifo, &single_sample, 4);
            num_words_read++;
        }
    }

    puts("Goodbye");

}
