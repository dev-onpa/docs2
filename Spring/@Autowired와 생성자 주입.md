#  @Autowired 와 생성자 주입 
> https://yaboong.github.io/spring/2019/08/29/why-field-injection-is-bad/


...

## Conclution
### 생성자 주입방식
- 의존관계 설정이 되지 않으면 객체생성 불가 -> 컴파일 타임에 인지 가능, NPE 방지
- 의존성 주입이 필요한 필드를 final 로 선언가능 -> Immutable
- (스프링에서) 순환참조 감지가능 -> 순환참조시 앱구동 실패
- 테스트 코드 작성 용이

### 필드 인젝션 (@Autowired)
- 편하다는 것 말고는 없다