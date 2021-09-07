# 리뉴올PC 개발서버세팅 (renewallpc)
> 2021.02.15 
> tomcat 9.0.39 (zip 압축 해제-9080, 9005, 9009, 9443)
> nginx (conf => server 항목 추가)

## 서버 배포 방법 
### 1. Gradle Build 
intellij에서 Gradle build --exclude-task test 실행하거나 
CMD에서 `gradlew` 명령으로 빌드한다. 

```gradle
$ ./gradlew build --exclude-task test
```

### 2. 파일 업로드 
원격데스크톱으로 연결하거나 SSH로 서버에 접속하여 deploy폴더에 빌드된 파일을 업로드 한다.

#### 빌드된 파일 
- Static : ~/build/distributions/saleson-static.zip
- War : ~/saleson-web/build/libs/saleson-web-3.13.0.war

#### 원격데스크톱 접속 정보 
- IP: 211.115.212.42
- PORT: 9751
- ID/PW: administrator/uniForen1!

#### SSH 접속 
- IP: 211.115.212.42
- PORT: 22
- ID/PW: deploy/pw92%@

#### 배포 폴더 
- G:\home\saleson-dev\deploy

#### 배포 실행 
원격데스크톱 접속 후 배포 폴더에 deploy.bat 파일을 실행한다. 

## 시스템 정보 
### 설치 정보 
- Web Server: nginx 1.18.0  => default.conf (server 항목 추가)
- WAS: Tomcat 9.0.39
- Java: OpenJDK 1.8.0.265  (운영과 동일)
- DB: Mysql Community 8.0.22.0  (운영과 동일)

### 서버 설치 경로 
- tomcat: G:\server\tomcat-dev
- bin\startup.bat, shutdown.bat, service.bat 파일 수정. 


서비스 등록
```
service.bat install tomcat8-dev
```

서비스 제거
```
service.bat remove tomcat8-dev
```

### 서버 시작 / 중지
윈도우 서비스에 등록되어 있음.

- tomcat: 서비스로 등록됨 (서비스 이름: Tomcat9-DEV - Apache Tomcat 9.0)




### MYSQL 접속 정보 
> root password: uniForen1!

#### 개발 DB 정보
- IP : 211.115.212.42
- PORT: 3306
- DB: SALESON_RENEWALLPC_DEV
- id/pw: renewallpc-dev / renewall92%@



### DB 및 사용자 생성 
```sql
CREATE DATABASE SALESON_RENEWALLPC_DEV;
CREATE USER 'renewallpc-dev'@'localhost' IDENTIFIED WITH mysql_native_password BY 'renewall92%@';
GRANT ALL PRIVILEGES ON SALESON_RENEWALLPC_DEV.* TO 'renewallpc-dev'@'localhost' WITH GRANT OPTION;

CREATE USER 'renewallpc-dev'@'112.216.32.194' IDENTIFIED WITH mysql_native_password BY 'renewall92%@';
GRANT ALL PRIVILEGES ON SALESON_RENEWALLPC_DEV.* TO 'renewallpc-dev'@'112.216.32.194' WITH GRANT OPTION;
```

