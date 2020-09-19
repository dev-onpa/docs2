# Effective Java (3rd)


## 1. Introduction
- 자바를 효과적으로 쓸 방법들을 담은 책
- 자바 문법을 이미 아는 사람 대상
- 처음부터 끝까지 읽기 보다는 관심 있는 아이템만 보면 될듯


## 2. Creating and Destorying Objects

### Item 6. 불필요한 객체 생성을 피하라
정규표현식용 Pattern 인스턴스는, 한 번 쓰고 버러져서 곧바로 가바지 컬렉션 대상이 된다. 
Pattern은 입력받은 정규표현식에 해당하는 유한 상태 머신(finite state machine) 만들기 때문에 인스턴스 생성 비용이 높다.

```java
public static boolean isNumeric(String str) {
    return str != null && str.matches("[-+]?\\d*\\.?\\d+");
}
```

아래처럼 Pattern을 한 번만 만들고 쓰도록 수정
```java
private static final Pattern NUMERIC = Pattern.compile("[-+]?\\d*\\.?\\d+");
...
public static boolean isNumeric(String str) {
    return str != null && NUMERIC.matcher(str).matches();
}
```
  
### Item 9. try-finally보다는 try-with-resources를 사용하라
before: try/finally 중첩으로 복잡한 코드
```java
static void copy(String src, String dst) throws IOException {
    InputStream in = new FileInputStream(src);
    try {
        OutputStream out = new FileOutputStream(dst);
        try {
            byte[] buf = new byte[BUFFER_SIZE];
            int n;
            while ((n = in.read(buf)) >= 0)
                out.write(buf, 0, n);
        } finally {
            out.close();
        }
    } finally {
        in.close();
    }
}
```

after: try안에 AutoCloseable인터페이스 구현한 객체들 넣으면 알아서 close 호출
```java
static void copy2(String src, String dst) throws IOException {
    try (InputStream in = new FileInputStream(src);
         OutputStream out = new FileOutputStream(dst)) {
        byte[] buf = new byte[BUFFER_SIZE];
        int n;
        while ((n = in.read(buf)) >= 0)
            out.write(buf, 0, n);
    }
}
```

예외 처리 방법
```java
static String firstLineOfFile(String path, String defaultVal) {
    try (BufferedReader br = new BufferedReader(new FileReader(path))) {
        return br.readLine();
    } catch (IOException e) {
        return defaultVal;
    }
}
```


## 3. Methods Common to All Objects

### Item 12. toString을 항상 재정의하라
```java
@Override 
public String toString() {
  return String.format("%03d-%03d-%04d", areaCode, prefix, lineNum);
}
```
디버깅에 도움이 됨



## 4. Classes and Interfaces


## 5. Generics

### Item 26. raw 타입은 사용하지 말라, ### Item 27. 비검사 경고를 제거하라
before
```java
@SuppressWarnings("rawtypes")
private List listDatabase;

@SuppressWarnings("unchecked")
public void add(String name) {
  listDatabase.add(name);
}
```
after: 아래처럼 타입을 지정하면 rawtypes, unchecked 둘 다 제거할 수 있다
```java
private List<String> listDatabase;
```


## 6. Enums and Annotations

### Item 34. int 상수 대신 열거 타입을 사용하라
before: `STARTED == idx` 가 `true`임

```java
public static final int NeedMigration = 0;
public static final int STARTED = 1;
public static final int COMPLETED = 2;
public static final int FAILED = 3;
...
public int idx = 1;
```

after
```java
public enum MigrationStatus { NeedMigration, STARTED, COMPLETED, FAILED }
```

### Item 36. 비트 필드 대신 EnumSet을 사용하라
before
```java
public static final int STYLE_BOLD = 1 << 0; //1
public static final int STYLE_ITALIC = 1 << 1; //2
public static final int STYLE_UNDERLINE = 1 << 2; //4
public static final int STYLE_STRIKETHROUGH = 1 << 3; //8
text.applyStyles(STYLE_BOLD | STYLE_ITALIC);
```

after
```java
public enum Style { BOLD, ITALIC, UNDERLINE, STRIKETHROUGH }; 
text.applyStyles(EnumSet.of(Style.BOLD, Style.ITALIC));
```


## 7. Lambdas and Streams

### Item 42. 익명 클래스보다는 람다를 사용하라
```java
List<String> words = Arrays.asList("dzzzd", "wer", "wwws");
Collections.sort(words, new Comparator<String>() { // 낡은 방식
  public int compare(String s1, String s2) {
    return Integer.compare(s1.length(), s2.length());
  } 
});
```

after
```java
// lambda 
Collections.sort(words,
    (s1, s2) -> Integer.compare(s1.length(), s2.length()));
// Comparator construction method + method reference
Collections.sort(words,  Comparator.comparingInt(String::length));
// java 8에 추가된 List.sort로 더 짧아진 
words.sort(Comparator.comparingInt(String::length));
```

### Item 43. 람다보다는 메서드 참조를 사용하라
주석 부분은 메소드 참조에 대응하는 람다
```java
Integer::parseInt      // str -> Integer.parseInt(str);
Instant.now()::isAfter // Instant then = Instant.now(); t -> then.isAfter(t)
String::toLowerCase    // str -> str.toLowerCase()
TreeMap<K,V>::new      // () -> new TreeMap<K,V>()
int[]::new             // len -> new int[len]
```

method reference는 람다의 간단명료한 대안이 될 수 있다. 메서드 참조 쪽이 짧고 명확하다면 메서드 참조를 쓰고, 그렇지 않을 때만 람다를 사용하라.



## 8. Methods

### Item 54. null이 아닌, 빈 컬렉션이나 배열을 반환하라
```java
public List<Cheese> getCheeses() {
  return cheesesInStock.isEmpty() ? null : new ArrayList<>(cheesesInStock);
}
List<Cheese> cheeses = shop.getCheeses();
if (cheeses != null && cheeses.contains(Cheese.STILTON))
```	
null을 반환하는 API는 사용하기 어렵고 오류 처리 코드도 늘어난다. 그렇다고 성능이 좋은 것도 아니다.
// 대부분의 상황에서는 이렇게 하면 된다

```java
public List<Cheese> getCheeses2() {
  return new ArrayList<>(cheesesInStock); 
}

// 최적화 - 빈 컬렉션 생성 매번 하지 않기 
public List<Cheese> getCheeses3() {
  return cheesesInStock.isEmpty() ? Collections.emptyList() : new ArrayList<>(cheesesInStock);
}
```


## 9. General Programming

### Item 58. 전통적인 for문보다는 for-each문을 사용하라
before
```java
for (int i = 0; i < idxList.size(); i++) {
  coll.createIndex(idxList.get(i));
}
```

after
```java
for (DBObject obj : idxList) {
  coll.createIndex(obj);
}
```


### Item 63. 문자열 연결은 느리니 주의하라
String을 더할 때 + 를 쓰거나 StringBuffer 쓰지말고, StringBuilder 를 쓰자. 
단순 더하기는 객체를 추가로 생성하고, StringBuffer는 각 메소드가 synchronized 여서 상대적으로 느리다.


### Item 64. 객체는 인터페이스를 사용해 참조하라
// 좋은 예. 인터페이스를 타입으로 사용했다.
```java
Set<Son> sonSet = new LinkedHashSet<>();
```
// 나쁜 예. 클래스를 타입으로 사용했다!
```java
LinkedHashSet<Son> sonSet = new LinkedHashSet<>();
추가로 Thread를 구현할 때 상속(extend)하기 보다는 Runnable를 구현(implements)하는 게 좋음. 다중상속이 안 되기 때문에 설계할 때 인터페이스 구현이 더 깔끔함.
Runnable runnable = new MyRunnable();
Thread thread = new Thread(runnable); 
thread.start();
```


### Item 67. 최적화는 신중히 하라
자바가 탄생하기 20년 전에 나온 격언들

> (맹목적인 어리석음을 포함해) 그 어떤 핑계보다 효율성이라는 이름 아래 행해진 컴퓨팅 최악이 더 많다(심지어 효율을 높이지도 못하면서). — 윌리엄 울프
>
> (전체의 97% 정도인) 자그마한 효율성은 모두 잊자. 섣부른 최적화가 만악의 근원이다. — 도널드 크누스
>
> 최적화를 할 때는 다음 두 규칙을 따르라.  
> - 첫 번째, 하지 마라.  
> - 두 번째, (전문가 한정) 아직 하지 마라.   
>
> 다시 말해, 완전히 명백하고 최적화되지 않은 해법을 찾을 때까지는 하지 마라. - M.A. 잭슨

성능 때문에 견고한 구조를 희생하지 말자. 빠른 프로그램보다는 좋은 프로그램을 작성하라. <중략>각각의 최적화 시도 전후로 성능을 측정하라 — 작가


### Item 68. 일반적으로 통용되는 명명 규칙을 따르라
- 패키지 — 소문자
- 클래스 — 대문자 시작, camel case
- 메소드, 변수 — 소문자 시작, camel case
- 상수 필드(static final) — 대문자


## 10. Exception

### Item 72. 표준 예외를 사용하라
- IllegalArgumentException — 허용하지 않는 값이 인수로 건네졌을 때(null은 따로 NullPointerException으로 처리)
- IllegalStateException — 객체가 메서드를 수행하기에 적절하지 않은 상태일 때
- NullPointerException — null을 허용하지 않는 메서드에 null 건넸을 때
- IndexOutOfBoundException — 인덱스가 범위를 넘어섰을 때
- ConcurrentModificationException — 허용하지 않는 동시 수정이 발견됐을 때
- UnsupportedOperationException — 호출한 메서드를 지원하지 않을 때

그리고 제발 `Exception` 을 던지거나 받지말자.


### Item 77. 예외를 무시하지 말라
```java
try {
  hostPort = Integer.parseInt(hostInfo[1]);
  connList.add(new ServerAddress(hostName, hostPort));
} catch (NumberFormatException e) {
  // ignore
}
```

위는 실제 쓰는 코드. 무시할 거면 아래처럼 변수명을 ignore 로 쓰라고 책에 나온다.
```java
} catch (NumberFormatException ignore) { }
```


## Concurrency

### Item 80. 스레드보다는 실행자, 태스크, 스트림을 애용하라
실행자 프레임워크(Executor Framework)를 쓰라 (java 5). 
작업 큐를 손수 만드는 일은 삼가야 하고, 스레드를 직접 다루는 것도 일반적으로 삼가야 한다.

- 작업 단위 — Runnable, Callable
- 수행 매커니즘 — 실행자 서비스

Thread를 쓰면 전부 직접해야 함. 
(컬렉션 프레임워크가 데이터 모음을 담당하듯) 실행자 프레임워크가 작업 수행을 담당. 더 자세한 건 ‘자바 병렬 프로그래밍’ 참고.


### Item 82. 스레드 안전성 수준을 문서화하라
- 불변(immutable) — String, Long
- 무조건적 스레드 안전(unconditionally thread-safe) — AtomicLong, ConcurrentHashMap
- 조건부 스레드 안전(conditionally thread-safe) — Collections.synchronized
- 스레드 안전하지 않음(non thread-safe) — ArrayList, HashMap
- 스레드 적대적(thread-hostile)


## Serialization

### Item 85. 자바 직렬화의 대안을 찾으라
직렬화는 위험하니 피해야 한다. 
시스템을 밑바닥부터 설계한다면 JSON이나 프로토콜버퍼 같은 대안을 사용하자.


