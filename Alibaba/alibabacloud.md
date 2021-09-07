# 알리클라우드 


ECS
- 데이터센터 : 중국(항저우)
- ECS 인스턴스 유형: ecs.t5-lc1m1.small
- ECS 인스턴스: 코어 CPU 1개(Intel Xeon)
- 메모리: 1GB 메모리(DDR4)
- 1MB 인터넷 대역폭(VPC)

==> 인스턴스 생성, 실명인증 필요 


RDS 설정 
- 사양: 1Core 1GB (rds.mysql.t1.small)
- 지역: China (Hangzhou)
- 데이터베이스 엔진: mysql 5.6
- 판: 고 가용성 
- 저장유형: Local SSD
- 네트워크 유형: Classic Network
- 저장용량: 20G
- 지속: 1개월 



## 속도 느림 
### EIP 구매 후 ECS에 연결 후 테스트 
- 종량제 
- 지역: 항저우 
- 네트워크 트래픽 : 트래픽 기준
- 최대 대역폭 : 200Mbps
- 사용료: $0.003/시간 
- 공공트래픽사용료: $0.123/GB 




### Global Accelerator 가격
https://www.alibabacloud.com/ko/product/ga#J_8647712520



z9nE1p

ssh password: @Emoldino1


## 2020-08-07
### ECS 인스턴스 생성 
- ecs.t5-c1m1.large (2vCpu, 2gb)
- key pair name: ali-emoldino
- hdd: 20gb
- SSH 비밀번호 reset: @Emoldino1 인스턴스 상세에서 상단 More > Reset Password
- EIP: 121.41.86.83
- 1개월 단위 자동 결제: 14.

> 생성 후 Internet IP가 할당되지 않아 인스턴스 목록에서 기존에 생성해둔 EIP를 할당함.

### ECS 접속 
```
ssh root@121.41.86.83

$ yum -y update
$ yum install -y java-1.8.0-openjdk-devel.x86_64

```

### RDS 인스턴스 생성 
- Billing Method: Subscription
- Region: 항저우
- Database: Mysql 5.7
- Edition: Basic
- Storage Type: Standard SSD
- Zone: Hangzhou Zone H
- Instant Type: mysql.n1.micro.1 (1CPU, 1GB)
- 1Month : $6.50

인스턴스 생성 후 상세에서 
- apply public access
- configure Whitelist

### Database 생성 
좌측 Databases 메뉴에서 DB생성.

- Database Name: mms
- Supported Character Sets: utf8mb4
- Authorized Account: 미설정 


### DB 계정 생성 
좌측 Accounts 메뉴에서 계정 생성.
- Database Account: mms
- Authorized Databases: mms -> 선택 후 Read/Write 권한 
- Account Type: Starndard Account
- Password: emoldino^&^%  



## 2020-08-27
처음 프리티어로 사용하던 RDS 기간 만료 (8/24) - 1달 연장(renew) => 24달러 
새로 생성하고 사용량기준으로 하면 시간당 0.01달러 (1달 기준 7.2달)러
새로 생성하기로 함. 


### RDS 인스턴스 생성 
1. Basic Configuration
- Billing Method: Pay-As-You-Go
- Region: 항저우
- Database: Mysql 5.7
- Edition: Basic
- Storage Type: Standard SSD
- Zone: Hangzhou Zone H
- Instant Type: mysql.n1.micro.1 (1CPU, 1GB)
- Capacity: 20GB
- Fee : $0.01/Hour

2. Instance Configuration
- 기본값 

인스턴스 생성 후 상세에서 
- apply public access
- configure Whitelist


### ECS 접속
```
ssh root@121.41.86.83

$ yum -y update
$ yum install -y java-1.8.0-openjdk-devel.x86_64

```

### RDS 인스턴스 생성
- Billing Method: Subscription
- Region: 항저우
- Database: Mysql 5.7
- Edition: Basic
- Storage Type: Standard SSD
- Zone: Hangzhou Zone H
- Instant Type: mysql.n1.micro.1 (1CPU, 1GB)
- 1Month : $6.50

인스턴스 생성 후 상세에서
- apply public access
- configure Whitelist

### Database 생성
좌측 Databases 메뉴에서 DB생성.

- Database Name: mms
- Supported Character Sets: utf8mb4
- Authorized Account: 미설정


### DB 계정 생성
좌측 Accounts 메뉴에서 계정 생성.
- Database Account: mms
- Authorized Databases: mms -> 선택 후 Read/Write 권한
- Account Type: Starndard Account
- Password: emoldino^&^%



## 2020-08-27
처음 프리티어로 사용하던 RDS 기간 만료 (8/24) - 1달 연장(renew) => 24달러
새로 생성하고 사용량기준으로 하면 시간당 0.01달러 (1달 기준 7.2달)러
새로 생성하기로 함.


### RDS 인스턴스 생성
1. Basic Configuration
- Billing Method: Pay-As-You-Go
- Region: 항저우
- Database: Mysql 5.7
- Edition: Basic
- Storage Type: Standard SSD
- Zone: Hangzhou Zone H
- Instant Type: mysql.n1.micro.1 (1CPU, 1GB)
- Capacity: 20GB
- Fee : $0.01/Hour

2. Instance Configuration
- 기본값

인스턴스 생성 후 상세에서
- apply public access
- configure Whitelist
