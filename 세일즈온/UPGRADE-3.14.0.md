# Upgrade SalesOn 3.14.0

## Upgrade
- Gradle 6.7 -> 7.0.2
- Java 1.8 -> OpenJdk 11
- Embeded Tomcat 9.0.38 -> 9.0.46


### gradle
```
./gradlew wrapper --gradle-version 7.0.2
```



### saleson-web
- bootRun이 아닌 SalesonWebApplication.java를 바로 실행 할 수 있도록 수정 
- 인텔리J에서 run/debug config에서 working directory = %MODULE_WORKING_DIR% 로 설정 필요 (Gradle Multi Module Project에서 ...)
- TilesConfig 분리 



### JavaConfig 
- aop
  https://m.blog.naver.com/PostView.naver?blogId=zzxx4949&logNo=221697782544&proxyReferer=https:%2F%2Fwww.google.com%2F
  https://dymn.tistory.com/49
  https://linked2ev.github.io/gitlog/2019/10/02/springboot-mvc-15-%EC%8A%A4%ED%94%84%EB%A7%81%EB%B6%80%ED%8A%B8-MVC-Transaction-%EC%84%A4%EC%A0%95/
  http://blog.naver.com/PostView.nhn?blogId=zzxx4949&logNo=221697782544&categoryNo=29&parentCategoryNo=0&viewDate=&currentPage=1&postListTopCurrentPage=1&from=postView
  https://stackoverflow.com/questions/48450504/spring-boot-aop-tx-advice-in-java-config-without-xml-config
  https://www.programmersought.com/article/38396020569/
  https://idkbj.tistory.com/31
  https://www.hanumoka.net/2018/08/24/spring-20180824-spring4-aop-logging/

### 4umall 수정사항 적용 
- spring session : SessionMysqlConfig? 
- 컬럼 길이 적용



### opframework 
- FileUtils : @Component 제거 
- StringUtils, SeedUtils, FileUtils, SftpClient, TokenServiceImpl, DateUtils  main 메서드 제거 
- 버전업 

- Proguard 난독화 처리 : gradle 7.0 버전에서 missing an input or output annotation. 오류 발생 (보류)

- code, message 데이터 조회가 되시않아 jdbcTemplate 로 쿼리 실행하도록 수정. 





https://docs.gradle.org/current/userguide/upgrading_version_6.html#changes_7.0

Removed Configuration	New Configuration
compile                 api or implementation
runtime                 runtimeOnly
testRuntime             testRuntimeOnly
testCompile             testImplementation
<sourceSet>Runtime      <sourceSet>RuntimeOnly
<sourceSet>Compile      <sourceSet>Implementation


implementation fileTree(dir: ‘lib’, include: ‘*.jar’)
implementation group: ‘mysql’, name: ‘mysql-connector-java’, version: ‘8.0.17’
implementation project(’:common’)