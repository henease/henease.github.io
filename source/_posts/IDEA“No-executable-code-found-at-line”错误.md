---
title: IDEA “No-executable-code-found-at-line”错误
date: 2017-09-26 11:04:18
categories: IDEA
tags: [IDEA,maven]
---
![](https://s3.amazonaws.com/rails-camp-tutorials/blog/best-ways-debug-ruby-on-rails-application/debugging.jpg)<!-- more -->
　　今天碰到一个问题，发现在进行数据库查询时，将传入的多个参数放入Map中传递后，控制台竟然报参数无法找到。于是debug了一下，在Map中放参数的那行代码打了断点：

![](http://orujzh93n.bkt.clouddn.com/getSms%E6%96%B9%E6%B3%95.png)
　　发现程序总是无法进入断点，再次查看控制台报错信息，发现错误在@Override这行。于是将断点打在此行，再次debug后发现没有进入方法，并且原来在Map中放参数的那行代码处的断点报错：

![](http://orujzh93n.bkt.clouddn.com/no_executable_code_found_at_line.png)
　　（上图为网络图）“No executable code found at line”错误，没有可执行的代码。回忆了一下，想起来之前这个服务是在另一个包里的，后来单独提出来开了一个新包。也许是编译问题呢？于是到对应包下mvn compile了下，问题解决！方法正常执行了。　　

