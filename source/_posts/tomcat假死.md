---
title: tomcat假死
tags: [Java,tomcat]
date: 2020-10-29 17:49:02
updated: 2020-10-29 17:49:02
categories: Java
---

# 前言
线上服务接口调取不了，但是定时任务却能正常执行，排查之后，基本确定是tomcat的假死导致，以下是解决过程 【转】[https://zhuanlan.zhihu.com/p/165995050](https://zhuanlan.zhihu.com/p/165995050)

# jstack 排查
### 查看cpu和内存 
```shell script
top -c 

top - 16:43:14 up 4 days, 20:57,  0 users,  load average: 0.20, 0.13, 0.16
Tasks:   4 total,   1 running,   3 sleeping,   0 stopped,   0 zombie
%Cpu(s):  0.6 us,  0.8 sy,  0.0 ni, 98.6 id,  0.0 wa,  0.0 hi,  0.0 si,  0.0 st
KiB Mem:  32194248 total,  6510148 used, 25684100 free,     2232 buffers
KiB Swap: 33550332 total,        0 used, 33550332 free.  2033696 cached Mem

   PID USER      PR  NI    VIRT    RES    SHR S  %CPU %MEM     TIME+ COMMAND                                                                                                                                                                
     1 root      20   0 18.098g 2.393g  15072 S   4.7  7.8   8:53.46 java -Dfilloginchecke.encoding=UTF-8 -Djava.security.egd=file:/./urandom -jar /app.jar                                                                                 
   338 root      20   0   21968   2188   1660 S   0.0  0.0   0:00.23 bash                                                                                                                                                                   
   458 root      20   0   21944   2164   1656 S   0.0  0.0   0:00.05 bash                                                                                                                                                                   
   835 root      20   0   23628   1572   1188 R   0.0  0.0   0:00.00 top c 
```
可以看到运行的程序 pid 是1 以及内存和cpu 情况

### jstack java的进程id
```shell script
jstack 1

"redisson-netty-2-8" #59 prio=5 os_prio=0 tid=0x00007f0008001000 nid=0x4d runnable [0x00007f00383fb000]
   java.lang.Thread.State: RUNNABLE
        at sun.nio.ch.EPollArrayWrapper.epollWait(Native Method)
        at sun.nio.ch.EPollArrayWrapper.poll(EPollArrayWrapper.java:269)
        at sun.nio.ch.EPollSelectorImpl.doSelect(EPollSelectorImpl.java:93)
        at sun.nio.ch.SelectorImpl.lockAndDoSelect(SelectorImpl.java:86)
        - locked <0x00000005d7161b70> (a io.netty.channel.nio.SelectedSelectionKeySet)
        - locked <0x00000005d7161b88> (a java.util.Collections$UnmodifiableSet)
        - locked <0x00000005d7161b28> (a sun.nio.ch.EPollSelectorImpl)
        at sun.nio.ch.SelectorImpl.select(SelectorImpl.java:97)
        at io.netty.channel.nio.SelectedSelectionKeySetSelector.select(SelectedSelectionKeySetSelector.java:62)
        at io.netty.channel.nio.NioEventLoop.select(NioEventLoop.java:791)
        at io.netty.channel.nio.NioEventLoop.run(NioEventLoop.java:439)
        at io.netty.util.concurrent.SingleThreadEventExecutor$5.run(SingleThreadEventExecutor.java:906)
        at io.netty.util.internal.ThreadExecutorMap$2.run(ThreadExecutorMap.java:74)
        at io.netty.util.concurrent.FastThreadLocalRunnable.run(FastThreadLocalRunnable.java:30)
        at java.lang.Thread.run(Thread.java:745)

"redisson-netty-2-7" #58 prio=5 os_prio=0 tid=0x00007f00e2a29800 nid=0x4c runnable [0x00007f001eaf8000]
   java.lang.Thread.State: RUNNABLE
        at sun.nio.ch.EPollArrayWrapper.epollWait(Native Method)
        at sun.nio.ch.EPollArrayWrapper.poll(EPollArrayWrapper.java:269)
        at sun.nio.ch.EPollSelectorImpl.doSelect(EPollSelectorImpl.java:93)
        at sun.nio.ch.SelectorImpl.lockAndDoSelect(SelectorImpl.java:86)
        - locked <0x00000005d69ee848> (a io.netty.channel.nio.SelectedSelectionKeySet)
        - locked <0x00000005d7298b40> (a java.util.Collections$UnmodifiableSet)
        - locked <0x00000005d69ee7a0> (a sun.nio.ch.EPollSelectorImpl)
        at sun.nio.ch.SelectorImpl.select(SelectorImpl.java:97)
        at io.netty.channel.nio.SelectedSelectionKeySetSelector.select(SelectedSelectionKeySetSelector.java:62)
        at io.netty.channel.nio.NioEventLoop.select(NioEventLoop.java:791)
        at io.netty.channel.nio.NioEventLoop.run(NioEventLoop.java:439)
        at io.netty.util.concurrent.SingleThreadEventExecutor$5.run(SingleThreadEventExecutor.java:906)
        at io.netty.util.internal.ThreadExecutorMap$2.run(ThreadExecutorMap.java:74)
        at io.netty.util.concurrent.FastThreadLocalRunnable.run(FastThreadLocalRunnable.java:30)
        at java.lang.Thread.run(Thread.java:745)
```
查找DeadThread 并没有死锁

### 查看进程中最耗cpu的子线程
```shell script
top -p  1 -H

top - 16:48:57 up 4 days, 21:03,  0 users,  load average: 0.16, 0.20, 0.18
Threads: 163 total,   0 running, 163 sleeping,   0 stopped,   0 zombie
%Cpu(s):  0.7 us,  1.0 sy,  0.0 ni, 98.3 id,  0.0 wa,  0.0 hi,  0.0 si,  0.0 st
KiB Mem:  32194248 total,  6485560 used, 25708688 free,     2232 buffers
KiB Swap: 33550332 total,        0 used, 33550332 free.  2047080 cached Mem

   PID USER      PR  NI    VIRT    RES    SHR S %CPU %MEM     TIME+ COMMAND                                                                                                                                                                 
   297 root      20   0 18.098g 2.356g  15072 S  3.3  7.7   2:14.20 java                                                                                                                                                                    
   142 root      20   0 18.098g 2.356g  15072 S  0.3  7.7   0:05.04 java                                                                                                                                                                    
   199 root      20   0 18.098g 2.356g  15072 S  0.3  7.7   0:06.95 java                                                                                                                                                                    
     1 root      20   0 18.098g 2.356g  15072 S  0.0  7.7   0:00.05 java                                                                                                                                                                    
     6 root      20   0 18.098g 2.356g  15072 S  0.0  7.7   0:28.20 java                                                                                                                                                                    
     7 root      20   0 18.098g 2.356g  15072 S  0.0  7.7   0:01.59 java                                                                                                                                                                    
     8 root      20   0 18.098g 2.356g  15072 S  0.0  7.7   0:01.65 java                                                                                                                                                                    
     9 root      20   0 18.098g 2.356g  15072 S  0.0  7.7   0:01.68 java                                                                                                                                                                    
    10 root      20   0 18.098g 2.356g  15072 S  0.0  7.7   0:01.65 java                                                                                                                                                                    
    11 root      20   0 18.098g 2.356g  15072 S  0.0  7.7   0:01.67 java                                                                                                                                                                    
    12 root      20   0 18.098g 2.356g  15072 S  0.0  7.7   0:01.67 java                                                                                                                                                                    
    13 root      20   0 18.098g 2.356g  15072 S  0.0  7.7   0:01.69 java                                                                                                                                                                    
    14 root      20   0 18.098g 2.356g  15072 S  0.0  7.7   0:01.62 java                                                                                                                                                                    
    15 root      20   0 18.098g 2.356g  15072 S  0.0  7.7   0:01.64 java                                                                                                                                                                    
    16 root      20   0 18.098g 2.356g  15072 S  0.0  7.7   0:01.68 java                                                                                                                                                                    
    17 root      20   0 18.098g 2.356g  15072 S  0.0  7.7   0:01.64 java                                                                                                                                                                    
    18 root      20   0 18.098g 2.356g  15072 S  0.0  7.7   0:01.64 java                                                                                                                                                                    
    19 root      20   0 18.098g 2.356g  15072 S  0.0  7.7   0:01.67 java                                                                                                                                                                    
    20 root      20   0 18.098g 2.356g  15072 S  0.0  7.7   0:02.15 java                                                                                                                                                                    
    21 root      20   0 18.098g 2.356g  15072 S  0.0  7.7   0:00.03 java                                                                                                                                                                    
    22 root      20   0 18.098g 2.356g  15072 S  0.0  7.7   0:00.04 java                                                                                                                                                                    
    23 root      20   0 18.098g 2.356g  15072 S  0.0  7.7   0:00.00 java                                                                                                                                                                    
    24 root      20   0 18.098g 2.356g  15072 S  0.0  7.7   0:25.34 java 
```
最耗资源的是297
- 将最耗cpu的线程id转换为16进制输出
```shell script
printf "%x \n" 297

root@598b9d456d11:/# printf "%x \n" 297
129 
root@598b9d456d11:/# 
```
- 查询具体出现问题的代码位置
```shell script
jstack 1 | grep 129 -A 30

root@598b9d456d11:/# jstack 1 | grep 129 -A 30
"System Clock" #245 daemon prio=5 os_prio=0 tid=0x00007efedc090000 nid=0x129 waiting on condition [0x00007eff841b5000]
   java.lang.Thread.State: TIMED_WAITING (parking)
        at sun.misc.Unsafe.park(Native Method)
        - parking to wait for  <0x0000000775c55c38> (a java.util.concurrent.locks.AbstractQueuedSynchronizer$ConditionObject)
        at java.util.concurrent.locks.LockSupport.parkNanos(LockSupport.java:215)
        at java.util.concurrent.locks.AbstractQueuedSynchronizer$ConditionObject.awaitNanos(AbstractQueuedSynchronizer.java:2078)
        at java.util.concurrent.ScheduledThreadPoolExecutor$DelayedWorkQueue.take(ScheduledThreadPoolExecutor.java:1093)
        at java.util.concurrent.ScheduledThreadPoolExecutor$DelayedWorkQueue.take(ScheduledThreadPoolExecutor.java:809)
        at java.util.concurrent.ThreadPoolExecutor.getTask(ThreadPoolExecutor.java:1067)
        at java.util.concurrent.ThreadPoolExecutor.runWorker(ThreadPoolExecutor.java:1127)
        at java.util.concurrent.ThreadPoolExecutor$Worker.run(ThreadPoolExecutor.java:617)
        at java.lang.Thread.run(Thread.java:745)

"redisson-3-16" #226 prio=5 os_prio=0 tid=0x00007f000002d800 nid=0x116 waiting on condition [0x00007f001ebf9000]
   java.lang.Thread.State: WAITING (parking)
        at sun.misc.Unsafe.park(Native Method)
        - parking to wait for  <0x00000005d69284e0> (a java.util.concurrent.locks.AbstractQueuedSynchronizer$ConditionObject)
        at java.util.concurrent.locks.LockSupport.park(LockSupport.java:175)
        at java.util.concurrent.locks.AbstractQueuedSynchronizer$ConditionObject.await(AbstractQueuedSynchronizer.java:2039)
        at java.util.concurrent.LinkedBlockingQueue.take(LinkedBlockingQueue.java:442)
        at java.util.concurrent.ThreadPoolExecutor.getTask(ThreadPoolExecutor.java:1067)
        at java.util.concurrent.ThreadPoolExecutor.runWorker(ThreadPoolExecutor.java:1127)
        at java.util.concurrent.ThreadPoolExecutor$Worker.run(ThreadPoolExecutor.java:617)
        at io.netty.util.concurrent.FastThreadLocalRunnable.run(FastThreadLocalRunnable.java:30)
        at java.lang.Thread.run(Thread.java:745)
```
- 当时出现很多time_waited的状态，通过这种方法找到了问题代码的具体位置

# netstat 查找

### docker安装netstat
```shell script
apt-get update

apt-get install net-tools
```

### linux 查看

- 查看tomcat服务对应的端口的连接状态，可以确定是有很多的TIME_WAIT状态
```shell script
netstat -an|grep 9909|awk '{count[$6]++} END{for (i in count) print(i,count[i])}'

FIN_WAIT2 2
LISTEN 1
TIME_WAIT 356
ESTABLISHED 13
```

- 如果是tcp的问题，用如下的命令
```shell script
netstat -n | awk '/^tcp/ {++S[$NF]} END {for(a in S) print a, S[a]}'

FIN_WAIT2 8
TIME_WAIT 6
ESTABLISHED 358
```