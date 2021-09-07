# ContentNegotiation 설정 
> https://www.baeldung.com/spring-mvc-content-negotiation-json-xml


## @ResponseBody Content-Type은 어떻게 결정되는 가? 
기본적으로 Request Header의 "Accept" 값에 따라 결정됨. 
ContentNegotiation의 전략 중 HeaderContentNegotiationStrategy.java 에서 결정   
