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

###################
# --- configs --- #
###################

JOB_NAME='Server#install'

#####################
# --- functions --- #
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
  sudo /tmp/installers/server/bash.sh
  sudo /tmp/installers/server/path.sh
  sudo /tmp/installers/unix/update.sh
  sudo /tmp/installers/user/create.sh deploy www-data

  sudo /tmp/installers/nginx/nginx.sh activate 1.13.2
  sudo /tmp/installers/nginx/nginx.sh configure

  sudo /tmp/installers/ruby/ruby.sh activate 2.4.1
  sudo /tmp/installers/git/git.sh activate 2.13.2
  sudo /tmp/installers/nodejs/install.sh
  sudo /tmp/installers/unicorn/install.sh deploy www-data blogy
  sudo /tmp/installers/java/install.sh

  sudo /tmp/installers/postgres/install.sh deploy blogy_production blogy

  /tmp/installers/rubygems/rubygems.sh install
  /tmp/installers/bundler/install.sh
}

###################
# --- install --- #
###################

begin

install

end
