# Mssql 데이터베이스 복원 
> 2021.04.02 

## bak파일로 복원하기 
1. 백업 DB의 데이터베이스명을 확인하여 동일 이름으로 DB생성 (2010_a4u_new)
2. DB 파일 경로 확인 : C:\Program Files\Microsoft SQL Server\MSSQL11.SQLEXPRESS\MSSQL\DATA\
3. 생성된 데이터베이스명 우클릭 > 태스크 > 복원 > 데이터베이스
4. 일반 항목에서 
  1) 원본
     - 장치 항목 체크 : [v] 장치
     - [...]클릭 > 추가 : bak 파일을 선택 > 확인 
  2) 대상
    - 데이터베이스 선택: 2010_a4u_new
     
4. 좌측 파

---------
*.bak 파일로 복원이 되지 않음. ㅜ. 