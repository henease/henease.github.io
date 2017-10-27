---
title: DWZ-jui局部刷新分页的即时刷新问题
date: 2017-08-18 17:10:56
categories: dwz
tags: [ajax,dwz]
---
　　![](http://orujzh93n.bkt.clouddn.com/%E5%81%9A%E4%BA%BA%E8%A6%81%E9%9D%A0%E8%87%AA%E5%B7%B1.jpg)<!-- more -->
### 碰到的问题
　　这两天一直在做后台，用的是[dwz富客户端框架](http://jui.org/#main.html)，这个框架上手比较简单，文档也就30多页，官网上也有demo页面。官方说只要做html扩展就可以了，js和ajax之类的操作基本都制定好了，但是实际开发的过程中发现还是有些问题的，基于体验的问题，感觉还是需要自己做一些自定义。比如在对局部刷新分页做新增修改和删除时，源代码无法做到即时刷新页面数据。
　　![](http://orujzh93n.bkt.clouddn.com/%E6%96%B0%E5%A2%9E%E5%92%8C%E4%BF%AE%E6%94%B9%E6%8C%89%E9%92%AE.png)
　　比如，点击上图中的新增配置和修改配置时，新增或者修改成功后，页面数据并不会即时刷新，体验非常差，于是我打算自己做一些自定义，实现即时刷新。在google上搜索了一些办法，基本没有几个说的让人满意的（也有可能是我的搜索能力问题）。于是自己看源码研究，尝试自己改进这个问题。
### 研究源码
　　发现在源码中，表单form在提交后，会对应到action指定的映射进行处理，然后后台返回json数据，onsubmit对应的函数对返回的json数据进行处理，做出相应的动作，这是一个很常见的逻辑。
　　![](http://orujzh93n.bkt.clouddn.com/%E5%8E%9F%E5%85%88%E5%9B%9E%E8%B0%83%E5%87%BD%E6%95%B0dialogAjaxDone.png)
　　可以看到，源码中对应的处理函数是dialogAjaxDone，点进去看看具体是怎么个逻辑。
　　![](http://orujzh93n.bkt.clouddn.com/dialogAjaxDone%E5%87%BD%E6%95%B0.png)
　　可以看到，源码中其实一直都是针对navTab进行操作的，并不适用于局部刷新分页，所以应该要自定义一个函数来处理局部刷新分页新增和修改的ajax操作。再回到页面，发现其中一个html文件中对应一个id为jbsxBox（jbsx为局部刷新的拼音首字母）的div，其实这就是页面最右侧的部分，在另一个html文件中对应一个rel为jbsxBox的div，数据回填后呈现在id为jbsxBox的div部分。
　　![](http://orujzh93n.bkt.clouddn.com/jbsxBox%E7%9A%84id.png)　　
　　![](http://orujzh93n.bkt.clouddn.com/rel%E4%B8%BAjbsxBox%E7%9A%84table%E6%95%B0%E6%8D%AE.png)
### 自定义函数　　
　　所以可以将onsubmit对应的回调函数进行自定义，我把这个函数上提到dwz.util.js中。
　　![](http://orujzh93n.bkt.clouddn.com/onsubmit%E6%9B%B4%E6%94%B9%E5%9B%9E%E8%B0%83%E5%87%BD%E6%95%B0.png)
　　函数内容为：
　　![](http://orujzh93n.bkt.clouddn.com/%E5%B0%86%E5%87%BD%E6%95%B0%E4%B8%8A%E6%8F%90%E5%88%B0dwz.util.js%E6%96%87%E4%BB%B6.png)
　　从后台返回jbsxBox的navTabId和页面forwardUrl，对其进行异步刷新。同时注意更新index.html页面中引入的dwz.util.js版本。
### 删除操作的ajax处理
　　上面说的是针对target为dialog的ajax处理，对于像target为ajaxTodo的操作，又该如何处理呢？查看dwz.ajax.js文件，可以发现，对于ajaxTodo类型的操作，它会去找删除操作中&lt;a&gt;的callback属性，callback定义一个回调函数，如果没有这个属性的话，默认去执行navTabAjaxDone。所以我们需要自定义一个callback，由于删除操作只做一次，所以回调函数就直接写在页面里了。代码如下：
``` javascript
    <![CDATA[
    function deleteAjaxCallback(json) {
        DWZ.ajaxDone(json);
        if (json[DWZ.keys.statusCode] == DWZ.statusCode.ok){
            if(json.navTabId && json.forwardUrl) {
                $("#"+json.navTabId).ajaxUrl({url:json.forwardUrl});
            }
        }
    }
    ]]>
```
　　这里的&lt;![CDATA[和]]&gt;不能省略，否则会报语法错误，因为&符号会被解析器当作新元素的开始。