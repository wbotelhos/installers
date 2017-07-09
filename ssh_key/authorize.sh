#!/bin/bash

##################
# --- common --- #
##################

GRAY='\033[0;36m'
GREEN='\033[0;32m'
NO_COLOR='\033[1;0m'
RED='\033[1;31m'
YELLOW='\033[1;33m'

##################
# --- config --- #
##################

JOB_NAME='SSH Key#authorize'

#####################
# --- functions --- #
#####################

ask() {
  read -p "Access public key path (~/.ssh/blogy.pem): " KEY_PATH

  [ "${KEY_PATH}" == '' ] && KEY_PATH=~/.ssh/blogy.pem

  echo -e "${YELLOW}KEY_PATH: ${NO_COLOR}${KEY_PATH}\n"

  read -p "To be uploaded key path (~/.ssh/blogy.pub): " KEY_PATH_TO_UPLOAD

  [ "${KEY_PATH_TO_UPLOAD}" == '' ] && KEY_PATH_TO_UPLOAD=~/.ssh/blogy.pub

  echo -e "${YELLOW}KEY_PATH_TO_UPLOAD: ${NO_COLOR}${KEY_PATH_TO_UPLOAD}\n"

  read -p "User credential (user): " USER_CREDENTIAL

  [ "${USER_CREDENTIAL}" == '' ] && USER_CREDENTIAL='user'

  echo -e "${YELLOW}USER_CREDENTIAL: ${NO_COLOR}${USER_CREDENTIAL}\n"

  read -p "Domain credential (wbotelhos.com): " DOMAIN_CREDENTIAL

  [ "${DOMAIN_CREDENTIAL}" == '' ] && DOMAIN_CREDENTIAL='wbotelhos.com'

  echo -e "${YELLOW}DOMAIN_CREDENTIAL: ${NO_COLOR}${DOMAIN_CREDENTIAL}\n"

  read -p "Remote user dir (/home/${USER_CREDENTIAL}): " REMOTE_DIR

  [ "${REMOTE_DIR}" == '' ] && REMOTE_DIR=/home/${USER_CREDENTIAL}

  echo -e "${YELLOW}REMOTE_DIR: ${NO_COLOR}${REMOTE_DIR}\n"
}

begin() {
  echo -e "-------------------------------------"
  echo -e "${GRAY}Starting ${JOB_NAME}...${NO_COLOR}\n"
}

end() {
  echo -e "${GREEN}Done!${NO_COLOR}"
  echo -e "-------------------------------------\n"
}

authorize() {
  REMOTE=${USER_CREDENTIAL}@${DOMAIN_CREDENTIAL}

  echo -e "${YELLOW}\ncat $KEY_PATH_TO_UPLOAD | ssh -i $KEY_PATH $REMOTE '${REMOTE_DIR}/.ssh/authorized_keys'${NO_COLOR}\n"

  cat $KEY_PATH_TO_UPLOAD | ssh -i $KEY_PATH $REMOTE "cat >> ${REMOTE_DIR}/.ssh/authorized_keys"
}

###################
# --- install --- #
###################

begin

ask
authorize

end
