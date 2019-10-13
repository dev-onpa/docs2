# Microservice Architecture.


## Eureka 서버 구성 
### 1. Spring Initializer를 이용하여 Project를 구성함.
```
    Cloud Discovery > Eureka Server를 선택 
```

### 2. EurekaServerApplication.java 에 @EnableEurekaServer 애노테이션 추가 
```java
package msa.eurekaserver;

import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.cloud.netflix.eureka.server.EnableEurekaServer;

@EnableEurekaServer
@SpringBootApplication
public class EurekaServerApplication {

	public static void main(String[] args) {
		SpringApplication.run(EurekaServerApplication.class, args);
	}

}
```


### 3. application.properties 파일에 아래와 같이 환경 구성 
```aidl
    #Port for Registry service
    server.port=8761
    
    #Service should not register with itself
    eureka.client.register-with-eureka=false
    eureka.client.fetch-registry=false
    
    #Managing the logging
    logging.level.com.netflix.eureka=OFF
    logging.level.com.netflix.discovery=OFF
```

### 4. application을 실행하고 8761 포트에 접속 
```
http://localhost:8761
```



## Microservice




