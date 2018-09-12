# Docker

## Get Started

### Part 1 : 설정 


#### Docker 컨셉 
Docker는 개발자나 시스템 관리자가 컨테이너(`Container`)를 사용하여 애플리케이션을 개발, 배포, 실행할 수 있는 플랫폼이다. Linux 컨테이너를 사용하여 애플리케이션을 배포한다.
컨테이너는 새로운 것은 아니지만 애플리케이션을 쉽게 배포할 수 있게 해준다. 

컨테이너를 통해 애플리케이션을 배포하는 점점 인기를 얻고 있다. 왜냐하면

1. 유연하다 : 복잡한 애플리케이션도 Containerizerd 될 수 있다.
2. 가볍다 : 컨테이너는 host kernel을 사용하고 공유한다.
3. 교체가능(Interchageable) : 앱이 업데이트, 업그레이드 된 경우 즉시 배포가 가능하다.
4. 확장(Scaleable) : 컨테이너의 복제본을 늘리고 자동으로 배포할 수 있다.
5. Stackable : 서비스(`Service`)를 수직으로 즉석해서 쌓을 수 있다.


##### 이미지와 컨테이너 (Image and containers)

컨테이너는 이미지를 실행하여 구동된다. 
이미지는 애플리케이션을 실행하기 위해 필요한 모든 것을 포함하는 실행가능한 패키지이다. (code, runtime, library, evironment variables, and configuration files)


