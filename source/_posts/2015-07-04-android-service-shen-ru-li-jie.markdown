---
layout: post
title: "Android详细理解Service"
date: 2015-07-04 21:16:11 +0800
comments: true
categories: Android
---

#Service
官方文档给出的解释为。Service是一个无界面，长时间在后台运行的应用组件。
其他的应用组件可以启动一个Service，即使用户切换到其他应用后Service任然在后台运行。
另外，组件可以通过绑定(Bind)的方式与Service进行交互，甚至使用Interprocess Communication(IPC)的方式。

Service基本上可以采取两种形式：

Started

当一个组件调用startService()方法后，Service将启动。一旦被启动，无论启动它的组件是否被销毁，Service都会在后台运行。
这种方式通常为了执行一个单独的操作，并且我们不需要Service返回状态。

Bound

当一个组件调用bindService()方法后，Service提供了一个接口使得可以与组件进行交互。包括发送请求，获得结果，甚至进程间通信IPC。

一般会分开讨论这两种Service的启动类型，但我们可以使Service在这两种方式下运行。这取决于你是否实现了一对回调方法：onStartCommand()允许组件启动；onBind()允许组件绑定。

`值得注意的是Service是运行在主线程中的，这意味着Service不能创建它自己的线程，也不能运行在其他进程中（除非特别指定）。一旦你需要做一些消耗CPU的工作或者阻塞操作，你应该在Service中创建一个新的线程去完成。`

**何时使用Service或者Thread：**Service因为是Android中的一个组件，会一直在后台运行，请确认是否需要一个常驻的功能。Thread通常是处理一个异步的任务，任务执行完就不再需要，它避免阻塞主线程。

#Service常用基类
###Service
这是所有服务类的基类，继承该类，对于在服务中创建新线程很重要。因为默认服务使用应用的主线程，可能会降低程序的性能。
###IntentService
这是一个Service的子类，该子类使用线程处理所有启动请求，一次一个。这是不使用服务处理多任务请求的最佳选择。你需要做的只是实现onHandleIntent()方法即可。可以为每个启动请求接收到intent，放到后台工作即可。
内部使用一个Handler和Looper来实现子线程处理.

#Service生命周期
###未绑定的服务
startService() -> onCreate() -> onStartCommand() -> 运行服务 -> 停止 -> onDestroy() -> 服务关闭

###绑定的服务
bindService() -> onCreate() -> onBind() -> 客户端绑定到服务 -> 客户端调用unbindService() -> onUnbind() -> onDestroy() -> 服务关闭

#自动启动Service
通常的办法是实现一个BroadcastReceiver，监听ACTION_BOOT_COMPLETED即可，并在接收完该广播后通过AlarmManager轮询发送自定义广播，再通过另一个BroadcastReceiver启动Service。

如果通过某种方式将整个进程杀死，所有的服务也会被杀死，此时将无法定期启动服务了。要想达到即使杀死了也可以自动启动服务，需要注册一个系统级别的BroadcastReceiver。