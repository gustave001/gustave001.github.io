---
title: Java代码优化
tags: [Java,代码优化]
date: 2019-02-14 22:51:26
updated: 2019-02-15 00:58:14
categories: Java
---

# 尽量指定类、方法的final修饰符
带有final修饰符的类是不可派生的。在Java核心API中，有许多应用final的例子，例如java.lang.String，整个类都是final的。为类指定final修饰符可以让类不可以被继承，为方法指定final修饰符可以让方法不可以被重写。如果指定了一个类为final，则该类所有的方法都是final的。Java编译器会寻找机会内联所有的final方法，内联对于提升Java运行效率作用重大，具体参见Java运行期优化。此举能够使性能平均提高50%。

# 尽可能使用局部变量
调用方法时传递的参数以及在调用中创建的临时变量都保存在栈中，速度较快，其他变量，如静态变量、实例变量等，都在堆中创建，速度较慢。另外，栈中创建的变量，随着方法的运行结束，这些内容就没了，不需要额外的垃圾回收。

# 及时关闭流
Java编程过程中，进行数据库连接、I/O流操作时务必小心，在使用完毕后，及时关闭以释放资源。因为对这些大对象的操作会造成系统大的开销，稍有不慎，将会导致严重的后果。

# 尽量减少变量的重复计算
明确一个概念，对方法的调用，即使方法中只有一句语句，也是有消耗的，包括创建栈帧、调用方法时保护现场、调用方法完毕时恢复现场等。所以例如下面的操作：
```java
for(int i;i < list.size();i++)
    {...}
修改为:
for(int i,length = list.size;i<length;i++)
    {...}
```
这种写法，在list的size很大的时候，可以减少开销

# 尽量使用懒加载，即在需要的时候创建

# 慎用异常
1. 只在必要使用异常的地方才使用异常，不要用异常去控制程序的流程
谨慎地使用异常，异常捕获的代价非常高昂，异常使用过多会严重影响程序的性能。如果在程序中能够用if语句和Boolean变量来进行逻辑判断，那么尽量减少异常的使用，从而避免不必要的异常捕获和处理。比如下面这段经典的程序：
```java
  public void useExceptionsForFlowControl() {  
    try {  
    while (true) {  
      increaseCount();  
      }  
    } catch (MaximumCountReachedException ex) {  
    }  
    //Continue execution  
  }  
      
  public void increaseCount() throws MaximumCountReachedException {  
    if (count >= 5000)  
      throw new MaximumCountReachedException();  
  }
```
上边的useExceptionsForFlowControl()用一个无限循环来增加count直到抛出异常，这种做法并没有说让代码不易读，而是使得程序执行效率降低。
2. 切忌使用空catch块
在捕获了异常之后什么都不做，相当于忽略了这个异常。千万不要使用空的catch块，空的catch块意味着你在程序中隐藏了错误和异常，并且很可能导致程序出现不可控的执行结果。如果你非常肯定捕获到的异常不会以任何方式对程序造成影响，最好用Log日志将该异常进行记录，以便日后方便更新和维护。
3. 检查异常和非检查异常的选择
一旦你决定抛出异常，你就要决定抛出什么异常。这里面的主要问题就是抛出检查异常还是非检查异常。
检查异常导致了太多的try…catch代码，可能有很多检查异常对开发人员来说是无法合理地进行处理的，比如SQLException，而开发人员却不得不去进行try…catch，这样就会导致经常出现这样一种情况：逻辑代码只有很少的几行，而进行异常捕获和处理的代码却有很多行。这样不仅导致逻辑代码阅读起来晦涩难懂，而且降低了程序的性能。
我个人建议尽量避免检查异常的使用，如果确实该异常情况的出现很普遍，需要提醒调用者注意处理的话，就使用检查异常；否则使用非检查异常。
因此，在一般情况下，我觉得尽量将检查异常转变为非检查异常交给上层处理。
4. 注意catch块的顺序
不要把上层类的异常放在最前面的catch块。比如下面这段代码：
```java
try {
        FileInputStream inputStream = new FileInputStream("d:/a.txt");
        int ch = inputStream.read();
        System.out.println("aaa");
        return "step1";
    } catch (IOException e) {
　　      System.out.println("io exception");　　      
         return "step2";
    }catch (FileNotFoundException e) {
        System.out.println("file not found");　　　　      
        return "step3";
    }finally{
        System.out.println("finally block");
        //return "finally";
    }
```
第二个catch的FileNotFoundException将永远不会被捕获到，因为FileNotFoundException是IOException的子类。
5. 不要将提供给用户看的信息放在异常信息里
比如下面这段代码：
```java
public class Main {
    public static void main(String[] args) {
        try {
            String user = null;
            String pwd = null;
            login(user,pwd);
        } catch (Exception e) {
            System.out.println(e.getMessage());
        }
         
    }
     
    public static void login(String user,String pwd) {
        if(user==null||pwd==null)
            throw new NullPointerException("用户名或者密码为空");
        //...
    }
}
```
展示给用户错误提示信息最好不要跟程序混淆一起，比较好的方式是将所有错误提示信息放在一个配置文件中统一管理。
6. 避免多次在日志信息中记录同一个异常
只在异常最开始发生的地方进行日志信息记录。很多情况下异常都是层层向上跑出的，如果在每次向上抛出的时候，都Log到日志系统中，则会导致无从查找异常发生的根源。
7. 异常处理尽量放在高层进行
尽量将异常统一抛给上层调用者，由上层调用者统一之时如何进行处理。如果在每个出现异常的地方都直接进行处理，会导致程序异常处理流程混乱，不利于后期维护和异常错误排查。由上层统一进行处理会使得整个程序的流程清晰易懂。
8. 在finally中释放资源
如果有使用文件读取、网络操作以及数据库操作等，记得在finally中释放资源。这样不仅会使得程序占用更少的资源，也会避免不必要的由于资源未释放而发生的异常情况。

# 当复制大量数据时，使用`System.arraycopy()`命令

# 乘法和除法使用移位操作
```java
for(int i = 0;i < 100;i ++){
    a = i * 8;
    b = i / 16;
}
for(int i -= 0;i < 100; i ++){
    a = i << 3;
    b = i >> 4;
}
```
移位操作会降低可读性，所以最好带上注释

# 循环内不要不断创建对象引用

# 尽量在合适的场合使用单例
使用单例可以减轻加载的负担、缩短加载的时间、提高加载的效率，但并不是所有地方都适用于单例，简单来说，单例主要适用于以下三个方面：
- 控制资源的使用，通过线程同步来控制资源的并发访问
- 控制实例的产生，以达到节约资源的目的
- 控制数据的共享，在不建立直接关联的条件下，让多个不相关的进程或线程之间实现通信

# ArrayList等实现了RandomAccess接口的集合，应当使用普通for循环而不是foreach循环
这是JDK推荐给用户的。JDK API对于RandomAccess接口的解释是：实现RandomAccess接口用来表明其支持快速随机访问，此接口的主要目的是允许一般的算法更改其行为，从而将其应用到随机或连续访问列表时能提供良好的性能。实际经验表明，实现RandomAccess接口的类实例，假如是随机访问的，使用普通for循环效率将高于使用foreach循环；反过来，如果是顺序访问的，则使用Iterator会效率更高。可以使用类似如下的代码作判断：
```java
if (list instanceof RandomAccess)
{
    for (int i = 0; i < list.size(); i++){}
}
else
{
    Iterator<?> iterator = list.iterable();
    while (iterator.hasNext()){iterator.next()}
}
```
自己的测试
```java
    @Test
    public void testRandomAccess(){
        List<Integer> list = new ArrayList<>();
        for (int i = 0; i < 1000000 ; i++) {
            list.add(i);
        }
        Object obj = null;
        long l = System.currentTimeMillis();
        for (int i = 0; i < list.size(); i++) {
            obj = list.get(i);
        }
        long l1 = System.currentTimeMillis();
        System.out.println(l1-l);
        for (Integer x : list) {
            obj = x;
        }
        System.out.println(System.currentTimeMillis() - l1);
    }
```
![结果](../images/快速随机访问for循环.jpg)

# 使用同步代码块代替同步方法
这点在多线程模块中的synchronized锁方法块一文中已经讲得很清楚了，除非能确定一整个方法都是需要进行同步的，否则尽量使用同步代码块，避免对那些不需要进行同步的代码也进行了同步，影响了代码执行效率。

# 程序运行过程避免使用反射
关于，请参见反射。反射是Java提供给用户一个很强大的功能，功能强大往往意味着效率不高。不建议在程序运行过程中使用尤其是频繁使用反射机制，特别是Method的invoke方法，如果确实有必要，一种建议性的做法是将那些需要通过反射加载的类在项目启动的时候通过反射实例化出一个对象并放入内存----用户只关心和对端交互的时候获取最快的响应速度，并不关心对端的项目启动花多久时间。

# 使用带缓冲的输入输出流进行IO操作
带缓冲的输入输出流，即BufferedReader、BufferedWriter、BufferedInputStream、BufferedOutputStream，这可以极大地提升IO效率

# 公用的集合类中不使用的数据一定要及时remove掉
如果一个集合类是公用的（也就是说不是方法里面的属性），那么这个集合里面的元素是不会自动释放的，因为始终有引用指向它们。所以，如果公用集合里面的某些数据不使用而不去remove掉它们，那么将会造成这个公用集合不断增大，使得系统有内存泄露的隐患。

# 把一个基本数据类型转为字符串，基本数据类型.toString()是最快的方式、String.valueOf(数据)次之、数据+""最慢
```java
public static void main(String[] args)
{
    int loopTime = 50000;
    Integer i = 0;
    long startTime = System.currentTimeMillis();
    for (int j = 0; j < loopTime; j++)
    {
        String str = String.valueOf(i);
    }    
    System.out.println("String.valueOf()：" + (System.currentTimeMillis() - startTime) + "ms");
    startTime = System.currentTimeMillis();
    for (int j = 0; j < loopTime; j++)
    {
        String str = i.toString();
    }    
    System.out.println("Integer.toString()：" + (System.currentTimeMillis() - startTime) + "ms");
    startTime = System.currentTimeMillis();
    for (int j = 0; j < loopTime; j++)
    {
        String str = i + "";
    }    
    System.out.println("i + \"\"：" + (System.currentTimeMillis() - startTime) + "ms");
}
```
结果
```java
String.valueOf()：11ms
Integer.toString()：5ms
i + ""：25ms
```
所以以后遇到把一个基本数据类型转为String的时候，优先考虑使用toString()方法。至于为什么，很简单：
- String.valueOf()方法底层调用了Integer.toString()方法，但是会在调用前做空判断
- Integer.toString()方法就不说了，直接调用了
- i + ""底层使用了StringBuilder实现，先用append方法拼接，再用toString()方法获取字符串
三者对比下来，明显是2最快、1次之、3最慢

# 对资源的close()建议分开操作
```java
try
{
    XXX.close();
    YYY.close();
}
catch (Exception e)
{
    ...
}
```
改为
```java
try
{
    XXX.close();
}
catch (Exception e)
{
    ...
}
try
{
    YYY.close();
}
catch (Exception e)
{
    ...
}
```
虽然有些麻烦，却能避免资源泄露。我们想，如果没有修改过的代码，万一XXX.close()抛异常了，那么就进入了catch块中了，YYY.close()不会执行，YYY这块资源就不会回收了，一直占用着，这样的代码一多，是可能引起资源句柄泄露的。而改为下面的写法之后，就保证了无论如何XXX和YYY都会被close掉

# 切记以常量定义的方式替代魔鬼数字，魔鬼数字的存在将极大地降低代码可读性，字符串常量是否使用常量定义可以视情况而定

# 推荐使用JDK7中新引入的Objects工具类来进行对象的equals比较，直接a.equals(b)，有空指针异常的风险

# 对于ThreadLocal使用前或者使用后一定要先remove
当前基本所有的项目都使用了线程池技术，这非常好，可以动态配置线程数、可以重用线程。
然而，如果你在项目中使用到了ThreadLocal，一定要记得使用前或者使用后remove一下。这是因为上面提到了线程池技术做的是一个线程重用，这意味着代码运行过程中，一条线程使用完毕，并不会被销毁而是等待下一次的使用。我们看一下Thread类中，持有ThreadLocal.ThreadLocalMap的引用：
```java
/* ThreadLocal values pertaining to this thread. This map is maintained
 * by the ThreadLocal class. */
ThreadLocal.ThreadLocalMap threadLocals = null;
```
线程不销毁意味着上条线程set的ThreadLocal.ThreadLocalMap中的数据依然存在，那么在下一条线程重用这个Thread的时候，很可能get到的是上条线程set的数据而不是自己想要的内容。
这个问题非常隐晦，一旦出现这个原因导致的错误，没有相关经验或者没有扎实的基础非常难发现这个问题，因此在写代码的时候就要注意这一点，这将给你后续减少很多的工作量。

# 不捕获Java类库中定义的继承自RuntimeException的运行时异常类
- ArithmeticException可以通过判断除数是否为空来规避
- NullPointerException可以通过判断对象是否为空来规避
- IndexOutOfBoundsException可以通过判断数组/字符串长度来规避
- ClassCastException可以通过instanceof关键字来规避
- ConcurrentModificationException可以使用迭代器来规避

# 避免Random实例被多线程使用，虽然共享该实例是线程安全的，但会因竞争同一seed 导致的性能下降，JDK7之后，可以使用ThreadLocalRandom来获取随机数
解释一下竞争同一个seed导致性能下降的原因，比如，看一下Random类的nextInt()方法实现：
```java
public int nextInt() {
    return next(32);
}
```
调用了next(int bits)方法，这是一个受保护的方法：

复制代码
```java
protected int next(int bits) {
    long oldseed, nextseed;
    AtomicLong seed = this.seed;
    do {
        oldseed = seed.get();
        nextseed = (oldseed * multiplier + addend) & mask;
    } while (!seed.compareAndSet(oldseed, nextseed));
    return (int)(nextseed >>> (48 - bits));
}
```
复制代码
而这边的seed是一个全局变量：
```java
/**
 * The internal state associated with this pseudorandom number generator.
 * (The specs for the methods in this class describe the ongoing
 * computation of this value.)
 */
private final AtomicLong seed;
```
多个线程同时获取随机数的时候，会竞争同一个seed，导致了效率的降低。

转自：[五月的仓颉](http://www.cnblogs.com/xrq730/p/4865416.html)

- 谨此祭奠过去N多年来逃避现实的自己
- 永远对这个世界保持好奇心！
- 痛苦时分析其产生的根源，去改正能改正的己过，以技术角度为突破口走出来，切莫陷入痛苦的漩涡无法自拔
- 番茄使人充实，也是驱使你前进的本源！