# [JPA] querydsl gradle 설정하기

## Gradle4 기준 
```groovy
plugins {
    id 'java'
    id 'com.ewerk.gradle.plugins.querydsl' version '1.0.10'  // querydsl plugin
}

group 'practice.writer0713'
version '1.0-SNAPSHOT'

sourceCompatibility = 1.8

repositories {
    mavenCentral()
}

dependencies {
    testCompile group: 'junit', name: 'junit', version: '4.12'

    compile group: 'org.springframework.boot', name: 'spring-boot-starter-data-jpa', version: '2.1.5.RELEASE'

    compile group: 'com.querydsl', name: 'querydsl-jpa', version: '4.2.1' // querydsl
    compile group: 'com.querydsl', name: 'querydsl-apt', version: '4.2.1' // querydsl

    testCompile('org.springframework.boot:spring-boot-starter-test')
}

// querydsl 적용
apply plugin: "com.ewerk.gradle.plugins.querydsl"
def querydslSrcDir = 'src/main/generated'

querydsl {
    library = "com.querydsl:querydsl-apt"
    jpa = true
    querydslSourcesDir = querydslSrcDir
}

sourceSets {
    main {
        java {
            srcDirs 'src/main/java', querydslSrcDir
        }
    }
}

```



## Gradle5 기준 
- 이것 저것 잘 안됨.
- 아래 내용으로 깔끔하게 처리됨.

```groovy
plugins {
    id 'java'
    id 'com.ewerk.gradle.plugins.querydsl' version '1.0.10'  // querydsl plugin
}

group 'practice.writer0713'
version '1.0-SNAPSHOT'

sourceCompatibility = 1.8

repositories {
    mavenCentral()
}

dependencies {
    testCompile group: 'junit', name: 'junit', version: '4.12'

    compile group: 'org.springframework.boot', name: 'spring-boot-starter-data-jpa', version: '2.1.5.RELEASE'

    compile group: 'com.querydsl', name: 'querydsl-jpa', version: '4.2.1' // querydsl
    compile group: 'com.querydsl', name: 'querydsl-apt', version: '4.2.1' // querydsl

    testCompile('org.springframework.boot:spring-boot-starter-test')
}

// querydsl 적용
apply plugin: "com.ewerk.gradle.plugins.querydsl"
def querydslSrcDir = 'src/main/generated'

querydsl {
    library = "com.querydsl:querydsl-apt"
    jpa = true
    querydslSourcesDir = querydslSrcDir
}

sourceSets {
    main {
        java {
            srcDirs 'src/main/java', querydslSrcDir
        }
    }
}

// gradle 5에서는 아래 내용 추가
compileQuerydsl{
    options.annotationProcessorPath = configurations.querydsl
}

configurations {
    querydsl.extendsFrom compileClasspath
}
```