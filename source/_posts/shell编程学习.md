---
title: shell编程学习
tags: [shell]
date: 2020-10-16 19:52:07
updated: 2020-10-16 19:52:07
categories: 好奇尚异
---

# 经常接触到shell，早就想系统学习一下shell编程了
- [https://www.runoob.com/linux/linux-shell.html](https://www.runoob.com/linux/linux-shell.html)


# 标准输出与标准错误

``` shell_script
root@k8s-slave01:~/bash# ./test.sh >/dev/null
cat: nosuchfile: No such file or directory
root@k8s-slave01:~/bash# ./test.sh >/dev/null 2>&1
root@k8s-slave01:~/bash# ll
total 12
drwxr-xr-x  2 root root 4096 Oct 16 16:00 ./
drwx------ 13 root root 4096 Oct 16 16:00 ../
-rwxr-xr-x  1 root root   28 Oct 16 16:00 test.sh*
root@k8s-slave01:~/bash# ./test.sh
hello
cat: nosuchfile: No such file or directory
root@k8s-slave01:~/bash# ll
total 12
drwxr-xr-x  2 root root 4096 Oct 16 16:00 ./
drwx------ 13 root root 4096 Oct 16 16:00 ../
-rwxr-xr-x  1 root root   28 Oct 16 16:00 test.sh*
root@k8s-slave01:~/bash# cat test.sh 
echo "hello"
cat nosuchfile
```

# Shell 传递参数
我们可以在执行 Shell 脚本时，向脚本传递参数，脚本内获取参数的格式为：$n。n 代表一个数字，1 为执行脚本的第一个参数，2 为执行脚本的第二个参数，以此类推……

```shell_script

$ chmod +x test.sh 
$ ./test.sh 1 2 3
Shell 传递参数实例！
执行的文件名：./test.sh
第一个参数为：1
第二个参数为：2
第三个参数为：3
```

- 在为shell脚本传递的参数中如果包含空格，应该使用单引号或者双引号将该参数括起来，以便于脚本将这个参数作为整体来接收
- Shell 里面的中括号（包括单中括号与双中括号）可用于一些条件的测试：
算术比较, 比如一个变量是否为0, [ $var -eq 0 ]。
文件属性测试，比如一个文件是否存在，[ -e $var ], 是否是目录，[ -d $var ]。
字符串比较, 比如两个字符串是否相同， [[ $var1 = $var2 ]]。

# shell数组
```shell_script
#!/bin/bash
# author:菜鸟教程
# url:www.runoob.com

my_array=(A B "C" D)

echo "第一个元素为: ${my_array[0]}"
echo "第二个元素为: ${my_array[1]}"
echo "第三个元素为: ${my_array[2]}"
echo "第四个元素为: ${my_array[3]}"
执行脚本，输出结果如下所示：

$ chmod +x test.sh 
$ ./test.sh
第一个元素为: A
第二个元素为: B
第三个元素为: C
第四个元素为: D
```

# shell基本运算符
- 表达式和运算符之间要有空格，例如 2+2 是不对的，必须写成 2 + 2，这与我们熟悉的大多数编程语言不一样。
- 完整的表达式要被 ` ` 包含，注意这个字符不是常用的单引号，在 Esc 键下边。
```shell_script
#!/bin/bash
# author:菜鸟教程
# url:www.runoob.com

a=10
b=20

val=`expr $a + $b`
echo "a + b : $val"

val=`expr $a - $b`
echo "a - b : $val"

val=`expr $a \* $b`
echo "a * b : $val"

val=`expr $b / $a`
echo "b / a : $val"

val=`expr $b % $a`
echo "b % a : $val"

if [ $a == $b ]
then
   echo "a 等于 b"
fi
if [ $a != $b ]
then
   echo "a 不等于 b"
fi
```


# echo命令
- 注意很多反斜杠的使用
```shell_script
read 命令从标准输入中读取一行,并把输入行的每个字段的值指定给 shell 变量

#!/bin/sh
read name 
echo "$name It is a test"
以上代码保存为 test.sh，name 接收标准输入的变量，结果将是:

[root@www ~]# sh test.sh
OK                     #标准输入
OK It is a test        #输出
```

# 输出日期
```shell_script
echo `date`
```

# printf命令
```shell_script
接下来,我来用一个脚本来体现printf的强大功能：

#!/bin/bash
# author:菜鸟教程
# url:www.runoob.com
 
printf "%-10s %-8s %-4s\n" 姓名 性别 体重kg  
printf "%-10s %-8s %-4.2f\n" 郭靖 男 66.1234 
printf "%-10s %-8s %-4.2f\n" 杨过 男 48.6543 
printf "%-10s %-8s %-4.2f\n" 郭芙 女 47.9876 
执行脚本，输出结果如下所示：

姓名     性别   体重kg
郭靖     男      66.12
杨过     男      48.65
郭芙     女      47.99
```

# Shell 流程控制
### if else
```shell_script
if condition
then
    command1 
    command2
    ...
    commandN 
fi
```

### for 循环
```shell_script
for var in item1 item2 ... itemN
do
    command1
    command2
    ...
    commandN
done
```

```shell_script
for var in item1 item2 ... itemN; do command1; command2… done;
```

- 例子
```shell_script
for loop in 1 2 3 4 5
do
    echo "The value is: $loop"
done
```


### while 语句
```shell_script
while condition
do
    command
done
```

```
#!/bin/bash
int=1
while(( $int<=5 ))
do
    echo $int
    let "int++"
done
```

### until 循环
```shell_script
until condition
do
    command
done
```

```shell_script
#!/bin/bash

a=0

until [ ! $a -lt 10 ]
do
   echo $a
   a=`expr $a + 1`
done
```

### case
```shell_script
case 值 in
模式1)
    command1
    command2
    ...
    commandN
    ;;
模式2）
    command1
    command2
    ...
    commandN
    ;;
esac
```
> case工作方式如上所示。取值后面必须为单词in，每一模式必须以右括号结束。取值可以为变量或常数。匹配发现取值符合某一模式后，其间所有命令开始执行直至 ;;。

取值将检测匹配的每一个模式。一旦模式匹配，则执行完匹配模式相应命令后不再继续其他模式。如果无一匹配模式，使用星号 * 捕获该值，再执行后面的命令。

下面的脚本提示输入1到4，与每一种模式进行匹配：

```shell_script
echo '输入 1 到 4 之间的数字:'
echo '你输入的数字为:'
read aNum
case $aNum in
    1)  echo '你选择了 1'
    ;;
    2)  echo '你选择了 2'
    ;;
    3)  echo '你选择了 3'
    ;;
    4)  echo '你选择了 4'
    ;;
    *)  echo '你没有输入 1 到 4 之间的数字'
    ;;
esac
```

> 输入不同的内容，会有不同的结果，例如：

输入 1 到 4 之间的数字:
你输入的数字为:
3
你选择了 3

### case ... esac
```shell_script
case 值 in
模式1)
    command1
    command2
    command3
    ;;
模式2）
    command1
    command2
    command3
    ;;
*)
    command1
    command2
    command3
    ;;
esac
```

```shell_script
#!/bin/sh

site="runoob"

case "$site" in
   "runoob") echo "菜鸟教程"
   ;;
   "google") echo "Google 搜索"
   ;;
   "taobao") echo "淘宝网"
   ;;
esac
```

# shell函数
```shell_script
- 中括号内是可以省略的
[ function ] funname [()]

{

    action;

    [return int;]

}
```

```shell_script
#!/bin/bash

demoFun(){
    echo "这是我的第一个 shell 函数!"
}
echo "-----函数开始执行-----"
demoFun
echo "-----函数执行完毕-----"
```

下面定义一个带有return语句的函数：
```shell_script
#!/bin/bash

funWithReturn(){
    echo "这个函数会对输入的两个数字进行相加运算..."
    echo "输入第一个数字: "
    read aNum
    echo "输入第二个数字: "
    read anotherNum
    echo "两个数字分别为 $aNum 和 $anotherNum !"
    return $(($aNum+$anotherNum))
}
funWithReturn
echo "输入的两个数字之和为 $? !"
```

### 函数参数
```shell_script
#!/bin/bash

funWithParam(){
    echo "第一个参数为 $1 !"
    echo "第二个参数为 $2 !"
    echo "第十个参数为 $10 !"
    echo "第十个参数为 ${10} !"
    echo "第十一个参数为 ${11} !"
    echo "参数总数有 $# 个!"
    echo "作为一个字符串输出所有参数 $* !"
}
funWithParam 1 2 3 4 5 6 7 8 9 34 73


第一个参数为 1 !
第二个参数为 2 !
第十个参数为 10 !
第十个参数为 34 !
第十一个参数为 73 !
参数总数有 11 个!
作为一个字符串输出所有参数 1 2 3 4 5 6 7 8 9 34 73 !
```
注意，$10 不能获取第十个参数，获取第十个参数需要${10}。当n>=10时，需要使用${n}来获取参数。

另外，还有几个特殊字符用来处理参数：


函数返回值在调用该函数后通过 $? 来获得。

注意：所有函数在使用前必须定义。这意味着必须将函数放在脚本开始部分，直至shell解释器首次发现它时，才可以使用。调用函数仅使用其函数名即可。

注意：$? 仅对其上一条指令负责，一旦函数返回后其返回值没有立即保存入参数，那么其返回值将不再能通过 $? 获得。


### 函数与命令的执行结果可以作为条件语句使用。要注意的是，和 C 语言不同，shell 语言中 0 代表 true，0 以外的值代表 false
```shell_script
#!/bin/bash

echo "Hello World !" | grep -e Hello
echo $?
echo "Hello World !" | grep -e Bye
echo $?
if echo "Hello World !" | grep -e Hello
then
    echo true
else
    echo false
fi

if echo "Hello World !" | grep -e Bye
then
    echo true
else
    echo false
fi

function demoFun1(){
    return 0
}

function demoFun2(){
    return 12
}

if demoFun1
then
    echo true
else
    echo false
fi

if demoFun2
then
    echo ture
else
    echo false
fi
其执行结果如下：

Hello World !
0
1
Hello World !
true
false
true
false
grep 是从给定字符串中寻找匹配内容的命令。首先看出如果找到了匹配的内容，会打印匹配部分且得到的返回值 $? 为 0，如果找不到，则返回值 $? 为 1。

接下来分别将这两次执行的 grep 命令当作条件语句交给 if 判断，得出返回值 $? 为 0，即执行成功时，条件语句为 true，当返回值 $? 为 1，即执行失败时，条件语句为 false。

之后再用函数的 return 值作为测试，其中 demoFun1 返回值为 0，demoFun2 返回值选择了任意一个和 0 不同的整数，这里为 12。

将函数作为条件语句交给 if 判断，得出返回值为 0 时，依然为 true，而返回值只要不是 0，条件语句都判断为 false。
```

# Shell 输入/输出重定向

注意：0 是标准输入（STDIN），1 是标准输出（STDOUT），2 是标准错误输出（STDERR）。

这里的 2 和 > 之间不可以有空格，2> 是一体的时候才表示错误输出。

|  命令   | 说明  |
|  ----   | ----  |
|command > file	    |将输出重定向到 file。|
|command < file	    |将输入重定向到 file。|
|command >> file	|将输出以追加的方式重定向到 file。|
|n > file	        |将文件描述符为 n 的文件重定向到 file。|
|n >> file	        |将文件描述符为 n 的文件以追加的方式重定向到 file。|
|n >& m	            |将输出文件 m 和 n 合并。|
|n <& m	            |将输入文件 m 和 n 合并。|
|<< tag	            |将开始标记 tag 和结束标记 tag 之间的内容作为输入|