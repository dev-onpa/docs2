# Git에서 .DS_Store 파일 제거

## .DS_Store 파일 제거
1. 기존파일 제거
```
find . -name .DS_Store -print0 | xargs -0 git rm -f --ignore-unmatch

echo .DS_Store >> .gitignore

git add .gitignore

git commit -m '.DS_Store banished!'
```
