#!/bin/bash

##################
# --- common --- #
##################

GRAY='\033[0;36m'
GREEN='\033[0;32m'
NO_COLOR='\033[1;0m'
YELLOW='\033[1;33m'

if [ $UID != 0 ]; then
  echo -e "${YELLOW}You need to be root!${NO_COLOR}\n"
  exit 1
fi

################
# --- vars --- #
################

GROUP='user'
SITE_NAME='blogy'
USERNAME='user'

###################
# --- configs --- #
###################

BASH_FILE=/home/${USERNAME}/.bash_profile
BASH_FILE_ROOT=/root/.bash_profile
FILE=/tmp/installers/server/files/bash_profile
JOB_NAME='Server#bash'

#####################
# --- functions --- #
#####################

begin() {
  echo -e "-------------------------------------"
  echo -e "${GRAY}Starting ${JOB_NAME}...${NO_COLOR}\n"
}

clean() {
  rm -rf $BASH_FILE_ROOT $BASH_FILE
}

result() {
  echo -e "${YELLOW}SITE_NAME: ${NO_COLOR}${SITE_NAME}"
  echo -e "${YELLOW}GROUP: ${NO_COLOR}${GROUP}"
  echo -e "${YELLOW}USERNAME: ${NO_COLOR}${USERNAME}${NO_COLOR}\n"
}

end() {
  echo -e "${GREEN}Done!${NO_COLOR}"
  echo -e "-------------------------------------\n"
}

install() {
  cat $FILE | sed s,{{site_name}},${SITE_NAME},g > $1
}

permissions() {
  chown ${USERNAME}:${GROUP} $BASH_FILE
}

reload() {
  source $BASH_FILE
}

###################
# --- install --- #
###################

begin

clean
install $BASH_FILE_ROOT
install $BASH_FILE
permissions
reload
result

end
