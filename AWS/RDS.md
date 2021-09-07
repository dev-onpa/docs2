# RDS mysql
> 2020.03.01


## 파라미터 그룹 생성 
파라미터 그룹 편집에서 수정 가능.

### char_set
- utf8mb4

### time_zone
- UTC+8 (말레이시아) : Asia/Singapore
- UTC-3 (브라질) : America/Fortaleza
- UTC+2 (파리) : Europe/Paris
- UTC-5 (멕시코) : America/Bogota (콜롬비아로 선택)


### slow_query_log 설정
로그남김 설정 : 1

### long_query_time
몇 초 이상이 슬로우 쿼리인가? : 2초

### log_output 설정
- FILE로 설정




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
- DB 인스턴스 식별자 : mms-mm0427
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
- DB 파라미터 그룹: emoldino-mysql-parameter-group

### 유지관리
- 마이너 버전 자동 업그레이드 사용 안 함

### t3.micro 옵션인가??  
- 암호화 활성화 : 체크해제
- 모니터링 > Enhanced 모니터링 활성화 : 체크해제 
- 마이너 버전 자동 업그레이드 사용: 체크 
나머진 기본값


## 참고
### RDS 타임존 
- RDS 파라미터 그룹 항목 중 'time_zone' 검색 
- 말레이시아 타임존이 없어 Asia/Singapore로 설정함. 

- UTC-3 (브라질) : America/Fortaleza
- UTC+2 (파리) : Europe/Paris






### EC2 타임존 설정 
#### 타임존 설정 
```shell
$ ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

```

#### 설정가능한 Timezone
```
Africa/Cairo, Africa/Casablanca, Africa/Harare, Africa/Monrovia, Africa/Nairobi, Africa/Tripoli, Africa/Windhoek, America/Araguaina, America/Asuncion, America/Bogota, America/Buenos_Aires, America/Caracas, America/Chihuahua, America/Cuiaba, America/Denver, America/Fortaleza, America/Guatemala, America/Halifax, America/Manaus, America/Matamoros, America/Monterrey, America/Montevideo, America/Phoenix, America/Santiago, America/Tijuana, Asia/Amman, Asia/Ashgabat, Asia/Baghdad, Asia/Baku, Asia/Bangkok, Asia/Beirut, Asia/Calcutta, Asia/Damascus, Asia/Dhaka, Asia/Irkutsk, Asia/Jerusalem, Asia/Kabul, Asia/Karachi, Asia/Kathmandu, Asia/Krasnoyarsk, Asia/Magadan, Asia/Muscat, Asia/Novosibirsk, Asia/Riyadh, Asia/Seoul, Asia/Shanghai, Asia/Singapore, Asia/Taipei, Asia/Tehran, Asia/Tokyo, Asia/Ulaanbaatar, Asia/Vladivostok, Asia/Yakutsk, Asia/Yerevan, Atlantic/Azores, Australia/Adelaide, Australia/Brisbane, Australia/Darwin, Australia/Hobart, Australia/Perth, Australia/Sydney, Canada/Newfoundland, Canada/Saskatchewan, Brazil/East, Europe/Amsterdam, Europe/Athens, Europe/Dublin, Europe/Helsinki, Europe/Istanbul, Europe/Kaliningrad, Europe/Moscow, Europe/Paris, Europe/Prague, Europe/Sarajevo, Pacific/Auckland, Pacific/Fiji, Pacific/Guam, Pacific/Honolulu, Pacific/Samoa, US/Alaska, US/Central, US/Eastern, US/East-Indiana, US/Pacific, UTC
```

#### CB0413
- UTC-3 (브라질) : America/Fortaleza
```shell
$ ln -snf /usr/share/zoneinfo/America/Fortaleza /etc/localtime && echo America/Fortaleza > /etc/timezone
```

- UTC-5 (멕시코) : America/Bogota
```shell
$ ln -snf /usr/share/zoneinfo/America/Bogota /etc/localtime && echo America/Bogota > /etc/timezone
```

#### NS0407, LF0408 
- UTC+2 (프랑스) : Europe/Paris
```shell
$ ln -snf /usr/share/zoneinfo/Europe/Paris /etc/localtime && echo Europe/Paris > /etc/timezone

```


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

