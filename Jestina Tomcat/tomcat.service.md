# 서비스 파일 작성 

```
$ vi /etc/systemd/system/tomcat.service
```


```
# Systemd unit file for tomcat
[Unit]
Description=Tomcat Mall
After=syslog.target network.target

[Service]
Type=forking

Environment=JAVA_HOME=/usr/lib/jvm/java-1.8.0-openjdk-1.8.0.191.b12-1.el7_6.x86_64
Environment=CATALINA_PID=/usr/local/jestina/jestinaMall/bin/tomcat.pid
Environment=CATALINA_HOME=/usr/local/jestina/jestinaMall
Environment=CATALINA_BASE=/usr/local/jestina/jestinaMall
Environment='CATALINA_OPTS=-Xms2024M -Xmx2048M -server -XX:+UseParallelGC'
Environment='JAVA_OPTS=-Dfile.encoding=UTF-8'

ExecStart=/usr/local/jestina/jestinaMall/bin/startup.sh
ExecStop=/bin/kill -15 $MAINPID

User=root
Group=root
#UMask=0007
RestartSec=10
Restart=always

[Install]
WantedBy=multi-user.target


```


## 서비스 등록 
```
$ systemctl daemon-reload
```

## 서비스 재시작 1
```
$ systemctl restart tomcat.service
```

## 서비스 재시작 2
```
$ service tomcat restart
```

## 부팅 시 자동시작 
```
$ systemctl enable tomcat
```

## 상태보기 
```
$ systemctl status tomcat
```

## Reference 
```
https://www.digitalocean.com/community/tutorials/how-to-install-apache-tomcat-8-on-centos-7
```



# AJP 연결 오류 및 Content 403 Fobbiden 인 경우에 추가로 확인해볼 내용.

## 403 Fobbiden
```
chcon -R -t httpd_sys_content_t /home/jestina
```

## AJP port 연결 실패 시 (tcp)
```
- SELinux 상태 확인 
$ sestatus

- 포트 확인
$ semanage port -l|grep http_port_t

- 포트 추가 
$ semanage port -a -t http_port_t -p tcp 8007
```
