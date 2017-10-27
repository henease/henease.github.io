---
title: show engines没有InnoDB
date: 2017-06-28 18:57:27
categories: mysql
tags: mysql
---
### sql语句里设置的ENGINE没有生效
　　今天在Navicat上建表时发现一个问题，sql语句中设置ENGINE=InnoDB，但是在Navicat上执行后发现ENGINE=MyISAM。<!-- more -->sql语句：
```sql
CREATE TABLE `tb_bankcard` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `userid` bigint(30) NOT NULL COMMENT '用户id',
  `bank` varchar(40) DEFAULT NULL COMMENT '银行',
  `deposit` varchar(100) DEFAULT NULL COMMENT '开户行分支',
  `card` varchar(40) DEFAULT NULL COMMENT '银行卡号',
  `bankcode` varchar(100) DEFAULT NULL COMMENT '银行卡编码',
  `state` int(1) DEFAULT '0' COMMENT '0-可用 1-不可用',
  `create_time` datetime DEFAULT NULL COMMENT '添加时间',
  `name` varchar(20) DEFAULT NULL COMMENT '真实姓名',
  `idno` varchar(30) DEFAULT NULL COMMENT '身份证号',
  PRIMARY KEY (`id`),
  UNIQUE KEY (`userid`,`card`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='用户银行卡信息表'; 
```
　　Navicat上DDL显示如下：

![](http://orujzh93n.bkt.clouddn.com/engine%E4%B8%8D%E4%B8%80%E6%A0%B7.png)
### mysql里没有InnoDB
　　为什么sql语句和DDL显示不一样呢？难道mysql不支持InnoDB吗？于是在dos里证实了一下。
　　输入：
```dos
mysql> show engines;
```
![](http://orujzh93n.bkt.clouddn.com/%E6%B2%A1%E6%9C%89innodb.png)

　　发现并没有InnoDB，这是怎么回事呢？这个时候就应该去看日志了，根据日志记录看看运行过程中发生了什么问题，竟然没有InnoDB。我在mysql安装目录的data文件夹内发现有一个.err文件，嗯，一看后缀就知道是错误记录的文件，打开后观察了下，确实有报错。
### 查看.err日志文件
![](http://orujzh93n.bkt.clouddn.com/%E6%97%A5%E5%BF%97%E6%8A%A5%E9%94%991.png)

　　这里说配置文件内的日志大小设置与实际生成的日志大小不一致，在我的本地配置文件my.ini中日志文件的大小设置是innodb\_log\_file\_size = 120M，根据日志报错实际应该设置成5M，于是我重新设置日志大小，并把所有ib\_logfile文件删除，重新启动mysql，再次查看.err日志文件。

![](http://orujzh93n.bkt.clouddn.com/%E6%97%A5%E5%BF%97%E6%8A%A5%E9%94%992.png)

　　发现新生成的日志文件都是5M的了，但是第二个红框还是有日志方面的错误，说“data files are corrupt ”，那就再重启一次mysql吧。
### 官方解决方案
![](http://orujzh93n.bkt.clouddn.com/%E6%97%A5%E5%BF%97%E6%8A%A5%E9%94%993_%E7%BB%99%E5%87%BA%E9%93%BE%E6%8E%A5.png)

　　发现系统温馨地给出说明和疑似解决问题的链接了，哎，似乎是被mysql鄙视了。于是点开箭头所指的链接[(在这儿)](https://dev.mysql.com/doc/refman/5.5/en/error-creating-innodb.html)，打开mysql官方给出的解决方案。

![](http://orujzh93n.bkt.clouddn.com/%E5%AE%98%E6%96%B9%E5%A4%84%E7%90%86.png)

　　官方建议我把ibdata和ib_logfile全部删除，嗯那就照着官方的指示来试试吧。删除后重新启动mysql，发现.err里没有报错信息了，进入mysql查看一下engines。
### 问题解决
![](http://orujzh93n.bkt.clouddn.com/%E6%9C%89innodb%E4%BA%86.png)

　　InnoDB回来啦！再次在Navicat里执行一遍同样的sql。

![](http://orujzh93n.bkt.clouddn.com/innodb%E5%BB%BA%E8%A1%A8%E6%88%90%E5%8A%9F.png)

　　发现ENGINE=InnoDB，成功！
