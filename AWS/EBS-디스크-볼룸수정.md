# EBS (Elastic Block Store) - 디스크 볼륨 수정 
> 2020.12.29 
> https://docs.aws.amazon.com/ko_kr/AWSEC2/latest/UserGuide/recognize-expanded-volume-linux.html


## 적용 순서 
1. 관리콘솔 > EC2 인스턴스 > 스토리지 > 볼륨 ID 클릭 
2. 볼륨 선택 후 작업 > 볼륨 수정 : 크기 설정 
3. 상태: Optimizing 상태가 완료될 때 까지 기다림. 
4. 해당 인스턴스 ssh 접속 후 파일 시스템 확장

## 리눅스 파일시스템 확장
1. df -hT 명령으로 파일시스템 타입 확인 (Type항목)
```
[ec2-user@ip-172-31-31-151 ~]$ df -hT
Filesystem     Type      Size  Used Avail Use% Mounted on
devtmpfs       devtmpfs  483M   60K  483M   1% /dev
tmpfs          tmpfs     493M     0  493M   0% /dev/shm
/dev/xvda1     ext4        8G  3.3G   13G  21% /
```

2. 볼륨에 확장해야 하는 파티션이 있는지 확인
```
[ec2-user@ip-172-31-31-151 ~]$ lsblk
NAME    MAJ:MIN RM SIZE RO TYPE MOUNTPOINT
xvda    202:0    0  16G  0 disk
└─xvda1 202:1    0  8G  0 part /
```

루트 볼륨 /dev/xvda에는 /dev/xvda1라는 파티션이 있습니다. 볼륨 크기가 16GB일 때 파티션의 크기가 여전히 8GB이기 때문에 파티션 크기를 늘려야 합니다.

3. 볼륨에서 파티션을 확장
growpart 명령을 사용하여 파티션을 확장한다. 디바이스 이름과 파티션 번호 사이에 공백이 있다는 점에 유의할 것!
```
sudo growpart /dev/xvda 1
```

4. lsblk 명령으로 파티션에 늘어난 볼륨 크기가 반영되었는지 확인 
```
[ec2-user@ip-172-31-31-151 ~]$ lsblk
NAME    MAJ:MIN RM SIZE RO TYPE MOUNTPOINT
xvda    202:0    0  16G  0 disk
└─xvda1 202:1    0  16G  0 part /
```

5. 볼륨 Type이 `EX4`인 경우 resize2fs 명령을 사용하여 각 볼륨에서 파일 시스템을 확장
```
sudo resize2fs /dev/xvda1
```

6. 볼륨 Type이 `XFS`인 경우 xfs_growfs 명령을 사용하여 각 볼륨에서 파일 시스템을 확장
```
sudo xfs_growfs -d /
```
xfs_growfs가 설치되지 않는 경우 아래 명령으로 설치 
```
sudo yum install xfsprogs
```

7. df -h 명령을 사용하여 각 파일 시스템에 늘어난 볼륨 크기가 반영되었는지 확인
```
[ec2-user@ip-172-31-31-151 ~]$ df -h
Filesystem      Size  Used Avail Use% Mounted on
devtmpfs        483M   60K  483M   1% /dev
tmpfs           493M     0  493M   0% /dev/shm
/dev/xvda1       16G  3.3G   13G  21% /
```


### Dyson 볼륨 크기 조절 
```
[ec2-user@ip-172-31-36-215 ~]$ lsblk
NAME          MAJ:MIN RM SIZE RO TYPE MOUNTPOINT
nvme0n1       259:0    0  64G  0 disk
├─nvme0n1p1   259:3    0  64G  0 part /
└─nvme0n1p128 259:4    0   1M  0 part
```

```
sudo growpart /dev/nvme0n1 1
```