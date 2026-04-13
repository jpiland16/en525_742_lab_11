from ssh_utils import copy_file_to_remote, run_sshpass_command

def main():
    copy_file_to_remote("udpsender.c")
    run_sshpass_command("gcc -g -o udpsender udpsender.c && ./udpsender 192.168.2.100 1000")

if __name__ == "__main__":
    main()

