# RDS mysql
> 2020.03.01

## RDS (mysql) 인스턴스 생성 
1. 전체서비스 > 데이터베이스 > RDS 선택하여 Amazon RDS에 접속 
2. `데이터베이스 생성`

## 엔진옵션
- mysql
- RDS 프리 티어에 적용되는 옵션만 사용 - 체크

## DB 세부 정보 지정
### 인스턴스 사양
- 스토리지 자동 조정 활성화 체크해제
- 나머지 기본값
### 설정
- DB 인스턴스 식별자 : emoldino
- 마스터 사용자 이름 : mms
- 마스터 암호 : emoldino^&^%

## 고급 설정 구성
### 네트워크 및 보안
- 기본 VPC
- 서브넷 그룹: emoldino mysql subnet group
- 퍼블릭엑세스 : 예
- 가용영역 : 기본값
- 기존 VPC 보안 그룹 체크 -> default삭제, emoldino-mysql 선택

### 데이터베이스 옵션
- 데이터베이스 이름 : MMS
- DB 파라미터 그룹: korean-parameter

### 유지관리
- 마이너 버전 자동 업그레이드 사용 안 함

나머진 기본값


## 참고
### RDS 말레이시아 타임존 
- RDS 파라미터 그룹 항목 중 'time_zone' 검색 
- 말레이시아 타임존이 없어 Asia/Singapore로 설정함. 

### EC2 타임존 설정 

Africa/Cairo, Africa/Casablanca, Africa/Harare, Africa/Monrovia, Africa/Nairobi, Africa/Tripoli, Africa/Windhoek, America/Araguaina, America/Asuncion, America/Bogota, America/Buenos_Aires, America/Caracas, America/Chihuahua, America/Cuiaba, America/Denver, America/Fortaleza, America/Guatemala, America/Halifax, America/Manaus, America/Matamoros, America/Monterrey, America/Montevideo, America/Phoenix, America/Santiago, America/Tijuana, Asia/Amman, Asia/Ashgabat, Asia/Baghdad, Asia/Baku, Asia/Bangkok, Asia/Beirut, Asia/Calcutta, Asia/Damascus, Asia/Dhaka, Asia/Irkutsk, Asia/Jerusalem, Asia/Kabul, Asia/Karachi, Asia/Kathmandu, Asia/Krasnoyarsk, Asia/Magadan, Asia/Muscat, Asia/Novosibirsk, Asia/Riyadh, Asia/Seoul, Asia/Shanghai, Asia/Singapore, Asia/Taipei, Asia/Tehran, Asia/Tokyo, Asia/Ulaanbaatar, Asia/Vladivostok, Asia/Yakutsk, Asia/Yerevan, Atlantic/Azores, Australia/Adelaide, Australia/Brisbane, Australia/Darwin, Australia/Hobart, Australia/Perth, Australia/Sydney, Canada/Newfoundland, Canada/Saskatchewan, Brazil/East, Europe/Amsterdam, Europe/Athens, Europe/Dublin, Europe/Helsinki, Europe/Istanbul, Europe/Kaliningrad, Europe/Moscow, Europe/Paris, Europe/Prague, Europe/Sarajevo, Pacific/Auckland, Pacific/Fiji, Pacific/Guam, Pacific/Honolulu, Pacific/Samoa, US/Alaska, US/Central, US/Eastern, US/East-Indiana, US/Pacific, UTC




###
mms
```
mysqldump -umms -p --column-statistics=0 -h mms.csmnutrnrwsm.us-east-2.rds.amazonaws.com MMS > emoldino.sql
mysql -umms -p -h emoldino.csmnutrnrwsm.us-east-2.rds.amazonaws.com MMS < emoldino.sql
```

ABB
```
mysqldump -umms -p --column-statistics=0 -h mms-abb.csmnutrnrwsm.us-east-2.rds.amazonaws.com MMS > abb.sql
mysql -umms -p -h abb.csmnutrnrwsm.us-east-2.rds.amazonaws.com MMS < abb.sql
```

PHILIPS
```
mysqldump -umms -p --column-statistics=0 -h mms-philips.csmnutrnrwsm.us-east-2.rds.amazonaws.com MMS > philips.sql
mysql -umms -p -h philips.csmnutrnrwsm.us-east-2.rds.amazonaws.com MMS < philips.sql
```

