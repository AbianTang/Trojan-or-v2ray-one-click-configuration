yum install wget unzip -y
wget https://github.com/trojan-gfw/trojan/releases/download/v1.17.1/trojan-1.17.1-linux-amd64.tar.xz
tar xf trojan-1.17.1-linux-amd64.tar.xz

#创建证书使用以下命令创建自签名证书
openssl req -new -x509 -nodes -newkey rsa:2048 -keyout trojan.key -out trojan.crt -days 3650

#编辑 Trojan 的配置文件，使用以下命令：
vi /usr/local/etc/trojan/config.json

#启动 Trojan：
./trojan -c config.json

#在 /etc/systemd/system/ 目录下创建一个名为 trojan.service 的文件，命令如下：
sudo nano /etc/systemd/system/trojan.service

#文件info
[Unit]
Description=Trojan Service
After=network.target

[Service]
Type=simple
ExecStart=/root/trojan/trojan -c /root/trojan/config.json
ExecStop=/usr/bin/pkill trojan
Restart=on-failure

[Install]
WantedBy=multi-user.target

#使systemd重新加载配置文件
sudo systemctl daemon-reload

#执行以下命令，将 Trojan 服务加入到开机自启动列表中：

sudo systemctl enable trojan.service
#启动
sudo systemctl start trojan.service

#你可以使用systemctl status命令检查服务的状态，确保服务已经成功启动，命令如下：

sudo systemctl status trojan.service


//您可以使用以下命令持续查看 trojan.service 的运行状态：
sudo journalctl -u trojan.service -f




#查看防火墙状态
firewall-cmd --state

#停止firewall
systemctl stop firewalld.service
