---
title: 使用ORDER BY和LIMIT分页时的数据重复问题
date: 2018-02-09 00:17:35
categories: mysql
tags: [mysql,sql]
---
![](http://orujzh93n.bkt.clouddn.com/its.jpg)<!-- more -->

#### 原因分析

　　今天测试在看板上给我提交了一个bug，他发现在翻页时，下一页会出现上一页出现过的数据。那么这是怎么回事呢？先看一下我的sql语句：

``` sq
SELECT * FROM tb_settlement ORDER BY type,code LIMIT offset,pageSize
```

　　好像没有啥问题，但是既然出现重复数据，那很显然就是LIMIT分页语句没有生效，或者未按我预想的方向生效。仔细想一下，这条sql语句的预想结果是首先根据ORDER BY先后按type和code进行排序，然后取出指定偏移位置之后的数据。但是事实并没有按这种结果显示，所以第一猜测就是ORDER BY和LIMIT之间没有协同好。

#### MySQL官方手册说明

　　我的mysql版本是5.6的，所以我查询了mysql5.6版本的官方手册，下面是ORDER BY和LIMIT的说明：

　　1、[ORDER BY Optimization](https://dev.mysql.com/doc/refman/5.6/en/order-by-optimization.html#order-by-filesort-in-memory)

　　2、[LIMIT Query Optimization](https://dev.mysql.com/doc/refman/5.6/en/limit-optimization.html)

##### LIMIT的用法说明

　　我们先不看ORDER BY，而是先看一下LIMIT的用法。

> If you combine `LIMIT`  *row_coun* with `ORDER BY`, MySQL stops sorting as soon as it has found the first *row_count* rows of the sorted result, rather than sorting the entire result. If ordering is done by using an index, this is very fast. If a filesort must be done, all rows that match the query without the `LIMIT` clause are selected, and most or all of them are sorted, before the first *row_count* are found. After the initial rows have been found, MySQL does not sort any remainder of the result set.

　　这里主要的意思是说ORDER BY和LIMIT结合使用时，mysql在排序到LIMIT指定的数时就不会继续对之后的数据进行排序了，似乎对我们的问题没有多少帮助。接着往后看：

> If an index is not used for `ORDER BY` but a `LIMIT` clause is also present, the optimizer may be able to avoid using a merge file and sort the rows in memory using an in-memory `filesort` operation. For details, see [The In-Memory filesort Algorithm](https://dev.mysql.com/doc/refman/5.6/en/order-by-optimization.html#order-by-filesort-in-memory).

　　这句话似乎终于说到我们关心的东西了，当我们对非索引的列使用ORDER BY时，优化器会进行in-memory的文件排序操作。继续看下一句话：

> If multiple rows have identical values in the `ORDER BY` columns, the server is free to return those rows in any order, and may do so differently depending on the overall execution plan. In other words, the sort order of those rows is nondeterministic with respect to the nonordered columns.

　　这里终于给我们下了个结论，当ORDER BY后的列出现重复值或者说相同值时，那这些数据就不会按确定的顺序列出，每次操作后显示的顺序可能并不一样。
　　到此可以舒口气了，不是我的bug，是mysql自己进行优化了。

##### ORDER BY的用法说明

　　接下来再来看看ORDER BY Optimization，其实在说到in-memory时，mysql就给出了in-memory的算法链接了，这个链接就是到ORDER BY Optimization页面的。

> MySQL has multiple `filesort` algorithms for sorting and retrieving results. The original algorithm uses only the `ORDER BY` columns. The modified algorithm uses not just the `ORDER BY` columns, but all columns referenced by the query. There is also an algorithm for small result sets that sorts in memory using the sort buffer as a priority queue without a merge file.

　　这里说，mysql其实有多种文件排序的算法，最初的算法是只根据ORDER BY指定的列排序，后来又修改为不只按ORDER BY指定的列，而是会把查询语句所有相关联的列都指定进来。而现在，对于小的结果集，mysql又采用priority queue来进行排序。
　　这里是这个算法的一些说明：

> The sort buffer has a size of [`sort_buffer_size`](https://dev.mysql.com/doc/refman/5.6/en/server-system-variables.html#sysvar_sort_buffer_size). If the sort elements for *N* rows are small enough to fit in the sort buffer (*M*+*N* rows if *M* was specified), the server can avoid using a merge file and performs an in-memory sort by treating the sort buffer as a priority queue:
>
> 1. Scan the table, inserting the select list columns from each selected row in sorted order in the queue. If the queue is full, bump out the last row in the sort order.
> 2. Return the first *N* rows from the queue. (If *M* was specified, skip the first *M* rows and return the next *N* rows.)
>
> Absent that optimization, the server performs this operation by using a merge file for the sort:
>
> 1. Scan the table, repeating these steps through the end of the table:
>    - Select rows until the sort buffer is filled.
>    - Write the first *N* rows in the buffer (*M*+*N* rows if *M* was specified) to a merge file.
> 2. Sort the merge file and return the first *N* rows. (If *M* was specified, skip the first *M* rows and return the next *N* rows.)
>
> The cost of the table-scan operation is the same for the queue and merge-file methods, so the optimizer chooses between methods based on other costs:
>
> - The queue method involves more CPU for inserting rows into the queue in order.
> - The merge-file method has I/O costs to write and read the file and CPU cost to sort it.
>
> The optimizer considers the balance between these factors for particular values of *M*, *N*, and the row size.
>
> An `ORDER BY` with and without `LIMIT` may return rows in different orders, as discussed in [Section 8.2.1.16, “LIMIT Query Optimization”](https://dev.mysql.com/doc/refman/5.6/en/limit-optimization.html).

　　上面主要对比了算法的排序开销，priority queue 使用了堆排序的排序方法，而堆排序是一种不是那么稳定的排序方法，对于相同的值可能排序出来的结果和读出来的数据顺序并不一致。

#### 解决方案

　　综上，我们知道了出现这个问题的原因，那么解决起来就容易了。为了修改这个bug，我们需要把type和code修改为索引列，或者在code后面再加一个带索引的列，比如id，这样就可以达到我们所期望的ORDER BY和LIMIT协同的结果。