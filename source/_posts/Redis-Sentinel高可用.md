---
title: 'Redis,Sentinel高可用'
tags: [Redis,Sentinel,Docker]
date: 2019-01-11 03:22:29
updated: 2019-01-11 03:38:37
categories: 好奇尚异
---
- redis,sentinel的高可用,必须允许sentinel更改配置文件
- 查找资料，分析原因，问题在于使用了Docker之后，不在同一网段
- 解决办法，使用host网络模式即可
- 借此，引申需要研究Docker-Compose的各项命令，网络模式的研究

# redis.yml配置
```yaml
version: '3.1'
services:
  redis1:
    image: redis:3.2.1
    container_name: redis1
    restart: always
    command: /usr/local/bin/redis-server /usr/local/redis.conf
    volumes:
      - /usr/local/docker/redis/redis1-data:/data
      - /usr/local/docker/redis/redis1.conf:/usr/local/redis.conf
    ports:
      - 6379:6379
    network_mode: "host"

  redis2:
    image: redis:3.2.1
    container_name: redis2
    restart: always
    command: /usr/local/bin/redis-server /usr/local/redis.conf
    volumes:
      - /usr/local/docker/redis/redis2-data:/data
      - /usr/local/docker/redis/redis2.conf:/usr/local/redis.conf
    ports:
      - 6380:6379
    network_mode: "host"

  redis3:
    image: redis:3.2.1
    container_name: redis3
    restart: always
    command: /usr/local/bin/redis-server /usr/local/redis.conf
    volumes:
      - /usr/local/docker/redis/redis3-data:/data
      - /usr/local/docker/redis/redis3.conf:/usr/local/redis.conf
    ports:
      - 6381:6381
    network_mode: "host"
```
# redis.conf
- master
```yaml
port 6379
masterauth 123456
requirepass 123456
```
- slave
```yaml
port 6380
masterauth 123456
requirepass 123456
slaveof 192.168.213.129 6379
```
# sentinel.yml
```yaml
version: '3.1'
services:
  sentinel1:
    image: redis:3.2.1
    container_name: redis-sentinel-1
    ports:
      - 26379:26379
    command: redis-sentinel /usr/local/etc/redis/sentinel.conf
    volumes:
      - /usr/local/docker/redis/sentinel1.conf:/usr/local/etc/redis/sentinel.conf
      - /usr/local/docker/redis/sentinel1-data:/data
    network_mode: "host"

  sentinel2:
    image: redis:3.2.1
    container_name: redis-sentinel-2
    ports:
      - 26380:26379
    command: redis-sentinel /usr/local/etc/redis/sentinel.conf
    volumes:
      - /usr/local/docker/redis/sentinel2.conf:/usr/local/etc/redis/sentinel.conf
      - /usr/local/docker/redis/sentinel2-data:/data
    network_mode: "host"

  sentinel3:
    image: redis:3.2.1
    container_name: redis-sentinel-3
    ports:
      - 26381:26379
    command: redis-sentinel /usr/local/etc/redis/sentinel.conf
    volumes:
      - /usr/local/docker/redis/sentinel3.conf:/usr/local/etc/redis/sentinel.conf
      - /usr/local/docker/redis/sentinel3-data:/data
    network_mode: "host"
```
# sentinel.conf
```yaml
port 26379
sentinel monitor mymaster 192.168.213.129 6379 2
sentinel auth-pass mymaster 123456
sentinel down-after-milliseconds mymaster 15000
sentinel parallel-syncs mymaster 1
sentinel failover-timeout mymaster 80000
protected-mode no
```