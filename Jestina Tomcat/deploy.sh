# Configuration
SOURCE_HOME=/var/lib/jenkins/workspace/jestina
BUILD_PATH=${SOURCE_HOME}/target
TARGET_COMMON=/home/jestina/common

WAR_FILE_NAME=jestina.war

echo "## 0. [COMMON] Copy common resources"
rm -rf ${TARGET_COMMON}/license/*
rm -rf ${TARGET_COMMON}/payment/*
cp -r ${SOURCE_HOME}/license/* ${TARGET_COMMON}/license/
cp -r ${SOURCE_HOME}/payment/* ${TARGET_COMMON}/payment/


echo "## 1. [MALL] Deploy #######################################################3"
DEPLOY_MALL=/home/jestina/mall

# - Clean
rm -rf ${DEPLOY_MALL}/META-INF
rm -rf ${DEPLOY_MALL}/WEB-INF
rm -rf ${DEPLOY_MALL}/content
rm -rf ${DEPLOY_MALL}/auto-complete.json

# - Copy source
cp -r ${BUILD_PATH}/${WAR_FILE_NAME} ${DEPLOY_MALL}

# - Unzip build file
unzip ${DEPLOY_MALL}/${WAR_FILE_NAME} -d ${DEPLOY_MALL}/
# mkdir ${DEPLOY_MALL}/WEB-INF/classes/properties
cp -r ${SOURCE_HOME}/deploy/production-mall/properties/* ${DEPLOY_MALL}/WEB-INF/classes/properties/

# -Remove Build File
rm -rf ${DEPLOY_MALL}/${WAR_FILE_NAME}

# - Start Tomcat
service tomcat-mall restart



echo "## 2. [MOBILE] Deploy #######################################################3"
DEPLOY_MOBILE=/home/jestina/mobile

# - Clean
rm -rf ${DEPLOY_MOBILE}/META-INF
rm -rf ${DEPLOY_MOBILE}/WEB-INF
rm -rf ${DEPLOY_MOBILE}/content
rm -rf ${DEPLOY_MOBILE}/auto-complete.json

# - Copy source
cp -r ${BUILD_PATH}/${WAR_FILE_NAME} ${DEPLOY_MOBILE}

# - Unzip build file
unzip ${DEPLOY_MOBILE}/${WAR_FILE_NAME} -d ${DEPLOY_MOBILE}/
# mkdir ${DEPLOY_MOBILE}/WEB-INF/classes/properties
cp -r ${SOURCE_HOME}/deploy/production-mobile/properties/* ${DEPLOY_MOBILE}/WEB-INF/classes/properties/

# -Remove Build File
rm -rf ${DEPLOY_MOBILE}/${WAR_FILE_NAME}

# - Start Tomcat
service tomcat-mobile restart



echo "## 3. [ADMIN] Deploy #######################################################3"
DEPLOY_ADMIN=/home/jestina/admin

# - Clean
rm -rf ${DEPLOY_ADMIN}/META-INF
rm -rf ${DEPLOY_ADMIN}/WEB-INF
rm -rf ${DEPLOY_ADMIN}/content
rm -rf ${DEPLOY_ADMIN}/auto-complete.json

# - Copy source
cp -r ${BUILD_PATH}/${WAR_FILE_NAME} ${DEPLOY_ADMIN}

# - Unzip build file
unzip ${DEPLOY_ADMIN}/${WAR_FILE_NAME} -d ${DEPLOY_ADMIN}/
# mkdir ${DEPLOY_ADMIN}/WEB-INF/classes/properties
cp -r ${SOURCE_HOME}/deploy/production-admin/properties/* ${DEPLOY_ADMIN}/WEB-INF/classes/properties/

# -Remove Build File
rm -rf ${DEPLOY_ADMIN}/${WAR_FILE_NAME}

# - Start Tomcat
service tomcat-admin restart



echo "## 4. [SELLER] Deploy #######################################################3"
DEPLOY_SELLER=/home/jestina/seller

# - Clean
rm -rf ${DEPLOY_SELLER}/META-INF
rm -rf ${DEPLOY_SELLER}/WEB-INF
rm -rf ${DEPLOY_SELLER}/content
rm -rf ${DEPLOY_SELLER}/auto-complete.json

# - Copy source
cp -r ${BUILD_PATH}/${WAR_FILE_NAME} ${DEPLOY_SELLER}

# - Unzip build file
unzip ${DEPLOY_SELLER}/${WAR_FILE_NAME} -d ${DEPLOY_SELLER}/
# mkdir ${DEPLOY_SELLER}/WEB-INF/classes/properties
cp -r ${SOURCE_HOME}/deploy/production-seller/properties/* ${DEPLOY_SELLER}/WEB-INF/classes/properties/

# -Remove Build File
rm -rf ${DEPLOY_SELLER}/${WAR_FILE_NAME}

# - Start Tomcat
service tomcat-seller restart
