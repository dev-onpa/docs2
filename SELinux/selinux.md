
설정 확인
```
$ sestatus
$ setenforce 0
````



```
$ setenforce 1
```


## 아파치에서 403 Fobidden 일 때 

상태확인.  httpd_sys_content_t 있어야 아파치가 읽을 수 있음.
```
$ ls -lZ 
```

httpd_sys_content_t


chcon -R -t user_home_dir_t spring.png
user_home_dir_t




## SELinux
[- SELinux 참고](https://itzone.tistory.com/646)

http://blog.naver.com/PostView.nhn?blogId=take0415&logNo=221100645561


```xml
<VirtualHost *:80>
        ServerName jestina.co.kr
        ServerAdmin edger@jestina.com

        <Directory /home/jestina/mall>
                AllowOverride AuthConfig
                Require all granted
        </Directory>

        # JkMount
        Include conf/tomcat2.properties

        RewriteEngine On
        RewriteCond %{HTTPS} !=on
        RewriteCond %{REQUEST_URI}  !(upload/UpData2/ep/)
        RewriteRule ^(.*)$  https://www.jestina.co.kr$1 [R,L]

</VirtualHost>

```


$ setsebool -P httpd_use_nfs=1 