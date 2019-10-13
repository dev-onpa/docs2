#Linux 서버 다운 원인 분석

## 서버가 다운되고 재부팅 
```
ABRT에 의해 '22' 건의 문제가 발견되었습니다.  
(다음을 실행하여 보다 자세한 내용을 확인합니다: abrt-cli list --since 1559289785

```

### 로그 확인 
```
 $ abrt-cli list --since 1559289785 > log.txt
```
- 대부분 mce: [Hardware Error]: Machine check events logged
- mce Error는 cat /var/log/mcelog OR > dmesg 으로 확인
             
### mce Error  확인
```
 $ cat /var/log/mcelog

 $ dmesg
```


## 1. 서버 로그 부터 확인하자 
```
 $ vi /var/log/message
```




## 참고 
- 시스템 로그 분석 : https://m.blog.naver.com/PostView.nhn?blogId=shotleg&logNo=10176235446&proxyReferer=https%3A%2F%2Fwww.google.com%2F
![로그파일 종류](./images/var-log-message.png)



- 시스템 로그파일 : http://egloos.zum.com/ragreen/v/6297093
![로그파일 종류](./images/system-logs.png)
