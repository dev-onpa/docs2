# Java Bean 이란?
> 2021.03.23 


## Java Bean 이란?
JavaBean은 JavaBean API Specification에 따른 Standard이다

- JavaBeans Spec: https://www.oracle.com/java/technologies/javase/javabeans-spec.html

Java Bean 은 데이터를 표현하는 것을 목적으로 하는 자바 클래스이다. 
특별한 것은 없고 Java Bean 규약에 맞춰서 만든 클래스라보 보면 됨.

## Java Bean 
1. 기본생성자가 존재해야한다.
2. 모든 멤버변수의 접근제어자는 private이다.
3. 멤버변수마다 getter/setter가 존재해야한다. (속성이 boolean일 경우 is를 붙힘)
4. 외부에서 멤버변수에 접근하기 위해서는 메소드로만 접근할 수 있다.
5. Serializable(직렬화)가 가능해야한다.

미국 동부 (버지니아 북부)us-east-1
아시아 태평양 (싱가포르)ap-southeast-1
유럽 (프랑크푸르트)eu-central-1