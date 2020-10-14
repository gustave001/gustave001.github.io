---
title: openvpn的ip切换
tags:
  - shell
  - vpn
  - yml
categories: uncategorized
abbrlink: 48632
date: 2020-07-31 10:30:29
updated: 2020-07-31 10:30:29
---
# 起因
- 本来用的好好的vpn，突然频繁断，然后使用finalshell连接vpn服务器，也频繁断开，折腾一天，啥都试了，以下是解决步骤

# 修改固定ip地址
```shell script
vi /etc/netplan/50-cloud-init.yaml

network:
    ethernets:
        enp0s17:
          addresses: [192.168.0.X/24]
          gateway4: 192.168.0.1
          nameservers:
            addresses: [192.168.0.1]
    version: 2
```
- netplan apply 进行提交

# 修改frpc的映射地址
- local_ip 改成新的地址
```shell script
[common]
server_addr = 
server_port = 
authentication_method = token
token = 


[vpn]
type = tcp
local_ip = 192.168.0.x
local_port = 
remote_port = 
```

# 修改server.conf
- 修改local的地址
```shell script
vi /etc/openvpn/server/server.conf

local 192.168.0.x
port 
proto tcp
dev tun
ca ca.crt
cert server.crt
key server.key
dh dh.pem
auth SHA512
tls-crypt tc.key
topology subnet
server 10.8.0.0 255.255.255.0
push "redirect-gateway def1 bypass-dhcp"
ifconfig-pool-persist ipp.txt
push "dhcp-option DNS 8.8.8.8"
push "dhcp-option DNS 8.8.4.4"
client-to-client
keepalive 10 120
cipher AES-256-CBC
user nobody
group nogroup
persist-key
persist-tun
status openvpn-status.log
verb 3
crl-verify crl.pem
```

# 修改openvpn-iptables的配置
- 这也是最关键的，卡在这步挺久。查的github上的issue才解决的，[https://github.com/Nyr/openvpn-install/issues/770](https://github.com/Nyr/openvpn-install/issues/770)
- 修改了配置之后需要reboot
```shell script
vi /etc/systemd/system/openvpn-iptables.service

[Unit]
Before=network.target
[Service]
Type=oneshot
ExecStart=/sbin/iptables -t nat -A POSTROUTING -s 10.8.0.0/24 ! -d 10.8.0.0/24 -j SNAT --to 192.168.0.x
ExecStart=/sbin/iptables -I INPUT -p tcp --dport 1194 -j ACCEPT
ExecStart=/sbin/iptables -I FORWARD -s 10.8.0.0/24 -j ACCEPT
ExecStart=/sbin/iptables -I FORWARD -m state --state RELATED,ESTABLISHED -j ACCEPT
ExecStop=/sbin/iptables -t nat -D POSTROUTING -s 10.8.0.0/24 ! -d 10.8.0.0/24 -j SNAT --to 192.168.0.x
ExecStop=/sbin/iptables -D INPUT -p tcp --dport 1194 -j ACCEPT
ExecStop=/sbin/iptables -D FORWARD -s 10.8.0.0/24 -j ACCEPT
ExecStop=/sbin/iptables -D FORWARD -m state --state RELATED,ESTABLISHED -j ACCEPT
RemainAfterExit=yes
[Install]
WantedBy=multi-user.target
```