# Postman - Access Token

## Postman에서 환경 정보 설정 
- 설정 아이콘을 클릭하여 설정 함.
- 환경 정보에 환경 변수를 저장함.
- 저장된 환경 변수는 postman에서 {{환경변수}}와 같이 사용할 수 있음. 
- API 호출 시 저장된 환경 정보를 선택한 후 테스트 


## AccessToken 저장 하기 
Access Token을 조회하는 API 요청 화면의 `Tests` 탭에 아래와 같이 응답 정보를 환경변수에 할당하는 코드를 작성한다.

```javascript
var data = JSON.parse(responseBody);
postman.setEnvironmnetVariable("access_token", data.access_token);
postman.setEnvironmentVariable("refresh_token", data.refresh_token);
```


## Reference
- https://www.cragdoo.co.uk/2018/02/19/postman-access-token/