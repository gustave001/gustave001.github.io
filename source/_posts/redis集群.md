---
title: redis集群搭建
tags: [redis]
date: 2020-10-14 11:06:15
updated: 2020-10-14 11:06:15
categories: 好奇尚异
--- 

# config
```
port 6391

tcp-backlog 511

timeout 0

tcp-keepalive 300

supervised no

pidfile /var/run/redis_6391.pid

loglevel notice

logfile ""

databases 16

always-show-logo yes


save 900 1
save 300 10
save 60 10000

stop-writes-on-bgsave-error yes

rdbcompression yes

rdbchecksum yes

# The filename where to dump the DB
dbfilename dump.rdb

dir "/data"

################################# REPLICATION #################################

# Master-Replica replication. Use replicaof to make a Redis instance a copy of
masterauth 123456

```


# redis.sh
```
redis-server  /config/nodes-${PORT}.conf
```

# yml
```
version: "3"
services:
    network_mode: host # 使用host模式
    privileged: true # 拥有容器内命令执行的权限
    volumes:
      - /usr/local/src/docker/redis-cluster/config:/config #配置文件目录映射到宿主机
    entrypoint: # 设置服务默认的启动程序
      - /bin/bash
      - redis.sh
  redis-master2:
    image: redis:5.0
    working_dir: /config
    container_name: node2
    environment:
      - PORT=6392
    ports:
      - 6392:6392
      - 16392:16392
    stdin_open: true
    network_mode: host
    tty: true
    privileged: true
    volumes:
      - /usr/local/src/docker/redis-cluster/config:/config
    entrypoint:
      - /bin/bash
      - redis.sh
  redis-master3:
    image: redis:5.0
    container_name: node3
    working_dir: /config
    environment:
      - PORT=6393
    ports:
      - 6393:6393
      - 16393:16393
    stdin_open: true
    network_mode: host
    tty: true
    privileged: true
    volumes:
      - /usr/local/src/docker/redis-cluster/config:/config
    entrypoint:
      - /bin/bash
      - redis.sh
```

# 集群的创建
- 需要在容器里面执行 一条创建集群的语句
- 关于建立集群的说明 [https://www.cnblogs.com/zhoujinyi/p/11606935.html](https://www.cnblogs.com/zhoujinyi/p/11606935.html)
```
redis-cli --cluster add-node 192.168.163.132:6382 192.168.163.132:6379 --cluster-slave --cluster-master-id 117457eab5071954faab5e81c3170600d5192270

```
