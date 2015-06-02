---
layout: post
title: "Android开发中提升Gradle性能"
date: 2015-06-02 11:42:39 +0800
comments: true
categories: Android
---

是不是感觉一整天都在等着Android Studio编译完成？我也是

幸亏现在有方法让编译速度提升一些。虽然这些操作仍然有一定的风险，但还是值得尝试一下。
当我修改了一小部分的代码后，使用这个方法，编译速度直接减少了2.5秒。

Android现在通常使用Gradle进行编译。发布这篇文章的时候，默认的Gradle版本是2.2。
最新的为2.4，它比之前的版本已经有了很大的提升。

有两种方法配制新版Gradle，直接手动修改build脚本，或者更改Android Studio的配置。

1.手动修改build脚本，通过在项目根目录的build.grade中添加以下代码


    task wrapper(type: Wrapper) {
        gradleVersion = '2.4'
    }

现在打开终端并且运行./gradlew，它会自动下载并安装Gradle 2.4作为本地版本。
[官方文档](http://gradle.org/docs/current/userguide/gradle_wrapper.html)

2.如果打算修改Android Studio的配制，需要打开Project Structure Dialog（OS X: ⌘+;），
在左边的列表中选择Project，然后修改Gradle version为2.4。单击OK，Android Studio会自动安装和同步Gradle的配置。

![1433219043.png](http://www.openwudi.com/images/2015/1433219043.png)

下一步是确保Gradle守护进程和并行编译可用。使用守护进程编译速度会提高，因为它并不会每次都编译完整的项目。
并行编译会将项目分成多模块编译，这样可以提升大型多模块项目的编译速度。

当然这些设置需要添加到.gradle目录的gradle.properties中。(i.e., ~/.gradle/gradle.properties)

    org.gradle.daemon=true
    org.gradle.parallel=true

守护进程已经在Android Studio中开启，这样做是为了在终端中使用。

注意：并行编译可能导致一些项目不安全。原因是需要你所有的项目是解耦的，不然会编译失败。[多模块编译](http://gradle.org/docs/current/userguide/multi_project_builds.html#sec:decoupled_projects)
认真测试所有的build variants，保证都可以正常工作。

添加以下代码可以增加JVM的最大堆内存：

    org.gradle.jvmargs=-Xmx768m
    org.gradle.java.home=/path/to/jvm

其他的gradle.properties配制，可以参考[官方文档](http://gradle.org/docs/current/userguide/userguide_single.html#sec:gradle_configuration_properties)。

最后的更改是增量打包dex，这是一个实验性的功能，默认是不开启的。它可能会导致你编译失败，但是还是建议你去试一下，看看你能否使用。

增加以下代码到app模块的build.gradle中：

    dexOptions {
            incremental true
    }

如果你有其他的技巧欢迎与我交流。