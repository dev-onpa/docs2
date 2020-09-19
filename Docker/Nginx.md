# Nginx Docker로 실행하기 

## Nginx Docker 최신버전 설치 명령어
```
$ sudo docker pull nginx:latest
```

### Nginx index 파일 설정
Nginx Docker와 vloume 설정 할 폴더 확인 (http root)
```
$ pwd
/Users/dbclose/saleson/3.0/workspace/saleson/saleson-front
```


## Nginx Docker 컨테이너 실행
명령어 설명
- run nginx : nginx 이미지에 option 을 주면서 실행
- --name : docker container 이름 설정
- -v : local 에 있는 /home/mint/nginx/html 폴더를 nginx docker의 /usr/share/nginx/html 폴더와 mount
- -d : background에서 실행
- -d : 포트 설정 local 80 port: nginx container 80 port

```
$ docker run --name nginx-saleson-front -v /Users/dbclose/saleson/3.0/workspace/saleson/saleson-front:/usr/share/nginx/html:ro -d -p 80:80 nginx
```



$ docker run --name nginx-dacha -v /Users/dbclose/workspace/dacha:/usr/share/nginx/html:ro -d -p 80:80 nginx

$ docker run --name nginx-mms -v /Users/dbclose/eshotlink/mms/src/main/resources/static:/usr/share/nginx/html:ro -d -p 80:80 nginx
$ docker run --name nginx-druh -v /Users/dbclose/onlinepowers/druhgolf/saleson-front:/usr/share/nginx/html:ro -d -p 80:80 nginx


docker run --name nginx-vk -v /Users/dbclose/workspace/vk:/usr/share/nginx/html:ro -d -p 80:80 nginx




docker run --name nginx-skplanet -v /Users/dbclose/onlinepowers/skplanet/saleson-front:/usr/share/nginx/html:ro -d -p 80:80 nginx


출처: https://minimilab.tistory.com/8 [MINIMI LAB]