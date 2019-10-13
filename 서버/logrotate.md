# Logrotate

## 설정
1. /etc/logrotate.d 디렉토리 안에 아래의 파일을 생성

```
$ cd /etc/logrotate.d
$ cat  tomcat

${CATALINA_HOME}/logs/catalina.out {
 copytruncate
 daily
 rotate 30
 compress
 missingok 
 notifempty
 dateext
}
```

> - copytruncate : 기존 파일을 백업해서 다른 파일로 이동하고 기존 파일은 지워버리는 옵션  
> - daily : 로그파일을 날짜별로 변환  
> - compress : 지나간 로그파일들을 gzip으로 압축  
> - dateext : 순환된 로그파일의 날짜확장자  
> - missingok : 로그파일이 없더라도 오류를 발생시키지 않음  
> - rotate 30 : 로그 파일은 30개만큼 저장된 다음 제거되거나 메일로 보내짐  
> - notifempty : 파일의 내용이 없으면 새로운 로그 파일을 생성 안함  


## TEST
```
$logrotate -f /etc/logrotate.d/tomcat # 로그파일 순환 테스트
```

