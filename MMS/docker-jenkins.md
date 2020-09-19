# Jenkins (Docker)
> http://jmlim.github.io/docker/2019/02/25/docker-jenkins-setup/


## 1. Jenkins 이미지 내려 받기
```
docker pull jenkins/jenkins:lts
```


### 2. Jenkins 이미지를 컨테이너로 실행하기
```
docker run -d -p 8181:8080 -v /Users/dbclose/eshotlink/jenkins:/var/jenkins_home --env JAVA_OPTS="-Xmx1024m -Djava.awt.headless=true" --name jenkins-mms -u root jenkins/jenkins:lts

```

### 3. Jenkins 설정 
> localhost:8181 접속 
- default plugin
- admin : dbclose/skc9252


#### Global Tool Configuration
- OpenJdk8
- gradle 5.6


