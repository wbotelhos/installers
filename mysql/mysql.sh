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

################
# --- vars --- #
################

PASSWORD=$2
SITE_NAME='blogy'
USERNAME='deploy'

##################
# --- config --- #
##################

COMMAND=$1
JOB_NAME="MySQL#${COMMAND}"
DATABASE="${SITE_NAME}_production"

# folders
WWW_FOLDER=/var/www
APP_HOME=${WWW_FOLDER}/${SITE_NAME}
CONFIG_FOLDER=${APP_HOME}/config

DATABASE_FILE=${CONFIG_FOLDER}/database.yml

# local
LOCAL_FOLDER=/tmp/installers/mysql
LOCAL_DATABASE_FILE=${LOCAL_FOLDER}/config/database.yml

#####################
# --- functions --- #
#####################

begin() {
  echo -e "-------------------------------------"
  echo -e "${GRAY}Starting ${JOB_NAME}...${NO_COLOR}\n"
}

check_password() {
  PASSWORD=$1

  if [ -z $PASSWORD ]; then
    echo -e "${YELLOW}Usage: ${0} configure {password}${NO_COLOR}\n"
    exit 1
  fi
}

compile() {
  apt-get install libmysqlclient-dev -qq -y
  apt-get install mysql-client       -qq -y
  apt-get install mysql-server       -qq -y
}

copy_database_conf() {
  cat $LOCAL_DATABASE_FILE | \
  sed s,{{database}},${DATABASE},g | \
  sed s,{{password}},${PASSWORD},g | \
  sed s,{{username}},${USERNAME},g > $DATABASE_FILE
}

end() {
  echo -e "${GREEN}Done!${NO_COLOR}"
  echo -e "-------------------------------------\n"
}

prepare() {
  mkdir -p $CONFIG_FOLDER
}

version() {
  echo $(mysql -v)
}

###################
# --- install --- #
###################

begin

case "${COMMAND}" in
  configure)
    check_password $2
    prepare
    copy_database_conf
    mysql_secure_installation
  ;;

  install)
    compile
  ;;

  *)
    echo -e "${YELLOW}Usage: ${0} {install|configure}${NO_COLOR}\n"
    exit 3
  ;;
esac

end
