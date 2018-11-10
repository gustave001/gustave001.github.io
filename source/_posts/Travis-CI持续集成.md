---
title: Travis-CI持续集成
tags:
  - Travis CI
  - 持续集成
categories: 博客搭建
abbrlink: d4ce3f58
date: 2018-11-10 01:20:34
---
# 生命不息，折腾不止
- 还是没忍住捣腾了下Travis CI的持续集成，一开始因为墙的问题，node-sass下不来，折腾挺久，坑啊！！
- 解决办法就是cnpm！！
<!--more-->
.travis.yml的配置文件如下
```yaml
language: node_js
node_js: stable

cache:
  directories:
    - node_modules # 缓存不经常更改的内容

before_install:
  - export TZ='Asia/Shanghai' # 更改时区

# S: Build Lifecycle
install:
  - npm install cnpm -g --registry=https://registry.npm.taobao.org
  - cnpm install


#before_script:
# - npm install -g gulp

script:
  - hexo clean  #清除
  - hexo g && gulp  #生成

after_script:
  - git clone https://${GH_REF} .deploy_git  # GH_REF是最下面配置的仓库地址
  - cd .deploy_git
  - git checkout master
  - cd ../
  - mv .deploy_git/.git/ ./public/   # 这一步之前的操作是为了保留master分支的提交记录，不然每次git init的话只有1条commit
  - cd ./public
  - git config user.name "Gustave"
  - git config user.email "1014016816@qq.com"
  - git add .
  - git commit -m "Travis CI Auto Builder at `date +"%Y-%m-%d %H:%M"`"  # 提交记录包含时间 跟上面更改时区配合
  - git push --force --quiet "https://${GH_TOKEN}@${GH_REF}" master:master
# E: Build LifeCycle

branches:
  only:
    - source
env:
  global:
    - GH_REF: github.com/kikyou93/kikyou93.github.io.git

# configure notifications (email, IRC, campfire etc)
# please update this section to your needs!
# https://docs.travis-ci.com/user/notifications/
notifications:
  email:
    - 1014016816@qq.com
  on_success: change
  on_failure: always

```

- 持续集成了就是方便，哈哈
