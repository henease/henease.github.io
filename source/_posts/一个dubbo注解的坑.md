---
title: 一个dubbo注解的坑
date: 2017-08-07 15:00:50
categories: dubbo
tags: [dubbo,spring]
---
![](http://orujzh93n.bkt.clouddn.com/%E5%9D%91.jpg)<!-- more -->
　　最近这段时间一直在忙项目，菜鸟经验不足，所以必须多花时间啦。言归正传，说到dubbo服务（英文发音为|ˈdʌbəʊ|），它是阿里巴巴开发的一个分布式服务框架，用于提供高性能和透明化的RPC远程服务调用方案，以及SOA服务治理方案。dubbo确实帮助开发者提高了开发效率，但是在这之前，该踩的坑还是得踩。之前学dubbo时，尝试自己编译，中间折腾了很久，比如依赖版本号之类的问题，让人很是无语，还好后来解决了，也做了总结。今天又碰到了dubbo方面的问题，但是严格来说，似乎应该算作个人的坏习惯。
### dubbo报Forbid consumer错误
　　在测试过程中出现“Forbid consumer xxx.xxx.xxx.xxx access service......Please check registry access list (whitelist/blacklist)”这样的错误，相信使用过dubbo的人对这个报错应该非常熟悉。根据以往的经验，出现这个错误，和黑白名单没啥关系，因为我的服务注册地址在本地，而我没有配置过黑白名单。出现这个报错，大多数情况是服务没有注册，没有provider，这里有一篇文章是写这个的，[去看看](http://blog.sina.com.cn/s/blog_4adc4b090102x12u.html) 。所以在遇到这个错误时，我第一时间查看了dubbo配置，看服务注册和调用是否配置正确，发现并没有问题。因为是和spring boot整合使用的，所以之后又检查了服务的注解，看是不是哪里落了注解没加，可是依然一无所获。被dubbo伤的很深，炎热的天气里，我的心拔凉拔凉的。
### 确实是注解出了问题
　　所谓“山重水复疑无路，柳暗花明又一村”，每当我陷入bug不可自拔时，都会去放点水让脑子清醒点。这次也不例外，在解决的过程中，我想到貌似只有注解能出问题了，加了注解不代表加对了注解，毕竟IDE工具很方便，自动就加上了。回去一看发现果然不出所料，服务上加的@Service注解是spring家的，而我需要的是dubbo家的。
　　把下面的注解换掉：
　　
![](http://orujzh93n.bkt.clouddn.com/spring%E7%9A%84Service%E6%B3%A8%E8%A7%A3.png)

　　换成dubbo的@Service注解。
　　
![](http://orujzh93n.bkt.clouddn.com/dubbo%E7%9A%84Service%E6%B3%A8%E8%A7%A3.png)

　　再次启动，查看启动日志，发现服务已经注册，测试也没有报错产生。
### 反思
　　这件事情也提醒我开发过程中的习惯养成问题，现在各种IDE工具非常智能实用，也确确实实帮助我提高了开发效率，但是自动提示只是自动提示，过程当中还是需要多留意多注意。记一笔，算是一个小小的教训吧。