# CUCHEN Azure Infra 구성 
> 2021.02.15 
> 다우에서 이미 서비스들을 생성해둠. 

## Azure 계정 
- id: admin@cuchenmall.onmicrosoft.com
- pw: cuchen2021!!

## 리소스 그룹
- 리소스 그룹: RG-CuchenMall
- 영역: 한국 중부 


## AKS 정보
- 리소스 검색: aks > Kubernetes 클러스터 만들기
- Kubernetes 클러스터 이름: CuchenMall
- kubernetes 버전: 1.19.9
- 노드 풀 : 표준 DS2 v2 * 3ea

## 스토리지 계정생성
- 스토리지 계정 이름: cuchenmall


### 파일공유(File Share) 만들기
- cuchen-saleson : 라이선스 파일 (1GB)
- cuchen-storage : 첨부파일 경로 (5GB)

> cuchen-saleson/license/라이선스파일 업로드
> cuchen-saleson/upload/

## Container Registry (컨테이너 레지스트리)
- Container Registry 만들기
- 레지스트리 이름: cuchenmall
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
az aks get-credentials --resource-group RG-CuchenMall --name CuchenMall
```

## AKS 클러스터에 대한 ACR 통합 구성
```
az aks update -n CuchenMall -g RG-CuchenMall --attach-acr cuchenmall
```



### Docker Image 생성
1. Build Saleson 
```
gradle clean build --exclude-task test
```


2. Build docker
```
docker build -t cuchenmall.azurecr.io/cuchen/saleson-web:1 ./saleson-web
docker push cuchenmall.azurecr.io/cuchen/saleson-web:1
```

> docker push 시 unauthorized: authentication required 오류 발생 시 acr 인증 후 다시 push
> az acr login --name cuchenmall


3. deploy.sh (instead of 2, 3)
   docker image 생성 및 push (deploy.sh 파일 수정 필요!)
```
./deploy.sh
```



## 스토리지(cuchenmall) 연동
### Kubernetes Secret 만들기
- cuchen-storage-secret
- azurestorageaccountkey는 portal > 스토리지 계정 > 설정 > 엑세스 키에서 key1
```
kubectl create secret generic cuchen-storage-secret --from-literal=azurestorageaccountname=cuchenmall --from-literal=azurestorageaccountkey=Uw76hVPCEpf8zFfsSLiDJbEw27Y1QweBc+6tpxCkI+4p7Dx8dx8gBsThLdHttKMjX4b7jyWloWJPs1l6ElRuOg==
```

### StorageClass, PV, PVC 생성
```
kubectl apply -f saleson-kubernetes/cuchen-storage-pv.yaml
```


### pod / deployment 생성

saleson-*-deployment.yaml 파일을 수정한 후 생성


```
kubectl create -f saleson-kubernetes/cuchen-prod-frontend-deployment.yaml
kubectl create -f saleson-kubernetes/cuchen-prod-backend-deployment.yaml
kubectl create -f saleson-kubernetes/cuchen-dev-deployment.yaml
```




### Kubernetes 클러스터의 리소스 그룹에 고정IP 만들기
- 클러스터의 리소스 그룹 이름 조회
```
az aks show --resource-group RG-CuchenMall --name CuchenMall --query nodeResourceGroup -o tsv

MC_RG-CuchenMall_CuchenMall_koreacentral  # 클러스터의 리소스 그룹 이름
```

#### INGRESS 용 IP
- az network 으로 고정 IP 주소 만들기 (resource-group : MC_RG-CuchenMall_CuchenMall_koreacentral)
```
az network public-ip create \
    --resource-group MC_RG-CuchenMall_CuchenMall_koreacentral \
    --name CuchenMallIngressIP \
    --sku Standard \
    --allocation-method static \
    --query publicIp.ipAddress -o tsv
    
20.194.17.62   
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
    --set controller.service.loadBalancerIP="20.194.17.62"
    
```

```
helm install nginx-ingress ingress-nginx/ingress-nginx \
    --set controller.replicaCount=2 \
    --set controller.nodeSelector."beta\.kubernetes\.io/os"=linux \
    --set defaultBackend.nodeSelector."beta\.kubernetes\.io/os"=linux \
    --set controller.admissionWebhooks.patch.nodeSelector."beta\.kubernetes\.io/os"=linux \
    --set controller.service.loadBalancerIP="20.194.17.62"
    
```

3. helm 설치 목록 
```shell
$ helm list --namespace default
```


4. nginx-ingress 삭제 
```shell
helm uninstall nginx-ingress --namespace default
```


#### HTTPs Ingress
- SSL 인증서가 없어 우선 onlinepowers 인증서로 등록 


saleson-ssl-secret 만들기
```
kubectl create secret tls saleson-ssl-secret \
    --namespace default \
    --key certs/ssl-onlinepowers.key \
    --cert certs/ssl-onlinepowers.crt
```

> 업체로 부터 ssl 인증서를 받아 ssl-secret을 사시 생성하고 ingress 수정 후 다시 적용해야함.
```
kubectl create secret tls cuchen-ssl-secret \
    --namespace default \
    --cert certs/cuchenmall.co.kr.crt \
    --key certs/cuchenmall.co.kr.key
    
```

```
kubectl create secret tls cuchen-tls-secret3 \
    --namespace default \
    --cert certs/cuchenmall.co.kr.pem \
    --key certs/cuchenmall.co.kr.key
    
```

```
kubectl create secret tls cuchenmall-ssl-secret \
    --namespace default \
    --cert certs/cuchenmall.crt \
    --key certs/cuchenmall.key
    
```

- azure-saleson-ingress.yaml 파일 수정 후 실행




#### 라이선스 발급 및 적용
- Ingress 고정 IP 기준으로 라이선스 키를 발행하고 관련 정보를 수정


### 성능 모니터링(Log Analytics)
ASK는 Azure Monitor 를 이용한 Container Insights 를 수집 하여 AKS 성능 모니터링을 진행함. (기본설정)
AKS 모니터링을 중단해야 모니터링 비용이 발생하지 않음.

> 모니터링 중단 방법 : https://docs.microsoft.com/ko-kr/azure/azure-monitor/insights/container-insights-optout

#### 모니터링 중단 방법
`az aks disable-addons` 명령을 사용하여 컨테이너 인사이트를 사용하지 않도록 설정합니다.
이 명령은 클러스터 노드에서 에이전트를 제거하지만, 이미 수집되어 Azure Monitor 리소스에 저장된 솔루션 또는 데이터는 제거하지 않습니다.


```shell
# 적용하진 않음.(2021.07.02) : az aks disable-addons -a monitoring -n CuchenMall -g RG-CuchenMall

```




## MYSQL
### 운영 DB 
- host: cuchenmall.mysql.database.azure.com
- db: CUCHEN
- user: cuchenmall@cuchenmall
- pw: zncps92%@


### 개발 DB
- host: cuchenmall.mysql.database.azure.com
- db: CUCHEN_DEV
- user: cuchendev@cuchenmall
- pw: zncps92%@

----------- 여기까지 -----------


## Jenkins 연동
> https://docs.microsoft.com/ko-kr/azure/aks/jenkins-continuous-deployment
> https://docs.microsoft.com/ko-kr/azure/developer/jenkins/deploy-from-github-to-aks

### Jenkins 환경 변수 만들기
Jenkins 관리 > 시스템 설정 > Global properties

- ACR_CUCHEN = cuchenmall.azurecr.io


### ACR의 Jenkins 자격 증명 만들기
서비스 주체 생성
```
az ad sp create-for-rbac --skip-assignment

-- 출력
{
  "appId": "31deebe6-a285-4e2a-85c7-d926e2ca6f18",
  "displayName": "azure-cli-2021-05-06-01-08-14",
  "name": "http://azure-cli-2021-05-06-01-08-14",
  "password": "xsUMktpl.QIs3DBN5cEIIbdHd5x3SQY0_3",
  "tenant": "82aa5b9e-292a-4f7b-a48a-935ee7073d88"
}
```
Az ACR show 명령을 사용 하여 ACR 레지스트리의 리소스 ID를 가져오고 변수로 저장 합니다. 리소스 그룹 이름과 ACR 이름을 입력합니다.
이제 역할 할당을 만들어 ACR 레지스트리에 대한 서비스 주체 Contributor 권한을 할당합니다.

```
ACR_ID=$(az acr show --resource-group RG-CuchenMall --name cuchenmall --query "id" --output tsv)
az role assignment create --assignee 31deebe6-a285-4e2a-85c7-d926e2ca6f18 --role Contributor --scope $ACR_ID

-- 출력 
{
  "canDelegate": null,
  "condition": null,
  "conditionVersion": null,
  "description": null,
  "id": "/subscriptions/7acd0e44-c3cc-411e-aacb-387c50562d78/resourceGroups/RG-CuchenMall/providers/Microsoft.ContainerRegistry/registries/cuchenmall/providers/Microsoft.Authorization/roleAssignments/a13892b0-1cd2-485c-98b8-f101beb0a086",
  "name": "a13892b0-1cd2-485c-98b8-f101beb0a086",
  "principalId": "3f9a2952-f53b-47d8-9a9b-efadc21ff3be",
  "principalType": "ServicePrincipal",
  "resourceGroup": "RG-CuchenMall",
  "roleDefinitionId": "/subscriptions/7acd0e44-c3cc-411e-aacb-387c50562d78/providers/Microsoft.Authorization/roleDefinitions/b24988ac-6180-42a0-ab88-20f7382dd24c",
  "scope": "/subscriptions/7acd0e44-c3cc-411e-aacb-387c50562d78/resourceGroups/RG-CuchenMall/providers/Microsoft.ContainerRegistry/registries/cuchenmall",
  "type": "Microsoft.Authorization/roleAssignments"
}
```

#### Jenkins에서 ACR 서비스 주체의 자격 증명 리소스 만들기
Credentials > System > Global credentials (unrestricted) 메뉴에서 `Add Credentils`

- Kind: Username and Password
- Scope: Global (jenkins, nodes, items, all child items, etc)
- username: 31deebe6-a285-4e2a-85c7-d926e2ca6f18 (ACR 레지스트리에 인증하기 위해 만든 서비스 주체의 appId입니다.)
- password: xsUMktpl.QIs3DBN5cEIIbdHd5x3SQY0_3 (ACR 레지스트리에 인증하기 위해 만든 서비스 주체의 password입니다.)
- ID - acr-cuchen-credentials  (자격 증명 식별자)
- Description: ACR_CUCHEN


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
jenkins-robot-token-wkmgz


$ kubectl -n default get secrets jenkins-robot-token-wkmgz -o go-template --template '{{index .data "token"}}' | base64 -d

-- 출력 
eyJhbGciOiJSUzI1NiIsImtpZCI6IkxMbDdHTnlpZGR6c01fVHU2dmE3bTFobmIyUTN1d0hPSVc2NVdDYjFLQTgifQ.eyJpc3MiOiJrdWJlcm5ldGVzL3NlcnZpY2VhY2NvdW50Iiwia3ViZXJuZXRlcy5pby9zZXJ2aWNlYWNjb3VudC9uYW1lc3BhY2UiOiJkZWZhdWx0Iiwia3ViZXJuZXRlcy5pby9zZXJ2aWNlYWNjb3VudC9zZWNyZXQubmFtZSI6ImplbmtpbnMtcm9ib3QtdG9rZW4td2ttZ3oiLCJrdWJlcm5ldGVzLmlvL3NlcnZpY2VhY2NvdW50L3NlcnZpY2UtYWNjb3VudC5uYW1lIjoiamVua2lucy1yb2JvdCIsImt1YmVybmV0ZXMuaW8vc2VydmljZWFjY291bnQvc2VydmljZS1hY2NvdW50LnVpZCI6IjlkMjg2MWI0LTdmYjEtNGI2NS1iMmI2LWZiODhkZTYwYjE4ZSIsInN1YiI6InN5c3RlbTpzZXJ2aWNlYWNjb3VudDpkZWZhdWx0OmplbmtpbnMtcm9ib3QifQ.nmGw_eA6xsBgleK8dbCagA975OQFWCv7j2cWdbg09Ylt2rex1iPKvCtZVkDjZIh7An5qNcFE2bQLZpiGLrACnE8E46fnGxRr-YU9akCzYyvsvt1ixP_3a8QjLOhOEky_RFlSMr2k3BngkocjBZxnKoEk16bW9y2F9eBVzEsBwCA0XUypu8yZ4UAfJj7QlB_-bdZzoFViWPjFVTQaDAhsNEUpdM-Qt868ck6isjabGUy5uONpTi1G9xHmEEfWrdzUXN34Hqpvmdj-Ih8TtRDZqCQM2qJugO2fDS1DsR2JLmLs6_pVQjsHvexfmNOMgXa5hctxh-_ZM5y6PtqzDUE7Hg0vNG5cwyFXY9ibGP-OhHZISwmGyC0pShOHsHfHrO9lvDKs7IpSX28ukMQWplzkK6dp9nSSxx6n3UUZ2Wrca46Zw8aH3_sWdtC_kRAzXSZVGZLB3XCO4wDrJECx4q0PPJ5sU5YPL3vr28lmfKwoJbYpb5nI7JoR_jq3pWF5LQDkq7qmsjW3MVlpuREEs86QSrcJoEjDnAgP_1V5UgWe9L3_FAN9pkxfyI6QbrARi4kQRCTlOPQGyFNse1yK87Qq4kYl04U_NjE6XRHHdnvDVT3BguIKshVqEfzcg6729ir6e7gCFtj7PR8ms7vR7xRk85ubwnF_8hTmKEaI_8krLmg%
```
> 토큰의 마지막이 %로 끝나는 경우 %는 토큰이 아님.


#### 2. Jenkins에서 Credential 생성
Credentials > System > Global credentials (unrestricted) 메뉴에서 `Add Credentils` 클릭

- Kind: Secret text
- Scope: Global (jenkins, nodes, items, all child items, etc)
- secret: eyJhbGciOiJSUzI1NiIsImtpZCI6IkxMbDdHTnlpZGR6c01fVHU2dmE3bTFobmIyUTN1d0hPSVc2NVdDYjFLQTgifQ.eyJpc3MiOiJrdWJlcm5ldGVzL3NlcnZpY2VhY2NvdW50Iiwia3ViZXJuZXRlcy5pby9zZXJ2aWNlYWNjb3VudC9uYW1lc3BhY2UiOiJkZWZhdWx0Iiwia3ViZXJuZXRlcy5pby9zZXJ2aWNlYWNjb3VudC9zZWNyZXQubmFtZSI6ImplbmtpbnMtcm9ib3QtdG9rZW4td2ttZ3oiLCJrdWJlcm5ldGVzLmlvL3NlcnZpY2VhY2NvdW50L3NlcnZpY2UtYWNjb3VudC5uYW1lIjoiamVua2lucy1yb2JvdCIsImt1YmVybmV0ZXMuaW8vc2VydmljZWFjY291bnQvc2VydmljZS1hY2NvdW50LnVpZCI6IjlkMjg2MWI0LTdmYjEtNGI2NS1iMmI2LWZiODhkZTYwYjE4ZSIsInN1YiI6InN5c3RlbTpzZXJ2aWNlYWNjb3VudDpkZWZhdWx0OmplbmtpbnMtcm9ib3QifQ.nmGw_eA6xsBgleK8dbCagA975OQFWCv7j2cWdbg09Ylt2rex1iPKvCtZVkDjZIh7An5qNcFE2bQLZpiGLrACnE8E46fnGxRr-YU9akCzYyvsvt1ixP_3a8QjLOhOEky_RFlSMr2k3BngkocjBZxnKoEk16bW9y2F9eBVzEsBwCA0XUypu8yZ4UAfJj7QlB_-bdZzoFViWPjFVTQaDAhsNEUpdM-Qt868ck6isjabGUy5uONpTi1G9xHmEEfWrdzUXN34Hqpvmdj-Ih8TtRDZqCQM2qJugO2fDS1DsR2JLmLs6_pVQjsHvexfmNOMgXa5hctxh-_ZM5y6PtqzDUE7Hg0vNG5cwyFXY9ibGP-OhHZISwmGyC0pShOHsHfHrO9lvDKs7IpSX28ukMQWplzkK6dp9nSSxx6n3UUZ2Wrca46Zw8aH3_sWdtC_kRAzXSZVGZLB3XCO4wDrJECx4q0PPJ5sU5YPL3vr28lmfKwoJbYpb5nI7JoR_jq3pWF5LQDkq7qmsjW3MVlpuREEs86QSrcJoEjDnAgP_1V5UgWe9L3_FAN9pkxfyI6QbrARi4kQRCTlOPQGyFNse1yK87Qq4kYl04U_NjE6XRHHdnvDVT3BguIKshVqEfzcg6729ir6e7gCFtj7PR8ms7vR7xRk85ubwnF_8hTmKEaI_8krLmg
- ID: cuchen-kube-secret
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
                git branch: 'solution/cuchen', credentialsId: 'gitlab-jenkins', url: 'http://git.onlinepowers.com:8080/saleson/saleson.git'
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
                
                withCredentials([usernamePassword(credentialsId: 'acr-cuchen-credentials', passwordVariable: 'ACR_PASSWORD', usernameVariable: 'ACR_ID')]) {
                    sh '''
                        WEB_IMAGE_NAME="${ACR_CUCHEN}/cuchen/saleson-web:${SALESON_VERSION}-${BUILD_NUMBER}"
                        docker build -t $WEB_IMAGE_NAME ./saleson-web
                        docker login ${ACR_CUCHEN} -u ${ACR_ID} -p ${ACR_PASSWORD}
                        docker push $WEB_IMAGE_NAME
                    '''
                }
            }
        }

        stage('Stage 4 : Deploy Azure Kubernetes') {
            steps {
                withKubeConfig([credentialsId: 'cuchen-kube-secret', serverUrl:'https://cuchenmall-dns-d8ffc7e4.hcp.koreacentral.azmk8s.io']){
                    sh 'kubectl get all'
                    
                    sh '''
                        WEB_IMAGE_NAME="${ACR_CUCHEN}/cuchen/saleson-web:${SALESON_VERSION}-${BUILD_NUMBER}"
                        kubectl set image deployment/cuchen-front-deployment cuchen-front=$WEB_IMAGE_NAME
                        kubectl set image deployment/cuchen-admin-deployment cuchen-admin=$WEB_IMAGE_NAME
                    '''
                    
                }
            }
        }
    }
}
```


CUCHEN 접속 정보 
--------------
## IP
- ingress: 20.194.17.62
- egress: 20.194.60.47


## 데이터베이스 
### 운영 DB
- host: cuchenmall.mysql.database.azure.com
- db: CUCHEN
- user: cuchenmall@cuchenmall
- pw: zncps92%@

### 개발 DB
- host: cuchenmall.mysql.database.azure.com
- db: CUCHEN_DEV
- user: cuchendev@cuchenmall
- pw: zncps92%@


## 스토리지 계정 
파일 스토리지에 licence, payment, upload 파일등이 저장됨. 

### portal.azure.com 
- 스토리지계정 > 데이터 스토리지 > 파일공유

### 파일질라 Pro
- host: file.core.windows.net
- 스토리지 계정: cuchenmall
- 접근키: Uw76hVPCEpf8zFfsSLiDJbEw27Y1QweBc+6tpxCkI+4p7Dx8dx8gBsThLdHttKMjX4b7jyWloWJPs1l6ElRuOg==

### 디렉토리
#### 운영
- cuchen-saleson: license, payment
- cuchen-storage: upload

#### 개발 
- cuchen-saleson-dev: license, payment
- cuchen-storage-dev: upload


## 배포 
- 온파 Jenkins에 `cuchen-azure`로 배포 가능 (쿠첸 쪽 별도 구성해야함. )
- 운영 배포로만 구성함. 

## 접속 
- host 등록 필요. 

```
20.194.17.62   www.cuchenmall.co.kr
20.194.17.62   dev.cuchenmall.co.kr
```

## 접속확인 
- 운영: https://www.cuchenmall.co.kr
- 개발: http://dev.cuchenmall.co.kr



## 쿠첸몰 storage 변경 
> Standard -> Premium
> 2021.08.31 

### Kubernetes Secret 만들기
- cuchenmall-storage-secret
- 스토리지계정명: cuchenmall202108
- azurestorageaccountkey는 portal > 스토리지 계정 > 설정 > 엑세스 키에서 key1
```
kubectl create secret generic cuchenmall-storage-secret --from-literal=azurestorageaccountname=cuchenmall202108 --from-literal=azurestorageaccountkey=Xu18avnoQcpzcbHjfZSApESY3zOpmtadu1l6BeeZVWzGENrz5r4GkvT+Ag2OJmdM/wrOqkeGuAy/Wiv9eVvq4A==
```

### storage class
```
kubectl apply -f saleson-kubernetes/cuchenmall-pv.yaml
```


### 1시에 실행
1) 기존 deployment 삭제 
```
kubectl delete -f saleson-kubernetes/cuchen-deployment.yaml
```

2) 신규 deployment 삭제 (마지막 이미지로..)
```
kubectl apply -f saleson-kubernetes/cuchenmall-deployment.yaml
```

3) git push
```
git push
```

4) github 배포 

### pod / deployment 생성

saleson-*-deployment.yaml 파일을 수정한 후 생성