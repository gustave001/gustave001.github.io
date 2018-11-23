---
title: nginx折腾记
tags: [nginx,折腾]
categories: 好奇尚异
date: 2018-11-23 19:16:12
updated: 2018-11-23 19:16:12
---
- docker-compose.yml
```yaml
version: '3.1'
services:
  web:
    image: nginx
    restart: always
    container_name: nginx
    volumes:
     - ./nginx.conf:/etc/nginx/nginx.conf
    ports:
     - "80:80"
```
- nginx.conf
```
user  nginx;
worker_processes  1;

events {
    worker_connections  1024;
}

http {
    include       mime.types;
    default_type  application/octet-stream;

    sendfile        on;

    keepalive_timeout  65;

    # 配置一个代理服务器
    upstream kikfan {
        server space.kikfan.com:5000;
    }

    # 配置一个虚拟主机
    server {
        listen 80;
        server_name yp.kikfan.com;
        location / {
                # 域名 yp.kikfan.com 的请求全部转发到 kikfan 服务上
                proxy_pass http://kikfan;
                # 欢迎页面，按照从左到右的顺序查找页面
                # index index.jsp index.html index.htm;
        }
    }

}
```
