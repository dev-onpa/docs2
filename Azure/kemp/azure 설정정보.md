# KEMP Azure 세팅 정보 
> 2021.07.07

## 1. 접속 url
### web 접속
- https://kemp.kr

### Azure Portal 접속 정보 
- 포털: portal.azure.com
- 계정: admin@kempO365.onmicrosoft.com
- 비밀번호: kemp92%@!


## 2. Azure 서비스 생성 및 설정 
### 리소스 그룹
- 구독: Azure subscription 1 
- 리소스 그룹: KempResourceGroup
- 영역: 한국 중부

### AKS 생성
- 리소스 검색: aks > Kubernetes 클러스터 만들기
- Kubernetes 클러스터 이름: KempKube
- kubernetes 버전: 1.18.14 (자동 설정값)
- 노드 풀 : 표준 DS2 v2 * 2ea

### 스토리지 계정생성
- 스토리지 계정 이름: kempstorage
- 성능: 표준
- 나머지 기본값.

#### 파일공유(File Share)
- kemp-saleson : 라이선스 파일 (1GB)
- kemp-storage : 첨부파일 경로 (5GB)

### Container Registry (컨테이너 레지스트리)
- Container Registry 만들기
- 레지스트리 이름: KempRegistry
- 한국 중부 / 표준


## 3. Mysql
### 접속 정보 
#### 1) root
- host: kemp-mysql.mysql.database.azure.com
- port: 3306
- user: rooot@kemp-mysql
- pw: Zpdldldpavl92%@

#### 2) kemp
- host: 4umall-mysql.mysql.database.azure.com
- port: 3306
- db: SALESON3
- user: kemp@kemp-mysql
- pw: Kemp92%@


### Azure 설정 
#### 생성 정보 
- 서버이름 : kemp-mysql
- 컴퓨팅 + 스토리지 : 범용(2vCore), 100G 스토리지, 백업 7일
- 위치: 한국 중부
- 버전: 8.0

### 설정
- 포털: 연결 보안 > 방화벽 규칙
- Azure 서비스 방문 허용

### 서버 매개 변수
- character_set_server: UTF8MB4 저장
- time_zone : Asia/Seoul
- sql_mode: 모두 체크 해제


## 4. 배포 
### 1) 소스 빌드 
```shell
$ ./gradlew build --exclude-task test
```

### 2) Azure Login
Azure 계정으로 로그인 
```shell
$ az login
```

### 3) 배포 스크립스 실행 
소스에 포함되어 있는 Shell Script로 배포 
```shell
$ ./deploy.sh
```

- 자료 전달 시 일정 내용도 포함. 
- 금요일 미팅 : KEMP (오후)
- 조합이 경기도 김포에 있음.  


