---
layout: post
title: "Google Guava Library Tips"
date: 2014-09-02 18:58:38 +0800
comments: true
categories: Java
---

#String

* CharMatcher (which can be considered as a light form of JDK's Pattern+Matcher with string manipulation capabilities)
* Joiner and MapJoiner (which are useful for joining iterables or arrays into string representations)
* Splitter (which is split() of JDK on steroids).

###CharMatcher.JAVA_LETTER_OR_DIGIT

.countIn("")

.matchesAllOf("")

.matchesNoneOf("")

.negate()

.removeFrom("")

.retainFrom("")

.indexIn("")

.anyOf("")

.noneOf("")

.inRange('', '')

.or(CharMatcher)

.and(CharMatcher)



###Joiner

.on("")

.join(List)

.skipNulls()

.useForNull("")



###Splitter

.on("")

.omitEmptyStrings()

.trimResults()

.split("")

.fixedLength(int)



###Strings

.emptyToNull("")

.isNullOrEmpty("")

.repeat("", int)

.padEnd("", int, '')

.padStart("", int, '')



#Ordering

This class is really useful if you need to order your Iterable, find the maximum/minimum element in your Iterable, find the index of an arbitrary element. It implements Comparator interface for backward compatibility..from(Comparator)

.sortedCopy(List)

.explicit(enum)

.usingToString()

.natural()

.binarySearch(List,Object)

.max(List)

.min(List)

.reverse()

.isOrdered()

.isStrictlyOrdered()