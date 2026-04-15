import glob
from ssh_utils import run_sshpass_command, copy_file_to_remote, PASSWORD

def sudo(command: str):
    return f" echo {PASSWORD} | sudo -S {command} "

def main():
    copy_file_to_remote("web/cgi-bin/design_1_wrapper.bit.bin")
    run_sshpass_command(sudo("fpgautil -b design_1_wrapper.bit.bin"))
    # run_sshpass_command(sudo("devmem 0x43c00000 w 480"))
    run_sshpass_command(sudo("devmem 0x43c00008 w 2"))

    run_sshpass_command("rm -rf src && mkdir -p src")
    copy_file_to_remote(" ".join(glob.glob("xilinxlib/*")), "~/src/.")
    copy_file_to_remote("stream_udp_data.c", "~/src/.")
    print("Compiling `stream_udp_data` on the target... please wait...")
    run_sshpass_command("cd src && gcc -g -o ../stream_udp_data *.c && cd .. && " + sudo("./stream_udp_data 192.168.2.100"))


if __name__ == "__main__":
    main()

