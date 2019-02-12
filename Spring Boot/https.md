# Spring Boot SSL 적용 

application.properties
```
server.port=8443 #

# 키 저장소 경로 server.ssl.key-store=C:/Program Files/Java/jdk1.8.0_45/bin/keystore.jks 

# 키 저장소 
server.ssl.key-store-password=설정했던비밀번호 

# alias에 맞는 비번 
server.ssl.key-password=설정했던비밀번호 
server.ssl.key-alias=설정했던별칭 
server.ssl.trust-store=C:/Program Files/Java/jdk1.8.0_45/bin/cacerts.jks server.ssl.trust-store-password=설정했던비밀번호

```


출처: https://seongtak-yoon.tistory.com/10 [테이키스토리]