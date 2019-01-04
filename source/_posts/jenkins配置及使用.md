---
title: jenkins配置及使用
tags: [jenkins]
date: 2019-01-01 13:49:43
updated: 2019-01-05 01:32:03
categories: 好奇尚异
---

# 关于/var/run/docker.sock
- http方式创建和启动容器，帮助理解
## 创建容器
```
curl -XPOST --unix-socket /var/run/docker.sock  -d '{"Image":"redis"}' -H 'Content-Type:application/json' http://localhost/containers/create

{"Id":"773590db01d5061c9edb91ab258a2bfb537d00b76b74c695ff9cb7564b46d1c3","Warnings":null}
```
## 启动容器
```
curl -XPOST --unix-socket /var/run/docker.sock http://localhost/containers/773590db01d5061c9edb91ab258a2bfb537d00b76b74c695ff9cb7564b46d1c3/start
```
# docker搭建jenkins
- docker-compose.yml
- 需要注意的是因为需求权限，所以添加root
```yaml
version: '3.1'
services:
  jenkins:
    restart: always
    image: jenkinsci/jenkins
    container_name: jenkins
    ports:
      - 8080:8080
    volumes:
      - /usr/local/docker/jenkins/jenkinsci_home:/var/jenkins_home
      - /var/run/docker.sock:/var/run/docker.sock
    user: root
```

