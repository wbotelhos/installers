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

##########################
# --- Configurations --- #
##########################

# change it!
TOMCAT_PATH=/var/lib/tomcat
URL='http://localhost:8080'

JOB_NAME='Jenkins#install'
SITE='http://mirrors.jenkins-ci.org/war'

########################
# --- Dependencies --- #
########################

if [ ! -e /var/lib/tomcat ]; then
  echo -e "${RED}Install tomcat first!${NO_COLOR}\n"
  exit 1
fi

#####################
# --- Functions --- #
#####################

ask() {
  read -p "Version of <$SITE> (latest): " VERSION

  [ "${VERSION}" == '' ] && VERSION='latest'

  read -p 'Context path (/): ' CONTEXT

  if [ "${CONTEXT}" == '' ]; then
    CONTEXT='ROOT'
  else
    CONTEXT=`echo $CONTEXT | sed s,^\\s+,, | sed s,\\s+$,, | sed s,^/*,,`
  fi

  FILE_NAME='jenkins.war'
  DOWNLOAD_URL="http://mirrors.jenkins-ci.org/war/${VERSION}/${FILE_NAME}"
}

begin() {
  echo -e "-------------------------------------"
  echo -e "${GRAY}Starting ${JOB_NAME}...${NO_COLOR}\n"
}

clean() {
  rm -rf ${TOMCAT_PATH}/webapps/${CONTEXT}
}

download() {
  cd /tmp

  if [ ! -e $FILE_NAME ]; then
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

restart() {
  service tomcat restart
}

setup() {
  sudo cp $FILE_NAME ${TOMCAT_PATH}/webapps/${CONTEXT}.war
}

###################
# --- Install --- #
###################

begin

ask
download
clean
setup
restart

end
