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

JOB_NAME='Rails#install'

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
  gem install rails --no-ri --no-rdoc
}

version() {
  echo -e "\n${YELLOW}Version now:${NO_COLOR} ${1}\n"
}

###################
# --- Install --- #
###################

begin

install
version $(rails -v | cut -d ' ' -f 2)

end
