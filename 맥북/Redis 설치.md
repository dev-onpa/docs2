# Redis 설치 (mac)
> 2021.03.30 
> https://hub.docker.com/_/redis


## Docker
### redis 이미지 다운로드 
```shell
docker pull redis
```

### redis network 생성 
```shell
docker network create dbclose-redis-network
```


### redis 실행 
```shell
docker run --name dbclose-redis -d -p 6379:6379 redis
```

```shell
docker run --name dbclose-redis -d -p 6379:6379 --network dbclose-redis-network -v /Users/dbclose/redis  redis redis-server --appendonly yes
```


### redis-cli로 redis 접속 
```shell
docker run -it --network dbclose-redis-network --rm redis redis-cli -h dbclose-redis
```


### redis 종료 
```shell
docker stop dbclose-redis
```

### redis 삭제 
```shell
docker rm dbclose-redis
```


## Medis (Redis Client for Mac)
> https://github.com/luin/medis  
> https://dolsup.work/posts/how-to-build-medis-on-macos/
> app store에서 받으면 유료. github 소스로 설치시 무료 

### 소스 다운로드 (git clone)
```shell
$ cd /Users/dbclose
$ git clone https://github.com/luin/medis.git
$ cd medis
$ npm install
$ npm run pack
```
진행 중에 webpack analyzer가 브라우저 탭으로 뜨면 프로세스를 종료하세요. (Ctrl+C)

```shell
$ node bin/pack.js
```
“Unhandled rejection Error: No identity found for signing.“과 같은 에러는 무시하셔도 됩니다. 배포하지 않고 혼자 사용할 것이기 때문에 Signing은 필요 없습니다.


```shell
$ dist/out/Medis-mas-x64/Medis.app
```