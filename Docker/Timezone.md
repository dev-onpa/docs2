# Docker Timezone 설정 
> 2021.04.13 
> https://labo.lansi.kr/posts/33

## Docker 타임존 설정 
### apt-get

```dockerfile
ENV TZ="Asia/Seoul"
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone
```


### alpine linux
```dockerfile
ENV TZ="Asia/Seoul"
RUN apk add tzdata
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone
```