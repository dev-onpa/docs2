
문서의 내용을 참조하여 아래와 같이 테스트를 진행하였습니다.

### 1. 하위 도메인의 네임서버(NS) 레코드를 추가할 수 있는가? 
- Route53에서 하위도메인에 네임서버(NS) 레코드를 설정할 수 있는가? => 설정 가능 
- wix.com 도메인관리 메뉴에서 하위도메인에 네임서버(NS) 레코드를 설정할 수 있는가? => 설정 불가 


### 2. Route53에 네임서버(NS) 레코드를 추가하여 하위도메인의 서브도메인 관리가 가능한가? 
> 도메인: emoldino.tk  
> 하위도메인: aws.emoldino.tk (NS)  
> 서비스 도메인: site1.aws.emoldino.tk, site1.aws.emoldino.tk 로 설정 및 접속 가능 여부 확인   

-  하위 도메인을 새로운 호스트 영역으로 등록, 새로운 호스트 영역의 네임서버 정보를 루트 도메인의 NS레코드에 업데이트 
-  aws.emoldino.tk 호스트 영역에  site1.aws.emoldino.tk, site1.aws.emoldino.tk 의 레코드를 추가하여 서비스 가능함.


### 3. Route53에 wix의 네임서버 정보 값으로 네임서버(NS) 레코드를 추가하고 추가한 하위 도메인을 wix.com에서 관리가 가능한가?
> 도메인: emoldino.tk  
> 하위도메인: aws.emoldino.tk (NS - wix.com 네임서버 정보로 등록)  
> wix.com에서 도메인(aws.emoldino.tk) 도메인으로 연결 추가  

- 도메인 연결이 aws.emoldino.tk 도메인으로 연결되지 않고 emoldino.tk로 연결됨.
- http로 aws.emoldino.tk로 접속 시 사이트 접속은 가능.


### 4. wix.com 의 https 연결 설정 시 https로 연결 되는가? 
- SSL/TLS 보안 인증 절차가 진행되는 중에는 사이트 사용이 불가능합니다. 인증 절차가 모두 완료되려면 최대 1시간이 소요됩니다. 라는 메시지가 몇 시간이 지나도 동일하게 보임
- http / https 모두 접속되지 않음. 


### 5. 요약 
- Route53에서 하위 도메인에 대한 네임서버 설정이 가능함.
- wix.com에서는 네임서버 기반 하위 도메인은 연결할 수 없음. (aws.emoldino.tk 도메인 등록 시 emoldino.tk로 관리 됨)
- 하위 도메인은 연결 후 http://aws.emoldino.tk 은 가능하지만 https 기능 설정 시 http / https 모두 접속되지 않음. 





