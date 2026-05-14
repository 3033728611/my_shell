#!/bin/bash

# This is a shell which to use public keys to login with no password and committion among server1,server2 and server3
# created by YRA on 2026/5/14 supported by ai

# hosts.txt
# server1
# server2
# server3

PASS='0816'
command -v expect &> /dev/null || yum install -y expect

ssh-keygen -t rsa -P '' -f ~/.ssh/id_rsa &> /dev/null && echo "ssh key is created"

while read ip;
do
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