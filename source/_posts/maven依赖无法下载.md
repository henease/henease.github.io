---
title: maven依赖无法下载
date: 2017-07-07 14:20:46
categories: maven
tags: [maven,IDEA]
---
　　最近两天和IDEA杠上了，今天在项目的pom文件里添加依赖坐标后，发现不能自动下载依赖，或者说依赖下载不成功。
```pom
<dependency>
	<groupId>com.aliyun</groupId>
	<artifactId>aliyun-java-sdk-dysmsapi</artifactId>
	<version>1.0.0-SNAPSHOT</version>
</dependency>
```
<!-- more -->
### maven依赖下载失败
　　像上面这样添加了正确的依赖后，发现在“External Libraries”里并没有对应的jar包显示。

![](http://orujzh93n.bkt.clouddn.com/%E6%B2%A1%E6%9C%89%E4%B8%8B%E8%BD%BD%E6%88%90%E5%8A%9F.png)

　　按照网上千篇一律的指导，说是需要删除本地maven仓库内下载失败的文件，即以.lastUpdated结尾的文件，但是照做之后重新执行，发现依赖仍然不能成功下载下来。

![](http://orujzh93n.bkt.clouddn.com/%E6%9C%AC%E5%9C%B0maven%E4%BB%93%E5%BA%93%E6%B2%A1%E6%9C%89%E4%B8%8B%E8%BD%BD%E6%88%90%E5%8A%9F.png)
### 解决方案
　　于是采用了最笨最简单的方法，就是下载官方jar包到本地，然后手动添加，Ctrl+Shift+Alt+s后进入项目结构设置，点击下图箭头所指的位置添加jar包。

![](http://orujzh93n.bkt.clouddn.com/%E6%B7%BB%E5%8A%A0%E6%9C%AC%E5%9C%B0jar%E5%8C%85.png)

　　但是作为一名严重强迫症患者，这种情况是难以接受的，而且我在写代码的过程中也发现，通过这种方式导包，IDEA会出现一些莫名其妙的报错，比如报方法参数有误，而实际上并没有问题。既然是想通过maven的方式管理依赖，何不把jar包安装到本地的maven仓库呢？这样也就能实现和maven自动下载依赖一样的效果了。下面就说说怎么把下载的jar包转变为maven自动下载后的样子。
　　打开对应项目的终端，即Terminal窗口，以我自己的情况为例，输入下面代码。
```dos
mvn install:install-file -Dfile=C:\Users\Administrator\Desktop\aliapi\aliyun-java-sdk-dysmsapi-1.0.0-SNAPSHOT.jar -DgroupId=com.aliyun -DartifactId=aliyun-java-sdk-dysmsapi -Dversion=1.0.0-SNAPSHOT -Dpackaging=jar
```
　　当然，不同的情况，-Dfile、-DgroupId、-DartifactId、-Dversion、-Dpackaging都不一样。
　　可以看到安装成功：

![](http://orujzh93n.bkt.clouddn.com/mvn%E5%AE%89%E8%A3%85%E6%88%90%E5%8A%9F.png)

　　这个时候就可以看到在“External Libraries”里多了一行：

![](http://orujzh93n.bkt.clouddn.com/mavenjar%E5%8C%85%E6%B7%BB%E5%8A%A0%E6%88%90%E5%8A%9F.png)

### 待续
　　虽然问题貌似解决了，但是maven依然不能成功自动下载对应依赖，这个问题留待研究，后续补上。