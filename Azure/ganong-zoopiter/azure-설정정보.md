# 가농바이오 Azure 세팅 정보 
> Azure 구성일: 2021.06.04 (금)
> 2021.07.01 (목)

## 1. 접속 url
### web 접속
- http://new.ganongbio.co.kr/

### Azure Portal
- 포털: portal.azure.com
- 아이디: admin@ganong365.onmicrosoft.com
- 비밀번호: wnvlxj159!

### mysql 
#### 1). ROOT
- host: ganong-mysql.mysql.database.azure.com
- user: rooot@ganong-mysql
- pw: Ganong!@#4

#### 2) ganong
- host: ganong-mysql.mysql.database.azure.com:3306
- db: SALESON3
- user: ganong@ganong-mysql
- pw: Ganong!@#4


## 2. 쿠버네티스 셋팅과정 등
### 리소스 그룹
- 구독: Azure subscription 1 
- 리소스 그룹: GanongResourceGroup
- 영역: 한국 중부

### AKS 생성
- 리소스 검색: aks > Kubernetes 클러스터 만들기
- Kubernetes 클러스터 이름: GanongKube
- kubernetes 버전: 1.19.1 (자동 설정값)
- 노드 풀 : 표준 DS2 v2 * 2ea

### 스토리지 계정생성
- 스토리지 계정 이름: ganongstorage
- 성능: 표준

#### 파일공유(File Share)
- ganong-storage : 첨부파일 경로 (50GB)

### Container Registry (컨테이너 레지스트리)
- Container Registry 만들기
- 레지스트리 이름: GanongRegistry
- 한국 중부 / 표준


## 3. mysql 버전 및 기본 파라미터 설정값 등
### 생성 (단일서버)
- 서버이름 : ganong-mysql
- 위치: 한국 중부
- 버전: 8.0
- 컴퓨팅 + 스토리지 : Basic(2vCore), 100G 스토리지, 백업 7일  (* 범용 2vCore가 선택되지 않음. 범용-4vCore가 기본)

### 설정
- 포털: 연결 보안 > 방화벽 규칙
- Azure 서비스 방문 허용

### 서버 매개 변수
- character_set_server: UTF8MB4 저장
- time_zone : Asia/Seoul
- sql_mode: 모두 체크 해제


## 4. 기타 애저에 세팅된 알려주실 정보가 있다면 추가 부탁드립니다.
### 참고사항 
- mysql 컴퓨팅 사양에 따라 max_connections 가 달라짐. 
- 설정 된 컴퓨팅: Basic(2vCore), 100G 스토리지 ==> max_connections: 100
- 커넥션이 부족한 경우 컴퓨팅 사양을 변경해야함. 

#### 제한 사항 (max_connections)
> https://docs.microsoft.com/ko-kr/azure/mysql/concepts-server-parameters

| 가격 | 책정 계층 | vCore	기본값 | 최소 값 |	최대 값 | 
|---|---|---|---|---|
|Basic	| 1	| 50    | 10	| 50    |
|Basic  | 2	| 100   | 10	| 100   |
|범용         | 2     | 300	    | 10    | 600   |   
|범용         | 4     | 625	    | 10    | 1,250   |  
|범용         | 8     | 1,250	| 10	| 2,500   |
|범용         | 16    | 2,500	| 10	| 5,000   |
|범용         | 32    | 5,000	| 10	| 10,000   |
|범용         | 64    | 10,000	| 10	 | 20,000   |
|메모리 최적화   | 2	    | 600	 |10	| 800   |
|메모리 최적화   | 4	    | 1,250	 |10	| 2,500   |
|메모리 최적화   | 8	    | 2,500	 |10	| 5,000   |
|메모리 최적화   | 16	    | 5,000	 |10	| 10,000   |
|메모리 최적화   | 32	    | 10,000	 |10	| 20,000   |




