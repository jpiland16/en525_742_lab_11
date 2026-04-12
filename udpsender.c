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

#define DATA_LENGTH 256
#define PORT 25344

#define STR_HELPER(x) #x
#define STR(x) STR_HELPER(x)

#define USAGE "\
usage: ./udpsender <ip_addr> <number_of_packets> \n\
  - Sends <number_of_packets> packets to <ip_addr>:" STR(PORT) " \
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

void create_synthetic_packet(udp_packet_t* output) {
    /* NOTE: this function does not allocate memory. It is the responsibility
    of the caller to ensure that `output` points to a space large enough to 
    hold a new `udp_packet_t`.*/
    static int32_t counter = 0;
    output->counter = counter;

    for (int i = 0; i < (DATA_LENGTH / 2); i++) {
        // Create some arbitrary data based on the counter
        output->data[i * 2    ].real = ((counter >>  0) & 0xF) | ('J'       << 8);
        output->data[i * 2    ].imag = ((counter >>  8) & 0xF) | ('C'       << 8);
        output->data[i * 2 + 1].real = ((counter >> 16) & 0xF) | ('P'       << 8);
        output->data[i * 2 + 1].imag = ((counter >> 24) & 0xF) | ((i & 0xF) << 8);
    }

    counter++;
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
    if (argc != 3) {
        puts(USAGE);
        return EXIT_FAILURE;
    }

    char* destination_address = argv[1];
    int number_of_packets = atoi(argv[2]);

    printf("Sending %d UDP packet(s) to %s...\n", number_of_packets, destination_address);
    printf("INFO: Size of UDP packet is %d bytes\n", sizeof(udp_packet_t));

    udp_packet_t packet;

    int success_count = 0;

    sockaddr_in_t server_address;
    int fd;
    
    if (!(udp_setup(&fd, &server_address, destination_address, PORT))) {
        puts("UDP setup failure!");
        return EXIT_FAILURE;
    }

    for (int i = 0; i < number_of_packets; i++) {
        create_synthetic_packet(&packet);
        bool result_success = udp_send((void* ) &packet, sizeof(udp_packet_t), server_address, fd);
        if (result_success) {
            success_count++;
        } else {
            // retry setting up the socket
            if (!(udp_setup(&fd, &server_address, destination_address, PORT))) {
                puts("UDP setup failure!");
                return EXIT_FAILURE;
            }
        }
    }

    udp_shutdown(fd);

    printf("%d packet(s) sent successfully, %d failures\n", success_count, number_of_packets - success_count);

    return EXIT_SUCCESS;
}
