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

JOB_NAME='Unix#upgrade'

#####################
# --- Functions --- #
#####################

begin() {
  echo -e "-------------------------------------"
  echo -e "${GRAY}Starting ${JOB_NAME}...${NO_COLOR}\n"
}

dependencies() {
  apt-get update       -qq -y  # Downloads the updated packages list.
  apt-get upgrade      -qq -y  # Upgrades the dist (dapper).
  apt-get dist-upgrade -qq -y  # Upgrades to the next dist (edgy).
  apt-get autoremove   -qq -y  # Removes unused packages.
}

end() {
  echo -e "${GREEN}Done!${NO_COLOR}"
  echo -e "-------------------------------------\n"
}

install() {
  apt-get install autoconf         -qq -y
  apt-get install automake         -qq -y
  apt-get install bison            -qq -y
  apt-get install curl             -qq -y
  apt-get install libc6-dev        -qq -y
  apt-get install libreadline6     -qq -y
  apt-get install libreadline6-dev -qq -y
  apt-get install libsqlite3-dev   -qq -y
  apt-get install libssl-dev       -qq -y
  apt-get install libtool          -qq -y
  apt-get install libxml2-dev      -qq -y
  apt-get install libxslt-dev      -qq -y
  apt-get install libyaml-dev      -qq -y
  apt-get install make             -qq -y
  apt-get install ncurses-dev      -qq -y
  apt-get install openssl          -qq -y
  apt-get install pkg-config       -qq -y
  apt-get install sqlite3          -qq -y
  apt-get install subversion       -qq -y
  apt-get install zlib1g           -qq -y
  apt-get install zlib1g-dev       -qq -y
}

version() {
  echo $(lsb_release -a)
}

###################
# --- Install --- #
###################

begin

dependencies
install
version

end
