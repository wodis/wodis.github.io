---
layout: post
title: "Android开发中的MVVM模式"
date: 2015-06-01 18:27:14 +0800
comments: true
categories: Android
---

从去年开始我们的Android项目就已经从传统的MVC架构切换为Model-View-Presenter（MVP）架构，使得整个分层更加清晰。
Presenter作为整个逻辑的控制者，与Controller的区别在于它并不包含任何的显示逻辑，只处理网络请求和数据填充操作，
并通知View何时更新，当View收到更新请求，将数据根据需求展示在不同View中。

今年的Google IO为Android开发者介绍了一个非常棒的新框架，允许将视图绑定（Binding）到任意对象的成员变量上。
当成员变量更新，框架会通知视图 **自动更新**。

这个系统相当强大，让我们可以使用一种在Windows世界常见的开发模式Model-View-ViewModel (MVVM)。
我们先熟悉一下基本的概念，对于整个架构的理解很重要，并且看它如何使你的app更好。

MVVM设计模式包含3部分：

* Model – 表示你的业务逻辑
* View – 显示的内容
* ViewModel – 将View和Model联系到一起

ViewModel接口做两件事：行为(Actions)和数据(Data)。行为改变底层的模型（点击事件，文本变化事件等），数据则表示这个模型的内容。

例如，一个拍卖系统的ViewModel数据可能是图片、标题、描述和价格。行为可能是竞拍、购买、或者联系卖家。

传统的Android架构中，控制器（Controller）将数据直接赋值给View，再从Activity中找到View，更新内容。
使用MVVM模式，ViewModel改变内容并通知绑定（Binding）框架内容已经变化。框架将会自动更新被绑定的View。
这两个容器只通过数据接口和命令进行松散耦合。

除了看起来智能的View绑定，也让测试变得方便。

因为ViewModel并不依赖于View，你可以只测试一个ViewModel，甚至不需要View存在。通过适当的依赖注入，测试就很简单了。

希望你已经理解了MVVM模式的基本概念，并且已经了解使用它的好处。后续我会发布实现MVVM的代码，和一些绑定框架的使用技巧。

参考资料：

1. [Comparison of Architecture presentation patterns MVP(SC),MVP(PV),PM,MVVM and MVC](http://www.codeproject.com/Articles/66585/Comparison-of-Architecture-presentation-patterns-M)
2. [Introduction to Model-View-Presenter on Android](http://konmik.github.io/introduction-to-model-view-presenter-on-android.html?utm_source=Android+Weekly&utm_campaign=5589504b56-Android_Weekly_148&utm_medium=email&utm_term=0_4eb677ad19-5589504b56-337845481)