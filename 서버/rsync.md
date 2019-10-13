# rsync 를 이용한 대용량 복사 


## error 
Use "rsync --daemon --help" to see the daemon-mode command-line options.
Please see the rsync(1) and rsyncd.conf(5) man pages for full documentation.
See http://rsync.samba.org/ for updates, bug reports, and answers
rsync error: syntax or usage error (code 1) at main.c(1434) [client=3.0.6]




터미널 접속을 끊고 다시 접속하면, Zsh로 된다. 접속하면 아래와 같은 문구가 나오는데, 0이나 혹은 2번을 선택하여 ./zshrc가 생성되도록 한후, Oh my Zsh설치하면 된다.

This is the Z Shell configuration function for new users,
zsh-newuser-install.
You are seeing this message because you have no zsh startup files
(the files .zshenv, .zprofile, .zshrc, .zlogin in the directory
~). This function can help you with a few settings that should
make your use of the shell easier.

You can:

(q) Quit and do nothing. The function will be run again next time.

(0) Exit, creating the file ~/.zshrc containing just a comment.
That will prevent this function being run again.

(1) Continue to the main menu.

(2) Populate your ~/.zshrc with the configuration recommended
by the system administrator and exit (you will need to edit
the file by hand, if so desired).


출처: https://minder97.tistory.com/entry/Zsh-설치-및-Oh-my-Zsh-사용 [눈, 그 깊은 심연]




$ chcon -u system_u -r object_r -t httpd_modules_t /etc/httpd/modules/mod_jk.so // SELinux 설정 변경
$ setenforce 0 // 설정 적용


출처: https://larva.tistory.com/entry/CentOS6-httpd22-tomcat7-설치-및-modjk-연동 [devNote]













[08/20 18:25:17] OP-190820182422148-/error/404	DEBUG	1	-	-	-	***** Request is to process authentication (AbstractAuthenticationProcessingFilter.java : 205) *****
[08/20 18:25:17] OP-190820182422148-/error/404	DEBUG	1	-	-	-	***** No properties file found for [classpath:/messages/message_ko_KR] - neither plain properties nor XML (ReloadableResourceBundleMessageSourceWithDatabase.java : 488) *****
[08/20 18:25:17] OP-190820182422148-/error/404	DEBUG	1	-	-	-	***** No properties file found for [classpath:/messages/message_ko] - neither plain properties nor XML (ReloadableResourceBundleMessageSourceWithDatabase.java : 488) *****
[08/20 18:25:17] OP-190820182422148-/error/404	DEBUG	1	-	-	-	***** Re-caching properties for filename [classpath:/messages/message] - file hasn't been modified (ReloadableResourceBundleMessageSourceWithDatabase.java : 457) *****
[08/20 18:25:17] OP-190820182422148-/error/404	DEBUG	1	-	-	-	***** No properties file found for [classpath:/properties/application_ko_KR] - neither plain properties nor XML (ReloadableResourceBundleMessageSourceWithDatabase.java : 488) *****
[08/20 18:25:17] OP-190820182422148-/error/404	DEBUG	1	-	-	-	***** No properties file found for [classpath:/properties/application_ko] - neither plain properties nor XML (ReloadableResourceBundleMessageSourceWithDatabase.java : 488) *****
[08/20 18:25:17] OP-190820182422148-/error/404	DEBUG	1	-	-	-	***** Re-caching properties for filename [classpath:/properties/application] - file hasn't been modified (ReloadableResourceBundleMessageSourceWithDatabase.java : 457) *****
[08/20 18:25:17] OP-190820182422148-/error/404	DEBUG	1	-	-	-	***** No properties file found for [classpath:/properties/config_ko_KR] - neither plain properties nor XML (ReloadableResourceBundleMessageSourceWithDatabase.java : 488) *****
[08/20 18:25:17] OP-190820182422148-/error/404	DEBUG	1	-	-	-	***** No properties file found for [classpath:/properties/config_ko] - neither plain properties nor XML (ReloadableResourceBundleMessageSourceWithDatabase.java : 488) *****
[08/20 18:25:17] OP-190820182422148-/error/404	DEBUG	1	-	-	-	***** Re-caching properties for filename [classpath:/properties/config] - file hasn't been modified (ReloadableResourceBundleMessageSourceWithDatabase.java : 457) *****
[08/20 18:25:17] OP-190820182422148-/error/404	DEBUG	1	-	-	-	***** ooo Using Connection [1579323809, URL=jdbc:oracle:thin:@192.168.123.15:1521:orcl, UserName=JESTINA, Oracle JDBC driver] (BaseJdbcLogger.java : 132) *****
[08/20 18:25:17] OP-190820182422148-/error/404	DEBUG	1	-	-	-	***** ==>  Preparing: SELECT * FROM OP_USER WHERE LOGIN_ID = ? AND STATUS_CODE IN ('9', '4')  (BaseJdbcLogger.java : 132) *****
[08/20 18:25:17] OP-190820182422148-/error/404	DEBUG	1	-	-	-	***** ==> Parameters: test1234(String) (BaseJdbcLogger.java : 132) *****

------------------------------------------------------------------------------------------------
SELECT * FROM OP_USER WHERE LOGIN_ID = 'test1234' AND STATUS_CODE IN ('9', '4') 
 {executed in 3 msec}
------------------------------------------------------------------------------------------------
[08/20 18:25:17] OP-190820182422148-/error/404	DEBUG	1	-	-	-	***** ooo Using Connection [1579323809, URL=jdbc:oracle:thin:@192.168.123.15:1521:orcl, UserName=JESTINA, Oracle JDBC driver] (BaseJdbcLogger.java : 132) *****
[08/20 18:25:17] OP-190820182422148-/error/404	DEBUG	1	-	-	-	***** ==>  Preparing: SELECT * FROM OP_USER_ROLE WHERE USER_ID = ?  (BaseJdbcLogger.java : 132) *****
[08/20 18:25:17] OP-190820182422148-/error/404	DEBUG	1	-	-	-	***** ==> Parameters: 345317(Long) (BaseJdbcLogger.java : 132) *****

------------------------------------------------------------------------------------------------
SELECT * FROM OP_USER_ROLE WHERE USER_ID = 345317 
 {executed in 2 msec}
------------------------------------------------------------------------------------------------
[08/20 18:25:17] OP-190820182422148-/error/404	TRACE	2	Svc	S	0	saleson.shop.etc.EtcServiceImpl.getEncodingPassword
[08/20 18:25:17] OP-190820182422148-/error/404	DEBUG	2	-	-	-	***** Authentication success. Updating SecurityContextHolder to contain: org.springframework.security.authentication.UsernamePasswordAuthenticationToken@1e7538b4: Principal: com.onlinepowers.framework.security.userdetails.OpUserDetails@5a683a84; Credentials: [PROTECTED]; Authenticated: true; Details: null; Granted Authorities: ROLE_USER (AbstractAuthenticationProcessingFilter.java : 319) *****
[08/20 18:25:17] OP-190820182422148-/error/404	DEBUG	2	-	-	-	***** ooo Using Connection [1755895620, URL=jdbc:oracle:thin:@192.168.123.15:1521:orcl, UserName=JESTINA, Oracle JDBC driver] (BaseJdbcLogger.java : 132) *****
[08/20 18:25:17] OP-190820182422148-/error/404	DEBUG	2	-	-	-	***** ==>  Preparing: SELECT KEY, VALUE, TITLE, DESCRIPTION, USE_YN, UPDATE_DATE, ORDERING, ISMS_TYPE FROM OP_CONFIG_ISMS ORDER BY ISMS_TYPE, ORDERING  (BaseJdbcLogger.java : 132) *****
[08/20 18:25:17] OP-190820182422148-/error/404	DEBUG	2	-	-	-	***** ==> Parameters:  (BaseJdbcLogger.java : 132) *****

------------------------------------------------------------------------------------------------
SELECT KEY, VALUE, TITLE, DESCRIPTION, USE_YN, UPDATE_DATE, ORDERING, ISMS_TYPE FROM OP_CONFIG_ISMS 
ORDER BY ISMS_TYPE, ORDERING 
 {executed in 2 msec}
------------------------------------------------------------------------------------------------
[08/20 18:25:17] OP-190820182422148-/error/404	TRACE	3	Dao	S	7	com.sun.proxy.$Proxy165.getIsmsList
[08/20 18:25:17] OP-190820182422148-/error/404	TRACE	4	Svc	S	7	saleson.shop.isms.IsmsServiceImpl.getIsmsList
[08/20 18:25:17] OP-190820182422148-/error/404	DEBUG	4	-	-	-	***** ooo Using Connection [1244724162, URL=jdbc:oracle:thin:@192.168.123.15:1521:orcl, UserName=JESTINA, Oracle JDBC driver] (BaseJdbcLogger.java : 132) *****
[08/20 18:25:17] OP-190820182422148-/error/404	DEBUG	4	-	-	-	***** ==>  Preparing: SELECT * FROM OP_USER WHERE USER_ID = ?  (BaseJdbcLogger.java : 132) *****
[08/20 18:25:17] OP-190820182422148-/error/404	DEBUG	4	-	-	-	***** ==> Parameters: 345317(Long) (BaseJdbcLogger.java : 132) *****

------------------------------------------------------------------------------------------------
SELECT * FROM OP_USER WHERE USER_ID = 345317 
 {executed in 3 msec}
------------------------------------------------------------------------------------------------
[08/20 18:25:17] OP-190820182422148-/error/404	TRACE	5	Dao	S	5	com.sun.proxy.$Proxy70.getExtendsUserByUserId
[08/20 18:25:17] OP-190820182422148-/error/404	TRACE	6	Svc	S	5	saleson.shop.user.UserServiceImpl.isAccountLockForUser
[08/20 18:25:17] OP-190820182422148-/error/404	DEBUG	6	-	-	-	***** ooo Using Connection [838614706, URL=jdbc:oracle:thin:@192.168.123.15:1521:orcl, UserName=JESTINA, Oracle JDBC driver] (BaseJdbcLogger.java : 132) *****
[08/20 18:25:17] OP-190820182422148-/error/404	DEBUG	6	-	-	-	***** ==>  Preparing: UPDATE OP_USER SET LOGIN_FAIL_COUNT = 0, IS_ACCOUNT_LOCK = 'N' WHERE USER_ID = ?  (BaseJdbcLogger.java : 132) *****
[08/20 18:25:17] OP-190820182422148-/error/404	DEBUG	6	-	-	-	***** ==> Parameters: 345317(Long) (BaseJdbcLogger.java : 132) *****

------------------------------------------------------------------------------------------------
UPDATE OP_USER SET LOGIN_FAIL_COUNT = 0, IS_ACCOUNT_LOCK = 'N' WHERE USER_ID = 345317 
 {executed in 2 msec}
------------------------------------------------------------------------------------------------
[08/20 18:25:17] OP-190820182422148-/error/404	TRACE	7	Dao	S	4	com.sun.proxy.$Proxy70.updateClearUserFailLogin
[08/20 18:25:17] OP-190820182422148-/error/404	TRACE	8	Svc	S	5	saleson.shop.user.UserServiceImpl.updateClearUserFailLogin
[08/20 18:25:17] OP-190820182422148-/error/404	DEBUG	8	-	-	-	***** ooo Using Connection [1184547833, URL=jdbc:oracle:thin:@192.168.123.15:1521:orcl, UserName=JESTINA, Oracle JDBC driver] (BaseJdbcLogger.java : 132) *****
[08/20 18:25:17] OP-190820182422148-/error/404	DEBUG	8	-	-	-	***** ==>  Preparing: UPDATE OP_SEQUENCE SET SEQUENCE_ID = SEQUENCE_ID + 1 WHERE SEQUENCE_KEY = ?  (BaseJdbcLogger.java : 132) *****
[08/20 18:25:17] OP-190820182422148-/error/404	DEBUG	8	-	-	-	***** ==> Parameters: OP_USER_LOGIN_LOG(String) (BaseJdbcLogger.java : 132) *****

------------------------------------------------------------------------------------------------
UPDATE OP_SEQUENCE SET SEQUENCE_ID = SEQUENCE_ID + 1 WHERE SEQUENCE_KEY = 'OP_USER_LOGIN_LOG' 
 {executed in 10 msec}
------------------------------------------------------------------------------------------------
[08/20 18:25:17] OP-190820182422148-/error/404	DEBUG	8	-	-	-	***** ooo Using Connection [1184547833, URL=jdbc:oracle:thin:@192.168.123.15:1521:orcl, UserName=JESTINA, Oracle JDBC driver] (BaseJdbcLogger.java : 132) *****
[08/20 18:25:17] OP-190820182422148-/error/404	DEBUG	8	-	-	-	***** ==>  Preparing: SELECT SEQUENCE_ID FROM OP_SEQUENCE WHERE SEQUENCE_KEY = ?  (BaseJdbcLogger.java : 132) *****
[08/20 18:25:17] OP-190820182422148-/error/404	DEBUG	8	-	-	-	***** ==> Parameters: OP_USER_LOGIN_LOG(String) (BaseJdbcLogger.java : 132) *****

------------------------------------------------------------------------------------------------
SELECT SEQUENCE_ID FROM OP_SEQUENCE WHERE SEQUENCE_KEY = 'OP_USER_LOGIN_LOG' 
 {executed in 2 msec}
------------------------------------------------------------------------------------------------
[08/20 18:25:17] OP-190820182422148-/error/404	DEBUG	8	-	-	-	***** ooo Using Connection [1184547833, URL=jdbc:oracle:thin:@192.168.123.15:1521:orcl, UserName=JESTINA, Oracle JDBC driver] (BaseJdbcLogger.java : 132) *****
[08/20 18:25:17] OP-190820182422148-/error/404	DEBUG	8	-	-	-	***** ==>  Preparing: INSERT INTO OP_USER_LOGIN_LOG ( LOGIN_LOG_ID, LOGIN_TYPE, LOGIN_ID, SUCCESS_FLAG, REMOTE_ADDR, MEMO, LOGIN_DATE, IN_OUT_TYPE ) VALUES ( ?, ?, ?, ?, ?, ?, TO_CHAR(SYSDATE,'YYYYMMDDHH24MISS') , '1' )  (BaseJdbcLogger.java : 132) *****
[08/20 18:25:17] OP-190820182422148-/error/404	DEBUG	8	-	-	-	***** ==> Parameters: 6015(Long), user(String), test1234(String), Y(String), 0:0:0:0:0:0:0:1(String), (String) (BaseJdbcLogger.java : 132) *****

------------------------------------------------------------------------------------------------
INSERT INTO OP_USER_LOGIN_LOG ( LOGIN_LOG_ID, LOGIN_TYPE, LOGIN_ID, SUCCESS_FLAG, REMOTE_ADDR, 
MEMO, LOGIN_DATE, IN_OUT_TYPE ) VALUES ( 6015, 'user', 'test1234', 'Y', '0:0:0:0:0:0:0:1', 
'', TO_CHAR(SYSDATE,'YYYYMMDDHH24MISS') , '1' ) 
 {executed in 3 msec}
------------------------------------------------------------------------------------------------
[08/20 18:25:17] OP-190820182422148-/error/404	TRACE	9	Dao	S	12	com.sun.proxy.$Proxy356.insertUserLoginLog
[08/20 18:25:17] OP-190820182422148-/error/404	TRACE	10	Svc	S	30	saleson.shop.log.LoginLogServiceImpl.insertUserLoginLog
[08/20 18:25:17] OP-190820182422148-/error/404	DEBUG	10	-	-	-	***** ooo Using Connection [956140562, URL=jdbc:oracle:thin:@192.168.123.15:1521:orcl, UserName=JESTINA, Oracle JDBC driver] (BaseJdbcLogger.java : 132) *****
[08/20 18:25:17] OP-190820182422148-/error/404	DEBUG	10	-	-	-	***** ==>  Preparing: SELECT UD.*, U.LOGIN_ID , FN_GET_OFFLINE_STORE_NAME(UD.OFFLINE_STORE_CODE) AS OFFLINE_STORE_NAME, UL.LEVEL_ID, UL.GROUP_CODE, NVL(UL.LEVEL_NAME,'일반회원 ') AS LEVEL_NAME FROM OP_USER U LEFT JOIN OP_USER_DETAIL UD ON U.USER_ID = UD.USER_ID LEFT JOIN OP_USER_LEVEL UL ON UD.LEVEL_ID = UL.LEVEL_ID WHERE U.USER_ID = ?  (BaseJdbcLogger.java : 132) *****
[08/20 18:25:17] OP-190820182422148-/error/404	DEBUG	10	-	-	-	***** ==> Parameters: 345317(Long) (BaseJdbcLogger.java : 132) *****

------------------------------------------------------------------------------------------------
SELECT UD.*, U.LOGIN_ID , FN_GET_OFFLINE_STORE_NAME(UD.OFFLINE_STORE_CODE) AS OFFLINE_STORE_NAME, 
UL.LEVEL_ID, UL.GROUP_CODE, NVL(UL.LEVEL_NAME,'일반회원 ') AS LEVEL_NAME FROM OP_USER U LEFT JOIN 
OP_USER_DETAIL UD ON U.USER_ID = UD.USER_ID LEFT JOIN OP_USER_LEVEL UL ON UD.LEVEL_ID = UL.LEVEL_ID 
WHERE U.USER_ID = 345317 
 {executed in 4 msec}
------------------------------------------------------------------------------------------------
[08/20 18:25:17] OP-190820182422148-/error/404	TRACE	11	Dao	S	9	com.sun.proxy.$Proxy70.getUserDetail
[08/20 18:25:17] OP-190820182422148-/error/404	DEBUG	11	-	-	-	***** ooo Using Connection [1577032315, URL=jdbc:oracle:thin:@192.168.123.15:1521:orcl, UserName=JESTINA, Oracle JDBC driver] (BaseJdbcLogger.java : 132) *****
[08/20 18:25:17] OP-190820182422148-/error/404	DEBUG	11	-	-	-	***** ==>  Preparing: UPDATE CR_CUST@ERPLINK SET JE_CONN_YMD = TO_CHAR(SYSDATE, 'YYYYMMDD') WHERE CUST_CD = ?  (BaseJdbcLogger.java : 132) *****
[08/20 18:25:17] OP-190820182422148-/error/404	DEBUG	11	-	-	-	***** ==> Parameters: J02018070300167(String) (BaseJdbcLogger.java : 132) *****

------------------------------------------------------------------------------------------------
UPDATE CR_CUST@ERPLINK SET JE_CONN_YMD = TO_CHAR(SYSDATE, 'YYYYMMDD') WHERE CUST_CD = 'J02018070300167' 
 {executed in 28 msec}
------------------------------------------------------------------------------------------------
[08/20 18:25:17] OP-190820182422148-/error/404	TRACE	12	Dao	S	29	com.sun.proxy.$Proxy174.updateUserJeConnYmd
[08/20 18:25:17] OP-190820182422148-/error/404	DEBUG	12	-	-	-	***** ooo Using Connection [957411602, URL=jdbc:oracle:thin:@192.168.123.15:1521:orcl, UserName=JESTINA, Oracle JDBC driver] (BaseJdbcLogger.java : 132) *****
[08/20 18:25:17] OP-190820182422148-/error/404	DEBUG	12	-	-	-	***** ==>  Preparing: SELECT UD.*, U.LOGIN_ID , FN_GET_OFFLINE_STORE_NAME(UD.OFFLINE_STORE_CODE) AS OFFLINE_STORE_NAME, UL.LEVEL_ID, UL.GROUP_CODE, NVL(UL.LEVEL_NAME,'일반회원 ') AS LEVEL_NAME FROM OP_USER U LEFT JOIN OP_USER_DETAIL UD ON U.USER_ID = UD.USER_ID LEFT JOIN OP_USER_LEVEL UL ON UD.LEVEL_ID = UL.LEVEL_ID WHERE U.USER_ID = ?  (BaseJdbcLogger.java : 132) *****
[08/20 18:25:17] OP-190820182422148-/error/404	DEBUG	12	-	-	-	***** ==> Parameters: 345317(Long) (BaseJdbcLogger.java : 132) *****

------------------------------------------------------------------------------------------------
SELECT UD.*, U.LOGIN_ID , FN_GET_OFFLINE_STORE_NAME(UD.OFFLINE_STORE_CODE) AS OFFLINE_STORE_NAME, 
UL.LEVEL_ID, UL.GROUP_CODE, NVL(UL.LEVEL_NAME,'일반회원 ') AS LEVEL_NAME FROM OP_USER U LEFT JOIN 
OP_USER_DETAIL UD ON U.USER_ID = UD.USER_ID LEFT JOIN OP_USER_LEVEL UL ON UD.LEVEL_ID = UL.LEVEL_ID 
WHERE U.USER_ID = 345317 
 {executed in 4 msec}
------------------------------------------------------------------------------------------------
[08/20 18:25:17] OP-190820182422148-/error/404	TRACE	13	Dao	S	10	com.sun.proxy.$Proxy70.getUserDetail
[08/20 18:25:17] OP-190820182422148-/error/404	TRACE	14	Svc	S	10	saleson.shop.user.UserServiceImpl.getUserDetail
[08/20 18:25:17] OP-190820182422148-/error/404	DEBUG	14	-	-	-	***** ooo Using Connection [1889494761, URL=jdbc:oracle:thin:@192.168.123.15:1521:orcl, UserName=JESTINA, Oracle JDBC driver] (BaseJdbcLogger.java : 132) *****
[08/20 18:25:17] OP-190820182422148-/error/404	DEBUG	14	-	-	-	***** ==>  Preparing: SELECT LEVEL_ID, GROUP_CODE, DEPTH, LEVEL_NAME, FILE_NAME, PRICE_START, PRICE_END, DISCOUNT_RATE, POINT_RATE, SHIPPING_COUPON_COUNT, RETENTION_PERIOD, REFERENCE_PERIOD, EXCEPT_REFERENCE_PERIOD, CREATED_DATE FROM OP_USER_LEVEL WHERE LEVEL_ID = ?  (BaseJdbcLogger.java : 132) *****
[08/20 18:25:17] OP-190820182422148-/error/404	DEBUG	14	-	-	-	***** ==> Parameters: 5(Integer) (BaseJdbcLogger.java : 132) *****

------------------------------------------------------------------------------------------------
SELECT LEVEL_ID, GROUP_CODE, DEPTH, LEVEL_NAME, FILE_NAME, PRICE_START, PRICE_END, DISCOUNT_RATE, 
POINT_RATE, SHIPPING_COUPON_COUNT, RETENTION_PERIOD, REFERENCE_PERIOD, EXCEPT_REFERENCE_PERIOD, 
CREATED_DATE FROM OP_USER_LEVEL WHERE LEVEL_ID = 5 
 {executed in 76 msec}
------------------------------------------------------------------------------------------------
[08/20 18:25:17] OP-190820182422148-/error/404	TRACE	15	Dao	S	96	com.sun.proxy.$Proxy88.getUserLevelById
[08/20 18:25:17] OP-190820182422148-/error/404	DEBUG	15	-	-	-	***** ooo Using Connection [130127392, URL=jdbc:oracle:thin:@192.168.123.15:1521:orcl, UserName=JESTINA, Oracle JDBC driver] (BaseJdbcLogger.java : 132) *****
[08/20 18:25:17] OP-190820182422148-/error/404	DEBUG	15	-	-	-	***** ==>  Preparing: UPDATE OP_USER SET LOGIN_COUNT = LOGIN_COUNT + 1, LOGIN_DATE = TO_CHAR(SYSDATE,'YYYYMMDDHH24MISS') , SLEEP_MAIL_SEND_DATE = '' WHERE USER_ID = ? AND STATUS_CODE = '9'  (BaseJdbcLogger.java : 132) *****
[08/20 18:25:17] OP-190820182422148-/error/404	DEBUG	15	-	-	-	***** ==> Parameters: 345317(Long) (BaseJdbcLogger.java : 132) *****

------------------------------------------------------------------------------------------------
UPDATE OP_USER SET LOGIN_COUNT = LOGIN_COUNT + 1, LOGIN_DATE = TO_CHAR(SYSDATE,'YYYYMMDDHH24MISS') 
, SLEEP_MAIL_SEND_DATE = '' WHERE USER_ID = 345317 AND STATUS_CODE = '9' 
 {executed in 9 msec}
------------------------------------------------------------------------------------------------
[08/20 18:25:17] OP-190820182422148-/error/404	DEBUG	15	-	-	-	***** ooo Using Connection [1838892858, URL=jdbc:oracle:thin:@192.168.123.15:1521:orcl, UserName=JESTINA, Oracle JDBC driver] (BaseJdbcLogger.java : 132) *****
[08/20 18:25:17] OP-190820182422148-/error/404	DEBUG	15	-	-	-	***** ==>  Preparing: SELECT COUNT(*) FROM OP_CART WHERE USER_ID = ?  (BaseJdbcLogger.java : 132) *****
[08/20 18:25:17] OP-190820182422148-/error/404	DEBUG	15	-	-	-	***** ==> Parameters: 345317(Long) (BaseJdbcLogger.java : 132) *****

------------------------------------------------------------------------------------------------
SELECT COUNT(*) FROM OP_CART WHERE USER_ID = 345317 
 {executed in 3 msec}
------------------------------------------------------------------------------------------------
[08/20 18:25:17] OP-190820182422148-/error/404	TRACE	16	Dao	S	15	com.sun.proxy.$Proxy149.getCountForUserItemByUserId
[08/20 18:25:17] OP-190820182422148-/error/404	DEBUG	16	-	-	-	***** ooo Using Connection [1838892858, URL=jdbc:oracle:thin:@192.168.123.15:1521:orcl, UserName=JESTINA, Oracle JDBC driver] (BaseJdbcLogger.java : 132) *****
[08/20 18:25:17] OP-190820182422148-/error/404	DEBUG	16	-	-	-	***** ==>  Preparing: SELECT * FROM OP_CART WHERE SESSION_ID = ?  (BaseJdbcLogger.java : 132) *****
[08/20 18:25:17] OP-190820182422148-/error/404	DEBUG	16	-	-	-	***** ==> Parameters: BCA31DAB071B8BB6531F0656763534D0(String) (BaseJdbcLogger.java : 132) *****

------------------------------------------------------------------------------------------------
SELECT * FROM OP_CART WHERE SESSION_ID = 'BCA31DAB071B8BB6531F0656763534D0' 
 {executed in 3 msec}
------------------------------------------------------------------------------------------------
[08/20 18:25:17] OP-190820182422148-/error/404	TRACE	17	Dao	S	6	com.sun.proxy.$Proxy149.getCartListBySessionId
[08/20 18:25:17] OP-190820182422148-/error/404	DEBUG	17	-	-	-	***** ooo Using Connection [1838892858, URL=jdbc:oracle:thin:@192.168.123.15:1521:orcl, UserName=JESTINA, Oracle JDBC driver] (BaseJdbcLogger.java : 132) *****
[08/20 18:25:17] OP-190820182422148-/error/404	DEBUG	17	-	-	-	***** ==>  Preparing: DELETE FROM OP_ORDER_ITEM_TEMP WHERE USER_ID = ?  (BaseJdbcLogger.java : 132) *****
[08/20 18:25:17] OP-190820182422148-/error/404	DEBUG	17	-	-	-	***** ==> Parameters: 345317(Long) (BaseJdbcLogger.java : 132) *****

------------------------------------------------------------------------------------------------
DELETE FROM OP_ORDER_ITEM_TEMP WHERE USER_ID = 345317 
 {executed in 3 msec}
------------------------------------------------------------------------------------------------
[08/20 18:25:17] OP-190820182422148-/error/404	TRACE	18	Dao	S	6	com.sun.proxy.$Proxy66.deleteOrderItemTemp
[08/20 18:25:17] OP-190820182422148-/error/404	TRACE	19	Svc	S	6	saleson.shop.order.OrderServiceImpl.deleteOrderItemTemp
[08/20 18:25:17] OP-190820182422148-/error/404	DEBUG	19	-	-	-	***** ooo Using Connection [1838892858, URL=jdbc:oracle:thin:@192.168.123.15:1521:orcl, UserName=JESTINA, Oracle JDBC driver] (BaseJdbcLogger.java : 132) *****
[08/20 18:25:17] OP-190820182422148-/error/404	DEBUG	19	-	-	-	***** ==>  Preparing: UPDATE OP_ORDER_ITEM_TEMP SET USER_ID = ? WHERE SESSION_ID = ?  (BaseJdbcLogger.java : 132) *****
[08/20 18:25:17] OP-190820182422148-/error/404	DEBUG	19	-	-	-	***** ==> Parameters: 345317(Long), BCA31DAB071B8BB6531F0656763534D0(String) (BaseJdbcLogger.java : 132) *****

------------------------------------------------------------------------------------------------
UPDATE OP_ORDER_ITEM_TEMP SET USER_ID = 345317 WHERE SESSION_ID = 'BCA31DAB071B8BB6531F0656763534D0' 
 {executed in 4 msec}
------------------------------------------------------------------------------------------------
[08/20 18:25:17] OP-190820182422148-/error/404	TRACE	20	Dao	S	7	com.sun.proxy.$Proxy66.updateOrderItemTempByUserId
[08/20 18:25:17] OP-190820182422148-/error/404	TRACE	21	Svc	S	7	saleson.shop.order.OrderServiceImpl.updateOrderItemTempByUserId
[08/20 18:25:17] OP-190820182422148-/error/404	TRACE	22	Svc	S	35	saleson.shop.cart.CartServiceImpl.updateUserIdBySessionId
[08/20 18:25:17] OP-190820182422148-/error/404	DEBUG	22	-	-	-	***** Using default Url: / (AbstractAuthenticationTargetUrlRequestHandler.java : 107) *****