# SSL 인증서 적용하기 
> 2021.04.13


## SSL 인증서 신청 후 발급 받은 인증서 
- *.pfx: IIS 서버용
- *.jks: Tomcat, WebLogic, JEUS, Resin 서버 
- *.crt, *.key: Apache (아파치는 인증서, CA인증서를 따로 설정할 수 있음)
- *.pem: WebToB, Nginx (CA인증서를 따로 설정할 수 없어 cert, cacert 를 하나의 파일로 합쳐야함.)


## Key파일 비밀번호 없애기 
### Key파일 내용 확인하기 
Key파일에 Porc-Type, DEK-INFO 의 내용이 보인다면 비밀번호가 설정되어 있다고 생각하면됨. 

```shell
$ vi onlinepowers_com.key

-----BEGIN RSA PRIVATE KEY-----
Proc-Type: 4,ENCRYPTED
DEK-Info: DES-EDE3-CBC,66659034211D4C4F

wWkR71sa+xeHWdevl9K4Vq+QfMd2QmY2FAUTtmTbGctnwqq33ndUGXNQlG9iCkLf
hgGsIYvlaCgUW7f5ZnXa7GNrjtO7M9AlXo4BzjsZGarKdZv/qjZ6ioi9n1wVWUI2
....

```

인증서 변환 
```shell
$ mv onlinepowers_com.key onlinepowers_com.key.encrypted

$ openssl rsa -in onlinepowers_com.key.encrypted -out onlinepowers_com.key 
Enter pass phrase for onlinepowers_com.key.encrypted:  (SSL 신청시 입력한 비밀번호 입력)


```

변환 후 파일 : 다음과 같이 pass phrase가 제거됨 (Proc-Type, DEK-Info 항목이 사라짐) 

```shell
$ mv onlinepowers_com.key

-----BEGIN RSA PRIVATE KEY-----
wWkR71sa+xeHWdevl9K4Vq+QfMd2QmY2FAUTtmTbGctnwqq33ndUGXNQlG9iCkLf
hgGsIYvlaCgUW7f5ZnXa7GNrjtO7M9AlXo4BzjsZGarKdZv/qjZ6ioi9n1wVWUI2
....

```

## CA인증서가 없는 경우
- 외부에서 SSL 통신 시 오류 발생 (가상계좌 입금 통보시 : 리뉴올PC, druh)  
```
Exceptiion : sun.security.validator.ValidatorException: PKIX path building failed: sun.security.provider.certpath.SunCertPathBuilderException: unable to find valid certification path to requested target
```

- cert파일과 CA cert 파일을 하나로 합쳐서 사용할 것!!



## Azure Key Vault (키 자격증명 모음)
Azure Key Vault > 비밀 : application/x-pkcs12 인증서를 Ingress에 적용하기 
- 해당 인증서를 클릭해서 상세 화면에서 `인증서로 다운로드` 하면 pfx 인증서를 다운로드 할 수 있음. 

### pfx 에서 crt, key 파일 추출해서 적용하기 
1. Extract the .key file from the .pfx file:
```shell
openssl pkcs12 -in cuchenmall.pfx -nocerts -out cuchenmall.key

# 인증서 비밀번호??
Enter Import Password:
Mac verify error: invalid password?
```

2. Decrypt the .key file:
```shell
openssl rsa -in cuchenmall.key -out cuchenmall.decrypted.key
```

3. Extract the .crt file from .pfx file:
```shell
openssl pkcs12 -in cuchenmall.pfx -clcerts -nokeys -out cuchenmall.crt
```

4. Create a secret in your Kubernetes cluster:
```shell
kubectl create secret tls cuchenmall-ssl-secret --cert cuchenmall.crt --key cuchenmall.decrypted.key
```


### 인증서 추출 및 변환 
> https://ykarma1996.tistory.com/84
> https://blog.hapinus.com/2020/openssl-changing-certificate-pfx-pem-p7b/
```
openssl pkcs12 -in ofm.pfx -nocerts -nodes -out my.key --password pass:82022
openssl pkcs12 -in ofm.pfx -clcerts -nokeys -out my.crt --password pass:82022
openssl pkcs12 -in ofm.pfx -cacerts -nokeys -chain -out ca_my.pem --password pass:82022



openssl pkcs12 -in ofm.pfx -nokeys -out ofm.pem -nodes 
openssl pkcs12 -in ofm.pfx -nocerts -out ofm.key -nodes 
openssl pkcs12 -in ofm.pfx -cacerts -nokeys -chain -out ca-ofm.cer

kubectl create secret tls ofm_thecheck_co_kr-ssl-secret \
    --namespace default \
    --key ofm.pem \
    --cert ofm.key


```


### akv2k8s Helm Chart
> https://github.com/SparebankenVest/public-helm-charts/tree/master/stable/akv2k8s
> https://stackoverflow.com/questions/58603406/kubernetes-no-matches-for-kind-azurekeyvaultsecret-in-version-v1

akv2k8s Helm Chart를 이용해서 keyVault => secret으로 바로 생성하기 

#### 1. To install the latest stable chart with the release name akv2k8s:
```shell
helm repo add spv-charts http://charts.spvapi.no
helm install akv2k8s spv-charts/akv2k8s
```

For the latest version:
```shell
helm repo add spv-charts http://charts.spvapi.no
helm install akv2k8s spv-charts/akv2k8s --version 2.0.11
```

#### 2. cuchen-keyvault-ssl.yaml 생성
```yaml
apiVersion: spv.no/v2beta1
kind: AzureKeyVaultSecret
metadata:
  name: ingress-cert
  namespace: default
spec:
  vault:
    name: cuchenmall38611a8c-eb89-4cbf-9140-76b51685fbaa # name of key vault
    object:
      name: cuchenmall  
      type: certificate # 고정
  output:
    secret:
      name: cuchenmall-ssl-secret # kubernetes secret name
      type: kubernetes.io/tls # kubernetes secret type

```

#### 3. secret 생성 
```shell
kubectl apply -f cuchen-keyvault-ssl.yaml
```


#### 4. secret 생성 확인 
```shell
kubectl get secret 


NAME                                                   TYPE                                  DATA   AGE
akv2k8s-controller-token-jdfwd                         kubernetes.io/service-account-token   3      41m
akv2k8s-envinjector-ca                                 kubernetes.io/tls                     3      41m
akv2k8s-envinjector-tls                                kubernetes.io/tls                     3      41m
```

#### 5. Ingress 수정 
```yaml
...
spec:
  tls:
    - hosts:
        - cuchenmall.co.kr
        - www.cuchenmall.co.kr
      #secretName: saleson-ssl-secret
      secretName: akv2k8s-envinjector-tls
...
```

#### 6. 브라우저 인증서 정보 
```
Kubernetes Ingress Controller Fake Cerificate
자체 서명된 루트 인증서 
사용 만료: 2022년 5월 10일 화요일 오후 2시 1분 55초 대한민국 표준시
^ 이 인증서는 타사에 의해 검증되지 않았습니다.  
```


#### 7. Uninstall 
```
helm uninstall akv2k8s spv-charts/akv2k8s

kubectl delete -f cuchen-keyvault-ssl.yaml


```