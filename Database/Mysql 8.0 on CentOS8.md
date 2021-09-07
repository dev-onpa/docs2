# Mysql 8.0 on CentOS8
> 설치 : https://www.itzgeek.com/how-tos/linux/centos-how-tos/how-to-install-mysql-8-0-on-rhel-8.html
> 8.0 기능 : http://minsql.com/mysql8/C-1-A-newCharsetWithCollation/
> 2020.03.02

## Install MySQL 8.0 from MySQL Dev Community
공식 mysql community server repository 추가
```
rpm -ivh https://dev.mysql.com/get/mysql80-community-release-el8-1.noarch.rpm

https://dev.mysql.com/get/mysql80-community-release-el8-1.noarch.rpm(을)를 복구합니다
경고: /var/tmp/rpm-tmp.XcR9Jg: Header V3 DSA/SHA1 Signature, key ID 5072e1f5: NOKEY
Verifying...                          ################################# [100%]
준비 중...                         ################################# [100%]
Updating / installing...
   1:mysql80-community-release-el8-1  ################################# [100%]
```

다음 명령으로 mysql 저장소 추가 및 활성화 여부 확인
```
yum repolist all | grep mysql | grep enabled

MySQL Connectors Community                       19 kB/s |  19 kB     00:01
MySQL Tools Community                           3.0 MB/s |  62 kB     00:00
MySQL 8.0 Community Server                      1.3 MB/s | 543 kB     00:00
```

yum 명령을 이용하여 mysql 설치
```
yum --disablerepo=AppStream install -y mysql-community-server
```

## MySQL 서버 서비스를 시작
MySQL을 설치 한 후 다음 명령을 사용하여 MySQL 서버 서비스를 시작하십시오.

```
systemctl start mysqld
```

재부팅시 자동 시작 설정
```
systemctl enable mysqld
```

상태확인
```
systemctl status mysqld
```

## Mysql 보안 설정
mysql root 계정의 초기 비밀번호는 `/var/log/mysqld.log`에서 확인할 수 있습니다.
```
cat /var/log/mysqld.log | grep -i 'temporary password'

2020-03-02T07:25:12.795259Z 5 [Note] [MY-010454] [Server] A temporary password is generated for root@localhost: fewA-!&so1w9
```

root 비밀번호 설정 및 기본 보안 설정을 위해 아래 명령을 실행합니다.
root / Rnfhpowers^&^5  (대문자 / 특수문자 / 숫자 포함)
```
mysql_secure_installation
```

항목에 대한 값을 설정
```
Securing the MySQL server deployment.

Enter password for user root:   << Enter the temporary password you got from the previous step

The existing password for the user account root has expired. Please set a new password.

New password:   << Enter new root password

Re-enter new password:   << Re-enter new root password
The 'validate_password' component is installed on the server.
The subsequent steps will run with the existing configuration
of the component.
Using existing password for root.

Estimated strength of the password: 100 
Change the password for root ? ((Press y|Y for Yes, any other key for No) : N  << Type N and Enter as we have already set root password

 ... skipping.
By default, a MySQL installation has an anonymous user,
allowing anyone to log into MySQL without having to have
a user account created for them. This is intended only for
testing, and to make the installation go a bit smoother.
You should remove them before moving into a production
environment.

Remove anonymous users? (Press y|Y for Yes, any other key for No) : Y  << Remove anonymous user
Success.


Normally, root should only be allowed to connect from
'localhost'. This ensures that someone cannot guess at
the root password from the network.

Disallow root login remotely? (Press y|Y for Yes, any other key for No) : N  << allow root login remotely
Success.

By default, MySQL comes with a database named 'test' that
anyone can access. This is also intended only for testing,
and should be removed before moving into a production
environment.


Remove test database and access to it? (Press y|Y for Yes, any other key for No) : Y  << Remove test database
 - Dropping test database...
Success.

 - Removing privileges on test database...
Success.

Reloading the privilege tables will ensure that all changes
made so far will take effect immediately.

Reload privilege tables now? (Press y|Y for Yes, any other key for No) : Y  << Reload privilege tables
Success.

All done!
```

## Mysql 접속
```
mysql -uroot -p

password: 변경한 비밀번호 
```

## 데이터베이스 / 계정 생성
```sql
CREATE DATABASE SALESON3;
CREATE USER 'saleson3'@'192.168.123.%' IDENTIFIED WITH mysql_native_password BY 'pw92%@';
GRANT ALL PRIVILEGES ON SALESON3.* TO 'saleson3'@'192.168.123.%' WITH GRANT OPTION;
```