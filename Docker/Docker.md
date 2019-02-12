# Docker 시작하기

## Part 1 : 설정 

### Docker 컨셉 
Docker는 개발자나 시스템 관리자가 컨테이너(`Container`)를 사용하여 애플리케이션을 개발, 배포, 실행할 수 있는 플랫폼이다. Linux 컨테이너를 사용하여 애플리케이션을 배포한다.
컨테이너는 새로운 것은 아니지만 애플리케이션을 쉽게 배포할 수 있게 해준다. 

컨테이너를 통해 애플리케이션을 배포하는 점점 인기를 얻고 있다. 왜냐하면

1. 유연하다 : 복잡한 애플리케이션도 Containerizerd 될 수 있다.
2. 가볍다 : 컨테이너는 host kernel을 사용하고 공유한다.
3. 교체가능(Interchageable) : 앱이 업데이트, 업그레이드 된 경우 즉시 배포가 가능하다.
4. 확장(Scaleable) : 컨테이너의 복제본을 늘리고 자동으로 배포할 수 있다.
5. Stackable : 서비스(`Service`)를 수직으로 즉석해서 쌓을 수 있다.


#### 이미지와 컨테이너 (Image and containers)

컨테이너는 이미지를 실행하여 구동된다. 
이미지는 애플리케이션을 실행하기 위해 필요한 모든 것을 포함하는 실행가능한 패키지이다. (code, runtime, library, evironment variables, and configuration files)
컨테이너는 이미지의 런타임 인스턴스이고 실행될 때 메모리에 상주하게 된다.
리눅스에서 처럼 `docker ps` 명령어로 실행중인 컨테이너를 확인할 수 있다.


#### 컨테이너와 가상머신 (Container and virtual machines)


### Docker 환경 구성
우선 Docker를 설치하자

>  
> 쿠버네티스 (Kubernetes)와 완전한 통합을 위해서는  
>  
> + Kubernetes on Docker for Mac is available in 17.12 Edge (mac45) or 17.12 Stable (mac46) and higher.
> + Kubernetes on Docker for Windows is available in 18.02 Edge (win50) and higher edge channels only.


> [`Docker 설치하기`](https://docs.docker.com/install/)  
  
#### Docker 버전 확인
1. `docker --version`을 실행하고 지원되는 버전인지 확인하자

```
    docker --version
```


## Part 2 : 컨테이너 (Containers) 

### Recap and cheat sheet (optional)
    $ docker build -t friendlyhello .         # Create image using this directory's Dockerfile 
    $ docker run -p 4000:80 friendlyhello     # Run "friendlyname" mapping port 4000 to 80
    $ docker run -d -p 4000:80 friendlyhello         # Same thing, but in detached mode
    $ docker container ls                                # List all running containers
    $ docker container ls -a                  # List all containers, even those not running
    $ docker container stop <hash>           # Gracefully stop the specified container
    $ docker container kill <hash>         # Force shutdown of the specified container
    $ docker container rm <hash>        # Remove specified container from this machine
    $ docker container rm $(docker container ls -a -q)         # Remove all containers
    $ docker image ls -a                             # List all images on this machine
    $ docker image rm <image id>            # Remove specified image from this machine
    $ docker image rm $(docker image ls -a -q)   # Remove all images from this machine
    $ docker login             # Log in this CLI session using your Docker credentials
    $ docker tag <image> username/repository:tag  # Tag <image> for upload to registry
    $ docker push username/repository:tag            # Upload tagged image to registry
    $ docker run username/repository:tag                   # Run image from a registry