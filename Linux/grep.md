# grep

gzip -d nohup.out-20201101.gz

## 기본 사용법
```
$ grep "검색 정규식" [파일명]  
```


## 옵션 
-c : 카운트 
-F : 정규표현식은 사용하지 않음. (grep 기본이 정규식 검색임 )
-i : 대소문자를 구별하지 않음. 


| more : 페이지 단위로 출력. space bar => 다음 페이지 


grep Exception nohup.out-20201101 > b
grep Exception nohup.out-20201101 | grep transfer
grep Exception nohup.out-20201101 | more
grep Exception nohup.out-20201101
grep TRANSFER nohup.out-20201101
grep TRANSFER nohup.out-20201101 > a


grep sales nohup.out-20201101
grep TRANSFER nohup.out-20201101
grep TRANSFER nohup.out-20201101 | grep -c "q = "
grep TRANSFER nohup.out-20201101 | grep -c "parameters : "
grep TRANSFER nohup.out-20201101 | grep -c "parameters : {at="
grep ERROR_A nohup.out-20201101


grep '2020-11-13 14:0[0|1]' nohup.out | grep 'exec-1]'
grep '2020-11-13 13:29' nohup.out | grep 'Thread-8' | more

2020-11-13 13:[29|30]       Thread-8