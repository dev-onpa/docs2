# 더체크 (thecheck) Azure 구성 
> 2021.07.20 


## 접속계정
- 포털: portal.azure.com
- id: dev@onlinepowers.com
- pw: vkdnjtmakstp!1


## 리소스 그룹 생성
- 구독: 종량제 (생성 되어 있는 구독을 선택함 )
- 리소스 그룹: ThecheckResourceGroup
- 영역: 한국 중부

## AKS 생성
- 리소스 검색: aks > Kubernetes 클러스터 만들기
- Kubernetes 클러스터 이름: ThecheckKube
- kubernetes 버전: 1.19.1 (자동 설정값)
- 노드 풀 : 표준 DS2 v2 
- 크기 조정 방법: 수동 
- 노드 개수: 2

## 스토리지 계정생성
- 스토리지 계정 이름: thecheckstorage
- 성능: 표준
- 나머지 기본값.

### 파일공유(File Share) 만들기
> 기존 saleson(licence, log...) 와 storage(upload)로 구분하였으나 storage로 1개로 통일함.
- thecheck-storage : 첨부파일 경로 (50GB)

> thecheck-storage/license/라이선스파일 업로드
> thecheck-storage/upload/

## Container Registry (컨테이너 레지스트리)
- Container Registry 만들기
- 레지스트리 이름: ThecheckRegistry
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
az aks get-credentials --resource-group ThecheckResourceGroup --name ThecheckKube
```

### AKS 클러스터에 대한 ACR 통합 구성
```
az aks update -n ThecheckKube -g ThecheckResourceGroup --attach-acr ThecheckRegistry
```


### Kubernetes 클러스터의 리소스 그룹에 고정IP 만들기
- 클러스터의 리소스 그룹 이름 조회
```
az aks show --resource-group ThecheckResourceGroup --name ThecheckKube --query nodeResourceGroup -o tsv

MC_ThecheckResourceGroup_ThecheckKube_koreacentral  # 클러스터의 리소스 그룹 이름
```

#### INGRESS 용 IP
- az network 으로 고정 IP 주소 만들기 (resource-group : MC_ThecheckResourceGroup_ThecheckKube_koreacentral)
```
az network public-ip create \
    --resource-group MC_ThecheckResourceGroup_ThecheckKube_koreacentral \
    --name ThecheckIngressIP \
    --sku Standard \
    --allocation-method static \
    --query publicIp.ipAddress -o tsv
    
52.231.99.255  
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
    --set controller.service.loadBalancerIP="52.231.99.255"
    
```

3. helm 설치 목록
```shell
$ helm list --namespace default
```

4. nginx-ingress 삭제
```shell
helm uninstall nginx-ingress --namespace default
```




### Docker Image 생성
1. Saleson Build
```
gradle clean build --exclude-task test
```

2. Saleson API
```
cd saleson-api
docker build -t thecheckregistry.azurecr.io/thecheck/saleson-api:1.0.0-SNAPSHOT .
docker push thecheckregistry.azurecr.io/thecheck/saleson-api:1.0.0-SNAPSHOT
```

> docker push 시 unauthorized: authentication required 오류 발생 시 acr 인증 후 다시 push
> az acr login --name ThecheckRegistry

3. Saleson Web
```
cd ../saleson-web
docker build -t thecheckregistry.azurecr.io/thecheck/saleson-web:1.0.0-SNAPSHOT .
docker push thecheckregistry.azurecr.io/thecheck/saleson-web:1.0.0-SNAPSHOT
```

4. deploy.sh (instead of 2, 3)
   docker image 생성 및 push (deploy.sh 파일 수정 필요!)
```
./deploy.sh
```


## 스토리지(thecheckstorage) 연동
### Kubernetes Secret 만들기
- thecheck-storage-secret  (이름 고정)
- azurestorageaccountkey는 portal > 스토리지 계정 > 보안+네트워킹 > 엑세스 키에서 key1
```
kubectl create secret generic thecheck-storage-secret --from-literal=azurestorageaccountname=thecheckstorage --from-literal=azurestorageaccountkey=qu6SMrcagVhsBvVJab7HRngO6wWxRQu7yBK9Ul/7UES8XTVxXe6kBwvoRMP0QQSyCPBnjw7mRxycbt65ij7sCQ==
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



#### 라이선스 발급 및 적용
- Ingress 고정 IP 기준으로 라이선스 키를 발행하고 관련 정보를 수정




#### HTTPs Ingress
- ofm_thecheck_co_kr-ssl-secret 생성 
> 업체로 부터 ssl 인증서를 받아 ssl-secret을 사시 생성하고 ingress 수정 후 다시 적용해야함.

ofm_thecheck_co_kr.pem = crt + CA 로 새로 생성함. 

```
kubectl create secret tls ofm-thecheck-co-kr-ssl-secret \
    --namespace default \
    --cert certs/ofm.thecheck.co.kr.pem \
    --key certs/ofm.thecheck.co.kr.key
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
az aks disable-addons -a monitoring -n ThecheckKube -g ThecheckResourceGroup

```







## Jenkins 연동
> https://docs.microsoft.com/ko-kr/azure/aks/jenkins-continuous-deployment
> https://docs.microsoft.com/ko-kr/azure/developer/jenkins/deploy-from-github-to-aks

### Jenkins 환경 변수 만들기
Jenkins 관리 > 시스템 설정 > Global properties

- ACR_THECHECK = thecheckregistry.azurecr.io


### ACR의 Jenkins 자격 증명 만들기
서비스 주체 생성
```
az ad sp create-for-rbac --skip-assignment

-- 출력
{
  "appId": "d6235a58-d184-4ac7-a585-47e96682e2a0",
  "displayName": "azure-cli-2021-07-21-00-52-25",
  "name": "http://azure-cli-2021-07-21-00-52-25",
  "password": "S0fHFPZwb5rOXA7QFsI2jZjxkdEp0d_hn.",
  "tenant": "2d05ee32-f89c-40b3-9fcd-63ce21cf1b0e"
}
```
Az ACR show 명령을 사용 하여 ACR 레지스트리의 리소스 ID를 가져오고 변수로 저장 합니다. 리소스 그룹 이름과 ACR 이름을 입력합니다.
이제 역할 할당을 만들어 ACR 레지스트리에 대한 서비스 주체 Contributor 권한을 할당합니다.
--assignee : appId(d6235a58-d184-4ac7-a585-47e96682e2a0)

```
ACR_ID=$(az acr show --resource-group ThecheckResourceGroup --name ThecheckRegistry --query "id" --output tsv)
az role assignment create --assignee d6235a58-d184-4ac7-a585-47e96682e2a0 --role Contributor --scope $ACR_ID

-- 출력 
{
  "canDelegate": null,
  "condition": null,
  "conditionVersion": null,
  "description": null,
  "id": "/subscriptions/8b49580b-df09-4214-b360-eea8b1cd1776/resourceGroups/ThecheckResourceGroup/providers/Microsoft.ContainerRegistry/registries/ThecheckRegistry/providers/Microsoft.Authorization/roleAssignments/23314257-bc5c-4f00-ba19-9b0aa2b2feed",
  "name": "23314257-bc5c-4f00-ba19-9b0aa2b2feed",
  "principalId": "8df8f135-a542-42eb-b04f-850c018632bb",
  "principalType": "ServicePrincipal",
  "resourceGroup": "ThecheckResourceGroup",
  "roleDefinitionId": "/subscriptions/8b49580b-df09-4214-b360-eea8b1cd1776/providers/Microsoft.Authorization/roleDefinitions/b24988ac-6180-42a0-ab88-20f7382dd24c",
  "scope": "/subscriptions/8b49580b-df09-4214-b360-eea8b1cd1776/resourceGroups/ThecheckResourceGroup/providers/Microsoft.ContainerRegistry/registries/ThecheckRegistry",
  "type": "Microsoft.Authorization/roleAssignments"
}

```

#### Jenkins에서 ACR 서비스 주체의 자격 증명 리소스 만들기
Credentials > System > Global credentials (unrestricted) 메뉴에서 `Add Credentils`

- Kind: Username and Password
- Scope: Global (jenkins, nodes, items, all child items, etc)
- username: d6235a58-d184-4ac7-a585-47e96682e2a0 (ACR 레지스트리에 인증하기 위해 만든 서비스 주체의 appId입니다.)
- password: S0fHFPZwb5rOXA7QFsI2jZjxkdEp0d_hn. (ACR 레지스트리에 인증하기 위해 만든 서비스 주체의 password입니다.)
- ID - acr-thecheck-credentials  (자격 증명 식별자)
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
jenkins-robot-token-thfs2


$ kubectl -n default get secrets jenkins-robot-token-thfs2 -o go-template --template '{{index .data "token"}}' | base64 -d

-- 출력 
eyJhbGciOiJSUzI1NiIsImtpZCI6Ii13ODBLTGY5cmVGRmdWWGdGV2JSekFlbE9EQ0hDVldTQVpXNFZyVW1jR2sifQ.eyJpc3MiOiJrdWJlcm5ldGVzL3NlcnZpY2VhY2NvdW50Iiwia3ViZXJuZXRlcy5pby9zZXJ2aWNlYWNjb3VudC9uYW1lc3BhY2UiOiJkZWZhdWx0Iiwia3ViZXJuZXRlcy5pby9zZXJ2aWNlYWNjb3VudC9zZWNyZXQubmFtZSI6ImplbmtpbnMtcm9ib3QtdG9rZW4tdGhmczIiLCJrdWJlcm5ldGVzLmlvL3NlcnZpY2VhY2NvdW50L3NlcnZpY2UtYWNjb3VudC5uYW1lIjoiamVua2lucy1yb2JvdCIsImt1YmVybmV0ZXMuaW8vc2VydmljZWFjY291bnQvc2VydmljZS1hY2NvdW50LnVpZCI6ImJhMzUyMDFmLTk0YmUtNGIxNy05M2Y4LWY4NDgxYzJkZTg3YSIsInN1YiI6InN5c3RlbTpzZXJ2aWNlYWNjb3VudDpkZWZhdWx0OmplbmtpbnMtcm9ib3QifQ.PMCIDh88h_Ux2z25kldltt6RJIeoHBb_O4dG6RZS1lOhD8UrYbYsCatQ57umc4hKp3DaxIrrEPbImgA4LLs_2BI8UHysAU_u2yJ9sL1zAIc4zbJe3AYX6p3hHnkOVfir_b280MgpTvqV7CeAJCa2ApOSgMwb46qeTFqJPmqicpoSIrhIVKsQWJOIKkdEMOME1RBBFRC_bqc2YqsQ433LRP-D1WwG-vr4iv0amAGsAEQnJ6RTv8J27gDcDIvJNFsDzds93VXy8n035VtpTeM1X_Vc_ZDFmzXWcUnLrwl1u72xpS7W4z-nQSFYvdx_p0g46J3FSp5hN6dmHTiCbyhy2XpaoEq--DpBaKE3pjdlS1TcODBJIOaCaZA6w3rWMpn-ZpVZZo3-ynKZEsx_o7DF7FZnzYHDeWjm7465DzO5Vim1jiL15GDJgmFPtQWolCigLANv5-GPbM-8qT9ryNmIwFAd2qPmuiRMeL9pkJkxUw-Nj6opUNxfXiMIbucCj5QmVJqXE7lzbAm_RIZPvDbcWXMAKNL_-OP-28M-Sh6oIMTY5TyzjPp58L0lrGMB3YwRQCNebBBsNjNzXi2NukU4BrY2_aQuCBTAZAq1HHokAC8laq2JP7y-GvzNg4MKjVbjva78r34RBiRUX9rF33nFUFe1cUjAmxFAXcuo-V1a_Ow%
```
> 토큰의 마지막이 %로 끝나는 경우 %는 토큰이 아님.


#### 2. Jenkins에서 Credential 생성
Credentials > System > Global credentials (unrestricted) 메뉴에서 `Add Credentils` 클릭

- Kind: Secret text
- Scope: Global (jenkins, nodes, items, all child items, etc)
- secret: eyJhbGciOiJSUzI1NiIsImtpZCI6Ii13ODBLTGY5cmVGRmdWWGdGV2JSekFlbE9EQ0hDVldTQVpXNFZyVW1jR2sifQ.eyJpc3MiOiJrdWJlcm5ldGVzL3NlcnZpY2VhY2NvdW50Iiwia3ViZXJuZXRlcy5pby9zZXJ2aWNlYWNjb3VudC9uYW1lc3BhY2UiOiJkZWZhdWx0Iiwia3ViZXJuZXRlcy5pby9zZXJ2aWNlYWNjb3VudC9zZWNyZXQubmFtZSI6ImplbmtpbnMtcm9ib3QtdG9rZW4tdGhmczIiLCJrdWJlcm5ldGVzLmlvL3NlcnZpY2VhY2NvdW50L3NlcnZpY2UtYWNjb3VudC5uYW1lIjoiamVua2lucy1yb2JvdCIsImt1YmVybmV0ZXMuaW8vc2VydmljZWFjY291bnQvc2VydmljZS1hY2NvdW50LnVpZCI6ImJhMzUyMDFmLTk0YmUtNGIxNy05M2Y4LWY4NDgxYzJkZTg3YSIsInN1YiI6InN5c3RlbTpzZXJ2aWNlYWNjb3VudDpkZWZhdWx0OmplbmtpbnMtcm9ib3QifQ.PMCIDh88h_Ux2z25kldltt6RJIeoHBb_O4dG6RZS1lOhD8UrYbYsCatQ57umc4hKp3DaxIrrEPbImgA4LLs_2BI8UHysAU_u2yJ9sL1zAIc4zbJe3AYX6p3hHnkOVfir_b280MgpTvqV7CeAJCa2ApOSgMwb46qeTFqJPmqicpoSIrhIVKsQWJOIKkdEMOME1RBBFRC_bqc2YqsQ433LRP-D1WwG-vr4iv0amAGsAEQnJ6RTv8J27gDcDIvJNFsDzds93VXy8n035VtpTeM1X_Vc_ZDFmzXWcUnLrwl1u72xpS7W4z-nQSFYvdx_p0g46J3FSp5hN6dmHTiCbyhy2XpaoEq--DpBaKE3pjdlS1TcODBJIOaCaZA6w3rWMpn-ZpVZZo3-ynKZEsx_o7DF7FZnzYHDeWjm7465DzO5Vim1jiL15GDJgmFPtQWolCigLANv5-GPbM-8qT9ryNmIwFAd2qPmuiRMeL9pkJkxUw-Nj6opUNxfXiMIbucCj5QmVJqXE7lzbAm_RIZPvDbcWXMAKNL_-OP-28M-Sh6oIMTY5TyzjPp58L0lrGMB3YwRQCNebBBsNjNzXi2NukU4BrY2_aQuCBTAZAq1HHokAC8laq2JP7y-GvzNg4MKjVbjva78r34RBiRUX9rF33nFUFe1cUjAmxFAXcuo-V1a_Ow
- ID: thecheck-kube-secret
- Description: [thecheck] 클러스터의 secret key


#### 3. Jenkins Pipeline
```
pipeline {
    agent any 
    tools {
        jdk "OpenJDK 11"
        gradle 'Gradle 7.0.2'
    }
    environment { 
        SALESON_VERSION = '3.14.0'
        c = 'thecheckregistry.azurecr.io'
    }
    stages {
        stage('Stage 1 : Prepare environment') {
            steps {
                echo 'Checkout Source!' 
                git branch: 'solution/thecheck-3.14.0', credentialsId: 'gitlab-jenkins', url: 'http://git.onlinepowers.com:8080/saleson/saleson.git'
            }
        }

        stage('Stage 2 : Gradle build') {
            steps {
                echo 'Gradle build' 
                sh 'gradle clean build --exclude-task test'
            }
        }
        
        stage('Stage 3 : Build Docker Image & Push') {
            steps {
                echo "Build Docker Image & Push"
                
                withCredentials([usernamePassword(credentialsId: 'acr-thecheck-credentials', passwordVariable: 'ACR_PASSWORD', usernameVariable: 'ACR_ID')]) {
                    sh '''
                        WEB_IMAGE_NAME="${AZURE_CONTAINER_REGISTRY}/thecheck/saleson-web:${SALESON_VERSION}-${BUILD_NUMBER}"
                        docker build -t $WEB_IMAGE_NAME ./saleson-web
                        docker login ${ACR_THECHECK} -u ${ACR_ID} -p ${ACR_PASSWORD}
                        docker push $WEB_IMAGE_NAME
                    '''
                    sh '''
                        API_IMAGE_NAME="${AZURE_CONTAINER_REGISTRY}/thecheck/saleson-api:${SALESON_VERSION}-${BUILD_NUMBER}"
                        docker build -t ${API_IMAGE_NAME} ./saleson-api
                        docker login ${ACR_THECHECK} -u ${ACR_ID} -p ${ACR_PASSWORD}
                        docker push $API_IMAGE_NAME
                    '''
                    
                    sh '''
                        FRONT_IMAGE_NAME="${AZURE_CONTAINER_REGISTRY}/thecheck/saleson-front:${SALESON_VERSION}-${BUILD_NUMBER}"
                        docker build -t ${FRONT_IMAGE_NAME} ./saleson-frontend
                        docker login ${ACR_THECHECK} -u ${ACR_ID} -p ${ACR_PASSWORD}
                        docker push $FRONT_IMAGE_NAME
                    '''
                    
                    
                }
            }
        }

        stage('Stage 4 : Deploy Azure Kubernetes') {
            steps {
                withKubeConfig([credentialsId: 'thecheck-kube-secret', serverUrl:'https://ThecheckKube-dns-719680fe.hcp.koreacentral.azmk8s.io']){
                    sh 'kubectl get all'
                    
                    
                    sh '''
                        WEB_IMAGE_NAME="${AZURE_CONTAINER_REGISTRY}/thecheck/saleson-web:${SALESON_VERSION}-${BUILD_NUMBER}"
                        kubectl set image deployment/saleson-web-deployment saleson-web=$WEB_IMAGE_NAME
                    '''
                    
                    sh '''
                        API_IMAGE_NAME="${AZURE_CONTAINER_REGISTRY}/thecheck/saleson-api:${SALESON_VERSION}-${BUILD_NUMBER}"
                        kubectl set image deployment/saleson-api-deployment saleson-api=$API_IMAGE_NAME
                    '''
                    
                    sh '''
                        FRONT_IMAGE_NAME="${AZURE_CONTAINER_REGISTRY}/thecheck/saleson-api:${SALESON_VERSION}-${BUILD_NUMBER}"
                        kubectl set image deployment/saleson-front-deployment saleson-front=$FRONT_IMAGE_NAME
                    '''
                }
            }
        }
    }
}
```


