# MSA 기반 프로젝트 
https://github.com/sivaprasadreddy/spring-boot-microservices-series



## 관련내용 
![이미지](../images/spring_netflix.png)

## Spring cloud nexflix zuul (API GATEWAY)
- https://github.com/sivaprasadreddy/spring-boot-microservices-series/
- https://www.javacodegeeks.com/2018/03/microservices-part-5-spring-cloud-zuul-proxy-as-api-gateway.html
- Eureka Sever / Eureka Client 로 구성하고 
- 각각의 API 서비스는 Eureka Client로 등록 한다. 

## Zipkin
- MSA 환경에서 분산 트렌젝션의 추적
- 데이터는 스토리지에 저장 (In-memory, MySQL, Cassandra, Elastic Search)
- Spring Sleuth : Zipkin 지원 

* [Zipkin을 이용한 MSA 환경에서 분산 트렌젝션의 추적 #1](https://bcho.tistory.com/1243)
* [Zipkin을 이용한 MSA 환경에서 분산 트렌젝션의 추적 #2](https://bcho.tistory.com/1244?category=502863)
* [Zipkin을 이용한 MSA 환경에서 분산 트렌젝션의 추적 #3](https://bcho.tistory.com/1245?category=502863)


## Logstash (로그 외부화)
- 클라우드에서 로컬 I/O를 남기면 병목 현상이 발생할 수 있음. 
- 이를 방지하기 위해서 중앙 집중식 로깅 프레임워크를 사용 
- Logstash, Splunk, Greylog, Logplex, Loggly 등.  



## Zuul + oauth + jwt
https://www.baeldung.com/spring-security-zuul-oauth-jwt