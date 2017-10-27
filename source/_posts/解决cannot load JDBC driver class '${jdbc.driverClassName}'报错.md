---
title: 解决cannot load JDBC driver class '${jdbc.driverClassName}'报错
date: 2017-06-20 21:08:04
categories: spring
tags: [mysql,IDEA,spring]
---
### 报错
　　今天学习了WebMagic爬虫框架，然后就蠢蠢欲动，写了个豆瓣爬虫，根据评分爬取图书，并持久化到MySQL数据库的程序。但是很不幸的是在最后单元测试的时候报错了，控制台报错如下：

![报错](http://orujzh93n.bkt.clouddn.com/%E6%8A%A5%E9%94%99.jpg)<!-- more -->

　　很明显，没有识别到“${jdbc.driverClassName}”的“真实面目”，检查了一遍配置文件，发现一切正常啊，怎么会这样呢？

![数据源配置](http://orujzh93n.bkt.clouddn.com/%E6%95%B0%E6%8D%AE%E6%BA%90%E9%85%8D%E7%BD%AE.jpg)

![资源文件配置](http://orujzh93n.bkt.clouddn.com/%E5%A4%96%E9%83%A8%E6%96%87%E4%BB%B6%E9%85%8D%E7%BD%AE.jpg)

### 查错
　　于是google了一下报错，看了一些解决方案，基本都是一样的说法，都是从同一个答案copy出来的，于事无补。很无奈啊，到底出了什么幺蛾子......
后来在解决Nature's call时突然想到，配置文件应该能找到的吧？结果发现是这样：

![多个同名配置文件](http://orujzh93n.bkt.clouddn.com/%E5%A4%9A%E4%B8%AA%E9%80%89%E9%A1%B9.jpg)

　　竟然有两个同名的配置文件，这时候才恍然大悟，想起来我之前统一抽取过配置文件，Ctrl+Shift+Alt+s看一下，发现果然如此。

![项目结构配置](http://orujzh93n.bkt.clouddn.com/%E9%A1%B9%E7%9B%AE%E7%BB%93%E6%9E%84.jpg)

　　红色箭头指的地方加了一些配置文件，里面就有一个叫做jdbc.properties的配置文件，内容是这样的：

![同名jdbc配置的内容](http://orujzh93n.bkt.clouddn.com/jdbc%E9%85%8D%E7%BD%AE.jpg)

### 结论
　　spring在找同名的jdbc.properties时优先去SDKs设置里找了，然后发现里面并没有叫jdbc.driverClassName的东西，于是报错。把E:\config这个配置去掉，重跑一次，一切OK!

### 最后
　　那么在保持原有SDKs设置的情况下，怎样才能读到正确的配置呢？
* 把你要用到的那个jdbc.properties重命名，比如改成db.properties；
* 把classpath改成classpath\*，因为在同一路径下存在同名配置文件时，classpath只会读取类路径下的第一个，而classpath*除了当前类路径，还会扫描jar包中的类加载路径，并且会读取所有同名配置文件。

