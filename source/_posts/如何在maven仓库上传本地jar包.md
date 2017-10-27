---
title: 如何在maven仓库上传本地jar包
date: 2017-07-26 17:01:14
categories: maven
tags: maven
---
　　之前在“maven依赖无法下载”里提到将maven依赖安装到本地maven仓库的方法，虽然解决了自己的问题，但对于一个开发团队来说，这种解决方案无疑是于事无补的。因为团队其他成员在更新代码后，会发现依赖无法下载，因为中央仓库里根本没有这个依赖（这里的中央仓库指的是公司服务器上的maven仓库）。所以仅仅把依赖jar包安装到本地仓库并不能彻底解决问题，而是需要把jar包上传到中央仓库（即settings.xml文件中指定的仓库地址）才行。<!-- more -->那么该如何把jar包上传到中央仓库呢？
### 登录中央仓库
　　首先在浏览器中打开中央仓库的url地址，可以看到下面的页面：

![](http://orujzh93n.bkt.clouddn.com/%E6%89%93%E5%BC%80%E4%B8%AD%E5%A4%AE%E4%BB%93%E5%BA%93.png)
　　点击红色箭头处“Log In”登录管理员账户，然后在页面左侧箭头所指处选择“Repositories”：
　　
![](http://orujzh93n.bkt.clouddn.com/%E9%80%89%E6%8B%A9repositories.png)
### 选择上传方式　　
　　点击3rd party
　　
![](http://orujzh93n.bkt.clouddn.com/%E9%80%89%E6%8B%A93rd_party.png)
　　然后选择“Artifact Upload”
　　
![](http://orujzh93n.bkt.clouddn.com/%E7%82%B9%E5%87%BBupload.png)
　　如图选择GAV Parameters

![](http://orujzh93n.bkt.clouddn.com/%E9%80%89%E6%8B%A9GAV_Parameters.png)
### 添加依赖　　
　　之后按照下图所示的数字顺序依次输入依赖坐标，选择需要上传的依赖jar包，点击Add Artifact，最后点击Upload Artifact(s)。

![](http://orujzh93n.bkt.clouddn.com/%E6%B7%BB%E5%8A%A0%E4%BE%9D%E8%B5%96jar%E6%AD%A5%E9%AA%A4.png)
　　到此为止就完成了依赖的上传，这时候团队其他成员在pom文件内配置好对应依赖的坐标后，即可将依赖下载到本地仓库中。