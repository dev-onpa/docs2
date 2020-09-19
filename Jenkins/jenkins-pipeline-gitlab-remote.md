# Jenkins + gitlab을 연동하고 Pipeline을 이용하여 원격지 서버에 배포하기

## Prerequires
+ jenkins 2.x 이상 : pipeline 사용
+ jenkins plugin : gitlab, ssh 등
+ SSH 비밀번호 없이 접속하기 (key를 이용한 접속 가능)



## SSH 비밀번호 없이 접속하기
1. jenkins서버에서 키 생성하기 (개인)
    ```
    $ ssh-keygen -t rsa
    ```
2. 이후 나머지 입력 항목은 Enter 입력
3. id_rsa(개인키), id_rsa.pub (공개키) 생성 확인
    ```
    $ ls -al ~/.ssh

    -rw-------. 1 root root 1679  9월 16 12:42 id_rsa
    -rw-r--r--. 1 root root  407  9월 16 12:42 id_rsa.pub
    ````

4. 원격 서버에 id_rsa.pub (공개키) 전송
    ```
    $ scp id_rsa.pub node@192.168.123.22:/home/node
    ````

5. 원격 서버에 접속하여 전송된 공개키 사용 등록
    ```
    $ ssh node@192.168.123.22 (비밀번호 입력 후 접속)
    ```

6. 계정 root폴더에 .ssh 가 없으면 생성 하고 id_rsa.pub 파일을 authorized_keys 에 등록 
    ```
    $ mkdir 700 ~/.ssh
    $ cat /home/node/id_rsa.pub >> ~/.ssh/authorized_keys
    ```

7. .ssh 권한 설정 
    ```
    $ sudo chown -R node.node   # 소유자를 해당 사용자, 그룹을 해당 사용자 그룹으로 설정
    $ sudo chmod 700 ~/.ssh     # 소유자만 해당 디렉토리 읽기, 쓰기, 접근 가능
    $ sudo chmod 600 ~/.ssh/authorized_keys     # 소유자만 해당 파일 읽기, 쓰기 가능
    ```    

8. 비밀번호 없이 접속 가능한 지 확인 
    ```
    $ exit;
    $ ssh node@192.168.123.22
    ````


## ssh-keygen
```
ssh-keygen -t rsa -C dyson-us -f dyson-us.pem
```

## ppk to pem (pem to ppk)
```
puttygen from.ppk -O private-openssh -o to.pem
```

```
puttygen from.pem -O private-openssh -o to.ppk
```

```
puttygen dyson-us.pem -O private-openssh -o dyson-us.ppk
```

## puttygen 설치 (mac)
```
brew install putty
```