#!/bin/bash

INSTALLERS_PATH=~/workspace/installers
source ${INSTALLERS_PATH}/common.sh

##########################
# --- Configurations --- #
##########################

JOB_NAME='Sublime#download'
VERSION='2.0.2'
ARCH='x64'
EXTENSION='tar.bz2'
SITE='http://www.sublimetext.com/2'

#######################
# ---- Functions ---- #
#######################

install() {
  # data
  CHOSEN_VERSION=$1
  FOLDER_NAME="sublime-${CHOSEN_VERSION}-${ARCH}"
  FILE_NAME="${FOLDER_NAME}.${EXTENSION}"
  DOWNLOAD_URL="http://c758482.r82.cf2.rackcdn.com/Sublime%20Text%20${CHOSEN_VERSION}%20${ARCH}.${EXTENSION}"

  # download
  download

  # clean
  rm -rf ${DEVELOPMENT_PATH}/${FOLDER_NAME}

  # extract
  tar jxf ${DEVELOPMENT_PATH}/${FILE_NAME}
}

#################
# ---- Ask ---- #
#################

begin

ask_version

end
