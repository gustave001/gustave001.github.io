---
title: 有意思的Java单例模式
tags:
  - Java
  - 单例模式
categories: 好奇尚异
abbrlink: e95c6f09
date: 2019-01-25 17:26:18
updated: 2019-01-25 22:19:46
---
# 前言
Java的单例模式号称最简单的设计模式，然后其实并没有那么简单，下面来研究研究单例模式的具体实现

# 饿汉式
```java
public class SingletonB {

    private static final SingletonB INSTANCE = new SingletonB();

    private SingletonB() {
    }

    public static SingletonB getInstance(){
        return INSTANCE;
    }
}

```
 如上所示为饿汉式的单例模式的实现，全局的单例实例在类加载的时候就构建（可以免疫很多多线程的问题），但是该种方式也缺陷明显，浪费资源。
 
 # v1.懒汉式
 ```java
public class SingletonA1 {

    private static SingletonA1 INSTANCE;

    private SingletonA1() {
    }

    public static SingletonA1 getInstance(){
        if (INSTANCE == null) {
            INSTANCE = new SingletonA1();
        }
        return INSTANCE;
    }
}
```
如上为简单版懒汉模式，相比饿汉式，在需要的时候才构建实例，然而多线程的场景下，  
如果有多个线程同时判断了INSTANCE为null，则系统中会出现多个实例

# v2.synchronized版本
```java
public class SingletonA2 {

    private static SingletonA2 INSTANCE;

    private SingletonA2() {
    }

    public static synchronized SingletonA2 getInstance(){
        if (INSTANCE == null) {
            INSTANCE = new SingletonA2();
        }
        return INSTANCE;
    }
}
```
既然如此，将获取实例的方法加锁即可，确实可以避免v1版的问题，但是一旦方法加锁之后同步了，  
所有其他线程都被阻塞，为了1%可能导致的多线程问题，而造成了效率上的大大降低，其实是得不偿失的

# v3.Double-Check版本
```java
public class SingletonA3 {

    private static SingletonA3 INSTANCE;

    private SingletonA3() {
    }

    public static SingletonA3 getInstance() {
        if (INSTANCE == null) {
            synchronized (SingletonA3.class) {
                if (INSTANCE == null) {
                    INSTANCE = new SingletonA3();
                }
            }
        }
        return INSTANCE;
    }
}
```
双检法，当实例为null的时候，才加锁，相对于v2版本，只针对那1%的时候，进行同步处理  
到了这里，基本就是完美的了，然而事情并没有这么简单！！！
`INSTANCE = new SingletonA3();`该语句并非是原子性的（不可分割）  
细分之后为1.INSTANCE分配内存2.SingletonA3调用构造器在堆中构建实例3.将INSTANCE指向堆中的实例  
而Java有指令重排的机制，并非一定是123的顺序，如果是132的顺序时，刚执行完13，此时恰好，有另外的线程在进行  
第一个`if (INSTANCE == null)`的判断，此时判断INSTANCE是非null的，则会直接返回，然而实际上它并没有正确指向堆，  
所以理所应该地就报错了。如下则为指令重排详解
## 指令重排
简单来说，就是计算机为了提高执行效率，会做的一些优化，在不影响最终结果的情况下，可能会对一些语句的执行顺序进行调整。
比如，这一段代码：
```java
int a ;   // 语句1 

a = 8 ;   // 语句2

int b = 9 ;     // 语句3

int c = a + b ; // 语句4
```
正常来说，对于顺序结构，执行的顺序是自上到下，也即1234。
但是，由于指令重排的原因，因为不影响最终的结果，所以，实际执行的顺序可能会变成3124或者1324。
由于语句3和4没有原子性的问题，语句3和语句4也可能会拆分成原子操作，再重排。
——也就是说，对于非原子性的操作，在不影响最终结果的情况下，其拆分成的原子操作可能会被重新排列执行顺序。
OK，了解了原子操作和指令重排的概念之后，我们再继续看Version3代码的问题。
下面这段话直接从陈皓的文章(深入浅出单实例SINGLETON设计模式)中复制而来：
主要在于singleton = new Singleton()这句，这并非是一个原子操作，事实上在 JVM 中这句话大概做了下面 3 件事情。
1. 给 singleton 分配内存
2. 调用 Singleton 的构造函数来初始化成员变量，形成实例
3. 将singleton对象指向分配的内存空间（执行完这步 singleton才是非 null 了）
但是在 JVM 的即时编译器中存在指令重排序的优化。也就是说上面的第二步和第三步的顺序是不能保证的，最终的执行顺序可能是 1-2-3 也可能是 1-3-2。如果是后者，则在 3 执行完毕、2 未执行之前，被线程二抢占了，这时 instance 已经是非 null 了（但却没有初始化），所以线程二会直接返回 instance，然后使用，然后顺理成章地报错。
再稍微解释一下，就是说，由于有一个『instance已经不为null但是仍没有完成初始化』的中间状态，而这个时候，如果有其他线程刚好运行到第一层if (instance == null)这里，这里读取到的instance已经不为null了，所以就直接把这个中间状态的instance拿去用了，就会产生问题。
这里的关键在于——线程T1对instance的写操作没有完成，线程T2就执行了读操作。

# v4.volatile关键字完美版
```java
public class SingletonA4 {

    private static volatile SingletonA4 INSTANCE;

    private SingletonA4() {
    }

    public static SingletonA4 getInstance() {
        if (INSTANCE == null) {
            synchronized (SingletonA4.class) {
                if (INSTANCE == null) {
                    INSTANCE = new SingletonA4();
                }
            }
        }
        return INSTANCE;
    }
}
```
volatile关键字的作用在于，在写之前即`INSTANCE = new SingletonA4();`操作之前，不会进行读操作，即`if (INSTANCE == null)`操作  
这是双检法的终极版本，要说缺点的话，就是写法太复杂了

# 静态内部类法
```java
public class SingletonC {

    private SingletonC() {
    }

    static class SingetonHolder {
        private static SingetonHolder INSTANCE = new SingetonHolder();

        public static SingetonHolder getInstance() {
            return INSTANCE;
        }
    }

}
```
内部类的方法，该种方式，获取实例的方式是饿汉式的，然后由于它属于内部类，并不会在外层SingletonC类加载的时候进行构建  
所以是非常巧妙的实现

# 枚举法
下面是使用enum的实现方式
```java
public enum SingletonD {
    INSTANCE;

    public void dosth(){
        System.out.println("枚举法的实现方式");
    }
}

public class SingletonTest {

    @Test
    public void testSingleton(){
        SingletonD.INSTANCE.dosth();
    }
}
```
枚举法简洁直观，要说缺点的话，因为它不是class所以无法继承