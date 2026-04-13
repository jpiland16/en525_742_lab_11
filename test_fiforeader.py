from ssh_utils import run_sshpass_command, copy_file_to_remote, PASSWORD

def main():
    # copy_file_to_remote("web/cgi-bin/design_1_wrapper.bit.bin")
    # run_sshpass_command(f"echo {PASSWORD} | sudo -S fpgautil -b design_1_wrapper.bit.bin")

    run_sshpass_command("rm -rf fiforeader && mkdir -p fiforeader")
    copy_file_to_remote("-r fiforeader", "~/")
    # run_sshpass_command("cd fiforeader && gcc -g -o fiforeader fiforeader.c && ./fiforeader")
    run_sshpass_command(f"cd fiforeader && gcc -g -o fiforeader *.c && echo {PASSWORD} | sudo -S ./fiforeader")


if __name__ == "__main__":
    main()

