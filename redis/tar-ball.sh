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

FILE_PATH=$(echo $0 | sed 's,/install.sh,,g')

##########################
# --- Configurations --- #
##########################

JOB_NAME='Redis#install'

DEVELOPMENT_PATH=~/Development
FILE=~/.bash_profile
REDIS_PATH=/usr/local/redis
SITE='http://download.redis.io/releases'
VAR_EXPORT='export PATH=${PATH}:${REDIS_HOME}/src'
VAR_HOME='export REDIS_HOME=${REDIS_PATH}'

#####################
# --- Functions --- #
#####################

add_to_file() {
  ENTRY=$1

  RESULT=$(grep "${ENTRY}" $FILE)

  [ "${RESULT}" == '' ] && echo $ENTRY >> $FILE

  source $FILE
}

ask() {
  read -p "Check the version number at <${SITE}>, type it and press ENTER: " VERSION

  if [ "$VERSION" == '' ]; then
    echo -e "${RED}Version missing, install aborted!${NO_COLOR}\n"
    exit 1
  fi

  FILE_NAME="redis-${VERSION}"
  DOWNLOAD_URL="http://download.redis.io/releases/redis-"${VERSION}".tar.gz"
}

begin() {
  echo -e "-------------------------------------"
  echo -e "${GRAY}Starting ${JOB_NAME}...${NO_COLOR}\n"
}

compile() {
  cd $REDIS_PATH
  make > tmp 2>&1 && make install > tmp 2>&1 # TODO: execs was created only with install, so i couldn't just to create a symlink to redis_home/src/....
}

config() {
  cp ${FILE_PATH}/redis.conf $REDIS_PATH
}

download() {
  cd $DEVELOPMENT_PATH

  if [ ! -e ${FILE_NAME}.tar.gz ]; then
    echo -e "\nDownloading from ${DOWNLOAD_URL}"

    wget $DOWNLOAD_URL 2> /dev/null

    if [ $? != 0 ]; then
      echo -e "${RED}Incorret version (${VERSION}), check it out: ${SITE}\n${NO_COLOR}"
      exit 1
    fi
  fi
}

echo_var() {
  echo $VAR_HOME >> $FILE
  echo $VAR_EXPORT >> $FILE
}

end() {
  echo -e "${GREEN}Done!${NO_COLOR}"
  echo -e "-------------------------------------\n"
}

reload() {
  source $FILE
}

set_init() {
  sudo cp ${FILE_PATH}/redis-server /etc/init.d

  sudo update-rc.d -f redis-server remove
  sudo update-rc.d redis-server defaults
}

setup() {
  rm -rf $FILE_NAME
  tar zxf ${FILE_NAME}.tar.gz
  sudo rm -rf $REDIS_PATH
  sudo ln -s $(pwd)/$FILE_NAME $REDIS_PATH

  cd -
}

version() {
  echo -e "\n${YELLOW}Version now:${NO_COLOR} ${1}\n"
}

###################
# --- Install --- #
###################

begin

ask
download
setup
compile
config
echo_var
set_init
reload
version $(redis-cli --version | rev | cut -d ' ' -f 1 | rev)

end
