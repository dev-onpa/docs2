# SAP 연동 
## 연동 요약
- 업체에서 SAP과 연동할 항목을 정의해서 RFC를 제공 (parameter 정의)
- SAP에서 정의한 RFC를 호출하는 java용 라이브러리를 제공 (sapjco)
- sapjco 라이브러리는 CPU에 종속됨. (cpu, os 별로)
- sapjco 라이브러리에서 제공하는 기능을 이용하여 파라미터 등을 설정하고 RFC를 호출함.

> `RFC호출`:  실제로는 SAP에서 function을 만들고 외부에서 sapjco를 이용하여 해당 function을 실행하는 것.

## sapjco 연결 설정 (client)
- sapjco 라이브러리를 사용하기 위해서는 destination 정보 설정 필요. (SAP 접속 정보)
- 접속 정보 항목 (JCO_ASHOST, JCO_SYSNR, JCO_CLIENT, JCO_USER, JCO_PASSWD, JCO_LANG, JCO_POOL_CAPACITY, JCO_PEAK_LIMIT)
- java 연동 예제 (sapjco)
```java

 // RFC (function) 설정
 JCoFunction function = destination.getRepository().getFunction([RFC명]);

 // import parameter 설정 
 function.getImportParameterList().setValue(key, param.get(key));
 
 // RFC호출 (function 실행)
 function.execute(destination);
 
 // 결과  
 var xxx = function.getExportParameterList();
```


## 이전 프로젝트에서 SAP과 연동 했던 RFC 정의서 (참고용)
https://docs.google.com/spreadsheets/d/1AzKnFkwR2TdCN99LgQN8rnYHvYHNALprKbUqxLc027o/edit#gid=0

