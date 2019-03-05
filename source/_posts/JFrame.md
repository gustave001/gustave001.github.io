---
title: JFrame
tags:
  - JFrame
  - Java
categories: Java
abbrlink: ad1a6c7d
date: 2019-01-07 01:53:57
updated: 2019-01-20 16:22:32
---

# WindowMenu
<!--more-->
```java
package com.gustave.practice.jframe;

import javax.swing.*;

public class WindowMenu extends JFrame {

    JMenuBar menubar;

    JMenu menu0,menu1,menu2,subMenu;

    JMenuItem item1,item2,item3;

    public WindowMenu(String s,int x,int y,int w,int h) {

        init(s);

        setLocation(x,y);

        setSize(w,h);

        setVisible(true);

        setDefaultCloseOperation(DISPOSE_ON_CLOSE);

    }

    void init(String s) {

        setTitle(s);

        menubar = new JMenuBar();

        menu0 = new JMenu("游戏"); //菜单栏的第一个选项

        item1 = new JMenuItem("新游戏(new)");

        item2 = new JMenuItem("重新开始");

        menu0.add(item1);

        menu0.addSeparator(); //设置子菜单之间的分割线

        menu0.add(item2);

        menu0.addSeparator(); //设置子菜单之间的分割线

        subMenu = new JMenu("难度等级");

        menu0.add(subMenu);

        subMenu.add(new JMenuItem("初级"));

        subMenu.add(new JMenuItem("中级"));

        subMenu.add(new JMenuItem("高级"));

        menu0.addSeparator();

        item3 = new JMenuItem("退出");

        menu0.add(item3);

        menubar.add(menu0);

        menu1 = new JMenu("编辑"); //菜单栏的第二个选项

        item1 = new JMenuItem("后退一步");

        menu1.add(item1);

        menu1.addSeparator(); //设置子菜单之间的分割线

        item2 = new JMenuItem("前进一步");

        menu1.add(item2);

        menubar.add(menu1);

        menu2 = new JMenu("关于");

        item1 = new JMenuItem("作者：rwxian");

        menu2.add(item1);

        menu2.addSeparator();

        item2 = new JMenuItem("版本：v1.0");

        menu2.add(item2);

        menubar.add(menu2);

        setJMenuBar(menubar);

    }

}

```
# Main
```java
package com.gustave.practice.jframe;

public class Main {
    public static void main(String[] args) {
        for (String arg : args) {
            System.out.println(arg);
        }
        WindowMenu win = new WindowMenu("俄罗斯方块", 200, 30, 900, 1000);
    }

}

```