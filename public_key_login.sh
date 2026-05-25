#!/bin/bash

# This is a shell which to use public keys to login with no password and committion among server1,server2 and server3
# created by YRA on 2026/5/14 supported by ai

# hosts.txt
# server1
# server2
# server3

#!/bin/bash

# 第一步：生成密钥
echo "=== 第1步：生成 SSH 密钥 ==="
if [ ! -f ~/.ssh/id_rsa ]; then
    ssh-keygen -t rsa -P '' -f ~/.ssh/id_rsa
fi
echo "密钥已就绪"

# 第二步安装sshpass
echo "=== 第2步：安装sshpass ==="
if ! command -v sshpass &> /dev/null; then
    yum install -y sshpass || {
        echo "sshpass not installed, please check and install in person"
        exit 1
    }
fi

# 第三步：读取服务器列表并配置
echo ""
echo "=== 第3步：配置无密码登录 ==="
PASS='0816'

while IFS= read -r ip
do
    # 跳过空行和注释
    if [ -z "$ip" ] || [[ "$ip" == \#* ]]; then
        continue
    fi
    
    echo ">>> 正在配置 $ip ..."
    
    # 这里手动执行 ssh-copy-id 命令
    sshpass -p "$PASS" ssh-copy-id -o StrictHostKeyChecking=no -i ~/.ssh/id_rsa.pub "$ip"
    
done < hosts.txt

echo ""
echo "=== 全部完成 ==="