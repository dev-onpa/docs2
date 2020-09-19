# GitLab Upgrade 설치 (8번 서버)
> upgrade, update, 업그레이드 

## Reference
- https://www.youtube.com/watch?v=XLfK_aOWZwU
- https://about.gitlab.com/update/#centos-7


## 1. Make a backup (Optional)

If you would like to make a backup before updating, the below command will backup data in /var/opt/gitlab/backups by default.

```
$ gitlab-rake gitlab:backup:create STRATEGY=copy
```

## 2. Update GitLab
Update to the latest version of GitLab.

```
$ yum install -y gitlab-ce
$ gitlab-ctl restart
```

## 3. 버전 차이가 많이 나는 경우 단계별 업그레이드 
> https://docs.gitlab.com/ce/policy/maintenance.html#upgrade-recommendations

```
yum install -y gitlab-ce-11.11.8-ce.0.el7
yum install -y gitlab-ce-12.0.12-ce.0.el7
yum install -y gitlab-ce-12.10.6-ce.0.el7
yum install -y gitlab-ce-13.0.0-ce.0.el7
yum install -y gitlab-ce-13.2.0-ce.0.el7
```


## 기타
GitLab 설정파일 : /etc/gitlab/gitlab.rb


## 업그레이드 정보
- 2020-08-14 13.2.4 업그레이드
- 2020-08-04 13.0.12 13버전 부터 웹서버로 unicon을 사용하지 않아 오류 발생 (gitlab.rb 파일에서 정보수정)
