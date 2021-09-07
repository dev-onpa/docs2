# Nginx Ingress
> 2021.05.03 
> ssl, tls, 1.1 


nginx ingress 설정 시 TLS 버전이 1.2, 1.3이 기본 설정이다. 
Legacy 시스템에서 TLS 1.1 버전으로 사용하는 경우 연동 오류가 발생함. 

- windows7에 IE11 브라우저의 경우 TLS 1.1을 사용하여 Azure 접속 시 오류가 발생함.
- 외부 시스템에서 https로 azure 시스템에 데이터를 전송하는 경우 TLS 1.1 버전을 사용한다면 데이터를 정상적으로 수신할 수 없음. 


### Nginx Ingress에 TLS 버전 설정 
> https://docs.nginx.com/nginx-ingress-controller/installation/installation-with-helm/
> https://docs.microsoft.com/ko-kr/azure/aks/ingress-basic
> https://kubernetes.github.io/ingress-nginx/user-guide/tls/
> TLS 테스트: https://www.cdn77.com/tls-test

- 확인 중 .
- configMap에 설정하는 방법?
- ingress와 configMap은 어떻게 연결하는 가?
- helm으로 nginx-ingress 설정시 --set 옵션으로 configMap을 지정할 수 있는 듯
- kubectl get configmap 으로 확인해보면 `nginx-ingress-ingress-nginx-controller` 자동 생성되어 잇음.
- nginx-ingress-ingress-nginx-controller 를 수정하면 되는가?


```
$ kubectl describe configmap/nginx-ingress-ingress-nginx-controller

Name:         nginx-ingress-ingress-nginx-controller
Namespace:    default
Labels:       app.kubernetes.io/component=controller
              app.kubernetes.io/instance=nginx-ingress
              app.kubernetes.io/managed-by=Helm
              app.kubernetes.io/name=ingress-nginx
              app.kubernetes.io/version=0.46.0
              helm.sh/chart=ingress-nginx-3.30.0
Annotations:  <none>

Data
====
Events:  <none>

```