# Redis
> https://velog.io/@hyeondev/Redis-%EB%9E%80-%EB%AC%B4%EC%97%87%EC%9D%BC%EA%B9%8C

## Cache
### Look aside Cache
- 캐시에 있으면 캐시 없으면 DB 

### Write Back
- 우선 캐시에 저장한 후 모아서 한번에 INSERT
- 모아서 인서트 하면 속도가 빠름 
- 단점: 메모리에 저장하므로 장애시 데이터가 사라질 가능성 있음. 

## 사용예
- Redis 에 로그를 밀어 넣고 한번에 로그를 저장 
- Ranking 서버: 서버가 여러대, 사용자가 많으면 계속 disk에 접속하면 속도가 느려짐. (sorted set을 사용하면 쉽게 구현) 
- 친구리스트: 접속 상태에 따라 다른 경우의 수가 있을 수 있음. (자료구조가 atomic)
- 세션 클러스터링.

- Memcached : 좋지만 Collection 을 제공하지 않음. 
- Redis는 Collection을 제공하므로 개발 편의성이 좋음. 


## Redis 사용 처 
- Remote Data Store: 여러 서버에서 데이터 공유
- 인증 토큰 저장
- Ranking (sorted set)
- 유저 API limit
- 잡 큐(list) - 셀러리(?)


## Redis Collections
- String: key/value
- List: 중간에 데이터 삽입은 느림 (앞, 뒤는 빠름)
- Set: 중복 제거 
- Sorted Set: score
- Hash: (spring date redis repository)


## Redis 운영 
- [중요] 메모리 관리를 잘하자 
- [중요] O(N) 관련 명령어는 주의하자 

### 메모리 관리 
- in-memory Data Store
- physical memory 이상을 사용하면 문제가 발생 (한번 swap이 일어는 키는 계속 disk를 사용합. )
- Maxmemory를 설정하더라도 이보다 더 사용할 가능성이 있음. 
- RSS 값을 모니터링 해야함. 

### Ziplist
- ziplist를 사용하면 메모리를 줄일 수 있다. (Sorted set을 쓰더라도 설정하면 ziplist를 사용할 수 잇다. )

## O(N)명령은 주의하자
- 


## Redis HA
- https://lifeplan-b.tistory.com/13
- https://lascrea.tistory.com/214
- https://coding-start.tistory.com/128
