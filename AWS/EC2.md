# Amazon EC2

아마존 웹 서비스 : 
- http://www.itworld.co.kr/print/81311
- https://librewiki.net/wiki/%EC%95%84%EB%A7%88%EC%A1%B4_%EC%9B%B9_%EC%84%9C%EB%B9%84%EC%8A%A4/Free_Tier_%EC%A3%BC%EC%9D%98%EC%82%AC%ED%95%AD
- https://coding8.tistory.com/9





## AWS 로그인 
sales@emoldino.com / !Chris6388 



## EC2 인스턴스 생성 
1. AMI(Amazon machine Image) 선택 : Amazon Linux AMI 2018.03  -- CentOs 계
2. 인스턴스 유형 : t2.micro (프리티어 사용가능)
3. 인스턴스 구성 : 기본값
4. 스토리지 추가 : 기본 
5. 태그 추가 : 기본값 (미설정)
6. 보안 그룹 구성 : 기본값 (0.0.0.0)
7. 검토 -> 시작하기 
8. 키페이 생성 
    - 키페어 이름 : emoldino
    - 키페어 다운로드 : emoldino.pem
    - `인스턴스 시작`

> 프리 티어 사용 가능 고객은 최대 30GB의 EBS 범용(SSD) 또는 마그네틱 스토리지를 사용할 수 있습니다.
> [프리티어 세부 정보 보기](https://aws.amazon.com/ko/free/?all-free-tier.sort-by=item.additionalFields.SortRank&all-free-tier.sort-order=asc)


### Linux 인스턴스에 연결하는 방법
- Linux 인스턴스에 연결 : https://docs.aws.amazon.com/ko_kr/AWSEC2/latest/UserGuide/AccessingInstances.html
- 키페어 파일 권한 설정 : 400
```
$ chmod 400 /Users/dbclose/onlinepowers/aws/emoldino.pem
```
- SSH로 접속하기 
```
$ ssh ec2-user@ec2-18-218-222-8.us-east-2.compute.amazonaws.com -i /Users/dbclose/onlinepowers/aws/emoldino.pem
```



## Elastic IP (고정아이파 힐당)
- ec2 관리 콘솔에서 네트워크 및 보안 > 탄력적 IP
- 새주소 할당 : 3.18.124.254

### 주소 연결하기 
- 할당 받은 IP에서 주소 연결 실행
- 인스턴스 선택 : 
- 프라이빗IP 선택 : 172.31.385.75
- 연결 

### EC2 서버 접속 정보 변경 
```
ssh ec2-user@ec2-18-218-222-8.us-east-2.compute.amazonaws.com -i /Users/dbclose/onlinepowers/aws/emoldino.pem

ssh ec2-user@3.18.124.254 -i /Users/dbclose/onlinepowers/aws/emoldino.pem
ssh ec2-user@3.130.186.22 -i /Users/dbclose/onlinepowers/aws/emoldino.pem
```



### OpenJdk 1.8 설치 
- 설치 가능 jdk보기 (-devel이 붙어 있어야 JDK임.)
```
$ yum list java*jdk-devel
```
- jdk 1.8 설치 
```
$ yum install java-1.8.0-openjdk-devel.x86_64
``` 

- JAVA 버전 변경 
```
$ /usr/sbin/alternatives --config java

2 개의 프로그램이 'java'를 제공합니다.

  선택    명령
-----------------------------------------------
*+ 1           /usr/lib/jvm/jre-1.7.0-openjdk.x86_64/bin/java
   2           /usr/lib/jvm/jre-1.8.0-openjdk.x86_64/bin/java

현재 선택[+]을 유지하려면 엔터키를 누르고, 아니면 선택 번호를 입력하십시오:2 (2번 엔터)

$ java -version
  openjdk version "1.8.0_201"
  OpenJDK Runtime Environment (build 1.8.0_201-b09)
  OpenJDK 64-Bit Server VM (build 25.201-b09, mixed mode)
```

- JAVA 1.7 버전 삭제 
```
$ yum remove java-1.7.0-openjdk
```


## RDS (mysql) 인스턴스 생성 
1. 전체서비스 > 데이터베이스 > RDS 선택하여 Amazon RDS에 접속 
2. `데이터베이스 생성`

### 데이터베이스 생성 
1. 엔진선택 : mysql (RDS 프리 티어에 적용되는 옵션만 사용에 체크 )
2. DB 세부 정보 지정 
    - 스토리지 자동 조정 : 체크해제
    - DB 인스턴스 식별자 : emoldino-mysql
    - 마스터 사용자 이름 : emoldino
    - 마스터 암호 : rnfhpowers^&^%
    - 나머진 기본값 설정.
3. 고급 설정 구성
    - 퍼블릭 엑세스 가능성 : 예 (외부접속을 위해 필요)
    - VPC 보안 그룹 : 새로운 VPC 보안 그룹 만들기
     
    - 데이터베이스 이름 : MMS
    - IAM DB 인증 : 비활성화 
    - 백업 보존 기간 : 1일 
    
    - 삭제 방지 활성화 : 체크 해제.
4. 데이터베이스 생성     
    
```
host : mms.csmnutrnrwsm.us-east-2.rds.amazonaws.com
port : 3306
db : MMS
id : emoldino
pw : rnfhpowers^&^%
```
> [자습서보기](https://aws.amazon.com/ko/getting-started/tutorials/create-mysql-db/)

### mysqldump로 export한 파일을 Amazon RDS (mysql)에 import하기 
- 방법은? 찾아봅시다.
- intelliJ를 이용해서 ddl 생성 후 데이터 임포트.



## Elastic IP (고정아이파 힐당)
- ec2 관리 콘솔에서 네트워크 및 보안 > 탄력적 IP
- 새주소 할당 : 3.18.124.254

### 주소 연결하기 
- 할당 받은 IP에서 주소 연결 실행
- 인스턴스 선택 : 
- 프라이빗IP 선택 : 172.31.385.75
- 연결 

### EC2 서버 접속 정보 변경 
```
ssh ec2-user@ec2-18-218-222-8.us-east-2.compute.amazonaws.com -i /Users/dbclose/onlinepowers/aws/emoldino.pem

ssh ec2-user@3.18.124.254 -i /Users/dbclose/onlinepowers/aws/emoldino.pem
```
ssh ec2-user@ec2-18-218-222-8.us-east-2.compute.amazonaws.com -i  /Users/dbclose/onlinepowers/aws/emoldino.pem




## EC2에서 RDS 연결하기 
- char 설정 및 보안그룹 설정이 필요하여 기존 RDS 삭제 후 다시 생성 
- 참고 : https://ndb796.tistory.com/226  (잘 읽어 볼것. 보안 및 charset 설정 후 DB 생성하자 !)

### DB 세부 정보 지정
- 스토리지 자동 조정 : 체크 해제 
- DB 인스턴스 식별자 : MMS
- 마스터 사용자 이름 : mms
- 마스터 암호 : emoldino^&^%

```
host : mms.csmnutrnrwsm.us-east-2.rds.amazonaws.com
port : 3306
db : MMS
id : mms
pw : emoldino^&^%
```


## EC2 서버 인바운드 규칙 추가 
- HTTP(80) 추가 후 접속 확인 



## 사용량 확인 
https://console.aws.amazon.com/billing/home?#/


## 추가 확인사항 
- 도메인 연결 : Route53 ??
- https 인증서 : 오하이오 무료 인증서 발급 가능 (서울도 가능?)



## emoldino 인스턴스 추가하기
### 이미지로 시작하기 
- 이미지 > AMI 메뉴에서 emolino-image를 선택하고 '시작하기'
- 인스턴스 생성시 기본값은 유지 하고 보안 그룹은 'launch-wizard-1' 선택
- 기존 개인키 사용 - emoldino

### 탄력적 IP 생성 및 연결 
- 네트워크 및 보안 > 탄력적 IP 메뉴
- 새 주소 할당 
- 할당된 주소를 선택한 후 작업 > 주소연결 
- 인스턴스 및 프라이빗IP를 선택한 후 연결 



### Amazon RDS 데이터베이스 생성 
- https://ndb796.tistory.com/226 참조하여 프리티어로 생성 
- DB인스턴스 식별자 : mms-abb
- Master username : mms
- 마스터 암호 : emoldino^&^%
- 스토리지 자동 조정 활성화 : 체크해제

#### 추가 연결 구성 
- 서브넷 그룹 : emoldino mysql subnet group 선택 
- 퍼블릭 엑세스 가능 : 예
- 기존 VPC 보안그룹 : default 삭제 , emoldino-mysql 선택 

#### 추가 구성 
- 데이터베이스 이름 : MMS
- DB 파라미터 그룹 : korean-parameter 선택
- 데이터베이스 생성 

#### DB 외부 접속 테스트 및 기초 데이터 
- intellij database에서 접속 테스트 
- DDL 및 기초 데이터 등록 (쿼리 저장해둠) 


> 스냅샷으로 부터 RDS 인스턴스 생성이 가능한지 확인해 볼것 ! 
> emoldino-mysql-stater 로 테이블 및 초기 데이터 백업해 둠.


### ssh 접속 확인 및 설정 변경
SSH 접속 후 DB 정보 변경
```
ssh ec2-user@18.221.152.61 -i /Users/dbclose/onlinepowers/aws/emoldino.pem

$ sudo su
$ vi /home/emoldino/mms/mms/config/application.properties
```

서비스 시작 및 브라우저에서 접속확인 


