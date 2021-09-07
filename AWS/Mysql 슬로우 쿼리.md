# AWS RDS (Mysql) 슬로우 쿼리 로그 설정 
> 2021.03.30 


파라미터 그룹 편집에서 수정 가능.


## slow_query_log 설정
로그남김 설정 : 1

## long_query_time
몇 초 이상이 슬로우 쿼리인가? : 2초 

## log_output 설정
- FILE로 설정 
  
### TABLE
```sql
Select * from mysql.slow_log
Select * from mysql.general_log
``` 
### FILE
- 파일로그는 RDS 인스턴스에서 로그에 남도록 함. 