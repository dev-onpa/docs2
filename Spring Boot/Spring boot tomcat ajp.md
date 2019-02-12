https://sarc.io/index.php/development/1116-spring-boot-ajp


1. 개요
Spring Boot에 AJP 포트 설정을 추가하는 방법이다.

2. 방법 I
2-1. ContainerConfig 클래스 추가
import org.apache.catalina.connector.Connector;
import org.springframework.boot.context.embedded.EmbeddedServletContainerCustomizer;
import org.springframework.boot.context.embedded.tomcat.TomcatEmbeddedServletContainerFactory;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;

```
@Configuration
public class ContainerConfig {
	@Bean
	public EmbeddedServletContainerCustomizer containerCustomizer() {
		return container -> {
			TomcatEmbeddedServletContainerFactory tomcat =
					(TomcatEmbeddedServletContainerFactory) container;
			
			Connector ajpConnector = new Connector("AJP/1.3");
			ajpConnector.setPort(8109);
			ajpConnector.setSecure(false);
			ajpConnector.setAllowTrace(false);
			ajpConnector.setScheme("http");
			tomcat.addAdditionalTomcatConnectors(ajpConnector);
		};
	}
}
```
2-2. 부팅 로그 확인 
2018-02-13 14:05:45.706  INFO 12972 --- [           main] s.b.c.e.t.TomcatEmbeddedServletContainer : Tomcat initialized with port(s): 8180 (http) 8109 (http)
2018-02-13 14:05:49.681  INFO 12972 --- [           main] org.apache.coyote.ajp.AjpNioProtocol     : Initializing ProtocolHandler ["ajp-nio-8109"]
2018-02-13 14:05:49.699  INFO 12972 --- [           main] org.apache.coyote.ajp.AjpNioProtocol     : Starting ProtocolHandler ["ajp-nio-8109"]
2018-02-13 14:05:49.779  INFO 12972 --- [           main] s.b.c.e.t.TomcatEmbeddedServletContainer : Tomcat started on port(s): 8180 (http) 8109 (http)
3. 방법 II
3-1. application.properties
다음 설정을 추가한다.

tomcat.ajp.protocol=AJP/1.3
tomcat.ajp.port=8109
tomcat.ajp.enabled=true
3-2. ContainerConfig 클래스 추가
import org.apache.catalina.connector.Connector;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.boot.context.embedded.EmbeddedServletContainerCustomizer;
import org.springframework.boot.context.embedded.tomcat.TomcatEmbeddedServletContainerFactory;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;

@Configuration
public class ContainerConfig {
	@Value("${tomcat.ajp.protocol}")
	String ajpProtocol;

	@Value("${tomcat.ajp.port}")
	int ajpPort;

	@Value("${tomcat.ajp.enabled}")
	boolean tomcatAjpEnabled;

	@Bean
	public EmbeddedServletContainerCustomizer containerCustomizer() {
		return container -> {
			TomcatEmbeddedServletContainerFactory tomcat = (TomcatEmbeddedServletContainerFactory) container;
			if (tomcatAjpEnabled) {
				Connector ajpConnector = new Connector(ajpProtocol);
				ajpConnector.setPort(ajpPort);
				ajpConnector.setSecure(false);
				ajpConnector.setAllowTrace(false);
				ajpConnector.setScheme("http");
				tomcat.addAdditionalTomcatConnectors(ajpConnector);
			}
		};
	}
}
3-3. 부팅 로그 확인
2018-02-13 14:12:29.969  INFO 6932 --- [           main] s.b.c.e.t.TomcatEmbeddedServletContainer : Tomcat initialized with port(s): 8180 (http) 8109 (http)
2018-02-13 14:12:33.171  INFO 6932 --- [           main] org.apache.coyote.ajp.AjpNioProtocol     : Initializing ProtocolHandler ["ajp-nio-8109"]
2018-02-13 14:12:33.184  INFO 6932 --- [           main] org.apache.coyote.ajp.AjpNioProtocol     : Starting ProtocolHandler ["ajp-nio-8109"]
2018-02-13 14:12:33.228  INFO 6932 --- [           main] s.b.c.e.t.TomcatEmbeddedServletContainer : Tomcat started on port(s): 8180 (http) 8109 (http)
 