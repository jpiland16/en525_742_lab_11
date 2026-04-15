# Notes

## Building project

```sh
source /tools/Xilinx/2025.2/Vivado/settings64.sh
```

## Setting up ip on Zybo

(serial)

```sh
sudo ip addr add 192.168.2.101/24 dev eth0
```

(Windows)

```sh
ssh student@192.168.2.101
# password: student
scp ./vivado/radio_periph_lab.runs/impl_1/design_1_wrapper.bit.bin student@192.168.1.101:
```

## Running on Zybo

```sh
fpgautil -b myfile.bit.bin
cp /run/media/boot-mmcblk0p1/config_codec.sh .
```

## Firewall (Fedora)

```sh
sudo firewall-cmd --add-port=25344/udp
```
