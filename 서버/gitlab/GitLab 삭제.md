# GitLab 삭제 (gitlab-ce)

## Reference
- https://jpss.ta3ke.com/250


## 1. 서비스 제거 

```
$ gitlab-ctl uninstall
```

## 2. 클린업 데이터 
```
$ gitlab-ctl cleanse
```

## 3. 계정 제거  
```
$ gitlab-ctl remove-accounts
```

## 4. 패키지 제거 (CentOS 7)  
```
$ yum remove gitlab-ce
```