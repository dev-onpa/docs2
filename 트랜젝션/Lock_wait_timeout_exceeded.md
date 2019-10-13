# Lock wait timeout exceeded

## JJGLOBAL 케이스
### 케이스 분석  
```
com.mysql.jdbc.exceptions.jdbc4.MySQLTransactionRollbackException - Lock wait timeout exceeded; try restarting transaction 84 Stack (Time:2019-02-24 18:15) SQL
```
- OP_ORDER_TEMP 테이블에 인덱스가 없음. 
- 슬로우 쿼리로 잡힘 

DELETE FROM OP_ORDER_TEMP WHERE xxxx  
실행 시 인덱스가 없어 쿼리 실행 시간이 오래 걸림..

INSERT OP_ORDER_TEMP 실행 시 DELETE 쿼리가 끝나기를 기다리다가 
Timeout (10초)이 나면서 오류가 발생한 것으로 예상 

```
SELECT @@innodb_lock_wait_timeout;   (타임아웃 10초로 설정 되어 있음)
```

### 조치사항 
- PK 및 인덱스 설정 
- 참고 : https://brunch.co.kr/@cg4jins/8