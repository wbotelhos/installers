#!/bin/bash

INSTALLERS_PATH=~/workspace/installers
source ${INSTALLERS_PATH}/common.sh

##########################
# --- Configurations --- #
##########################

ARCH='amd64'
EXTENSION='deb'
JOB_NAME='Chrome#install'
SITE='https://www.google.com/chrome'
VERSION='stable_current'

#####################
# --- Functions --- #
#####################

install() {
  # data
  FOLDER_NAME="google-chrome-stable_current_${ARCH}"
  FILE_NAME="${FOLDER_NAME}.${EXTENSION}"
  DOWNLOAD_URL="https://dl.google.com/linux/direct/google-chrome-${VERSION}_${ARCH}.${EXTENSION}"

  # download
  download

  # clean
  rm -rf ${DEVELOPMENT_PATH}/${FOLDER_NAME}

  # compile
  sudo dpkg -i ${DEVELOPMENT_PATH}/${FILE_NAME}

  # check version
  version `google-chrome --version | rev | cut -d ' ' -f 2`
}

#####################
# ---- Install ---- #
#####################

begin

install

end
