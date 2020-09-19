# Azure 환경 구성 (Windows) 

## Azure CLI 설치
https://docs.microsoft.com/ko-kr/cli/azure/install-azure-cli-windows?view=azure-cli-latest&tabs=azure-cli


## Kubernetes CLI 설치 
```
az aks install-cli
```

## Azure 로그인
```
az login
```

브라우저에서 아래 아이디로 로그인. 
```
id: druh@saleson365.onmicrosoft.com
pw: emfn92%@
```

## Kubernetes 클러스터 연결 
```
az aks get-credentials --resource-group DruhResourceGroup --name DruhKube
```

## pod 조회 
``` 
kubectl get pod


nginx-ingress-controller-5cf8b9459f-ctrqr        1/1     Running   0          24d
nginx-ingress-controller-5cf8b9459f-mpb5p        1/1     Running   0          24d
nginx-ingress-default-backend-659598fbc6-bxrpj   1/1     Running   0          24d
saleson-api-deployment-58dbb56f94-vmrt5          1/1     Running   0          44h
saleson-deployment-76bb98d8c9-2rcgn              1/1     Running   0          44h
```

## Log 조회 (tail)
pod 중 saleson-deployment-xxx, saleson-api-deployment-xxx 확인 

```
kubectl logs --tail 500 saleson-api-deployment-58dbb56f94-vmrt5
```

