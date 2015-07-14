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

#####################
# --- Variables --- #
#####################

SITE='http://ftp.unicamp.br/pub/apache/tomcat/tomcat-8'
TOMCAT_PATH=/var/lib/tomcat

##########################
# --- Configurations --- #
##########################

JOB_NAME='Tomcat#install'

#####################
# --- Functions --- #
#####################

ask() {
  read -p "Version of <${SITE}>: " VERSION

  if [ "${VERSION}" == '' ]; then
    echo -e "${RED}Version missing, install aborted!${NO_COLOR}\n"
    exit 1
  fi

  MAJOR=$(echo $VERSION | head -c 1)
  FILE_NAME="apache-tomcat-${VERSION}"
  DOWNLOAD_URL="http://ftp.unicamp.br/pub/apache/tomcat/tomcat-${MAJOR}/v${VERSION}/bin/${FILE_NAME}.tar.gz"
}

begin() {
  echo -e "-------------------------------------"
  echo -e "${GRAY}Starting ${JOB_NAME}...${NO_COLOR}\n"
}

clean() {
  sudo rm -rf ${TOMCAT_PATH}/LICENSE
  sudo rm -rf ${TOMCAT_PATH}/NOTICE
  sudo rm -rf ${TOMCAT_PATH}/RELEASE-NOTES
  sudo rm -rf ${TOMCAT_PATH}/RUNNING.txt
  sudo rm -rf ${TOMCAT_PATH}/webapps/docs
  sudo rm -rf ${TOMCAT_PATH}/webapps/examples
}

download() {
  cd /tmp

  if [ ! -e ${FILE_NAME}.tar.gz ]; then
    echo -e "\nDownloading from ${DOWNLOAD_URL}"

    wget $DOWNLOAD_URL 2> /dev/null

    if [ $? != 0 ]; then
      echo -e "${RED}Incorret version ($VERSION), check it out: ${SITE}\n${NO_COLOR}"
      exit 1
    fi
  fi
}

end() {
  echo -e "${GREEN}Done!${NO_COLOR}"
  echo -e "-------------------------------------\n"
}

move() {
  rm -rf $FILE_NAME
  tar zxf ${FILE_NAME}.tar.gz
  sudo rm -rf $TOMCAT_PATH
  sudo mv $FILE_NAME $TOMCAT_PATH

  cd -
}

setup() {
  sudo cp ${FILE_PATH}/etc/init.d/tomcat /etc/init.d
}

start() {
  sudo service tomcat start
}

###################
# --- Install --- #
###################

begin

ask
download
move
clean
setup
start

end
