# Azure Kubernetes Service (AKS)

## 실행 파일 구성 
- Azure kubernetes 자습서 기준으로 kubernetes 구성파일(yaml) 
- Node는 Azure에서 관리 (nodeSelector가 ms로 되어 있음) 



## Azure Kubernetes 클러스터 구성 
### 1. Kubernetes 클러스터 만들기 
```
az aks create \
    --resource-group FreeTiar \
    --name saleson-kubernetes \
    --node-count 2 \
    --generate-ssh-keys \
    --attach-acr ddocker
```

```
az aks create \
    --resource-group OpTest \
    --name OpKubernetes \
    --node-count 2 \
    --generate-ssh-keys \
    --attach-acr OpDocker
```


### 2. Kubernetes CLI 설치 (kubectl)
```
az aks install-cli
```    

### 3. kubectl을 사용하여 클러스터에 연결
Kubernetes 클러스터에 연결하도록 kubectl을 구성하려면 az aks get-credentials 명령을 사용합니다. 
다음 예제에서는 FreeTiar (리소스그룹)에서 AKS 클러스터 이름 saleson-kubernetes에 대한 자격 증명을 가져옵니다.
```
az aks get-credentials --resource-group FreeTiar --name saleson-kubernetes
```

```
az aks get-credentials --resource-group OpTest --name OpKubernetes
```


클러스터에 대한 연결을 확인하려면 kubectl get nodes 명령을 실행합니다.    
```
$ kubectl get nodes                                                           ✹master
NAME                                STATUS   ROLES   AGE   VERSION
aks-nodepool1-10285484-vmss000000   Ready    agent   70m   v1.14.8
aks-nodepool1-10285484-vmss000001   Ready    agent   69m   v1.14.8
```


## AKS(Azure Kubernetes Service)에서 애플리케이션 실행
### 1. 구성파일 (Manifast) ACR 이미지 정보로 변경 
``` 
containers:
- name: saleson3+++*9
  image: ddocker.azurecr.io/onlinepowers/saleson:3.9.0
  
...
  
containers:
- name: saleson-frontend
  image: microsoft/azure-vote-front:3.8.4
```  

### 2. 애플리케이션 배포 
애플리케이션을 배포하려면 kubectl apply 명령을 사용합니다. 
이 명령은 매니페스트 파일을 구문 분석하고 정의된 Kubernetes 개체를 만듭니다. 
다음 예제처럼 샘플 매니페스트 파일을 지정합니다.

```
$ kubectl apply -f saleson-kubernetes.yaml

deployment.apps/saleson3 created
service/saleson3 created
deployment.apps/saleson3-frontend created
service/saleson3-frontend created
```

### 3. 애플리케이션 테스트 

애플리케이션이 실행되면 애플리케이션 프런트 엔드를 인터넷에 공개하는 Kubernetes 서비스가 만들어집니다. 
이 프로세스를 완료하는 데 몇 분이 걸릴 수 있습니다.  
진행 상태를 모니터링하려면 --watch 인수와 함께 kubectl get service 명령을 사용합니다. 

``` 
$ kubectl get service saleson3-frontend --watch

NAME                TYPE           CLUSTER-IP    EXTERNAL-IP     PORT(S)        AGE
saleson3-frontend   LoadBalancer   10.0.24.178   40.80.233.123   80:30583/TCP   2m42s
``` 

Pod 상태 확인 
``` 
$ kubectl get pods

NAME                                 READY   STATUS             RESTARTS   AGE
saleson3-bd849659-tznkd              0/1     CrashLoopBackOff   11         34m
saleson3-df45c5657-7mzl8             0/1     ImagePullBackOff   0          15m
saleson3-frontend-69f8b94855-wg9x7   1/1     Running            0          31m
``` 

saleson3-bd849659-tznkd CrashLoopBackOff 상태임.
제대로 배포가 되지 않음. 
 
### 4. 문제해결 
> https://kubernetes.io/docs/tasks/debug-application-cluster/debug-application/#debugging-pods

#### Debugging pod 
kubectl describe pods ${POD_NAME}

```
$ kubectl describe pods saleson3-bd849659-tznkd
```

#### 컨테이너 로그 확인 

kubectl logs ${POD_NAME} ${CONTAINER_NAME}로 컨테이너 로그를 확인한다. 
``` 
``` 

> Container 볼륨 문제로 확인됨.  
> Azure File Share 로 마운트 하는 방법을 찾아보자   
> https://docs.microsoft.com/ko-kr/azure/aks/azure-files-volume
$ kubectl logs saleson3-bd849659-tznkd saleson3


## AKS(Azure Kubernetes Service)에서 Azure Files 공유를 사용하여 수동으로 볼륨을 만들고 사용
### 1. Azure File Share 만들기 
파일 공유 스토리지 생성 (saleson3으로 이미 생성했었음. )

- 스토리지 계정 : saleson3
- KEY : k5HDb60LwAvk2FbOn+fYf7IB+Ih+se+vdrpFGoxjKQnO6CL50kESsEGMcyGfjR/x50Z0H+RRicwQcwsONKb33g==

### 2. Kubernetes Secret 만들기
이전 단계에서 작성된 파일 공유에 액세스하려면 Kubernetes에 자격 증명이 필요합니다. 
이러한 자격 증명은 Kubernetes pod를 만들 때 참조 되는 Kubernetes 암호에 저장 됩니다.
kubectl create secret 명령을 사용하여 비밀을 작성하세요. 
다음 예제는 saleson-kubernetes-secret이라는 공유를 만들고 이전 단계에서 azurestorageaccountname 및 azurestorageaccountkey를 생성합니다. 
기존 Azure Storage 계정을 사용하려면 계정 이름과 키를 입력합니다.

```
kubectl create secret generic saleson-kubernetes-secret \
        --from-literal=azurestorageaccountname=saleson3 \
        --from-literal=azurestorageaccountkey=k5HDb60LwAvk2FbOn+fYf7IB+Ih+se+vdrpFGoxjKQnO6CL50kESsEGMcyGfjR/x50Z0H+RRicwQcwsONKb33g==
```

```
kubectl create secret generic op-kubernetes-secret \
        --from-literal=azurestorageaccountname=opfiles \
        --from-literal=azurestorageaccountkey=CZ6N8LnH8imnv6wB7+Lyj7Y7XI3w6bfegu3DUpbS4hMixQRt9Zdqp9r6VqHef63xgR5ok1f7423sQhIfhOclfw==
```

> 생성된 Secret은 Azure Portal의 어디에서 확인할 수 있는가? (saleson-kubernetes-secret)




kubectl delete -f saleson-kubernetes2.yaml
kubectl apply -f saleson-kubernetes2.yaml

kubectl get nodes
kubectl get all
kubectl get pods

kubectl describe pods


kubectl logs saleson-pod saleson3
kubectl logs saleson-pod saleson3-frontend



Volume Mount 하면서 Deployment로 쿠버네티스 구성하기 