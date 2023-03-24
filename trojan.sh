

#!/bin/bash
# Trojan-One-Click-Config

echo "Trojan-One-Click-Config欢迎您的使用"
echo "正在检测系统环境..."

#检测系统版本
if [ ! -e /etc/redhat-release ]; then
echo "系统不受支持"
exit
fi

if  [ -n "$(grep ' 6\.' /etc/redhat-release)" ] ;then
CentOS_Version="6"
elif  [ -n "$(grep ' 5\.' /etc/redhat-release)" ];then
CentOS_Version="5"
fi

#检查Root权限
if  [ $(id -u) != "0" ]; then
echo "Error: You must be root to run this script, please use root to install Trojan"
exit 1
fi

#安装必要软件
yum -y install wget unzip zip

#添加Trojan的yum源
echo "[trojan]
name=Trojan
baseurl=https://mirrors.tuna.tsinghua.edu.cn/trojan-deb/deb
enabled=1
gpgcheck=0" > /etc/yum.repos.d/trojan.repo

#更新yum源
yum clean all
yum makecache

#安装Trojan
yum -y install trojan

#读取配置文件
echo "请输入Trojan的密码:"
read password

echo "
{
    \"run_type\": \"server\",
    \"local_addr\": \"0.0.0.0\",
    \"local_port\": 443,
    \"remote_addr\": \"127.0.0.1\",
    \"remote_port\": 80,
    \"password\": [
        \"$password\"
    ],
    \"log_level\": 1,
    \"ssl\": {
        \"cert\": \"/etc/trojan/trojan.crt\",
        \"key\": \"/etc/trojan/trojan.key\",
        \"key_password\": \"\",
        \"cipher\": \"ECDHE-ECDSA-AES128-GCM-SHA256:ECDHE-RSA-AES128-GCM-SHA256:ECDHE-ECDSA-AES256-GCM-SHA384:ECDHE-RSA-AES256-GCM-SHA384:ECDHE-ECDSA-CHACHA20-POLY1305:ECDHE-RSA-CHACHA20-POLY1305:DHE-RSA-AES128-GCM-SHA256:DHE-RSA-AES256-GCM-SHA384\",
        \"prefer_server_cipher\": true,
        \"alpn\": [
            \"http/1.1\"
        ],
        \"reuse_session\": true,
        \"session_ticket\": false,
        \"session_timeout\": 600,
        \"plain_http_response\": \"\"
    },
    \"tcp\": {
        \"no_delay\": true,
        \"keep_alive\": true,
        \"fast_open\": false
    },
    \"mysql\": {
        \"enabled\": false,
        \"server_addr\": \"127.0.0.1\",
        \"server_port\": 3306,
        \"database\": \"trojan\",
        \"username\": \"trojan\",
        \"password\": \"\"
    }
}" > /etc/trojan/config.json

#启动Trojan
/usr/bin/trojan -c /etc/trojan/config.json

echo "Trojan已经安装完成"
