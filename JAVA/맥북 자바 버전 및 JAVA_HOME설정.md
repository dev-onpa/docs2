# 맥북 자바 버전 및 JAVA_HOME 설정 

## 자바 버전 확인
```$xslt
$ /usr/libexec/java_home -V
``` 


```$xslt
Matching Java Virtual Machines (4):
    11.0.1, x86_64:	"OpenJDK 11.0.1"	/Library/Java/JavaVirtualMachines/jdk-11.0.1.jdk/Contents/Home
    1.8.0_181-zulu-8.31.0.1, x86_64:	"Zulu 8"	/Library/Java/JavaVirtualMachines/zulu-8.jdk/Contents/Home
    1.8.0_181, x86_64:	"Java SE 8"	/Library/Java/JavaVirtualMachines/jdk1.8.0_181.jdk/Contents/Home
    1.7.0_80, x86_64:	"Java SE 7"	/Library/Java/JavaVirtualMachines/jdk1.7.0_80.jdk/Contents/Home
``` 

아래 설치된 자바 버전 중 원하는 버전으로 쉽게 변경할 수 있음.


## JAVA_HOME 변경 
```$xslt
# Java 10
$ export JAVA_HOME=$(/usr/libexec/java_home -v 10)

# Java 9
$ export JAVA_HOME=$(/usr/libexec/java_home -v 9)

# Java 1.8
$ export JAVA_HOME=$(/usr/libexec/java_home -v 1.8)

# Java 1.7
$ export JAVA_HOME=$(/usr/libexec/java_home -v 1.7)

# Java 1.6
$ export JAVA_HOME=$(/usr/libexec/java_home -v 1.6)
``` 

동일 버전이 여러개 설치된 경우에는 ? 
-> export JAVA_HOME=$(/usr/libexec/java_home -v 1.8)  Open Jdk가 되었음.

