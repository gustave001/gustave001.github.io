---
title: IDEA插件小试牛刀
tags: [IDEA,插件]
categories: 好奇尚异
date: 2018-11-19 02:01:57
updated: 2018-11-19 02:01:57
---
下了个社区版，先试试 `Hello World` ，后续尝试更多花样
```java
public class HelloAction extends AnAction {

    @Override
    public void actionPerformed(AnActionEvent e) {
        Date date = new Date();
        SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
        String formatDate = sdf.format(date);
        Messages.showMessageDialog(String.format("It is %s now",formatDate), "Good Morning", Messages.getWarningIcon());
    }
}
```
![IDEA插件](https://note.youdao.com/yws/public/resource/7fe8e401352a5a9cbdeac81cafe1f9e1/xmlnote/D737BB17BA134BEF9778D78A2E7EC622/2706)
# 心情的起伏
人生总是很难一帆风顺，总会磕磕绊绊，所以是否能够不受影响，坚定地去做自己想做的事就显得尤为重要！