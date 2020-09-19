

## ELB 생성 
- 서비스 > EC2 접속 
- 좌측 로드 밸런싱 > 로드밸런서 메뉴 접속
- `로드 밸런서 생성` 
- Application Load Balancer 생성 
- 가용영역 선택 후 다음.. .
- 생성 후 대상 등록 (인스턴스로 등록 함 )
- 생성 후 로드밸런서를 클릭하면 하단의 리스너항목 
- 리스너의 규칙 보기/편집 으로 규칙추가 
- hostname 기준으로 라우팅 설정 

- https 리스너 추가 
- ACM에서 인증서 생성 후 ROUTE53에 CNAME 추가 

- 추가 할일 : 실제 적용 시 항목 다시 정리 
- http -> https 로 전환 처리 (http 규칙 추가로 설정 가능 - 검색해봐)


## Route53
- 호스트 영역 생성 
- 생성된 호스트 영역에서 레코드 세트로 이동 
- 레코드 추가 

https://medium.com/@rlatla626/route-53%EC%9D%84-%EC%9D%B4%EC%9A%A9%ED%95%9C-%EB%8F%84%EB%A9%94%EC%9D%B8-%EC%97%B0%EA%B2%B0-f92aaeedf6ea


- 기본 도메인 A레코드 별칭(alias)로 로드밸런서 DNS 연결 





## Wix

wix.com 프리미엄 플랜 결제 후 테스트 
Route53 에서 CNAME 설정 후 도메인 연결 확인 
wix에서 https 적용 시 도메인이 연결되지 않음.   


> `중요!`  
> Wix는 외부 사이트와 연결된 도메인 및 하위 도메인에 대한 SSL 지원을 제공하지 않습니다.

https://support.wix.com/ko/article/ssl-%EB%B0%8F-https-%EC%A0%95%EB%B3%B4








## 소스 수정 
spring security form login redirect
로그인 페이지로 전환될 때 https -> http로 변환되어 redirect 됨. 

```
server.tomcat.remote-ip-header=x-forwarded-for
server.tomcat.protocol-header=x-forwarded-proto
```
Source: https://docs.spring.io/spring-boot/docs/current/reference/html/howto-security.html#howto-enable-https










