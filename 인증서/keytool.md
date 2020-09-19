# keytool 사용법
> https://www.lesstif.com/pages/viewpage.action?pageId=20775436

## 개요
Java 는 KeyStore 라는 인터페이스를 통해 Encryption/Decryption 및 Digital Signature 에 사용되는 Private Key, Public Key 와 Certificate 를 추상화하여 제공하고 있다.

KeyStore 를 구현한 Provider 에 따라 실제 개인키가 저장되는 곳이 로컬 디스크이든 HSM 같은 별도의 하드웨어이든 아니면 Windows 의 CertStore나 OSX 의 KeyChain 이든 상관없이 사용자는 소스 코드 수정없이 키와 인증서를 가져올 수 있고 이를 이용하여 데이타 암복호화, 전자서명을 수행할 수 있다.

keytool 은 Keystore 기반으로 인증서와 키를 관리할 수 있는 커맨드 방식의 유틸리티로 JDK 에 포함되어 있다.
커맨드 방식의 openssl  과 비슷한 용도로 사용할 수 있는  프로그램이라 보면 될 것 같다.



## KeyStore Type
keytool 을 사용할 경우 명시적으로 -keystore 옵션으로 키스토어 파일의 경로를 지정하지 않으면 기본적으로 사용자의 홈디렉터리에서 .keystore 파일을 찾게 된다.
keystore 는 여러 가지 타입을 지원하는데 기본적으로는 JKS(Java KeyStore) 라는 타입으로 처리된다.
다음은 jks_keystore 라는 파일 이름으로 JKS 방식의 키스토어를 생성하는 명령어로 JKS 는 기본 옵션이므로 -storetype jks 은 생략 가능하다.

```
keytool -genkeypair -keystore jks_keystore -storetype jks
```

인증서와 개인키를 저장하는 또 다른 표준인 PKCS12 타입을 사용할 경우 다음과 같이 -storetype 옵션을 추가하면 된다.

```
keytool -genkeypair -keystore pkcs12_keystore -storetype pkcs12
```
Windows 와 Mac OSX 는 OS 에 개인키와 인증서를 저장하는 공간이 따로 있는데 keytool 로 접근이 가능하다. Windows-MY 는 사용자의 인증서와 개인키를 저장하는 공간이며 Windows-ROOT 는 신뢰하는 루트 인증서를 저장하는 공간이다. OSX 의 키체인(KeyChain) 에 접근시 KeychainStore 를 타입으로 지정하면 된다. 그외 Bouncy Castle 를 JCE Provider 로 사용할 경우 BKS 타입을 사용할 수 있다.


## 인증서 목록 출력
```
keytool -list -keystore my-keystore.jks
```
