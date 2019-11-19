---
title: K线形态分析程序
tags:
  - 股票
categories: 好奇尚异
abbrlink: 728ca17
date: 2019-09-29 18:26:42
updated: 2019-11-19 11:30:10
password: cheer_up
abstract: 欢迎访问
message: Welcome, enter password to read this
---

# 懈怠
- 最近几月都得过且过，也没有认真地执行自己的计划
- 九月的尾巴，就先立个flag，十月要弄好Spring Boot的股票K线分析，设置定时爬取数据，并且每天爬取的数据的结果通过邮箱发送给自己，
对于上影线，双阴线，涨停加一阳进行分析,跑回测的概率
- 后期如果成熟获取了较为稳定的图形，那么可以引入分时的买入点。

```properties
DROP TABLE IF EXISTS `wal_training_record`;

CREATE TABLE `wal_training_record`(
  `training_record_id` INT NOT NULL AUTO_INCREMENT COMMENT 'id',
  `training_name` VARCHAR(50) NOT NULL COMMENT '训练名称',
  `training_type` VARCHAR(50) NOT NULL COMMENT '训练类型，normal:同步，strengthen:强化',
  `tenant_id` INT NOT NULL COMMENT '生成布置作业任务的教师tenantId',
  `end_time` DATETIME NULL COMMENT '截止时间',
  `creator` INT NULL COMMENT '创建人',
  `create_time` DATETIME NULL COMMENT '创建时间',
  `modifier` INT NULL COMMENT '修改人',
  `modify_time` DATETIME NULL COMMENT '修改时间',
  PRIMARY KEY(`training_record_id`),
  INDEX `idx_wtr_tenant_id`(`tenant_id`)
)DEFAULT CHARACTER SET=utf8 COMMENT='布置学习记录表';

DROP TABLE IF EXISTS `wal_training_record_dtl`;

CREATE TABLE `wal_training_record_dtl`(
  `training_record_obj_id` INT NOT NULL AUTO_INCREMENT COMMENT 'id',
  `tenant_id` INT NOT NULL COMMENT '生成布置作业任务的教师tenantId',
  `creator` INT NULL COMMENT '创建人',
  `create_time` DATETIME NULL COMMENT '创建时间',
  `modifier` INT NULL COMMENT '修改人',
  `modify_time` DATETIME NULL COMMENT '修改时间',
  PRIMARY KEY(`training_record_obj_id`),
  INDEX `idx_wtr_tenant_id`(`tenant_id`)
)DEFAULT CHARACTER SET=utf8 COMMENT='布置学习记录表';


DROP TABLE IF EXISTS `wal_training_record_obj`;

CREATE TABLE `wal_training_record_obj`(
  `training_record_obj_id` INT NOT NULL AUTO_INCREMENT COMMENT 'id',
  `student_id` INT NOT NULL COMMENT '学生id',
  `tenant_id` INT NOT NULL COMMENT '生成布置作业任务的教师tenantId',
  `creator` INT NULL COMMENT '创建人',
  `create_time` DATETIME NULL COMMENT '创建时间',
  `modifier` INT NULL COMMENT '修改人',
  `modify_time` DATETIME NULL COMMENT '修改时间',
  PRIMARY KEY(`training_record_obj_id`),
  INDEX `idx_wtr_tenant_id`(`tenant_id`)
)DEFAULT CHARACTER SET=utf8 COMMENT='布置学习记录表';
```
