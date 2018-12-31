---
title: redis和jenkins
tags:
  - redis
  - jenkins
categories: 好奇尚异
abbrlink: 9494c549
date: 2018-12-08 21:58:54
updated: 2018-12-31 14:27:42
---
time flies
# redis

# jenkins

最近略忙，都没时间搞了，冒个泡  
我的自信和自负皆源自于此，如此一直下去就可以了
即将更新，redis！！

redis连踩两天坑，终于搞定！！爽

# pom依赖
- 由于spring版本的问题，踩了几多坑，找到合适的版本
```xml
		<dependency>
			<groupId>org.springframework.data</groupId>
			<artifactId>spring-data-redis</artifactId>
			<version>1.8.11.RELEASE</version>
		</dependency>
		<dependency>
			<groupId>biz.paluch.redis</groupId>
			<artifactId>lettuce</artifactId>
			<version>4.2.0.Final</version>
		</dependency>
```

# redis.properties
- 使用的哨兵模式
```properties
redis.nodes=192.168.213.129:26379,192.168.213.129:26380,192.168.213.129:26381
redis.masterName=mymaster
redis.password=
redis.maxTotal=10000
redis.maxIdle=100
redis.minIdle=50
redis.timeout=30000
redis.database=6
```

# applicationContext-redis.xml
- 使用lettuce操作redis
- 更改了序列化方式，可以直接查看redis里的数据
```xml

<?xml version="1.0" encoding="UTF-8"?>
<beans xmlns="http://www.springframework.org/schema/beans" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:jee="http://www.springframework.org/schema/jee" xmlns:tx="http://www.springframework.org/schema/tx" xmlns:mvc="http://www.springframework.org/schema/mvc" xmlns:context="http://www.springframework.org/schema/context"
	xsi:schemaLocation="http://www.springframework.org/schema/beans http://www.springframework.org/schema/beans/spring-beans-4.1.xsd
	                    http://www.springframework.org/schema/tx http://www.springframework.org/schema/tx/spring-tx-4.1.xsd 
	                    http://www.springframework.org/schema/jee http://www.springframework.org/schema/jee/spring-jee-3.0.xsd 
	                    http://www.springframework.org/schema/context http://www.springframework.org/schema/context/spring-context-4.1.xsd
	                    http://www.springframework.org/schema/mvc http://www.springframework.org/schema/mvc/spring-mvc-4.1.xsd ">


    <!--连接池配置-->
    <bean id="defaultLettucePool" class="org.springframework.data.redis.connection.lettuce.DefaultLettucePool">
        <constructor-arg name="sentinelConfiguration" ref="lettuceSentinelConfiguration"/>
        <property name="poolConfig" ref="genericObjectPoolConfig"/>
    </bean>

    <!--common-pool2线程池配置-->
    <bean id="genericObjectPoolConfig" class="org.apache.commons.pool2.impl.GenericObjectPoolConfig">
        <property name="maxIdle" value="${redis.maxIdle}"/>
        <property name="minIdle" value="${redis.minIdle}"/>
        <property name="maxTotal" value="${redis.maxTotal}"/>
        <!-- 其他相关配置 -->
    </bean>

    <!--哨兵集群信息配置-->
    <bean id="lettuceSentinelConfiguration" class="org.springframework.data.redis.connection.RedisSentinelConfiguration">
        <constructor-arg name="master" value="${redis.masterName}"/>
        <constructor-arg name="sentinelHostAndPorts" value="${redis.nodes}"/>
    </bean>

    <bean id="lettuceConnectionFactory" class="org.springframework.data.redis.connection.lettuce.LettuceConnectionFactory">
        <!--注销掉的部分为spring-data-redis2.0以下的版本配置的方式-->
        <!--<constructor-arg name="sentinelConfiguration" ref="lettuceSentinelConfiguration"/>-->
        <constructor-arg name="pool" ref="defaultLettucePool"/>
        <property name="database" value="${redis.database}"/>
        <!--spring-data-redis2.0以上建议获取的方式-->
        <!--<constructor-arg name="standaloneConfig" ref="redisStandaloneConfiguration"></constructor-arg>-->
    </bean>


    <!--手动设置 key  与 value的序列化方式-->
    <bean id="keySerializer" class="org.springframework.data.redis.serializer.StringRedisSerializer"/>
    <bean id="valueSerializer" class="org.springframework.data.redis.serializer.GenericJackson2JsonRedisSerializer"/>

    <!--配置jedis模板  -->
    <bean id = "redisTemplate" class="org.springframework.data.redis.core.RedisTemplate">
        <property name="connectionFactory" ref="lettuceConnectionFactory" />
        <property name="keySerializer" ref="keySerializer" />
        <property name="valueSerializer" ref="valueSerializer" />
        <property name="hashKeySerializer" ref="keySerializer" />
        <property name="hashValueSerializer" ref="valueSerializer" />
    </bean>

    <!--也可以StringRedisTemplate  专注于String的操作  -->
    <bean id="stringRedisTemplate" class="org.springframework.data.redis.core.StringRedisTemplate">
        <!--<property name="connectionFactory" ref="jedisConnectionFactory"></property>-->
        <!--在StringRedisTemplate与redisTemplate不同,可以直接造构造器中传入ConnectionFactory-->
        <constructor-arg name="connectionFactory" ref="lettuceConnectionFactory"/>
        <property name="keySerializer" ref="keySerializer" />
        <property name="valueSerializer" ref="valueSerializer" />
        <property name="hashKeySerializer" ref="keySerializer" />
        <property name="hashValueSerializer" ref="valueSerializer" />

    </bean>

</beans>

```