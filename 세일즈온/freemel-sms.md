# FreemelSMS 

세일즈온 솔루션 판매 후 온파 freemel sms를 사용하는 경우 

## 확인사항 
- 발신번호 확인 : 발신번호를 등록해야 함.
- SMS를 발송 서버 IP : 운영, 개발

## 계정생성 
http://sms.webpost.co.kr/common/login.php (root / xxxxxxxx) 

관리자 메뉴 > 추가 


## 발신번호 등록 
- 마이스소프트 : 김대현 과장 070-4705-9426


## 세일즈온 적용 방범
application.properties freemelSMS 설정값 변경  
```
# Freemel SMS 
freemelSMS.tranId={계정ID}
freemelSMS.sendUrl=http://sms.webpost.co.kr/sms/sms_grp_post.html
freemelSMS.sender={발신자명}
```


