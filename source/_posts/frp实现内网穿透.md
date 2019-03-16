---
title: frp实现内网穿透
tags: [frp,内网穿透]
date: 2019-03-16 10:23:33
updated: 2019-03-17 02:37:22
categories: 好奇尚异
---

# 什么是frp

frp 是一个高性能的反向代理应用，可以帮助您轻松地进行内网穿透，对外网提供服务，支持 tcp, http, https 等协议类型，并且 web 服务支持根据域名进行路由转发。

# 准备
在使用frp之前，需要一台有公网IP的服务器（下文称外网主机），一台需要实现内网穿透的机器（下文称内网主机），SSH工具，以及一个域名（如果只是建立SSH反向代理则不需要域名）。
该文章中笔者所使用的服务器是朋友推荐的Vultr服务器，虽然服务器是在国外，但胜在带宽够，有需要的朋友可以注册一个。而需要实现内网穿透的机器则是笔者用上网本搭建的黑。SSH工具使用的是Xshell 5。而域名笔者则是使用自己个人网站的域名。
开始使用
根据机器的操作系统，在Release页面中找到对应的frp程序，然后分别在外网主机和内网主机中下载它。
下面的所示范用的frp程序版本是以笔者的服务器为主的。
外网主机
SSH连接上外网主机后，使用wget指令下载frp。
```jshelllanguage
wget https://github.com/fatedier/frp/releases/download/v0.20.0/frp_0.20.0_linux_amd64.tar.gz
```

使用tar指令解压tar.gz文件
```jshelllanguage
tar -zxvf frp_0.20.0_linux_amd64.tar.gz
```

使用cd指令进入解压出来的文件夹
```jshelllanguage
cd frp_0.20.0_linux_amd64/
```

外网主机作为服务端，可以删掉不必要的客户端文件，使用rm指令删除文件。
```jshelllanguage
rm -f frpc
rm -f frpc.ini
```

接下来要修改服务器配置文件，即frps.ini文件。使用vi指令对目标文件进行编辑。
```jshelllanguage
vi frps.ini
```

打开frps.ini后可以看到默认已经有很多详细的配置和示范样例，该文章仅以达到内网穿透为目的，所以这里选择删掉或注释掉里面的所有内容，然后根据的情况，按照官方的中文文档添加以下配置。（这里的操作都使用vi命令，关于vi命令的使用方式这里不作详细介绍，可以自行搜索相关使用方法。）
```jshelllanguage
bind_port = 7000
vhost_http_port = 8080
```
# [common]

[common]部分是必须有的配置，其中bind_port是自己设定的frp服务端端口，vhost_http_port是自己设定的http访问端口。
保存上面的配置后，使用以下指令启动frp服务端。（如果需要在后台运行，请往下翻阅关于后台运行的部分。）
```jshelllanguage
./frps -c ./frps.ini
```

服务端的工作就到此结束了。
# 客户端
客户端前面的操作和服务端是一模一样的，这里不一一解释。
```jshelllanguage
wget https://github.com/fatedier/frp/releases/download/v0.20.0/frp_0.20.0_linux_amd64.tar.gz
tar -zxvf frp_0.20.0_linux_amd64.tar.gz
cd frp_0.20.0_linux_amd64
rm -f frps
rm -f frps.ini
vi frpc.ini
```

客户端的配置如下
```jshelllanguage
[common]
server_addr = x.x.x.x
server_port = 7000

[ssh]
type = tcp
local_ip = 127.0.0.1
local_port = 22
remote_port = 6000

[nas]
type = http
local_port = 5000
custom_domains = no1.sunnyrx.com

[web]
type = http
local_port = 80
custom_domains = no2.sunnyrx.com
```

上面的配置和服务端是对应的。
[common]中的server_addr填frp服务端的ip（也就是外网主机的IP），server_port填frp服务端的bind_prot。
[ssh]中的local_port填的ssh端口。
[nas]中的type对应服务端配置。local_port填的DSM端口。custom_domains为要映射的域名，记得域名的A记录要解析到外网主机的IP。
[web]同上，local_port填的web端口。这里创建了两个http反向代理是为了分别映射两个重要的端口，5000和80，前者用于登录管理，后者用于的Web Station和DS Photo。
保存配置，输入以下指令运行frp客户端。（同样如果需要在后台运行，请往下翻阅关于后台运行的部分。）
```jshelllanguage
./frpc -c ./frpc.ini
```
此时在服务端会看到"start proxy sucess"字样，即连接成功。
现在可以用SSH通过外网主机IP:6000和建立SSH连接。通过浏览器访问no1.sunnyrx.com:8080打开nas的管理页面，访问no2.sunnyrx.com:8080打开Web Station的网站，DS Photo app可以连接no2.sunnyrx.com:8080进入DS Photo管理。
# 让frp在后台运行
虽然现在frp运作起来了，内网穿透也实现了，但这还是不够的。此时如果断开与服务端或者客户端的SSH连接（比如关掉了Xshell）也就中止了frp的运行。
保持frp运行是关键是让服务端的frp和客户端的frp在后台运行，这里提两个方法供参考，一个是使用screen指令，另一个是使用nohup指令。由于的系统默认是没有screen指令的，这里也不提供安装screen的方法，所以推荐直接使用nohup。

其实服务端也直接用'nohup'就好了。

# 使用nohup指令
nohup指令的使用方法相对简单，只需要在nohup后面加上frp的运行指令即可。下面示范的指令是运行frp客户端。（同样，如果之前断开了SSH连接，记得用cd指令进入frp的目录先。）
```jshelllanguage
nohup ./frpc -c ./frpc.ini &
```

这样就成功让frp在后台运行了。

-  [原文链接](https://www.jianshu.com/p/e8e26bcc6fe6)
-  [GitHub](https://github.com/fatedier/frp/blob/master/README_zh.md)

# ngrok自建服务器穿透
- [ngrok](https://www.jianshu.com/p/b81bb6a3c0b9)
