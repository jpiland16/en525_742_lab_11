#include <stdio.h>
#include <sys/mman.h>
#include <fcntl.h>
#include "xllfifo.h"
#include <stdlib.h>


#define USAGE "\
usage: ./fiforeader <number_of_words> \n\
  - Reads <number_of_words> 4-byte words from the AXI-Stream FIFO in the PL\
"

#define CONTROL_BASE_ADDR 0x43c00000
#define CONTROL_BASE_SIZE 0x10

#define CONTROL_DDS_RESET 0x1
#define CONTROL_FIFO_ENABLE 0x2

#define INITIAL_FAKEADC_PHASE_INCREMENT 480 // roughly Bb4

typedef struct _radio_control_t {
    uint32_t fakeadc_phase_increment;
    uint32_t tuner_phase_increment;
    uint32_t control_reg;
    uint32_t readonly_clock;
} radio_control_t;

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

    void *control_map = mmap(NULL,
                     CONTROL_BASE_SIZE,
                     PROT_READ | PROT_WRITE,
                     MAP_SHARED,
                     fd,
                     CONTROL_BASE_ADDR);

    if (map == MAP_FAILED || control_map == MAP_FAILED) {
        perror("mmap");
        return -1;
    }

    volatile uint32_t *fifo_ptr = (volatile uint32_t *)map;
    volatile radio_control_t* radio_control_ptr = (radio_control_t* ) control_map;

    puts("Initializing radio...");
    radio_control_ptr->fakeadc_phase_increment = INITIAL_FAKEADC_PHASE_INCREMENT;
    radio_control_ptr->control_reg = CONTROL_FIFO_ENABLE; 

    puts("Initializing FIFO...");
    XLlFifo fifo;
    XLlFifo_Initialize(&fifo, (unsigned int) fifo_ptr);
    printf("Initialization complete! Reading %d 4-byte words...\n", num_words_to_read);
    fflush(stdout); // To ensure that timing can be reviewed accurately

    unsigned int num_words_read = 0;
    unsigned int single_sample;
    
    while (num_words_read < num_words_to_read) {
        if (((XLlFifo_iRxGetLen(&fifo) & 0x3FFFFF) >> 2) > 0) {
            // There are bytes available in the FIFO, read them now
            XLlFifo_Read(&fifo, &single_sample, 4);
            num_words_read++;
        }
    }

    puts("Goodbye");

}
