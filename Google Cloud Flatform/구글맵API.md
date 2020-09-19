# 구글맵 API 연동 (google map)


## 연동 절차 
1. 구글 클라우드 플랫폼 (https://console.cloud.google.com)  접속 후 결제 정보 등록
- 구글 클라우드 플랫폼네 접속 후 '결제' 메뉴에서 결제 정보를 등록해야 합니다.
- 기본 사용량 이상 사용하는 경우 등록된 정보로 결제됨.
- sales@emoldino.com / !Chris6388  


2. 구글 클라우드 플랫폼 - 프로젝트 생성 

3. 라이브러리 > 구글맵 API  활성화 

4. 사용자 인증 정보 등록

5. 구글맵 API 키 확인 후 연동작업..
- Api > Credentials 메뉴에서 API KEY 확인 가능.


## 언어 및 지역 설정
> https://developers.google.com/maps/documentation/javascript/localization
- language: ja
- region: JP

```html
<script src="https://maps.googleapis.com/maps/api/js?key=YOUR_API_KEY&language=ja&region=JP">
</script>
```