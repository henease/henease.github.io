---
title: IDEA中添加依赖时自动提示
date: 2017-07-06 15:16:11
categories: maven
tags: [IDEA,maven]
---
![](http://orujzh93n.bkt.clouddn.com/%E7%A8%8B%E5%BA%8F%E7%8C%BF.jpg)<!-- more -->


　　很多开发者们总是自嘲程序猿，然而虽然称呼为“猿”，但我们的工作却非常要求效率的，如果能在每个步骤上节约时间，小河汇大江，加起来应该也能提早点下班吧。言归正传，由于公司要求，从eclipse转IDEA有一段时间了，IDEA的界面非常极客，尤其是配上Darcula主题，其他的各种提示也非常人性化，大大提高了工作效率。但这两天因为开发新项目，转到楼下工作，配了新电脑，写代码时发现在加pom依赖时不会自动提示了，所以每次都得自己敲依赖坐标，非常痛苦。其实解决这个问题非常简单，现在我就来说一说具体步骤。
### 无法自动提示并填写依赖坐标
　　比如我想输入aliyun-java-sdk-core.jar的依赖坐标，当我像下面这样在pom文件里输入时，发现IDEA并没有给出任何提示，很奇怪，以前不是这样的。

![](http://orujzh93n.bkt.clouddn.com/%E6%B7%BB%E5%8A%A0%E4%BE%9D%E8%B5%96%E4%B8%8D%E8%83%BD%E8%87%AA%E5%8A%A8%E6%8F%90%E7%A4%BA.png)

### 原因
　　经过一番探索研究，终于理清楚了这其中的原因。原来IDEA在你输入某一项依赖的坐标时，可以根据你本地以及远程maven仓库内已经下载好的依赖，给出相应的提示。如果你之前从来没有添加过某个依赖，那么第一次输入时还是需要自己手敲坐标的，但是因为各个项目间的依赖其实差的并不是很大，所以只要能设置自动提示，手动添加坐标的情况还是很少见的。
### 设置为可以自动提示
　　那么该怎么设置呢？可以按照下面的步骤，进入到Repositories的设置中。
> File >> Settings >> Build,Execution,Deployment >> Build Tools >> Maven >> Repositories

　　可以看到如图所示的设置：

![](http://orujzh93n.bkt.clouddn.com/Settings%E8%AE%BE%E7%BD%AEmaven%E4%BB%93%E5%BA%93.png)

　　依次选中本地和远程的maven仓库地址，点击右侧的Update按钮，进行更新。
### 实现自动提示
　　设置完毕后，重新在pom文件内输入aliyun-java-sdk-core.jar的依赖坐标，发现这个时候IDEA会给出提示，其中就有我需要的选项，可爱的IDEA又回来了。当然，这里的前提是我之前下载过这个依赖。

![](http://orujzh93n.bkt.clouddn.com/idea%E6%B7%BB%E5%8A%A0%E4%BE%9D%E8%B5%96%E6%9C%89%E6%8F%90%E7%A4%BA%E4%BA%86.png)



