#include <stdio.h>
#include <stdlib.h>
#include <stdint.h>
#include <stdbool.h>
#include <sys/socket.h>
#include <netinet/in.h>
#include <arpa/inet.h>
#include <unistd.h>
#include <strings.h>
#include <string.h>
#include <fcntl.h>
#include <sys/mman.h>
#include "xllfifo.h"
#include <signal.h>

#define DATA_LENGTH 256
#define PORT 25344

#define FIFO_LENGTH_MASK 0x3FFFFF
#define LOG2_FIFO_WORD_LENGTH 2

#define STR_HELPER(x) #x
#define STR(x) STR_HELPER(x)

#define MIN(a, b) (((a) < (b)) ? (a) : (b))

#define USAGE "\
usage: ./stream_udp_data <ip_addr> \n\
  - Sends UDP packets to <ip_addr>:" STR(PORT) " when FIFO data is available \
"

typedef struct sockaddr_in sockaddr_in_t;
typedef struct sockaddr sockaddr_t;

typedef struct _complex32_t {
    int16_t real;
    int16_t imag;
} complex32_t;

typedef struct _udp_packet_t {
    int32_t counter;
    complex32_t data[DATA_LENGTH];
} udp_packet_t;

// Exit gracefully when Ctrl-C is pressed
bool exit_now = false;
void simple_handler(int sig) {
    printf("\nSIGINT (%d) received, exiting...\n", sig);
    exit_now = true;
}

bool udp_setup(int* out_fd, sockaddr_in_t* out_server_address, const char* host, int port) {
    int fd = socket(AF_INET,SOCK_DGRAM,0);
    if(fd < 0){
        perror("cannot open socket");
        return false;
    }
    
    *out_fd = fd;
    bzero(out_server_address, sizeof(*out_server_address));
    out_server_address->sin_family = AF_INET;
    out_server_address->sin_addr.s_addr = inet_addr(host);
    out_server_address->sin_port = htons(port);
    return true;
}

bool udp_send(const void* data, int data_len, sockaddr_in_t server_address, int fd) {
    if (sendto(fd, data, data_len, 0, (sockaddr_t*) &server_address, sizeof(server_address)) < 0){
        perror("cannot send message");
        close(fd);
        return false;
    }
    return true;
}

void udp_shutdown(int fd) {
    close(fd);
}

int main(int argc, char* argv[]) {
    // Register SIGINT handler
    signal(SIGINT, simple_handler);

    if (argc != 2) {
        puts(USAGE);
        return EXIT_FAILURE;
    }

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
    printf("Initialization complete! Now streaming data as UDP packets...\n");
    fflush(stdout); // To ensure that timing can be reviewed accurately

    char* destination_address = argv[1];

    udp_packet_t packet;
    uint32_t position_in_data_packet = 0;

    int success_count = 0;
    int failure_count = 0;

    sockaddr_in_t server_address;
    int udp_fd;

    bool udp_is_set_up = false;

    uint32_t num_fifo_words_available;
    uint32_t this_packet_vacancy;
    uint32_t num_fifo_words_to_read;

    uint32_t packet_counter = 0;

    while (!exit_now) {
        if (!udp_is_set_up) {
            // try to set up
            if (!(udp_setup(&udp_fd, &server_address, destination_address, PORT))) {
                puts("UDP setup failure!");
                return EXIT_FAILURE;
            }
            udp_is_set_up = true;
        }

        if (num_fifo_words_available = ((XLlFifo_iRxGetLen(&fifo) & FIFO_LENGTH_MASK) >> LOG2_FIFO_WORD_LENGTH) > 0) {
            this_packet_vacancy = DATA_LENGTH - position_in_data_packet;
            num_fifo_words_to_read = MIN(this_packet_vacancy, num_fifo_words_available);
            XLlFifo_Read(&fifo, (void* ) (packet.data + position_in_data_packet), num_fifo_words_to_read << LOG2_FIFO_WORD_LENGTH);
            position_in_data_packet += num_fifo_words_to_read;
        }

        if (position_in_data_packet == DATA_LENGTH) {
            packet.counter = packet_counter;
            packet_counter++;
            bool result_success = udp_send((void* ) &packet, sizeof(udp_packet_t), server_address, udp_fd);
            if (result_success) {
                success_count++;
            } else {
                failure_count++;
                udp_is_set_up = false; // socket is closed on failure; so retry setup
            }
            position_in_data_packet = 0;
        }
    }

    udp_shutdown(udp_fd);

    printf("INFO: %d packet(s) sent successfully, %d failures\n", success_count, failure_count);

    return EXIT_SUCCESS;
}
