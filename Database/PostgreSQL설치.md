# PostgreSQL 설치 (CentOS 7)
> Date: 2019-06-18  
> Author: skc@onlinepowers.com

## 설치하기 
> PostgreSQL 홈페이지의 다운로드 메뉴에 접속 [다운로드](https://www.postgresql.org/download/linux/redhat/)   
> 버전, 플랫폼, 아키텍처 등을 설정하면 설치 가이드가 표시됨.

### RPM Repository 설치 
```
 yum install https://download.postgresql.org/pub/repos/yum/reporpms/EL-7-x86_64/pgdg-redhat-repo-latest.noarch.rpm
```

### Client Packages 설치 
```
 yum install postgresql11
```

### Server Packages 설치 (Optional)
```
 yum install postgresql11-server
```

### DB 초기화 및 자동 시작 설정.
```
 /usr/pgsql-11/bin/postgresql-11-setup initdb
 systemctl enable postgresql-11
 systemctl start postgresql-11
```

## 설치확인 
### 설치 버전 확인
```
 $ /usr/pgsql-11/bin/postgres --version
 postgres (PostgreSQL) 11.3
```

### psql 접속 
```
 $ psql
 psql: 치명적오류:  "root" 롤(role) 없음
```
PostgreSQL을 설치할 때 postgres 계정이 생성됨.  
postgres 계정으로 psql 접속이 가능함. 
```
 $ su - postgress   (sudo su -postgress)
 
 $ psql
 psql (11.3)
 도움말을 보려면 "help"를 입력하십시오.
 
 postgres=#
```

특정 DB에 일반사용자로 접속 
```
 $ psql -d SALESON3 -U saleson3
```


### psql에서 버전 확인 
```
postgres=# select version();

                                                 version
---------------------------------------------------------------------------------------------------------
 PostgreSQL 11.3 on x86_64-pc-linux-gnu, compiled by gcc (GCC) 4.8.5 20150623 (Red Hat 4.8.5-36), 64-bit
(1개 행)

```


## 계정 및 DB 생성
### 계정 생성 
```
 postgres=# CREATE ROLE saleson3 login password 'pw92%@';
```

### DB 생성  
```
 postgres=# CREATE DATABASE SALESON3 OWNER=saleson3;
 GRANT
```

### DB 권한 주기  
```
 postgres=# GRANT ALL PRIVILEGES ON DATABASE SALESON3 TO saleson3;
```

### 비밀번호 변경 
```
 postgres=# \password saleson3;
```

### 계정삭제 
```
 postgres=# DROP ROLE test;
```

## 타임존 설정 (시간)
### postgresql.conf
```
 $ vi /var/lib/pgsql/11/data/postgresql.conf
  
 // 변경할 부분
 timezone = 'ROK'
 log_timezone = 'ROK'

 // 변경 내용
 timezone = 'Asia/Seoul'
 log_timezone = 'Asia/Seoul'
 
 
 $ service postgresql-11 restart
  
```
### Intellij Database 설정
```
 # vm 옵션 추가 
 -Duser.timezone=Asia/Seoul   
```


## 외부 접속 허용
### 1. pg_hba.conf에 호스트 정보 추가 
```
 host   all     all     0.0.0.0/0   password     
```

### 2. postgresql.conf
```
 $ vi /var/lib/pgsql/11/data/postgresql.conf
 
 // 변경할 부분
 #listen_addresses = 'localhost'         # what IP address(es) to listen on;
 
 // 변경 내용
 listen_addresses = '*'         # what IP address(es) to listen on;
 
``` 

### 3. 방화벽 설정 
방화벽 설정에 tcp / 5432 포트를 추가한다.  
centos7 인 경우 `firewall-cmd`를 통해 추가함 

#### 상태확인
```
 $ firewall-cmd --state
 running
```

#### 5432 포트 추가 
```
 $ firewall-cmd --add-port=5432/tcp
```


## 오류사항 
### 1. 신규 생성 계정으로 psql 접속 시 오류 
```
 $ psql -d saleson3 -U saleson3;
 psql: 치명적오류:  사용자 "saleson3"의 peer 인증을 실패했습니다.
```
- 시스템 계정과 DB 소유자 계정이 같아야 peer인증이 가능함.  
 (DB계정 만들 때마다 시스템 계정 생성?? 이건 아니지!! 여러 계정이 접속할 때는??)

#### pg_hba.conf
pg_hba.conf는 시스템 사용자와 소유자가 다른 경우 맵핑 정보를 설정함.
`peer`부분을 `md5`로 변경함. (or `trust)
```
 $ vi /var/lib/pgsql/11/data/pg_hba.conf
 
 
 # TYPE  DATABASE        USER            ADDRESS                 METHOD
 
 # "local" is for Unix domain socket connections only
 local   all             all                                     peer
 # IPv4 local connections:
 host    all             all             127.0.0.1/32            ident
 # IPv6 local connections:
 host    all             all             ::1/128                 ident
 # Allow replication connections from localhost, by a user with the
 # replication privilege.
 local   replication     all                                     peer
 host    replication     all             127.0.0.1/32            ident
 host    replication     all             ::1/128                 ident
```




## 기타 명령 
```
\du : 유저 목록 (\du+)
\l  : DB 목록 
\q  : psql 종료 
```





