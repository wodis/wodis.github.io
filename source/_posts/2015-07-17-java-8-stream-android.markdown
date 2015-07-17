---
layout: post
title: "Android开发中使用Java 8 Stream"
date: 2015-07-17 11:48:52 +0800
comments: true
categories: Android
---

你将从这篇文章中了解到什么是Stream，并且如何在Android开发中使用它。

不幸的是Android还不支持Java 8，Kitkat（Android 4.4+）以后的版本可以支持Java 7。
那么只能和新特性说再见了吗？当然不是，一些聪明人想出了一个解决办法：

[RETROLAMBDA](https://github.com/orfjackal/retrolambda)

#如何安装RETROLAMBDA
作为热身，让我们来看看如何快速的在项目中使用Retrolambda。
（假设你已经了解Android Studio的gradle构建系统以及它是如何工作的）

1.在./build.gradle文件中添加新的classpath:

![1437106139.png](http://www.openwudi.com/images/2015/1437106139.png)

2.在./app/build.gradle文件中添加Retrolambda插件:

![1437106186.png](http://www.openwudi.com/images/2015/1437106186.png)

3.还需要添加:

![1437106215.png](http://www.openwudi.com/images/2015/1437106215.png)

4.编译gradle

#STREAM
`A stream is an abstraction for specifying aggregate computations on a DataSet`

Java 8 Stream API引入的目的在于弥补Java函数式编程的缺陷。对于很多支持函数式编程的语言，map()、reduce()基本上都内置到语言的标准库中了，不过，Java 8的Stream API总体来讲仍然是非常完善和强大，足以用很少的代码完成许多复杂的功能。

创建一个Stream有很多方法，最简单的方法是把一个Collection变成Stream。我们来看最基本的几个操作：

    public static void main(String[] args) {
        List<Integer> numbers = Arrays.asList(1, 2, 3, 4, 5, 6, 7, 8, 9, 10);
        Stream<Integer> stream = numbers.stream();
        stream.filter((x) -> {
            return x % 2 == 0;
        }).map((x) -> {
            return x * x;
        }).forEach(System.out::println);
    }

集合类新增的stream()方法用于把一个集合变成Stream，然后，通过filter()、map()等实现Stream的变换。Stream还有一个forEach()来完成每个元素的迭代。

使用Stream的两个原因：

1.集合类会持有所有元素在内存中，大集合会占用大量内存。而Stream的元素是在访问的时候被计算出来，内存占用小。

2.二是集合类的迭代逻辑是调用者负责，通常是for循环，而Stream的迭代是隐含在对Stream的各种操作中，例如map()。

更多特性参考InfoQ的文章[Java 8新特性：全新的Stream API](http://www.infoq.com/cn/articles/java8-new-features-new-stream-api)

#Android中使用轻量级Stream API
上一部分介绍了Java 8 Stream的使用，但是我们的目的是讨论Android如何去使用这个特性。我们可以通过
[Lightweight-Stream-API](https://github.com/aNNiMON/Lightweight-Stream-API)，只需要增加它的classpath。

`compile 'com.annimon:stream:1.0.1'`

#JAVA 8 vs Lightweight-Stream-API（LSA）
虽然Java 8的Stream和LSA工作方式一样，但他们间仍有少量的区别。例如使用LSA创建Stream时使用Stream.of(YourCollection)，而Java 8中使用Stream<YourCollectionItem>。
另一个区别为排序操作，Java 8中使用‘sort()’，而LSA中使用‘sorted()’。