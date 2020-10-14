---
title: git
tags:
  - git
categories: uncategorized
abbrlink: 43167
date: 2020-07-05 11:32:10
updated: 2020-07-05 11:32:10
---
# git reset --hard --soft --mixed区别
使用方法
`git reset --mixed/--hard/--soft  41e1d58739a5ab280b5b2dbde107c14aeeb0b6d2`

- git --soft
只是删除某次提交,再次提交直接commit即可

- git --mixed- 
删除某次提交,并且回到add之前的状态,再次提交先add  在commit

- git --hard
删除末次提交,并清空所有基于41e1d58739a5ab280b5b2dbde107c14aeeb0b6d2这次commit的修改.可能会造成数据丢失.

# git cherry-pick {commit_id} ...
合并一条或者多条的commit 记录

# git rebase {branch}
将当前分支基点置于另一分支的最后一个提交的位置，同样可以更新另一分支的内容，与merge的区别是1、rebase更加干净2、rebase 是线性的提交记录

# git rebase -i {commit_id}
交互模式，操作当前分支所在位置，通常用于插入commit，删除commit，合并commit等，功能较为强大
>  Commands:
   p, pick = use commit
   r, reword = use commit, but edit the commit message
   e, edit = use commit, but stop for amending
   s, squash = use commit, but meld into previous commit
   f, fixup = like "squash", but discard this commit's log message
   x, exec = run command (the rest of the line) using shell
   d, drop = remove commit

# merge 与 rebase的选择
- 不要在公共分支上使用rebase，因为rebase会修改提交记录，否则会造成回溯的困难

