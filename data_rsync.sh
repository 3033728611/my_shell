#!/bin/bash

# This is a shell which to rsync among server1,server2 and server3
# created by YRA on 2026/5/13 supported by ai

if [ "$#" -ne 1 ];then
  echo "Usage:$0 /path/to/file"
  exit 1
fi

if [ ! -e "$1"  ];then
  echo "[$1] does not existed(directly path)"
  exit 2
fi

fullpath=$(dirname "$1")

basepath=$(basename "$1")

# 检查并安装rsync
if ! command -v rsync &> /dev/null; then
    yum install -y rsync || {
        echo "rsync not installed, please check and install in person"
        exit 3
    }
fi

for host in server1 server2 server3;do

  # 检查目标主机是否在线
  if ! ping -c 1 -W 2 "$host" &> /dev/null; then
    tput setaf 1
    echo "Host [$host] is offline, skipping..."
    tput setaf 7
    continue
  fi

  # 检查远程服务器是否安装了rsync，如果没有则自动安装
  tput setaf 3
  echo "Checking rsync on [$host]..."
  tput setaf 7
  
  ssh root@"$host" "command -v rsync &> /dev/null" 
  if [ $? -ne 0 ]; then
    tput setaf 3
    echo "rsync not found on [$host], installing..."
    tput setaf 7
    ssh root@"$host" "yum install -y rsync" 
    if [ $? -ne 0 ]; then
      tput setaf 1
      echo "Failed to install rsync on [$host]"
      tput setaf 7
      continue
    fi
    tput setaf 2
    echo "rsync installed successfully on [$host]"
    tput setaf 7
  fi

  tput setaf 2
  echo "Syncing [$basepath] to [$host]..."
  tput setaf 7
  # 使用rsync同步文件到目标服务器
  # -a: 归档模式，保留文件属性
  # -z: 传输时压缩
  # --delete: 删除目标目录中源目录不存在的文件，保持完全同步
  rsync -az --delete "$fullpath" root@"$host:$basepath/"

  if [ $? -eq 0 ];then
    echo "Sync [$basepath] to [$host] successfully"
  else
    echo "Sync [$basepath] to [$host] failed"
    exit 4
  fi
done
