---
title: 更改项目的Jenkins部署
date: 2018-04-09 22:39:17
categories: jenkins
tags: [jenkins,linux]
---

![](http://orujzh93n.bkt.clouddn.com/Jenkins_Needs_You.png)<!-- more -->

　　下午对项目的Jenkins部署进行了更改，所以在这里对此做一个小小的总结。Jenkins是用于持续构建的可视化web工具，可以对项目进行自动化编译、打包、分发部署。Jenkins可以很好地兼容ant、maven、gradle等构建工具，可以和svn、git等版本控制工具无缝集成。总的来说就是：让我们懒一点，很省事！

## 背景介绍

　　之前我们项目在测试环境部署时，都是部署在一台服务器上的，后来有了其他项目，他们图省事也部署到了同一台上，到后期阶段，同一台服务器的性能瓶颈就越来越被放大了，时常cpu飙高。所以又重开了两台服务器，专门用于部署我们的项目。于是，我需要更改Jenkins的一些设置，以便之后项目构建时能部署到新的两台服务器上。

## 更改过程

### 前期准备

　　首先我对新开的两台服务器环境进行配置（基本的jdk之类的配置就略过不说了），我将项目分为web和service两部分，web部署一台，service部署一台。在两台服务器上分别建立相应的jar包所在文件夹，启动服务的shell脚本，日志记录，编译服务所需的动态库，开启相应服务所对应的端口等等，总之就是将原来的服务器环境配置平移拆解到新开的两台服务器上，这个视原先具体的部署情况而定，这里不多做说明。

### 项目配置修改

　　首先需要修改每个项目的配置。进入Jenkins页面，可以看到项目列表，如下图所示：

![](http://orujzh93n.bkt.clouddn.com/jenkins_projects.jpg)

　　点击“test.admin”，进入Project，然后点击左侧的配置，对项目配置进行修改，这里我们主要修改构建部分的内容。

![](http://orujzh93n.bkt.clouddn.com/deploy_setting.jpg)

　　这里我已经修改完成，实际修改时，我们只能修改“Command”部分的内容，“SSH site”部分是select框，里面的服务器地址需要在其他地方设置后，才能在这里进行选择。下面我们说说如何添加SSH site。

### 添加SSH site

　　上面说到需要修改构建部分，其实构建部分就是两个操作：

1. 执行打包操作，生成相应的新jar包
2. 执行shell脚本，拷贝jar包到远程主机上，并执行启动脚本

　　其中第2步操作需要安装SSH插件，如下所示。

![](http://orujzh93n.bkt.clouddn.com/jenkins_ssh_plugin.jpg)

　　我已经安装过这个插件了。下面说添加SSH site的操作，还是回到Jenkins主页面，点击左侧栏的系统管理，进入“管理Jenkins”页面后，点击“系统设置”，在“SSH remote hosts”项增加新的SSH site，如下所示：

![](http://orujzh93n.bkt.clouddn.com/add_ssh_site.jpg)

　　添加红框部分的设置即可，之后回到项目配置页面，SSH site选项中就会有添加的服务器地址。

### SSH免密设置

　　这时候，当我们去构建某一个项目时，可能会出现“Host key verification failed”或者“Permission denied”的错误，这是因为在执行scp操作时，需要验证密码。那么如何实现免密执行scp命令呢？假设Jenkins所在服务器为A，远程服务器为B，我们需要在A上执行scp命令，将jar包传到B服务器上。

　　在A上执行以下步骤：

1. ``ssh-keygen -t rsa ``，输入命令后一直按回车就行
2. `` ssh root@xxx.xxx.xxx.xxx "chmod 0700 .ssh"``
3. `` scp ~/.ssh/id_rsa.pub root@xxx.xxx.xxx.xxx:.ssh/id_rsa.pub``

　　上面步骤中xxx.xxx.xxx.xxx即为B服务器的ip地址。

　　在B上执行以下步骤：

1. `` touch /root/.ssh/authorized_keys``
2. `` chmod 600 ~/.ssh/authorized_keys``
3. `` cat /root/.ssh/id_rsa.pub >> /root/.ssh/authorized_keys``

　　完成上面6个步骤后就可以实现免密操作了，可以在A服务器上输入：

　　`` ssh root@xxx.xxx.xxx.xxx``

　　发现能直接登录到B服务器。

## 更改完成

　　此时再次执行构建，打开Console Output，会看到执行成功，查看具体项目的日志，确认服务已经启动。

![](http://orujzh93n.bkt.clouddn.com/console_output.jpg)

