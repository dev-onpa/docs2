# CentOS7에 OpenJDK 설치하기 

## Open JDK 설치 
centOs의 쉘에 아래 명령으로 현재 설치가능한 jdk 버전확인
```
yum list java*jdk-devel
```

조회된 결과중에 java-1.8.0-openjdk-devel.x86_64 버전을 설치해보자  
쉘에 아래 명령어를 입력하자.
```
yum install java-1.8.0-openjdk-devel.x86_64
```

## CentOs7 jdk 설치 결과 확인
```
[root@localhost ~]# javac -version
javac 1.8.0_161
[root@localhost ~]# rpm -qa java*jdk-devel
java-1.8.0-openjdk-devel-1.8.0.161-0.b14.el7_4.x86_64
[root@localhost ~]#
```


## javac 위치 확인
```
[root@localhost ~]# javac -version
javac 1.8.0_161
[root@localhost ~]# rpm -qa java*jdk-devel
java-1.8.0-openjdk-devel-1.8.0.161-0.b14.el7_4.x86_64
[root@localhost ~]#
```
which javac라는 명령어는 javac라는 명령어의 위치를 알려달라는 말이다.  
/usr/bin/javac 는 심볼릭 링크 이므로 원본 파일의 위치를 찾기 위해 readlink -f /usr/bin/javac 명령어를 사용하였다.  
readlink -f는 심볼릭 링크에서 원본파일을 추출하는 명령어 이다.  
즉 /usr/lib/jvm/java-1.8.0-openjdk-1.8.0.161-0.b14.el7_4.x86_64/bin/javac 가 쉘에서 동작하고 있는 javac명령어의 원본파일이다.
`/usr/lib/jvm/java-1.8.0-openjdk-1.8.0.161-0.b14.el7_4.x86_64` 가 JAVA_HOME이 될 경로가 된다.


## JAVA_HOME 설정 
실제 javac명령어의 경로를 찾았으니 그 경로를 이용하여 JAVA_HOME 환경변수로 등록하도록 하자.
환경변수를 설정할수 있는 profile 이라는 파일을 vi 편집기로 열자
```
vi /etc/profile
```

해당 파일의 하단에 아래 내용을 추가한뒤 저장하자.
```
export JAVA_HOME=/usr/lib/jvm/java-1.8.0-openjdk-1.8.0.161-0.b14.el7_4.x86_64
```


파일을 저장한뒤 아래 명령어를 이용하여 수정한 파일을 적용하자.  
ssh를 재접속 해도 되지만 아래 방법이 더 편하다.
```
source /etc/profile
```