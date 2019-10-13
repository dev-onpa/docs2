# Spring Security OAuth

- 권한부여 서버(Authorization Server)와 리소스 서버(Resource Server)를 같이 구성함.


## OAuth 기본 Endpoint URI 변경
- 기본 : /oauth/token
- 변경 : /api/auth/token

`AuthorizationServerEndpointsConfigurer`에서 설정 변경이 가능함. 

```java
@Override
public void configure(AuthorizationServerEndpointsConfigurer endpoints) throws Exception {
    endpoints.tokenStore(tokenStore())

        .pathMapping("/oauth/token", "/api/auth/token")         // 변경 
        .pathMapping("/oauth/authorize", "/api/auth/authorize") // 변경 
        .tokenEnhancer(jwtAccessTokenConverter())
        .authenticationManager(authenticationManager)
        .userDetailsService(userDetailsService);

    // ....

}
```


 