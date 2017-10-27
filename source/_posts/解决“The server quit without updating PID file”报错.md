---
title: 解决“The server quit without updating PID file”报错
date: 2017-06-26 12:02:26
categories: mysql
tags: mysql
---
### 出错
　　今天在mac终端上登录之前用homebrew安装的mysql时报错：
```bash
bash-3.2$ mysql -uroot -p
Enter password:
ERROR 2002 (HY000):Can't connect to local MySQL server through socket '/tmp/mysql.sock' (2)
```
<!-- more -->
　　第一时间觉得应该是mysql没有启动吧，查看一下进程。
```bash
bash-3.2$ ps aux | grep mysqld
henease       77714    0.0    0.0   2432804    852    s000    S+     12:01上午      0:00.00  grep mysqld
```
　　果然没有启动，于是启动mysql。
```bash
bash-3.2$ mysql.server start
Starting MySQL
./usr/local/Cellar/mysql/5.7.16/bin/mysqld_safe: line 135: /usr/local/var/mysql/henease.local.err: Permission denied
/usr/local/Cellar/mysql/5.7.16/bin/mysqld_safe: line 169: /usr/local/var/mysql/henease.local.err: Permisson denied
 ERROR! The server quit without updating PID file (/usr/local/var/mysql/henease.local.pid).
```
### 存在权限问题
　　发现报“The server quit without updating PID file”错误。根据“Permission denied”推测可能是访问权限的问题，于是看看对应文件夹都有些啥。
```bash
bash-3.2$ cd /usr/local/var/mysql/
bash-3.2$ ls
auto.cnf           henease.local.err   mysql               server-key.pem     
ca-key.pem         ib_buffer_pool      performance_schema  sys
ca.pem             ib_logfile0         private_key.pem     
client-cert.pem    ib_logfile1         public_key.pem      
client-key.pem     ibdata1             server-cert.pem
```
　　嗯，有很多，包括那个报错“Permission denied”的henease.local.err文件。再看一下每个文件的拥有者信息。
```bash
bash-3.2$ ls -laF /usr/local/var/mysql/
total 357144
drwxr-xr-x   19  henease   admin       646    6      24   23:58   ./
drwxrwxr-x   10  henease   admin       340    6      24   21:10   ../
-rw-r-----    1  henease   admin        56   12       1    2016   auto.cnf
-rw-------    1  henease   admin      1676   12       1    2016   ca-key.pem
-rw-r--r--    1  henease   admin      1075   12       1    2016   ca.pem
-rw-r--r--    1  henease   admin      1079   12       1    2016   client-cert.pem
-rw-------    1  henease   admin      1676   12       1    2016   client-key.pem
-rw-r-----    1  _mysql    admin   2459473    6      24   22:47   henease.local.err
-rw-r-----    1  henease   admin       478    6      24   23:40   ib_buffer_pool
-rw-r-----    1  henease   admin  50331648    6      24   23:40   ib_logfile0
-rw-r-----    1  henease   admin  50331648   12       1    2016   ib_logfile1
-rw-r-----    1  henease   admin  79691776    6      24   23:40   ibdata1
drwxr-x---   77  henease   admin      2618   12       1    2016   mysql/
drwxr-x---   90  henease   admin      3060   12       1    2016   performance_schema/
-rw-------    1  henease   admin      1676   12       1    2016   private_key.pem
-rw-r--r--    1  henease   admin       452   12       1    2016   public_key.pem
-rw-r--r--    1  henease   admin      1079   12       1    2016   server-cert.pem
-rw-------    1  henease   admin      1680   12       1    2016   server-key.pem
drwxr-x---  108  henease   admin      3672   12       1    2016   sys/
```
### 处理
　　发现henease.local.err的拥有者不一样，其他的都是henease，只有它是_mysql，所以此时应该有两条路可走
> * 更改henease.local.err的拥有者
> * 根据henease.local.err的文件信息，删除掉应该不会有什么影响，所以尝试先在/tmp内备份一份后删除它

### 结果
　　我尝试了第二种方式，之后再次启动mysql。
```bash
bash-3.2$ mysql.server start
Starting MySQL
 SUCCESS！
```
　　启动成功了！进入mysql看看。
```bash
bash-3.2$ mysql -uroot -p
Enter password:
Welcome to the MySQL monitor.  Commands end with ; or \g.
Your MySQL connection id is 2
Server version: 5.7.16 Homebrew

Copyright (c) 2000, 2016, Oracle and/or its affiliates. All rights reserved.

Oracle is a registered trademark of Oracle Corporation and/or its
affiliates. Other names may be trademarks of their respective
owners.

Type 'help;' or '\h' for help. Type '\c' to clear the current input statement.

mysql>
```
　　可以了，一切正常。
### 参考
　　出现错误的时候，照着错误提示信息一步步处理应该问题不大，当然在Stack Overflow上也有类似的问题，比如
[mysql-server-startup-error-the-server-quit-without-updating-pid-file](https://stackoverflow.com/questions/4963171/mysql-server-startup-error-the-server-quit-without-updating-pid-file)，里面有一个答案的处理方式和我一样，可以作为参考。