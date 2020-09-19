# [Git] Revert (Merge) 된 브랜치가 있는 경우

git commit 취소에 대해서는 revert를 해서 해당 commit 번호를 입력하면 된다.

하지만 merge된 branch에 하면 오류가 발생 할것이다.

예를 들어서 develop 브랜치에 feature branch를 merge했다고 보자.
그리고 해당 featrue를 revert 하고 싶지만 에러가 발생하기도 할 것이다.

git은 자신의 부모가 누구였는지 정확히 모른다. 그래서 부모를 지정 해줘야 한다.

```
git log
```
를 통해서 log를 보면

```
Merge: 8989ee0 7c6b236
```
위와 같은 문구가 있을 것이다. 부모가 2개이기에 그런것이다. 그래서 revert시 -m (부모 번호) 를 입력 해줘야 한다.
develop 브랜치에 merge가 되었고 feature를 revert하고 싶은 것이면 -m 1 옵셥을 주면 된다.

## case 1
```
git revert (merge 되기전 develop 브랜치의 commit 번호) -m 1
```

## case 2
```
git revert HEAD -m 1
```

## case 3 ( 한번에 여러개 가능 )

```
git checkout -b revert-branch # 새로운 브랜치
git reset 56e05fced ( 예) 되돌리고 싶은 커밋 번호 - 5개 전 )
git reset --soft HEAD@{1}
git commit -m "Revert to 56e05fced"
git reset --hard
git checkout [revert하는 branch]
git merge --no-ff revert-branch
```

# 2020-02-07
git checkout -b revert-f15bc102 # 새로운 브랜치
git reset f15bc102 ( 예) 되돌리고 싶은 커밋 번호 - 5개 전 )
git reset --soft HEAD@{1}
git commit -m "Revert to f15bc102"
git reset --hard
git checkout master
git merge --no-ff revert-f15bc102








## 참조
- https://bugtypekr.tistory.com/67