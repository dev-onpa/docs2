# 세일즈온 MSA 적용


## Zipkin
- MSA 환경에서 분산 트렌젝션의 추적
- 데이터는 스토리지에 저장 (In-memory, MySQL, Cassandra, Elastic Search)
- Spring Sleuth : Zipkin 지원 

> Docker로 zipkin 실행하기   
```
$ docker pull openzipkin/zipkin
$ docker run -d -p 9411:9411 openzipkin/zipkin
```

> Spring boot로 zipkin 실행하기 


### saleson-zipkin 프로젝트 

#### dependencies 
```yaml
dependencies {
    compile 'io.zipkin.java:zipkin-server:2.11.13'
    runtime 'io.zipkin.java:zipkin-autoconfigure-ui:2.11.13'
    compile 'org.springframework.boot:spring-boot-starter-web'
    testImplementation 'org.springframework.boot:spring-boot-starter-test'
    //compile 'org.springframework.cloud:spring-cloud-sleuth-zipkin'
    //compile 'org.springframework.cloud:spring-cloud-starter-zipkin'
}

dependencyManagement {
    imports {
        mavenBom "org.springframework.cloud:spring-cloud-dependencies:${springCloudVersion}"
        mavenBom "org.springframework.boot:spring-boot-starter-parent:${springBootVersion}"
    }
}
``` 

#### SalesonZipkinApplication 
- `@EnableZipkinServer` 애노테이션 추가 


#### 실행 확인 
- http://localhost:9411/zipkin/
- http://localhost:9411/actuator

#### 적용사항 
- [ ] server-zipkin : zipkin 서버 프로젝트 구성 (우선 9411로 뜨기만 함.)
- [ ] Spring Sleuth 연동 필요
- [ ] ELK (Elasticsearch, Logstash, Kibana) 적용

#### 추가 확인 사항 
- 서비스에서 (API)에서 zipkin 추적을 위한 설정   
     //compile 'org.springframework.cloud:spring-cloud-sleuth-zipkin'
     //compile 'org.springframework.cloud:spring-cloud-starter-zipkin'


## RabbitMQ
- RabbitMQ는 AMQP(Advanced Message Queuing Protocol)을 구현한 메시지 브로커입니다.
- 마이크로서비스의 상호작용이 발행-구독 구조로 비동기적으로 처리할 수 있도록 메시징 솔루션을 적용한다. (RabbitMQ)


### exchange
- 방식 : fanout / topic / direct (좀 더 확인 필요!)
- [fanout/topic 방식 구현](ttps://www.baeldung.com/rabbitmq-spring-amqp)


### RabbitMQ 실행
- Docker로 실행 

```
docker run -d --name rabbitmq -p 5672:5672 -p 15672:15672 --restart=unless-stopped -e RABBITMQ_DEFAULT_USER=username -e RABBITMQ_DEFAULT_PASS=password rabbitmq:management

docker run -d --name rabbitmq -p 5672:5672 -p 15672:15672 --restart=unless-stopped -e RABBITMQ_DEFAULT_USER=guest -e RABBITMQ_DEFAULT_PASS=guest rabbitmq:management
```


## 메시지 서버 구현 
### 설정 

Spring cloud stream 으로 구현함.
```
compile 'org.springframework.cloud:spring-cloud-starter-stream-rabbit'
```

`@Input`, `@Output`, `MessageChannel`, `SubscribableChannel`,  `@EnableBinding`

- 적용 : https://stackabuse.com/spring-cloud-stream-with-rabbitmq-message-driven-microservices/
- 참고 : https://coding-start.tistory.com/139



## Spring Config Server
- https://yaboong.github.io/spring-cloud/2018/11/25/spring-cloud-config/


## Spring Cloud Bus
- https://coe.gitbook.io/guide/config/springcloudconfigbus



## API Gateway 
- https://www.baeldung.com/zuul-load-balancing



## ELK 
- elasticsearch, logstesh, kibana
- docker-compose 로 한번에 설치 
- https://hoonmaro.tistory.com/48

### docker-elk repository clone
작업 디렉토리에서 docker-elk git 레포지토리를 clone 한다.

```
$ git clone https://github.com/deviantony/docker-elk
```


### docker-elk 실행 
```
# docker-compose.yml이 있는 디렉토리에서 수행해야 한다 
# build 

$ docker-compose build 


# 빌드를 통해 생성된 도커 이미지 확인 
$ docker images 

# up: 컨테이너 생성 및 구동, -d는 백그라운드로 실행 옵션 
$ docker-compose up -d 

# 컨테이너 목록 확인 
$ docker-compose ps 

# 컨테이너 로그 확인 
$ docker-compose logs -f 

# elasticsearch 인덱스 확인 
$ curl -XGET localhost:9200/_cat/indices?v

```


### Kibana 접속 
```
http://localhost:5601

- username: elastic
- password: changeme
```




## Zipkin + ELK 로그 추적 
### Zipkin 
- MSA 환경에서 분산 트렌젝션의 추적
- 데이터는 스토리지에 저장 (In-memory, MySQL, Cassandra, Elastic Search)
- Spring Sleuth : Zipkin 지원 

- Spring boot를 이용하여 Zipkin 프로젝트 구성 후 실행하려고 했지만 @EnableZipkinServer (Deprecated  됨 )
- docker를 이용하여 구성.

> Docker로 zipkin 실행하기   
```
$ docker pull openzipkin/zipkin
$ docker run -d -p 9411:9411 openzipkin/zipkin
```

### Zipkin + Sleuth + ELK 연동
> Dependency 추가 
``` 
implementation 'org.springframework.cloud:spring-cloud-starter-sleuth'
implementation 'org.springframework.cloud:spring-cloud-starter-zipkin'
```

> Dependency 추가 
``` 
implementation 'org.springframework.cloud:spring-cloud-starter-sleuth'
implementation 'org.springframework.cloud:spring-cloud-starter-zipkin'
```

> *-service.yml 파일에 설정 추가 
``` 
  zipkin:
    base-url: http://localhost:9411/
    sender.type: rabbit

  sleuth:
    sampler.probability: 1.0
```

> logback.xml 
- logstash로 보냄 -> kibana에서 확인 
```xml
<?xml version="1.0" encoding="UTF-8"?>
<configuration debug="false">
    <include resource="org/springframework/boot/logging/logback/base.xml"/>
    <appender name="logstash" class="net.logstash.logback.appender.LogstashTcpSocketAppender">
        <destination>localhost:5000</destination>
        <encoder class="net.logstash.logback.encoder.LoggingEventCompositeJsonEncoder">
            <providers>
                <mdc/>
                <context/>
                <version/>
                <logLevel/>
                <loggerName/>
                <message/>
                <pattern>
                    <pattern>
                        {
                            "appName": "item-service"
                        }
                    </pattern>
                </pattern>
                <threadName/>
                <stackTrace/>
            </providers>
        </encoder>
    </appender>
    <root level="INFO">
        <appender-ref ref="CONSOLE"/>
        <appender-ref ref="logstash"/>
    </root>
    <logger name="org.springframework" level="INFO"/>
    <logger name="com.onlinepowers" level="DEBUG"/>
</configuration>
```

- zipkin서버에서 로그 추적...
- http://localhost:9411/zipkin/


## Hysrtix
- 장애 전파 방지
- 빠른 실패(Fail fast)와 빠른 복구(Rapid Recovery)
- 실시간 모니터링, 알람 및 설정 변경(Operational Control) 지원

### 구현 
- `@EnableHystrix`, `/hystrix.stream`
- HystrixCommand: 단일 API에 대하여 Hystrix를 적용한다.(fallbackMethod 등록)
- FeignClient: Feign Interface 에 포함된 API에 Hystrix를 적용한다.(fallback class사용)
- Zuul: routing시 Hystrix를 적용한다. (`FallbackProvider` 등록)


### YML 설정 
```yaml
hystrix:
  threadpool:
    default:
      coreSize: 100  # Hystrix Thread Pool default size
      maximumSize: 500  # Hystrix Thread Pool default size
      keepAliveTimeMinutes: 1
      allowMaximumSizeToDivergeFromCoreSize: true
  command:
    default:
      execution:
        isolation:
          thread:
            timeoutInMilliseconds: 3000     #설정 시간동안 처리 지연발생시 timeout and 설정한 fallback 로직 수행
      circuitBreaker:
        requestVolumeThreshold: 2                # 설정수 값만큼 요청이 들어온 경우만 circut open 여부 결정 함
        errorThresholdPercentage: 50        # requestVolumn값을 넘는 요청 중 설정 값이상 비율이 에러인 경우 circuit open
        enabled: true
```


## Turbine + Hystrix-dashboard
- 각 서비스의 /actuator/hystrix.stream 을 /turbine.stream 취합
- Hystrix-dashboard 에서 turbine.stream으로 한 번에 모니터링..
- Hystrix-dashboard 접속 : http://localhost:9010/hystrix

> 설정파일 
```yaml
server.port: 9010
spring:
  application.name: saleson-turbine-server
turbine:
  appConfig: saleson-gateway-server, item-service, user-service    # 모니터 원하는 서비스 나열(eureka에 등록되어 있어야 함)
  clusterNameExpression: new String('default')
eureka:
  client.serviceUrl.defaultZone: http://localhost:9000/eureka/
```



## @FeignClient를 이용하여 다른 서비스 API 호출하기 
- OrderService 에서 ItemService 호출 하기 
- @FeignClient 로 호출 시 401 오류. access_token을 어떻게 설정할까? 
```
FeignClientInterceptor 를 생성하고 security에서 token 정보를 가져와 requestTemplate header 값으로 설정함. 
```
- 파라미터 설정은? @SpringQueryMap Object params
- @SpringQueryMap 사용하여 전송시 배열값 전송 방법은??





## spring cloud kubernetes
- docker contaier 실행 후 eureka 서버에서 container id를 hostname으로 등록하는 이슈가 있음.
- docker run 옵션으로 --net host로 실행하면 됨..
- 맥에서는 ip가 다르게 잡힘..
- 개발서버에서는 정상으로 ip가 등록됨 .. 
- 그런데 --net host 인 경우 
- -p 8011:8010으로 해도 8010으로만 실행됨.. 2개 띠울 수가 없음.
- port는 어떻게 하지?

==> kubernetes는?
- [Spring Cloud VS Kubernetes 기술스택](https://zetawiki.com/wiki/Spring_Cloud%EC%99%80_Kubernetes_%EA%B8%B0%EC%88%A0%EC%8A%A4%ED%83%9D)
- 어라 쿠버네티스 좀 알아보자... 8/10


### 참고 
- https://futurecreator.github.io/2019/02/25/kubernetes-cluster-on-google-compute-engine-for-developers/
- [Quick Guide to Microservices with Kubernetes, Spring Boot 2.0 and Docker](https://piotrminkowski.wordpress.com/2018/08/02/quick-guide-to-microservices-with-kubernetes-spring-boot-2-0-and-docker/)
- https://itnext.io/migrating-a-spring-boot-service-to-kubernetes-in-5-steps-7c1702da81b6




## Graphite + Grafana
실시간으로 생성되는 Hystrix Stream 데이터를 historical하게 볼수 있도록 함
Metrics를 dropwizard로 보내고 이를 graphite에 저장하는 형식으로 시스템 부하에 대한 모니터링 필요

- Graphite: Hystrix Merics 정보를 파일 형태로 저장
- Grafana: Graphite의 Metrics 이력을 챠트로 표현해 줌(Graphite외 다른 저장소 사용 가능)

## Reference
- Hystrix, Hystrix Dashboard, Turbine, Grafana : https://coe.gitbook.io/guide/circuit-breaker/hystrix


## OAuthe2 
- oauth2 with zuul, eureka

- https://github.com/Lungesoft/Simple-Example-OAuth2-With-Spring-cloud-Eureka-Ribbon-Zuul
- https://www.baeldung.com/spring-security-zuul-oauth-jwt
- https://stackoverflow.com/questions/38030242/zuul-proxy-oauth2-unauthorized-in-spring-boot






## 11번가 MSA
- 검색어 : MSA 11번가
https://www.slideshare.net/balladofgale/spring-camp-2018-11-spring-cloud-msa-1
https://www.youtube.com/watch?v=J-VP0WFEQsY


### RabbitMQ HA (High Available)
- https://github.com/pardahlman/docker-rabbitmq-cluster


