---
title: Git使用
tags:
  - git
categories: 实用工具
abbrlink: ca675cd4
date: 2019-06-19 12:31:03
updated: 2019-06-19 12:31:03
---

# git reset --hard --soft --mixed区别
使用方法
git reset --mixed/--hard/--soft  41e1d58739a5ab280b5b2dbde107c14aeeb0b6d2

git --soft
只是删除某次提交,再次提交直接commit即可

git --mixed
删除某次提交,并且回到add之前的状态,再次提交先add  在commit

git --hard
删除末次提交,并清空所有基于41e1d58739a5ab280b5b2dbde107c14aeeb0b6d2这次commit的修改.可能会造成数据丢失.
