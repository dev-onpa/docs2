안녕하세요. 신극창입니다.

어제 말씀 주신 문서 검토 내용입니다.

우선 현재 미국 동부 (오하이오) 리전에 AWS Instance가 실행 중이고 
22번 이메일을 통해 비밀번호 초기화 하는 부분은 아직 구현 전입니다.


12
Are all aspects of your provision located within the EU? If not, can you tell us the locations?
Current instance is located in the AWS Seoul region. But for production, we are considering Frankfurt region (To be checked for confirming)

22
If any part of the application or service employs username/password-based authentication, how does the application or service store passwords, and how is account recovery handled?
We’re currently using the Bcrypt algorithm for storing  passwords. And we support reset via email address. 
> 이메일을 통한 초기화는 구현되지 않았음.

23
Will you encrypt Dyson’s data at rest (including backups)? If so, what encryption standards will be used?
Yes. We will encrypt Dyson's data using the industry standard AES-256 encryption algorithm
> AWS RDS 암호회 기능 
> https://docs.aws.amazon.com/ko_kr/AmazonRDS/latest/UserGuide/Overview.Encryption.html

30
In which countries will the data be stored? 
Current instance is located in AWS Seoul region. But for production, we are considering Frankfurt region
> 미국 동부 오하이오

41
Are your data centres geographically dispersed? To what locations outside the EU?
Data is distributed by availability zone in AWS. Location은 확인해야 함
> 미국 동부 오하이오

44
Are applications developed following secure coding practices (e.g. OWASP)?
> No but we’re in the process of developing the company’s secure coding practices
> 오픈소스(SonarQube)를 이용하여 static application security tests 가 가능함. (OWASP 항목 포함)

45
Do you perform static/dynamic application security tests against systems holding Dyson data?
> 오픈소스(SonarQube)를 이용하여 SAST 점검
> 오픈소스(OWASP ZAP)이나 상용(Acunetix)로 DAST 가능 

http://www.opennaru.com/opennaru-blog/owasp-zap-devops-and-security/




안녕하세요신극창입니다. 
Dyson AWS 아키텍처를 첨부하였습니다. 확인부탁드립니다.

그리고 어제 문서 항목 중 Region 관련 내용을 제외하고검토한 내용을 간단히 정리하였습니다. 

#22. ... how is account recovery handled?
- 이메일을 통한 비밀번호 초기화는 기능은 아직 구현되지 않았습니다.

#23. Will you encrypt Dyson’s data at rest (including backups)? 
- AWS RDS 리소스 암호화를 적용하면 될 듯 합니다.  
- https://docs.aws.amazon.com/ko_kr/AmazonRDS/latest/UserGuide/Overview.Encryption.html

#44. Are applications developed following secure coding practices (e.g. OWASP)?
- 시큐어 코딩을 적용한다면 점검 툴을 이용해야 할 것 같습니다. 
- 오픈소스(SonarQube)를 이용하여 static application security tests 가 가능합니다. (OWASP 항목 포함)
- 소스 레벨에서 점검하고 결과는 리포트 서버에서 확인.  
- 리포트 서버 구성이 필요합니다. 

#45. Do you perform static/dynamic application security tests against systems holding Dyson data?
- 시큐어 코딩을 적용한다면 점검 툴을 이용해야 할 것 같습니다. 
- 오픈소스(SonarQube)를 이용하여 SAST 점검이 가능.
- 오픈소스(OWASP ZAP)로 dynamic test가 가능하다고 합니다. (사용해 보진 않았습니다.)
