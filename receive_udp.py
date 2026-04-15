import socket

# 1. Define the IP address and port to listen on
# Use "0.0.0.0" to listen on all available network interfaces
UDP_IP = "192.168.2.100" 
UDP_PORT = 25344

# 2. Create a UDP socket
# AF_INET = IPv4, SOCK_DGRAM = UDP
sock = socket.socket(socket.AF_INET, socket.SOCK_DGRAM)

# 3. Bind the socket to the address and port
sock.bind((UDP_IP, UDP_PORT))

print(f"Listening for UDP packets on {UDP_IP}:{UDP_PORT}...")

while True:
    # 4. Receive data (buffer size is 1024 bytes)
    # data is the actual message; addr is a tuple (ip, port) of the sender
    data, addr = sock.recvfrom(1028)
    print("received packet")
