# Let's Encrypt
> https://lynlab.co.kr/blog/72
> 2020-07-28


## docker를 이용해 인증서 발급..신
### 인증서 발급 
```
docker run -it --rm --name certbot \
  -v '/Users/dbclose/letsencrypt/certs:/etc/letsencrypt' \
  -v '/Users/dbclose/letsencrypt/lib:/var/lib/letsencrypt' \
  certbot/certbot certonly -d '*.emoldino.com' \
  --manual --preferred-challenges dns --server https://acme-v02.api.letsencrypt.org/directory

```


### 인증서 갱신 (90일 마다..)
```
docker run -it --rm --name certbot \
  -v '/Users/dbclose/letsencrypt/certs:/etc/letsencrypt' \
  -v '/Users/dbclose/letsencrypt/lib:/var/lib/letsencrypt' \
  certbot/certbot renew \
  --manual --preferred-challenges dns --server https://acme-v02.api.letsencrypt.org/directory

```

## Spring boot용 인증서로 변경 
spring boot는 pem 형식의 인증서는 지원하지 않음. 

인증서 경로로 이동 
```
cd /Users/dbclose/letsencrypt/certs/live/emoldino.com

openssl pkcs12 -export -in fullchain.pem \
                 -inkey privkey.pem \
                 -out emoldino.p12 \
                 -name emoldino \
                 -CAfile chain.pem \
                 -caname root


Enter Export Password:
Verifying - Enter Export Password:
```

### application.properties
```
server:
  port: 8443
  servlet:
    context-path: /
  ssl:
    key-store: /Users/dbclose/letsencrypt/certs/live/emoldino.com/emoldino.p12
    key-store-password: emoldino^&^%
    key-store-type: pkcs12
    key-alias: emoldino

```

```
server.ssl.key-store-type: pkcs12
server.ssl.key-store=/Users/dbclose/letsencrypt/certs/live/emoldino.com/emoldino.p12
server.ssl.key-store-password=emoldino^&^%
server.ssl.key-alias=emoldino
```



안녕하세요. 신극창입니다. 

Alibaba 클라우드 구성에 대한 진행 내용을 공유드립니다. 

1. ECS 인스턴스 구성 및 애플리케이션 설치 완료
2. RDS 인스턴스 구성 및 애플리케이션과 RDS 연동 
3. http://47.111.163.58 (ECS IP)으로 접속 가능하지만 속도가 느림.
4. SLB 구성완료
    - 무료 SSL인증서를 사용할 수 있을 것으로 예상하였지만 인증서를 구매하거나 letencrypt에서 무료인증서를 연동하는 것으로 가이드됨.
    - letencrypt에서 무료 인증서 발급 후 연동
    - https://47.98.59.87 로 접속 가능.
5. AWS Route53에서 ac0728.emoldino.com 레코드 설정 후 접속 시 중국 ICP 관련 페이지로 접속됨. 


알리 클라우드 구성 시 현재까지의 이슈는 속도, SSL인증서, 도메인 연결 문제입니다. 

[속도이슈]
ECS로 직접 연결하는 경우 속도 저하가 있는 것으로 예상되며 
1. bandwidth를 크게 설정하여 Elastic IP(EIP)를 생성한 후 ECS에 연결 (테스트 중)
   - 알리클라우드 관리콘솔에서 EIP생성 후 ECS에 연결 설정 시 이후 진행이 않되는 현상이 발생하여 문의 요청 중
2. SLB(Server Load Balancer)를 생성 후 ECS와 연결
   - 테스트 시 접속 속도는 향상된 것으로 확인 
   - ECS endpoint: http://47.111.163.58   (ECS로 직접 접속 )
   - SLB endpoint: http://47.98.59.87     (SLB를 통해 ECS에 접속)

EIP가 정상적으로 설정되고 속도향상이 있는 것으로 확인되는 경우 
서버 이중화 여부 및 가격에 따라 EIP나 SLB를 선택하면 될 것으로 예상됩니다. 


[SSL인증서]
- AWS와는 다르게 무료 SSL인증서를 제공하지 않아 인증서를 구매하거나 letencrypt에서 무료인증서를 발급받아 연동해야함.
- letencrypt에서 무료인증서는 *.emoldino.com 으로 발급은 받은 상태이지만 3개월 마다 갱신해야함.
- 무료인증서를 ECS에서 직접 연결하는 경우 스크립트를 통해 3개월 마다 자동으로 갱신할 수 있을 것으로 예상됨.
- 무료인증서를 SLB에 연결하는 경우 3개월마다 수동으로 갱신하거나 자동 갱신할 수 있는 방법을 찾아봐야함.
- 실제 접속 시 무료 인증서를 연동했을 때 문제가 없는 지는 확인해 봐야 하지만 
  현재 도메인으로 접속 시 ICP오류 페이지가 보여 아직 확인되지는 않음. 
  (테스트 서버에 무료인증서를 연결하고 테스트 했을 때는 인증서 오류는 없었음. https://dev.emoldino.tk)


[도메인 연결]
Rout53에서 도메인 레코드 생성 후 접속을 시도했을 때 ICP 관련 메시지가 보입니다. 
SLB 설정이나 HTTPS 접속 및 인증서 정상여부를 확인은 ICP 등록 후 가능할 것으로 보입니다.  


