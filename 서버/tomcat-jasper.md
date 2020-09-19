# Jasper 2 JSP Engine How To
> https://tomcat.apache.org/tomcat-9.0-doc/jasper-howto.html

## Introduction
Tomcat 9.0은 Jasper 2 JSP 엔진을 사용하여 JavaServer Pages 2.3 사양을 구현합니다.

Jasper 2는 원래 Jasper보다 성능이 크게 향상되도록 재 설계되었습니다. 일반적인 코드 개선 외에도 다음과 같이 변경되었습니다.

- JSP Custom Tag Pooling: JSP 사용자 정의 태그에 대해 인스턴스화 된 Java 오브젝트를 풀링하여 재사용 할 수 있습니다. 이는 사용자 정의 태그를 사용하는 JSP 페이지의 성능을 크게 향상시킵니다.
- Background JSP compilation: 이미 컴파일 된 JSP 페이지를 변경하면 Jasper 2가 백그라운드에서 해당 페이지를 다시 컴파일 할 수 있습니다. 이전에 컴파일 된 JSP 페이지를 계속 사용하여 요청을 처리 할 수 ​​있습니다. 새 페이지가 성공적으로 컴파일되면 이전 페이지가 바뀝니다. 이는 프로덕션 서버에서 JSP 페이지의 가용성을 향상시키는 데 도움이됩니다.
- Recompile JSP when included page changes: Jasper 2는 이제 JSP에서 컴파일 시간에 포함 된 페이지가 변경된시기를 감지 한 다음 상위 JSP를 다시 컴파일 할 수 있습니다.
- JDT used to compile JSP pages: Eclipse JDT Java 컴파일러는 이제 JSP Java 소스 코드 컴파일을 수행하는 데 사용됩니다. 이 컴파일러는 컨테이너 클래스 로더에서 소스 종속성을로드합니다. Ant와 javac는 여전히 사용할 수 있습니다.

Jasper는 서블릿 클래스 org.apache.jasper.servlet.JspServlet을 사용하여 구현됩니다.


## Configuration
기본적으로 Jasper는 웹 애플리케이션 개발을 수행 할 때 사용하도록 구성되어 있습니다. 프로덕션 Tomcat 서버에서 Jasper를 구성하는 방법에 대한 정보는 프로덕션 구성 섹션을 참조하십시오.

Jasper를 구현하는 서블릿은 글로벌 $CATALINA_BASE/conf/web.xml에서 초기화 매개 변수를 사용하여 구성됩니다.

- **`checkInterval`** - `development`가 false이고 checkInterval이 0보다 크면 백그라운드 컴파일이 사용됩니다. checkInterval은 JSP 페이지 (및 종속 파일)를 다시 컴파일해야하는지 확인하는 시간 (초)입니다. 기본값은 0 초입니다.
- **`classdebuginfo`** - 클래스 파일을 디버깅 정보로 컴파일해야합니까? true 또는 false, 기본값은 true입니다.
- **`classpath`** - 생성 된 서블릿을 컴파일하는 데 사용될 클래스 경로를 정의합니다. 이 매개 변수는 ServletContext 속성 org.apache.jasper.Constants.SERVLET_CLASSPATH가 설정되지 않은 경우에만 적용됩니다. 이 속성은 Jasper가 Tomcat 내에서 사용될 때 항상 설정됩니다. 기본적으로 클래스 경로는 현재 웹 애플리케이션을 기반으로 동적으로 작성됩니다.
- **`compiler`** - JSP 페이지를 컴파일하기 위해 사용해야하는 컴파일러 Ant 이에 대한 유효한 값은 Ant의 javac 태스크의 컴파일러 속성과 동일합니다. 값을 설정하지 않으면 Ant를 사용하는 대신 기본 Eclipse JDT Java 컴파일러가 사용됩니다. 기본값은 없습니다. 이 속성이 설정되면 setenv. [sh | bat]를 사용하여 ant.jar, ant-launcher.jar 및 tools.jar을 CLASSPATH 환경 변수에 추가해야합니다.
- **`compilerSourceVM`** - 소스 파일과 호환되는 JDK 버전은 무엇입니까? (기본값 : 1.8)
- **`compilerTargetVM`** - 생성 된 파일과 호환되는 JDK 버전은 무엇입니까? (기본값 : 1.8)
- **`development`** - Jasper는 개발 모드에서 사용됩니까? true 인 경우, JSP의 수정 점검 빈도는 modifyTestInterval 매개 변수를 통해 지정할 수 있습니다. true 또는 false, 기본값은 true입니다.
- **`displaySourceFragment`** - 소스 메시지가 예외 메시지에 포함되어야합니까? true 또는 false, 기본값은 true입니다.
- **`dumpSmap`** - JSR45 디버깅을위한 SMAP 정보를 파일로 덤프해야합니까? true 또는 false, 기본값은 false입니다. suppressSmap이 true이면 false입니다.
- **`enablePooling`** - 태그 핸들러 풀링 사용 여부를 결정합니다. 이것은 컴파일 옵션입니다. 이미 컴파일 된 JSP의 동작을 변경하지 않습니다. true 또는 false, 기본값은 true입니다.
- **`engineOptionsClass`** - Jasper를 구성하는 데 사용되는 Options 클래스를 지정할 수 있습니다. 없으면 기본 EmbeddedServletOptions가 사용됩니다. SecurityManager에서 실행중인 경우이 옵션은 무시됩니다.
- **`errorOnUseBeanInvalidClassAttribute`** - useBean 조치의 클래스 속성 값이 유효한 Bean 클래스가 아닌 경우 Jasper가 오류를 발행해야합니까? true 또는 false, 기본값은 true입니다.
- **`fork`** - Ant fork JSP 페이지를 컴파일하여 Tomcat과 별도의 JVM에서 수행되도록합니까? true 또는 false, 기본값은 true입니다.
- **`genStringAsCharArray`** - 경우에 따라 성능을 향상시키기 위해 텍스트 문자열을 char 배열로 생성해야합니까? 기본값은 false입니다.
- **`ieClassId`** - <jsp : plugin> 태그를 사용할 때 Internet Explorer로 전송 될 클래스 ID 값입니다. 기본 clsid : 8AD9C840-044E-11D1-B3E9-00805F499D93.
- **`javaEncoding`** - Java 소스 파일 생성에 사용할 Java 파일 인코딩 기본 UTF8.
- **`keepgenerated`** - 각 페이지에 대해 생성 된 Java 소스 코드를 삭제하지 않고 유지해야합니까? true 또는 false, 기본값은 true입니다.
- **`mappingfile`** - 디버깅을 쉽게하기 위해 입력 라인 당 하나의 print 문으로 정적 컨텐츠를 생성해야합니까? true 또는 false, 기본값은 true입니다.
- **`maxLoadedJsps`** - 웹 애플리케이션에로드 될 최대 JSP 수입니다. 이 수보다 많은 JSP가로드되면 가장 최근에 사용 된 JSP가 언로드되어 한 번에로드 된 JSP 수가이 제한을 초과하지 않습니다. 0 이하의 값은 제한이 없음을 나타냅니다. 기본 -1
- **`jspIdleTimeout`** - JSP가 언로드되기 전에 유휴 상태 일 수있는 시간 (초)입니다. 0 이하의 값은 언로드되지 않음을 나타냅니다. 기본 -1
- **`modifiedTestInterval`** - JSP가 마지막으로 수정 사항을 확인한 시간부터 지정된 시간 간격 (초) 동안 JSP (및 종속 파일)의 수정 사항을 검사하지 않도록합니다. 값이 0이면 모든 액세스에서 JSP가 점검됩니다. 개발 모드에서만 사용됩니다. 기본값은 4 초입니다.
- **`recompileOnFail`** - JSP 컴파일이 실패하면 modifyTestInterval을 무시하고 다음 액세스에서 재 컴파일 시도를 트리거해야합니까? 개발 모드에서만 사용되며 컴파일 비용이 많이 들고 과도한 리소스 사용으로 이어질 수 있으므로 기본적으로 비활성화되어 있습니다.
- **`scratchdir`** - SP 페이지를 컴파일 할 때 어떤 스크래치 디렉토리를 사용해야합니까? 기본값은 현재 웹 애플리케이션의 작업 디렉토리입니다. SecurityManager에서 실행중인 경우이 옵션은 무시됩니다.
- **`suppressSmap`** - JSR45 디버깅을위한 SMAP 정보 생성을 억제해야합니까? true 또는 false, 기본값은 false입니다.
- **`trimSpaces`** - 공백으로 완전히 구성된 템플릿 텍스트를 출력에서 ​​제거하거나 (true) 단일 공백으로 바꾸거나 (단일) 변경하지 않은 채 (false)해야합니까? JSP 페이지 또는 태그 파일이 trimDirectiveWhitespaces 값을 true로 지정하면 해당 페이지 / 태그에 대한이 구성 설정보다 우선합니다. 기본값은 false입니다.
- **`xpoweredBy`** - 생성 된 서블릿이 X-Powered-By 응답 헤더를 추가할지 여부를 결정합니다. true 또는 false, 기본값은 false입니다.
- **`strictQuoteEscaping`** - 스크립틀릿 표현식이 속성 값에 사용될 때 따옴표 문자 이스케이프에 대한 JSP.1.6의 규칙을 엄격하게 적용해야합니까? true 또는 false, 기본값은 true입니다.
- **`quoteAttributeEL`** - JSP 페이지의 속성 값에 EL을 사용하는 경우 JSP.1.6에 설명 된 속성 인용 규칙을 표현식에 적용해야합니까? true 또는 false, 기본 true

Eclipse JDT의 Java 컴파일러는 기본 컴파일러로 포함되어 있습니다. Tomcat 클래스 로더에서 모든 종속성을로드하는 고급 Java 컴파일러로 수십 개의 JAR이있는 대규모 설치를 컴파일 할 때 크게 도움이됩니다. 빠른 서버에서는 큰 JSP 페이지에서도 1 초 미만의 재 컴파일주기가 가능합니다.

이전 Tomcat 릴리스에서 사용 된 Apache Ant는 위에서 설명한대로 컴파일러 속성을 구성하여 새 컴파일러 대신 사용할 수 있습니다.

애플리케이션의 JSP 서블릿 설정을 변경해야하는 경우 /WEB-INF/web.xml에서 JSP 서블릿을 다시 정의하여 기본 구성을 대체 할 수 있습니다. 그러나 JSP 서블릿 클래스가 인식되지 않을 수 있으므로 다른 컨테이너에 애플리케이션을 배치하려고하면 문제가 발생할 수 있습니다. Tomcat 특정 /WEB-INF/tomcat-web.xml 배치 디스크립터를 사용하여이 문제점을 해결할 수 있습니다. 형식은 /WEB-INF/web.xml과 동일합니다. /WEB-INF/web.xml의 기본 설정은 무시하지만 기본 설정은 무시합니다. Tomcat 전용이므로 응용 프로그램이 Tomcat에 배포 된 경우에만 처리됩니다.


## Known issues
352/5000
버그 39089에 설명 된 것처럼 알려진 JVM 문제인 버그 6294277은 java.lang.InternalError : name이 너무 길어서 매우 큰 JSP를 컴파일 할 때 예외를 나타내지 않을 수 있습니다. 이것이 관찰되면 다음 중 하나를 사용하여 해결할 수 있습니다.

- JSP의 크기를 줄입니다
- suppressSmap을 true로 설정하여 SMAP 생성 및 JSR-045 지원을 사용하지 않도록 설정하십시오.


## Production Configuration
수행 할 수있는 주요 JSP 최적화는 JSP의 사전 컴파일입니다. 그러나 이것은 가능하지 않거나 (예를 들어, jsp-property-group 기능을 사용하는 경우) Jasper 서블릿의 구성이 중요하게 될 수 있습니다.

프로덕션 Tomcat 서버에서 Jasper 2를 사용하는 경우 기본 구성에서 다음 변경을 고려해야합니다.
- **`development`** - JSP 페이지 컴파일에 대한 액세스 점검을 사용하지 않으려면이를 false로 설정하십시오.
- **`genStringAsCharArray`** - 약간 더 효율적인 char 배열을 생성하려면 이것을 true로 설정하십시오.
- **`modificationTestInterval`** - 어떤 이유로 든 `development`을 true로 설정해야하는 경우 (예 : JSP의 동적 생성)이를 높은 값으로 설정하면 성능이 크게 향상됩니다.
- **`trimSpaces`** - 응답에서 쓸모없는 바이트를 제거하려면 이것을 true로 설정하십시오.



## Web Application Compilation
Ant 사용은 JSPC를 사용하여 웹 애플리케이션을 컴파일하는 데 선호되는 방법입니다. JSP를 사전 컴파일 할 때 `suppressSmap`이 false이고 `compile`이 true 인 경우 SMAP 정보는 최종 클래스에만 포함됩니다. webapp를 사전 컴파일하려면 아래에 제공된 스크립트를 사용하십시오 ( "deployer"다운로드에 유사한 스크립트가 포함됨).
```xml
<project name="Webapp Precompilation" default="all" basedir=".">

   <import file="${tomcat.home}/bin/catalina-tasks.xml"/>

   <target name="jspc">

    <jasper
             validateXml="false"
             uriroot="${webapp.path}"
             webXmlInclude="${webapp.path}/WEB-INF/generated_web.xml"
             outputDir="${webapp.path}/WEB-INF/src" />

  </target>

  <target name="compile">

    <mkdir dir="${webapp.path}/WEB-INF/classes"/>
    <mkdir dir="${webapp.path}/WEB-INF/lib"/>

    <javac destdir="${webapp.path}/WEB-INF/classes"
           debug="on" failonerror="false"
           srcdir="${webapp.path}/WEB-INF/src"
           excludes="**/*.smap">
      <classpath>
        <pathelement location="${webapp.path}/WEB-INF/classes"/>
        <fileset dir="${webapp.path}/WEB-INF/lib">
          <include name="*.jar"/>s
        </fileset>
        <pathelement location="${tomcat.home}/lib"/>
        <fileset dir="${tomcat.home}/lib">
          <include name="*.jar"/>
        </fileset>
        <fileset dir="${tomcat.home}/bin">
          <include name="*.jar"/>
        </fileset>
      </classpath>
      <include name="**" />
      <exclude name="tags/**" />
    </javac>

  </target>

  <target name="all" depends="jspc,compile">
  </target>

  <target name="cleanup">
    <delete>
        <fileset dir="${webapp.path}/WEB-INF/src"/>
        <fileset dir="${webapp.path}/WEB-INF/classes/org/apache/jsp"/>
    </delete>
  </target>

</project>
```

다음 명령 줄을 사용하여 스크립트를 실행할 수 있습니다 (Tomcat 기본 경로 및 사전 컴파일해야하는 webapp 경로로 토큰 교체).
```
$ANT_HOME/bin/ant -Dtomcat.home=<$TOMCAT_HOME> -Dwebapp.path=<$WEBAPP_PATH>
```

그런 다음 사전 컴파일 중에 생성 된 서블릿에 대한 선언 및 맵핑을 웹 애플리케이션 배치 디스크립터에 추가해야합니다. ${webapp.path}/WEB-INF/web.xml 파일의 올바른 위치에 ${webapp.path}/WEB-INF/generated_web.xml을 삽입하십시오. 관리자를 사용하여 웹 애플리케이션을 다시 시작하고 사전 컴파일 된 서블릿에서 웹 애플리케이션이 제대로 실행되는지 테스트하십시오. 웹 애플리케이션 배치 디스크립터에있는 적절한 토큰을 사용하여 Ant 필터링 기능을 사용하여 생성 된 서블릿 선언 및 맵핑을 자동으로 삽입 할 수도 있습니다. 이것은 실제로 Tomcat과 함께 배포 된 모든 웹앱이 빌드 프로세스의 일부로 자동 컴파일되는 방식입니다.

jasper 태스크에서 $ {webapp.path}/WEB-INF/web.xml의 현재 웹 애플리케이션 배치 디스크립터와 ${webapp.path}/WEB-INF/generated_web.xml을 자동 병합하기 위해 addWebXmlMappings 옵션을 사용할 수 있습니다. . JSP에서 Java 6 기능을 사용하려면 다음 javac 컴파일러 태스크 속성을 추가하십시오 : source = "1.6"target = "1.6". 라이브 애플리케이션의 경우 debug = "off"를 사용하여 디버그 정보를 비활성화 할 수도 있습니다.

첫 번째 JSP 구문 오류에서 JSP 생성을 중지하지 않으려면 failOnError = "false"를 사용하고 showSuccess = "true"와 함께 성공적인 JSP에서 Java 로의 모든 JSP가 인쇄됩니다. ${webapp.path}/WEB-INF/src에서 Java 소스 파일 생성 및 ${webapp.path}/WEB-INF/classes/org/apache에서 컴파일 JSP 서블릿 클래스를 정리할 때 매우 유용합니다. / jsp.


힌트 :

다른 Tomcat 릴리스로 전환하면 새 Tomcat 버전으로 JSP를 재생성하고 다시 컴파일하십시오.
서버 런타임에서 java 시스템 특성을 사용하여 PageContext 풀링 org.apache.jasper.runtime.JspFactoryImpl.USE_POOL = false를 비활성화하십시오. org.apache.jasper.runtime.BodyContentImpl.LIMIT_BUFFER = true로 버퍼링을 제한하십시오. 기본값을 변경하면 성능에 영향을 줄 수 있지만 응용 프로그램에 따라 다릅니다.


## Optimisation
Jasper 내에는 사용자가 자신의 환경에 맞게 동작을 최적화 할 수있는 다양한 확장 점이 있습니다.

이러한 확장 점 중 첫 번째는 태그 플러그인 메커니즘입니다. 이를 통해 웹 애플리케이션이 사용할 수 있도록 태그 핸들러의 대체 구현을 제공 할 수 있습니다. 태그 플러그인은 WEB-INF 아래에있는 tagPlugins.xml 파일을 통해 등록됩니다. JSTL 용 샘플 플러그인은 Jasper에 포함되어 있습니다.

두 번째 확장 점은 Expression Language 인터프리터입니다. 대체 통역사는 ServletContext를 통해 구성 될 수 있습니다. 대체 EL 인터프리터를 구성하는 방법에 대한 자세한 내용은 ELInterpreterFactory javadoc을 참조하십시오.