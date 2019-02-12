# Git에서 특정 경로만 clone 하기 

## 1. git 저장소 생성 (local)
```
$ git init test
$ cd test
```

## 2. 부분 체크아웃이 가능하도록 설정 
```
$ git config core.sparseCheckout true
```

## 3. remote repository 연결 
```
$ git remote add -f origin https://test.git
```

## 4. 부분 체크아웃 받을 경로 설정  
```
$ echo "sample/test" >> .git/info/sparse-checkout
```

## 5. Pull 
```
$ git pull origin master
```

[- 참고 URL](
https://www.lesstif.com/pages/viewpage.action?pageId=20776761)