---
layout: post
title: "Android绘制过程"
date: 2015-08-26 17:23:01 +0800
comments: true
categories: Android
---

最近群里面有些小伙伴问我，希望可以解释一下View间的绘制关系，所以简单的写一下。

#Android是如何绘制View的
一旦Activity获得焦点之后，将会触发绘制布局的流程。
绘制过程是从布局的根节点(root node)开始的，根据布局的树状结构测量(measure)并绘制(draw)。
这个过程用于规定每一个View的区域，然后绘制对应的界面。
ViewGroup用于负责请求每一个它的子View进行绘制，当子View接到请求则开始绘制自己的界面。
注意树的遍历是有序的，意味着父View将在子View绘制之前被调用。

##Measure与Layout
绘制布局分为两个过程：measure和layout。

measure(int, int)方法用来自上而下的遍历View，每个View都是递归的测量自己所占的大小。

layout(int, int, int, int)方法同样是自上而下的，它的功能是将子View放置在合适的位置。

当View对象调用了measure方法之后，通过getMeasuredWidth()和getMeasuredHeight()方法就可以获取到测量后的值。
注意一点，子View的宽和高不得超过在父View。这可以确保所有的子View都被父View所包含。

##ViewGroup.LayoutParams
父类如何得知子类想要如何布局呢，ViewGroup.LayoutParams类用于告诉父类它们的布局预期。
我们可以使用3种配置方式：

* 准确的值
* MATCH_PARENT，子View想与父View一样大小
* WRAP_CONTENT，子View的大小足以包括它的内容

##MeasureSpec
MeasureSpec用于父View向下要求子View的绘制模式，MeasureSpec有3种模式：

* UNSPECIFIED，表示大小并不明确
* EXACTLY，表示父类给定一个准确的大小
* AT MOST，表示父类限制了子类的最大值

`上面的逻辑是不是太抽象了？简单来说就是一个View如果想要展示出来需要两步：1、计算自己所占空间的大小。2、子View摆放的位置。(所有过程都是从父View发起，直到子View计算完成向它的父View返回结果)`

#自定义一个ViewGroup
我们自定义一个ViewGroup通常分为以下几步：

1.继承ViewGroup并且重写父类的三个构造函数


``` java
public class CustomViewGroup extends ViewGroup {

  public CustomViewGroup(Context context) {
      super(context);
    }

  public CustomViewGroup(Context context, AttributeSet attrs) {
      super(context, attrs);
    }

  public CustomViewGroup(Context context, AttributeSet attrs, intdefStyle) {
      super(context, attrs, defStyle);
    }
}
```

2.重载onMeasure()方法
自定义ViewGroup的onMeasure()方法中，除了计算自身的尺寸外，还需要调用measureChildren()函数来计算子控件的尺寸。

onMeasure()的定义不是本文的讨论重点，因此这里我直接使用默认的onMeasure()定义，当然measureChildren()是必须得加的，或者我们针对性的调用子View的measure方法。
通常我们使用MeasureSpec.makeMeasureSpec(int size, int mode)来产生一个规格。
使用getChildCount()获取子View个数。使用getChildAt(i)获得对应的子View。在最后不要忘记使用setMeasuredDimension方法设置当前View的规格。

3.实现onLayout()方法
通常我们在这个方法里面调用getMeasuredWidth()和getMeasuredHeight()获取已经测量过的View大小，
然后根据这些数据来计算每个View对应的位置。通过layout(int l, int t, int r, int b)设置子View在当前View中的位置。

4.添加LayoutParams
generateLayoutParams()用于返回一个LayoutParams给子View，这样子View就可以将对应layout布局的参数传入，
我们自定义的父View可以使用getLayoutParams()获取我们传入的LayoutParams。

你可以跟踪源码看看，其实XML文件中View的layout_xxx参数都是被传递到了各种自定义ViewGroup.LayoutParams派生类对象中。例如LinearLayout的LayoutParams定义的关键部分如下：

``` java
public class LinearLayout extends ViewGroup {

    public static class LayoutParams extends ViewGroup.MarginLayoutParams {

        public float weight;
        public int gravity = -1;

        public LayoutParams(Context c, AttributeSet attrs) {

                super(c, attrs);

                TypedArray a = c.obtainStyledAttributes(attrs, com.android.internal.R.styleable.LinearLayout_Layout);
                weight = a.getFloat(com.android.internal.R.styleable.LinearLayout_Layout_layout_weight, 0);
                gravity = a.getInt(com.android.internal.R.styleable.LinearLayout_Layout_layout_gravity, -1);

                a.recycle();
        }
    }

    @Override
    public LayoutParams generateLayoutParams(AttributeSet attrs) {
        return new LinearLayout.LayoutParams(getContext(), attrs);
    }
}
```

这样你大概就可以理解为什么LinearLayout的子控件支持weight和gravity的设置了吧，当然我们也可以这样自定义一些属于我们ViewGroup特有的params。

这样修改之后，我们就可以在onLayout()函数中获取子控件的layout_xxx值了。