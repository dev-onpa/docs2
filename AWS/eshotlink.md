# eShotLink AWS 인스턴스 추가하기

> 2019-09-27 PHILIPS 데모 구성 (18.189.137.58)

## EC2 인스턴스 추가 
### 이미지로 시작하기 
- EC2 대시보드 접속 
- 이미지 > AMI 메뉴에서 emolino-image를 선택하고 '시작하기'
    + 6.보안그룹구성 : 기존 보안 그룹 / launch-wizard-1' 선택
    + 7.검토 및 시작 : 시작하기
    + 기존 키 페어 선택 > emoldino > 인스턴스 시작

### 탄력적 IP 생성 및 연결 
- 네트워크 및 보안 > 탄력적 IP 메뉴
- 새 주소 할당 : Amazon 풀 선택 
- 할당된 주소를 선택한 후 작업 > 주소연결 
- 인스턴스 및 프라이빗IP를 선택한 후 연결 



## Amazon RDS 데이터베이스 생성
> Amazon RDS 접속  
> https://ndb796.tistory.com/226 참조하여 프리티어로 생성

`데이터베이스 생성' 버튼 클릭 
## 기본 설정 
- mysql / 5.7

## 템플릿 
- 프리 티어 선택 

## 설정 
- DB인스턴스 식별자 : mms-abb
- Master username : mms
- 마스터 암호 : emoldino^&^%
- 스토리지 자동 조정 활성화 : 체크해제

## 추가 연결 구성 
- 서브넷 그룹 : emoldino mysql subnet group 선택 
- 퍼블릭 엑세스 가능 : 예
- 기존 VPC 보안그룹 : default 삭제 , emoldino-mysql 선택 

## 추가 구성 
- 데이터베이스 이름 : MMS
- DB 파라미터 그룹 : korean-parameter 선택
- 데이터베이스 생성 

## DB 외부 접속 테스트 및 기초 데이터 
- intellij database에서 접속 테스트 
- DDL 및 기초 데이터 등록 (쿼리 저장해둠 - MMS@AmazonRDS) 


> 스냅샷으로 부터 RDS 인스턴스 생성이 가능한지 확인해 볼것 ! 
> emoldino-mysql-stater 로 테이블 및 초기 데이터 백업해 둠.


## ssh 접속 확인 및 설정 변경
SSH 접속 후 DB 정보 변경
```
ssh ec2-user@18.221.152.61 -i /Users/dbclose/onlinepowers/aws/emoldino.pem

$ sudo su
$ vi /home/emoldino/mms/mms/config/application.properties
```

서비스 시작 및 브라우저에서 접속확인 
