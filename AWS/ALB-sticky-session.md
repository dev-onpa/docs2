# ALB - sticky session 설정
> 2020.03.11
> https://linuxer.name/2019/10/alb-sticky-session-%EC%97%90-%EB%8C%80%ED%95%9C-%EA%B3%A0%EC%B0%B0/
> https://docs.aws.amazon.com/elasticloadbalancing/latest/application/load-balancer-target-groups.html

## 관리 콘솔
1. EC2 > 로드밸런싱 > 대상 그룹
2. 대상 그룹 선택
3. 설명(Description) 탭에서 속성 > 속성 편집
4. 고정 : 활성화 체크


### To enable sticky sessions using the console

1. Open the Amazon EC2 console at https://console.aws.amazon.com/ec2/.
2. On the navigation pane, under LOAD BALANCING, choose Target Groups.
3. Select the target group.
4. On the Description tab, choose Edit attributes.
5. On the Edit attributes page, do the following:
    - Select Enable load balancer generated cookie stickiness.
    - For Stickiness duration, specify a value between 1 second and 7 days.
    - Choose Save.

## Sticky Session 이 설정된 경우
- AWSALB 쿠키가 생성됨.