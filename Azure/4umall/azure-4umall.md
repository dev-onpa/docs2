# 4UMALL Azure Infra 구성 (포유몰)
> 2021.02.16(화) 

## 4umall 계정 
- admin@saleson365.onmicrosoft.com / Tpdlfwmdhs! 계정 로그인후 사용자 생성 
- 4umall@saleson365.onmicrosoft.com
- 이름: 4umall
- 암호: vhdbahf92%@

포유몰 구독 신청 (박이사님 -> MS) 
## 구독 
- 포유몰 : 4umall@saleson365.onmicrosoft.com 계정에 구독 소유자 역할 추가 

## 리소스 그룹 생성 
- 구독: 포유몰
- 리소스 그룹: 4umallResourceGroup
- 영역: 한국 중부

## AKS 생성
- 리소스 검색: aks > Kubernetes 클러스터 만들기
- Kubernetes 클러스터 이름: 4umallKube 
- kubernetes 버전: 1.18.14 (자동 설정값)
- 노드 풀 : 표준 DS2 v2 * 2ea

## 스토리지 계정생성
- 스토리지 계정 이름: 4umallstorage
- 성능: 표준
- 나머지 기본값.

### 파일공유(File Share) 만들기
- 4umall-saleson : 라이선스 파일 (1GB)
- 4umall-storage : 첨부파일 경로 (5GB)

> 4umall-saleson/license/라이선스파일 업로드
> 4umall-saleson/upload/

## Container Registry (컨테이너 레지스트리)
- Container Registry 만들기 
- 레지스트리 이름: 4umallRegistry
- 한국 중부 / 표준 


## CLI 명령 
### Azure CLI 설치 
### Kubernetes CLI 설치 (kublctl)

### azure login
```
az login
``` 

### kubectl을 사용하여 클러스터에 연결
```
az aks get-credentials --resource-group 4umallResourceGroup --name 4umallKube
```

## AKS 클러스터에 대한 ACR 통합 구성
```
az aks update -n 4umallKube -g 4umallResourceGroup --attach-acr 4umallRegistry
```


### Docker Image 생성 
1. Saleson Build
```
gradle clean build --exclude-task test
```

2. Saleson API
```
cd saleson-api
docker build -t 4umallregistry.azurecr.io/4umall/saleson-api:0.0.1 .
docker push 4umallregistry.azurecr.io/4umall/saleson-api:0.0.1
```

> docker push 시 unauthorized: authentication required 오류 발생 시 acr 인증 후 다시 push
> az acr login --name 4umallregistry

3. Saleson Web
```
cd ../saleson-web
docker build -t 4umallregistry.azurecr.io/4umall/saleson-web:0.0.1 .
docker push 4umallregistry.azurecr.io/4umall/saleson-web:0.0.1
```

4. deploy.sh (instead of 2, 3)
docker image 생성 및 push (deploy.sh 파일 수정 필요!)
```
./deploy.sh
```


## 스토리지(4umallstorage) 연동
### Kubernetes Secret 만들기
- 4umall-storage-secret 
- azurestorageaccountkey는 portal > 스토리지 계정 > 설정 > 엑세스 키에서 key1 
```
kubectl create secret generic 4umall-storage-secret --from-literal=azurestorageaccountname=4umallstorage --from-literal=azurestorageaccountkey=5CXm0t7uFqtVmzzoN/0FgOFGR209J8SUco0tbD8knJE67YXiuRzJ6xl3j65a6IFUnXGVRvQ7YTP4nb3BpeMmCQ==
```

### StorageClass, PV, PVC 생성
```
kubectl apply -f saleson-kubernetes/azure-saleson-pv.yaml
```


### pod / deployment 생성

saleson-*-deployment.yaml 파일을 수정한 후 생성


```
kubectl create -f azure-saleson-api-deployment.yaml
kubectl create -f azure-saleson-deployment.yaml
```


### Kubernetes 클러스터의 리소스 그룹에 고정IP 만들기
- 클러스터의 리소스 그룹 이름 조회
```
az aks show --resource-group 4umallResourceGroup --name 4umallKube --query nodeResourceGroup -o tsv

MC_4umallResourceGroup_4umallKube_koreacentral  # 클러스터의 리소스 그룹 이름
```

#### INGRESS 용 IP
- az network 으로 고정 IP 주소 만들기 (resource-group : MC_4umallResourceGroup_4umallKube_koreacentral)
```
az network public-ip create \
    --resource-group MC_4umallResourceGroup_4umallKube_koreacentral \
    --name 4umallIngressIP \
    --sku Standard \
    --allocation-method static \
    --query publicIp.ipAddress -o tsv
    
20.194.35.173   
```


#### Nginx Ingress Controller 설치 (고정 IP)
> https://docs.microsoft.com/ko-kr/azure/aks/ingress-basic
> helm이 이미 설치되어 있어야 함.
> namespace는 지정하지 않았음.

1. Add the official stable repository
```
helm repo add ingress-nginx https://kubernetes.github.io/ingress-nginx
```

2. nginx-ingress 설치
접속한 Client ip를 확인하기 위해서 `--set controller.service.externalTrafficPolicy=Local` 설정을 추가한다. 
`X-Forward-For`를 통해 IP를 확인할 수 있다. 
```
helm install nginx-ingress ingress-nginx/ingress-nginx \
    --set controller.replicaCount=2 \
    --set controller.service.externalTrafficPolicy=Local \
    --set controller.nodeSelector."beta\.kubernetes\.io/os"=linux \
    --set defaultBackend.nodeSelector."beta\.kubernetes\.io/os"=linux \
    --set controller.admissionWebhooks.patch.nodeSelector."beta\.kubernetes\.io/os"=linux \
    --set controller.service.loadBalancerIP="20.194.35.173"
    
```

3. helm 설치 목록
```shell
$ helm list --namespace default
```

4. nginx-ingress 삭제
```shell
helm uninstall nginx-ingress --namespace default
```


#### 라이선스 발급 및 적용
- Ingress 고정 IP 기준으로 라이선스 키를 발행하고 관련 정보를 수정




#### HTTPs Ingress
- 도메인이 결정 전 이라 4umall.onlinepowers.com 으로 우선 등록 


saleson-ssl-secret 만들기
```
kubectl create secret tls saleson-ssl-secret \
    --namespace default \
    --key certs/ssl-onlinepowers.key \
    --cert certs/ssl-onlinepowers.crt
```

> 업체로 부터 ssl 인증서를 받아 ssl-secret을 사시 생성하고 ingress 수정 후 다시 적용해야함.
```
kubectl create secret tls 4umall-ssl-secret \
    --namespace default \
    --key certs/www_4umall_co_kr.key \
    --cert certs/www_4umall_co_kr.crt
```
kubectl create secret tls 4umall-ssl-secret --key certs/www_4umall_co_kr.key --cert certs/www_4umall_co_kr.crt.pem

kubectl create secret tls 4umall-ssl-secret --key certs/private.key --cert certs/www_4umall_co_kr.crt.pem

- azure-saleson-ingress.yaml 파일 수정 후 실행 


### 송신 IP 확인하기 (사용하지 않음- 참고용)
> https://docs.microsoft.com/ko-kr/azure/aks/egress  (사용하지 않음)
> egress 로 아이피를 할당하지 않고 aks 초기 구성시 outbound IP가 할당되어 있음.   

- 기본적으로 AKS(Azure Kubernetes Service) 클러스터의 송신 IP 주소는 임의로 할당됨
- portal.azure.com > Kube리소스그룹 > 부하분산장치 > 프런트엔드 IP 구성 
- 52.141.2.96(4ec8df1e-9c79-46e3-afdd-427f568f1438) 이런 형태로 할당된 IP 상세페이지 접속 
- 사용자: `aksOutboundRule` 로 설정되어 있는지 확인 


### 성능 모니터링(Log Analytics)
ASK는 Azure Monitor 를 이용한 Container Insights 를 수집 하여 AKS 성능 모니터링을 진행함. (기본설정)
AKS 모니터링을 중단해야 모니터링 비용이 발생하지 않음.

> 모니터링 중단 방법 : https://docs.microsoft.com/ko-kr/azure/azure-monitor/insights/container-insights-optout  

#### 모니터링 중단 방법
`az aks disable-addons` 명령을 사용하여 컨테이너 인사이트를 사용하지 않도록 설정합니다. 
이 명령은 클러스터 노드에서 에이전트를 제거하지만, 이미 수집되어 Azure Monitor 리소스에 저장된 솔루션 또는 데이터는 제거하지 않습니다.

```shell
az aks disable-addons -a monitoring -n 4umallKube -g 4umallResourceGroup

```


### 정적 웹사이트는 사용하지 않음. 
> 2021.04.07 kube로 구성함. 




## Jenkins 연동
> https://docs.microsoft.com/ko-kr/azure/aks/jenkins-continuous-deployment
> https://docs.microsoft.com/ko-kr/azure/developer/jenkins/deploy-from-github-to-aks

### Jenkins 환경 변수 만들기
Jenkins 관리 > 시스템 설정 > Global properties

- ACR_4UMALL = 4umallregistry.azurecr.io


### ACR의 Jenkins 자격 증명 만들기
서비스 주체 생성
```
az ad sp create-for-rbac --skip-assignment

-- 출력
{
  "appId": "63f20107-ce23-437d-bc6c-ddac0c384081",
  "displayName": "azure-cli-2021-04-25-23-51-03",
  "name": "http://azure-cli-2021-04-25-23-51-03",
  "password": "J0YNuQH5.6erfnx21VZlepNE3WXt11~5MJ",
  "tenant": "6d6e5e0b-0033-43d2-bc45-b590f106e2f6"
}
```
Az ACR show 명령을 사용 하여 ACR 레지스트리의 리소스 ID를 가져오고 변수로 저장 합니다. 리소스 그룹 이름과 ACR 이름을 입력합니다.
이제 역할 할당을 만들어 ACR 레지스트리에 대한 서비스 주체 Contributor 권한을 할당합니다.

```
ACR_ID=$(az acr show --resource-group 4umallResourceGroup --name 4umallRegistry --query "id" --output tsv)
az role assignment create --assignee 63f20107-ce23-437d-bc6c-ddac0c384081 --role Contributor --scope $ACR_ID

-- 출력 
{
  "canDelegate": null,
  "condition": null,
  "conditionVersion": null,
  "description": null,
  "id": "/subscriptions/e8e3faa2-0c96-4d67-ae6c-c22bbb5ec91e/resourceGroups/4umallResourceGroup/providers/Microsoft.ContainerRegistry/registries/4umallRegistry/providers/Microsoft.Authorization/roleAssignments/78bf7cef-c833-4fae-a28e-48379c83e49c",
  "name": "78bf7cef-c833-4fae-a28e-48379c83e49c",
  "principalId": "3e0fb614-6001-49c2-936a-a58e8520f1c8",
  "principalType": "ServicePrincipal",
  "resourceGroup": "4umallResourceGroup",
  "roleDefinitionId": "/subscriptions/e8e3faa2-0c96-4d67-ae6c-c22bbb5ec91e/providers/Microsoft.Authorization/roleDefinitions/b24988ac-6180-42a0-ab88-20f7382dd24c",
  "scope": "/subscriptions/e8e3faa2-0c96-4d67-ae6c-c22bbb5ec91e/resourceGroups/4umallResourceGroup/providers/Microsoft.ContainerRegistry/registries/4umallRegistry",
  "type": "Microsoft.Authorization/roleAssignments"
}

```

#### Jenkins에서 ACR 서비스 주체의 자격 증명 리소스 만들기
Credentials > System > Global credentials (unrestricted) 메뉴에서 `Add Credentils`

- Kind: Username and Password
- Scope: Global (jenkins, nodes, items, all child items, etc)
- username: 63f20107-ce23-437d-bc6c-ddac0c384081 (ACR 레지스트리에 인증하기 위해 만든 서비스 주체의 appId입니다.)
- password: J0YNuQH5.6erfnx21VZlepNE3WXt11~5MJ (ACR 레지스트리에 인증하기 위해 만든 서비스 주체의 password입니다.)
- ID - acr-4umall-credentials  (자격 증명 식별자)
- Description: ACR-4UMALL


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

-- 출력
jenkins-robot-token-vv6n4


$ kubectl -n default get secrets jenkins-robot-token-vv6n4 -o go-template --template '{{index .data "token"}}' | base64 -d

-- 출력 
eyJhbGciOiJSUzI1NiIsImtpZCI6IjhESXQxMF95VkhfcTU3UE5IYmJ1cVlEMmxFN2VpX3VQLTdMYjJhcHhUNU0ifQ.eyJpc3MiOiJrdWJlcm5ldGVzL3NlcnZpY2VhY2NvdW50Iiwia3ViZXJuZXRlcy5pby9zZXJ2aWNlYWNjb3VudC9uYW1lc3BhY2UiOiJkZWZhdWx0Iiwia3ViZXJuZXRlcy5pby9zZXJ2aWNlYWNjb3VudC9zZWNyZXQubmFtZSI6ImplbmtpbnMtcm9ib3QtdG9rZW4tdnY2bjQiLCJrdWJlcm5ldGVzLmlvL3NlcnZpY2VhY2NvdW50L3NlcnZpY2UtYWNjb3VudC5uYW1lIjoiamVua2lucy1yb2JvdCIsImt1YmVybmV0ZXMuaW8vc2VydmljZWFjY291bnQvc2VydmljZS1hY2NvdW50LnVpZCI6IjY3ZWZhZWIwLTc1MGEtNGNmZC05YTljLWUzMzkxYWI4MjdlYyIsInN1YiI6InN5c3RlbTpzZXJ2aWNlYWNjb3VudDpkZWZhdWx0OmplbmtpbnMtcm9ib3QifQ.BFzepHlR5RjLGKye-FhxpMcrmoe5c9VXcz4WBgOTdqdBL8HS6DHIWHYUSHTxEZu7HbP_7awRd9156GIgsZ6Q88127UdN0CMh5bNwwWN9_iIuOJZVh6RDCts1XXdNDNhEqI0_wUme7LinXk2iKKigIxo1MzfERi9KOK3HgMsTR7p0xVlSA_3El8eBn6Nq9fk_mPYDDbGuVYvKE02wORQoE3l_eKIGnYVOaj9nFDrL5LxgBJtbVYgLtiqQUenVs3OMtwwg3t3UCyUyIEvHpub3N8C5aRghfpJ9qTEmXant7zrdMRPTUtnTg5evdkF5GKuWIpiMCi_FDEvi-4700sOMkRJeY_f9VSb9YTdRSddJrQV45Gfa6d3dA919fEYcSfVoSNubQsYQNBtmb8jEcwOIvQVestFHvnqpSTPJk_-GWsgl-jc2kMHvj6lmLDPKIrdW7yKF-xDD0Enys98E7M6PLYjCRVTzVvIMf_jZP6ZKvHNUiot8Af1O0MdIUFCcMerpQdUZAhy-90q4s2TEuJcuDmMbfurR-52G56_L-CAZnuNDJi3x3aMHWAe1I6vzqnPP8fq7iJkkfAZQkVjf0_KcYSZHEnSUIKyJfEDPwQp1051FEzsCfqASJtB-3e_njsfeMgkfqp9Vn4bJw6Y9ivgNwgq99N43KVW2eYt_q-CTbBo%
```
> 토큰의 마지막이 %로 끝나는 경우 %는 토큰이 아님.


#### 2. Jenkins에서 Credential 생성
Credentials > System > Global credentials (unrestricted) 메뉴에서 `Add Credentils` 클릭

- Kind: Secret text
- Scope: Global (jenkins, nodes, items, all child items, etc)
- secret: eyJhbGciOiJSUzI1NiIsImtpZCI6IjhESXQxMF95VkhfcTU3UE5IYmJ1cVlEMmxFN2VpX3VQLTdMYjJhcHhUNU0ifQ.eyJpc3MiOiJrdWJlcm5ldGVzL3NlcnZpY2VhY2NvdW50Iiwia3ViZXJuZXRlcy5pby9zZXJ2aWNlYWNjb3VudC9uYW1lc3BhY2UiOiJkZWZhdWx0Iiwia3ViZXJuZXRlcy5pby9zZXJ2aWNlYWNjb3VudC9zZWNyZXQubmFtZSI6ImplbmtpbnMtcm9ib3QtdG9rZW4tdnY2bjQiLCJrdWJlcm5ldGVzLmlvL3NlcnZpY2VhY2NvdW50L3NlcnZpY2UtYWNjb3VudC5uYW1lIjoiamVua2lucy1yb2JvdCIsImt1YmVybmV0ZXMuaW8vc2VydmljZWFjY291bnQvc2VydmljZS1hY2NvdW50LnVpZCI6IjY3ZWZhZWIwLTc1MGEtNGNmZC05YTljLWUzMzkxYWI4MjdlYyIsInN1YiI6InN5c3RlbTpzZXJ2aWNlYWNjb3VudDpkZWZhdWx0OmplbmtpbnMtcm9ib3QifQ.BFzepHlR5RjLGKye-FhxpMcrmoe5c9VXcz4WBgOTdqdBL8HS6DHIWHYUSHTxEZu7HbP_7awRd9156GIgsZ6Q88127UdN0CMh5bNwwWN9_iIuOJZVh6RDCts1XXdNDNhEqI0_wUme7LinXk2iKKigIxo1MzfERi9KOK3HgMsTR7p0xVlSA_3El8eBn6Nq9fk_mPYDDbGuVYvKE02wORQoE3l_eKIGnYVOaj9nFDrL5LxgBJtbVYgLtiqQUenVs3OMtwwg3t3UCyUyIEvHpub3N8C5aRghfpJ9qTEmXant7zrdMRPTUtnTg5evdkF5GKuWIpiMCi_FDEvi-4700sOMkRJeY_f9VSb9YTdRSddJrQV45Gfa6d3dA919fEYcSfVoSNubQsYQNBtmb8jEcwOIvQVestFHvnqpSTPJk_-GWsgl-jc2kMHvj6lmLDPKIrdW7yKF-xDD0Enys98E7M6PLYjCRVTzVvIMf_jZP6ZKvHNUiot8Af1O0MdIUFCcMerpQdUZAhy-90q4s2TEuJcuDmMbfurR-52G56_L-CAZnuNDJi3x3aMHWAe1I6vzqnPP8fq7iJkkfAZQkVjf0_KcYSZHEnSUIKyJfEDPwQp1051FEzsCfqASJtB-3e_njsfeMgkfqp9Vn4bJw6Y9ivgNwgq99N43KVW2eYt_q-CTbBo
- ID: 4umall-kube-secret
- Description: [4umall] 클러스터의 secret key


#### 3. Jenkins Pipeline
```
pipeline {
    agent any 
    tools {
        gradle 'Gradle 5.6.2'
    }
    environment { 
        SALESON_VERSION = '3.13.0'
    }
    stages {
        stage('Stage 1 : Prepare environment') {
            steps {
                echo 'Checkout Source!' 
                git branch: 'solution/4umall', credentialsId: 'gitlab-jenkins', url: 'http://git.onlinepowers.com:8080/saleson/saleson.git'
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
                
                withCredentials([usernamePassword(credentialsId: 'acr-4umall-credentials', passwordVariable: 'ACR_PASSWORD', usernameVariable: 'ACR_ID')]) {
                    sh '''
                        WEB_IMAGE_NAME="${ACR_4UMALL}/4umall/saleson-web:${SALESON_VERSION}-${BUILD_NUMBER}"
                        docker build -t $WEB_IMAGE_NAME ./saleson-web
                        docker login ${ACR_4UMALL} -u ${ACR_ID} -p ${ACR_PASSWORD}
                        docker push $WEB_IMAGE_NAME
                    '''
                    sh '''
                        API_IMAGE_NAME="${ACR_4UMALL}/4umall/saleson-api:${SALESON_VERSION}-${BUILD_NUMBER}"
                        docker build -t ${API_IMAGE_NAME} ./saleson-api
                        docker login ${ACR_4UMALL} -u ${ACR_ID} -p ${ACR_PASSWORD}
                        docker push $API_IMAGE_NAME
                    '''
                    
                    sh '''
                        FRONT_IMAGE_NAME="${ACR_4UMALL}/4umall/saleson-front:${SALESON_VERSION}-${BUILD_NUMBER}"
                        docker build -t ${FRONT_IMAGE_NAME} ./saleson-front
                        docker login ${ACR_4UMALL} -u ${ACR_ID} -p ${ACR_PASSWORD}
                        docker push $FRONT_IMAGE_NAME
                    '''
                    
                    
                }
            }
        }

        stage('Stage 4 : Deploy Azure Kubernetes') {
            steps {
                withKubeConfig([credentialsId: '4umall-kube-secret', serverUrl:'https://4umallkube-dns-719680fe.hcp.koreacentral.azmk8s.io']){
                    sh 'kubectl get all'
                    
                    
                    sh '''
                        WEB_IMAGE_NAME="${ACR_4UMALL}/4umall/saleson-web:${SALESON_VERSION}-${BUILD_NUMBER}"
                        kubectl set image deployment/saleson-deployment saleson3=$WEB_IMAGE_NAME
                    '''
                    
                    sh '''
                        API_IMAGE_NAME="${ACR_4UMALL}/4umall/saleson-api:${SALESON_VERSION}-${BUILD_NUMBER}"
                        kubectl set image deployment/saleson-api-deployment saleson3-api=$API_IMAGE_NAME
                    '''
                    
                    sh '''
                        FRONT_IMAGE_NAME="${ACR_4UMALL}/4umall/saleson-api:${SALESON_VERSION}-${BUILD_NUMBER}"
                        kubectl set image deployment/saleson-front-deployment saleson3-front=$FRONT_IMAGE_NAME
                    '''
                }
            }
        }
    }
}
```






포유몰 접속정보 
------------
* Git
- url: https://git.onlinepowers.com:8443/saleson/saleson.git
- branch: solution/4umall
- git clone -b solution/4umall https://git.onlinepowers.com:8443/saleson/saleson.git


* DB
- host: 4umall-mysql.mysql.database.azure.com:3306
- db: SALESON3
- user: 4umall@4umall-mysql
- pw: 4UMall92%@


* FileZilla
- host: file.core.windows.net
- 스토리지 계정: 4umallstorage
- 접근키: 5CXm0t7uFqtVmzzoN/0FgOFGR209J8SUco0tbD8knJE67YXiuRzJ6xl3j65a6IFUnXGVRvQ7YTP4nb3BpeMmCQ==


* 코딩
- http://4umall.coding.onlinepowers.com/html/


* 접속 URL
- front: https://4umallstorage.z12.web.core.windows.net
- bo: https://4umall.onlinepowers.com/opmanager
- api: https://4umall.onlinepowers.com/api

