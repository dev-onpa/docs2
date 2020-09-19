# Git

1. 분산 버전 관리 시스템 

## 시작하기

develop 브랜치만 클론 하기
  git clone -b develop http://sadfasd/test.git


git commit 취속 
- https://gmlwjd9405.github.io/2018/05/25/git-add-cancle.html



### Git Download
git을 다운로드 한다. [다운로드](http://www.naver.com)
`


```linux
$ git clone http://www.asdfasf.com/asdf.git
```

## 사용 방법

### 특정 커밋으로 체크아웃 
- git log, git reflog 조회 시 해시 값 6자리로 checkout
```
$ git checkout e4f2fd
```


### 특정 파일만 merge 하기  
- develop 브랜치에 feature-01 에 있는 /aaa/bb/cc/test.jsp 파일만 머지 하기 
```
$ git checkout develop

$ git checkout feature-01 -- /aaa/bb/cc/test.jsp
```

### Merge 할 때 한쪽 방향으로 덮어쓰기 
```
git merge -X ours 브랜치명 (내것으로 auto merge)

git merge -X theirs 브랜치명 (상대것으로 auto merge)
```

### Merge 취소 
- 머지 중일 때만 가능 
- Merge 했는데 충돌이 많아 취소하고 싶다.

```
$ git merge --abrort
```


### Reset 과 Revert
- 커밋, 머지 되돌리기 
- Reset 커밋 이력까지 되돌리기 
- Revert는 이전 커밋 유지 새로운 커밋 생성 

#### Reset
```
$ git reset [--hard|--soft|--mixed] [커밋 버전]

$ git reset --hard ef3da3
````


### 원격 저장소에 올라간 커밋 되돌리기
#### 1. 로컬에서 커밋을 되돌린 후 강제 커밋 

먼저 로컬에서 $ git reset 명령어를 이용해 내가 되돌리고 싶은 커밋들을 되돌린다.
``` 
$ git reset --hard HEAD~3

$ git push origin master  (에러문구: reject)

```
로컬 저장소의 커밋 히스토리가 원격 저장소의 커밋 히스토리보다 뒤쳐져 있는데 푸시를 하였으므로 발생하는 에러이다.  
하지만 지금 우리가 원하는 것은 이 뒤쳐져 있는 로컬 저장소의 커밋 히스토리를 원격 저장소의 커밋 히스토리로 강제로 덮어쓰는 것이므로 이를 위한 옵션 `-f` 또는 `--force 를 명령어에 추가하여야 한다.
```
$ git push -f origin master
```

주의사항 
이 방법을 이용하면 원격 저장소에 흔적도 없이 내가 만들었던 커밋들을 제거할 수 있으므로 겉보기에는 가장 깔끔한 해결책으로 보인다. 
하지만 만약 해당 브랜치가 팀원들과 공유하는 브랜치이고, 내가 커밋들을 되돌리기 전에 다른 팀원이 혹시나 내가 작성한 커밋들을 이미 pull로 땡겨갔다면, 그때부터 다른 팀원의 로컬 저장소에는 내가 되돌린 커밋들이 남아있게 된다. 
그 커밋들이 되돌려진 사실을 모르는 팀원은 자신이 작업한 커밋들과 함께 push할 것이고, 그 때 내가 되돌렸던 커밋들이 다시 원격 저장소에 추가되게 된다.

따라서 이 방법은 다른 팀원이 내가 되돌린 커밋들을 pull로 땡겨가지 않았다고 확신할 수 있는 경우, 
예를 들어,

나 혼자만 사용하는 브랜치에 커밋을 push하였고, 이를 되돌리고 싶은 경우
팀원들과 직접 커뮤니케이션해서 내가 되돌린 커밋을 pull로 땡겨간 팀원이 없다고 확인된 경우
이러한 경우에는 안전하고 간편하게 사용할 수 있는 방법이다.


#### 2. 로컬에서 커밋을 되돌린 후 강제 커밋 


 
- https://jupiny.com/2019/03/19/revert-commits-in-remote-repository/