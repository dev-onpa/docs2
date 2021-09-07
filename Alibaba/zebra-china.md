# Zebra China (알리클라우드) 
> 2021.09.03


## ECS 인스턴스 생성
Basic
- Billing Method: Subscription
- Region: Chaina (Hangzhou) - Zone H
- Instance Type: ecs.t5-c1m1.large (2vCpu, 2gb)
- Burstable Instance: 체크
- Quantity: 1
- Image: abb-china
- Storage: Ultra Disk, 40Gib (40이 최소)

Networking
- Network Type: VPC
- Public IP Address: 체크
- Bandwidth Billing:  Pay-By-Bandwidth
- Bandwidth: 1Mbps
- 나머지 디폴트

System Configuration
- key pair name: ali-emoldino
- Instance Name: zebra-china
- Description: Zebra China

Grouping
- default

Preview
- Duration: 1 Month
- Auto-renewal:  체크 (Enable Auto-renewal)
- Terms of Service: 체크

`Create Order`


### SSH 비밀번호 변경
- 콘솔에서 instance 상세 페이지 우측 상단 `Reset Password`
- Login Password: @Emoldino1
- Confiram Password: @Emoldino1
- Restart


### ECS 접속
```
ssh root@114.55.66.143
```



## RDS 인스턴스 생성
> 2021.09.07

1. Basic Configuration
- Billing Method: Subscription
- Region: 항저우
- Database Engine: Mysql 5.7
- Edition: Basic
- Storage Type: Enhanced SSD (Recommended)  => Standard SSD와 월 500원 차이남.
- Zone of Primary Node: Hangzhou Zone H

- Instant Type: mysql.n1.micro.1 (1CPU, 1GB)
- Capacity: 20GB
- Duration: 1Month
- Fee : $6.96

2. Instance Configuration
- Time Zone: UTC+08:00
- Table Name Case Sensitivity: Case-insensitive(default) => 대소문자 구분없음. 
- 기본값

3. Confirm Order
- Auto-Renew Enabled: 체크함 => 월별 자동 결제 

`Pay Now`


### DB 접속 설정 
인스턴스 생성 후 상세에서
- Public Endpoint: `Apply for Public Endpoint`
- `configure Whitelist` 클릭하여 접속 허용 IP를 추가함. 


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
- Password: Emoldino^&^%  

### DB 접속 정보 
- host: rm-1ud83m171w3l669ud3o.mysql.rds.aliyuncs.com
- port: 3306
- db: mms
- id: mms
- pw: Emoldino^&^%


### 기본 데이터 등록 
```properties
mysql -umms -p -h rm-1ud83m171w3l669ud3o.mysql.rds.aliyuncs.com mms < mms-20210621.sql


ERROR 1071 (42000) at line 499: Specified key was too long; max key length is 767 bytes
```

DB Parameter 수정 
innodb_large_prefix: OFF -> ON 으로 변경 
