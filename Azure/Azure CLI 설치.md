# Azure CLI 설치 
> 2021.08.30  
> `cli`, `az`, `kubectl`


## Linux에 설치 
> https://docs.microsoft.com/ko-kr/cli/azure/install-azure-cli-linux?view=azure-cli-latest&pivots=dnf

Microsoft 리포지토리 키를 가져옵니다.
```shell
sudo rpm --import https://packages.microsoft.com/keys/microsoft.asc
```


로컬 azure-cli 리포지토리 정보를 만듭니다.


```shell
echo -e "[azure-cli]
name=Azure CLI
baseurl=https://packages.microsoft.com/yumrepos/azure-cli
enabled=1
gpgcheck=1
gpgkey=https://packages.microsoft.com/keys/microsoft.asc" | sudo tee /etc/yum.repos.d/azure-cli.repo
```

dnf(yum) install 명령을 사용하여 설치됩니다.
```shell
sudo dnf install azure-cli
```


## Windows에 설치 
> https://docs.microsoft.com/ko-kr/cli/azure/install-azure-cli-windows?view=azure-cli-latest&tabs=azure-cli



## Kubernetes CLI 설치 (kubectl)
```shell
az aks install-cli
```