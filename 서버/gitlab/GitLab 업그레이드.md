# GitLab 설치 (8번 서버)

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