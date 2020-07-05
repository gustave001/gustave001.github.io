---
title: openvpn+frp实现内网穿透远程办公
tags:
  - openvpn
  - frp
  - 内网穿透
categories: 好奇尚异
abbrlink: 87304ffa
date: 2020-06-04 04:48:04
updated: 2020-06-04 04:48:04
---

# openvpn
- 使用Nyr大神的一键脚本即可（注：数据源上面吃了小亏，package 错误，不再犯）
```shell script
wget https://git.io/vpn -O openvpn-install.sh && bash openvpn-install.sh
```

# frp
###### - 站在巨人的肩膀上，同样简单操作，注意需要配置服务以防频繁掉（linux 配置系统服务）
`vi /lib/systemd/system/frpc.service`
```shell script
[Unit]
  
Description=frpc service

After=network.target syslog.target

Wants=network.target

[Service]

Type=simple

ExecStart=/root/frp_0.33.0_linux_amd64/frpc -c /root/frp_0.33.0_linux_amd64/frpc.ini

[Install]

WantedBy=multi-user.target

```
`systemctl enable frpc`

`systemctl start frpc`
- 配置frp的过程中有个小坑，frpc的映射必须填所在网段的地址
```shell script
[vpn]
type = tcp
local_ip = 192.168.0.0
local_port = 
remote_port = 
```