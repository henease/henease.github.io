---
title: 一次ajax请求，两次提交
date: 2017-07-21 13:40:26
categories: ajax
tags: [ajax，html]
---
　　最近一直在忙公司的web项目的开发，碰到一个比较有趣的问题，这个问题不太容易发现（老鸟们请忽视）。
### 点击提交，执行两次请求
　　我在使用ajax进行表单的提交时，发现后台执行成功，但前台总是不执行success的回调函数，而是执行error的回调函数，检查了n遍，依旧发现不了问题。后来抓包发现，在点击表单的提交按钮后，先后执行了ajax的post请求，以及一次不知哪里冒出来的get请求。<!-- more -->看来问题似乎并不在ajax上，而是出在了html的提交按钮上。
### button的type问题
　　检查了下前端的button按钮，发现代码如下：
```html
<button class="login-btn" id="s-submit">提交</button>
```
　　看了下w3school关于HTML&lt;button&gt;标签的[介绍](http://www.w3school.com.cn/tags/att_button_type.asp)，里面有句话是这么说的：
> type 属性规定按钮的类型。
> 提示：请始终为按钮规定 type 属性。Internet Explorer 的默认类型是 "button"，而其他浏览器中（包括 W3C 规范）的默认值是 "submit"。

　　还有如下所示的一张表：

![](http://orujzh93n.bkt.clouddn.com/button%E7%9A%84type%E5%B1%9E%E6%80%A7.png)

　　我在测试时一直都是用的chrome，所以此时button的默认type属性为submit，所以每次执行完ajax的post请求后，submit默认又把表单提交了一遍，因而出现了开头我说的问题。
### 解决方案
　　于是我把提交按钮的type属性设置为button：
```html
<button type="button" class="login-btn" id="s-submit">提交</button>
```
　　再次测试后发现ajax能正确执行success的回调函数了。除此之外，保持type=submit的情况下，在提交按钮的click()函数最后一行加上return false，也可以保证ajax的success回调函数正确执行，因为此时阻止了submit的默认行为。