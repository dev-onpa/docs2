# Ganong Azure Infra 구성 (가농, zoopiter corp)
> 2021.06.4(금)

## Azure 계정
- 포털: portal.azure.com
- 아이디: admin@ganong365.onmicrosoft.com
- 비밀번호: wnvlxj159!

## 리소스 그룹 생성
- 구독: Azure subscription 1 (생성 되어 있는 구독을 선택함 )
- 리소스 그룹: GanongResourceGroup
- 영역: 한국 중부

## AKS 생성
- 리소스 검색: aks > Kubernetes 클러스터 만들기
- Kubernetes 클러스터 이름: GanongKube
- kubernetes 버전: 1.19.1 (자동 설정값)
- 노드 풀 : 표준 DS2 v2 * 2ea

## 스토리지 계정생성
- 스토리지 계정 이름: ganongstorage
- 성능: 표준
- 나머지 기본값.

### 파일공유(File Share) 만들기
> 기존 saleson(licence, log...) 와 storage(upload)로 구분하였으나 storage로 1개로 통일함. 
- ganong-storage : 첨부파일 경로 (50GB)

> ganong-storage/license/라이선스파일 업로드
> ganong-storage/upload/

## Container Registry (컨테이너 레지스트리)
- Container Registry 만들기
- 레지스트리 이름: GanongRegistry
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
az aks get-credentials --resource-group GanongResourceGroup --name GanongKube
```

## AKS 클러스터에 대한 ACR 통합 구성
```
az aks update -n GanongKube -g GanongResourceGroup --attach-acr GanongRegistry
```


### Docker Image 생성
1. Saleson Build
```
gradle clean build --exclude-task test
```

2. Saleson API
```
cd saleson-api
docker build -t ganongregistry.azurecr.io/ganong/saleson-api:1.0.0-SNAPSHOT .
docker push ganongregistry.azurecr.io/ganong/saleson-api:1.0.0-SNAPSHOT
```

> docker push 시 unauthorized: authentication required 오류 발생 시 acr 인증 후 다시 push
> az acr login --name GanongRegistry

3. Saleson Web
```
cd ../saleson-web
docker build -t ganongregistry.azurecr.io/ganong/saleson-web:1.0.0-SNAPSHOT .
docker push ganongregistry.azurecr.io/ganong/saleson-web:1.0.0-SNAPSHOT
```

4. deploy.sh (instead of 2, 3)
   docker image 생성 및 push (deploy.sh 파일 수정 필요!)
```
./deploy.sh
```


## 스토리지(4umallstorage) 연동
### Kubernetes Secret 만들기
- ganong-storage-secret
- azurestorageaccountkey는 portal > 스토리지 계정 > 보안+네트워킹 > 엑세스 키에서 key1
```
kubectl create secret generic ganong-storage-secret --from-literal=azurestorageaccountname=ganongstorage --from-literal=azurestorageaccountkey=nd69Or9v0ewLvDR1rnHjV3cdENvwWWYcUaVwb+ZtjbPd1PnG4OWveRGjGKiAh26HXu6V09Gvwe5nf53PLl+kDQ==
```

### StorageClass, PV, PVC 생성
```
kubectl apply -f saleson-kubernetes/saleson-pv.yaml
```


### pod / deployment 생성

saleson-*-deployment.yaml 파일을 수정한 후 생성


```
kubectl create -f saleson-front-deployment.yaml
kubectl create -f saleson-api-deployment.yaml
kubectl create -f saleson-deployment.yaml
```


### Kubernetes 클러스터의 리소스 그룹에 고정IP 만들기
- 클러스터의 리소스 그룹 이름 조회
```
az aks show --resource-group GanongResourceGroup --name GanongKube --query nodeResourceGroup -o tsv

MC_GanongResourceGroup_GanongKube_koreacentral  # 클러스터의 리소스 그룹 이름
```

#### INGRESS 용 IP
- az network 으로 고정 IP 주소 만들기 (resource-group : MC_GanongResourceGroup_GanongKube_koreacentral)
```
az network public-ip create \
    --resource-group MC_GanongResourceGroup_GanongKube_koreacentral \
    --name GanongIngressIP \
    --sku Standard \
    --allocation-method static \
    --query publicIp.ipAddress -o tsv
    
52.231.99.248  
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
    --set controller.service.loadBalancerIP="52.231.99.248"
    
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
- 도메인: www.eggshop.co.kr


ganong-ssl-secret 만들기

```
kubectl create secret tls ganong-ssl-secret \
    --namespace default \
    --key certs/www.eggshop.co.kr_pem.key \
    --cert certs/www.eggshop.co.kr_pem.pem
```

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
az aks disable-addons -a monitoring -n GanongKube -g GanongResourceGroup

```


### 정적 웹사이트는 사용하지 않음.
> 2021.04.07 kube로 구성함.




## Jenkins 연동
> https://docs.microsoft.com/ko-kr/azure/aks/jenkins-continuous-deployment
> https://docs.microsoft.com/ko-kr/azure/developer/jenkins/deploy-from-github-to-aks

### Jenkins 환경 변수 만들기
Jenkins 관리 > 시스템 설정 > Global properties

- ACR_GANONG = GanongRegistry.azurecr.io


### ACR의 Jenkins 자격 증명 만들기
서비스 주체 생성
```
az ad sp create-for-rbac --skip-assignment

-- 출력
{
  "appId": "4cfc5684-1769-4782-b124-bd8401764f50",
  "displayName": "azure-cli-2021-08-17-08-08-54",
  "name": "4cfc5684-1769-4782-b124-bd8401764f50",
  "password": "OsIm~Ol-U2XEXLxY0pSnwzkEse1Ryz4wZ6",
  "tenant": "7d027692-de81-4d17-885e-3e14128ef8e0"
}

```
Az ACR show 명령을 사용 하여 ACR 레지스트리의 리소스 ID를 가져오고 변수로 저장 합니다. 리소스 그룹 이름과 ACR 이름을 입력합니다.
이제 역할 할당을 만들어 ACR 레지스트리에 대한 서비스 주체 Contributor 권한을 할당합니다.

```
ACR_ID=$(az acr show --resource-group GanongResourceGroup --name GanongRegistry --query "id" --output tsv)
az role assignment create --assignee 4cfc5684-1769-4782-b124-bd8401764f50 --role Contributor --scope $ACR_ID

-- 출력 
{
  "canDelegate": null,
  "condition": null,
  "conditionVersion": null,
  "description": null,
  "id": "/subscriptions/7d799574-8252-4a81-aa19-cdf1ce026f92/resourceGroups/GanongResourceGroup/providers/Microsoft.ContainerRegistry/registries/GanongRegistry/providers/Microsoft.Authorization/roleAssignments/19465d02-d6cb-4f8b-b1a0-58095f52fa7a",
  "name": "19465d02-d6cb-4f8b-b1a0-58095f52fa7a",
  "principalId": "ff0d4856-0102-4ad8-9ac3-1a6953f9c3af",
  "principalType": "ServicePrincipal",
  "resourceGroup": "GanongResourceGroup",
  "roleDefinitionId": "/subscriptions/7d799574-8252-4a81-aa19-cdf1ce026f92/providers/Microsoft.Authorization/roleDefinitions/b24988ac-6180-42a0-ab88-20f7382dd24c",
  "scope": "/subscriptions/7d799574-8252-4a81-aa19-cdf1ce026f92/resourceGroups/GanongResourceGroup/providers/Microsoft.ContainerRegistry/registries/GanongRegistry",
  "type": "Microsoft.Authorization/roleAssignments"
}

```

#### Jenkins에서 ACR 서비스 주체의 자격 증명 리소스 만들기
Credentials > System > Global credentials (unrestricted) 메뉴에서 `Add Credentils`

- Kind: Username and Password
- Scope: Global (jenkins, nodes, items, all child items, etc)
- username: 4cfc5684-1769-4782-b124-bd8401764f50 (ACR 레지스트리에 인증하기 위해 만든 서비스 주체의 appId입니다.)
- password: OsIm~Ol-U2XEXLxY0pSnwzkEse1Ryz4wZ6 (ACR 레지스트리에 인증하기 위해 만든 서비스 주체의 password입니다.)
- ID: ganong-acr-credentials  (자격 증명 식별자)
- Description: [GANONG] ACR 자격증명


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
jenkins-robot-token-wl29d


$ kubectl -n default get secrets jenkins-robot-token-wl29d -o go-template --template '{{index .data "token"}}' | base64 -d

-- 출력 
eyJhbGciOiJSUzI1NiIsImtpZCI6InBrS2VNV1JFZzRMd3lFZlA0ZlFCNnE4bzBsUTJRcFp0UWNrRE1GLWMtWHcifQ.eyJpc3MiOiJrdWJlcm5ldGVzL3NlcnZpY2VhY2NvdW50Iiwia3ViZXJuZXRlcy5pby9zZXJ2aWNlYWNjb3VudC9uYW1lc3BhY2UiOiJkZWZhdWx0Iiwia3ViZXJuZXRlcy5pby9zZXJ2aWNlYWNjb3VudC9zZWNyZXQubmFtZSI6ImplbmtpbnMtcm9ib3QtdG9rZW4td2wyOWQiLCJrdWJlcm5ldGVzLmlvL3NlcnZpY2VhY2NvdW50L3NlcnZpY2UtYWNjb3VudC5uYW1lIjoiamVua2lucy1yb2JvdCIsImt1YmVybmV0ZXMuaW8vc2VydmljZWFjY291bnQvc2VydmljZS1hY2NvdW50LnVpZCI6IjRmMzI5ZmZlLTZjNDMtNDEwMi1hZjQ4LWVmYjVmZmFlY2VmOCIsInN1YiI6InN5c3RlbTpzZXJ2aWNlYWNjb3VudDpkZWZhdWx0OmplbmtpbnMtcm9ib3QifQ.JDwzdmUTK6Vz_lEnoLtyonBsWJWomTQxyxH_KsNiioJQ8DaQIiOKmleBmM-EcjYd4x5XS5IEKiHc-4Vfncw6viZ61bWCrP0pEDWlSuXXqCmdUcgrg3JvINOwEV1zyIO_eu69_VwktM1jG2uiT_SttnP4w0ewwVNSxw1F2IkVNCcQEx4M5LdtUhlyMFjDnKrcAfAU2zTJihlvcpIQBB4DPJ7xIXejqizgiH0lfSmpUptuDpZ_drrPGV4-7T0d6OLZonBsI8MGrFw0-32ck3z6tJpm7OjM6OCm5RGi7p4LuyFsBGQIVWdgO-ox7Alm9ZQFU4Ljse-n3kD5cBhRFqoB26CpSQlvulSWxURHM3IkVGtN008TEY_ybOZ47wT7MTKKoojHHxes8LEqtyIg9Z8yYTclKs93teIxkMmx1cL-TLAbP17TNgYgiKNaf7P4b2m6vnYAvOPhFTSVYfjumlP0XNR0xUECEdQQ2-GSp-qRWtURqUUggAJDTi3KEafgfKb0TOY-eNxNU7b_RdBXVPOuP7uox7V4DnmS3dfAtu_kUrvG-ENW2MUjk--K3dJ9P4Ekk8We1fYGPxcifGUZmSiBBcKs1zkFNwY5WxCOGCmsDY8ffJDnxvQLHz01Zc10ReynkoRxDpZWFpCjD6GjlBmpxvqEOGFTdvBrEuQmCmEALKM
```
> 토큰의 마지막이 %로 끝나는 경우 %는 토큰이 아님.


#### 2. Jenkins에서 Credential 생성
Credentials > System > Global credentials (unrestricted) 메뉴에서 `Add Credentils` 클릭

- Kind: Secret text
- Scope: Global (jenkins, nodes, items, all child items, etc)
- secret: eyJhbGciOiJSUzI1NiIsImtpZCI6InBrS2VNV1JFZzRMd3lFZlA0ZlFCNnE4bzBsUTJRcFp0UWNrRE1GLWMtWHcifQ.eyJpc3MiOiJrdWJlcm5ldGVzL3NlcnZpY2VhY2NvdW50Iiwia3ViZXJuZXRlcy5pby9zZXJ2aWNlYWNjb3VudC9uYW1lc3BhY2UiOiJkZWZhdWx0Iiwia3ViZXJuZXRlcy5pby9zZXJ2aWNlYWNjb3VudC9zZWNyZXQubmFtZSI6ImplbmtpbnMtcm9ib3QtdG9rZW4td2wyOWQiLCJrdWJlcm5ldGVzLmlvL3NlcnZpY2VhY2NvdW50L3NlcnZpY2UtYWNjb3VudC5uYW1lIjoiamVua2lucy1yb2JvdCIsImt1YmVybmV0ZXMuaW8vc2VydmljZWFjY291bnQvc2VydmljZS1hY2NvdW50LnVpZCI6IjRmMzI5ZmZlLTZjNDMtNDEwMi1hZjQ4LWVmYjVmZmFlY2VmOCIsInN1YiI6InN5c3RlbTpzZXJ2aWNlYWNjb3VudDpkZWZhdWx0OmplbmtpbnMtcm9ib3QifQ.JDwzdmUTK6Vz_lEnoLtyonBsWJWomTQxyxH_KsNiioJQ8DaQIiOKmleBmM-EcjYd4x5XS5IEKiHc-4Vfncw6viZ61bWCrP0pEDWlSuXXqCmdUcgrg3JvINOwEV1zyIO_eu69_VwktM1jG2uiT_SttnP4w0ewwVNSxw1F2IkVNCcQEx4M5LdtUhlyMFjDnKrcAfAU2zTJihlvcpIQBB4DPJ7xIXejqizgiH0lfSmpUptuDpZ_drrPGV4-7T0d6OLZonBsI8MGrFw0-32ck3z6tJpm7OjM6OCm5RGi7p4LuyFsBGQIVWdgO-ox7Alm9ZQFU4Ljse-n3kD5cBhRFqoB26CpSQlvulSWxURHM3IkVGtN008TEY_ybOZ47wT7MTKKoojHHxes8LEqtyIg9Z8yYTclKs93teIxkMmx1cL-TLAbP17TNgYgiKNaf7P4b2m6vnYAvOPhFTSVYfjumlP0XNR0xUECEdQQ2-GSp-qRWtURqUUggAJDTi3KEafgfKb0TOY-eNxNU7b_RdBXVPOuP7uox7V4DnmS3dfAtu_kUrvG-ENW2MUjk--K3dJ9P4Ekk8We1fYGPxcifGUZmSiBBcKs1zkFNwY5WxCOGCmsDY8ffJDnxvQLHz01Zc10ReynkoRxDpZWFpCjD6GjlBmpxvqEOGFTdvBrEuQmCmEALKM
- ID: ganong-kube-secret
- Description: [GANONG] Kubernetes secret key


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
                withKubeConfig([credentialsId: '4umall-kube-secret', serverUrl:'https://GanongKube-dns-719680fe.hcp.koreacentral.azmk8s.io']){
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

