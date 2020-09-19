# MariaDB (on CentOS7)

## MariaDB 5.5
yum으로 설치하면 됨.

### 1. yum
```
$ sudo yum install mariadb-server
```

### 2. 시작 및 부팅 시 자동실행 
```
$ sudo systemctl start mariadb
$ sudo systemctl enable mariadb
```

### 3. 상태 체크  
```
$ sudo systemctl status mariadb
```

### 4. Run the mysql_secure_installation script which will perform several security related tasks:Run the mysql_secure_installation script which will perform several security related tasks:
```
$ sudo mysql_secure_installation
```


## MariaDB 10.3 설치 
MariaDB 리파지토리 활성화 

### 1. MariaDB Repository
/etc/yum.repos.d/MariaDB.repo
```
# MariaDB 10.3 CentOS repository list - created 2018-05-25 19:02 UTC
# http://downloads.mariadb.org/mariadb/repositories/
[mariadb]
name = MariaDB
baseurl = http://yum.mariadb.org/10.3/centos7-amd64
gpgkey=https://yum.mariadb.org/RPM-GPG-KEY-MariaDB
gpgcheck=1
```

### 2. yum
```
$ sudo yum install MariaDB-server MariaDB-client
```

### 3. 시작 및 부팅 시 자동 실행 설정  
```
$ sudo systemctl start mariadb
$ sudo systemctl enable mariadb
```

### 3. 상태 체크  
```
$ sudo systemctl status mariadb
```

### 4. Run the mysql_secure_installation script which will perform several security related tasks:Run the mysql_secure_installation script which will perform several security related tasks:
root 비밃번호 등 기본적인 설정
```
$ sudo mysql_secure_installation
```



## 접속 (command line)
To connect to the MariaDB server through the terminal as the root account type:

```
mysql -u root -p
```

You will be prompted to enter the root password you have previously set when the mysql_secure_installation script was run.

Once you enter the password you will be presented with the MariaDB shell as shown below:

```
Welcome to the MariaDB monitor.  Commands end with ; or \g.
Your MariaDB connection id is 8
Server version: 10.3.7-MariaDB MariaDB Server

Copyright (c) 2000, 2018, Oracle, MariaDB Corporation Ab and others.

Type 'help;' or '\h' for help. Type '\c' to clear the current input statement.
```


## 캐릭터셋(charset) 설정 (utf8mb4 / utf8mb4_unicode_ci)
디폴트 캐릭터셋을 latin1에서 utf-8(mb4, 이모지추가)으로 변경하기 위해 아래 내용으로 추가함.

### 현재 설정 확인  
``` 
show variables like 'c%';
```

### /etc/my.cnf.d/mysql-clients.cnf
``` 
[mysql]
default-character-set=utf8

[mysqldump]
default-character-set=utf8
``` 

### /etc/my.cnf.d/server.cnf
``` 
[mysqld]
collation-server = utf8_unicode_ci
init-connect='SET NAMES utf8'
character-set-server = utf8
``` 

### 설정 적용 
``` 
$ systemctl restart mariadb
```

## 방화벽 설정 (firewall-cmd)
- 3306 포트 추가 
``` 
$ firewall-cmd --permanent --zone=public --add-port=3306/tcp
$ firewall-cmd --reload
``` 










https://linuxize.com/post/install-mariadb-on-centos-7/