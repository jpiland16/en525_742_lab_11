import glob
from ssh_utils import run_sshpass_command, copy_file_to_remote, sudo

def main():
    copy_file_to_remote("web/cgi-bin/design_1_wrapper.bit.bin")
    run_sshpass_command(sudo("fpgautil -b design_1_wrapper.bit.bin"))

    run_sshpass_command("rm -rf src && mkdir -p src")
    copy_file_to_remote(" ".join(glob.glob("xilinxlib/*")), "~/src/.")
    copy_file_to_remote("fiforeader/fiforeader.c", "~/src/.")
    print("Compiling `fiforeader` on the target... please wait...")
    run_sshpass_command("cd src && gcc -g -o ../fiforeader *.c && cd .. && " + sudo("./fiforeader 480000"))


if __name__ == "__main__":
    main()

