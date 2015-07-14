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

JOB_NAME='MongoDB#install'

DEVELOPMENT_PATH=~/Development
SITE='http://downloads-distro.mongodb.org/repo/ubuntu-upstart/dists/dist/10gen/binary-amd64'

#####################
# --- Functions --- #
#####################

add_source() {
  URL='deb http://downloads-distro.mongodb.org/repo/ubuntu-upstart dist 10gen'

  echo $URL | sudo tee '/etc/apt/sources.list.d/mongodb.list'
}

ask() {
  read -p "Check the version number at <${SITE}>, type it and press ENTER: " VERSION

  if [ "$VERSION" == '' ]; then
    echo -e "${RED}Version missing, install aborted!${NO_COLOR}\n"
    exit 1
  fi
}

begin() {
  echo -e "-------------------------------------"
  echo -e "${GRAY}Starting ${JOB_NAME}...${NO_COLOR}\n"
}

end() {
  echo -e "${GREEN}Done!${NO_COLOR}"
  echo -e "-------------------------------------\n"
}

import_key() {
  sudo apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv 7F0CEB10
}

install() {
  sudo apt-get install mongodb-org=$VERSION        -qq -y
  sudo apt-get install mongodb-org-server=$VERSION -qq -y
  sudo apt-get install mongodb-org-shell=$VERSION  -qq -y
  sudo apt-get install mongodb-org-mongos=$VERSION -qq -y
  sudo apt-get install mongodb-org-tools=$VERSION  -qq -y
}

update() {
  sudo apt-get update -qq -y
}

version() {
  echo -e "\n${YELLOW}Version now:${NO_COLOR} ${1}\n"
}

###################
# --- Install --- #
###################

begin

ask
import_key
add_source
update
install
version $(mongo --version | rev | cut -d ' ' -f 1 | rev)

end
