# SalesOn3 - Spring Boot

## 배경
- 씨네샵에서 Spring Boot Base로 프로젝트를 진행하기를 원함. 
- Spring Boot로 변경 가능한 지 검토 


## 검토 및 변경 
### Spring Boot Initializer로 프로젝트 생성 
- saleson 
- saleson > saleson-common
- saleson > saleson-web (:saleson-common)


### saleson-common (공통) 
- saleson-common 구성 
- dependancy
- spring security


### saleson-web 
- WebMvcConfiguration 



#### spring boot jsp + tiles
- jsp를 사용하기 위해서는 WEB-INF 폴더를 생성해야함.
- gradle 'war'로 패킹해야함.

```groovy
apply plugin: 'war'

dependencies {
    compile project(':saleson-common')

    compile "org.hibernate:hibernate-validator:6.0.14.Final"
    compile "com.googlecode.htmlcompressor:htmlcompressor:1.5.2"
    // compile "rhino:js:1.6R7"
    compile "com.yahoo.platform.yui:yuicompressor:2.4.8"

    compile("org.apache.tomcat.embed:tomcat-embed-jasper")
    compile("javax.servlet:jstl:1.2")
    compile("org.apache.tiles:tiles-jsp:3.0.8")

}
```

- 실행 방법 : bootWar 빌드 후 war파일을 java -jar로 실행함. 
```
 $ java -jar saleson-web.war
```

- Intellij(인텔리J)에서 실행 방법 
```
 gradle > Tasks > application > bootRun
```  

##### 참고
- bootRun : http://progtrend.blogspot.com/2018/07/spring-boot-war.html
- Resource Handler : https://eblo.tistory.com/51


