#!/bin/bash

# This is a shell which to use public keys to login with no password and committion among server1,server2 and server3
# created by YRA on 2026/5/14 supported by ai

# hosts.txt
# server1
# server2
# server3

PASS='0816'

# 检查 hosts.txt 文件是否存在
if [ ! -f hosts.txt ]; then
    echo "错误: hosts.txt 文件不存在!"
    echo "请创建 hosts.txt 文件，每行包含一个服务器 IP 地址或主机名"
    exit 1
fi

command -v expect &> /dev/null || yum install -y expect

ssh-keygen -t rsa -P '' -f ~/.ssh/id_rsa &> /dev/null && echo "ssh key is created"

while read ip; do
    expect << EOF
    set timeout 20

    spawn ssh-copy-id -i ~/.ssh/id_rsa.pub $ip
    expect {
        "yes/no" {send "yes\r";exp_continue}
        "password:" {send "$PASS\r"}
        timeout {puts "Connection to $ip timed out"; exit 1}
        eof
    }
    expect eof
EOF

    echo "${ip} is read"
done < hosts.txt