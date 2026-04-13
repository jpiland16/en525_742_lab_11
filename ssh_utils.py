import subprocess, shlex, os
from typing import Dict, Any

DIR = "/home/jpiland/jhu/2026-01/en.525.742/lab11"

if os.getcwd() != DIR:
    print("INFO: changing directory to", DIR)
    os.chdir(DIR)

PASSWORD = "student"
REMOTE_HOST = "student@192.168.2.101"

def run_command(command: str, wait_for_result: bool = True, show_stderr: bool = False) -> int | subprocess.Popen:
    command_split = shlex.split(command)
    additional_kwargs: Dict[str, Any] = {}
    if show_stderr == False:
        additional_kwargs["stderr"] = subprocess.DEVNULL
    if wait_for_result:
        return subprocess.call(command_split, **additional_kwargs)
    # else
    return subprocess.Popen(command_split, **additional_kwargs)

def run_sshpass_command(command: str, wait_for_result: bool = True, show_stderr: bool = False) -> int | subprocess.Popen:
    return run_command(f"sshpass -p {PASSWORD} ssh {REMOTE_HOST} -t \"{command}\"", wait_for_result, show_stderr)

def copy_file_to_remote(source: str, dest: str = "", wait_for_result: bool = True, show_stderr: bool = True) -> int | subprocess.Popen:
    return run_command(f"sshpass -p {PASSWORD} scp {source} {REMOTE_HOST}:{dest}", wait_for_result, show_stderr)
