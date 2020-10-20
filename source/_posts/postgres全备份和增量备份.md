---
title: postgres全备份和增量备份
tags:
  - postgres
  - 数据库
categories: SQL
abbrlink: 34964
date: 2020-10-15 20:29:47
updated: 2020-10-20
---


# 官网的备份和恢复的教程
- [http://www.postgres.cn/docs/11/continuous-archiving.html](http://www.postgres.cn/docs/11/continuous-archiving.html)

# 开启连续归档(增量备份)
- $PGDATA 即集簇目录 找到postgres.conf
### 集簇目录 
表示为数据卷的主目录，对应容器里的/var/lib/postgres/data
```shell_script
[root@localhost pgsql]# ll
总用量 8
-rw-r--r--.  1 root    root  333 9月  28 16:49 docker-compose.yml
drwx------. 19 polkitd root 4096 10月 12 09:34 pgdata
[root@localhost pgsql]# vi docker-compose.yml 
[root@localhost pgsql]# vi pgdata/postgresql.conf 

###
wal_level = replica

archive_mode = on

archive_command = 'test ! -f /backup/pg_archive/%f.gz && gzip < %p > /backup/pg_archive/%f.gz'
###

[root@localhost pgsql]# docker-compose down
Stopping pgsql ... done
Removing pgsql ... done
Removing network pgsql_default
[root@localhost pgsql]# docker-compose up -d
Creating network "pgsql_default" with the default driver
Creating pgsql ... done
```

### 重新加载postgres.conf 
- 对archive_command 生效
```shell_script
SELECT pg_reload_conf();
```

### 常用的归档配置如下
1. 非压缩

archive_command = 'cp %p /appdata/pgsql/pg_archive/%f && echo %f >> /appdata/pgsql/pg_archive/archive.list'
restore_command = 'cp /appdata/pgsql/pg_archive/%f %p'
2. 压缩 gzip

archive_command = 'gzip < %p > /appdata/pgsql/pg_archive/%f.gz'
restore_command = 'gunzip < /appdata/pgsql/pg_archive/%f.gz > %p'
3. 压缩 bzip2

archive_command = 'bzip2 < %p > /appdata/pgsql/pg_archive/%f.bz2'
restore_command = 'bunzip2 < /appdata/pgsql/pg_archive/%f.bz2 > %p'
4. 压缩 lz4

archive_command = 'lz4 -f -q -z %p /appdata/pgsql/pg_archive/%f.lz4'
restore_command = 'lz4 -f -q -d /appdata/pgsql/pg_archive/%f.lz4 %p'
5. scp方式

archive_command = 'scp %p dragon02:/appdata/pgsql/pg_archive/%f'
restore_command = 'scp dragon02:/appdata/pgsql/pg_archive/%f %p'
6. rsync方式

archive_command = 'rsync -a %p barman@dragon02:/appdata/pgsql/pg_archive/%f'
restore_command = 'rsync -a barman@dragon02:/appdata/pgsql/pg_archive/%f %p'
7. windows

archive_command = 'copy "%p" "C:\\appdata\\pgsql\\pg_archive\\%f"'


### 获取用户信息 并赋予备份目录权限
- 注：因wal归档有以postgres身份执行的cp命令，所以需要该操作
```shell_script
[root@localhost backup]# docker exec -it pgsql bash
root@72bd09e3b44e:/# su postgres
postgres@72bd09e3b44e:/$ who am i && id
uid=999(postgres) gid=999(postgres) groups=999(postgres),103(ssl-cert)
```

```shell_script
[root@localhost data]# mkdir -p /backup/pg_archive
[root@localhost data]# chown -R 999:999 backup/
```

# 进行全量备份
```shell_script
docker exec pgsql /bin/bash -c "mkdir -p /backup/$(date '+%Y-%m-%d') && pg_basebackup -D /backup/$(date '+%Y-%m-%d') -Upostgres" 

```
- 带压缩的命令
```shell_script
 docker exec pgsql /bin/bash -c "mkdir -p /backup/$(date '+%Y-%m-%d') && pg_basebackup -D /backup/$(date '+%Y-%m-%d') -Upostgres -Ft -z -v"
```


```shell_script
drwxr-xr-x. 19 root    root  4096 10月 15 18:11 2020-10-15
drwxr-xr-x.  2 polkitd input 4096 10月 15 18:11 pg_archive
[root@localhost backup]# du -sh 2020-10-15/
1.3G    2020-10-15/
[root@localhost backup]#
```


# 恢复
- 解压缩相应日期下的备份，并复制到数据卷对应的数据库集簇目录，例如挂载方式为/home/data/docker/pgdata:/var/lib/postgres/data 则复制到宿主机的/home/data/docker/pgdata下
```shell_script
[root@localhost 2020-10-16]# pwd
/home/backup/2020-10-16
tar -xzvf base.tar.gz
cp * /data/docker/pgsql/pgdata/
```
- 配置好相应的docker-compose.yml （注意不能现在还不能启动）
- $PGDATA 目录创建 recovery.conf 文件，配置恢复信息
```shell_script
cat recovery.conf

restore_command = 'gunzip < /backup/pg_archive/%f.gz > %p'                    

recovery_target_time = '2020-10-14 16:38:00+08'
# recovery_target_timeline = 'latest'

```
- docker-compose.yml 所在目录 执行 docker-compose up -d
- 连接上数据库之后，执行 `select  pg_wal_replay_resume();  # 必须使用该命令来截断wal 恢复中的部分信息(恢复的时间节点，使得wal文件并没有完全执行完)`
### recovery.conf
- recovery_target = ‘immediate’ :这个参数指定恢复应该在达到一个一致状态后尽快结束，即尽早结束。在从一个在线备份中恢复时，这意味着备份结束的那个点。
- recovery_target_name (string) :指定（pg_create_restore_point()所创建）的已命名的恢复点，进行恢复。
- recovery_target_time (timestamp) ：这个参数指定按时间戳恢复。
- recovery_target_xid (string) ：这个参数指定按事务 ID进行恢复。
- recovery_target_lsn (pg_lsn) ：这个参数指定按继续进行的预写日志位置的LSN进行恢复。
- recovery_target_inclusive (boolean)：指定我们是否仅在指定的恢复目标之后停止（true）， 或者仅在恢复目标之前停止（false）。 适用于recovery_target_lsn、recovery_target_time - 或者recovery_target_xid被指定的情况。 这个设置分别控制事务是否有准确的目标WAL位置(LAN)、提交时间或事务ID将被包括在该恢复中。 默认值为true。
- recovery_target_timeline (string) ：指定恢复到一个特定的时间线中。默认值是沿着基础备份建立时的当前时间线恢复。将这个参数设置为latest会恢复到该归档中能找到的最新的时间线。
- recovery_target_action (enum) ：指定在达到恢复目标时服务器应该立刻采取的动作，包括pause（暂停）、promote（接受连接）、shutdown（停止服务器），其中pause为默认动作



# 定时任务执行备份，并删除过期文件
- 定时任务,每天凌晨 0点5分执行该脚本，并记录执行日志
```shell_script
[root@localhost backup]# crontab -l
5 0 * * * /bin/bash /data/backup/cron/pg_backup_and_clear.sh 1>>/data/backup/log/backup.log 2>&1
```

- 具体脚本
```shell_script
[root@localhost backup]# cat cron/pg_backup_and_clear.sh 
#!/bin/bash
export backupPath=/data/backup
export fileKeep=+20
echo "$(date +'%F %H:%M:%S') backup start"
docker exec pgsql /bin/bash -c "mkdir -p /backup/$(date '   +%Y-%m-%d') && pg_basebackup -D /backup/$(date '+%Y-%m-%d') -Upostgres -Ft -z -v"
echo "$(date +'%F %H:%M:%S') backup finish"
find $backupPath -name "*.tar.gz" -mtime $fileKeep |xargs rm -fr
find $backupPath -name "*-*-*" -mtime $fileKeep |xargs rm -fr
find $backupPath/pg_archive -mtime $fileKeep |xargs rm -fr
```

# 定时任务执行有效期加10年的操作
- 注意这里转义字符的使用，还是挺讲究的
```shell_script
docker exec pgsql /bin/bash -c "psql -U postgres -d zegobirdWMS_Storage -c \"UPDATE tb_locationstock SET expirationdate = expirationdate + INTERVAL '10 YEAR' WHERE expirationdate < '2025-01-01'\""
```

# 切换wal 日志
```shelll_script
select pg_switch_wal();
```