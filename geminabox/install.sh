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

JOB_NAME='GemInABox#install'

#####################
# --- Functions --- #
#####################

ask() {
  echo -e "\n${GRAY}Example: ${GREEN}http://geminabox.ir7.com.br${NO_COLOR}\n"
  gem inabox -c
}

begin() {
  echo -e "-------------------------------------"
  echo -e "${GRAY}Starting ${JOB_NAME}...${NO_COLOR}\n"
}

end() {
  echo -e "${GREEN}Done!${NO_COLOR}"
  echo -e "-------------------------------------\n"
}

install() {
  gem install geminabox --no-doc --no-ri
}

#####################
# ---- Install ---- #
#####################

begin

install
ask

end
