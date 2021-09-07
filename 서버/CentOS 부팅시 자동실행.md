# 부팅시 자동실행 - CentOS
> https://5takoo.tistory.com/entry/%EB%A6%AC%EB%88%85%EC%8A%A4-Centos-7-%EB%B6%80%ED%8C%85%EC%8B%9C-%EB%AA%85%EB%A0%B9%EC%96%B4-%EC%9E%90%EB%8F%99%EC%8B%A4%ED%96%89-%EB%B0%A9%EB%B2%95


부팅시 명령어 자동실행 방법
자동으로 실행되게 하려면 '/etc/rc.d/rc.local' 파일을 이용하면 됩니다.

## rc.local 실행권한 허용
```
chmod +x /etc/rc.d/rc.local
```
 
## 실행스크립트 추가
```
vi /etc/rc.d/rc.local
```

## 상태 확인
```
systemctl status rc-local.service
```

## 실행
```
systemctl start rc-local.service
```
 


## 리부팅되어도 실행되게 서비스설정 enable 처리
```
vi /usr/lib/systemd/system/rc-local.service
```
 

```

[Install]

WantedBy=multi-user.target
```