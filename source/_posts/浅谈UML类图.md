---
title: 浅谈UML类图
date: 2017-10-10 09:43:34
categories: UML
tags: UML
---

![](http://orujzh93n.bkt.clouddn.com/uml.png)<!-- more -->

　　[UML](https://zh.wikipedia.org/wiki/%E7%BB%9F%E4%B8%80%E5%BB%BA%E6%A8%A1%E8%AF%AD%E8%A8%80)（Unified Modeling Language），是一种开放的方法，用于说明、可视化、构建和编写一个正在开发的、面向对象的、软件密集系统的制品的开放方法（来自维基百科）。在很多技术书籍中，都能看到它的身影，很多时候我们都会忽略它，而实际上只要稍加学习，了解其基本知识，就会发现其实读UML类图远比看文字来的更深刻。好了，现在就来浅谈一下UML类图吧。

### 类和接口的UML类图

#### 类的表示

```java
public Class Programmer {
    private String sex;
    private String language;
    public void write(){
      //writing code with language
    }
}
```

　　像上面这样一个类，用UML类图表示就如下图所示：

![](http://orujzh93n.bkt.clouddn.com/UML__Programmer.png)

　　其中第一行为类名，如果该类是抽象类，则这一行的字体为斜体；第二行为类的属性，第三行为类的方法。而属性前面的“-”号表示该属性由private修饰，如果为public，则用“+”，如果为protected，则用“#”。方法write前面的“+”号类同，表示该方法由public修饰。这里这个类图表示的是一般情况下的类，如果一个类包含有内部类，则还有第四行，这里就不展开了。

#### 接口的表示

``` java
public interface Car {
    void run();
}
```

　　该接口的UML类图如下：

![](http://orujzh93n.bkt.clouddn.com/UML_drive.png)

　　在接口中，通常没有属性，而且操作都是抽象的，只做了操作的声明（Java8中添加了默认方法），没有操作的实现。这里的类图中，接口名上方有“&lt;&lt;interface&gt;&gt;”，表示接口，这种表示方法又称矩形表示法或者内部视图。除此之外，还有一种在其他类实现该接口时的表示方法，如下所示：

![](http://orujzh93n.bkt.clouddn.com/UML_Mazda.png)

　　这里的圈圈就表示Mazda类继承了的接口，暂且认为是Drive接口，这个接口里有run()方法。用一个圈圈表示接口，这种方法有一个很有趣的叫法：棒棒糖表示法，也叫外部视图。

### 类图中的关系

#### 泛化关系

　　所谓的泛化关系（Generalization），其实就是我们平常所说的继承关系。在UML中，泛化关系用空心三角形的直线来表示，其中空心三角形一头指向父类：

![](http://orujzh93n.bkt.clouddn.com/UML_%E7%BB%A7%E6%89%BF.png)

#### 实现关系

　　实现关系（Realization），类实现了特定的接口，重写了接口中的方法。在UML中，我们用带三角形的虚线表示这种关系，其中三角形箭头指向接口：

![](http://orujzh93n.bkt.clouddn.com/UML_%E5%AE%9E%E7%8E%B0.png)

#### 关联关系

　　关联关系（Association），指的是一种拥有的关系，通俗一点说就是一个类“知道”另一个类的属性和方法。在UML类图中，用带箭头的实线表示这种关系，其中箭头指向被拥有者：

![](http://orujzh93n.bkt.clouddn.com/UML_st__te.png)

![](http://orujzh93n.bkt.clouddn.com/UML_st_co.png)

　　上面两幅图就分别表示多对多和1对多的关联关系，一个学生可以有多个老师，一个老师也可以有多个学生，一个学生可以修多门课程（但是课程不能拥有学生，这一点希望能对应到现实中加以理解）。这里有一点要说明，多对多关系时，可以双向都有箭头，也可以没有箭头，直接用直线连接。

　　此外，关联关系还有一种自相关，表示一个类的属性对象类型为这个类本身，比如数据结构里的链表（见《Java数据结构与算法》），如下图：

![](http://orujzh93n.bkt.clouddn.com/UML_sub.png)

#### 聚合关系

　　聚合关系（Aggregation），指的是整体与部分的关系，部分可以离开整体单独存在，它表示的是一种弱的拥有关系。比如停车场和汽车，雁群和大雁，汽车和轮胎（这个可能较难理解哈）等。聚合关系用带空心菱形和箭头的实线表示，其中菱形指向整体，箭头指向部分：

![](http://orujzh93n.bkt.clouddn.com/UML_park__car.png)

#### 合成关系

　　合成关系（Composition），也叫做组合关系，表示的也是整体与部分的关系，但与聚合关系不同的是，它表示的是一种强的拥有关系，部分不能离开整体单独存在。比如公司和公司底下的各个部门，一个部门不能离开公司单独存在，而有了公司才会有部门。在合成关系里，整体负责部分的生命周期。在UML类图中，合成关系用带箭头和实心菱形的实线表示，其中菱形指向整体，箭头指向部分：

![](http://orujzh93n.bkt.clouddn.com/UML_com_dep.png)

#### 依赖关系

　　依赖关系（Dependency），指的是一个类的实现需要另一个类的协助，比如人要活着，就要依赖氧气，依赖水，依赖食物。在UML类图中，用带箭头的虚线表示这种关系，其中箭头指向被使用者。

![](http://orujzh93n.bkt.clouddn.com/UML_hu_wa.png)

　　大多数情况下，依赖关系体现在某个类的方法使用另一个类的对象作为参数，比如驾驶员（Driver类）开车（Car类），drive()方法中会将Car类型的对象car传入，然后在drive()方法中调用car的run()方法。

### 总结

　　我在上面阐述各种关系时尽量贴近生活去举例，方便大家理解。但是在实际读图时，可能很多时候会比单单看一种关系图来的复杂得多，但是万变不离其宗，掌握UML类图的基本知识，多看多练，举一反三，我们就能清晰地读懂类和类之间的关系，理清它们的代码表现。最后以一张《大话设计模式》的图来结束本文。

![](http://orujzh93n.bkt.clouddn.com/UML_whole.png)







