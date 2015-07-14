#!/bin/bash

##################
# --- common --- #
##################

GRAY='\033[0;36m'
GREEN='\033[0;32m'
NO_COLOR='\033[1;0m'
YELLOW='\033[1;33m'

##################
# --- config --- #
##################

COMMAND=$1
FILE=~/.gemrc
JOB_NAME="RubyGems#${COMMAND}"
LOCAL_FOLDER=/tmp/installers/rubygems
LOCAL_FILE=${LOCAL_FOLDER}/gemrc

#####################
# --- functions --- #
#####################

begin() {
  echo -e "-------------------------------------"
  echo -e "${GRAY}Starting ${JOB_NAME}...${NO_COLOR}\n"
}

clean() {
  rm -rf $FILE
}

copy_file() {
  cp $LOCAL_FILE $FILE
}

end() {
  echo -e "\n${GREEN}Done!${NO_COLOR}"
  echo -e "-------------------------------------\n"
}

update() {
  gem update --no-document
}

version() {
  echo
  echo $(gem -v)
}

###################
# --- install --- #
###################

begin

case "${COMMAND}" in
  install)
    clean
    copy_file
    update
    version
  ;;

  uninstall)
    clean
  ;;

  *)
    echo -e "${YELLOW}Usage: ${0} {install|uninstall}${NO_COLOR}\n"
    exit 3
  ;;
esac

end
