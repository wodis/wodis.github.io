---
layout: post
title: "Git Learning"
date: 2014-07-01 13:47:06 +0800
comments: true
categories: Git
---

##Git 工作流程
一般工作流程如下：

* 克隆 Git 资源作为工作目录。
* 在克隆的资源上添加或修改文件。
* 如果其他人修改了，你可以更新资源。
* 在提交前查看修改。
* 提交修改。
* 在修改完成后，如果发现错误，可以撤回提交并再次修改并提交。

![工作流程](http://www.openwudi.com/images/2015/1432807147.png)

##Git 创建仓库
使用您当前目录作为Git仓库，我们只需使它初始化。

    git init

使用指定目录作为Git仓库。

    git init newrepo

初始化后，在当前目录下会出现一个名为 .git 的目录，所有 Git 需要的数据和资源都存放在这个目录中。
如果当前目录下有几个文件想要纳入版本控制，需要先用 git add 命令告诉 Git 开始对这些文件进行跟踪，然后提交：

    $ git add *.c
    $ git add README
    $ git commit -m 'initial project version'

###从现有仓库克隆
克隆仓库的命令格式为：

    git clone [url]

比如，要克隆 Ruby 语言的 Git 代码仓库 Grit，可以用下面的命令：

    $ git clone git://github.com/schacon/grit.git

执行该命令后，会在当前目录下创建一个名为grit的目录，其中包含一个 .git 的目录，用于保存下载下来的所有版本记录。
如果要自己定义要新建的项目目录名称，可以在上面的命令末尾指定新的名字：

    $ git clone git://github.com/schacon/grit.git mygrit

##Git 工作区、暂存区和版本库
我们先来理解下Git 工作区、暂存区和版本库概念

* 工作区：就是你在电脑里能看到的目录。
* 暂存区：英文叫stage, 或index。一般存放在"git目录"下的index文件（.git/index）中，所以我们把暂存区有时也叫作索引（index）。
* 版本库：工作区有一个隐藏目录.git，这个不算工作区，而是Git的版本库。

下面这个图展示了工作区、版本库中的暂存区和版本库之间的关系：

![工作区、暂存区和版本库](http://www.openwudi.com/images/2015/1432810388.jpg)

图中左侧为工作区，右侧为版本库。在版本库中标记为 "index" 的区域是暂存区（stage, index），标记为 "master" 的是 master 分支所代表的目录树。

图中我们可以看出此时 "HEAD" 实际是指向 master 分支的一个"游标"。所以图示的命令中出现 HEAD 的地方可以用 master 来替换。

图中的 objects 标识的区域为 Git 的对象库，实际位于 ".git/objects" 目录下，里面包含了创建的各种对象及内容。

当对工作区修改（或新增）的文件执行 "git add" 命令时，暂存区的目录树被更新，同时工作区修改（或新增）的文件内容被写入到对象库中的一个新的对象中，而该对象的ID被记录在暂存区的文件索引中。

当执行提交操作（git commit）时，暂存区的目录树写到版本库（对象库）中，master 分支会做相应的更新。即 master 指向的目录树就是提交时暂存区的目录树。

当执行 "git reset HEAD" 命令时，暂存区的目录树会被重写，被 master 分支指向的目录树所替换，但是工作区不受影响。

当执行 "git rm --cached <file>" 命令时，会直接从暂存区删除文件，工作区则不做出改变。

当执行 "git checkout ." 或者 "git checkout -- <file>" 命令时，会用暂存区全部或指定的文件替换工作区的文件。这个操作很危险，会清除工作区中未添加到暂存区的改动。

当执行 "git checkout HEAD ." 或者 "git checkout HEAD <file>" 命令时，会用 HEAD 指向的 master 分支中的全部或者部分文件替换暂存区和以及工作区中的文件。这个命令也是极具危险性的，因为不但会清除工作区中未提交的改动，也会清除暂存区中未提交的改动。

##Git 基本操作
Git 的工作就是创建和保存你的项目的快照及与之后的快照进行对比。

###基本快照
####git add
git add 命令可将该文件添加到缓存，如我们添加以下两个文件：

    $ touch README
    $ touch hello.php
    $ ls
    README		hello.php
    $ git status -s
    ?? README
    ?? hello.php
    $

git status 命令用于查看项目的当前状态。接下来我们执行 git add 命令来添加文件：

    $ git add README hello.php

现在我们再执行 git status，就可以看到这两个文件已经加上去了。

    $ git status -s
    A  README
    A  hello.php
    $

新项目中，添加所有文件很普遍，可以在当前工作目录执行命令：git add .。
现在我们改个文件，再执行一下 git status：

    $ vim README
    $ git status -s
    AM README
    A  hello.php

"AM" 状态的意思是，这个文件在我们将它添加到缓存之后又有改动。改动后我们在执行 git add 命令将其添加到缓存中：

    $ git add .
    $ git status -s
    A  README
    A  hello.php

当你要将你的修改包含在即将提交的快照里的时候，需要执行 git add。

####git status
git status 以查看在你上次提交之后是否有修改。
演示该命令的时候加了 -s 参数，以获得简短的结果输出。如果没加该参数会详细输出内容：

    $ git status
    On branch master

    Initial commit

    Changes to be committed:
      (use "git rm --cached <file>..." to unstage)

    	new file:   README
    	new file:   hello.php

####git diff
执行 git diff 来查看执行 git status 的结果的详细信息。
git diff 命令显示已写入缓存与已修改但尚未写入缓存的改动的区别。git diff 有两个主要的应用场景。

* 尚未缓存的改动：git diff
* 查看已缓存的改动： git diff --cached
* 查看已缓存的与未缓存的所有改动：git diff HEAD
* 显示摘要而非整个 diff：git diff --stat

修改 hello.php 文件中输入以下内容：

    $ git status -s
    A  README
    AM hello.php
    $ git diff
    diff --git a/hello.php b/hello.php
    index e69de29..d1a9166 100644
    --- a/hello.php
    +++ b/hello.php
    @@ -0,0 +1,3 @@
    +<?php
    +echo 'www.openwudi.com';
    +?>

git status显示你上次提交更新至后所更改或者写入缓存的改动， 而 git diff 一行一行地显示这些改动具体是啥。
接下来我们来查看下 git diff --cached 的执行效果：

    $ git add hello.php
    $ git status -s
    A  README
    A  hello.php
    $ git diff --cached
    diff --git a/README b/README
    new file mode 100644
    index 0000000..704cce7
    --- /dev/null
    +++ b/README
    @@ -0,0 +1 @@
    +openwudi.com
    diff --git a/hello.php b/hello.php
    new file mode 100644
    index 0000000..d1a9166
    --- /dev/null
    +++ b/hello.php
    @@ -0,0 +1,3 @@
    +<?php
    +echo 'www.openwudi.com';
    +?>

####git commit
使用 git add 命令将想要快照的内容写入了缓存， 而执行 git commit 记录缓存区的快照。
Git 为你的每一个提交都记录你的名字与电子邮箱地址，所以第一步需要配置用户名和邮箱地址。

    $ git config --global user.name 'openwudi'
    $ git config --global user.email xxx@openwudi.com

接下来我们写入缓存，并提交对 hello.php 的所有改动。在首个例子中，我们使用 -m 选项以在命令行中提供提交注释。

    $ git add hello.php
    $ git status -s
    A  README
    A  hello.php
    $ git commit -m 'test comment from openwudi.com'
    [master (root-commit) 85fc7e7] test comment from openwudi.com
     2 files changed, 4 insertions(+)
     create mode 100644 README
     create mode 100644 hello.php

现在我们已经记录了快照。如果我们再执行 git status:

    $ git status
    # On branch master
    nothing to commit (working directory clean)

以上输出说明我们在最近一次提交之后，没有做任何改动，是一个"干净的工作目录"。

如果你觉得 git add 提交缓存的流程太过繁琐，Git 也允许你用 -a 选项跳过这一步。命令格式如下：

    git commit -a

####git reset HEAD
git reset HEAD 命令用于取消缓存已缓存的内容。
这里我们有两个最近提交之后又有所改动的文件。我们将两个都缓存，并取消缓存其中一个。

    $ git status -s
     M README
     M hello.php
    $ git add .
    $ git status -s
     M  README
     M  hello.pp
    $ git reset HEAD -- hello.php
     Unstaged changes after reset:
     M hello.php
    $ git status -s
     M  README
     M hello.php

现在你执行 git commit 将只记录 README 文件的改动，并不含现在并不在缓存中的 hello.pp。

####git rm
git rm 将文件从缓存区中移除。如我们删除 hello.php文件：

    $ git rm hello.php
    rm 'hello.php'
    $ ls
    README

默认情况下，git rm file 会将文件从缓存区和你的硬盘中（工作目录）删除。 如果要在工作目录中留着该文件，可以使用命令：

    git rm --cached

####git mv
git mv 命令做得所有事情就是 git rm --cached， 重命名磁盘上的文件，然后再执行 git add 把新文件添加到缓存区。因此，虽然有 git mv 命令，但它有点多余 。

##Git 分支管理
####创建分支命令:

    git branch (branchname)

####切换分支命令:

    git checkout (branchname)

当你切换分支的时候，Git 会用该分支的最后提交的快照替换你的工作目录的内容， 所以多个分支不需要多个目录。

####合并分支命令:

    git merge

你可以多次合并到统一分支， 也可以选择在合并之后直接删除被并入的分支。

####列出分支基本命令:

    git branch

没有参数时，git branch 会列出你在本地的分支。

    $ git branch
    * master

此例的意思就是，我们有一个叫做"master"的分支，并且该分支是当前分支。
当你执行 git init 的时候，缺省情况下 Git 就会为你创建"master"分支。
如果我们要手动创建一个分支，并切换过去。执行 git branch (branchname) 即可。

    $ git branch testing
    $ git branch
    * master
      testing

现在我们可以看到，有了一个新分支 testing。
当你以此方式在上次提交更新之后创建了新分支，如果后来又有更新提交， 然后又切换到了"testing"分支，Git 将还原你的工作目录到你创建分支时候的样子
接下来我们将演示如何切换分支，我们用 git checkout (branch) 切换到我们要修改的分支。

    $ ls
    README
    $ echo 'openwudi.com' > test.txt
    $ git add .
    $ git commit -m 'add test.txt'
    [master 048598f] add test.txt
     2 files changed, 1 insertion(+), 3 deletions(-)
     delete mode 100644 hello.php
     create mode 100644 test.txt
    $ ls
    README		test.txt
    $ git checkout testing
    Switched to branch 'testing'
    $ ls
    README		hello.php

当我们切换到"testing"分支的时候，我们添加的新文件test.txt被移除了, 原来被删除的文件hello.php文件又出现了。切换回"master"分支的时候，它们有重新出现了。

    $ git checkout master
    Switched to branch 'master'
    $ ls
    README		test.txt

我们也可以使用 git checkout -b (branchname) 命令来创建新分支并立即切换到该分支下，从而在该分支中操作。

    $ git checkout -b newtest
    Switched to a new branch 'newtest'
    $ git rm test2.txt
    rm 'test2.txt'
    $ ls
    README		test.txt
    $ git commit -am 'removed test2.txt'
    [newtest 556f0a0] removed test2.txt
     1 file changed, 1 deletion(-)
     delete mode 100644 test2.txt
    $ git checkout master
    Switched to branch 'master'
    $ ls
    README		test.txt	test2.txt

如你所见，我们创建了一个分支，在该分支的上下文中移除了一些文件，然后切换回我们的主分支，那些文件又回来了。
使用分支将工作切分开来，从而让我们能够在不同上下文中做事，并来回切换。

####删除分支命令:

    git branch -d (branchname)

####分支合并:

    git merge (branchname)

####合并冲突:
合并并不仅仅是简单的文件添加、移除的操作，Git 也会合并修改。

    $ git branch
    * master
    $ cat test.txt
    openwudi.com

首先，我们创建一个叫做"change_site"的分支，切换过去，我们将内容改为 www.openwudi.com 。

    $ git checkout -b change_site
    Switched to a new branch 'change_site'
    $ vim test.txt
    $ head -1 test.txt
    www.openwudi.com
    $ git commit -am 'changed the site'
    [change_site d7e7346] changed the site
     1 file changed, 1 insertion(+), 1 deletion(-)

将修改的内容提交到 "change_site" 分支中。 现在，假如切换回 "master" 分支我们可以看内容恢复到我们修改前的，我们再次修改test.txt文件。

    $ git checkout master
    Switched to branch 'master'
    $ head -1 test.txt
    openwudi.com
    $ vim test.txt
    $ cat test.txt
    openwudi.com
    新增加一行
    $ git diff
    diff --git a/test.txt b/test.txt
    index 704cce7..f84c2a4 100644
    --- a/test.txt
    +++ b/test.txt
    @@ -1 +1,2 @@
     openwudi.com
    +新增加一行
    $ git commit -am '新增加一行'
    [master 14b4dca] 新增加一行
     1 file changed, 1 insertion(+)

现在这些改变已经记录到我的 "master" 分支了。接下来我们将 "change_site" 分支合并过来。

    $ git merge change_site
    Auto-merging test.txt
    CONFLICT (content): Merge conflict in test.txt
    Automatic merge failed; fix conflicts and then commit the result.
    $ cat test.txt
    <<<<<<< HEAD
    openwudi.com
    新增加一行
    =======
    www.openwudi.com
    >>>>>>> change_site

我们将前一个分支合并到 "master" 分支，一个合并冲突就出现了，接下来我们需要手动去修改它。

    $ vim test.txt
    $ cat test.txt
    www.openwudi.com
    新增加一行
    $ git diff
    diff --cc test.txt
    index f84c2a4,bccb7c2..0000000
    --- a/test.txt
    +++ b/test.txt
    @@@ -1,2 -1,1 +1,2 @@@
    - openwudi.com
    + www.openwudi.com
     +新增加一行

在 Git 中，我们可以用 git add 要告诉 Git 文件冲突已经解决

    $ git status -s
    UU test.txt
    $ git add test.txt 
    $ git status -s
    M  test.txt
    $ git commit
    [master 88afe0e] Merge branch 'change_site'

现在我们成功解决了合并中的冲突，并提交了结果。

##Git 查看提交历史
回顾下提交历史，我们可以使用 git log 命令查看。

    git log

可以用 --oneline 选项来查看历史记录的简洁的版本。

    git log --oneline

还可以用 --graph 选项，查看历史中什么时候出现了分支、合并。以下为相同的命令，开启了拓扑图选项：

    git log --oneline --graph

用 '--reverse'参数来逆向显示所有日志。

    git log --reverse --oneline

查找指定用户的提交日志可以使用命令：git log --author

    git log --author=openwudi --oneline -5

指定日期，可以执行几个选项：--since 和 --before，但是你也可以用 --until 和 --after。

更多 git log 命令可查看：[http://git-scm.com/docs/git-log](http://git-scm.com/docs/git-log)

##Git 标签
如果你达到一个重要的阶段，并希望永远记住那个特别的提交快照，你可以使用 git tag 给它打上标签。
-a 选项意为"创建一个带注解的标签"。 不用 -a 选项也可以执行的，但它不会记录这标签是啥时候打的，谁打的，也不会让你添加个标签的注解。 我推荐一直创建带注解的标签。

    git tag -a v1.0

当你执行 git tag -a 命令时，Git 会打开你的编辑器，让你写一句标签注解，就像你给提交写注解一样。

现在，注意当我们执行 git log --decorate 时，我们可以看到我们的标签了。

如果我们要查看所有标签可以使用以下命令：

    $ git tag
    v0.9
    v1.0

##Git 远程仓库
Git 并不像 SVN 那样有个中心服务器。
目前我们使用到的 Git 命令都是在本地执行，如果你想通过 Git 分享你的代码或者与其他开发人员合作。 你就需要将数据放到一台其他开发人员能够连接的服务器上。

###添加远程库
要添加一个新的远程仓库，可以指定一个简单的名字，以便将来引用,命令格式如下：

    git remote add [shortname] [url]

###查看当前的远程库
查看当前配置有哪些远程仓库，可以用命令：

    git remote

执行时加上 -v 参数，你还可以看到每个别名的实际链接地址。

###提取远程仓库
Git 有两个命令用来提取远程仓库的更新。

1、从远程仓库下载新分支与数据：

    git fetch

该命令执行完后需要执行git merge 远程分支到你所在的分支。

2、从远端仓库提取数据并尝试合并到当前分支：

    git pull

###推送到远程仓库
推送你的新分支与数据到某个远端仓库命令:

    git push [alias] [branch]

###删除远程仓库
删除远程仓库你可以使用命令：

    git remote rm [alias]
