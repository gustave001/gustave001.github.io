---
title: shell学习
tags: [shell]
date: 2019-10-11 16:26:32
updated: 2019-10-11 16:26:32
categories: 好奇尚异
---

# shell脚本学习

- echo -e 不显示转义的字符

- shell传递参数实例
```jshelllanguage
#!/bin/bash
# author:菜鸟教程
# url:www.runoob.com

echo "Shell 传递参数实例！";
echo "执行的文件名：$0";
echo "第一个参数为：$1";
echo "第二个参数为：$2";
echo "第三个参数为：$3";

$ chmod +x test.sh 
$ ./test.sh 1 2 3
Shell 传递参数实例！
执行的文件名：./test.sh
第一个参数为：1
第二个参数为：2
第三个参数为：3
```

- $* 与 $@ 区别：
 相同点：都是引用所有参数。
 不同点：只有在双引号中体现出来。假设在脚本运行时写了三个参数 1、2、3，，则 " * " 等价于 "1 2 3"（传递了一个参数），而 "@" 等价于 "1" "2" "3"（传递了三个参数）。

- 运算符
eq：equal to。
ne：not equal to。
gt：greater than。
ge：greater than or equal to。
lt：less than。
le：less than or equal to。


