---
title: postgres全备份和增量备份
tags: [postgres,数据库]
date: 2020-10-15 20:29:47
updated: 2020-10-15 20:29:47
categories: 好奇尚异
---


# 官网的备份和恢复的教程
- [http://www.postgres.cn/docs/11/continuous-archiving.html](http://www.postgres.cn/docs/11/continuous-archiving.html)

# 开启连续归档
- 集簇目录 找到postgres.conf
```shell script
[root@localhost pgsql]# ll
总用量 8
-rw-r--r--.  1 root    root  333 9月  28 16:49 docker-compose.yml
drwx------. 19 polkitd root 4096 10月 12 09:34 pgdata
[root@localhost pgsql]# vi docker-compose.yml 
[root@localhost pgsql]# vi pgdata/postgresql.conf 

###
wal_level = replica

archive_mode = on

archive_command = 'test ! -f /backup/pg_archive/%f && cp %p /backup/pg_archive/%f'
###

[root@localhost pgsql]# docker-compose down
Stopping pgsql ... done
Removing pgsql ... done
Removing network pgsql_default
[root@localhost pgsql]# docker-compose up -d
Creating network "pgsql_default" with the default driver
Creating pgsql ... done


```
- 重启pg

# 获取用户信息 并赋予备份目录权限
```shell script
[root@localhost backup]# docker exec -it pgsql bash
root@72bd09e3b44e:/# su postgres
postgres@72bd09e3b44e:/$ who am i && id
uid=999(postgres) gid=999(postgres) groups=999(postgres),103(ssl-cert)
```

```shell script
drwxr-xr-x. 3 root root  4096 10月 15 17:51 backup
drwx------. 2 root root 16384 9月  22 18:49 lost+found
[root@localhost home]# pwd
/home
[root@localhost home]# chown -R 999:999 backup/
```

# 进行全量备份
```shell script
docker exec pgsql /bin/bash -c "mkdir -p /backup/$(date '+%Y-%m-%d') && pg_basebackup -D /backup/$(date '+%Y-%m-%d') -Upostgres -R" 

```

```shell script
drwxr-xr-x. 19 root    root  4096 10月 15 18:11 2020-10-15
drwxr-xr-x.  2 polkitd input 4096 10月 15 18:11 pg_archive
[root@localhost backup]# du -sh 2020-10-15/
1.3G    2020-10-15/
[root@localhost backup]#
```


# 恢复
- 全量备份的文件复制到 $PGDATA，配置好相应的docker-compose.yml （注意不能现在还不能启动）
- $PGDATA 目录创建 recovery.conf 文件，配置恢复信息
```shell script
restore_command = 'cp /backup/pg_archive/%f %p'                    

recovery_target_time = '2020-10-14 16:38:00+08'

```
- docker-compose.yml 所在目录 执行 docker-compose up -d
- 连接上数据库之后，执行 `select  pg_wal_replay_resume();  # 必须使用该命令来截断wal 恢复中的部分信息(恢复的时间节点，使得wal文件并没有完全执行完)`



# 定时任务执行备份，并定期删除过期文件
```shell script
#!/bin/bash
docker exec pgsql /bin/bash -c "mkdir -p /backup/$(date '+%Y-%m-%d') && pg_basebackup -D /backup/$(date '+%Y-%m-%d') -Upostgres -R" 
```