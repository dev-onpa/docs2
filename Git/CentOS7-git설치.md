CentOS7 에 git 2버전 설치하기 
=========================

RHEL/CentOS 7 에는 git 1.8, CentOS 6 은 1.7 이 포함되어 있지만 버전이 낮아서 최신 버전의 gitlab 이나 Bitbucket 등을 설치할 수 없다.

gitlab 을 설치하려면 git 1.8 이 필요하므로 yum repository 를 제공하는 The PUIAS Computational repository 에서 최신 git 버전을 다운로드 할 수 있다.


2.x 버전 설치 
-----------
2.x 이상을 사용할 경우 Wandisco 사의 repository 를 설치한 후에 yum 으로 설치하면 된다.


### repository 설치 

#### CentOS 7
```
$ rpm -Uvh http://opensource.wandisco.com/centos/7/git/x86_64/wandisco-git-release-7-2.noarch.rpm
```

#### CentOS 6
```
$ rpm -Uvh http://opensource.wandisco.com/centos/6/git/x86_64/wandisco-git-release-6-1.noarch.rpm
```

### Git 설치 
정상 설치 여부를 확인하기 위해 `WANdisco` 저장소에서 git 검색
```
$ yum --enablerepo=WANdisco-git --disablerepo=base,updates info git
```

repository 설치를 마쳤으면 아래 명령어로 git 을 설치
```
yum --enablerepo=WANdisco-git --disablerepo=base,updates install git
```
