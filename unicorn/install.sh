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

GEM_HOME=/usr/local/ruby/gems
LOG_FOLDER=/var/log/unicorn
PID_FOLDER=/var/run/unicorn

##################
# --- config --- #
##################

GROUP=${2:-'www-data'}
JOB_NAME='Unicorn#install'
SITE_NAME=${3:-'danca'}
USERNAME=${1:-'deploy'}

# folders
SITE_NAME_HOME=/var/www/${SITE_NAME}
CONFIG_FOLDER=${SITE_NAME_HOME}/config

# files
CONFIG_FILE=${CONFIG_FOLDER}/unicorn.rb
INIT_FILE=/etc/init/unicorn.conf

# local
LOCAL_FOLDER=/tmp/installers/unicorn
LOCAL_INIT_FILE=${LOCAL_FOLDER}/etc/init/unicorn.conf
LOCAL_CONFIG_FILE=${LOCAL_FOLDER}/config/unicorn.rb

#####################
# --- functions --- #
#####################

begin() {
  echo -e "-------------------------------------"
  echo -e "${GRAY}Starting ${JOB_NAME}...${NO_COLOR}\n"
}

copy_init_conf() {
  cat $LOCAL_INIT_FILE | \
  sed s,{{app_home}},${APP_HOME},g | \
  sed s,{{gem_home}},${GEM_HOME},g | \
  sed s,{{group}},${GROUP},g | \
  sed s,{{unicorn_file}},${CONFIG_FILE},g | \
  sed s,{{username}},${USERNAME},g > $INIT_FILE
}

copy_unicorn_conf() {
  cat $LOCAL_CONFIG_FILE | \
  sed s,{{site_name}},${SITE_NAME},g > $CONFIG_FILE
}

end() {
  echo -e "${GREEN}Done!${NO_COLOR}"
  echo -e "-------------------------------------\n"
}

prepare() {
  mkdir -p $CONFIG_FOLDER
  mkdir -p $LOG_FOLDER
  mkdir -p $PID_FOLDER

  chown -R ${USERNAME}:${GROUP} $CONFIG_FOLDER
  chown -R ${USERNAME}:${GROUP} $LOG_FOLDER
  chown -R ${USERNAME}:${GROUP} $PID_FOLDER
  chown -R ${USERNAME}:${GROUP} $SITE_NAME_HOME
}

###################
# --- install --- #
###################

begin

prepare
copy_init_conf
copy_unicorn_conf

end
