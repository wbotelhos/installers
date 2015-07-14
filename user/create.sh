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

GROUP=${2:-'www-data'}
USERNAME=${1:-'deploy'}

###################
# --- configs --- #
###################

JOB_NAME='User#create'
SSH_FOLDER=/home/${USERNAME}/.ssh

#####################
# --- functions --- #
#####################

begin() {
  echo -e "-------------------------------------"
  echo -e "${GRAY}Starting ${JOB_NAME}...${NO_COLOR}\n"
}

create_ssh_folder() {
  mkdir -p $SSH_FOLDER
  chown ${USERNAME}:${GROUP} $SSH_FOLDER
  chmod 700 $SSH_FOLDER
}

end() {
  echo -e "${GREEN}Done!${NO_COLOR}"
  echo -e "-------------------------------------\n"
}

group() {
  groupadd $GROUP
}

result() {
  echo
  echo -e "${YELLOW}USERNAME: ${NO_COLOR}${USERNAME}"
  echo -e "${YELLOW}GROUP: ${NO_COLOR}${GROUP}${NO_COLOR}"
  echo
}

user() {
  adduser --quiet --disabled-login --ingroup $GROUP $USERNAME
}

###################
# --- install --- #
###################

begin

group
user
create_ssh_folder
result

end
