# JPA (Hibernate) 잠금(Lock) 이해하기 
> 2019-06-26

## 잠금(Lock)의 종류
### 낙관적 잠금(Optimisstic Lock)
낙관적 잠금은 현실적으로 데이터 갱신시 경합이 발생하지 않을 것이라고 낙관적으로 보고 잠금을 거는 기법입니다. 예를 들어 회원정보에 대한 갱신은 보통 해당 회원에 의해서 이루어지므로 동시에 여러 요청이 발생할 가능성이 낮습니다. 따라서 동시에 수정이 이루어진 경우를 감지해서 예외를 발생시켜도 실제로 예외가 발생할 가능성이 낮다고 낙관적으로 보는 것입니다. 이는 엄밀한 의미에서 보면 잠금이라기 보다는 일종의 충돌감지(Conflict detection)에 가깝습니다.

### 비관적 잠금(Pessimistic Lock)
동일한 데이터를 동시에 수정할 가능성이 높다는 비관적인 전제로 잠금을 거는 방식입니다. 예를 들어 상품의 재고는 동시에 같은 상품을 여러명이 주문할 수 있으므로 데이터 수정에 의한 경합이 발생할 가능성이 높다고 비관적으로 보는 것입니다. 이 경우 충돌감지를 통해서 잠금을 발생시키면 충돌발생에 의한 예외가 자주 발생하게 됩니다. 이럴경우 비관적 잠금을 통해서 예외를 발생시키지 않고 정합성을 보장하는 것이 가능합니다. 다만 성능적인 측면은 손실을 감수해야 합니다. 주로 데이터베이스에서 제공하는 배타잠금(Exclusive Lock)을 사용합니다.

### 암시적 잠금(Implicit Lock)
암시적 잠금은 프로그램 코드상에 명시적으로 지정하지 않아도 잠금이 발생하는 것을 의미합니다. JPA에서는 엔터티에 @Version이 붙은 필드가 존재하거나 @OptimisticLocking 어노테이션이 설정되어 있을 경우 자동적으로 충돌감지를 위한 잠금이 실행됩니다. 그리고 데이터베이스의 경우에는 일반적으로 사용하는 대부분의 데이터베이스가 업데이트, 삭제 쿼리 발행시에 암시적으로 해당 로우에 대한 행 배타잠금(Row Exclusive Lock)이 실행됩니다. JPA의 충돌감지가 역할을 할 수 있는 것도 이와 같은 데이터베이스의 암시적 잠금이 존재하기 때문입니다. 데이터베이스의 암시적 잠금이 없다면 충돌감지를 통과한 후 커밋(Commit)이 실행되는 사이에 틈이 생기므로 충돌감지를 하더라도 정합성을 보증할 수 없을 것입니다.

### 명시적 잠금(Explicit Lock)
프로그램을 통해 의도적으로 잠금을 실행하는 것이 명시적 잠금입니다. JPA에서 엔터티를 조회할 때 LockMode를 지정하거나 select for update 쿼리를 통해서 직접 잠금을 지정할 수 있습니다.

## 낙관적 잠금 사용법
JPA(Hibernate)에서 낙관적 잠금을 사용하는 방법에 대해서 알아보겠습니다.

### @Version
JPA에서 낙관적 잠금을 사용하기 위해서는 @Version어노테이션을 붙인 필드를 추가하면 간단하게 적용할 수 있습니다.
```java
@Entity
public class Member implements Serializable {

    @Id
    @GeneratedValue(strategy = GenerationType.AUTO)
    private Long memberNo;
    //...
    @Version
    private int version;
    //...

}
```

특정 필드에 @Version이 붙은 필드를 추가하면 자동적으로 낙관적 잠금이 적용됩니다.  
@Version을 적용할 수 있는 타입은 아래와 같습니다.
* int
* Integer
* short
* Short
* long
* Long
* java.sql.Timestamp

실제로 쿼리를 실행해보면 아래와 같이 업데이트 쿼리 발행시에 조건절에 버전정보가 설정된 것을 볼 수 있습니다.   
현재 엔터티가 가지고 있는 버전정보가 조건절에 적용되며 update문에는 +1된 값이 적용됩니다.   
다른 트랜잭션에의해서 이미 버전정보가 바뀐상태라고 하면 업데이트 로우(Row)수가 0이 반환되면서 충돌감지가 되어 예외(OptimisticLockException)가 발생하게 됩니다.   
일단 update문이 실행되면 위에서 언급한 암시적 잠금이 실행되며 동시에 실행된 동일한 엔터티에 대한 쿼리는 앞선 update쿼리가 커밋될때까지 대기하게되어 정합성을 확실하게 보증할 수 있습니다.  
```

```

@Version에 의한 낙관적 잠금


### @OptimisticLocking
JPA 표준 스펙에 정의되어있는 방법이 아니어서 자주 사용되는 방법은 아니지만 Hibernate에서 제공하는 낙관적 잠금을 설정하는 방법입니다.

| 잠금종류	| 설명                                           |
|-----------|-----------------------------------------------|
|NONE	    | 낙관적 잠금을 사용하지 않음.                         |
|VERSION	| @Version 어노테이션이 붙어있는 필드를 조건으로 낙관적 잠금. |
|DIRTY	    | 변경된 필드에 의해서 낙관적 잠금 사용.                  |
|ALL	    | 모든 필드를 충돌감지의 조건으로 사용하는 낙관적 잠금.       |

DIRTY와 ALL은 버전필드 없이도 낙관적 잠금(Version less optimistic lock)을 사용할 수 있는 방법입니다. 

```java
@Entity
@OptimisticLocking(type = OptimisticLockType.ALL)
@DynamicUpdate
public class Member {

    @Id
    @GeneratedValue
    @Column(name = "member_no")
    private Long memberNo;

    @Column(name = "member_id", nullable = false)
    private String memberId;

    @Column(name = "member_name")
    private String memberName;
    //...
}
```

```
@OptimisticLocking ALL에 의한 낙관적 잠금
```


위의 @Version 필드에 의한 잠김과는 다르게 조건절에 전체 컬럼가 걸려 있는 것을 알 수 있습니다. 조건절에는 업데이트 전의 값이 바인딩되어 있습니다. 이와 같이 컬럼 전체에 대한 업데이트 여부를 확인 함으로서 버전 없는 낙관적 잠금이 가능합니다. 주의할 점은 ALL을 사용할 경우에는 @DynamicUpdate는 같이 사용해야한다는 점입니다.
@DynamicUpdate가 필요한 이유는 필드단위로 Dirty여부를 확인하기 위함입니다.

> When using OptimisticLockType.ALL, you should also use @DynamicUpdate because the UPDATE statement must take into consideration all the entity property values.

```java
@Entity
@OptimisticLocking(type = OptimisticLockType.DIRTY)
@DynamicUpdate
public class Member {

    @Id
    @GeneratedValue
    @Column(name = "member_no")
    private Long memberNo;

    @Column(name = "member_id", nullable = false)
    private String memberId;

    @Column(name = "member_name")
    private String memberName;
    //...
}
```
```
@OptimisticLocking DIRTY에 의한 낙관적 잠금
```

DIRTY로 지정했을 경우에는 위와 같이 갱신될 컬럼의 갱신전 값으로 조건절에 바인딩 됩니다. 특정한 컬럼만 충돌확인에 사용하므로 ALL이나 @Version을 사용했을때에 비해서 충돌할 가능성을 낮출수 있습니다. 다시 말해서 특정 엔터티의 서로 다른 부분을 업데이트하는 프로그램이 있을 경우 충돌하지 않고 수행이 가능합니다.

> The main advantage of OptimisticLockType.DIRTY over OptimisticLockType.ALL and the default OptimisticLockType.VERSION used implicitly along with the @Version mapping, is that it allows you to minimize the risk of OptimisticLockException across non-overlapping entity property changes.  
>  
> When using OptimisticLockType.DIRTY, you should also use @DynamicUpdate because the UPDATE statement must take into consideration all the dirty entity property values, and also the @SelectBeforeUpdate annotation so that detached entities are properly handled by the Session#update(entity) operation.

@DynamicUpdate를 사용하지 않을 경우 org.hibernate.MappingException: optimistic-lock=all|dirty requires dynamic-update="true"와 같은 예외가 발생합니다.


## 명시적 낙관적 잠금
프로그램에 의해서 명시적으로 낙관적 잠금을 사용할 수 있습니다.
```java
public class SomeService {
    @Transactional
    public void someOperation() {
        Member member = this.entityManager.find(Member.class, memberNo, LockModeType.OPTIMISTIC);
        //do something
    }
}
```

```java
public class SomeService {
    @Transactional
    public void someOperation() {
        Member member = this.entityManager.find(Member.class, memberNo);
        //do something
        this.entityManager.lock(member, LockModeType.OPTIMISTIC);
    }
}
```
위와 같이 엔터티 매니저가 제공하는 EntityManager#find(Class<T> entityClass, Object primaryKey, LockModeType lockMode)를 사용하거나 EntityManager#lock(Object entity, LockModeType lockMode)를 사용할 수 있습니다.

find를 사용하는 경우에는 엔터티를 영속성 컨텍스트로 부터 찾거나 없을 경우 select하면서 동시에 잠금을 걸때 사용하고 lock는 이미 영속성 컨텍스트에 담겨있는 엔터티를 대상으로 잠금을 걸때 사용합니다.

### OPTIMISTIC
잠금모드를 OPTIMISTIC로 지정해서 잠금을 사용하는 경우에는 버전필드의 갱신여부와 상관없이 커밋 직전에 버전을 확인하는 쿼리를 한번 더 발행합니다.

```
OPTIMISTIC 잠금모드에 의한 버전 확인
```

해당 엔터티에 변경사항이 있을 경우에는 update쿼리 의해서 이미 충돌감지가 작동하므로 사실상 불필요한 쿼리가 발행될 수 있습니다. 
다만 엔터티에 변경 없이 해당 엔터티에 대한 처리를 수행할 경우에 사용할 수 있습니다. 
엔터티에 대한 변경이 없으어 암시적인 배타잠금(Row Exclusive Lock)이 발생하지 않으므로 완벽한 잠금이라고 보기 힘든 측면이 있습니다. 
자식 엔터티에 대한 수정을 목적으로 잠금을 사용하는 경우에는 빈틈이 있으므로 사용해선 안됩니다. 
그럴 경우에는 자식 엔터티의 수정시에 변경할 필드를 추가하거나(예를 들어 자식 엔터티 수정일자 등) 아래에서 소개할 `OPTIMISTIC_FORCE_INCREMENT` 잠금모드를 사용해야합니다.

JPA(Hibernate)에서는 자식 엔터티만 수정할 경우 부모엔터티는 변경이 있다고 판정되지 않습니다.

### OPTIMISTIC_FORCE_INCREMENT
`OPTIMISTIC`과 달리 버전을 강제로 증가시키는 잠금입니다. 
커밋 직전에 아래처럼 버전만 증가시키는 쿼리가 항상 발행됩니다. 
따라서 해당 엔터티에 변경이 있었을 경우에는 변경사항에 대한 업데이트문과 버전을 증가시키는 업데이트문에 의해서 두번 버전이 증가합니다. 
OPTIMISTIC와 동일하게 엔터티 자체에 변경사항이 있을 경우에는 불필요하게 업데이트 문이 발행되므로 주의할 필요가 있습니다. 
그리고 암시적인 행 배타잠금(Row Exclusive Lock)이 발생되어 정합성을 보증할 수는 있으므로 자식 엔터티를 수정할때 자식엔터티 전체에 대한 잠금용도로 사용할 수 있습니다.

```
OPTIMISTIC_FORCE_INCREMENT에 의한 버전확인
```

## 비관적 잠금
### PESSIMISTIC_READ
데이터베이스에서 제공하는 공유잠금(여러 트랜잭션에서 동시에 읽을 수 있지만 쓸수없는 잠금, for share)을 이용하여 잠금을 획득합니다. 다만 공유잠금을 제공하지 않는 경우 PESSIMISTIC_WRITE와 동일하게 동작합니다. 사용하는 데이터베이스에 따라 지원여부가 갈리므로 확인 후 사용하시기 바랍니다.

```java
public class SomeService {
    @Transactional
    public void someOperation() {
        Member member = this.entityManager.find(Member.class, memberNo, LockModeType.PESSIMISTIC_READ);
        //do something
    }
}
```

### PESSIMISTIC_WRITE
데이터베이스에서 제공하는 행 배타잠금(Row Exclusive Lock)을 이용하여 잠금을 획득합니다.

```java
public class SomeService {
    @Transactional
    public void someOperation() {
        Member member = this.entityManager.find(Member.class, memberNo, LockModeType.PESSIMISTIC_WRITE);
    }
}
```

### PESSIMISTIC_FORCE_INCREMENT
데이터베이스에서 제공하는 행 배타잠금(Row Exclusive Lock)을 이용한 잠금과 동시에 버전을 증가시킵니다. 해당하는 엔터티에 변경은 없으나 하위엔터티를 갱신을 위해서 잠금이 필요할 경우 사용할 수 있습니다.

```java
public class SomeService {
    @Transactional
    public void someOperation() {
        Member member = this.entityManager.find(Member.class, memberNo, LockModeType.PESSIMISTIC_FORCE_INCREMENT);
    }
}
```
```
행 배타잠금과 버전 증가
```
위와 같이 행 배타잠금과 버전증가가 연이어서 발생하는 것을 볼 수 있다.


## 주의사항
### 격리수준
일반적으로 주로 사용되는 데이터베이스는 주로 READ COMMITTED에 해당하는 격리수준을 가지는 경우가 많습니다. 
하지만 JPA를 사용할 경우 한번 영속 컨텍스트에 적재된 엔터티를 다시 조회할 경우 데이터베이스를 조회하지 않고 영속 컨텍스트에서 엔터티를 가져오므로 REPEATABLE READ 격리수준과 동일하게 동작하게 됩니다.

```java
public class SomeService {
    @Transactional
    public void someOperation(Long memberNo) {
        Member member = this.entityManager.find(Member.class, memberNo);
        //do something
        this.entityManager.find(Member.class, memberNo, LockModeType.PESSIMISTIC_WRITE);
        //do something
    }
}
```
위의 예제를 보면 동일한 엔터티를 두번 조회하면서 두번째 조회시에 비관적 잠금을 사용하고 있습니다. 실행 결과는 아래와 같습니다.

```
영속 컨텍스트에 존재하는 엔터티 잠금
```

버전필드가 존재하지 않는 엔터티의 경우 위와 같이 첫번째 조회시에 영속 컨텍스트에 적재된 엔터티의 상태는 바뀌지 않고 단순히 select for update에 의한 행 배타잠금이 실행됩니다. 
즉 REPEATABLE READ 격리 수준과 동일하게 동작하므로 처음 엔터티가 조회되어 잠금이 실행되기 전에 다른 트랜잭션에 의해서 엔터티가 변경되어 커밋된 상태가 반영되지 않고 현재 트랜잭션의 엔터티의 상태가 유지된다는 점에 주의해야 합니다. 
이럴 경우 앞선 트랜잭션에 의해서 변경된 값을 잃어버리는 문제(Lost update problem)가 발생할 수 있습니다.  
  
즉 잠금은 동작하였지만 정합성에 문제가 생길 수 있습니다. 
예를 들어 포인트를 사용하는 경우 앞선 트랜잭션에서 차감된 포인트가 반영되지 않으므로서 이중사용 문제가 발생할 수 있습니다. 
영속 컨텍스트에 엔터티가 존재하는 것이 확실한 경우에는 EntityManger#refresh나 JPQL을 이용하여 데이터베이스로부터 엔터티를 조회하도록 강제할 필요가 있습니다.

```
영속 컨텍스트에 존재하는 엔터티 잠금 버전필드가 존재하는 경우
```


버전 필드가 존재하는 엔터티의 경우에는 배타잠금을 실행하는 조건에 버전 정보가 포함되게 됩니다. 
이에 따라 쿼리 실행 후 배타잠금을 획득하기 전에 다른 트랜잭션에 의해서 버전이 증가하게 되어 잠금 획득에 실패하게 됩니다. 
따라서 비관적 락을 이용하여 순차적인 처리를 기대한 경우라면 기대대로 동작하지 않으므로 주의해야 할 필요가 있습니다.

### 쿼리 직접 사용
@Version필드가 존재하는 엔터티에 JPQL이나 네이티브 쿼리를 사용하는 경우 주의할 필요가 있습니다. 
JPQL이나 네이티브 쿼리 실행시 버전정보를 증가시키는 것을 누락할 경우 낙관적 잠금에 빈틈이 생길 수 있으므로 주의가 필요합니다.

### Timeout
비관적 잠금에 의해서 데이터베이스에 행 배타잠금이 발생한 경우 이어서 들어오는 동일한 행에대한 배타잠금 요청을 앞선 요청의 잠금이 해제될때까지 대기하게 됩니다. 이럴 때 잠금을 가진 요청의 처리가 길어지게 되면 커넥션 풀의 커넥션이 부족하게 되어 어플리케이션 전체가 영향을 받게되는 아름다운 상황에 놓일 수 있습니다. 이럴경우 잠금획득 대기시간을 설정하는 Timeout을 사용해서 데이터베이스의 잠금이 어플리케이션 전체의 장애로 확산되는 것을 방지할 수 있습니다.

```java
public class SomeService {
    @Transactional
    public void someOperation(Long memberNo) {
        Member member = this.entityManager.find(
            Member.class, memberNo,
            LockModeType.PESSIMISTIC_WRITE,
            Map.of("javax.persistence.lock.timeout", 0L)
        );
        //do something
    }
}
```

위와같이 설정하면 select for update 쿼리에 nowait가 추가되어 잠금을 취득할 수 없을 경우 즉시 LockTimeoutException과 같은 예외가 발생합니다. 
millisecond 단위로 시간을 지정하는 것도 가능합니다. 
다만 주의할 것은 데이터베이스에 따라 지원여부가 다르고 지원하지 않는 경우 무시되므로 잘 구분해서 사용해야한다는 점입니다. 
예를 들어 H2는 쿼리에 Timeout을 지정할 수 없고 PostgreSQL의 경우에는 NOWAIT(0으로 설정)는 지정 가능하나 시간설정은 무시되므로 주의할 필요가 있습니다. 
데이터베이스 별로 동작이 다른 부분이 있으므로 커넥션 단위의 설정을 이용하거나 서킷 브레이커(circuit breaker)등을 이용하는 것이 더 바람직해 보입니다.

## 마치며
낙관적 잠금, 비관적 잠금, 명시적 잠금 등 어떤 종류의 잠금일 이용할 것인지는 해당 도메인의 비지니스 로직에 따라서 다르고 대부분의 도메인에서는 필요없을 수도 있습니다. 
하지만 상황에 맞는 잠금을 선택할 수 있도록 특성에 대해 잘 알아 두는 것은 꼭 필요할 듯 합니다.



출처: https://reiphiel.tistory.com/entry/understanding-jpa-lock [레이피엘의 블로그]


