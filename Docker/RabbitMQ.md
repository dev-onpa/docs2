# RabbitMQ  docker로 실행하기 

## Install rabbitmq

### - 이미지 검색
```
$ docker search rabbitmq

```

### - 이미지 가져오기 
```
$ docker search rabbitmq

```


### - rabbitmq 실행하기 

```
$ docker run -d --hostname rabbitmq --name rabbitmq -p 5672:5762 -p 5671:5671 -p 15672:15672 -e RABBITMQ_DEFAULT_USER=admin -e RABBITMQ_DEFAULT_PASS=admin rabbitmq:3.6.6-management
```

### - rabbitmq 관리 페이지 접속 
```
http://localhost:15672
```



### - 이슈 
```
 이미지를 rabbitmq:latest로 실행하면 관리페이지 접속이 안됨.
 (rabbitmq:3.6.6-management)
```