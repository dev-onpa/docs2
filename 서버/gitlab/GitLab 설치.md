# GitLab 설치 (8번 서버)




서버 정보 
CentOS 7 - 64bit

centos-7 CE버전 
https://about.gitlab.com/installation/?version=ce#centos-7

설정

설정 적용
gitlab-ctl reconfigure
적용 후 재시작 
gitlab-ctl restart


unicon port 를 8000 번으로 했으나 오류 발생.
=> proxy:error] [pid 28854] (13)Permission denied: AH00957: HTTP: attempt to connect to 127.0.0.1:8000

SELinux context 는 http_port_t 이므로 허용 가능한 port 를 확인
https://www.lesstif.com/pages/viewpage.action?pageId=12943812

semanage port -l | grep http_port_t

# semanage port -a -p tcp -t http_port_t 8000 
추가했으나 이미 등록된 port라고 나옴..

# vi /etc/gitlab/gitlab.gb
=> unicon port => 8001로 설정

=> 아파치 proxy 변경 : 8000 ==> 8001  (vhost.conf)


로그
/var/log/gitlab/unicorn


ISSUE) git clone 시 인증 후 500에러 발생 
==> fatal: unable to access ‘xxx’: The requested URL returned error: 500

==> 아파치 연동 시 오류가 발생하는 듯 함.
=> https://gitlab.com/gitlab-org/gitlab-recipes/blob/master/web-server/apache/gitlab-apache24.conf
=> gitlab_workhorse_options="-listenUmask 0 -listenNetwork tcp -listenAddr 127.0.0.1:8181 -authBackend http://127.0.0.1:8080”
=> workhorse를 활성화 하고 아래와 같이 설정 함.


gitlab_workhorse['enable'] = true
gitlab_workhorse['listen_network'] = "tcp"
gitlab_workhorse['listen_umask'] = 0
gitlab_workhorse['listen_addr'] = "127.0.0.1:8008”
gitlab_workhorse['auth_backend'] = "http://localhost:8001”

------------------------------------------------------------------
아파치 vhost.conf  에서 proxy 설정을 8001 ==> 8008 로 변경 적용하여 성공함..



최종 설정 (/etc/gitlab/gitlab.gb)



external_url 'http://git.onlinepowers.com:8080'

gitlab_workhorse['enable'] = true
gitlab_workhorse['listen_network'] = "tcp"
gitlab_workhorse['listen_umask'] = 0
gitlab_workhorse['listen_addr'] = "127.0.0.1:8008"
gitlab_workhorse['auth_backend'] = "http://localhost:8001"

unicorn['worker_timeout'] = 60
unicorn['worker_processes'] = 2
unicorn['listen'] = '127.0.0.1'
unicorn['port'] = 8001
unicorn['log_directory'] = "/var/log/gitlab/unicorn"

nginx['enable'] = false








JENKINS 용 git 계정

jenkins / vkdnjtmakstw






{"severity":"WARN","time":"2020-07-30T08:25:52.486Z","error_class":"Redis::CannotConnectError","error_message":"Error connecting to Redis on /var/opt/gitlab/redis/redis.socket (Errno::ENOENT)","error_backtrace":["lib/gitlab/instrumentation/redis.rb:10:in `call'"],"retry":0}
{"severity":"ERROR","time":"2020-07-30T08:25:52.468Z","message":"Error fetching job: Error connecting to Redis on /var/opt/gitlab/redis/redis.socket (Errno::ENOENT)"}
{"severity":"WARN","time":"2020-07-30T08:25:52.487Z","error_class":"Redis::CannotConnectError","error_message":"Error connecting to Redis on /var/opt/gitlab/redis/redis.socket (Errno::ENOENT)","error_backtrace":["lib/gitlab/instrumentation/redis.rb:10:in `call'"],"retry":0}
{"severity":"ERROR","time":"2020-07-30T08:25:52.469Z","message":"Error fetching job: Error connecting to Redis on /var/opt/gitlab/redis/redis.socket (Errno::ENOENT)"}
{"severity":"WARN","time":"2020-07-30T08:25:52.488Z","error_class":"Redis::CannotConnectError","error_message":"Error connecting to Redis on /var/opt/gitlab/redis/redis.socket (Errno::ENOENT)","error_backtrace":["lib/gitlab/instrumentation/redis.rb:10:in `call'"],"retry":0}
{"severity":"ERROR","time":"2020-07-30T08:25:52.469Z","message":"Error fetching job: Error connecting to Redis on /var/opt/gitlab/redis/redis.socket (Errno::ENOENT)"}
{"severity":"WARN","time":"2020-07-30T08:25:52.489Z","error_class":"Redis::CannotConnectError","error_message":"Error connecting to Redis on /var/opt/gitlab/redis/redis.socket (Errno::ENOENT)","error_backtrace":["lib/gitlab/instrumentation/redis.rb:10:in `call'"],"retry":0}
{"severity":"ERROR","time":"2020-07-30T08:25:52.461Z","message":"Error fetching job: Error connecting to Redis on /var/opt/gitlab/redis/redis.socket (Errno::ENOENT)"}
{"severity":"WARN","time":"2020-07-30T08:25:52.489Z","error_class":"Redis::CannotConnectError","error_message":"Error connecting to Redis on /var/opt/gitlab/redis/redis.socket (Errno::ENOENT)","error_backtrace":["lib/gitlab/instrumentation/redis.rb:10:in `call'"],"retry":0}
{"severity":"ERROR","time":"2020-07-30T08:25:52.470Z","message":"Error fetching job: Error connecting to Redis on /var/opt/gitlab/redis/redis.socket (Errno::ENOENT)"}
{"severity":"WARN","time":"2020-07-30T08:25:52.490Z","error_class":"Redis::CannotConnectError","error_message":"Error connecting to Redis on /var/opt/gitlab/redis/redis.socket (Errno::ENOENT)","error_backtrace":["lib/gitlab/instrumentation/redis.rb:10:in `call'"],"retry":0}
{"severity":"ERROR","time":"2020-07-30T08:25:52.470Z","message":"Error fetching job: Error connecting to Redis on /var/opt/gitlab/redis/redis.socket (Errno::ENOENT)"}
{"severity":"ERROR","time":"2020-07-30T08:25:52.471Z","message":"Error fetching job: Error connecting to Redis on /var/opt/gitlab/redis/redis.socket (Errno::ENOENT)"}




gitlab