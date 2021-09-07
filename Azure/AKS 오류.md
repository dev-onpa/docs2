# Azure Kubernetes Service (AKS) 오류 
> 2021.05.25 


## 1. 얼마전 부터 콘솔에서 AKS Cluster에 연결하기 위해 아래 명령을 실행한 경우 ResourceGroup을 찾을 수 없다는 메시지가 확인되고 있습니다. 원인이 무엇인지 확인부탁드립니다.
```shell
az aks get-credentials --resource-group OpUmsResourceGroup --name OpUmsKube
Resource group 'OpUmsResourceGroup' could not be found.
```

### 답변 
> az account cli 참고 문서:   
> https://docs.microsoft.com/ko-kr/cli/azure/manage-azure-subscriptions-azure-cli​

오류 내용은 로그인한 구독에서 리소스 그룹을 못 찾아 발생 되는 것으로 보여집니다.
로그인을 하셨더라도 활성 구독으로 설정 안 되어 있으면 보내주신 오류가 발생 될 수 있습니다.

```shell
az account list --output table
```

아래와 같이 IsDefault 구독 확인 후 활성 구독을 설정함. 

```shell
az account set --subscription "구독 ID"
```


## 2. POD에 앱 배포시 컨테이너 레지스트리에서 이미지를 가져오지 못하고 있습니다.ErrImagePull 오류가 발생하여 앱이 배포되지 않습니다.
```shell
Events:
  Type     Reason     Age               From                                        Message
  ----     ------     ----              ----                                        -------
  Normal   Scheduled  16s               default-scheduler                           Successfully assigned default/msagent-deployment-bd84c9876-gxwj7 to aks-agentpool-37729743-vmss000000
  Normal   BackOff    14s               kubelet, aks-agentpool-37729743-vmss000000  Back-off pulling image "opregistry.azurecr.io/saleson/msagent:20210518"
  Warning  Failed     14s               kubelet, aks-agentpool-37729743-vmss000000  Error: ImagePullBackOff
  Normal   Pulling    2s (x2 over 15s)  kubelet, aks-agentpool-37729743-vmss000000  Pulling image "opregistry.azurecr.io/saleson/msagent:20210518"
  Warning  Failed     2s (x2 over 14s)  kubelet, aks-agentpool-37729743-vmss000000  Failed to pull image "opregistry.azurecr.io/saleson/msagent:20210518": [rpc error: code = Unknown desc = Error response from daemon: Get https://opregistry.azurecr.io/v2/saleson/msagent/manifests/20210518: unauthorized: Invalid clientid or client secret., rpc error: code = Unknown desc = Error response from daemon: Get https://opregistry.azurecr.io/v2/saleson/msagent/manifests/20210518: unauthorized: authentication required, visit https://aka.ms/acr/authorization for more information.]
  Warning  Failed     2s (x2 over 14s)  kubelet, aks-agentpool-37729743-vmss000000  Error: ErrImagePull
```


### 답변 
> AKS의 SP 업데이트와 관련한 상세설명은 다음 문서의 내용을 참고 부탁 드립니다.   
> https://docs.microsoft.com/en-us/azure/aks/update-credentials

OpUmsKube  클러스터의 백엔드쪽 로그를 확인해보면 5월 13일 경부터 클러스터가 플랫폼 리소스 배포를 위해 인증으로 사용하는 `Service Principal`이 만료된 것으로 보입니다.
Service Principal을 사용하는 AKS의 경우 SP가 기본 1년 후에 만료가 되게 되는데 만료된 이후부터는 클러스터 작동이나 컨테이너 레지스트리 인증이 실패하게 됩니다.

1) SP ID를 확인합니다.
```shell
az aks show --resource-group OpUmsResourceGroup --name OpUmsKube --query "servicePrincipalProfile.clientId" --output tsv

5c931fc9-ecd4-4fee-a14b-c82360411f3c
```


2) 해당 SP가 만료되었는 지 여부를 확인합니다.
```shell
az ad sp credential list --id <SP ID>
```
```shell
az ad sp credential list --id 5c931fc9-ecd4-4fee-a14b-c82360411f3c

[]
```



3) AKS의 노드 VMSS에 Run-Command 기능을 통해 SP secret을 받아옵니다.
> VMSS : 가상 머신 확장 집합(Virtual Machine Scale Set)
> Kube resource group에 있음. (MC_ 로 시작되는 리소스 그룹에서 vmss 확인이 가능함. )

```shell
az vmss run-command invoke --command-id RunShellScript --resource-group <nodeRG> --name <vmssName> --instance-id <0,1,2...> --scripts "hostname && date && cat /etc/kubernetes/azure.json" | grep aadClientSecret
```

```shell
az vmss run-command invoke --command-id RunShellScript \
--resource-group MC_OpUmsResourceGroup_OpUmsKube_koreacentral \
--name aks-agentpool-37729743-vmss \
--instance-id 0 \
--scripts "hostname && date && cat /etc/kubernetes/azure.json" | grep aadClientSecret
 
 - running..
... 
\"aadClientId\": \"5c931fc9-ecd4-4fee-a14b-c82360411f3c\",\n    
\"aadClientSecret\": \"4d32f0ec-039d-438e-815f-cd33077a2651\",\n
...
 
```


4) SP를 reset합니다.
```shell
az ad sp credential reset -n <aadClientId> -p <aadClientSecret> --years <NunmberOfYears>


az ad sp credential reset -n 5c931fc9-ecd4-4fee-a14b-c82360411f3c -p 4d32f0ec-039d-438e-815f-cd33077a2651 --years 10
```


5) SP 조회 
```shell
az ad sp credential list --id 5c931fc9-ecd4-4fee-a14b-c82360411f3c

[
  {
    "additionalProperties": null,
    "customKeyIdentifier": null,
    "endDate": "2031-05-25T01:44:19.436945+00:00",
    "keyId": "ae095064-16d9-4b56-907f-dd67fb6b0de8",
    "startDate": "2021-05-25T01:44:19.436945+00:00",
    "value": null
  }
]

```

> 위 내용 적용 후 container registry에서 정상적으로 이미지를 가져옴. (2021-05-26)



## 다른 케이스 (기타)
4umall, cuchen 의 경우 SP_ID 조회 시 msi로 출력됨. 
msi는 뭘까?

```shell
az aks show --resource-group 4umallResourceGroup --name 4umallKube --query "servicePrincipalProfile.clientId" --output tsv

msi
```

```shell
az aks show --resource-group RG-CuchenMall --name CuchenMall \
--query servicePrincipalProfile.clientId -o tsv

msi
```


## 3. AKS Secret (tls) 생성 오류 문의
AKS에서 https 적용을 위해 아래와 같이 secret을 생성하는 명령을 실행하였습니다.

```shell
kubectl create secret tls ssl-secret \  
--namespace default \
--key ssl.pem \
--cert ssl.key

error: failed to load key pair tls: failed to find certificate PEM data in certificate input, but did find a private key; PEM inputs may have been switched
```


--key , --cert 항목의 값이 바뀌었음. 

## 4. Kubernetes Ingress Controller Fake Certificate
ingress에 인증서 (tls secret) 적용 후 브라우저 인증서 정보에 `Kubernetes Ingress Controller Fake Certificate`라고 뜸. 

- 1. spec.tls.secretName이 생성한 secretName과 일치하는가? 
- 2. rules 에 host항목이 설정되어 있는가?
- 3. 같은 도메인으로 등록한 다른 tls secret이 있는가?

    

