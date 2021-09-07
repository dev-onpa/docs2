# Azure 사용량(usage) API 
> 2021.08.26 


## Query - Usage
> https://docs.microsoft.com/ko-kr/rest/api/cost-management/query/usage#querydataset


### PostMan clientsecret 만료 
- Azure portal > Azure Active Directory > Onlinepowers > 앱등록 > 모든 애플리케이션 > api-onlinepowers
- 인증서 및 암호 > `+ 새 클라이언트 암호`
- 등록 후 값에 해당하는 데이터를 clientsecret으로 사용하면됨.

#### 신규등록
- Azure portal > Azure Active Directory > Onlinepowers > 앱등록
- 앱을 신규로 등록해도 https://login.microsoftonline.com/{{tenantid}}/oauth2/token 인증이 가능함. 




### 질문 
Cost Management > Query - Usage API를 이용하여 데이터를 조회하려고 합니다 .
> https://aka.ms/costanalysis/api
> https://docs.microsoft.com/ko-kr/rest/api/cost-management/query/usage


API를 호출하기 위한 access_token은 받은 상태입니다.
구독ID가 459a1df5-548a-45ce-b665-b1c479d786e9 인 사용량을 조회하려고 할 때

API는
https://management.azure.com/subscriptions/459a1df5-548a-45ce-b665-b1c479d786e9/providers/Microsoft.CostManagement/query?api-version=2019-11-01

로 호출하고 조회 조건 등을 JSON 형식으로 보내야 하는데

조회 조건이
- 보기: 청구서 세부 정보
- 시작 날짜: 일, 8월 01, 2021
- 종료 날짜: 화, 8월 31, 2021
- 세분성: None
- 그룹화 기준: Meter

이고

조회할 데이터가 아래와 같다고 했을 때
PublisherType
ChargeType
ServiceFamily
ServiceName
Meter
PartNumber
CostUSD
Cost
Currency

위 조건으로 API를 호출하기 위한 요청 본문(Request Body - JSON 데이터) 을 보내주실 수 있을까요?
```json
// Request Body
// 위 조건에 해당하는 JSON 형식은??
{
"type": "Usage",
"timeframe": "TheLastBillingMonth",   // 이 값은 맞나요?
"dataset": {
// 무슨 데이터를 넣어야 할까요?
}
// 추가로 어떤 항목이 들어가야 위 조건에 맞는 데이터를 조회할 수 있을까요?
}
```