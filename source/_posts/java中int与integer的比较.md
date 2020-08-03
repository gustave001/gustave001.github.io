---
title: java中int与integer的比较
tags: [java,Integer,int]
date: 2020-08-03 11:42:54
updated: 2020-08-03 11:42:54
categories: 温故知新
---
# 前言：

    越是简单的东西，我们往往越是没有去把它明白，但我们大部分时间又常常在用，就像我们今天说的int与Integer的使用，我们程序员基本天天都在用，但是我今天没用详细弄清楚之前我也是不清楚，我们来看看这两个在用==号比较给我们带来的疑问。
    先看看下面的代码，看看我们是否都会
```java
        @Test
	public void testEquals() {
		int int1 = 12;
		int int2 = 12;
		
		Integer integer1 = new Integer(12);
		Integer integer2 = new Integer(12);
		Integer integer3 = new Integer(127);
		
		Integer a1 = 127;
		Integer a2 = 127;
		
		Integer a = 128;
		Integer b = 128;
			
		System.out.println("int1 == int2 -> " + (int1 == int2));					
		System.out.println("int1 == integer1 -> " + (int1 == integer1));			
		System.out.println("integer1 == integer2 -> " + (integer1 == integer2));	
		System.out.println("integer3 == a1 -> " + (integer3 == a1));				
		System.out.println("a1 == a2 -> " + (a1 == a2));							
		System.out.println("a == b -> " + (a == b));													
	}   
```

答案是：
1、   int1 == int2 -> true
2、   int1 == integer1 -> true
3、   integer1 == integer2 -> false
4、   integer3 == a1 -> false
5、   a1 == a2 -> true
6、   a == b -> false
看看结果跟我们自己做的是不是都一样。

根据以上总结：

-        ①、无论如何，Integer与new Integer不会相等。不会经历拆箱过程，因为它们存放内存的位置不一样。（要看具体位置，可以看看这篇文章：点击打开链接）

-        ②、两个都是非new出来的Integer，如果数在-128到127之间，则是true,否则为false。
这是因为java的自动装箱和拆箱的机制
```java
		Integer a1 = 127; 
```
这个语句实际上执行的是Integer a1 = Integer.valueOf(127);
如下是valueOf的方法
```java
    public static Integer valueOf(int i) {
        if (i >= IntegerCache.low && i <= IntegerCache.high)
            return IntegerCache.cache[i + (-IntegerCache.low)];
        return new Integer(i);
    }
```
如下是IntegerCache的源码
```java
private static class IntegerCache {
        static final int low = -128;
        static final int high;
        static final Integer cache[];

        static {
            // high value may be configured by property
            int h = 127;
            String integerCacheHighPropValue =
                sun.misc.VM.getSavedProperty("java.lang.Integer.IntegerCache.high");
            if (integerCacheHighPropValue != null) {
                try {
                    int i = parseInt(integerCacheHighPropValue);
                    i = Math.max(i, 127);
                    // Maximum array size is Integer.MAX_VALUE
                    h = Math.min(i, Integer.MAX_VALUE - (-low) -1);
                } catch( NumberFormatException nfe) {
                    // If the property cannot be parsed into an int, ignore it.
                }
            }
            high = h;

            cache = new Integer[(high - low) + 1];
            int j = low;
            for(int k = 0; k < cache.length; k++)
                cache[k] = new Integer(j++);

            // range [-128, 127] must be interned (JLS7 5.1.7)
            assert IntegerCache.high >= 127;
        }

        private IntegerCache() {}
    }
```


-        ③、两个都是new出来的,则为false。

-        ④、int和integer(new或非new)比较，都为true，因为会把Integer自动拆箱为int，其实就是相当于两个int类型比较。