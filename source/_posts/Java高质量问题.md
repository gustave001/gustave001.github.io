---
title: Java高质量问题
tags: [Java,题目]
date: 2019-01-29 00:35:16
updated: 2019-02-05 00:54:49
categories: 好奇尚异
---

- 千万不能沉溺于回报周期短的、微小的正反馈不能自拔，而要找到让你一路走下去的真正动力。得失心不要太重，目光不要太短，人生百年，说短也短，说长，其实也挺长的。
# MySQL中 like`%%`和`find_in_set`的区别
`find_in_set`对于查找以英文逗号分隔的字段，更加具有精确性

# Java类初始化顺序
基类静态代码块，基类静态成员字段（并列优先级，按照代码中出现的先后顺序执行，且只有第一次加载时执行）——>派生类静态代码块，派生类静态成员字段（并列优先级，按照代码中出现的先后顺序执行，且只有第一次加载时执行）——>基类普通代码块，基类普通成员字段（并列优点级，按代码中出现先后顺序执行）——>基类构造函数——>派生类普通代码块，派生类普通成员字段（并列优点级，按代码中出现先后顺序执行）——>派生类构造函数

# 一个java文件有3个类，编译后有几个class文件
文件中有几个类编译后就有几个class文件。

# 局部变量为何必须要显式地赋值才可以使用
成员变量是可以不经初始化的，在类加载过程的准备阶段即可给它赋予默认值，但局部变量使用前需要显式赋予初始值，javac不是推断不出不可以这样做，而是没有这样做，对于成员变量而言，其赋值和取值访问的先后顺序具有不确定性，对于成员变量可以在一个方法调用前赋值，也可以在方法调用后进行，这是运行时发生的，编译器确定不了，交给jvm去做比较合适。而对于局部变量而言，其赋值和取值访问顺序是确定的。

# 写一个死锁
```java
public class DeadLock {
    public static void main(String[] args) {
        List<Integer> list1 = Arrays.asList(1, 2, 3);
        List<Integer> list2 = Arrays.asList(4, 5, 6);
        new Thread(()-> {
            synchronized (list1){
                for (Integer o : list1) {
                    System.out.println(o);
                }
                try {
                    Thread.sleep(1000);
                } catch (InterruptedException e) {
                    e.printStackTrace();
                }
                synchronized (list2) {
                    for (Integer o : list2) {
                        System.out.println(o);
                    }
                }
            }
        }).start();
        new Thread(()-> {
            synchronized (list2){
                for (Integer o : list2) {
                    System.out.println(o);
                }
                try {
                    Thread.sleep(1000);
                } catch (InterruptedException e) {
                    e.printStackTrace();
                }
                synchronized (list1) {
                    for (Integer o : list1) {
                        System.out.println(o);
                    }
                }
            }
        }).start();
    }
}

```