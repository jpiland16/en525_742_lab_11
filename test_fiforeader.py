from ssh_utils import run_sshpass_command, copy_file_to_remote, PASSWORD

def sudo(command: str):
    return f" echo {PASSWORD} | sudo -S {command} "

def main():
    copy_file_to_remote("web/cgi-bin/design_1_wrapper.bit.bin")
    run_sshpass_command(sudo("fpgautil -b design_1_wrapper.bit.bin"))
    run_sshpass_command(sudo("devmem 0x43c00000 w 480"))
    run_sshpass_command(sudo("devmem 0x43c00008 w 2"))

    run_sshpass_command("rm -rf fiforeader && mkdir -p fiforeader")
    copy_file_to_remote("-r fiforeader", "~/")
    run_sshpass_command("cd fiforeader && gcc -g -o fiforeader *.c && " + sudo("./fiforeader 480000"))


if __name__ == "__main__":
    main()

