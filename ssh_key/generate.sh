#!/bin/bash

##################
# --- common --- #
##################

GRAY='\033[0;36m'
GREEN='\033[0;32m'
NO_COLOR='\033[1;0m'
YELLOW='\033[1;33m'

##################
# --- config --- #
##################

JOB_NAME='SSH Key#generate'

#####################
# --- functions --- #
#####################

add() {
  ssh-add $HOME_PATH/.ssh/${KEY_NAME}
}

ask() {
  read -p 'Home directory or just ENTER for (~): ' HOME_PATH

  [ "${HOME_PATH}" == '' ] && HOME_PATH=~

  read -p 'Key name or just ENTER for (id_rsa): ' KEY_NAME

  [ "${KEY_NAME}" == '' ] && KEY_NAME='id_rsa'

  read -p "Comment or just ENTER for (${HOME_PATH}/${KEY_NAME}): " COMMENT

  [ "${COMMENT}" == '' ] && COMMENT=${HOME_PATH}/${KEY_NAME}
}

begin() {
  echo -e "-------------------------------------"
  echo -e "${GRAY}Starting ${JOB_NAME}...${NO_COLOR}\n"
}

end() {
  echo -e "${GREEN}Done!${NO_COLOR}"
  echo -e "-------------------------------------\n"
}

generate() {
  ssh-keygen -t rsa -b 4096 -f ${HOME_PATH}/.ssh/${KEY_NAME} -C $COMMENT
}

permissions() {
  chmod 700 ${HOME_PATH}/.ssh
  chmod 600 ${HOME_PATH}/.ssh/${KEY_NAME}*
}

result() {
  echo
  echo -e "${YELLOW}HOME_PATH: ${NO_COLOR}${HOME_PATH}"
  echo -e "${YELLOW}KEY_NAME: ${NO_COLOR}${KEY_NAME}"
  echo -e "${YELLOW}COMMENT: ${NO_COLOR}${COMMENT}"
  echo
}

show() {
  ssh-add -l
}

###################
# --- install --- #
###################

begin

ask
generate
permissions
add
result
show

end
