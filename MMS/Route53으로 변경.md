# DNS를 Route53으로 변경 

## 1. AWS 기본 설정  
- EC2 / RDS 구성 및 접속 확인 (Dyson용)
- EC2 / RDS TimeZone 설정 (UTC+8, RDS는 타임존 설정 시 Asia/Kuala_Lump 가 없어서 Asia/Singapore 로 설정) 
- Route53에 emoldino.tk 호스틍 등록 및 레코드 설정
- ALB 설정 후 http -> https redirection 테스트 (리스너 규칙 추가)
- https://ds0124.emoldino.tk 접속 및 로그인 / 회원 추가 테스트 

- emoldino.com ALB 구성 중 멈춤 https 설정 불가 (인증서 생성이 안됨 - 아마도 도메인이 dns가 바뀌지 않아서인듯)
- DNS 변경 이후에 추가 작업 필요.


## 2. emoldino.com 설정 
### 1) 도메인 등록 업체에서 emoldino.com 도메인의 DNS 정보 변경
- 도메인 구입처에서 emoldino.com 도메인의 DNS 정보를 아래와 같이 수정.
  > `DNS 정보`  
  > ns-753.awsdns-30.net.  
  > ns-1984.awsdns-56.co.uk.  
  > ns-503.awsdns-62.com.   
  > ns-1281.awsdns-32.org

### 2) ACM에서 인증서 신청 (https)
- 도메인의 DNS 정보 변경 후 
- DNS 인증 필요.
- 적용 시간 약 20분 이상 

### 3) Route 53 
- 호스트 영역 정보 수정 
- 레코드 정보 추가 
- SSL 인증서 관련 레코드 추가 (CNAME)

### 4) ELB 설정 
- emoldino-alb 설정 추가 
- HTTPS 리스너 및 대상(ds0124) 추가 
- HTTP 규칙 추가 : Redirection 규칙 추가 (http -> https) 
- HTTPS 규칙 추가 : 호스트 기반 규칙 및 대상 추가 

### 5) 연결 확인 
- 메일 발송 확인 
    계정@emoldino.com 메일 발송 여부 확인.
    
- 브라우저 접속 확인 
    + https://ds0124.emoldino.com
  

### 6) Wix.com 설정 변경 
- 기존 도메인 정보 삭제
- 도메인 등록: www.emoldino.com 
- 연결 타입: 포인팅으로 설정
- http://www.emoldino.com 접속 확인 
 



# 도메인 이전 관련 메일 내용

## 사전 검토
1. Wix 및 AWS 도메인 이관 절차 검토
2. AWS Route53 에 host zone 등록 (emoldino.com)
3. wix에 설정된 DNS 정보를 Route 53에 등록


## 도메인 이전 작업
1. wix의 도메인 관리에서 다른 등록업체로 이전 및 코드 발송
2. 도메인 등록자 이메일(chris@emoldino.com)로 도메인 이전 코드 발송
3. Route53에서 도메인 이전 요청
    - 네임서버는 wix 유지
        ns2.wixdns.net
        ns3.wixdns.net
    - 이전 관련 정보 등록 (wix 이전 코드 등)

4. 이전 승인
    - 등록자 이메일로 승인메일 발송 및 승인 링크

5. 도메인 이전 소요 시간 : 약 7일
6. 도메인 이전 확인 후 도메인 네임서버 정보 변경
    - Route53 의 네임서버로 업데이트

7. 네임서버 변경 확인
