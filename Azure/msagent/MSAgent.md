# MSAgent 
> 2021-04-30 
> 관련 정보가 없어 새로 작성함. 


## Azure 정보 
- ResourceGroup: 



## 배포 
- 수동 배포 


## 스토리지 계정 
- 계정: opumsstorage
- 리소스그룹: OpUmsResourceGroup
- 구독: 온라인파워스 (459a1df5-548a-45ce-b665-b1c479d786e9)


### Kubernetes Secret 만들기
- msagent-storage-secret
- azurestorageaccountkey는 portal > 스토리지 계정 > 보안+네트워크 > 엑세스 키에서 key1
```
kubectl create secret generic msagent-storage-secret --from-literal=azurestorageaccountname=opumsstorage --from-literal=azurestorageaccountkey=0JdAiHRbUKZAm4F2X6QWUpQ6qIdPafLkmxQ/j7pPl/otSsPQvvZp4VkXYJJ1AaN9lvPvBIC7Jv3GUNRwFnPq7Q==
```

### StorageClass, PV, PVC 생성
```
kubectl apply -f kubes/msagent-pv.yaml
```



### 성능 모니터링(Log Analytics)
ASK는 Azure Monitor 를 이용한 Container Insights 를 수집 하여 AKS 성능 모니터링을 진행함. (기본설정)
AKS 모니터링을 중단해야 모니터링 비용이 발생하지 않음.

> 모니터링 중단 방법 : https://docs.microsoft.com/ko-kr/azure/azure-monitor/insights/container-insights-optout

#### 모니터링 중단 방법
`az aks disable-addons` 명령을 사용하여 컨테이너 인사이트를 사용하지 않도록 설정합니다.
이 명령은 클러스터 노드에서 에이전트를 제거하지만, 이미 수집되어 Azure Monitor 리소스에 저장된 솔루션 또는 데이터는 제거하지 않습니다.

```shell
az aks disable-addons -a monitoring -n OpUmsKube -g OpUmsResourceGroup

```
