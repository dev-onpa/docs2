# 공유폴더(samba)를 맥(mac) 타임머신(Time Machine) 서버로 이용하기

## 1. Mac에서 가상 디스크 이미지 생성 
- `디스크 유틸리티` 실행 
- 파일 > 새로운 이미지 > 빈 이미지 선택 
- 정보 입력 
    - 별도저장 : macbook-time-machine
    - 위치 : 다운로드 
    
    - 이름 : macbook-time-machine
    - 크기 : 맥 하드 용량보다 크게 (500GB)
    - 포멧 : Mac OS 확장(저글링)
    - 암호화 : 없음.
    - 파티션 : Apple 파티션 앱 
    - 이미지 포맷: 분할 번들 디스크 이미지 

## 2. 생성된 디스크 이미지를 파일서버 공유 폴더로 복사 
- 파인더에서 cmd + k를 눌러 공유폴더를 마운트함. 
```
 서버 주소: smb://192.168.123.31/skc/time-machine
```

- 다운로드 폴더에 생성된 `macbook-time-machine.sparsebundle` 파일을 공유 폴더에 복사한 후 더블 클릭으로 마운트 시킴
- finder > 위치 부분에 `macbook-time-machine` 가 마운트 되었는지 확인함. 


## 3. 마운트된 가상이미지를 타임머신 디스크로 설정 
- 터미널을 실행 시킨 후 아래 명령을 입력 
```
 sudo tmutil setdestination /Volumes/[마운트된 디스크 이미지 이름]
 
 $ sudo tmutil setdestination /Volumes/macbook-time-machine
```

## 4. 타임머신을 실행시키면 마운트된 가상이미지가 백업디스크로 설정되어 있는 것을 확인
- macbook-time-machine 으로 설정되어 있는 지 확인 
- `메뉴 막대에서 Time Machine 보기`를 체크한 후 

## 5. 백업시작 
- 메뉴 막대의 타임머신에서 백업 시작을 클릭!
- 첫 백업은 오래 걸리고 다음 백업 부터 변경 사항만 백업해.. 시간이 단축된다고 함.






## Reference
- https://www.clien.net/service/board/lecture/3938298
- https://ftdev.tistory.com/9