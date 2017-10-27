---
title: 用shiro实现不同角色的对应显示
date: 2017-08-29 15:47:21
categories: shiro
tags: [shiro,thymeleaf]
---
　　![shiro](http://orujzh93n.bkt.clouddn.com/Apache_Shiro_Logo.png)
　　最近在用shiro做后台的权限控制，作为Apache的开源项目，shiro的学习资料很多，我在看的除了官网文档外，还有《跟我学Shiro》，作者是京东的张开涛，我觉得非常不错，推荐给大家。<!-- more -->之前碰到的问题都是一个页面仅限一个角色显示，比如一个只针对ROOT角色的页面，ADMIN角色的用户是无法浏览的。像这种问题只要在映射方法上加上如下的注解即可：

``` java
@RequireRoles("ROOT")
```
　　之后在前台文件中需要权限控制的tag加入下面的代码（我用的模板引擎是thymeleaf，号称新一代的轻量级模板，用了一段时间后感觉比freemarker有过之而无不及）。
``` html
shiro:hasRole="ROOT"
```
　　上面这种权限控制针对的情况比较简单，如果出现这样一种页面，它显示一些数据，其中ROOT角色作为超级管理员可以浏览所有数据，但是ADMIN只能浏览自己添加的那部分内容（多个用户拥有ADMIN角色，他们可以添加各自的内容），那又该如何设置注解呢？对于这种情况，我们只需要在原来的基础上添加一个ADMIN角色，同时指定ROOT和ADMIN角色的逻辑关系即可。
``` java
@RequireRoles(value={"ROOT","ADMIN"},logical=Logical.OR)
```
　　“value”后的花括号内可以添加多个角色，它们之间的关系是“OR”或关系，如果不添加logical部分，则shiro默认ROOT和ADMIN之间是和关系，即既是ROOT又是ADMIN。然后在映射方法内进行逻辑判断，针对角色返回对应的数据。那么在前台文件里又该如何设置呢？此时仍然采用shiro:hasRole是不行的，因为它只指定一个角色，在shiro的官网中有针对hasRole这个tag的例子和说明（[点这里](https://shiro.apache.org/web.html#Web-The%7B%7BhasRole%7D%7Dtag)）。对于这种多个角色或关系的，我们可以使用[shiro:hasAnyRole](https://shiro.apache.org/web.html#Web-The%7B%7BhasAnyRole%7D%7Dtag)。
``` html
shiro:hasAnyRole="ROOT,ADMIN"
```
　　这里只是针对shiro的一个小小的知识点说明，作为权限控制框架，shiro考虑得非常全面，几乎覆盖了你能想到的任何情况。而且上手快，学习成本低，粗细粒度自由控制，非常方便。正如shiro自己所说的，Security can be very complex at times，even painful，but it doesn't have to be。