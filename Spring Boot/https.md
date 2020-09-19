# Spring Boot SSL 적용 

## 2019-01-30

application.properties
```
server.port=8443 #

# 키 저장소 경로 server.ssl.key-store=C:/Program Files/Java/jdk1.8.0_45/bin/keystore.jks 

# 키 저장소 
server.ssl.key-store-password=설정했던비밀번호 

# alias에 맞는 비번 
server.ssl.key-password=설정했던비밀번호 
server.ssl.key-alias=설정했던별칭 
server.ssl.trust-store=C:/Program Files/Java/jdk1.8.0_45/bin/cacerts.jks server.ssl.trust-store-password=설정했던비밀번호

```


## 2019-10-30
> Update http/https 동시 사용 설정 

### How to Enable HTTP/HTTPS in Spring Boot

#### spring boot 2.o

```
@SpringBootApplication
public class HpptHttpsSpringBootApplication {

	//HTTP port
	@Value("${http.port}")
	private int httpPort;

	public static void main(String[] args) {
		SpringApplication.run(HpptHttpsSpringBootApplication.class, args);

	}

	// Let's configure additional connector to enable support for both HTTP and HTTPS
	@Bean
	public ServletWebServerFactory servletContainer() {
		TomcatServletWebServerFactory tomcat = new TomcatServletWebServerFactory();
		tomcat.addAdditionalTomcatConnectors(createStandardConnector());
		return tomcat;
	}

	private Connector createStandardConnector() {
		Connector connector = new Connector("org.apache.coyote.http11.Http11NioProtocol");
		connector.setPort(httpPort);
		return connector;
	}
}

```

application.properties
```
# The format used for the keystore. for JKS, set it as JKS
server.ssl.key-store-type=PKCS12
# The path to the keystore containing the certificate
server.ssl.key-store=classpath:keystore/javadevjournal.p12
# The password used to generate the certificate
server.ssl.key-store-password=you password
# The alias mapped to the certificate
server.ssl.key-alias=javadevjournal
# Run Spring Boot on HTTPS only
server.port=8443

#HTTP port
http.port=8080
```

keystore
```
$ keytool -genkey -alias eshotlink-ssl -storetype PKCS12 -keyalg RSA -keysize 2048 -keystore eshotlink.p12 -validity 3650 
```


- spring boot: https://www.javadevjournal.com/spring-boot/how-to-enable-http-https-in-spring-boot/
- eshotlink.p12: https://jojoldu.tistory.com/350

