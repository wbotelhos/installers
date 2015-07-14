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

JOB_NAME='Java#install'

FILE=~/.bash_profile
VAR_HOME='export JAVA_HOME=/usr/lib/jvm/java-8-oracle'
VAR_EXPORT='export PATH=${PATH}:${JAVA_HOME}/bin'

#####################
# --- Functions --- #
#####################

add_to_file() {
  ENTRY=$1

  RESULT=$(grep "${ENTRY}" $FILE)

  [ "${RESULT}" == '' ] && echo $ENTRY >> $FILE

  source $FILE
}

begin() {
  echo -e "-------------------------------------"
  echo -e "${GRAY}Starting ${JOB_NAME}...${NO_COLOR}\n"
}

echo_var() {
  echo $VAR_HOME >> $FILE
  echo $VAR_EXPORT >> $FILE
}

end() {
  echo -e "${GREEN}Done!${NO_COLOR}"
  echo -e "-------------------------------------\n"
}

install() {
  sudo add-apt-repository ppa:webupd8team/java
  sudo apt-get update -qq -y
  sudo apt-get install oracle-java8-installer -qq -y
}

reload() {
  source $FILE
}

version() {
  echo -en "\n${YELLOW}Version now:${NO_COLOR} "
}

#####################
# ---- Install ---- #
#####################

begin

install
echo_var
reload
version
echo $(java -version)

end
