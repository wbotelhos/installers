#!/bin/bash

##################
# --- common --- #
##################

GRAY='\033[0;36m'
GREEN='\033[0;32m'
NO_COLOR='\033[1;0m'

##################
# --- config --- #
##################

JOB_NAME='Bundler#install'

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
  gem install bundler --no-doc --no-ri
}

version() {
  echo
  echo $(bundler -v)
}

###################
# --- install --- #
###################

begin

install
version

end
