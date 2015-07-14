#!/bin/bash

##################
# --- Common --- #
##################

GRAY='\033[0;36m'
GREEN='\033[0;32m'
NO_COLOR='\033[1;0m'
RED='\033[1;31m'
YELLOW='\033[1;33m'

if [ $UID != 0 ]; then
  echo -e "${YELLOW}You need to be root!${NO_COLOR}\n"
  exit 1
fi

##########################
# --- Configurations --- #
##########################

DOWNLOAD_URL='https://github.com/wbotelhos/installers/archive/master.zip'
JOB_NAME='Installers#download'
SITE='http://github.com/wbotelhos/installers'

#####################
# --- Functions --- #
#####################

begin() {
  echo -e '-------------------------------------'
  echo -e "${GRAY}Starting ${JOB_NAME}...${NO_COLOR}\n"
}

clean() {
  rm -rf /tmp/installers
  rm -f /tmp/master.zip*
}

dependencies() {
  apt-get install unzip -qq -y
}

download() {
  cd /tmp

  echo -e "Downloading from ${DOWNLOAD_URL}"
  wget -q $DOWNLOAD_URL 2> /dev/null

  if [ $? != 0 ]; then
    echo -e "${RED}Invalid url ($DOWNLOAD_URL), check it at: ${SITE}\n${NO_COLOR}"
    exit 1
  fi
}

end() {
  echo -e "${GREEN}Done!${NO_COLOR}"
  echo -e '-------------------------------------\n'
}

extract() {
  unzip -qq /tmp/master.zip
}

rename() {
  mv /tmp/installers-master /tmp/installers
}

###################
# --- Install --- #
###################

begin

dependencies
clean
download
extract
rename

end
