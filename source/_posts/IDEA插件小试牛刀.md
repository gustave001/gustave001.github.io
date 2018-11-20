---
title: IDEA插件小试牛刀
tags: [IDEA,插件]
categories: 好奇尚异
date: 2018-11-19 02:01:57
updated: 2018-11-21 02:27:38
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

# 插入时间插件
每次写完博客，手动写更新时间真的挺烦，自己动手，丰衣足食  
- plugin.xml
```xml
<idea-plugin>
  <id>com.your.company.unique.plugin.id</id>
  <name>Insert Time Plugin</name>
  <version>1.01</version>
  <vendor email="gustave.yupeng@gmail.com" url="https://www.kikfan.com">Gustave</vendor>

  <description><![CDATA[
      插入当前时间的插件.<br>
      <em>insert time plugin</em>
    ]]></description>

  <change-notes><![CDATA[
      Add change notes here.<br>
      <em>most HTML tags may be used</em>
    ]]>
  </change-notes>

  <!-- please see http://www.jetbrains.org/intellij/sdk/docs/basics/getting_started/build_number_ranges.html for description -->
  <idea-version since-build="173.0"/>

  <!-- please see http://www.jetbrains.org/intellij/sdk/docs/basics/getting_started/plugin_compatibility.html
       on how to target different products -->
  <!-- uncomment to enable plugin in all products
  <depends>com.intellij.modules.lang</depends>
  -->

  <extensions defaultExtensionNs="com.intellij">
    <!-- Add your extensions here -->
  </extensions>

  <actions>
    <!-- Add your actions here -->
    <!--<action id="plugins.HelloAction" class="HelloAction" text="HelloAction" description="Say Hello World">-->
      <!--<add-to-group group-id="HelpMenu" anchor="after" relative-to-action="About"/>-->
    <!--</action>-->
    <action id="plugins.InsertTimeAction" class="InsertTimeAction" text="InsertTime" description="插入当前时间">
      <add-to-group group-id="EditorPopupMenu" anchor="before" relative-to-action="CopyReference"/>
      <keyboard-shortcut first-keystroke="alt T" second-keystroke="ctrl T" keymap="$default"/>
    </action>
  </actions>

</idea-plugin>
```
- InsertTimeAction
```java
import com.intellij.openapi.actionSystem.AnAction;
import com.intellij.openapi.actionSystem.AnActionEvent;
import com.intellij.openapi.actionSystem.PlatformDataKeys;
import com.intellij.openapi.command.WriteCommandAction;
import com.intellij.openapi.editor.Editor;
import com.intellij.openapi.editor.EditorModificationUtil;
import com.intellij.openapi.editor.SelectionModel;
import org.apache.commons.lang3.StringUtils;

import java.text.SimpleDateFormat;
import java.util.Date;

public class InsertTimeAction extends AnAction {

    @Override
    public void actionPerformed(AnActionEvent e) {
        Date date = new Date();
        SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
        String formatDate = sdf.format(date);
//        Messages.showMessageDialog(String.format("It is %s now",formatDate), "Good Morning", Messages.getWarningIcon());
        Editor editor = e.getData(PlatformDataKeys.EDITOR);
        if (null == editor) {
            return;
        }
        SelectionModel selectionModel = editor.getSelectionModel();
        Runnable runnable;
        if(StringUtils.isBlank(selectionModel.getSelectedText())){
            runnable = () -> EditorModificationUtil.insertStringAtCaret(editor, formatDate);
        }
        else{
            runnable = () ->editor.getDocument().replaceString(selectionModel.getSelectionStart(), selectionModel.getSelectionEnd(), formatDate);
        }
        WriteCommandAction.runWriteCommandAction(editor.getProject(), runnable);
    }
}

```

