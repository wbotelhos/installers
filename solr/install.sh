#!/bin/bash

##################
# --- Common --- #
##################

GRAY='\033[0;36m'
GREEN='\033[0;32m'
NO_COLOR='\033[1;0m'
YELLOW='\033[1;33m'

if [ $UID != 0 ]; then
  echo -e "${YELLOW}You need to be root!${NO_COLOR}\n"
  exit 1
fi

FILE_PATH=$(echo $0 | sed 's,/install.sh,,g')

##########################
# --- Configurations --- #
##########################

JOB_NAME='Solr#install'
SITE='http://archive.apache.org/dist/lucene/solr'

#####################
# --- Variables --- #
#####################

SOLR_CONFIG=/opt/solr
SOLR_PATH=/var/lib/solr
TOMCAT_PATH=/var/lib/tomcat
USERNAME='tomcat'

########################
# --- Dependencies --- #
########################

if [ ! -e /var/lib/tomcat ]; then
  echo -e "${RED}Install Tomcat first!${NO_COLOR}\n"
  exit 1
fi

#####################
# --- Functions --- #
#####################

ask() {
  read -p "Check the version number at <${SITE}>, type it and press ENTER: " VERSION

  if [ "${VERSION}" == '' ]; then
    echo -e "${RED}Version missing, install aborted!${NO_COLOR}\n"
    exit 1
  fi

  FILE_NAME="solr-${VERSION}"
  DOWNLOAD_URL="http://archive.apache.org/dist/lucene/solr/${VERSION}/${FILE_NAME}.tgz"
}

begin() {
  echo -e "-------------------------------------"
  echo -e "${GRAY}Starting ${JOB_NAME}...${NO_COLOR}\n"
}

clean() {
  rm -rf $FILE_NAME
}

copy() {
  mv $FILE_NAME $SOLR_PATH

  cd -
}

download() {
  cd /tmp

  if [ ! -e ${FILE_NAME}.tgz ]; then
    echo -e "\nDownloading from ${DOWNLOAD_URL}"

    wget $DOWNLOAD_URL 2> /dev/null

    if [ $? != 0 ]; then
      echo -e "${RED}Incorret version (${VERSION}), check it out: ${SITE}\n${NO_COLOR}"
      exit 1
    fi
  fi
}

end() {
  echo -e "${GREEN}Done!${NO_COLOR}"
  echo -e "-------------------------------------\n"
}

extract() {
  tar zxf ${FILE_NAME}.tgz
}

logs() {
  tail -fn 100 $TOMCAT_PATH/logs/*
}

permission() {
  chown -R ${USERNAME}:${USERNAME} $TOMCAT_PATH $SOLR_PATH $SOLR_CONFIG
}

restart() {
  service tomcat restart
}

setup() {
  cp -r ${FILE_PATH}/opt/solr /opt
  cp ${FILE_PATH}/var/lib/tomcat/conf/Catalina/localhost/solr.xml ${TOMCAT_PATH}/conf/Catalina/localhost/solr.xml
  cp ${SOLR_PATH}/example/webapps/solr.war ${TOMCAT_PATH}/webapps
}

uninstall() {
  rm -rf ${TOMCAT_PATH}/webapps/solr* $SOLR_PATH $SOLR_CONFIG
}

###################
# --- Install --- #
###################

begin

uninstall
ask
download
clean
extract
copy
setup
permission
restart
# logs

end
