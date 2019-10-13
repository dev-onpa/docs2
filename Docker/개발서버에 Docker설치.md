# 개발 서버에 Docker 설치하기 

개발서버 192.168.123.8 에 docker, docker-compose를 설치하고 
docker-registry를 구성한다.


## docker 설치 



## docker-registry
ssl 적용 (원격에서 사용하기 위해서 )

```
docker run -d -p 5000:5000 --restart=always --name docker-registry \
  -v /etc/httpd/ssl/wildcard.onlinepowers.com_2018:/certs \
  -e REGISTRY_HTTP_TLS_CERTIFICATE=/certs/_wildcard_onlinepowers_com.crt \
  -e REGISTRY_HTTP_TLS_KEY=/certs/_wildcard_onlinepowers_com_SHA256WITHRSA.key \
  registry
```

docker run -d -p 5000:5000 --restart=always --name docker-registry registry
