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

## JAVA 버전 관리하기 
> 2019.10.14.

alternatives 명령어는 심볼릭 링크를 관리할 수 있는 툴입니다. 이를 이용해서 설치된 자바 버전 중 필요한 자바 버전을 선택해 심볼릭 링크를 설정해줄 수 있습니다.

```
$ alternatives
alternatives version 1.7.4 - Copyright (C) 2001 Red Hat, Inc.
This may be freely redistributed under the terms of the GNU Public License.

usage: alternatives --install <link> <name> <path> <priority>
                    [--initscript <service>]
                    [--family <family>]
                    [--slave <link> <name> <path>]*
       alternatives --remove <name> <path>
       alternatives --auto <name>
       alternatives --config <name>
       alternatives --display <name>
       alternatives --set <name> <path>
       alternatives --list

common options: --verbose --test --help --usage --version --keep-missing
                --altdir <directory> --admindir <directory>
```

### 심볼릭 링크 생성하기
```
$ alternatives --install /usr/bin/java java /usr/local/java/jdk1.8.0_171/bin/java 1
$ alternatives --install /usr/bin/java javac /usr/local/java/jdk1.8.0_171/bin/javac 1
$ alternatives --install /usr/bin/java javaws /usr/local/java/jdk1.8.0_171/bin/javaws 1

$ alternatives --set java /usr/local/java/jdk1.8.0_171/bin/java
$ alternatives --set javac /usr/local/java/jdk1.8.0_171/bin/javac
$ alternatives --set javaws /usr/local/java/jdk1.8.0_171/bin/javaws
```

### 심볼릭 링크 설정하기
```
$ alternatives --config java
```
위 명령어를 입력하면 java 로 정의된 심볼릭 링크들을 볼 수 있는데 제가 몇 번 삽질해서 잘못 등록한 자바 버전들을 볼 수 있습니다. 여기서 특정 버전을 골라서 선택할 수 있습니다.
```
$ alternatives --config java

There are 4 programs which provide 'java'.

  Selection    Command
-----------------------------------------------
 + 1           /usr/local/java/jdk1.8.0_171/bin/java
   2           /usr/local/java/jdk1.8.0_112/bin/java
*  3           /bin/java
   4           /usr/local/java/jdk1.8.0_171//bin/java

Enter to keep the current selection[+], or type selection number:
```

### 심볼릭 링크 삭제
잘못 등록한 심볼릭 링크를 삭제해보겠습니다.

```
$ alternatives --remove java /usr/local/java/jdk1.8.0_171//bin/java
```

### 심볼릭 링크 리스트 조회
--list 옵션으로 잘 정의되었는지 확인해보겠습니다.
```
$ alternatives --list
java    manual  /usr/local/java/jdk1.8.0_171/bin/java
javac   manual  /usr/local/java/jdk1.8.0_171/bin/javac
javaws  manual  /usr/local/java/jdk1.8.0_171/bin/javaws
```
### 설치 확인하기
```
$ java -version

java version "1.8.0_171"
Java(TM) SE Runtime Environment (build 1.8.0_171-b11)
Java HotSpot(TM) Client VM (build 25.171-b11, mixed mode)
```






