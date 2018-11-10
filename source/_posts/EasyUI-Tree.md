---
title: EasyUI_Tree
tags:
  - easyUI
  - tree
  - 前端
categories: 天涯海角
abbrlink: 5d3df5f4
date: 2018-10-29 00:49:59
update: 2018-10-29 00:58:55
---
# EasyUi Tree
 **树的初始化，以及数据格式** 
<!--more-->
1. 树的数据格式
  + id：节点的 id，它对于加载远程数据很重要。
  + text：要显示的节点文本。
  + state：节点状态，'open' 或 'closed'，默认是 'open'。当设置为 'closed' 时，该节点有子节点，并且将从远程站点加载它们。
  + checked：指示节点是否被选中。
  + attributes：给一个节点添加的自定义属性。
  + children：定义了一些子节点的节点数组。

```json

    [{
        "id":1,
        "text":"Folder1",
        "iconCls":"icon-save",
        "children":[{
            "text":"File1",
            "checked":true
        },{
            "text":"Books",
            "state":"open",
            "attributes":{
                "url":"/demo/book/abc",
                "price":100
            },
            "children":[{
                "text":"PhotoShop",
                "checked":true
            },{
                "id": 8,
                "text":"Sub Bookds",
                "state":"closed"
            }]
        }]
    },{
        "text":"Languages",
        "state":"closed",
        "children":[{
            "text":"Java"
        },{
            "text":"C#"
        }]
    }]
```
2. 初始化树

```javascript

    $(".tt").tree({
        data: treeData,
        onClick: function (node) {
            var parentTd = $(this).parents('.ttDiv').parent();
        },
        onSelect: function (node) {
            $(this).tree(node.state === 'closed' ? 'expand' : 'collapse', node.target);
        },
        onLoadSuccess: function () {
            $(this).tree("collapseAll");
        }
    });

```
