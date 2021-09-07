# 가농바이오 Azure 배포 방법 
> 2021.08.30 (월)

## 1. 배포 환경 구성 
배포를 진행할 서버 환경에 맞게 `az cli`, `kubectl`, `docker`를 설치한다. 

### Azure CLI를 설치
- https://docs.microsoft.com/ko-kr/cli/azure/install-azure-cli

### Kubernetes CLI 설치
Azure CLI를 이용하여 kubernetes cli를 설치한다. 

```shell
az aks install-cli
```

### Docker 설치 
- https://docs.docker.com/get-docker/



## 2. Azure에 배포
제공된 소스에 배포 스크립트(deploy.sh)가 포함되어 있고
`Azure Login > 배포 스크립트 실행` 순서로 Azure에 배포할 수 있음.

### 1) frontend
Front 프로젝트 ROOT 경로(~/ganong-front)에서 아래 명령을 실행합니다.

- 소스 업데이트 
```shell
git pull
```

- Azure 로그인 
```shell
az login
```

- 배포 스크립스 실행 
```shell
./deploy.sh
```

### 2) API & backend 
전달드린 API 및 관리자 소스에도 Azure 배포 스크립트(deploy.sh)가 포함되어 있습니다.
Saleson 프로젝트 ROOT 경로에서 아래 명령을 실행합니다.


- 소스 업데이트 (버전 관리를 하는 경우)
```shell
git pull
```

- Azure 로그인
```shell
az login
```

- 배포 스크립스 실행
```shell
./deploy.sh
```


