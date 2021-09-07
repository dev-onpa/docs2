# Github CI/CD
> 2021.08.31
> 쿠첸 ci/cd 


## github action
- 경로: .github/workflows
- 파일: release.yml, release-rollback.yml, stage.yml, stage-rollback.yml


### release.yml
```yaml
name: 릴리즈 배포 워크플로우

on:
  push:
    branches:
      - release

env:
  REGISTRY_NAME: cuchenmall
  TAG_PREFIX: cuchenmall.azurecr.io/cuchen/saleson

jobs:
  deploy:
    runs-on: ubuntu-latest
    steps:
    - uses: actions/checkout@v2
      with:
        ref: release
    
    - name: JDK 1.8 설치
      uses: actions/setup-java@v1
      with:
        java-version: 1.8
        
    - name: 권한처리
      run: |
        chmod +x gradlew
        chmod -R 777 ./saleson-web/.dockerfile/ant
        chmod -R 777 ./saleson-web/.dockerfile/conf
        
    - name: 그래들 빌드
      run: ./gradlew build --exclude-task test
      
    - name: Get current time
      uses: srfrnk/current-time@master
      id: current-time
      with:
        format: YYYYMMDDHHmmss

    - name: AzureCLI 로그인
      uses: azure/login@v1
      with:
        creds: ${{ secrets.AZURE_CREDENTIALS }}

    - name: AKS 인증정보
      run: az aks get-credentials --resource-group RG-CuchenMall --name CuchenMall

    - name: 도커 ACR 로그인
      uses: azure/docker-login@v1
      with:
        login-server: ${{ env.REGISTRY_NAME }}.azurecr.io
        username: ${{ secrets.REGISTRY_USERNAME }}
        password: ${{ secrets.REGISTRY_PASSWORD }}

    - name: 도커 빌드 및 푸시
      run: |
        docker build -t ${{ env.TAG_PREFIX }}-web:${{ steps.current-time.outputs.formattedTime }} ./saleson-web
        docker push ${{ env.TAG_PREFIX }}-web:${{ steps.current-time.outputs.formattedTime }}
    - name: AKS 배포
      run: |
        kubectl set image deployment.apps/cuchen-front-deployment cuchen-front=${{ env.TAG_PREFIX }}-web:${{ steps.current-time.outputs.formattedTime }} --record
        kubectl set image deployment.apps/cuchen-admin-deployment cuchen-admin=${{ env.TAG_PREFIX }}-web:${{ steps.current-time.outputs.formattedTime }} --record

```

### release-rollback.yml
```yaml
name: 💥 릴리즈 롤백

on:
  workflow_dispatch:

env:
  REGISTRY_NAME: cuchenmall
  TAG_PREFIX: cuchenmall.azurecr.io/cuchen/saleson

jobs:
  deploy:
    runs-on: ubuntu-latest
    steps:

    - name: Get current time
      uses: srfrnk/current-time@master
      id: current-time
      with:
        format: YYYYMMDDHHmmss

    - name: AzureCLI 로그인
      uses: azure/login@v1
      with:
        creds: ${{ secrets.AZURE_CREDENTIALS }}

    - name: AKS 인증정보
      run: az aks get-credentials --resource-group RG-CuchenMall --name CuchenMall

    - name: AKS 롤백 스크립트
      run: |
        kubectl rollout history deployment.apps/cuchen-front-deployment
        kubectl rollout history deployment.apps/cuchen-admin-deployment
        kubectl rollout undo deployment.apps/cuchen-front-deployment
        kubectl rollout undo deployment.apps/cuchen-admin-deployment
```

### stage.yml
```yaml
name: 스테이지 배포 워크플로우

on:
  workflow_dispatch:

env:
  REGISTRY_NAME: cuchenmall
  TAG_PREFIX: cuchenmall.azurecr.io/cuchen/saleson

jobs:
  deploy:
    runs-on: ubuntu-latest
    steps:
    - name: 슬랙 세팅
      id: slack
      uses: slackapi/slack-github-action@v1.14.0
      env:
        SLACK_WEBHOOK_URL: ${{ secrets.SLACK_WEBHOOK_URL }}

    - uses: actions/checkout@v2
      with:
        ref: stage
    
    - name: JDK 1.8 설치
      uses: actions/setup-java@v1
      with:
        java-version: 1.8
        
    - name: 권한처리
      run: |
        chmod +x gradlew
        chmod -R 777 ./saleson-web/.dockerfile/ant
        chmod -R 777 ./saleson-web/.dockerfile/conf
        
    - name: 그래들 빌드
      run: ./gradlew build --exclude-task test
      
    - name: Get current time
      uses: srfrnk/current-time@master
      id: current-time
      with:
        format: YYYYMMDDHHmmss

    - name: AzureCLI 로그인
      uses: azure/login@v1
      with:
        creds: ${{ secrets.AZURE_CREDENTIALS }}

    - name: AKS 인증정보
      run: az aks get-credentials --resource-group RG-CuchenMall --name CuchenMall

    - name: 도커 ACR 로그인
      uses: azure/docker-login@v1
      with:
        login-server: ${{ env.REGISTRY_NAME }}.azurecr.io
        username: ${{ secrets.REGISTRY_USERNAME }}
        password: ${{ secrets.REGISTRY_PASSWORD }}

    - name: 도커 빌드 및 푸시
      run: |
        docker build -t ${{ env.TAG_PREFIX }}-web:${{ steps.current-time.outputs.formattedTime }} ./saleson-web
        docker push ${{ env.TAG_PREFIX }}-web:${{ steps.current-time.outputs.formattedTime }}
    - name: AKS 배포
      run: |
        kubectl set image deployment.apps/cuchen-dev-deployment cuchen-dev=${{ env.TAG_PREFIX }}-web:${{ steps.current-time.outputs.formattedTime }} --record
```



### stage-rollback.yml
```yaml
name: 💥 스테이지 롤백

on:
  workflow_dispatch:

env:
  REGISTRY_NAME: cuchenmall
  TAG_PREFIX: cuchenmall.azurecr.io/cuchen/saleson

jobs:
  deploy:
    runs-on: ubuntu-latest
    steps:

    - name: Get current time
      uses: srfrnk/current-time@master
      id: current-time
      with:
        format: YYYYMMDDHHmmss

    - name: AzureCLI 로그인
      uses: azure/login@v1
      with:
        creds: ${{ secrets.AZURE_CREDENTIALS }}

    - name: AKS 인증정보
      run: az aks get-credentials --resource-group RG-CuchenMall --name CuchenMall

    - name: AKS 롤백 스크립트
      run: |
        kubectl rollout history deployment.apps/cuchen-dev-deployment
        kubectl rollout undo deployment.apps/cuchen-dev-deployment
```