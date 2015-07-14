#!/bin/bash

##################
# --- Common --- #
##################

GRAY='\033[0;36m'
GREEN='\033[0;32m'
NO_COLOR='\033[1;0m'
YELLOW='\033[1;33m'

##########################
# --- Configurations --- #
##########################

JOB_NAME='Phantomjs#install'

ARCH='x86_64'
DEVELOPMENT_PATH=~/Development
SITE='https://bitbucket.org/ariya/phantomjs/downloads'

#####################
# --- Functions --- #
#####################

ask() {
  read -p "Check the version number at <${SITE}>, type it and press ENTER: " VERSION

  if [ "$VERSION" == '' ]; then
    echo -e "${RED}Version missing, install aborted!${NO_COLOR}\n"
    exit 1
  fi

  FILE_NAME='phantomjs-'${VERSION}'-linux-'${ARCH}
  DOWNLOAD_URL='https://bitbucket.org/ariya/phantomjs/downloads/'${FILE_NAME}'.tar.bz2'
}

begin() {
  echo -e "-------------------------------------"
  echo -e "${GRAY}Starting ${JOB_NAME}...${NO_COLOR}\n"
}

download() {
  cd $DEVELOPMENT_PATH

  if [ ! -e ${FILE_NAME}.tar.bz2 ]; then
    echo -e "\nDownloading from ${DOWNLOAD_URL}"

    wget $DOWNLOAD_URL 2> /dev/null

    if [ $? != 0 ]; then
      echo -e "${RED}Incorret version (${VERSION}), check it out: ${SITE}\n${NO_COLOR}"
      exit 1
    fi
  fi
}

end() {
  echo -e "${GREEN}Done!${NO_COLOR}"
  echo -e "-------------------------------------\n"
}

move() {
  rm -rf $FILE_NAME
  tar jxf ${FILE_NAME}.tar.bz2

  CURRENT=$(pwd)

  sudo ln -s ${CURRENT}/${FILE_NAME}/bin/phantomjs /usr/bin/phantomjs
  sudo ln -s ${CURRENT}/${FILE_NAME}/bin/phantomjs /usr/local/bin/phantomjs
  sudo ln -s ${CURRENT}/${FILE_NAME}/bin/phantomjs /usr/local/share/phantomjs

  cd -
}

remove() {
  sudo apt-get remove phantomjs -qq -y
  sudo apt-get purge phantomjs -qq -y
}

unlink() {
  sudo rm -f /usr/local/bin/phantomjs
  sudo rm -f /usr/local/share/phantomjs
  sudo rm -f /usr/bin/phantomjs
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
remove
unlink
move
version $(phantomjs -v)

end
