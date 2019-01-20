---
title: 'bitmap,有点意思'
tags: [bitmap]
date: 2019-01-20 13:17:00
updated: 2019-01-20 13:17:00
categories: 好奇尚异
---

# 位移操作的基本概念与逻辑运算
```java
a = 0010(0x02)
a >>= 1; (a 右移1位并把右移的结果重新赋值给a) 此时a = 0001(0x01);
a <<= 1；（a左移1位并把左移的结果重新赋值给a） 此时 a = 0100(0x04);
a &= 0x01;（ a与0x01 按位与，并把按位与的结果重新赋值给a）。此时a = 0x0;
a |= 0x01;（ a与0x01 按位或，并把按位或的结果重新赋值给a）。此时a = 0011(0x03);
a ^= 0x01;（ a与0x01 按位异或，并把按位异或的结果重新赋值给a）。此时a = 0x03;(异或的意思就是，该位均为相同的则该位结果为0，该位均为不同的则该位结果为1)
```

# 扩展的bitmap,最高通缉次数为15次
```java
package com.gustave.practice.hobby.interest;

public class BitMap {
    public static final int PER_WORDS = 5;
    public int[] words;
    // 每个数字最高出现16次，既需要4bit来表示
    public static final int FINAL_PER_WORDS = 3;

    public BitMap(int size) {
        words = new int[((size - 1) >> FINAL_PER_WORDS) + 1];
    }

    public void set(int wordIndex) {
        int num = this.get(wordIndex);
        if (num < 15) {
            int count = (wordIndex - 1) % (1 << FINAL_PER_WORDS);
            words[wordIndex >> FINAL_PER_WORDS] += (1 << count * 4);
        }
    }

    public int get(int wordIndex) {
        int count = (wordIndex - 1) % (1 << FINAL_PER_WORDS);
        int num = (words[wordIndex >> FINAL_PER_WORDS] & (15 << count * 4)) / (1 << count * 4);
        return num < 0 ? 16 + num : num;
    }
}
```
# 测试的类
```java
package com.gustave.practice.testWork.bitMap;

import com.gustave.practice.hobby.interest.BitMap;
import org.junit.Test;

public class MyBitMap {

    @Test
    public void test(){
        int size = 100;
        BitMap bitMap = new BitMap(size);
        for (int i = 1; i <100 ; i++) {
            bitMap.set(i);
        }
        bitMap.set(1);
        bitMap.set(1);
        bitMap.set(2);
        for (int i = 0; i <9 ; i++) {
            bitMap.set(8);
        }
        for (int i = 0; i <19 ; i++) {
            bitMap.set(16);
            bitMap.set(17);
        }
        System.out.println(bitMap.get(1));
        System.out.println(bitMap.get(2));
        System.out.println(bitMap.get(12));
        System.out.println(bitMap.get(8));
        System.out.println(bitMap.get(16));
        System.out.println(bitMap.get(17));
    }
}

```
- 结果
```java
3
2
1
10
15
15
```