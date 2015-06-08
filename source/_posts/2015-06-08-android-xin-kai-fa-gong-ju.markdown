---
layout: post
title: "Google I/O回顾:Android开发工具的新玩意"
date: 2015-06-08 12:52:33 +0800
comments: true
categories: Android
---

每年我们都在期待Google I/O大会中Android相关的新东西。然而，在线看视频简直太花时间了（拜GFW所赐还得使用一些小手段观看）。
这篇文章对整个视频做了总结，希望可以帮到大家。

#Easing Design

![1433733652.png](http://www.openwudi.com/images/2015/1433733652.png)

[Android Design Support Library](http://android-developers.blogspot.co.at/2015/05/android-design-support-library.html)
可以帮你遵循最新的Material Design风格。这个库包含了一系列Material Design组件，
例如Navigation Drawer、Floating Labels for Editing Text、Floating Action Buttons和Snackbar，
所有的组件都兼容Android 2.1以上版本。

![1433733704.png](http://www.openwudi.com/images/2015/1433733704.png)

Android L已经介绍了Vector Drawables。随着Android Studio 1.3更改了Android Gradle插件，我们可以使用编译系统通过SVG和Vector Drawables生成不同dp的raster图像。

最终，开发工具团队开始重写了整个可视化设计编辑器、它帮你实现更多所见即所得的方式。

#Improving the Grade Plugin & Build System

![1433736364.png](http://www.openwudi.com/images/2015/1433736364.png)

Android Gradle插件有时会靠不住，特别是它作为依赖管理，相关问题已经得到了修复。

Android Gradle插件最令人纠结的当然是超长的编译时间。工具团队从多个层面去解决这个问题。
[Jack](http://tools.android.com/tech-docs/jackandjill)，Java Android Compiler Kit的缩写，
它将Java源码直接编译成Android的Dex文件格式。它是基于Eclispse Java编译器的，这个过程减少了一步。换句话说就是，不需要在转成Dex前编译成JVM字节码。另外，它还支持增量编译。

压缩处理PNG图片同样花费了巨大的时间。工具团队已经提升了这方面的性能，将500张PNG和.9图从4秒减低到400毫秒。

aapt(Android Asset Packaging Tool)，负责打包所有的Dex和资源文件，同样也得到了优化。

另外一个开销是因为Gradle自己造成的，当Gradle开始编译Android项目的时候，它不得不创建一个模块去描述variants(flavor + build type)，
即使只打算构建一个，它也会解析所有variants的依赖。并且它会执行自定义的逻辑。开发团队使用Gradle Ware优化了这些步骤。这是结果：

![1433743364.png](http://www.openwudi.com/images/2015/1433743364.png)

当然，还没有说完。开发工具团队正在致力于新的Android Gradle插件，它基于Gradle Ware新的API。
新的API允许Gradle直接管理模块，并且可以让它做一些事情，比如缓存、并行和增量构建。这是下一代插件的结果：

![1433744540.png](http://www.openwudi.com/images/2015/1433744540.png)

这些数字并不包括缓存的优化，因为它还没开发完成。但它有一个小缺点，就是新插件使用新的DSL，而且还不能向下兼容。预览版将在几周后放出，但是正式版可能会在年末。

开发工具团队也介绍了一个Data Binding Library。它需要构建系统的支持，因为它会从XML文件声明中生成Java源文件。老版和新版的Android Gradle插件都可以支持。Android Studio还开始支持C/C++进行NDK开发。

#Testing
![1433747802.png](http://www.openwudi.com/images/2015/1433747802.svg)

今年Android测试新发布了[Cloud Test lab](https://developers.google.com/cloud-test-lab/)。
它允许你使用Google测试云上的虚拟设备和物理设备进行app测试。并支持自动抓取，不需求自己写用例，当然如果你愿意也是支持的。

#Emulator

![1433748302.png](http://www.openwudi.com/images/2015/1433748302.png)

模拟器上并没有什么太多的变化，开发工具团队主要致力于稳定、正确性和可配置。Android Studio将下载并安装HAXM，性能上有很大的提升。
Android Auto模拟器中将会提供指纹识别的支持。

#New Support Annotations

![1433748585.png](http://www.openwudi.com/images/2015/1433748585.png)

Java注解可以在编译和运行时进行很多神奇的事情。新增了13种注解可以帮助你避免一些Bug。

例如，@WorkerThread注解。方法中声明此注解会自动检查代码是否在UI线程。Android Studio会高亮显示错误。

另一个例子是，@RequiresPermission。一旦你使用的API没有在manifest文件中声明权限，Android Studio将会提醒你插入权限。
在Android M中权限控制有了一些变化，用户可以选择同意和拒绝某种权限，这意味着你的代码不得不去处理拒绝后的逻辑。
Android Studio将自动产生一个代码块帮助你完成这件事。

#Data Binding

![1433750019.png](http://www.openwudi.com/images/2015/1433750019.png)

这个可能是给开发者印象最深的变化。当你开发Android的UI时，通常使用findViewByID()查找XML文件中的布局，并将Java POJO填充到里面。
Data Binding库可以让这个操作变简单。你可以声明POJO类型，变量表达式引用POJO，以及监听XML文件的布局，用来代替原来手动的操作。
在编译时期，构建系统会生成绑定的Java类，关联你的布局和POJO。

使用它只需要两步：POJO实现`android.databindings.Observable`接口，改变POJO则会反射到UI，反之亦然。
Data Binding库当前还属于beta阶段，需要Android Studio 1.3版本和最新的Gradle插件。更多内容请参考
[https://developer.android.com/tools/data-binding/guide.html](https://developer.android.com/tools/data-binding/guide.html)

#Profiling Tools

![1433770237.png](http://www.openwudi.com/images/2015/1433770237.png)

这个内存和性能分析工具做了一些优化。你现在可以查看在Android Studio中堆和方法路径的快照，通过一个下拉的界面，你可以发现问题在哪。
它还能可视化的查看和跟踪，你不需要手动的生成[HPROF](http://docs.oracle.com/javase/7/docs/technotes/samples/hprof.html)文件。

![1433770818.png](http://www.openwudi.com/images/2015/1433770818.png)

现在内存快照是下拉显示的，看起来非常简洁。通过调试器可以查看当前的对象。它也可以让你去追踪引用链直到GC的根节点，这样你就可以知道谁持有了垃圾的引用。

#New Features in Upcoming Releases

![1433771186.png](http://www.openwudi.com/images/2015/1433771186.png)

这个新的视觉设计器暂时还没加入到Android Studio 1.3版本。令人兴奋的是，它减轻了创建UI的负担。上图展示了一个新的主题编辑器，让你通过可视化查看和修改主题文件。
并且可以预览该主题的UI控件。

![1433773948.png](http://www.openwudi.com/images/2015/1433773948.png)

布局编辑器也加入了一些新的功能，上图蓝色的部分可以让你只关注UI的布局。它还提供通过拖拽的方式修改组件。

![1433774256.png](http://www.openwudi.com/images/2015/1433774256.png)

XML预览模式已经被扩展到可以显示系统参数，但是最重要的特点是通过所见即所得的方式直接在预览窗口进行编辑，包括从工具面板拖拽控件。