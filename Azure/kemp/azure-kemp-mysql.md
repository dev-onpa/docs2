# Azure Database for MySql

## 생성 (단일서버)
- 서버이름 : kemp-mysql
- 컴퓨팅 + 스토리지 : 범용(2vCore), 100G 스토리지, 백업 7일
- 위치: 한국 중부
- 버전: 8.0

## 관리자 계정
- 관리자 사용자 이름: rooot  (root는 사용이 안됨.)
- 암호 : Zpdldldpavl92%@  케이이엠피92%@



## 서버 매개 변수

- Azure에서 CALL mysql.az_load_timezone(); 호출해줘야 매개변수 타임존을 설정할 수 있음. (실행 후 SELECT * FROM mysql.time_zone; 값이 보임)
> https://docs.microsoft.com/ko-kr/azure/mysql/howto-server-parameters
```mysql
CALL mysql.az_load_timezone();
```
- char 검색 > character_set_server > UTF8MB4 저장
- time_zone : Asia/Seoul
- sql_mode: 모두 체크 해제

## MYSQL

### ROOT
- host: kemp-mysql.mysql.database.azure.com
- user: rooot@kemp-mysql
- pw: Zpdldldpavl92%@


### kemp
- host: 4umall-mysql.mysql.database.azure.com:3306
- db: SALESON3
- user: kemp@kemp-mysql
- pw: Kemp92%@


## insert Data
```
$ mysqldump --column-statistics=0 -ukemp -p -h 192.168.123.15 SALESON3_KEMP > kemp.sql

$ mysql -ukemp@kemp-mysql -p -h kemp-mysql.mysql.database.azure.com SALESON3 < kemp.sql
```


## 제한 사항 (max_connections)
> https://docs.microsoft.com/ko-kr/azure/mysql/concepts-limits

| 가격 | 책정 계층 | vCore	기본값 | 최소 값 |	최대 값 | 
|---|---|---|---|---|
|Basic	| 1	| 50    | 10	| 50    |
|Basic  | 2	| 100   | 10	| 100   |
|범용 | 2     | 300	10	600
|범용 | 4     | 625	10	1250
|범용 | 8     | 1250	10	2500
|범용 | 16    | 2500	10	5,000
|범용 | 32    | 5,000	10	10000
|범용 | 64    | 10000	10	20000
|메모리 최적화	2	600	10	800
|메모리 최적화	4	1250	10	2500
|메모리 최적화	8	2500	10	5,000
|메모리 최적화	16	5,000	10	10000
|메모리 최적화	32	10000	10	20000


| 값 | 의미 | 기본값 |
|---|:---:|---:|
| `static` | 유형(기준) 없음 / 배치 불가능 | `static` |
| `relative` | 요소 자신을 기준으로 배치 |  |
| `absolute` | 위치 상 부모(조상)요소를 기준으로 배치 |  |
| `fixed` | 브라우저 창을 기준으로 배치 |  |