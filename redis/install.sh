#!/bin/bash

##################
# --- Common --- #
##################

GRAY='\033[0;36m'
GREEN='\033[0;32m'
NO_COLOR='\033[1;0m'
YELLOW='\033[1;33m'

##########################
# --- Configurations --- #
##########################

JOB_NAME='Redis#install'

########################
# --- Dependencies --- #
########################

sudo add-apt-repository ppa:rwky/redis
sudo apt-get update -qq -y

#####################
# --- Functions --- #
#####################

begin() {
  echo -e "-------------------------------------"
  echo -e "${GRAY}Starting ${JOB_NAME}...${NO_COLOR}\n"
}

end() {
  echo -e "${GREEN}Done!${NO_COLOR}"
  echo -e "-------------------------------------\n"
}

install() {
  sudo apt-get install redis-server -qq -y
}

version() {
  echo -e "\n${YELLOW}Version now:${NO_COLOR} ${1}\n"
}

###################
# --- Install --- #
###################

begin

install
version $(redis-cli --version | rev | cut -d ' ' -f 1 | rev)

end
