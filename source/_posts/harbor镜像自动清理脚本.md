---
title: harbor镜像自动清理脚本
tags: [linux,harbor,shell]
date: 2020-11-04 17:30:12
updated: 2020-11-04 17:30:12
categories: 好奇尚异
---

# 前言
harbor镜像没有自动清理过期镜像的设置，所以通过api利用shell脚本实现，比较坑的是v2.0版本和1.9版本变得翻天覆地，浪费老子很多时间。


# 清理主脚本 v1.9.4 版本

```shell_script
#!/bin/bash

# 通过api查找到所有对应的镜像地址，这里有个"tags_count"就是镜像的tag数，通过tag数判断>5筛选出对应的镜像"repository_name"，刚开始一直在想通过管道连接的方式一条语句判断出来，结果确实没有想到好的方法判断出来，退而求其次选择了现在的方法，将获取到的值保存到文件中，根据自己的需要构造一个新的文件。

harbor_user=
harbor_passwd=
harbor_url=
HARBOR_PATH=
repo=dev

echo "$(date +'%F %H:%M:%S') clear start"

#获取所有tags_count
COUNT=$(curl -s -k -X GET "http://${harbor_user}:${harbor_passwd}@${harbor_url}/api/search?q=${repo}" |grep "\"tags_count\""|awk -F "\"" '{print $3$4}' | awk -F "" '{print $3$4}')

#获取所有repository_name
REPS=$(curl -s -k -X GET "http://${harbor_user}:${harbor_passwd}@${harbor_url}/api/search?q=${repo}" |grep "\"repository_name\""|awk -F "\"" '{print $4}')

# 接下来就是根据需求造文件，我这里想要的格式是 tags_count ,repository_name在同一行一一对应关联起来。

#touch test_count.txt
#touch test_server.txt

for i in $COUNT
do
echo $i >> test_count.txt
done
for y in $REPS
do
echo $y >> test_server.txt
done

#合并俩个文件拼接出新的文件，新的文件count_and_server.txt里面存放的就是我们造好的数据。
paste test_count.txt test_server.txt > count_and_server.txt

#删除不需要的文件
rm -rf test_count.txt
rm -rf test_server.txt
rm -rf server.txt

#循环读取每一行并判断，这里根据tab切割第一个值是tags_count，第二个值对应repository_name，判断大于5将服务读取到server.txt，这样server.txt里面就是我们所有需要清除的镜像
FILENAME=count_and_server.txt 
cat $FILENAME | while read LINE
do
        new_str=$(echo $LINE | cut -d " " -f1)
        new_str1=$(echo $LINE | cut -d " " -f2)
        if [ $new_str -gt 5 ]
        then
                echo $new_str1 >> server.txt
        fi
done


sed -i 's@\/@%2F@g' server.txt

SERVER_NAME=server.txt
cat $SERVER_NAME | while read LINE
do              

 # 继续造文件，造一个时间和tag名称对应的文件，这里文件是偶数行是created时间。奇数行是tag名称
name_date=$(curl -s -k -X GET "http://${harbor_user}:${harbor_passwd}@${harbor_url}/api/repositories/${LINE}/tags" |egrep "\"created|name\""|awk -F "\"" '{print $4}')

        for date in $name_date
        do
                echo $date >> date.txt
        done
        
        # 交换奇偶行
        awk 'getline i{print i}1' date.txt > tmp.txt

        echo "++++++++++++++++++++++++++++++++++"

        #合并两行，将时间和tag名称放到一行一一对应
        
        awk '{if(NR%2!=0)ORS=" ";else ORS="\n"}1' tmp.txt >> new_date.txt
        
        # 按照时间倒序进行排序
        sort -r new_date.txt > new1_date.txt
        rm -rf new_date.txt
        rm -rf date.txt
        rm -rf tmp.txt
        
        NEW_DEL=new1_date.txt
        del_tag=$(cat new1_date.txt | tail -n +6 | awk -F' ' '{print $2}')
        
        # 可以查看到所有满足删除需求的
        echo $del_tag   
        echo "==========================================="

        #根据tag执行软删除
        
        #根据tag执行软删除
        for single_del_tag in $del_tag
        do 
              curl -s -k -X DELETE "http://${harbor_user}:${harbor_passwd}@${harbor_url}/api/repositories/${LINE}/tags/${single_del_tag}"    
        done
   
done

docker-compose -f $HARBOR_PATH/docker-compose.yml stop
docker run -it --name gc --rm --volumes-from registry vmware/registry:2.6.2-photon garbage-collect --dry-run /etc/registry/config.yml >/dev/null

#最后启动harbor
docker-compose -f $HARBOR_PATH/docker-compose.yml start

echo "$(date +'%F %H:%M:%S') clear finish"

```


# 清理主脚本 v2.0 版本

```shell_script
#!/bin/bash

# 通过api查找到所有对应的镜像地址，这里有个"tags_count"就是镜像的tag数，通过tag数判断>5筛选出对应的镜像"repository_name"，刚开始一直在想通过管道连接的方式一条语句判断出来，结果确实没有想到好的方法判断出来，退而求其次选择了现在的方法，将获取到的值保存到文件中，根据自己的需要构造一个新的文件。

harbor_user=
harbor_passwd=
harbor_url=
HARBOR_PATH=
repo=pro
version=v2.0

echo "$(date +'%F %H:%M:%S') clear start"

#获取所有artifact_count
COUNT=$(curl -s -k -u "${harbor_user}:${harbor_passwd}" -X GET "http://${harbor_url}/api/${version}/search?q=${repo}" |jq|grep "\"artifact_count\""|awk -F "\"" '{print $3$4}' | awk -F "," '{print $1}'|awk -F "" '{print $3$4}')

#获取所有repository_name
REPS=$(curl -s -k -u "${harbor_user}:${harbor_passwd}" -X GET "http://${harbor_url}/api/${version}/search?q=${repo}" |grep "\"repository_name\""|awk -F "\"" '{print $4}')

# 接下来就是根据需求造文件，我这里想要的格式是 artifact_count ,repository_name在同一行一一对应关联起来。

#touch test_count.txt
#touch test_server.txt

for i in $COUNT
do
echo $i >> test_count.txt
done
for y in $REPS
do
echo $y >> test_server.txt
done

#合并俩个文件拼接出新的文件，新的文件count_and_server.txt里面存放的就是我们造好的数据。
paste test_count.txt test_server.txt > count_and_server.txt

#删除不需要的文件
rm -rf test_count.txt
rm -rf test_server.txt
rm -rf server.txt

#循环读取每一行并判断，这里根据tab切割第一个值是tags_count，第二个值对应repository_name，判断大于5将服务读取到server.txt，这样server.txt里面就是我们所有需要清除的镜像
FILENAME=count_and_server.txt 
cat $FILENAME | while read LINE
do
        new_str=$(echo $LINE | cut -d " " -f1)
        new_str1=$(echo $LINE | cut -d " " -f2)
        if [ $new_str -gt 20 ]
        then
                echo $new_str1 >> server.txt
        fi
done


# sed -i 's@\/@%2F@g' server.txt

SERVER_NAME=server.txt
cat $SERVER_NAME | while read LINE
do              

        echo $LINE
        PROJECT=$(echo $LINE | awk -F "/" '{print $1}')
        REPOSITORY=$(echo $LINE | awk -F "/" '{print $2}')
         # 继续造文件，造一个时间和tag名称对应的文件，这里文件是偶数行是created时间。奇数行是tag名称
        name_date=$(curl -s -k -u "${harbor_user}:${harbor_passwd}" -X GET "http://${harbor_url}/api/${version}/projects/${PROJECT}/repositories/${REPOSITORY}/artifacts?page=1&page_size=20"|jq |egrep "\"created|name\""|grep -v latest|awk -F "\"" '{print $4}')

        for date in $name_date
        do
                echo $date >> date.txt
        done
        
        # 交换奇偶行
        #awk 'getline i{print i}1' date.txt > tmp.txt

        echo "++++++++++++++++++++++++++++++++++"

        #合并两行，将时间和tag名称放到一行一一对应
        
        awk '{if(NR%2!=0)ORS=" ";else ORS="\n"}1' date.txt >> new_date.txt
        
        # 按照时间倒序进行排序
        sort -r new_date.txt > new1_date.txt
        rm -rf new_date.txt
        rm -rf date.txt
        rm -rf tmp.txt
        
        NEW_DEL=new1_date.txt
        # 镜像保留最近的20个
        del_tag=$(cat new1_date.txt | tail -n +21 | awk -F' ' '{print $2}')
        
        # 可以查看到所有满足删除需求的
        echo $del_tag   
        echo "==========================================="

        #根据tag执行软删除
        for single_del_tag in $del_tag
        do 
              curl -s -k -u "${harbor_user}:${harbor_passwd}" -X DELETE "http://${harbor_url}/api/${version}/projects/${PROJECT}/repositories/${REPOSITORY}/artifacts/${single_del_tag}"    
        done    
done

docker-compose -f $HARBOR_PATH/docker-compose.yml stop
docker run -it --name gc --rm --volumes-from registry vmware/registry:2.6.2-photon garbage-collect --dry-run /etc/registry/config.yml >/dev/null

#最后启动harbor
docker-compose -f $HARBOR_PATH/docker-compose.yml start

echo "$(date +'%F %H:%M:%S') clear finish"

```


# 交换奇偶行
- `sed -n 'h;$!{n;G};p' file`
1. [解析]

    把第一行内容交换进缓冲区，然后n进入下一行，G把缓冲区内容追加到该行的模式空间内，然后打印。整好就是把第1行，换到第2行后，第3行换到第4行后以此类推。最后一行不操作，直接输出，目的是最后一行如果是奇数行时也会输出。


- `awk 'i=NR%2{x=$0;next}{print $0 RS x}END{if(i)print x}' file`
2. [解析]

    NR对2取余，那么是偶数行的时候条件为假不会执行后面的赋值，则默认执行后面的打印，如果最后是奇数行,那么i的值是1，则最后END会打印出该行。


- `awk 'getline i{print i}1' file`
3. [解析]

    Tim大师的思路，真是佩服到不行啊，把getline作为pattern，如果是最后一行是奇数行，没有下读取的话，是不会执行后面的print的，完美解决了奇数行最后一行打印的问题，第一行，读取下一行给i，然后打印i的值（即下一行的内容），然后patter为1执行默认的{print}，这样刚好把两行互换，而且还具备了最后一行是奇数行的判断，佩服。
    
# 安装jq
安装EPEL源：
- `yum install epel-release`

安装完EPEL源后，可以查看下jq包是否存在：
- `yum list jq`

安装jq：
- `yum install jq`