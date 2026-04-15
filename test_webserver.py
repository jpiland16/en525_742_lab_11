import glob
from ssh_utils import run_sshpass_command, copy_file_to_remote, copy_file_from_remote, sudo

def make_web_tgz():
    print("Copying C files...")
    run_sshpass_command("rm -rf src && mkdir -p src")
    copy_file_to_remote(" ".join(glob.glob("xilinxlib/*")), "~/src/.")
    copy_file_to_remote("stream_udp_data.c", "~/src/.")
    print("Copying web files...")
    run_sshpass_command("rm -rf web")
    copy_file_to_remote("-r web")
    print("Compiling `stream_udp_data` on the target...")
    run_sshpass_command("cd src && gcc -g -o ../stream_udp_data *.c")
    
    print("Compiling `test_radio` on the target...")
    copy_file_to_remote("test_radio.c")
    run_sshpass_command("gcc -g -o web/cgi-bin/test_radio test_radio.c")
    print("Compiling `udpsender` on the target...")
    copy_file_to_remote("udpsender.c")
    run_sshpass_command("gcc -g -o web/cgi-bin/udpsender udpsender.c")
    print("Compiling `fiforeader` on the target...")
    copy_file_to_remote("fiforeader/fiforeader.c", "~/src/.")
    run_sshpass_command("cd src && rm stream_udp_data.c && gcc -g -o ../web/cgi-bin/fiforeader *.c")

    print("Compilation complete! Creating zip file...")
    run_sshpass_command("cp stream_udp_data web/cgi-bin")
    run_sshpass_command("tar -cvzf jpiland_web.tgz web")
    print("Zip created, deleting directories and bringing TGZ back to host...")
    run_sshpass_command("rm -rf web")
    copy_file_from_remote("jpiland_web.tgz", ".")
    run_sshpass_command("rm -rf jpiland_web.tgz")

def kill_programs():
    run_sshpass_command(sudo("killall httpd"))
    run_sshpass_command(sudo("killall stream_udp_data"))

def deploy_web_tgz():
    print("Deploying TGZ and starting web server...")
    copy_file_to_remote("jpiland_web.tgz")
    print("Files copied, starting server...")
    run_sshpass_command("tar -xvzf jpiland_web.tgz && cd web && " + sudo("httpd -p 8080"))


def main():
    kill_programs()
    make_web_tgz()
    deploy_web_tgz()

if __name__ == "__main__":
    main()

