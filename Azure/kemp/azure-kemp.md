# KEMP Azure Infra 구성 
> 2021.01.20 

## KEMP 구성 생성 완료 
- kemp 구독이 생성된 후 계정 / 임시 비밀번호를 전달 받음. 
- 로그인 후 비밀번호 변경
- 접속 링크: portal.azure.com
- 계정: admin@kempO365.onmicrosoft.com
- 비밀번호: kemp92%@!

## 리소스 그룹 생성 
- 구독: Azure subscription 1
- 리소스 그룹: KempResourceGroup
- 영역: 한국 중부


## AKS 생성
- 리소스 검색: aks > Kubernetes 클러스터 만들기
- Kubernetes 클러스터 이름: KempKube
- kubernetes 버전: 1.18.14 (자동 설정값)
- 노드 풀 : 표준 DS2 v2 * 2ea

## 스토리지 계정생성
- 스토리지 계정 이름: kempstorage
- 성능: 표준
- 나머지 기본값. 

### 파일공유(File Share) 만들기
- kemp-saleson : 라이선스 파일 (1GB)
- kemp-storage : 첨부파일 경로 (5GB)

> kemp-saleson/license/라이선스파일 업로드
> kemp-saleson/upload/

## Container Registry (컨테이너 레지스트리)
- Container Registry 만들기
- 레지스트리 이름: KempRegistry
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
az aks get-credentials --resource-group KempResourceGroup --name KempKube
```

## AKS 클러스터에 대한 ACR 통합 구성
```
az aks update -n KempKube -g KempResourceGroup --attach-acr KempRegistry
```




### Docker Image 생성
1. Saleson Build
```
gradle clean build --exclude-task test
```

2. Saleson API
```
cd saleson-api
docker build -t kempregistry.azurecr.io/kemp/saleson-api:0.0.1 .
docker push kempregistry.azurecr.io/kemp/saleson-api:0.0.1
```

> docker push 시 unauthorized: authentication required 오류 발생 시 acr 인증 후 다시 push
> az acr login --name kempregistry

3. Saleson Web
```
cd ../saleson-web
docker build -t kempregistry.azurecr.io/kemp/saleson-web:0.0.1 .
docker push kempregistry.azurecr.io/kemp/saleson-web:0.0.1
```

4. deploy.sh (instead of 2, 3)
   docker image 생성 및 push (deploy.sh 파일 수정 필요!)
```
./deploy.sh
```


## 스토리지(kempstorage) 연동
### Kubernetes Secret 만들기
- kemp-storage-secret
- azurestorageaccountkey는 portal > 스토리지 계정 > 설정 > 엑세스 키에서 key1
```
kubectl create secret generic kemp-storage-secret --from-literal=azurestorageaccountname=kempstorage --from-literal=azurestorageaccountkey=0cXE6kGe75IzaNE+V/xKexRnSKI3Rjn8OkrLUo1dFRVlWP4L+sxH95rBmpHg2HBvQUuEnBdaWBrep4Cyv2NNtw==
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
az aks show --resource-group KempResourceGroup --name KempKube --query nodeResourceGroup -o tsv

MC_KempResourceGroup_KempKube_koreacentral  # 클러스터의 리소스 그룹 이름
```

#### INGRESS 용 IP
- az network 으로 고정 IP 주소 만들기 (resource-group : MC_KempResourceGroup_KempKube_koreacentral)
```
az network public-ip create \
    --resource-group MC_KempResourceGroup_KempKube_koreacentral \
    --name KempIngressIP \
    --sku Standard \
    --allocation-method static \
    --query publicIp.ipAddress -o tsv
    
52.141.35.112  
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
    --set controller.service.loadBalancerIP="52.141.35.112"
    
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
- 도메인이 결정 전 이라 kemp.onlinepowers.com 으로 우선 등록


##### saleson-ssl-secret 만들기
```
kubectl create secret tls saleson-ssl-secret \
    --namespace default \
    --key certs/ssl-onlinepowers.key \
    --cert certs/ssl-onlinepowers.crt
```

> 업체로 부터 ssl 인증서를 받아 ssl-secret을 사시 생성하고 ingress 수정 후 다시 적용해야함.
```
kubectl create secret tls kemp-ssl-secret \
    --namespace default \
    --key certs/ssl-kemp.key \
    --cert certs/ssl-kemp.crt
```

##### secret-key 설정시 아래와 같은 오류 발생
error: failed to load key pair tls: failed to parse private key

인증서 변환
```shell
$ mv ssl-kemp.key ssl-kemp.key.encrypted

$ openssl rsa -in ssl-kemp.key.encrypted -out ssl-kemp.key 
Enter pass phrase for ssl-kemp.key.encrypted:  (SSL 신청시 입력한 비밀번호 입력)


```

- azure-saleson-ingress.yaml 파일 수정 후 실행


### 성능 모니터링(Log Analytics)
ASK는 Azure Monitor 를 이용한 Container Insights 를 수집 하여 AKS 성능 모니터링을 진행함. (기본설정)
AKS 모니터링을 중단해야 모니터링 비용이 발생하지 않음.

> 모니터링 중단 방법 : https://docs.microsoft.com/ko-kr/azure/azure-monitor/insights/container-insights-optout

#### 모니터링 중단 방법
`az aks disable-addons` 명령을 사용하여 컨테이너 인사이트를 사용하지 않도록 설정합니다.
이 명령은 클러스터 노드에서 에이전트를 제거하지만, 이미 수집되어 Azure Monitor 리소스에 저장된 솔루션 또는 데이터는 제거하지 않습니다.

```shell
az aks disable-addons -a monitoring -n KempKube -g KempResourceGroup

```




## Jenkins 연동
> https://docs.microsoft.com/ko-kr/azure/aks/jenkins-continuous-deployment
> https://docs.microsoft.com/ko-kr/azure/developer/jenkins/deploy-from-github-to-aks

### Jenkins 환경 변수 만들기
Jenkins 관리 > 시스템 설정 > Global properties

- ACR_KEMP = kempregistry.azurecr.io


### ACR의 Jenkins 자격 증명 만들기
서비스 주체 생성
```
az ad sp create-for-rbac --skip-assignment

-- 출력
{
  "appId": "914627ff-f31d-4a80-928f-4bd7e4a0af6b",
  "displayName": "azure-cli-2021-08-12-01-46-10",
  "name": "914627ff-f31d-4a80-928f-4bd7e4a0af6b",
  "password": "62cH0a-YcNcCYC~jpGnCrUd.wXy-PXWc4I",
  "tenant": "c5e65d70-aaff-4e43-ae16-7bcde421bb1f"
}
```
Az ACR show 명령을 사용 하여 ACR 레지스트리의 리소스 ID를 가져오고 변수로 저장 합니다. 리소스 그룹 이름과 ACR 이름을 입력합니다.
이제 역할 할당을 만들어 ACR 레지스트리에 대한 서비스 주체 Contributor 권한을 할당합니다.

```
ACR_ID=$(az acr show --resource-group kempResourceGroup --name kempRegistry --query "id" --output tsv)
az role assignment create --assignee 914627ff-f31d-4a80-928f-4bd7e4a0af6b --role Contributor --scope $ACR_ID

-- 출력 
{
  "canDelegate": null,
  "condition": null,
  "conditionVersion": null,
  "description": null,
  "id": "/subscriptions/0f599d17-d8f4-47fa-924b-054e57638a7e/resourceGroups/KempResourceGroup/providers/Microsoft.ContainerRegistry/registries/KempRegistry/providers/Microsoft.Authorization/roleAssignments/55b46514-4993-4d37-8162-6121d67ba39a",
  "name": "55b46514-4993-4d37-8162-6121d67ba39a",
  "principalId": "c8fd923e-840c-4b33-ae8e-e4c23493d30a",
  "principalType": "ServicePrincipal",
  "resourceGroup": "KempResourceGroup",
  "roleDefinitionId": "/subscriptions/0f599d17-d8f4-47fa-924b-054e57638a7e/providers/Microsoft.Authorization/roleDefinitions/b24988ac-6180-42a0-ab88-20f7382dd24c",
  "scope": "/subscriptions/0f599d17-d8f4-47fa-924b-054e57638a7e/resourceGroups/KempResourceGroup/providers/Microsoft.ContainerRegistry/registries/KempRegistry",
  "type": "Microsoft.Authorization/roleAssignments"
}

```

#### Jenkins에서 ACR 서비스 주체의 자격 증명 리소스 만들기
Credentials > System > Global credentials (unrestricted) 메뉴에서 `Add Credentils`

- Kind: Username and Password
- Scope: Global (jenkins, nodes, items, all child items, etc)
- username: 914627ff-f31d-4a80-928f-4bd7e4a0af6b (ACR 레지스트리에 인증하기 위해 만든 서비스 주체의 appId입니다.)
- password: J0YNuQH5.6erfnx21VZlepNE3WXt11~5MJ (ACR 레지스트리에 인증하기 위해 만든 서비스 주체의 password입니다.)
- ID - acr-kemp-credentials  (자격 증명 식별자)
- Description: ACR-KEMP


### Kuberneties 인증토큰 생성
- jenkins에서 kubectl 명령을 사용하기 위해서는 token이 필요함.
- 토큰 생성 > Credentials 등록
- withCredentials를 이용하여 kubectl 명령 실행.


#### 1. 토큰생성
> https://github.com/jenkinsci/kubernetes-cli-plugin
순서대로 실행하여 토큰 복사함
```
$ kubectl -n default create serviceaccount jenkins-kemp-robot

$ kubectl -n default create rolebinding jenkins-kemp-robot-binding --clusterrole=cluster-admin --serviceaccount=default:jenkins-kemp-robot

$ kubectl -n default get serviceaccount jenkins-kemp-robot -o go-template --template='{{range .secrets}}{{.name}}{{"\n"}}{{end}}'

-- 출력
jenkins-kemp-robot-token-54pdl


$ kubectl -n default get secrets jenkins-kemp-robot-token-54pdl -o go-template --template '{{index .data "token"}}' | base64 -d

-- 출력 
eyJhbGciOiJSUzI1NiIsImtpZCI6ImhpS0xSVEpnZDM1a1VfSnJiM0FzUVN6WlRKdHkyaXpVczVTbDl4Z3ZPcHMifQ.eyJpc3MiOiJrdWJlcm5ldGVzL3NlcnZpY2VhY2NvdW50Iiwia3ViZXJuZXRlcy5pby9zZXJ2aWNlYWNjb3VudC9uYW1lc3BhY2UiOiJkZWZhdWx0Iiwia3ViZXJuZXRlcy5pby9zZXJ2aWNlYWNjb3VudC9zZWNyZXQubmFtZSI6ImplbmtpbnMta2VtcC1yb2JvdC10b2tlbi01NHBkbCIsImt1YmVybmV0ZXMuaW8vc2VydmljZWFjY291bnQvc2VydmljZS1hY2NvdW50Lm5hbWUiOiJqZW5raW5zLWtlbXAtcm9ib3QiLCJrdWJlcm5ldGVzLmlvL3NlcnZpY2VhY2NvdW50L3NlcnZpY2UtYWNjb3VudC51aWQiOiI1OWJjZWQwNC1lY2UxLTRmZTEtODlhMS0wMjc4ZWEwZDQxODEiLCJzdWIiOiJzeXN0ZW06c2VydmljZWFjY291bnQ6ZGVmYXVsdDpqZW5raW5zLWtlbXAtcm9ib3QifQ.MnwqwAYb9b6HvwoC-ldDxB7-wHA5D_tQ8jbmIiVT73q38T2e3TD2HwgYIRBxIt8LJRxGGCoAWEdarIvFo1QRUTsSwMdrEcDB0T_eoPWM8NWiSQKIs7eTJhMo7F4KVBvkoAZJxZaXXMRrku5ZzdfNyVgSLohBctjcJO0UmW4bbaC5qzj4aA19zs7bOuVcdu2wcQ3akLBq_8w1ePvvCLF4wZLE4wIqxZCUh-mfNwkeBkPO7gbOWB6Imc11BhN9ppcH6FP-ZVQvHzt8JYKtI6W3D2yc7zBHCJyA7I6ZHSFpQwn-sl5zARlnmx2FFCsfRiCynXQwmeWKWnCw01iqFiLH_G_8B-8tSGsz1LrW4fwy0M9MilUHGyh3wqflEyiykX2kwyXpe-9kwSx95JhmIaDDbi9o_EBgj-DGKzszV7a8Fupza0eMQxdSk42fSFOGa7yCB73x1A_ItwCo2XIW-ajOait3pxPxhLMIlt3GBHTsFxcdBm5amvzlslOut0G0TCotkq4Kna8idv0gPUGW4Vn_4jLcXj0N0rAn85u_rkHfQ8dDQWvDkXwByPW1y7FVhKqvBTdIHQlitTGIs8Xkskp-F1SWiLJqKjz1cUkFWW89AcsgMpZ7NEC0uMkz5RbYrwDya5YZVJUF3gDRb2VE-SiF417_fBDK8iZOtmKxf5kr9nw
```
> 토큰의 마지막이 %로 끝나는 경우 %는 토큰이 아님.


#### 2. Jenkins에서 Credential 생성
Credentials > System > Global credentials (unrestricted) 메뉴에서 `Add Credentils` 클릭

- Kind: Secret text
- Scope: Global (jenkins, nodes, items, all child items, etc)
- secret: eyJhbGciOiJSUzI1NiIsImtpZCI6ImhpS0xSVEpnZDM1a1VfSnJiM0FzUVN6WlRKdHkyaXpVczVTbDl4Z3ZPcHMifQ.eyJpc3MiOiJrdWJlcm5ldGVzL3NlcnZpY2VhY2NvdW50Iiwia3ViZXJuZXRlcy5pby9zZXJ2aWNlYWNjb3VudC9uYW1lc3BhY2UiOiJkZWZhdWx0Iiwia3ViZXJuZXRlcy5pby9zZXJ2aWNlYWNjb3VudC9zZWNyZXQubmFtZSI6ImplbmtpbnMta2VtcC1yb2JvdC10b2tlbi01NHBkbCIsImt1YmVybmV0ZXMuaW8vc2VydmljZWFjY291bnQvc2VydmljZS1hY2NvdW50Lm5hbWUiOiJqZW5raW5zLWtlbXAtcm9ib3QiLCJrdWJlcm5ldGVzLmlvL3NlcnZpY2VhY2NvdW50L3NlcnZpY2UtYWNjb3VudC51aWQiOiI1OWJjZWQwNC1lY2UxLTRmZTEtODlhMS0wMjc4ZWEwZDQxODEiLCJzdWIiOiJzeXN0ZW06c2VydmljZWFjY291bnQ6ZGVmYXVsdDpqZW5raW5zLWtlbXAtcm9ib3QifQ.MnwqwAYb9b6HvwoC-ldDxB7-wHA5D_tQ8jbmIiVT73q38T2e3TD2HwgYIRBxIt8LJRxGGCoAWEdarIvFo1QRUTsSwMdrEcDB0T_eoPWM8NWiSQKIs7eTJhMo7F4KVBvkoAZJxZaXXMRrku5ZzdfNyVgSLohBctjcJO0UmW4bbaC5qzj4aA19zs7bOuVcdu2wcQ3akLBq_8w1ePvvCLF4wZLE4wIqxZCUh-mfNwkeBkPO7gbOWB6Imc11BhN9ppcH6FP-ZVQvHzt8JYKtI6W3D2yc7zBHCJyA7I6ZHSFpQwn-sl5zARlnmx2FFCsfRiCynXQwmeWKWnCw01iqFiLH_G_8B-8tSGsz1LrW4fwy0M9MilUHGyh3wqflEyiykX2kwyXpe-9kwSx95JhmIaDDbi9o_EBgj-DGKzszV7a8Fupza0eMQxdSk42fSFOGa7yCB73x1A_ItwCo2XIW-ajOait3pxPxhLMIlt3GBHTsFxcdBm5amvzlslOut0G0TCotkq4Kna8idv0gPUGW4Vn_4jLcXj0N0rAn85u_rkHfQ8dDQWvDkXwByPW1y7FVhKqvBTdIHQlitTGIs8Xkskp-F1SWiLJqKjz1cUkFWW89AcsgMpZ7NEC0uMkz5RbYrwDya5YZVJUF3gDRb2VE-SiF417_fBDK8iZOtmKxf5kr9nw
- ID: kemp-kube-secret
- Description: [kemp] 클러스터의 secret key


#### 3. Jenkins Pipeline

acr-kemp-credentials
kemp-kube-secret


```
pipeline {
    agent any 
    tools {
        gradle 'Gradle 6.7'
        jdk 'OpenJDK 1.8.0_181'
    }
    environment { 
        SALESON_VERSION = '3.13.0'
        AZURE_CONTAINER_REGISTRY = 'kempregistry.azurecr.io'
    }
    stages {
        stage('Stage 1 : Prepare environment') {
            steps {
                echo 'Checkout Source!' 
                git branch: 'solution/kemp', credentialsId: 'gitlab-jenkins', url: 'http://git.onlinepowers.com:8080/saleson/saleson.git'
            }
        }

        stage('Stage 2 : Gradle build') {
            steps {
                echo 'Checkout Source!' 
                sh 'gradle clean build --exclude-task test'
            }
        }
        
        stage('Stage 3 : Build Docker Image & Push') {
            steps {
                echo "Build Docker Image & Push"
                
                withCredentials([usernamePassword(credentialsId: 'acr-kemp-credentials', passwordVariable: 'ACR_PASSWORD', usernameVariable: 'ACR_ID')]) {
                    sh '''
                        WEB_IMAGE_NAME="${AZURE_CONTAINER_REGISTRY}/kemp/saleson-web:${SALESON_VERSION}-${BUILD_NUMBER}"
                        docker build -t $WEB_IMAGE_NAME ./saleson-web
                        docker login ${AZURE_CONTAINER_REGISTRY} -u ${ACR_ID} -p ${ACR_PASSWORD}
                        docker push $WEB_IMAGE_NAME
                    '''
                    sh '''
                        API_IMAGE_NAME="${AZURE_CONTAINER_REGISTRY}/kemp/saleson-api:${SALESON_VERSION}-${BUILD_NUMBER}"
                        docker build -t ${API_IMAGE_NAME} ./saleson-api
                        docker login ${AZURE_CONTAINER_REGISTRY} -u ${ACR_ID} -p ${ACR_PASSWORD}
                        docker push $API_IMAGE_NAME
                    '''
                    
                    sh '''
                        FRONT_IMAGE_NAME="${AZURE_CONTAINER_REGISTRY}/kemp/saleson-front:${SALESON_VERSION}-${BUILD_NUMBER}"
                        docker build -t ${FRONT_IMAGE_NAME} ./saleson-front
                        docker login ${AZURE_CONTAINER_REGISTRY} -u ${ACR_ID} -p ${ACR_PASSWORD}
                        docker push $FRONT_IMAGE_NAME
                    '''
                    
                    
                }
            }
        }

        stage('Stage 4 : Deploy Azure Kubernetes') {
            steps {
                withKubeConfig([credentialsId: 'kemp-kube-secret', serverUrl:'https://kempkube-dns-f2ff4dfa.hcp.koreacentral.azmk8s.io']){
                    sh 'kubectl get all'
                    
                    
                    sh '''
                        WEB_IMAGE_NAME="${AZURE_CONTAINER_REGISTRY}/kemp/saleson-web:${SALESON_VERSION}-${BUILD_NUMBER}"
                        kubectl set image deployment/saleson-deployment saleson3=$WEB_IMAGE_NAME
                    '''
                    
                    sh '''
                        API_IMAGE_NAME="${AZURE_CONTAINER_REGISTRY}/kemp/saleson-api:${SALESON_VERSION}-${BUILD_NUMBER}"
                        kubectl set image deployment/saleson-api-deployment saleson3-api=$API_IMAGE_NAME
                    '''
                    
                    sh '''
                        FRONT_IMAGE_NAME="${AZURE_CONTAINER_REGISTRY}/kemp/saleson-front:${SALESON_VERSION}-${BUILD_NUMBER}"
                        kubectl set image deployment/saleson-front-deployment saleson3-front=$FRONT_IMAGE_NAME
                    '''
                }
            }
        }
    }
}
```












## Saleson Frontend (Azure 정적 웹사이트) - 2021.05.07 사용하지 않음 => front-service 이용
> https://docs.microsoft.com/ko-kr/azure/storage/blobs/storage-custom-domain-name?tabs=azure-portal

- 스토리지 > 정적 웹 사이트 : 정적 웹 사이트 => 사용 (Blob 스토리지를 사용함)
- 스토리지 > 엑세스 키 확인

### Filezilla Pro에서 Azure Storage에 접속 가능
#### 파일질라 Pro 다운로드 및 설치
- FileZilla Pro Key: 6V26-JC6Y-8ASJ-X84V-VWQR

#### 파일질라 접속 설정
파일질라로 접속하여 이미지파일 및 html(vue)파일을 업로드 한다.

* Frontend - Blob Storage
- 접속 URL: https://kempstorage.z12.web.core.windows.net/
- 프로토콜: Microsoft Azure Blob Storage Service
- host: blob.core.windows.net
- 스트리지계정: kempstorage
- 접근키 : 0cXE6kGe75IzaNE+V/xKexRnSKI3Rjn8OkrLUo1dFRVlWP4L+sxH95rBmpHg2HBvQUuEnBdaWBrep4Cyv2NNtw==

* Backend - File Storage
- 프로토콜: Microsoft Azure File Storage Service
- host: file.core.windows.net
- 스트리지계정: kempstorage
- 접근키 : 0cXE6kGe75IzaNE+V/xKexRnSKI3Rjn8OkrLUo1dFRVlWP4L+sxH95rBmpHg2HBvQUuEnBdaWBrep4Cyv2NNtw==



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




















