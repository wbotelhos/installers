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

#####################
# --- Variables --- #
#####################

INIT=/etc/init.d/tomcat
TOMCAT_PATH=/var/lib/tomcat

##########################
# --- Configurations --- #
##########################

JOB_NAME='Jenkins#user'

#####################
# --- Functions --- #
#####################

ask() {
  read -p 'User (tomcat): ' USERNAME

  if [ "${USERNAME}" == '' ]; then
    USERNAME='tomcat'
  fi
}

begin() {
  echo -e "-------------------------------------"
  echo -e "${GRAY}Starting ${JOB_NAME}...${NO_COLOR}\n"
}

create() {
  sudo adduser $USERNAME
}

end() {
  echo -e "${GREEN}Done!${NO_COLOR}"
  echo -e "-------------------------------------\n"
}

mock_init() {
  TEMP=/tmp/tomcat.init

  cat $INIT | \
  sed s,'^.*/var',"  sudo -u $USERNAME /var",g > $TEMP && \
  cat $TEMP > $INIT && \
  rm $TEMP
}

permission() {
  chown -R ${USERNAME}:${USERNAME} $TOMCAT_PATH
}

restart() {
  sudo service tomcat stop
  sleep 2
  sudo service tomcat start
}

###################
# --- Install --- #
###################

begin

ask
create
permission
mock_init
restart

end
