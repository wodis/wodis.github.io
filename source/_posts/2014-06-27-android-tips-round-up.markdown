---
layout: post
title: "Android Tips Round-Up"
date: 2014-06-27 15:20:27 +0800
comments: true
categories: Android
---

[Activity.startActivities()][1] - Nice for launching to the middle of an app flow.

[TextUtils.isEmpty()][2] - Simple utility I use everywhere.

[Html.fromHtml()][3] - Quick method for formatting Html. It's not particularly fast so I wouldn't use it constantly (e.g., don't use it just to bold part of a string - construct the Spannable manually instead), but it's fine for rendering text obtained from the web.

[TextView.setError()][4] - Nice UI when validating user input.

[Build.VERSION_CODES][5] - Not only is it handy for routing code, it's also summarizes behavioral differences between each version of Android.

[Log.getStackTraceString()][6] - Convenience utility for logging.

[LayoutInflater.from()][7] - Wraps the long-winded getSystemService() call in a simple utility.

[ViewConfiguration.getScaledTouchSlop()][8] - Using the values provided in ViewConfiguration ensures all touch interaction feels consistent across the OS.

[PhoneNumberUtils.convertKeypadLettersToDigits][9] - Makes handling phone number data a snap, as some companies provide them as letters.

[Context.getCacheDir()][10] - Use the cache dir for caching data. Simple enough but some don't know it exists.

[ArgbEvaluator][11] - Transition from one color to another. As was pointed out by Chris Banes, this class creates a lot of autoboxing churn so it'd be better to just rip out the logic and run it yourself.

[ContextThemeWrapper][12] - Nice class for changing the theme of a Context on the fly.

[Space][13] - Lightweight View which skips drawing. Great for any situation that might require a placeholder.

[ValueAnimator.reverse()][14] - I love this for canceling animations smoothly.

[DateUtils.formatDateTime()][15] - One-stop shop for localized date/time strings.

[AlarmManager.setInexactRepeating][16] - Saves on battery life by grouping multiple alarms together. Even if you're only calling a single alarm this is better (just make sure to call AlarmManager.cancel() when done).

[Formatter.formatFileSize()][17] - A localized file size formatter.

[ActionBar.hide()/.show()][18] - Animates the action bar hiding/showing. Lets you switch to full-screen gracefully.

[Linkify.addLinks()][19] - If you need to control how links are added to text.

[StaticLayout][20] - Useful for measuring text that you're about to render into a custom View.

[Activity.onBackPressed()][21] - Easy way to manage the back button. While I wouldn't normally hijack back, sometimes it's necessary to make a flow work.

[GestureDetector][22] - Listens to motion events and fires listener events for common actions (like clicks, scrolls and flings). So much easier than implementing your own motion event system.

[DrawFilter][23] - Lets you manipulate a Canvas even if you're not calling the draw commands. For example, you could create a custom View which sets a DrawFilter which anti-aliases the draws of the parent View.

[ActivityManager.getMemoryClass()][24] - Gives you an idea of how much memory the device has. Great for figuring out how large to make your caches.

[SystemClock.sleep()][25] - Convenience method which guarantees sleeping the amount of time entered. I use it for debugging and simulating network delays.

[ViewStub][26] - A View that initially does nothing, but can later inflate a layout. This is a great placeholder for lazy-loading Views. Its only drawback is that it doesn't support <merge> tags, so it can create unnecessary nesting in the hierarchy if you're not careful.

[DisplayMetrics.density][27] - You can get the density of the screen this way. Most of the time you'll be better off letting the system scale dimensions automatically, but occasionally it's useful to have more control (especially with custom Views).

[Pair.create()][28] - Handy class, handy creator method.

[UrlQuerySanitizer][29] - Sanitize URLs with this handy utility.

[Fragment.setArguments][30] - Since you can't use a Fragment constructor w/ parameters this is the second best thing. Arguments set before creation last throughout the entire Fragment's lifecycle (even if it's destroyed/recreated due to a configuration change).

[DialogFragment.setShowsDialog()][31] - Neat trick - DialogFragments can act like normal Fragments! That way you can have the same Fragment do double-duty. I usually create a third View generation method that both onCreateView() and onCreateDialog() call into when creating a dual-purpose Fragment.

[FragmentManager.enableDebugLogging()][32] - Help when you need it when figuring out Fragments.

[LocalBroadcastManager][33] - Safer than global broadcasts. Simple and quick. Event buses like otto may make more sense for your use case though.

[PhoneNumberUtils.formatNumber()][34] - Let someone else figure out this problem for you.

[Region.op()][35] - I found this useful for comparing two generic areas before rendering. If I've got two Paths, do they overlap? I can figure that out with this method.

[Application.registerActivityLifecycleCallbacks][36] - Though lacking documentation I feel this is self-evident. Just a handy tool.

[versionNameSuffix][37] - This gradle setting lets you modify the versionName field in your manifest based on different build types. For example, I would setup my debug build type to end in "-SNAPSHOT"; that way you can easily tell if you're on a debug build or release build.

[CursorJoiner][38] - If you're using a single database then a join in SQL is the natural solution, but what if you've received data from two separate ContentProviders? In that case CursorJoiner can be helpful.

[Genymotion][39] - A much faster Android emulator. I use it all day.

[-nodpi][40] - Most qualifiers (-mdpi, -hdpi, -xhdpi, etc.) automatically scale assets/dimensions if you're on a device that isn't explicitly defined. Sometimes you just want something consistent though; in that case use -nodpi.

[BroadcastRecevier.setDebugUnregister()][41] - Another handy debugging tool.

[Activity.recreate()][42] - Forces an Activity to recreate itself for whatever reason.

[PackageManager.checkSignatures()][43] - You can use this to find out if two apps (presumably your own) are installed at the same time. Without checking signatures someone could imitate your app easily by just using the same package name.

[Activity.isChangingConfigurations()][44] - Often times you don't need to do quite as much saving of state if all that's happening is the configuration is changing.

[SearchRecentSuggestionsProvider][45] - A quick and easy way to create a recents suggestion provider.

[ViewTreeObserver][46] - This is an amazing utility; it can be grabbed from any View and used to monitor the state of the View hierarchy. My most often use for it is to determine when Views have been measured (usually for animation purposes).

[org.gradle.daemon=true][47] - Helps reduce the startup time of of Gradle builds. Only really applies to command-line builds as Android Studio already tries to use the daemon.

[DatabaseUtils][48] - A variety of useful tools for database operations.

[android:weightSum (LinearLayout)][49] - Want to use layout weights, but don't want them to fill the entire LinearLayout? That's what weightSum can do by defining the total weight.

[android:duplicateParentState (View)][50] - Makes the child duplicate the state of the parent - for example, if you've got a ViewGroup that is clickable, then you can use this to make its children change state when it is clicked.

[android:clipChildren (ViewGroup)][51] - If disabled, this lets the children of a ViewGroup draw outside their parent's bounds. Great for animations.

[android:fillViewport (ScrollView)][52] - Best explained in this post, this helps solve a problem with ScrollViews that may not always have enough content to actually fill the height of the screen.

[android:tileMode (BitmapDrawable)][53] - Lets you create repeated patterns with images.

[android:enterFadeDuration/android:exitFadeDuration (Drawables)][54] - For Drawables that have multiple states, this lets you define a fade before/after the drawable shows.

[android:scaleType (ImageView)][55] - Defines how to scale/crop a drawable within an ImageView. "centerCrop" and "centerInside" are regular settings for me.

[<merge>][56] - Lets you include a layout in another without creating a duplicate ViewGroup (more info). Also good for custom ViewGroups; you can inflate a layout with <merge> inside the constructor to define its children automatically.

[AtomicFile][57] - Manipulates a file atomically by using a backup file. I've written this myself before, it's good to have an official (and better-written) version of it.

[ViewDragHelper][58] - Dragging Views is a complex problem and this class helps a lot. If you want an example, DrawerLayout uses it for swiping. Flavient Laurent also wrote an excellent article about it.

[PopupWindow][59] - Used all around Android without you even realizing it (action bars, autocomplete, edittext errors), this class is the primary method for creating floating content.

[ActionBar.getThemedContext()][60] - ActionBar theming is surprisingly complex (and can be different from the theming of the rest of the Activity). This gets you a Context so if you create your own Views they will be properly themed.

[ThumbnailUtils][61] - Helps create thumbnails; in general I'd just use whatever image library was already in place (e.g. Picasso or Volley), but it can also create video thumbnails!

[Context.getExternalFilesDir()][62] - While you do have permission to write anywhere on the SD card if you ask for it, it's much more polite to write your data in the correct designated folder. That way it gets cleaned up and users get a common experience. Additionally, as of Kit Kat you can write to this folder without permission, and each user has their own external files dir.

[SparseArray][63] - A more efficient version of Map<Integer, Object>. Be sure to check out sister classes SparseBooleanArray, SparseIntArray and SparseLongArray as well.

[PackageManager.setComponentEnabledSetting()][64] - Lets you enable/disable components in your app's manifest. What's nice here is being able to shut off unnecessary functionality - for example, a BroadcastReceiver that is unnecessary due to the current app configuration.

[SQLiteDatabase.yieldIfContendedSafely()][65] - Lets you temporarily stop a db transaction so you don't tie up too much of the system.

[Environment.getExternalStoragePublicDirectory()][66] - Again, users like a consistent experience with their SD card; using this method will grab the correct directory for placing typed files (music, pictures, etc.) on their drive.

[View.generateViewId()][67] - Every once in a while I've wanted to dynamically generate view IDs. The problem is ensuring you aren't clobbering existing IDs (or other generated ones).

[ActivityManager.clearApplicationUserData()][68] - A reset button for your app. Perhaps the easiest way to log out a user, ever.

[Context.createConfigurationContext()][69] - Customize your configuration context. Common problem I've run into: forcing part of an app to render in a particular locale (not that I normally condone this sort of behavior, but you never know). This would make it a lot easier to do so.

[ActivityOptions][70] - Nice custom animations when moving between Activities. ActivityOptionsCompat is good for backwards compatible functionality.

[AdapterViewFlipper.fyiWillBeAdvancedByHostKThx()][71] - Because it's funny and for no other reason. There are other amusing tidbits in AOSP (like GRAVITY_DEATH_STAR_I) but unlike those this one is actually useful.

[ViewParent.requestDisallowInterceptTouchEvent()][72] - The Android touch event system defaults handle what you want most of the time, but sometimes you need this method to wrest event control from parents. (By the way, if you want to know about the touch system, this talk is amazing.)

[1]:http://developer.android.com/reference/android/app/Activity.html#startActivities(android.content.Intent[])

[2]:http://developer.android.com/reference/android/text/TextUtils.html#isEmpty(java.lang.CharSequence)

[3]:http://developer.android.com/reference/android/text/Html.html#fromHtml(java.lang.String)

[4]:http://developer.android.com/reference/android/widget/TextView.html#setError%28java.lang.CharSequence%29

[5]:http://developer.android.com/reference/android/os/Build.VERSION_CODES.html

[6]:http://developer.android.com/reference/android/util/Log.html#getStackTraceString(java.lang.Throwable)

[7]:http://developer.android.com/reference/android/view/LayoutInflater.html#from%28android.content.Context%29

[8]:http://developer.android.com/reference/android/view/ViewConfiguration.html#getScaledTouchSlop%28%29

[9]:http://developer.android.com/reference/android/telephony/PhoneNumberUtils.html#convertKeypadLettersToDigits%28java.lang.String%29

[10]:http://developer.android.com/reference/android/content/Context.html#getCacheDir%28%29

[11]:http://developer.android.com/reference/android/animation/ArgbEvaluator.html

[12]:http://developer.android.com/reference/android/view/ContextThemeWrapper.html

[13]:http://developer.android.com/reference/android/widget/Space.html

[14]:http://developer.android.com/reference/android/animation/ValueAnimator.html#reverse%28%29

[15]:http://developer.android.com/reference/android/text/format/DateUtils.html#formatDateTime%28android.content.Context,%20long,%20int%29

[16]:http://developer.android.com/reference/android/app/AlarmManager.html#setInexactRepeating(int,long,long,android.app.PendingIntent)

[17]:http://developer.android.com/reference/android/text/format/Formatter.html#formatFileSize(android.content.Context,long)

[18]:http://developer.android.com/reference/android/app/ActionBar.html#hide()

[19]:http://developer.android.com/reference/android/text/util/Linkify.html#addLinks(android.text.Spannable,int)

[20]:http://developer.android.com/reference/android/text/StaticLayout.html

[21]:http://developer.android.com/reference/android/app/Activity.html#onBackPressed()

[22]:http://developer.android.com/reference/android/view/GestureDetector.html

[23]:http://developer.android.com/reference/android/graphics/DrawFilter.html

[24]:http://developer.android.com/reference/android/app/ActivityManager.html#getMemoryClass()

[25]:http://developer.android.com/reference/android/os/SystemClock.html#sleep(long)

[26]:http://developer.android.com/reference/android/view/ViewStub.html

[27]:http://developer.android.com/reference/android/util/DisplayMetrics.html#density

[28]:http://developer.android.com/reference/android/util/Pair.html#create(A,B)

[29]:http://developer.android.com/reference/android/net/UrlQuerySanitizer.html

[30]:http://developer.android.com/reference/android/app/Fragment.html#setArguments%28android.os.Bundle%29

[31]:http://developer.android.com/reference/android/app/DialogFragment.html#setShowsDialog%28boolean%29

[32]:http://developer.android.com/reference/android/app/FragmentManager.html#enableDebugLogging%28boolean%29

[33]:http://developer.android.com/reference/android/support/v4/content/LocalBroadcastManager.html

[34]:http://developer.android.com/reference/android/telephony/PhoneNumberUtils.html#formatNumber%28java.lang.String%29

[35]:http://developer.android.com/reference/android/graphics/Region.html#op%28android.graphics.Region,%20android.graphics.Region,%20android.graphics.Region.Op%29

[36]:http://developer.android.com/reference/android/app/Application.html#registerActivityLifecycleCallbacks%28android.app.Application.ActivityLifecycleCallbacks%29

[37]:http://tools.android.com/tech-docs/new-build-system/user-guide#TOC-Build-Types

[38]:http://developer.android.com/reference/android/database/CursorJoiner.html

[39]:http://www.genymotion.com/

[40]:http://developer.android.com/guide/practices/screens_support.html#qualifiers

[41]:http://developer.android.com/reference/android/content/BroadcastReceiver.html#setDebugUnregister%28boolean%29

[42]:http://developer.android.com/reference/android/app/Activity.html#recreate%28%29

[43]:http://developer.android.com/reference/android/content/pm/PackageManager.html#checkSignatures%28java.lang.String,%20java.lang.String%29

[44]:http://developer.android.com/reference/android/app/Activity.html#isChangingConfigurations%28%29

[45]:http://developer.android.com/reference/android/content/SearchRecentSuggestionsProvider.html

[46]:http://developer.android.com/reference/android/view/ViewTreeObserver.html

[47]:https://www.timroes.de/2013/09/12/speed-up-gradle/

[48]:http://developer.android.com/reference/android/database/DatabaseUtils.html

[49]:http://developer.android.com/reference/android/widget/LinearLayout.html#attr_android:weightSum

[50]:http://developer.android.com/reference/android/view/View.html#attr_android:duplicateParentState

[51]:http://developer.android.com/reference/android/view/ViewGroup.html#attr_android:clipChildren

[52]:http://developer.android.com/reference/android/widget/ScrollView.html#attr_android:fillViewport

[53]:http://developer.android.com/guide/topics/resources/drawable-resource.html#Bitmap

[54]:http://developer.android.com/reference/android/R.attr.html#exitFadeDuration

[55]:http://developer.android.com/reference/android/widget/ImageView.html#attr_android:scaleType

[56]:http://developer.android.com/training/improving-layouts/reusing-layouts.html#Merge

[57]:http://developer.android.com/reference/android/util/AtomicFile.html

[58]:https://developer.android.com/reference/android/support/v4/widget/ViewDragHelper.html

[59]:https://developer.android.com/reference/android/widget/PopupWindow.html

[60]:https://developer.android.com/reference/android/app/ActionBar.html#getThemedContext()

[61]:https://developer.android.com/reference/android/media/ThumbnailUtils.html

[62]:https://developer.android.com/reference/android/content/Context.html#getExternalFilesDir(java.lang.String)

[63]:https://developer.android.com/reference/android/util/SparseArray.html

[64]:https://developer.android.com/reference/android/content/pm/PackageManager.html#setComponentEnabledSetting(android.content.ComponentName,int,int)

[65]:https://developer.android.com/reference/android/database/sqlite/SQLiteDatabase.html#yieldIfContendedSafely()

[66]:https://developer.android.com/reference/android/os/Environment.html#getExternalStoragePublicDirectory(java.lang.String)

[67]:https://developer.android.com/reference/android/view/View.html#generateViewId()

[68]:https://developer.android.com/reference/android/app/ActivityManager.html#clearApplicationUserData()

[69]:http://developer.android.com/reference/android/content/Context.html#createConfigurationContext(android.content.res.Configuration)

[70]:http://developer.android.com/reference/android/app/ActivityOptions.html

[71]:http://developer.android.com/reference/android/widget/AdapterViewFlipper.html#fyiWillBeAdvancedByHostKThx%28%29

[72]:http://developer.android.com/reference/android/view/ViewParent.html#requestDisallowInterceptTouchEvent%28boolean%29