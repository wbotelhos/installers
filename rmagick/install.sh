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

JOB_NAME='RMagick#install'

########################
# --- Dependencies --- #
########################

sudo apt-get -f install -qq -y

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
  sudo apt-get install libmagickcore-dev -qq -y
  sudo apt-get install imagemagick       -qq -y
  sudo apt-get install libmagickwand-dev -qq -y
}

version() {
  echo -e "\n${YELLOW}Version now:${NO_COLOR} ${1}\n"
}

#####################
# ---- Install ---- #
#####################

begin

install
version $(convert -version | head -1 | cut -d ' ' -f 3)

end
