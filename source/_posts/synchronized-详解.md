---
title: synchronized()详解
tags:
  - Java
  - synchronized
categories: 好奇尚异
abbrlink: 40821
date: 2020-10-14 11:02:53
updated: 2020-10-14 11:02:53
---

# synchronized(.class)
synchronized（.class）只要是访问这个类的方法，就会同步，不管用这个类创建了几个对象！一般单列模式常用
```java
private static volatile SingIn instance=null;
 private SingIn (){
 
 }
 public static  SingIn getInstance(){
    if(instance==null){
      synchronized(SingIn .class){
      if(instance==null){
        instance=new SingIn ();
       }
      }
     }
    return instance;
  }
```

# synchronized(Object )
synchronized（Object x），通过对象同步，注意必须是同一个对象
```java
@Override
 public void run（）{
     synchronized（Object x）{
         x .setDeviceName（“a”）;
    }
}
```

# synchronized(this)
synchronized（this） 指的是对象本身同步，一般在定义对象的方法时可以用，当只有访问同一对象，才会同步,和synchronized（Object x）功能类似。
```java
public class ObjectService {  
    public void serviceMethodA(){  
        try {  
            synchronized (this) {  
                System.out.println("A begin time="+System.currentTimeMillis());  
                Thread.sleep(2000);  
                System.out.println("A end   time="+System.currentTimeMillis());  
            }  
        } catch (InterruptedException e) {  
            e.printStackTrace();  
        }  
    }  
    public void serviceMethodB(){  
        synchronized (this) {  
            System.out.println("B begin time="+System.currentTimeMillis());  
            System.out.println("B end   time="+System.currentTimeMillis());  
        }  
    }  
} 

```