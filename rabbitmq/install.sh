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

JOB_NAME='RabbitMQ#install'

ADMIN_URL='http://localhost:15672'
SITE='https://www.rabbitmq.com/install-debian.html'

########################
# --- Dependencies --- #
########################

sudo apt-get -f install         -qq -y
sudo apt-get install erlang-nox -qq -y

#####################
# --- Functions --- #
#####################

ask() {
  read -p "Check the version number at <${SITE}>, type it and press ENTER: " VERSION

  if [ "$VERSION" == '' ]; then
    echo -e "${RED}Version missing, install aborted!${NO_COLOR}\n"
    exit 1
  fi

  NAMESPACE=$(echo ${VERSION} | cut -d '-' -f 1)
  FILE_NAME="rabbitmq-server_${VERSION}_all"
  DOWNLOAD_URL="https://www.rabbitmq.com/releases/rabbitmq-server/v"${NAMESPACE}"/rabbitmq-server_"${VERSION}"_all.deb"
}

begin() {
  echo -e "-------------------------------------"
  echo -e "${GRAY}Starting ${JOB_NAME}...${NO_COLOR}\n"
}

download() {
  cd $DEVELOPMENT_PATH

  if [ ! -e ${FILE_NAME}.deb ]; then
    echo -e "\nDownloading from ${DOWNLOAD_URL}"

    wget $DOWNLOAD_URL 2> /dev/null

    if [ $? != 0 ]; then
      echo -e "${RED}Incorret version (${VERSION}), check it out: ${SITE}\n${NO_COLOR}"
      exit 1
    fi
  fi
}

enable_admin() {
  sudo rabbitmq-plugins enable rabbitmq_management &2> /dev/null

  echo -e "\n${GREEN}Admin running at <${ADMIN_URL}> as (guest@guest) avaliable.${NO_COLOR}\n"
}

end() {
  echo -e "${GREEN}Done!${NO_COLOR}"
  echo -e "-------------------------------------\n"
}

move() {
  rm -rf $FILE_NAME
  sudo dpkg -i ${FILE_NAME}.deb

  cd -
}

version() {
  echo -e "\n${YELLOW}Version now:${NO_COLOR} ${1}\n"
}

#####################
# ---- Install ---- #
#####################

begin

ask
download
move
enable_admin
version $(sudo rabbitmqctl status | grep RabbitMQ | rev | cut -d '"' -f 2)

end
