# Azure Kubernetes 설정
> 2020.02.06  
> 2020.03.12 OpKubeTest 생성  
> 2020.04.16 OpKubeTest Auto Scale 설정   

## Azure Container Registry
- OpRegistry
- opregistry.azurecr.io
- portal.azure.com 에서 생성


## Kubernetes 서비스
- portal.azure.com 에서 클러스터 생성
- 2node
- resourceGroup: OpResourceGroup

## Azure Cli 설치
> https://docs.microsoft.com/ko-kr/cli/azure/install-azure-cli-yum?view=azure-cli-latest
```
sudo rpm --import https://packages.microsoft.com/keys/microsoft.asc
```

```
sudo sh -c 'echo -e "[azure-cli]
name=Azure CLI
baseurl=https://packages.microsoft.com/yumrepos/azure-cli
enabled=1
gpgcheck=1
gpgkey=https://packages.microsoft.com/keys/microsoft.asc" > /etc/yum.repos.d/azure-cli.repo'
```

```
sudo yum install azure-cli
```

```
az login
```




## Kubernetes CLI 설치 (kubectl)
기존에 설치하여 설치는 생략
```
az aks install-cli
```

## kubectl을 사용하여 클러스터에 연결
```
az aks get-credentials --resource-group OpResourceGroup --name OpKubernetes

# 3.12
az aks get-credentials --resource-group OpResourceGroup --name OpKubeTest
```

## 기존 AKS 클러스터에 대 한 ACR 통합 구성
```
az aks update -n OpKubernetes -g OpResourceGroup --attach-acr OpRegistry

# 3.12
az aks update -n OpKubeTest -g OpResourceGroup --attach-acr OpRegistry


```



## Azure File을 이용하여 볼륨 만들기
> https://docs.microsoft.com/ko-kr/azure/aks/azure-files-volume

### 1. 스토리지 계정생성
- portal에서 생성
- 계정: opfile
- 나머지 기본 값

### 2. File Share 만들기
- portal에서 생성
- shareName : saleson-mysql
- account : opfile
- acceount key : HWreidqMPKj67n/wnVCLX9qqrYVL+j1CvhUbGPyjj9jl7c+6HjSrWwUWfENZnv7Ra4Fee3BcivmuX5SFKX5YyA==

### 3. Kubernetes 비밀 만들기
- saleson-mysql-secret

```
kubectl create secret generic azure-mysql-secret --from-literal=azurestorageaccountname=opfile --from-literal=azurestorageaccountkey=HWreidqMPKj67n/wnVCLX9qqrYVL+j1CvhUbGPyjj9jl7c+6HjSrWwUWfENZnv7Ra4Fee3BcivmuX5SFKX5YyA==

kubectl create secret generic azurefile-secret --from-literal=azurestorageaccountname=opfile --from-literal=azurestorageaccountkey=HWreidqMPKj67n/wnVCLX9qqrYVL+j1CvhUbGPyjj9jl7c+6HjSrWwUWfENZnv7Ra4Fee3BcivmuX5SFKX5YyA==

# 3.12
kubectl create secret generic azurefile-secret --from-literal=azurestorageaccountname=opfile --from-literal=azurestorageaccountkey=HWreidqMPKj67n/wnVCLX9qqrYVL+j1CvhUbGPyjj9jl7c+6HjSrWwUWfENZnv7Ra4Fee3BcivmuX5SFKX5YyA==
```

## Azure mysql pv/pvc 만들기
- azuer-mysql-pv.yaml
- azure-mysql-secret 연결 설정.  (secretName, shareName 확인)


## Mysql deployment/pod 생성
- azure-mysql-deplyment.yaml
- pvc 설정

## DnsUtils 설치 후 service name으로 mysql로 연결이 되는 지 확인
> https://kubernetes.io/docs/tasks/administer-cluster/dns-debugging-resolution/


## Mysql pod 접속해 보기
```
kubectl exec -it [mysql pod 이름] bash
```

## Mysql Data 등록
azure-mysql-deployment.yaml 파일에서
mysql-service type을 LoadBalancer로 설정한 후
kubectl get svc 명령으로 mysql-service의 EXTERNAL-IP : 3306으로 접속

```
#3.12
mysqldump --column-statistics=0 -usaleson3 -p -h 192.168.123.15 SALESON3 > saleson3.sql
mysql -usaleson3 -p -h 52.231.106.31 SALESON3 < saleson3.sql
```



## Azure saleson pv/pvc 만들기
- azure-saleseon-pv.yaml
- shareName 수정 (kube-saleson)

- azure-saleson-pv: kube-saleson            | license
- azure-saleson-storage-pv: kube-storage    |upload


## ACR에 saleson3:kube 이미지 push
- docker image build
- docker push opregistry.azurecr.io/saleson/saleson3:kube3

## Saleson 배포
- azure-saleson-deployment.yaml
- azure-saleson-api-deployment.yaml

- 내용 확인 후 실행 (pvc, image 등)


## 고정 IP 서비스
고정IP 생성 > Helm ingress 설치 > azure-saleson-ingress.yaml 실행.


### OpKubeTest 클러스터의 리소스 그룹에 고정IP 만들기
- OpKubeTest 클러스터의 리소스 그룹 이름 조회
```
az aks show --resource-group OpResourceGroup --name OpKubeTest --query nodeResourceGroup -o tsv

MC_OpResourceGroup_OpKubeTest_koreacentral   # OpKubeTest 클러스터의 리소스 그룹 이름
```

- az network 으로 고정 IP 주소 만들기 (resource-group : MC_OpResourceGroup_OpKubeTest_koreacentral)
```
az network public-ip create \
    --resource-group MC_OpResourceGroup_OpKubeTest_koreacentral \
    --name OpKubeIP \
    --sku Standard \
    --allocation-method static \
    --query publicIp.ipAddress -o tsv
    
52.231.106.21   
```

### saleson-ingress 설치 (고정 IP 포함)
```
helm install saleson-ingress stable/nginx-ingress \
    --namespace default \
    --set controller.replicaCount=1 \
    --set controller.nodeSelector."beta\.kubernetes\.io/os"=linux \
    --set defaultBackend.nodeSelector."beta\.kubernetes\.io/os"=linux \
    --set controller.service.loadBalancerIP="52.231.106.21"
```

### saleson-ssl-secret 만들기
```
kubectl create secret tls saleson-ssl-secret \
    --namespace default \
    --key certs/ssl.key \
    --cert certs/ssl.crt
```

### saleson-ingress 구성파일 실행
- azure-saleson-ingress.yaml


## saleson pv
- /saleson3 , /saleson-cdn 을 동일하게 azure-saleson-pv에 마운트 하니 제대로 동작하지 않음.
- /saleson-cdn 파일 공유를 새로 만들고 azure-saleson-cdn-pv 를 따로 마운트함

## mysql
- max_allowed_packet = 2048(기본값) 오류
- deployment 에서 옵션 추가
- --max_allowed_packet=32505856
- --max_connections=2048



## Kubernetes Dashboard in Azure
> https://docs.microsoft.com/ko-kr/azure/aks/kubernetes-dashboard

```
az aks browse --resource-group OpResourceGroup --name OpKubernetes
az aks browse --resource-group OpResourceGroup --name OpKubernetes2
```
http://127.0.0.1:8001/ 접속시 dashboard 확인 (권한 오류 상태)


클러스터 롤 설정 후 재실행
```
kubectl create clusterrolebinding kubernetes-dashboard --clusterrole=cluster-admin --serviceaccount=kube-system:kubernetes-dashboard

az aks browse --resource-group OpResourceGroup --name OpKubernetes

```
이후

```
az aks browse --resource-group OpResourceGroup --name OpKubernetes
```

## 서비스 외부 노출 (고정IP)  -- 테스트용. 최종으로 ingress를 사용하자 !
> https://docs.microsoft.com/ko-kr/azure/aks/static-ip
- 고정IP 주소 만들기 az network public-ip create
```
az network public-ip create \
    --resource-group OpResourceGroup \      # OpResourceGroup 대신 MC_OpResourceGroup_OpKubernetes_koreacentral 으로해야함. 
    --name OpKubernetesIP2 \
    --sku Standard \
    --allocation-method static
```
!!!!!! resource-group을  OpKubernetes 클러스터의 리소스 그룹 으로 해야함. !!!!!!!!!


## 고정 IP 주소를 사용하여 서비스 만들기
- 노출시킬 서비스 생성시
- type : LoadBalancer
- loadBalancerIP: 40.121.183.52



## AKS에 Ingress Controller (수신 컨트롤러) 만들기
> https://docs.microsoft.com/ko-kr/azure/aks/ingress-static-ip

### 고정 IP 할달


### OpKubernetes 클러스터의 리소스 그룹에 고정IP 만들기
- OpKubernetes 클러스터의 리소스 그룹 이름 조회
```
az aks show --resource-group OpResourceGroup --name OpKubernetes --query nodeResourceGroup -o tsv

MC_OpResourceGroup_OpKubernetes_koreacentral   # OpKubernetes 클러스터의 리소스 그룹 이름
```

- az network 으로 고정 IP 주소 만들기 (resource-group : MC_OpResourceGroup_OpKubernetes_koreacentral)
```
az network public-ip create \
    --resource-group MC_OpResourceGroup_OpKubernetes_koreacentral \
    --name OpKubeIP \
    --sku Standard \
    --allocation-method static \
    --query publicIp.ipAddress -o tsv
    
40.82.154.152    
```


```
az network public-ip create \
    --resource-group MC_OpResourceGroup_OpKubernetes2_koreacentral \
    --name OpKubeSalesonIP \
    --sku Standard \
    --allocation-method static \
    --query publicIp.ipAddress -o tsv
    
    
52.141.26.38  
```



## Pod 리소스 설정 및 제한
> https://docs.microsoft.com/ko-kr/azure/aks/developer-best-practices-resource-management

CPU 요청 또는 한도를 정의하는 경우 값은 CPU 단위로 측정됩니다.
1.0 CPU는 노드에 있는 하나의 기본 가상 CPU 코어와 동일합니다.
GPU에도 동일한 측정이 사용됩니다.
Millicores에서 측정 된 분수를 정의할 수 있습니다. 예를 들어 100m 는 기본 vcpu 코어의 0.1 입니다.
단일 NGINX Pod에 대한 다음 기본 예제에서 Pod는 100m CPU 시간 및 128Mi 메모리를 요청합니다. Pod의 리소스 한도는 250m CPU 및 256Mi 메모리로 설정됩니다.

```yaml
kind: Pod
apiVersion: v1
metadata:
  name: mypod
spec:
  containers:
  - name: mypod
    image: nginx:1.15.5
    resources:
      requests:
        cpu: 200m
        memory: 256Mi
      limits:
        cpu: 500m
        memory: 512Mi

```

## Pod 크기 조절
> https://docs.microsoft.com/ko-kr/azure/aks/tutorial-kubernetes-scale

```
kubectl scale --replicas=5 deployment/azure-vote-front
```








### Helm을 이용하여 nginx-ingress 차트를 배포

#### Helm 상태확인
> Helm 기본 설정 및 사용법 : https://docs.microsoft.com/ko-kr/azure/aks/kubernetes-helm
버전 확인
```
helm version 
```

repository추가
```
helm repo add stable https://kubernetes-charts.storage.googleapis.com/

```


Create a namespace for your ingress resources
```
kubectl create namespace ingress-basic
```
Use Helm to deploy an NGINX ingress controller
```
helm install nginx-ingress stable/nginx-ingress \
    --namespace ingress-basic \
    --set controller.replicaCount=2 \
    --set controller.service.externalTrafficPolicy=Local \
    --set controller.nodeSelector."beta\.kubernetes\.io/os"=linux \
    --set defaultBackend.nodeSelector."beta\.kubernetes\.io/os"=linux \
    --set controller.service.loadBalancerIP="40.82.154.152"
```
적용
```
helm install saleson-ingress stable/nginx-ingress \
    --namespace default \
    --set controller.replicaCount=1 \
    --set controller.nodeSelector."beta\.kubernetes\.io/os"=linux \
    --set defaultBackend.nodeSelector."beta\.kubernetes\.io/os"=linux \
    --set controller.service.loadBalancerIP="40.82.154.152"
```
삭제
```
helm delete saleson-ingress
```



조회
```
kubectl get service -l app=nginx-ingress --namespace ingress-basic
```

### Ingress 생성 (수신 경로 만들기)



// 52.231.112.42
// 40.82.154.152


### Nginx INGRESS 다시 시도 - 2020.02.17
> https://docs.microsoft.com/ko-kr/azure/aks/ingress-basic

Nginx Ingress controller 설치 (name space는 default)

```
helm install nginx-ingress stable/nginx-ingress \
    --set controller.replicaCount=2 \
    --set controller.service.externalTrafficPolicy=Local \
    --set controller.nodeSelector."beta\.kubernetes\.io/os"=linux \
    --set defaultBackend.nodeSelector."beta\.kubernetes\.io/os"=linux
```





## Azure 정적 웹사이트
> https://docs.microsoft.com/ko-kr/azure/storage/blobs/storage-custom-domain-name?tabs=azure-portal
-  Azure CDN와 정적 웹 사이트 통합
- Azure CDN에 https 적용


### Azure CDN  생성
- endpoint

### 사용자 지정 도메인 생성
- 사용하려고 하는 도메인의 DNS 설정이 되어 있어야 등록이 됨
```
azure-front.onlinepowers.com    CNAME   saleson3-frontend-test.azureedge.net
```

- 사용자 지정 도메인 정보에서 구성 > 사용자 지정 도메인 HTTPS : [v]설정, [ ] 헤제
- 인증서 관리유형 : [v] CDN 관리됨, [ ] 나만의 인증서 사용


```
kubectl exec -ti dnsutils -- nslookup mysql-service
```

## 송신 고정 IP 사용
https://docs.microsoft.com/ko-kr/azure/aks/egress

curl -s checkip.dyndns.org


## Auto Scale
> https://docs.microsoft.com/ko-kr/azure/aks/cluster-autoscaler#about-the-cluster-autoscaler 
> https://docs.microsoft.com/bs-cyrl-ba/azure/aks/cluster-autoscaler 
> https://docs.microsoft.com/ko-kr/azure/aks/tutorial-kubernetes-scale

### portal 에서 
- 노드 풀 > 목록 > ...  ==> 크기 조정
- 자동크기조정 : 2 ~ 5 

### HPA (Horizontal Pod Autoscaler) 설정 
azure-saleson-api-hpa.yaml

```yaml
apiVersion: autoscaling/v1
kind: HorizontalPodAutoscaler
metadata:
  name: saleson-api-hpa
spec:
  maxReplicas: 4 # define max replica count
  minReplicas: 1  # define min replica count
  scaleTargetRef:
    apiVersion: apps/v1
    kind: Deployment
    name: saleson-api-deployment
  targetCPUUtilizationPercentage: 50 # target CPU utilization

```

### 테스트 
부하 발생 시 
- Pod 증가 (OK)
- CPU 사용에 따라 node 생성 (OK)

부하 없음. 
- 몇 분후 pod 감소
- node 감소 : pod 보다는 시간이 좀 더 걸림. 


### AKS 모니터링을 중단 하고 싶으시면 아래 링크를 참조 하여 중단 할 수 있습니다.
> https://docs.microsoft.com/ko-kr/azure/azure-monitor/insights/container-insights-optout

```
az aks disable-addons -a monitoring -n OpUmsKube -g OpUmsResourceGroup

az aks disable-addons -a monitoring -n OpKubeTest -g OpResourceGroup
```



### 고정IP로 서비스 만들기 
- OpUmsKube 클러스터의 리소스 그룹 이름 조회
```
az aks show --resource-group OpUmsResourceGroup --name OpUmsKube --query nodeResourceGroup -o tsv

MC_OpUmsResourceGroup_OpUmsKube_koreacentral   # OpUmsKube 클러스터의 리소스 그룹 이름
```

- az network 으로 고정 IP 주소 만들기 (resource-group : MC_OpUmsResourceGroup_OpUmsKube_koreacentral)
```
az network public-ip create \
    --resource-group MC_OpUmsResourceGroup_OpUmsKube_koreacentral \
    --name OpUmsApiIP \
    --sku Standard \
    --allocation-method static \
    --query publicIp.ipAddress -o tsv
    
20.39.186.24    
```

### LoadBalancerIp 할당 
고정 공용 IP 주소를 사용하여 서비스를 만들려면 고정 공용 IP 주소의 값과 loadBalancerIP 속성을 YAML 매니페스트에 추가합니다. 

```
apiVersion: v1
kind: Service
metadata:
  name: azure-egress
spec:
  loadBalancerIP: 40.121.183.52
  type: LoadBalancer
  ports:
  - port: 80
```



az aks get-credentials --resource-group OpUmsResourceGroup --name OpUmsKube