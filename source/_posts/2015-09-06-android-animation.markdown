---
layout: post
title: "浅谈Android动画"
date: 2015-09-06 18:26:51 +0800
comments: true
categories: Android
---

在Android中动画分为以下4种：

1. Tween Animation  补间动画
2. Frame Animation  帧动画
3. Layout Animation 布局动画
4. Property Animation 属性动画

动画实现流程：

1. 创建Animation
2. 设置相关属性
3. View调用startAnimation方法启动动画

#Animation
Animation类是Android系统的一个动画抽象类，所有其他一些动画类都要继承该类中的实现方法。Animation类主要用于补间动画效果，提供了动画启动、停止、重复、持续时间等方法。Animation类中的方法适用于任何一种补间动画对象。

常用方法：

start() 启动

startNow() 立即启动

cancel() 取消动画

setDuration(long) 设置持续时间

setRepeatMode(int) 设置重复模式

setRepeatCount(int) 设置重复次数

setFillEnabled(boolean) 能否填充位置

setFillBefore(boolean) 回到起始填充位置

setFillAfter(boolean) 回到结束填充位置

setStartOffset(long) 设置延时启动时间

setInterpolator(Interpolator) 设置加速曲线

setAnimationListener(AnimationListener) 设置动画的回调

#Tween Animation
该类Animations提供了旋转、移动、伸展和淡出等效果。Alpha——淡入淡出，Scale——缩放效果，Rotate——旋转，Translate——移动效果。

##TranslateAnimation
TranslateAnimation类是Android系统中的位置变化动画类，用于控制View对象的位置变化，该类继承于Animation类。TranslateAnimation类中的很多方法都与Animation类一致，该类中最常用的方法便是TranslateAnimation构造方法。

public TranslateAnimation (float fromXDelta, float toXDelta, float fromYDelta, float toYDelta)

参数说明

fromXDelta：位置变化的起始点X坐标。

toXDelta：位置变化的结束点X坐标。

fromYDelta：位置变化的起始点Y坐标。

toYDelta：位置变化的结束点Y坐标。

##RotateAnimation
RotateAnimation类是Android系统中的旋转变化动画类，用于控制View对象的旋转动作，该类继承于Animation类。RotateAnimation类中的很多方法都与Animation类一致，该类中最常用的方法便是RotateAnimation构造方法。

public RotateAnimation (float fromDegrees, float toDegrees, int pivotXType, float pivotXValue, int pivotYType, float pivotYValue)

参数说明

fromDegrees：旋转的开始角度。

toDegrees：旋转的结束角度。

pivotXType：X轴的伸缩模式，可以取值为ABSOLUTE、RELATIVE_TO_SELF、RELATIVE_TO_PARENT。

pivotXValue：X坐标的伸缩值。

pivotYType：Y轴的伸缩模式，可以取值为ABSOLUTE、RELATIVE_TO_SELF、RELATIVE_TO_PARENT。

pivotYValue：Y坐标的伸缩值。

##ScaleAnimation
ScaleAnimation类是Android系统中的尺寸变化动画类，用于控制View对象的尺寸变化，该类继承于Animation类。ScaleAnimation类中的很多方法都与Animation类一致，该类中最常用的方法便是ScaleAnimation构造方法。

public ScaleAnimation (float fromX, float toX, float fromY, float toY, int pivotXType, float pivotXValue, int pivotYType, float pivotYValue)

参数说明

fromX：起始X坐标上的伸缩尺寸。

toX：结束X坐标上的伸缩尺寸。

fromY：起始Y坐标上的伸缩尺寸。

toY：结束Y坐标上的伸缩尺寸。

pivotXType：X轴的伸缩模式，可以取值为ABSOLUTE、RELATIVE_TO_SELF、RELATIVE_TO_PARENT。

pivotXValue：X坐标的伸缩值。

pivotYType：Y轴的伸缩模式，可以取值为ABSOLUTE、RELATIVE_TO_SELF、RELATIVE_TO_PARENT。

pivotYValue：Y坐标的伸缩值。

##AlphaAnimation
AlphaAnimation类是Android系统中的透明度变化动画类，用于控制View对象的透明度变化，该类继承于Animation类。AlphaAnimation类中的很多方法都与Animation类一致，该类中最常用的方法便是AlphaAnimation构造方法。

public AlphaAnimation (float fromAlpha, float toAlpha)

参数说明

fromAlpha：开始时刻的透明度，取值范围0~1。

toAlpha：结束时刻的透明度，取值范围0~1。

##AnimationSet
AnimationSet类是Android系统中的动画集合类，用于控制View对象进行多个动作的组合，该类继承于Animation类。AnimationSet类中的很多方法都与Animation类一致，该类中最常用的方法便是addAnimation方法，该方法用于为动画集合对象添加动画对象。

public void addAnimation (Animation a)

其中，参数a为Animation动画对象，可以是前述任何一种补间动作。

##AnimationUtils
AnimationUtils类是Android系统中的动画工具类，提供了控制View对象的一些工具。该类中最常用的方法便是loadAnimation方法，该方法用于加载XML格式的动画配置文件。在Android系统中，除了在代码中设置动画效果外，还可以在XML配置文件中设置动画的组合动作，这种方式适用性更好。

public static Animation loadAnimation (Context context, int id)

参数说明

context：上下文对象。

id：动画配置文件的ID。

#Frame Animation
AnimationDrawable类：帧动画类

AnimationDrawable类是Android系统中的帧动画类。帧动画方式类似于放电影的原理，是通过顺序播放多张图片来实现动画效果的，图片之间有一定的动作连贯性，这样人眼看来就像对象真正在运动一样。AnimationDrawable类位于android.graphics.drawable软件包中，本节将介绍帧动画类中的主要编程方法。

``` xml
<?xml version="1.0" encoding="utf-8"?>
<animation-list xmlns:android="http://schemas.android.com/apk/res/android"
                android:oneshot="true">
    <item android:drawable="@drawable/p0" android:duration="50"/>
    <item android:drawable="@drawable/p1" android:duration="50"/>
    <item android:drawable="@drawable/p2" android:duration="50"/>
    <item android:drawable="@drawable/p3" android:duration="50"/>
    <item android:drawable="@drawable/p4" android:duration="50"/>
</animation-list>
```

通过动画配置文件，将其加载到ImageView的背景中，再start启动。

#Layout Animations
LayoutAnimationsController可以用于实现使多个控件按顺序一个一个的显示。

1. LayoutAnimationsController用于为一个layout里面的控件，或者是一个ViewGroup里面的控件设置统一的动画效果。
2. 每一个控件都有相同的动画效果。
3. 控件的动画效果可以在不同的时间显示出来。
4. LayoutAnimationsController可以在xml文件当中设置，也可以在代码当中进行设置。

``` java LayoutAnimations
//1.加载动画set的XML文件
Animation animation = (Animation) AnimationUtils.loadAnimation(Animation2Activity.this, R.anim.list_anim);
//2.初始化LayoutAnimationController
LayoutAnimationController controller = new LayoutAnimationController(animation);
//3.设置子View动画顺序
controller.setOrder(LayoutAnimationController.ORDER_NORMAL);
//4.设置动画延迟
controller.setDelay(0.5f);
//5.将LayoutAnimation设置给ViewGroup
listView.setLayoutAnimation(controller);
```


#Property Animation
属性动画要求对象必须实现对应的get和set方法，属性动画根据传递的初始值和最终值，以动画的效果多次调用对应的set方法，根据时间的推移越来越接近最终值。

如果需要对属性xxx做动画，必须满足两个条件：

1. object必须提供set方法，如果不指定初始状态则必须提供get方法（系统会通过get方法拿初始属性）。
2. object的set方法必须通过UI反应出来，不然动画无效（这点比较好理解，使UI布局更新）。

Google给出了3个解决方法：

1. 给对象添加set和get方法，前提是拥有权限
2. 用一个包装类，实现对应的set和get方法
3. 采用ValueAnimator，监听动画过程，自己实现属性的改变

###对象直接添加set和get方法
这个方式很简单，但是局限性较大。假如你想对Android SDK中的对象添加方法，正常是无法实现的。

###使用包装类间接实现set和get方法

``` java ViewWrapper
private void performAnimate() {
    ViewWrapper wrapper = new ViewWrapper(mButton);
    ObjectAnimator.ofInt(wrapper, "width", 500).setDuration(5000).start();
}

@Override
public void onClick(View v) {
    if (v == mButton) {
        performAnimate();
    }
}

private static class ViewWrapper {
    private View mTarget;

    public ViewWrapper(View target) {
        mTarget = target;
    }

    public int getWidth() {
        return mTarget.getLayoutParams().width;
    }

    public void setWidth(int width) {
        mTarget.getLayoutParams().width = width;
        mTarget.requestLayout();
    }
}
```

上述代码5s内让View的宽度增加到500px，为了达到这个效果，我们提供了ViewWrapper类专门用于包装View，具体到本例是包装View，然后我们对ViewWrapper的width熟悉做动画，并且在setWidth方法中修改其内部的target的宽度，而target实际上就是我们包装的Button，这样一个间接属性动画就搞定了。上述代码同样适用于一个对象的其他属性。

###采用ValueAnimator，监听动画过程，自己实现属性的改变
ValueAnimator本身不作用于任何对象，也就是说直接使用它没有任何动画效果。它可以对一个值做动画，然后我们可以监听其动画过程，在动画过程中修改我们的对象的属性值，这样也就相当于我们的对象做了动画。

``` java ValueAnimators
private void performAnimate(final View target, final int start, final int end) {
    ValueAnimator valueAnimator = ValueAnimator.ofInt(1, 100);

    valueAnimator.addUpdateListener(new AnimatorUpdateListener() {

        //持有一个IntEvaluator对象，方便下面估值的时候使用
        private IntEvaluator mEvaluator = new IntEvaluator();

        @Override
        public void onAnimationUpdate(ValueAnimator animator) {
            //获得当前动画的进度值，整型，1-100之间
            int currentValue = (Integer)animator.getAnimatedValue();
            Log.d(TAG, "current value: " + currentValue);

            //计算当前进度占整个动画过程的比例，浮点型，0-1之间
            float fraction = currentValue / 100f;

            //这里我偷懒了，不过有现成的干吗不用呢
            //直接调用整型估值器通过比例计算出宽度，然后再设给Button
            target.getLayoutParams().width = mEvaluator.evaluate(fraction, start, end);
            target.requestLayout();
        }
    });

    valueAnimator.setDuration(5000).start();
}

@Override
public void onClick(View v) {
    if (v == mButton) {
        performAnimate(mButton, mButton.getWidth(), 500);
    }
}
```

关于这个ValueAnimator我要再说一下，拿上例来说，它会在5000ms内将一个数从1变到100，然后动画的每一帧会回调onAnimationUpdate方法，在这个方法里，我们可以获取当前的值（1-100），根据当前值所占的比例（当前值/100），我们可以计算出Button现在的宽度应该是多少，比如时间过了一半，当前值是50，比例为0.5，假设Button的起始宽度是100px，最终宽度是500px，那么Button增加的宽度也应该占总增加宽度的一半，总增加宽度是500-100=400，所以这个时候Button应该增加宽度400*0.5=200，那么当前Button的宽度应该为初始宽度+ 增加宽度（100+200=300）。上述计算过程很简单，其实它就是整型估值器IntEvaluator的内部实现。

#最后

1. View动画（渐变动画）的功能是有限的，大家可以尝试使用属性动画
2. 为了在各种安卓版本上使用属性动画，你需要采用nineoldandroids，它是GitHub开源项目，jar包和源码都可以在网上下到，如果下不到jar包，我可以发给大家
3. 再复杂的动画都是简单动画的合理组合，再加上本文介绍的方法，可以对任何属性作用动画效果，也就是说你几乎可以做出任何动画
4. 属性动画中的插值器（Interpolator）和估值器（TypeEvaluator）很重要，它是实现非匀速动画的重要手段，你应该试着搞懂它，最好你还能够自定义它们

参考资料：[Android属性动画深入分析：让你成为动画牛人](http://blog.csdn.net/singwhatiwanna/article/details/17841165)