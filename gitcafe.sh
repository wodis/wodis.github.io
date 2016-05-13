cd _deploy
# 添加 gitcafe 源
git remote add coding git@git.coding.net:wodis/wodis.git >> /dev/null 2>&1
# 提交博客内容
echo "### Pushing to GitCafe..."
git push -u coding master:coding-pages
echo "### Done"%