# Azure Database for MySql

## 생성
- 서버이름 : ums-mysql-test
- 컴퓨팅 + 스토리니 : 기본, vCore: 1개, 5G 스토리지 (테스트용)
- 관리자 : oproot
- 비번 : Rnfhpowers^&^%

## 설정 
- 연결 보안 > 방화벽 규칙 
- Azure 서비스 방문 허용 


## 서버 매개 변수

- Azure에서 CALL mysql.az_load_timezone(); 호출해줘야 매개변수 타임존을 설정할 수 있음. (실행 후 SELECT * FROM mysql.time_zone; 값이 보임)
> https://docs.microsoft.com/ko-kr/azure/mysql/howto-server-parameters
```mysql
CALL mysql.az_load_timezone();
```
- char 검색 > character_set_server > UTF8MB4 저장
- time_zone : Asia/Seoul

## MYSQL
String url ="jdbc:mysql://ums-mysql-test.mysql.database.azure.com:3306/{your_database}?useSSL=true&requireSSL=false"; myDbConn = DriverManager.getConnection(url, "saleson@saleson-mysql", {your_password});


- host: ums-mysql-test.mysql.database.azure.com
- user: oproot@ums-mysql-test
- pw: Rnfhvkdnjtm92%@


## insert Data
```
mysql -usaleson3@mysql-saleson3-test -p -h mysql-saleson3-test.mysql.database.azure.com SALESON3 < saleson-demo.sql

jdbc:mysql://mysql-saleson3-test.mysql.database.azure.com:3306/SALESON3?useSSL=true&requireSSL=false
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