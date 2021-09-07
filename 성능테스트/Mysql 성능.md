# Mysql 성능 점검
> 2021.03.29 

## 이슈
- mysql 서버의 CPU 사용량이 100% 상황 발생 


## 예상되는 상황 
- table lock 으로 인한 속도저하 
- 슬로우 쿼리 실행으로 인한 지연 
- 기타 


## 분석 
### Lock 정보 조회 
INNODB_TRX 테이블은 읽기 전용 트랜잭션이 아닌 현재 실행 중인 모든 InnoDB 트랜잭션에 대한 정보를 제공합니다.
```sql
SELECT * FROM INFORMATION_SCHEMA.INNODB_TRX;
```

INNODB_LOCKS 테이블은 InnoDB 트랜잭션이 요청했지만 아직 받지 못한 잠금에 대한 정보를 제공합니다.
```sql
SELECT * FROM INFORMATION_SCHEMA.INNODB_LOCKS;
```

INNODB_LOCK_WAITS 테이블은 차단된 각 InnoDB 트랜잭션에 대해 하나 이상의 행을 제공합니다.
```sql
SELECT * FROM INFORMATION_SCHEMA.INNODB_LOCK_WAITS;
```

다음과 유사한 쿼리를 실행해 대기 중인 트랜잭션과 대기 중인 트랜잭션을 차단하는 트랜잭션을 확인할 수 있습니다.
```mysql
SELECT
  r.trx_id waiting_trx_id,
  r.trx_mysql_thread_id waiting_thread,
  r.trx_query waiting_query,
  b.trx_id blocking_trx_id,
  b.trx_mysql_thread_id blocking_thread,
  b.trx_query blocking_query
FROM       information_schema.innodb_lock_waits w
INNER JOIN information_schema.innodb_trx b
  ON b.trx_id = w.blocking_trx_id
INNER JOIN information_schema.innodb_trx r
  ON r.trx_id = w.requesting_trx_id;
```

조회 시 테이블 트랜젝션 LOCK 상태는 아닌 것으로 확인함. 


### PROCESSLIST
> https://dev.mysql.com/doc/refman/5.7/en/show-processlist.html

SHOW PROCESSLIST 명령은 현재 MySQL 인스턴스에서 실행 중인 스레드를 보여줍니다.

```mysql
SHOW FULL PROCESSLIST;
```
- Id: processId
- User: 접속 사용자
- Host: 접속 위치 (IP)
- DB: db
- Command: 실행 (Query, Sleep)
- Time: 실행 시간 (초)
- State: 상태 (Sending data, Creating sort index. ...)  
- Info: 실행 쿼리 


Command가 Query이고 Time이 높은 쿼리가 슬로우 쿼리임. 
Info 항목의 쿼리의 실행 계획을 확인('Full Scan' 여부 확인)하고 쿼리를 실행하여 조회 속도록 확인함.

> 5개 정도의 쿼리가 Time이 높았고 쿼리 실행 및 실행 계획을 확인해 보니 모두 Full Scan 중.
> Index를 추가하여 쿼리 속도를 개선할 수 있음.


## 처리 결과 





## Reference
- AWS: https://aws.amazon.com/ko/premiumsupport/knowledge-center/rds-instance-high-cpu/
