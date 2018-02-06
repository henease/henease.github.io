---
title: Java_API CTP结算单乱码处理
date: 2018-2-6 19:43:34
categories: C++
tags: [JNI,C++,CTP]
---

![](http://orujzh93n.bkt.clouddn.com/jni.png)<!-- more -->

　　最近有个需求是要得到期货公司手续费，看了CTP的接口文档，貌似并没有这个接口，后来重新翻了一次，发现OnRspQrySettlementInfo方法会返回结算单消息正文TThostFtdcContentType Content ，于是打印了一下，发现确实可以从结算单里拿到手续费。但是有两个问题，1、返回的数据是分多次发送的，需要拼接，不过这一点可以通过bIsLast进行识别；2、拿到的结算单数据是乱码，因为CTP貌似采用的是GB2312编码 。所以我需要将拿回的结算单进行转码，要做到这一点，就需要添加JNI的转换代码。

#### 操作

　　CTP的的api是C++的，当初是通过swig得到jar包，并且封装C++动态库的，但是当时并没有考虑转码的问题，所以需要添加转码操作。这里有一篇文章是关于linux下CTP Java API编译的（[点这里](http://blog.csdn.net/pjjing/article/details/53187469)）。现在linux下的文件像这样：

![](http://orujzh93n.bkt.clouddn.com/tradewrap.jpg)

##### makefile

　　这里需要做修改是makefile和thosttraderapi_wrap.cpp，makefile修改相对简单，添加下面红框部分即可。

![](http://orujzh93n.bkt.clouddn.com/makefile.jpg)

　　因为这里需要libiconv库进行转码。

##### thosttraderapi_wrap.cpp

　　之后就是修改thosttraderapi_wrap.cpp这个文件，在文件里找到Java_jctp_api_thosttradeapiJNI_CThostFtdcSettlementInfoField_1Content_1get这个方法，在方法上面添加下图所示的引入。

![](http://orujzh93n.bkt.clouddn.com/include.jpg)

　　图中有一些引入是之前写的，后来某些函数用不到了也没有删。然后对方法进行适当的修改，我是通过iconv的函数进行转码的，这个转换库的资料相对来说还是挺少的，这里有一篇还不错（[点这里](http://blog.csdn.net/fengmm521/article/details/78438687)）。因为不太懂C++，所以专门学习了下C++的语法，然后写了转换代码：

```c++
SWIGEXPORT jstring JNICALL
Java_jctp_api_thosttradeapiJNI_CThostFtdcSettlementInfoField_1Content_1get(JNIEnv *jenv, jclass jcls, jlong jarg1, jobject jarg1_) {
  jstring jresult = 0 ;
  CThostFtdcSettlementInfoField *arg1 = (CThostFtdcSettlementInfoField *) 0 ;
  char *result = 0 ;

  (void)jenv;
  (void)jcls;
  (void)jarg1_;
  arg1 = *(CThostFtdcSettlementInfoField **)&jarg1;
  result = (char *) ((arg1)->Content);

  if(result) {
     size_t inlen = strlen(result);
     iconv_t cd;
     cd = iconv_open("UTF-8//TRANSLIT//IGNORE", "GB2312");

     char *outbuf = (char *)malloc(inlen * 4);
     if(outbuf==NULL){
        jresult=jenv->NewStringUTF((const char *)result);
     } else {
        memset(outbuf,0,inlen * 4);
        char *in = result;
        char *out = outbuf;
        size_t in_len = inlen;
        size_t out_len = inlen * 4;
        iconv(cd, &in, &in_len, &out, &out_len);
        jresult = jenv->NewStringUTF((const char *)outbuf);
        free(outbuf);
     }
     iconv_close(cd);
  }
  return jresult;
}
```

　　这里通过malloc分配内存，所以最后记得用free释放一下。考虑到转换后空间不足的问题，我直接inlen \* 4粗暴地分配了，保证有足够的转换空间。然后我忽略了iconv(iconv_t cd,  char \* \* inbuf, size_t \* inbytesleft,   char\* \* outbuf, size_t \* outbytesleft)的errno的处理，而是直接在iconv_open时添加了//TRANSLIT//IGNORE，这里//TRANSLIT和//IGNORE的使用，网上介绍iconv时说的比较少，他们可以单独使用，也可以串联起来使用，表示在转码不支持时采用近似的编码，不行的话直接忽略。我的转换代码并不是非常严谨，不能保证所有字节都完全正常转换，但结果是符合我的预期的，几乎没有缺失和乱码。
　　做完上述更改后，make重新编译一下，将libthosttraderapi_wrap.so这个动态库复制到你的java.library.path下面，如果不知道的话，可以System.getProperty("java.library.path")看一下，然后通过System.loadLibrary()加载，这样就完成了转码操作。

##### iconv库

　　整个转码中，最重要的就是iconv库，如果环境里没有的话需要自己编译，具体可以[看这里](https://www.gnu.org/software/libiconv/)，linux环境下已经有这个库的，也许还需要做一下软连接，具体的可以看问题进行处理，这里就不说了。

#### 注意点

　　在修改makefile和thosttraderapi_wrap.cpp时记得做备份，libthosttraderapi.so和libthosttraderapi_wrap.so这两个动态库也做下备份，方便修改和复原。