#!/bin/bash

##################
# --- Common --- #
##################

GRAY='\033[0;36m'
'GREEN'='\033[0;32m'
NO_COLOR='\033[1;0m'
YELLOW='\033[1;33m'

##########################
# --- Configurations --- #
##########################

JOB_NAME='RVM#install'

ENTRY='source ~/.rvm/scripts/rvm'
FILE=~/.bash_profile

#####################
# --- Functions --- #
#####################

add_to_file() {
  ENTRY=$1

  RESULT=`grep "${ENTRY}" $FILE`

  [ "${RESULT}" == '' ] && echo $ENTRY >> $FILE
}

begin() {
  echo -e "-------------------------------------"
  echo -e "${GRAY}Starting ${JOB_NAME}...${NO_COLOR}\n"
}

download_signatures() {
  curl -sSL https://rvm.io/mpapis.asc | gpg --import -
}

end() {
  echo -e "${GREEN}Done!${NO_COLOR}"
  echo -e "-------------------------------------\n"
}

reload() {
  source $FILE
}

install() {
  curl -L get.rvm.io | bash -s stable

  rvm get latest
}

version() {
  echo -e "\n${YELLOW}Version now:${NO_COLOR} ${1}\n"
}

#####################
# ---- Install ---- #
#####################

begin

download_signatures
install
add_to_file $ENTRY
reload
version $(rvm -v | head -1 | cut -d ' ' -f 2)

end
