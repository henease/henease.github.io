---
title: 用vps和shadowsocks搭梯子
date: 2017-09-30 13:55:11
categories: 科学上网
tags: [vps,shadowsocks]
---
![](http://orujzh93n.bkt.clouddn.com/ladder.jpg)<!-- more -->

　　作为一个开发者，google是必不可少的，合理使用google也是程序员的基本技能，相比bing和baidu，google无疑是更优选择，于我而言，难以退而求其次。但是由于一些原因，google服务在国内无法使用，所以就不得不通过一些方法来帮助访问google服务了。
### GoAgent
　　大学时候，因为穷的原因，所以免费是第一考虑，当时的选择是[GoAgent](https://zh.wikipedia.org/wiki/GoAgent)配合Chrome浏览器，每个月有限额的流量，用作搜索使用绰绰有余，但是速度较慢。
### VPN
　　工作之后有了薪水，就选择了付费的VPN服务，速度上快了很多，但是不足的是VPN基本都是全局代理，即使是国内网站也需要绕个大圈子访问，非常不方便。只有在需要google服务的时候才会使用，所以闲置时间占比较多，经济上不是很合理划算。
### hosts文件
　　基于上面的考虑，后来接触到hosts文件修改方案。hosts在各个操作系统中都有，具体位置可以搜索查询。我们知道在访问网站时，需要找到它的IP地址，而IP地址又由DNS解析，将域名对应到IP上，而由于hosts的存在，在做DNS解析之前，系统会先检查本地的hosts文件中是否有地址映射关系，如果有的话就直接使用这个地址映射，而不会向DNS服务器发域名解析请求，因此修改hosts文件又成了一个新方案。通过修改hosts访问google，正常来说非常快速，而且意外地实现了分流的效果。但是，还是由于一些原因，hosts经常性地失效，每次失效都要更新一遍，比较麻烦。
### shadowsocks和vps
　　shadowsocks将socks5协议分解为客户端和服务端，两者通过ip、端口、加密方式和密码进行验证连接。服务端是代理服务器，可以帮助访问客户端无法访问到的内容。而vps是指虚拟专用服务器，是通过虚拟化技术在独立服务器中运行的专用服务器，拥有独立的公网IP地址、操作系统、硬盘空间、内存空间、CPU等，还可以安装程序、重启。shadowsocks和vps配合的步骤就是：
> 1、获得自己的vps
> 2、在vps上安装服务端的shadowsocks，并设置端口、加密方式和密码
> 3、在本地安装客户端shadowsocks，填入服务端的ip，第2步中的端口、加密方式、密码
> 4、done

#### 获得自己的vps
　　网上vps有很多，个人比较推荐[Vultr](https://www.vultr.com/?ref=7222285)，先注册登录，然后在Billing页面充值。

![](http://orujzh93n.bkt.clouddn.com/vultr_billing.png)

　　我选择的visa支付，现在已经支持alipay支付宝。充值后在Servers页面生成一个Instance，点击蓝色“+”添加。

![](http://orujzh93n.bkt.clouddn.com/vultr_servers.png)

　　然后选择你的站点和服务器配置，站点随意，Server Type推荐CentOS，Server Size看需求，一般5刀够用，下面的默认，点击“Deploy Now”部署。

![](http://orujzh93n.bkt.clouddn.com/vultr_deploy.png)

　　然后会看到服务器在“Installing”中，等待一段时间，直到处于Running状态。
#### 安装服务端shadowsocks
　　要在服务端安装shadowsocks，首先要通过ssh连接到vps，我自己使用的是Xshell，输入ip、端口、用户名和密码，接下来就是linux系统的操作体验了。分别输入下面三行命令：
``` bash
wget --no-check-certificate https://raw.githubusercontent.com/teddysun/shadowsocks_install/master/shadowsocks.sh
```
``` bash
chmod +x shadowsocks.sh
```
``` bash
./shadowsocks.sh 2>&1 | tee shadowsocks.log
```
　　输入最后一行后会让你输入密码和端口，仔细看提示操作就行，然后静静地等待其安装完毕。最后你会看到红色底色的IP、端口、密码和加密方式信息。到此第2步接近完成，之所以说接近完成，是因为还需要在服务器上进行速度优化，使得连接速度更为感人。这里推荐两个方案，都是单边优化，只需要在服务端操作就行。
##### TCP BBR拥塞控制算法
　　TCP BBR是Google开源的拥塞控制算法，类似锐速的单边加速工具。还是用Xshell（或者其他工具）连接到VPS，依次输入下面三行命令。
``` bash
wget --no-check-certificate https://github.com/teddysun/across/raw/master/bbr.sh
```
``` bash
chmod +x bbr.sh
```
``` bash
./bbr.sh
```
　　安装完成后会提示重启VPS，之后重新连接，输入：
``` bash
lsmod | grep bbr
```
　　如果返回值有tcp_bbr模块则表示成功。
##### 锐速
　　锐速也是一个单边加速方案，在VPS终端输入：
``` bash
wget -N --no-check-certificate https://raw.githubusercontent.com/91yun/serverspeeder/master/serverspeeder-all.sh && bash serverspeeder-all.sh
```
　　耐心等待其安装完毕，按提示操作，然后输入下面命令，打开配置文件：
``` bash
nano /serverspeeder/etc/config
```
　　将advinacc的值由0改为1，然后ctrl+x退出，再输入y并回车确认退出。如果安装后提示需要更换内核，则需要更换内核，可以输入下面两行命令：
``` bash
wget --no-check-certificate https://blog.asuhu.com/sh/ruisu.sh
```
``` bash
bash ruisu.sh
```
　　之后VPS会重启，重新连接到VPS，输入下面的命令：
``` bash 
wget --no-check-certificate -O appex.sh https://raw.githubusercontent.com/0oVicero0/serverSpeeder_Install/master/appex.sh && chmod +x appex.sh && bash appex.sh install
```
　　安装完毕后输入下面命令检测是否启用：
``` bash
lsmod | grep appex
```
#### 安装客户端shadowsocks
　　可以在GitHub上获取[shadowsocks](https://github.com/shadowsocks/shadowsocks-windows/releases)最新版本，点击shadowsocks.exe，输入服务器地址、端口、shadowsocks密码和加密方式，代理端口可以保持1080。此时基本设置完毕，如果平时使用Chrome的话，可以下载SwitchyOmega扩展进行代理设置。

![](http://orujzh93n.bkt.clouddn.com/switchyomega.png)

　　如图这样设置就行，然后在auto switch里配置需要使用proxy情景的网站域名，实现分流。最后打开shadowsocks客户端，点击“启用系统代理”。
#### Done
　　shadowsocks使用PAC（代理自动配置），可以自己设置本地PAC，比如SwitchyOmega那样，也可以使用在线PAC，以后慢慢研究。
### 结尾
　　最后，推荐一下IOS端的sugre，非常贵，非常好用！
