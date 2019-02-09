---
title: Java设计模式
tags: [Java,设计模式]
date: 2019-02-09 00:42:38
updated: 2019-02-09 14:58:28
categories: Java
---

# 简单工厂模式
- 实体类
```java
public abstract class Animal {

    public void shout(){
        System.out.println("动物在叫");
    }
}

class Dog extends Animal{
    @Override
    public void shout() {
        System.out.println("狗在叫");
    }
}

class Cat extends Animal{
    @Override
    public void shout() {
        System.out.println("猫在叫");
    }
}
```
- 工厂类
```java
public class AnimalFactory {
    public static Animal creatAnimal(String name){
        Animal animal = null;
        switch (name) {
            case "猫":
                animal = new Cat();break;
            case "狗":
                animal = new Dog();break;
            default:
                animal = new Animal() {
                    @Override
                    public void shout() {
                        System.out.println("不知名动物在叫");
                    }
                };
        }
        return animal;
    }
}
```
- Main函数
```java
public class Test {
    public static void main(String[] args) {
        Scanner in = new Scanner(System.in);
        while (true) {
            String name = in.next();
            Animal animal = AnimalFactory.creatAnimal(name);
            animal.shout();
        }
    }
}
```
- 结果
![运行结果](../images/简单工厂模式运行结果.jpg)