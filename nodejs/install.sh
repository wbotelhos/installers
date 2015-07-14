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

##################
# --- config --- #
##################

JOB_NAME='NodeJS#install'

#####################
# --- functions --- #
#####################

begin() {
  echo -e "-------------------------------------"
  echo -e "${GRAY}Starting ${JOB_NAME}...${NO_COLOR}\n"
}

end() {
  echo -e "\n${GREEN}Done!${NO_COLOR}"
  echo -e "-------------------------------------\n"
}

install() {
  apt-get install nodejs -qq -y
}

prepare() {
  curl -sL https://deb.nodesource.com/setup | sudo bash -
}

update() {
  apt-get update -qq -y
}

version() {
  echo
  echo $(nodejs -v)
}

###################
# --- install --- #
###################

begin

prepare
update
install
version

end
