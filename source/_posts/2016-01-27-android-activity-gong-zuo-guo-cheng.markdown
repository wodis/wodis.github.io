---
layout: post
title: "Activity的工作过程"
date: 2016-01-27 11:52:26 +0800
comments: true
categories: android
---

从这篇文章开始将分析Android四大组件的工作过程,Activity作为最常用的组件,我们最先来分析.(源码使用API_LEVEL_15)

通常我们编写以下代码来创建一个Activity:

``` java
Intent i = new Intent(this, TestActivity.class);
startActivity(i);
```

#1.Activity
然后Activity通过一系列的生命周期展示在我们眼前,就以Activity的**startActivity**这个方法为入口，发现实际上都调用了**startActivityForResult**方法.

``` java
    public void startActivityForResult(Intent intent, int requestCode) {
        if (mParent == null) {
            Instrumentation.ActivityResult ar =
                mInstrumentation.execStartActivity(
                    this, mMainThread.getApplicationThread(), mToken, this,
                    intent, requestCode);
            if (ar != null) {
                mMainThread.sendActivityResult(
                    mToken, mEmbeddedID, requestCode, ar.getResultCode(),
                    ar.getResultData());
            }
            if (requestCode >= 0) {
                // If this start is requesting a result, we can avoid making
                // the activity visible until the result is received.  Setting
                // this code during onCreate(Bundle savedInstanceState) or onResume() will keep the
                // activity hidden during this time, to avoid flickering.
                // This can only be done when a result is requested because
                // that guarantees we will get information back when the
                // activity is finished, no matter what happens to it.
                mStartedActivity = true;
            }
        } else {
            mParent.startActivityFromChild(this, intent, requestCode);
        }
    }
```

这里的**mParent**代表一个ActivityGroup，已经被弃用了，所以我们只需要关系 mParent == null 这段逻辑。**Instrumentation**没有图形界面，拥有启动能力并可以监控其他类的工具类，通过**execStartActivity**方法启动一个Activity。**mMainThread.getApplicationThread()**可以获得一个ApplicationThread对象，它是ActivityThread的内部类，这两个类对Activity的启动非常重要，后面会继续分析。

#2.Instrumentation
现在分析一下execStartActivity方法。

``` java
    public ActivityResult execStartActivity(
            Context who, IBinder contextThread, IBinder token, Activity target,
            Intent intent, int requestCode) {
        IApplicationThread whoThread = (IApplicationThread) contextThread;
        if (mActivityMonitors != null) {
            synchronized (mSync) {
                final int N = mActivityMonitors.size();
                for (int i=0; i<N; i++) {
                    final ActivityMonitor am = mActivityMonitors.get(i);
                    if (am.match(who, null, intent)) {
                        am.mHits++;
                        if (am.isBlocking()) {
                            return requestCode >= 0 ? am.getResult() : null;
                        }
                        break;
                    }
                }
            }
        }
        try {
            intent.setAllowFds(false);
            int result = ActivityManagerNative.getDefault()
                .startActivity(whoThread, intent,
                        intent.resolveTypeIfNeeded(who.getContentResolver()),
                        null, 0, token, target != null ? target.mEmbeddedID : null,
                        requestCode, false, false, null, null, false);
            checkStartActivityResult(result, intent);
        } catch (RemoteException e) {
        }
        return null;
    }
```

这里我们只需要关心两个地方，一个是ActivityManagerNative.getDefault()的**startActivity**方法，另一个是**checkStartActivityResult(result, intent)**方法。

从方法名我们就可以看出**startActivity**是真实的实现，但是ActivityManagerNative是一个抽象类，ActivityManagerNative.getDefault()只返回一个继承自IInterface的IActivityManager接口。


``` java
static public IActivityManager getDefault() {
    return gDefault.get();
}
```

**checkStartActivityResult**用于检查Activity的合法性等操作。

#3.ActivityManagerService
ActivityManagerNative实现了IActivityManager接口，继承Binder，很明显这是一个Binder结构，**gDefault**是一个单例对象，在create初始化方法中调用**asInterface**进行绑定。ActivityManagerService则继承自ActivityManagerNative，拥有具体的实现。我们继续分析ActivityManagerService中的startActivity方法。

``` java
    public final int startActivity(IApplicationThread caller,
            Intent intent, String resolvedType, Uri[] grantedUriPermissions,
            int grantedMode, IBinder resultTo,
            String resultWho, int requestCode, boolean onlyIfNeeded, boolean debug,
            String profileFile, ParcelFileDescriptor profileFd, boolean autoStopProfiler) {
        return mMainStack.startActivityMayWait(caller, -1, intent, resolvedType,
                grantedUriPermissions, grantedMode, resultTo, resultWho,
                requestCode, onlyIfNeeded, debug, profileFile, profileFd, autoStopProfiler,
                null, null);
    }
```

mMainStack是一个ActivityStack对象。

#4.ActivityStack
在startActivityMayWait方法中的调用顺序是：

* startActivityLocked
* startActivityUncheckedLocked
* resumeTopActivityLocked
* startSpecificActivityLocked
* realStartActivityLocked

在realStartActivityLocked方法中有一句

``` java
app.thread.scheduleLaunchActivity(new Intent(r.intent), r.appToken,
                    System.identityHashCode(r), r.info,
                    new Configuration(mService.mConfiguration),
                    r.compat, r.icicle, results, newIntents, !andResume,
                    mService.isNextTransitionForward(), profileFile, profileFd,
                    profileAutoStop);
```

其中app.thread为IApplicationThread类型，这个接口的实现类为ActivityThread的内部类ApplicationThread。

#5.ApplicationThread
ApplicationThread继承自ApplicationThreadNative，ApplicationThreadNative继承自Binder并实现IApplicationThread接口。和ActivityManagerService一样，都是IPC的实现方式。

现在来看一下ApplicationThread中scheduleLaunchActivity的实现

``` java
		// we use token to identify this activity without having to send the
        // activity itself back to the activity manager. (matters more with ipc)
        public final void scheduleLaunchActivity(Intent intent, IBinder token, int ident,
                ActivityInfo info, Configuration curConfig, CompatibilityInfo compatInfo,
                Bundle state, List<ResultInfo> pendingResults,
                List<Intent> pendingNewIntents, boolean notResumed, boolean isForward,
                String profileName, ParcelFileDescriptor profileFd, boolean autoStopProfiler)
        {
            ActivityClientRecord r = new ActivityClientRecord();
            r.token = token;
            r.ident = ident;
            r.intent = intent;
            r.activityInfo = info;
            r.compatInfo = compatInfo;
            r.state = state;
            r.pendingResults = pendingResults;
            r.pendingIntents = pendingNewIntents;
            r.startsNotResumed = notResumed;
            r.isForward = isForward;
            r.profileFile = profileName;
            r.profileFd = profileFd;
            r.autoStopProfiler = autoStopProfiler;
            updatePendingConfiguration(curConfig);
            queueOrSendMessage(H.LAUNCH_ACTIVITY, r);
        }
```

很简单只是发送了一个名字为H.LAUNCH_ACTIVITY的消息给**H**这个Handler做处理。在Handler中调用了**handleLaunchActivity**方法。

#6.ActivityThread

``` java
    private void handleLaunchActivity(ActivityClientRecord r, Intent customIntent) {
        // If we are getting ready to gc after going to the background, well
        // we are back active so skip it.
        unscheduleGcIdler();

        if (r.profileFd != null) {
            mProfiler.setProfiler(r.profileFile, r.profileFd);
            mProfiler.startProfiling();
            mProfiler.autoStopProfiler = r.autoStopProfiler;
        }

        // Make sure we are running with the most recent config.
        handleConfigurationChanged(null, null);

        if (localLOGV) Slog.v(
            TAG, "Handling launch of " + r);
        Activity a = performLaunchActivity(r, customIntent);

        if (a != null) {
            r.createdConfig = new Configuration(mConfiguration);
            Bundle oldState = r.state;
            handleResumeActivity(r.token, false, r.isForward);

            if (!r.activity.mFinished && r.startsNotResumed) {
                // The activity manager actually wants this one to start out
                // paused, because it needs to be visible but isn't in the
                // foreground.  We accomplish this by going through the
                // normal startup (because activities expect to go through
                // onResume() the first time they run, before their window
                // is displayed), and then pausing it.  However, in this case
                // we do -not- need to do the full pause cycle (of freezing
                // and such) because the activity manager assumes it can just
                // retain the current state it has.
                try {
                    r.activity.mCalled = false;
                    mInstrumentation.callActivityOnPause(r.activity);
                    // We need to keep around the original state, in case
                    // we need to be created again.
                    r.state = oldState;
                    if (!r.activity.mCalled) {
                        throw new SuperNotCalledException(
                            "Activity " + r.intent.getComponent().toShortString() +
                            " did not call through to super.onPause()");
                    }

                } catch (SuperNotCalledException e) {
                    throw e;

                } catch (Exception e) {
                    if (!mInstrumentation.onException(r.activity, e)) {
                        throw new RuntimeException(
                                "Unable to pause activity "
                                + r.intent.getComponent().toShortString()
                                + ": " + e.toString(), e);
                    }
                }
                r.paused = true;
            }
        } else {
            // If there was an error, for any reason, tell the activity
            // manager to stop us.
            try {
                ActivityManagerNative.getDefault()
                    .finishActivity(r.token, Activity.RESULT_CANCELED, null);
            } catch (RemoteException ex) {
                // Ignore
            }
        }
    }
```

从源码可以看出**performLaunchActivity**这个方法完成了最终的启动过程。我们来分析一下方法中的几个操作步骤。

1.通过ActivityClientRecord获取Activity的基本信息

``` java
        ActivityInfo aInfo = r.activityInfo;
        if (r.packageInfo == null) {
            r.packageInfo = getPackageInfo(aInfo.applicationInfo, r.compatInfo,
                    Context.CONTEXT_INCLUDE_CODE);
        }

        ComponentName component = r.intent.getComponent();
        if (component == null) {
            component = r.intent.resolveActivity(
                mInitialApplication.getPackageManager());
            r.intent.setComponent(component);
        }

        if (r.activityInfo.targetActivity != null) {
            component = new ComponentName(r.activityInfo.packageName,
                    r.activityInfo.targetActivity);
        }
```

2.通过Instrumentation的newActivity通过ClassLoader创建Activity对象。

``` java
Activity activity = null;
try {
    java.lang.ClassLoader cl = r.packageInfo.getClassLoader();
    activity = mInstrumentation.newActivity(
    	cl, component.getClassName(), r.intent);
    StrictMode.incrementExpectedActivityCount(activity.getClass());
    r.intent.setExtrasClassLoader(cl);
    if (r.state != null) {
        r.state.setClassLoader(cl);
    }
} catch (Exception e) {
    if (!mInstrumentation.onException(activity, e)) {
        throw new RuntimeException(
            "Unable to instantiate activity " + component
            + ": " + e.toString(), e);
    }
}
```

Instrumentation的newActivity方法只有一句。

``` java
public Activity newActivity(ClassLoader cl, String className,
    Intent intent)
    throws InstantiationException, IllegalAccessException,
    ClassNotFoundException {
        return (Activity)cl.loadClass(className).newInstance();
}
```

3.通过LoadedApk中makeApplication方法获取Application对象，如果Application对象存在就不创建，不存在就调用Instrumentation的callApplicationOnCreate创建。

``` java
Application app = r.packageInfo.makeApplication(false, mInstrumentation);
```

4.创建ContextImpl对象，并通过Activity的attach方法来完成数据初始化。

``` java
ContextImpl appContext = new ContextImpl();
appContext.init(r.packageInfo, r.token, this);
appContext.setOuterContext(activity);
CharSequence title = r.activityInfo.loadLabel(appContext.getPackageManager());
Configuration config = new Configuration(mCompatConfiguration);
if (DEBUG_CONFIGURATION) Slog.v(TAG, "Launching activity "
                        + r.activityInfo.name + " with config " + config);
activity.attach(appContext, this, getInstrumentation(), r.token,
                        r.ident, app, r.intent, r.activityInfo, title, r.parent,
                        r.embeddedID, r.lastNonConfigurationInstances, config);
```

5.Activity生命周期逻辑，意味着Activity已经完成了启动过程。

``` java
if (customIntent != null) {
    activity.mIntent = customIntent;
}
r.lastNonConfigurationInstances = null;
activity.mStartedActivity = false;
int theme = r.activityInfo.getThemeResource();
if (theme != 0) {
    activity.setTheme(theme);
}

activity.mCalled = false;
mInstrumentation.callActivityOnCreate(activity, r.state);
if (!activity.mCalled) {
    throw new SuperNotCalledException(
    "Activity " + r.intent.getComponent().toShortString() +
    " did not call through to super.onCreate()");
}
r.activity = activity;
r.stopped = true;
if (!r.activity.mFinished) {
    activity.performStart();
    r.stopped = false;
}
if (!r.activity.mFinished) {
    if (r.state != null) {
        mInstrumentation.callActivityOnRestoreInstanceState(activity, r.state);
    }
}
if (!r.activity.mFinished) {
    activity.mCalled = false;
    mInstrumentation.callActivityOnPostCreate(activity, r.state);
    if (!activity.mCalled) {
        throw new SuperNotCalledException(
        "Activity " + r.intent.getComponent().toShortString() +
        " did not call through to super.onPostCreate()");
    }
}
```