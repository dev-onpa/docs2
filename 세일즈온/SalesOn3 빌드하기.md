# SalesOn3 빌드하기 (2019-05-17) 

## 기본 정보 
### 컴파일 (Compile)
- 소스코드를 바이너리 코드로 변환 (java -> class)
- IDE가 자동으로..

### 빌드 (Build)
- 소스코드를 실행가능한 산출물로 생성 (class -> jar, war)

### 빌드툴 
- 빌드전 처리 -> 컴파일 -> 테스팅 -> 패키징 -> 빌드완료 -> 배포 등등의 일괄 처리를 해주는 툴
- ant, maven, gradle

## SalesOn3 빌드하기 
- gradle 로 빌드함.
- multi project 구성 : settings.gradle
- 빌드 정보를 build.gradle 파일에 정의 

### Gragle 빌드 단계 (TASK)
- clean: 이전 빌드 정보 삭제 
- querydsl: JPA querydsl Q도메인 생성 
- build : compile test packaging 등등.

### 환경 변수 기준 빌드 
- env 변수명에 testing / development / production 등을 설정하여 빌드가 가능함.
- 환경 변수에 따라 빌드 시 ~/env 폴더의 서버 환경별 설정 파일을 추가함.
- 설정은 빌드 옵션 -P[변수명]=[변수값]
```
-Penv=testing
```

### IDE 이용 
- 인텔리 j : 우측 Gradle 탭에서 clean -> querydsl -> build 를 각각 실행. (테스트 포함 시 )
- 우측 Gradle 탭에 코끼리 아이콘 클릭 후 명령 입력 ( clean querydsl build -x test -Penv=testing)
- 이클립스 : 버그있음.

### CLI(Command Line Interface, 명령 줄 인터페이스)로 실행 
- root 프로젝트 경로에서 gradlew로 실행 (~/saleson/ 폴더)
```
$ ./gradlew clean querydsl build -x test -Penv=development
```

### 빌드 산출물 
- 각 프로젝트(모듈)에 build 폴더에 생성  