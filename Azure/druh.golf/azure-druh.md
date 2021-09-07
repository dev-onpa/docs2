# Druh Style
> 2020.06.09

## 구독생성 
- 6/3 구독이 생성되었으나 ResourceGroup 생성 시 드루스타일 구독이 생성되지 않음. 
- 6/5 리소스그룹생성이 가능하여 생성 : DruhResourceGroup

## AKS 생성 
- portal에서 
- DS2 V2
- node 2개
- Azure Monitor 해제 
```
az aks disable-addons -a monitoring -n DruhKube -g DruhResourceGroup
```


## 스토리지 계정생성
- portal에서 생성
- 계정: druhfile
- 나머지 기본 값
> 엑세스키 : - acceount key : KHQlTzpqXCO7aj57TogkDu5S25qG7v9Q4OFybfF0YK7xPtpw7/qxjBTzz7Hz6t2d0mCht57QTet4LCByvc7CmA==


### File Share 만들기
- druh-saleson : 라이선스 파일 (1GB)
- druh-storage : 첨부파일 경로 (5GB)

druh-saleson/license/라이선스파일 업로드 
druh-saleson/upload/


 
## Container Registry (컨테이너 레지스트리)
- 레지스트리 이름:  DruhRegistry
- 한국 중부 / 표준 

az aks get-credentials --resource-group DruhResourceGroup --name DruhKube


### AKS 클러스터에 대한 ACR 통합 구성
```
az aks update -n DruhKube -g DruhResourceGroup --attach-acr DruhRegistry
```

### Docker Image 생성 
- saleson build


- saleson-api
```
cd saleson-api
docker build -t druhregistry.azurecr.io/saleson/saleson-druh-api:1.0.0 .
docker push druhregistry.azurecr.io/saleson/saleson-druh-api:1.0.0
```

> docker push 시 unauthorized: authentication required 오류 발생 시 acr 인증 후 다시 push
> az acr login --name druhregistry

- saleson-web
```
cd ../saleson-web
docker build -t druhregistry.azurecr.io/saleson/saleson-druh-web:1.0.0 .
docker push druhregistry.azurecr.io/saleson/saleson-druh-web:1.0.0
```


## 스토리지(druhfile) 연동 
### Kubernetes Secret 만들기
- druhfile-secret
```
kubectl create secret generic druhfile-secret --from-literal=azurestorageaccountname=druhfile --from-literal=azurestorageaccountkey=KHQlTzpqXCO7aj57TogkDu5S25qG7v9Q4OFybfF0YK7xPtpw7/qxjBTzz7Hz6t2d0mCht57QTet4LCByvc7CmA==
```

### StorageClass, PV, PVC 생성 
kubernetes persistentVolume을 생성하고 스토리지 계정과 연결.
```
kubectl apply -f saleson-kubernetes/azure-saleson-pv.yaml
```

### pod / deployment 생성 

saleson-*-deployment.yaml 파일을 수정한 후 생성


```
kubectl create -f azure-saleson-api-deployment.yaml
kubectl create -f azure-saleson-deployment.yaml
```


### DurhKube 클러스터의 리소스 그룹에 고정IP 만들기
- DurhKube 클러스터의 리소스 그룹 이름 조회
```
az aks show --resource-group DruhResourceGroup --name DruhKube --query nodeResourceGroup -o tsv

MC_DruhResourceGroup_DruhKube_koreacentral  # DruhKube 클러스터의 리소스 그룹 이름
```

#### INGRESS 용 IP
- az network 으로 고정 IP 주소 만들기 (resource-group : MC_DruhResourceGroup_DruhKube_koreacentral)
```
az network public-ip create \
    --resource-group MC_DruhResourceGroup_DruhKube_koreacentral \
    --name DruhpKubeIngressIP \
    --sku Standard \
    --allocation-method static \
    --query publicIp.ipAddress -o tsv
    
20.39.186.94    
```


## Nginx Ingress Controller 설치 (고정 IP)
> https://docs.microsoft.com/ko-kr/azure/aks/ingress-basic
helm이 이미 설치되어 있어야 함.
namespace는 지정하지 않았음.

1. Add the official stable repository
```
helm repo add ingress-nginx https://kubernetes.github.io/ingress-nginx
```

2. nginx-ingress 설치
   접속한 Client ip를 확인하기 위해서 `--set controller.service.externalTrafficPolicy=Local` 설정을 추가한다.
   `X-Forward-For`를 통해 IP를 확인할 수 있다.


```
helm install nginx-ingress stable/nginx-ingress \
    --set controller.replicaCount=2 \
    --set controller.service.externalTrafficPolicy=Local \
    --set controller.nodeSelector."beta\.kubernetes\.io/os"=linux \
    --set defaultBackend.nodeSelector."beta\.kubernetes\.io/os"=linux \
    --set controller.service.loadBalancerIP="20.39.186.94"
```

3. helm 설치 목록
```shell
$ helm list --namespace default
```

4. nginx-ingress 삭제
```shell
helm uninstall nginx-ingress --namespace default
```


### ingress resource 등록

#### HTTP Ingress 
azure-saleson-ingress-http.yaml 파일을 수정한 후 Ingress 생성
```
kubectl create -f azure-saleson-ingress-http.yaml 
```

#### HTTPs Ingress 
saleson-api-ssl-secret 만들기
```
kubectl create secret tls saleson-api-ssl-secret \
    --namespace default \
    --key certs/20200619-022314-api_druh_golf/api_druh_golf_SHA256WITHRSA.key \
    --cert certs/20200619-022314-api_druh_golf/api_druh_golf.crt
```

2021.04.13 채인인증서를 포함하여 적용 
```
kubectl create secret tls saleson-api-ssl-secret-fc \
    --namespace default \
    --key certs/20200619-022314-api_druh_golf/api_druh_golf_SHA256WITHRSA.key \
    --cert certs/20200619-022314-api_druh_golf/api_druh_golf_fullchain.crt
```


saleson-web-ssl-secret 만들기
```
kubectl create secret tls saleson-web-ssl-secret \
    --namespace default \
    --key certs/20200619-484627-bo_druh_golf/bo_druh_golf_SHA256WITHRSA.key \
    --cert certs/20200619-484627-bo_druh_golf/bo_druh_golf.crt
```



kubectl create secret tls saleson-web-ssl-secret-fc \
    --namespace default \
    --key certs/20200619-484627-bo_druh_golf/bo_druh_golf_SHA256WITHRSA.key \
    --cert certs/20200619-484627-bo_druh_golf/bo_druh_golf_fullchain.crt
    
    

azure-saleson-ingress.yaml 파일을 수정한 후 Ingress 생성
```
kubectl create -f azure-saleson-ingress.yaml
```

#### Nginx Ingress SSL 적용
```
kubectl create secret tls ${CERT_NAME} --key ${KEY_FILE} --cert ${CERT_FILE}
```

```
kubectl create secret tls saleson-ssl-secret \
        --key /Users/dbclose/saleson/3.0/workspace/saleson/saleson-kubernetes/certs/ssl.key \
        --cert /Users/dbclose/saleson/3.0/workspace/saleson/saleson-kubernetes/certs/ssl.crt
```
azure-saleson-ingress.yaml 에 spec > tls 항목 추가


### EGRESS용 IP (송신용)
고정 IP 생성 
```
az network public-ip create \
    --resource-group MC_DruhResourceGroup_DruhKube_koreacentral \
    --name DruhKubeEgressIP \
    --sku Standard \
    --allocation-method static \
    --query publicIp.ipAddress -o tsv
    
20.39.186.233    
```
부하 분산 장치(mc_druhresourcegroup_druhkube_koreacentral) > 프런트 엔드 IP 구성 메뉴에서 
고정IP로 할당되지 않은 IP 선택 (ip name이 랜덤 코드로 된 IP)
항목 중 공용IP 주소를 DruhKubeEgressIp를 선택함 ..
c
kubectl exec -it pod/sdfasdfasdf /bin/bash로 접속하여 curl로 IP 확인  

> IP 확인 (exec /bin/bash)
> curl -s checkip.dyndns.org 


alpine linux container 접속 
/bin/asc
```
kubectl exec -it pod/saleson-api-deployment-75988d4d7d-27fcg /bin/asc
```



#### 도메인 연결
service/nginx-ingress-controller의 EXTERNAL-IP를 연결하고자 하는 도메인에 A레코드로 추가한다.

```
NAME                                    TYPE           CLUSTER-IP     EXTERNAL-IP     PORT(S)                      AGE
service/kubernetes                      ClusterIP      10.0.0.1       <none>          443/TCP                      21d
service/nginx-ingress-controller        LoadBalancer   10.0.61.156    20.39.186.94   80:30052/TCP,443:32668/TCP   15m
```

호스트로 추가하는 경우  아래와 같이 설정.
```
vi /etc/hosts 

20.39.186.94    bo.druhstyle.com
20.39.186.94    api.druhstyle.com
```






## Saleson Frontend (Azure 정적 웹사이트)
> https://docs.microsoft.com/ko-kr/azure/storage/blobs/storage-custom-domain-name?tabs=azure-portal

- 스토리지 > 정적 웹 사이트 : 정적 웹 사이트 => 사용 (Blob 스토리지를 사용함)
- 스토리지 > 엑세스 키 확인 

### Filezilla Pro에서 Azure Storage에 접속 가능 
#### 파일질라 Pro 다운로드 및 설치
- FileZilla Pro Key: 6V26-JC6Y-8ASJ-X84V-VWQR 

#### 파일질라 접속 설정 
파일질라로 접속하여 이미지파일 및 html(vue)파일을 업로드 한다.

* Frontend - Blob Storage
- 접속 URL: https://druhfile.z12.web.core.windows.net/ 
- 프로토콜: Microsoft Azure Blob Storage Service
- host: blob.core.windows.net 
- 스트리지계정: druhfile
- 접근키 : KHQlTzpqXCO7aj57TogkDu5S25qG7v9Q4OFybfF0YK7xPtpw7/qxjBTzz7Hz6t2d0mCht57QTet4LCByvc7CmA==

* Backend - File Storage 
- 프로토콜: Microsoft Azure File Storage Service
- host: file.core.windows.net
- 스트리지계정: druhfile
- 접근키 : KHQlTzpqXCO7aj57TogkDu5S25qG7v9Q4OFybfF0YK7xPtpw7/qxjBTzz7Hz6t2d0mCht57QTet4LCByvc7CmA==
 


### 사용자 지정 도메인 HTTPS 연결 (www.druhstyle.com)
> http / https 별로 설정이 다름 
> HTTP: https://docs.microsoft.com/ko-kr/azure/storage/blobs/storage-custom-domain-name?tabs=azure-portal#enable-http
> HTTPS: https://docs.microsoft.com/ko-kr/azure/storage/blobs/storage-custom-domain-name?tabs=azure-portal#enable-https

#### 1. CDN 엔드포인트 생성.  
- 스토리지계정 > Blob service > Azure CDN
- CDN 프로필: saleson-frontend-cdn-profile 
- 가격 책정 계층: 표준 Microsoft (규칙엔진 적용을 위해)
- CDN 엔드포인트 이름: druhstyle
- 원본 호스트 이름: druhfile.z12.web.core.windows.net(정적 웹사이트) 선택 

연결 후 CDN 엔드포인트(https://druhstyle.azureedge.net)로 접속 시 접속 가능해야함. 

#### 2. CDN 엔드포인트에 사용자 지정 도메인 연결 
> https://docs.microsoft.com/ko-kr/azure/cdn/cdn-map-content-to-custom-domain 

도메인 추가 전 사용하려고 하는 도메인의 DNS 설정이 되어 있어야 등록이 됨
```
www.druhstyle.com    CNAME   druhstyle.azureedge.net
```

druhfile > Azure CDN 메뉴에서 엔트포인트 목록 중 druhstyle.azureedge.net 을 클릭한 후 
개요화면에서 `+ 사용자 지정 도메인`을 클릭하여 도메인을 추가한다. 

#### 3. CDN 엔드포인트에 사용자 지정 도메인에 HTTPS 사용 
사용자 지정 도메인이 연결되면 CDN 엔드포인트(druhstyle.azureedge.net) 개요 화면에서 사용자 지정 도메인 목록이 보임
목록 중 지정한 도메인을 클릭하여 상세보기로 들어가거나 좌측 메뉴 중 사용자 지정 도메인 메뉴를 클릭한 후 상세로 들어감. 

azure.druhstyle.com
사용자 지정 도메인

- 사용자 지정 도메인 HTTPS : [v]설정, [ ] 헤제
- 인증서 관리유형 : [v] CDN 관리됨, [ ] 나만의 인증서 사용

> 별도의 ssl인증서 파일이 없어도 CDN 관리됨을 선택하는 경우 https로 접속할 수 있음. 

https 연결 절차는 아래와 같이 4단계를 거침. 

1. 요청을 제출하는 중 (4:06)
2. 도메인 확인
3. 인증서 프로비전 중 : 인증서가 발급되어 현재 CDN 네트워크에 배포하는 중입니다. 최대 6시간이 걸릴 수 있습니다
4. 완료



### subscription Id 조회
> 활성 구독 변경 https://docs.microsoft.com/ko-kr/cli/azure/manage-azure-subscriptions-azure-cli?view=azure-cli-latest

구독 목록 조회 
```
az account list --output table
Name    CloudName    SubscriptionId                        State    IsDefault
------  -----------  ------------------------------------  -------  -----------
무료 체험   AzureCloud   326c5b62-6be1-45e4-b147-e5245eaa59fc  Enabled  False
무료 체험   AzureCloud   cf49c96e-f071-4cd1-809f-df8db6d8a57b  Enabled  False
온라인파워스  AzureCloud   459a1df5-548a-45ce-b665-b1c479d786e9  Enabled  False
세일즈온    AzureCloud   152f2cc1-4baa-4132-bb0b-2543a9e0bee7  Enabled  True
```

활성 구독 설정 
```
az account set --subscription "세일즈온"
```

구독 ID 조회 (subscriptionId)
```
az account show --query id

"152f2cc1-4baa-4132-bb0b-2543a9e0bee7"
```



## API oauth 인증을 위한 권한 생성 
> https://microsoft.github.io/AzureTipsAndTricks/blog/tip223.html

위의 구독ID를 확인하고 앱을 생성한다.
```
az ad sp create-for-rbac -n "druhstyle"  

Changing "druhstyle" to a valid URI of "http://druhstyle", which is the required format used for service principal names
Creating a role assignment under the scope of "/subscriptions/152f2cc1-4baa-4132-bb0b-2543a9e0bee7"
{
  "appId": "87a8d089-7f08-491c-9d56-70606335aad0",
  "displayName": "druhstyle",
  "name": "http://druhstyle",
  "password": "aaed3a9f-3b7c-407b-ae28-0cd62416a54e",
  "tenant": "6d6e5e0b-0033-43d2-bc45-b590f106e2f6"
}

```



apidoc -i /home/api-docs/src/ -0 /home/api-docs/workspace/doc/




### oauth 인증데이터 
- subscriptionId: az account show --query id
- tenantId: tenant
- clientid: appId
- clientsecret: password

druhstyle
- subscriptionId: 152f2cc1-4baa-4132-bb0b-2543a9e0bee7
- tenantId: 6d6e5e0b-0033-43d2-bc45-b590f106e2f6
- clientid: 87a8d089-7f08-491c-9d56-70606335aad0
- clientsecret: aaed3a9f-3b7c-407b-ae28-0cd62416a54e



## MYSQL
- 서버이름 : druh-mysql
- 컴퓨팅 + 스토리지: 기본 - vCore 1개, 5 GB 스토리지
- 관리자 : oproot
- 비번 : Rnfhpowers^&^%

### 타임존 매개변수 활성화 
host: druh-mysql.mysql.database.azure.com:3306
id: oproot
pw: Rnfhpowers^&^%

```mysql
CALL mysql.az_load_timezone();
```
쿼리 실행 후 portal에서 time_zone 설정. 

- 필터 
    + time_zone : Asia/Seoul
    + character_set_server: UTF8MB4
 

### SALESON3 데이터베이스 생성 
- oproot@druh-mysql로 로그인하여 SALESON3 DB 생성 
- 계정생성 
```sql
-- 서버 설정 확인
show variables like 'char%';
show variables like 'collation%';
show variables like 'time_z%';
show variables like 'max%';


-- DB 생성
CREATE DATABASE SALESON3 CHARACTER SET utf8mb4 DEFAULT COLLATE utf8mb4_general_ci;
CREATE USER 'saleson3'@'112.216.32.194' IDENTIFIED BY 'Tpdlfwmdhs92%@';  -- 쎄일즈온92%@
GRANT ALL PRIVILEGES ON SALESON3.* TO 'saleson3'@'112.216.32.194' WITH GRANT OPTION;

-- AzureDB 20.39.188.139
CREATE USER 'saleson3'@'20.39.188.139' IDENTIFIED BY 'Tpdlfwmdhs92%@';  -- 쎄일즈온92%@
GRANT ALL PRIVILEGES ON SALESON3.* TO 'saleson3'@'20.39.188.139' WITH GRANT OPTION;

``` 

#### DB 접속 
- host: druh-mysql.mysql.database.azure.com
- port: 3306
- id: saleson3@druh-mysql
- pw: Tpdlfwmdhs92%@




## Jenkins 연동
> https://docs.microsoft.com/ko-kr/azure/aks/jenkins-continuous-deployment

### Jenkins 환경 변수 만들기
Jenkins 관리 > 시스템 설정 > Global properties

- DRUH_ACR_SERVER = DruhRegistry.azurecr.io


### ACR의 Jenkins 자격 증명 만들기
서비스 주체 생성
```
az ad sp create-for-rbac --skip-assignment

{
  "appId": "0a3ab2e2-a8e2-4a32-a7a9-195a9aeda45f",
  "displayName": "azure-cli-2020-06-09-06-43-17",
  "name": "http://azure-cli-2020-06-09-06-43-17",
  "password": "e9f18e2e-6c04-4636-9bfa-401c784505b6",
  "tenant": "6d6e5e0b-0033-43d2-bc45-b590f106e2f6"
}
```
Az ACR show 명령을 사용 하 여 ACR 레지스트리의 리소스 ID를 가져오고 변수로 저장 합니다. 리소스 그룹 이름과 ACR 이름을 입력합니다.
이제 역할 할당을 만들어 ACR 레지스트리에 대한 서비스 주체 Contributor 권한을 할당합니다.

```
ACR_ID=$(az acr show --resource-group DruhResourceGroup --name DruhRegistry --query "id" --output tsv)
az role assignment create --assignee 0a3ab2e2-a8e2-4a32-a7a9-195a9aeda45f --role Contributor --scope $ACR_ID
```

#### Jenkins에서 ACR 서비스 주체의 자격 증명 리소스 만들기
Credentials > System > Global credentials (unrestricted) 메뉴에서 `Add Credentils`

- Kind: Username and Password
- Scope: Global (jenkins, nodes, items, all child items, etc)
- username: 0a3ab2e2-a8e2-4a32-a7a9-195a9aeda45f (ACR 레지스트리에 인증하기 위해 만든 서비스 주체의 appId입니다.)
- password: e9f18e2e-6c04-4636-9bfa-401c784505b6 (ACR 레지스트리에 인증하기 위해 만든 서비스 주체의 password입니다.)
- ID - acr-druhregistry-credentials  (자격 증명 식별자)
- Description: ACR-DruhRegistry


### Kuberneties 인증토큰 생성 
- jenkins에서 kubectl 명령을 사용하기 위해서는 token이 필요함. 
- 토큰 생성 > Credentials 등록 
- withCredentials를 이용하여 kubectl 명령 실행. 


#### 1. 토큰생성 
> https://github.com/jenkinsci/kubernetes-cli-plugin
순서대로 실행하여 토큰 복사함 
```
$ kubectl -n default create serviceaccount jenkins-robot

$ kubectl -n default create rolebinding jenkins-robot-binding --clusterrole=cluster-admin --serviceaccount=default:jenkins-robot

$ kubectl -n default get serviceaccount jenkins-robot -o go-template --template='{{range .secrets}}{{.name}}{{"\n"}}{{end}}'

jenkins-robot-token-h6s2k


$ kubectl -n default get secrets jenkins-robot-token-h6s2k -o go-template --template '{{index .data "token"}}' | base64 -d

eyJhbGciOiJSUzI1NiIsImtpZCI6IiJ9.eyJpc3MiOiJrdWJlcm5ldGVzL3NlcnZpY2VhY2NvdW50Iiwia3ViZXJuZXRlcy5pby9zZXJ2aWNlYWNjb3VudC9uYW1lc3BhY2UiOiJkZWZhdWx0Iiwia3ViZXJuZXRlcy5pby9zZXJ2aWNlYWNjb3VudC9zZWNyZXQubmFtZSI6ImplbmtpbnMtcm9ib3QtdG9rZW4taDZzMmsiLCJrdWJlcm5ldGVzLmlvL3NlcnZpY2VhY2NvdW50L3NlcnZpY2UtYWNjb3VudC5uYW1lIjoiamVua2lucy1yb2JvdCIsImt1YmVybmV0ZXMuaW8vc2VydmljZWFjY291bnQvc2VydmljZS1hY2NvdW50LnVpZCI6IjUwZGIwNWQwLTIyMzUtNDA2YS1iMWJkLWQ3YzAwM2ZhY2Y2ZSIsInN1YiI6InN5c3RlbTpzZXJ2aWNlYWNjb3VudDpkZWZhdWx0OmplbmtpbnMtcm9ib3QifQ.W7dqMv4r5mdCmPVO_WMhvW4IcCTKTQ1pAW41F2e28Q-gzyufDjoSkkZ_MfYYcsW9K0l6O4-ZMbaZuFUC4uhZh1w06CtvOyRcf79khvdluJUvOIK3opCzFdVbw0X-hoTJOGPuHSZ7AIwD9J7Y8WHQ6I-U3jdxGi1s0nSh9vXmg5UAejJ5t28rh9WR_sMZ6kQSjYEkOK96FnX2dY7T_D5QyC2GnI-5m3CG1vXJvr5h686zbeHqKerjr6vziO0kpFMJW6bYCJypHnN-toYi4Vkzr1p4Xku88s73XI7i5oqmFjVlEcUVZS4kK0A-TYWephDoYuvL8ypCWYVIykfci_N3KiRKSGTiaNMGwopITLu-HcMOm8UgHImRfNN5iuL1vEv-iv0I1dWy0iECxflUI1Ea9zcIEbN31HX9o787f9aH8s4rJy5HM-wD-OitlKm7sU0c7p9ic8ddTOwt43jUn8-h1osCYciW9nCSckUUoodwuX9o3ktT72W8Hu2eKsolrYTvBO9J9z624zawCEnvKrQqybohIW7HzS4n0zxVsGvsFh79cMueQQL8gqN7xB6RLaNcgFv5kwa0OX2kKco-hSJB1PrBmwxHqa62AVQdC9EQBlqTI6oup40kbNcymK6SlHHxZ-Uxqh5YFe4u-Y474zKRB61h6PRKfUIIOfzkZ-7q32g%
```
> 토큰의 마지막이 %로 끝나는 경우 %는 토큰이 아님.


#### 2. Jenkins에서 Credential 생성 
Credentials > System > Global credentials (unrestricted) 메뉴에서 `Add Credentils` 클릭

- Kind: Secret text
- Scope: Global (jenkins, nodes, items, all child items, etc)
- secret: eyJhbGciOiJSUzI1NiIsImtpZCI6IiJ9.eyJpc3MiOiJrdWJlcm5ldGVzL3NlcnZpY2VhY2NvdW50Iiwia3ViZXJuZXRlcy5pby9zZXJ2aWNlYWNjb3VudC9uYW1lc3BhY2UiOiJkZWZhdWx0Iiwia3ViZXJuZXRlcy5pby9zZXJ2aWNlYWNjb3VudC9zZWNyZXQubmFtZSI6ImplbmtpbnMtcm9ib3QtdG9rZW4taDZzMmsiLCJrdWJlcm5ldGVzLmlvL3NlcnZpY2VhY2NvdW50L3NlcnZpY2UtYWNjb3VudC5uYW1lIjoiamVua2lucy1yb2JvdCIsImt1YmVybmV0ZXMuaW8vc2VydmljZWFjY291bnQvc2VydmljZS1hY2NvdW50LnVpZCI6IjUwZGIwNWQwLTIyMzUtNDA2YS1iMWJkLWQ3YzAwM2ZhY2Y2ZSIsInN1YiI6InN5c3RlbTpzZXJ2aWNlYWNjb3VudDpkZWZhdWx0OmplbmtpbnMtcm9ib3QifQ.W7dqMv4r5mdCmPVO_WMhvW4IcCTKTQ1pAW41F2e28Q-gzyufDjoSkkZ_MfYYcsW9K0l6O4-ZMbaZuFUC4uhZh1w06CtvOyRcf79khvdluJUvOIK3opCzFdVbw0X-hoTJOGPuHSZ7AIwD9J7Y8WHQ6I-U3jdxGi1s0nSh9vXmg5UAejJ5t28rh9WR_sMZ6kQSjYEkOK96FnX2dY7T_D5QyC2GnI-5m3CG1vXJvr5h686zbeHqKerjr6vziO0kpFMJW6bYCJypHnN-toYi4Vkzr1p4Xku88s73XI7i5oqmFjVlEcUVZS4kK0A-TYWephDoYuvL8ypCWYVIykfci_N3KiRKSGTiaNMGwopITLu-HcMOm8UgHImRfNN5iuL1vEv-iv0I1dWy0iECxflUI1Ea9zcIEbN31HX9o787f9aH8s4rJy5HM-wD-OitlKm7sU0c7p9ic8ddTOwt43jUn8-h1osCYciW9nCSckUUoodwuX9o3ktT72W8Hu2eKsolrYTvBO9J9z624zawCEnvKrQqybohIW7HzS4n0zxVsGvsFh79cMueQQL8gqN7xB6RLaNcgFv5kwa0OX2kKco-hSJB1PrBmwxHqa62AVQdC9EQBlqTI6oup40kbNcymK6SlHHxZ-Uxqh5YFe4u-Y474zKRB61h6PRKfUIIOfzkZ-7q32g
- ID: druh-kube-secret
- Description: DruhKube 클러스터의 secret key


#### 3. Jenkins Pipeline
```
pipeline {
    agent any 
    tools {
        gradle 'Gradle 5.6.2'
    }
    environment { 
        SALESON_VERSION = '3.11.0'
    }
    stages {
        stage('Stage 1 : Prepare environment') {
            steps {
                echo 'Checkout Source!' 
                git branch: 'solution-druh-mysql', credentialsId: 'gitlab-jenkins', url: 'http://git.onlinepowers.com:8080/saleson/saleson.git'
            }
        }

        stage('Stage 2 : Gradle build') {
            steps {
                echo 'Checkout Source!' 
                sh 'gradle clean querydsl build -x test'
            }
        }
        
        stage('Stage 3 : Build Docker Image & Push') {
            steps {
                echo "Build Docker Image & Push"
                withCredentials([usernamePassword(credentialsId: 'druhregistry-credentials', passwordVariable: 'ACR_PASSWORD', usernameVariable: 'ACR_ID')]) {
                    sh '''
                        WEB_IMAGE_NAME="${DRUH_ACR_SERVER}/saleson/saleson-druh-web:${SALESON_VERSION}-${BUILD_NUMBER}"
                        docker build -t $WEB_IMAGE_NAME ./saleson-web
                        docker login ${DRUH_ACR_SERVER} -u ${ACR_ID} -p ${ACR_PASSWORD}
                        docker push $WEB_IMAGE_NAME
                    '''
                    sh '''
                        API_IMAGE_NAME="${DRUH_ACR_SERVER}/saleson/saleson-druh-api:${SALESON_VERSION}-${BUILD_NUMBER}"
                        docker build -t ${API_IMAGE_NAME} ./saleson-api
                        docker login ${DRUH_ACR_SERVER} -u ${ACR_ID} -p ${ACR_PASSWORD}
                        docker push $API_IMAGE_NAME
                    '''
                    
                    
                }
            }
        }

        stage('Stage 4 : Deploy Azure Kubernetes') {
            steps {
                withKubeConfig([credentialsId: 'druh-kube-secret', serverUrl:'https://druhkube-dns-f6b89c59.hcp.koreacentral.azmk8s.io']){
                    //sh 'kubectl get all'
                    sh '''
                        API_IMAGE_NAME="${DRUH_ACR_SERVER}/saleson/saleson-druh-api:${SALESON_VERSION}-${BUILD_NUMBER}"
                        kubectl set image deployment/saleson-api-deployment saleson3-api=$API_IMAGE_NAME
                    '''
                    
                    sh '''
                        WEB_IMAGE_NAME="${DRUH_ACR_SERVER}/saleson/saleson-druh-web:${SALESON_VERSION}-${BUILD_NUMBER}"
                        kubectl set image deployment/saleson-deployment saleson3=$WEB_IMAGE_NAME
                    '''
                }
            }
        }
    }
}
```





### 드루 jenkins azure 배포 오류 
#### DRUH (2021.06.10)
- Service Principle 만료가 원인 

```shell

az login 

az aks get-credentials --resource-group DruhResourceGroup --name DruhKube

az aks show --resource-group DruhResourceGroup --name DruhKube --query "servicePrincipalProfile.clientId" --output tsv
8122de5f-07fe-4c9b-be52-4308403b1fd8

az ad sp credential list --id 8122de5f-07fe-4c9b-be52-4308403b1fd8
[]

az vmss run-command invoke --command-id RunShellScript \
--resource-group MC_DruhResourceGroup_DruhKube_koreacentral \
--name aks-agentpool-41368111-vmss \
--instance-id 0 \
--scripts "hostname && date && cat /etc/kubernetes/azure.json" | grep aadClientSecret
...
\"aadClientId\": \"8122de5f-07fe-4c9b-be52-4308403b1fd8\",
\"aadClientSecret\": \"e0b15699-ba32-4515-b1ec-6806acb2dfd4\"
...

az ad sp credential reset -n 8122de5f-07fe-4c9b-be52-4308403b1fd8 -p e0b15699-ba32-4515-b1ec-6806acb2dfd4 --years 10
{
  "appId": "8122de5f-07fe-4c9b-be52-4308403b1fd8",
  "name": "8122de5f-07fe-4c9b-be52-4308403b1fd8",
  "password": "e0b15699-ba32-4515-b1ec-6806acb2dfd4",
  "tenant": "6d6e5e0b-0033-43d2-bc45-b590f106e2f6"
}

az ad sp credential list --id 8122de5f-07fe-4c9b-be52-4308403b1fd8

[
  {
    "additionalProperties": null,
    "customKeyIdentifier": null,
    "endDate": "2031-06-10T08:59:20.032617+00:00",
    "keyId": "0f801aaa-98e6-47d1-beb1-0a4ea8759d4b",
    "startDate": "2021-06-10T08:59:20.032617+00:00",
    "value": null
  }
]

```


### Jenkins 설정 
#### 1. ACR의 Jenkins 자격 증명 만들기
서비스 주체 생성
```
az ad sp create-for-rbac --skip-assignment

{
  "appId": "4dd7a2e0-432a-4a91-a840-116076b861a9",
  "displayName": "azure-cli-2021-06-17-04-39-47",
  "name": "http://azure-cli-2021-06-17-04-39-47",
  "password": "NuAwKK2HB0uph5qcTYsJ~fA60P~.0_gnXY",
  "tenant": "6d6e5e0b-0033-43d2-bc45-b590f106e2f6"
}
```
Az ACR show 명령을 사용 하 여 ACR 레지스트리의 리소스 ID를 가져오고 변수로 저장 합니다. 리소스 그룹 이름과 ACR 이름을 입력합니다.
이제 역할 할당을 만들어 ACR 레지스트리에 대한 서비스 주체 Contributor 권한을 할당합니다.

```
ACR_ID=$(az acr show --resource-group DruhResourceGroup --name DruhRegistry --query "id" --output tsv)
az role assignment create --assignee 4dd7a2e0-432a-4a91-a840-116076b861a9 --role Contributor --scope $ACR_ID
```

#### 2. Jenkins에서 ACR 서비스 주체의 자격 증명 리소스 만들기
Credentials > System > Global credentials (unrestricted) 메뉴에서 `druhregistry-credentials` username, password를 업데이트함. 

- Kind: Username and Password
- Scope: Global (jenkins, nodes, items, all child items, etc)
- username: 4dd7a2e0-432a-4a91-a840-116076b861a9 (ACR 레지스트리에 인증하기 위해 만든 서비스 주체의 appId입니다.)
- password: NuAwKK2HB0uph5qcTYsJ~fA60P~.0_gnXY (ACR 레지스트리에 인증하기 위해 만든 서비스 주체의 password입니다.)
- ID - druhregistry-credentials  (자격 증명 식별자)
- Description: ACR-DruhRegistry


#### 3. DRUH 토큰 재생성 (2021.06.10)
> https://github.com/jenkinsci/kubernetes-cli-plugin
순서대로 실행하여 토큰 복사함
```
$ kubectl -n default create serviceaccount jenkins-robot2

$ kubectl -n default create rolebinding jenkins-robot2-binding --clusterrole=cluster-admin --serviceaccount=default:jenkins-robot2

$ kubectl -n default get serviceaccount jenkins-robot2 -o go-template --template='{{range .secrets}}{{.name}}{{"\n"}}{{end}}'

jenkins-robot2-token-xxpxn


$ kubectl -n default get secrets jenkins-robot2-token-xxpxn -o go-template --template '{{index .data "token"}}' | base64 -d

eyJhbGciOiJSUzI1NiIsImtpZCI6IiJ9.eyJpc3MiOiJrdWJlcm5ldGVzL3NlcnZpY2VhY2NvdW50Iiwia3ViZXJuZXRlcy5pby9zZXJ2aWNlYWNjb3VudC9uYW1lc3BhY2UiOiJkZWZhdWx0Iiwia3ViZXJuZXRlcy5pby9zZXJ2aWNlYWNjb3VudC9zZWNyZXQubmFtZSI6ImplbmtpbnMtcm9ib3QyLXRva2VuLXh4cHhuIiwia3ViZXJuZXRlcy5pby9zZXJ2aWNlYWNjb3VudC9zZXJ2aWNlLWFjY291bnQubmFtZSI6ImplbmtpbnMtcm9ib3QyIiwia3ViZXJuZXRlcy5pby9zZXJ2aWNlYWNjb3VudC9zZXJ2aWNlLWFjY291bnQudWlkIjoiNjA2NjVmZWItODlmOC00ZTdmLWFkZmItNzBlZDdkOGFmMzBkIiwic3ViIjoic3lzdGVtOnNlcnZpY2VhY2NvdW50OmRlZmF1bHQ6amVua2lucy1yb2JvdDIifQ.Mr8HoZRKfug39q_1bEMswyb5u-KRBD016JmDHZwrtwBKaO1DilGYcabdtad8Y-V75m0lEzXrP7RQmBfSfpxTJniNZFDqCb6S79qEBPVC3Np6tNx4TQWIehx8ZVwYSC1kTjm85G-_ZD6oPqxCrtBy2rRm4tRLj23FNRblNgNKKZbFNFiGZU0JizQw8r1y13Xi-bPpyo1qmosEtSPEPM6ymtgnF2y4O1XkTKv-bCTTnY8PrQ7qrfayzSqcB2MaoBiNXRxhkZUCH8ycU4D4aJ-l95zzjR3LTLpVR5obT__g384kDBqYFFkMfabEJwxyrTQxLNQk00CEB6bwujc9X1O_7LCtmbHkOji6Yk5Fxp-kaBBoDv97cYOQOBDQc8QnPVmZrE6W5xIKKyrQXL287D-8FxSKgmCHFUWZSDlQz1DS3UMYVIMCKIMjxkWhDip8hNbVyxpmaST1nE50nR_T8SHOE30RAooIehOua1j7ArzkEh3e6riALO7WiCQ3H2K-jPwubwgfLp9Xdv0s6jGxC-oLZULrsTc-v0IrstbtXcUitpHeQSCo7xaC1Xv9Y35cD92FTpjvaMpgcxjoh0wYj_q-ly__BUeo3noD6CfqAK-7TCB44VIdxa-JlvunP37woWArJhhJpWXsxTE8kbV5u3IkNXxjN4tASdoN_SKJHsgdnWs
```
> 토큰의 마지막이 %로 끝나는 경우 %는 토큰이 아님.


#### 4. Jenkins에서 Credential 생성
Credentials > System > Global credentials (unrestricted) 메뉴에서 `Add Credentils` 클릭

- Kind: Secret text
- Scope: Global (jenkins, nodes, items, all child items, etc)
- secret: eyJhbGciOiJSUzI1NiIsImtpZCI6IiJ9.eyJpc3MiOiJrdWJlcm5ldGVzL3NlcnZpY2VhY2NvdW50Iiwia3ViZXJuZXRlcy5pby9zZXJ2aWNlYWNjb3VudC9uYW1lc3BhY2UiOiJkZWZhdWx0Iiwia3ViZXJuZXRlcy5pby9zZXJ2aWNlYWNjb3VudC9zZWNyZXQubmFtZSI6ImplbmtpbnMtcm9ib3QyLXRva2VuLXh4cHhuIiwia3ViZXJuZXRlcy5pby9zZXJ2aWNlYWNjb3VudC9zZXJ2aWNlLWFjY291bnQubmFtZSI6ImplbmtpbnMtcm9ib3QyIiwia3ViZXJuZXRlcy5pby9zZXJ2aWNlYWNjb3VudC9zZXJ2aWNlLWFjY291bnQudWlkIjoiNjA2NjVmZWItODlmOC00ZTdmLWFkZmItNzBlZDdkOGFmMzBkIiwic3ViIjoic3lzdGVtOnNlcnZpY2VhY2NvdW50OmRlZmF1bHQ6amVua2lucy1yb2JvdDIifQ.Mr8HoZRKfug39q_1bEMswyb5u-KRBD016JmDHZwrtwBKaO1DilGYcabdtad8Y-V75m0lEzXrP7RQmBfSfpxTJniNZFDqCb6S79qEBPVC3Np6tNx4TQWIehx8ZVwYSC1kTjm85G-_ZD6oPqxCrtBy2rRm4tRLj23FNRblNgNKKZbFNFiGZU0JizQw8r1y13Xi-bPpyo1qmosEtSPEPM6ymtgnF2y4O1XkTKv-bCTTnY8PrQ7qrfayzSqcB2MaoBiNXRxhkZUCH8ycU4D4aJ-l95zzjR3LTLpVR5obT__g384kDBqYFFkMfabEJwxyrTQxLNQk00CEB6bwujc9X1O_7LCtmbHkOji6Yk5Fxp-kaBBoDv97cYOQOBDQc8QnPVmZrE6W5xIKKyrQXL287D-8FxSKgmCHFUWZSDlQz1DS3UMYVIMCKIMjxkWhDip8hNbVyxpmaST1nE50nR_T8SHOE30RAooIehOua1j7ArzkEh3e6riALO7WiCQ3H2K-jPwubwgfLp9Xdv0s6jGxC-oLZULrsTc-v0IrstbtXcUitpHeQSCo7xaC1Xv9Y35cD92FTpjvaMpgcxjoh0wYj_q-ly__BUeo3noD6CfqAK-7TCB44VIdxa-JlvunP37woWArJhhJpWXsxTE8kbV5u3IkNXxjN4tASdoN_SKJHsgdnWs
- ID: druh-kube-secret-20210610
- Description: DruhKube 클러스터의 secret key



