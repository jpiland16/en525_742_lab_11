#/bin/sh

sed -i '/^192\.168\.2\.101/d' /home/jpiland/.ssh/known_hosts
sshpass -p student ssh -o StrictHostKeyChecking=accept-new student@192.168.2.101 -t "echo hello"
