#!/bin/bash

##################
# --- common --- #
##################

GRAY='\033[0;36m'
GREEN='\033[0;32m'
INSTALL_DIR=/usr/local
NO_COLOR='\033[1;0m'
RED='\033[1;31m'
SRC=${INSTALL_DIR}/src
YELLOW='\033[1;33m'

if [ $UID != 0 ]; then
  echo -e "${YELLOW}You need to be root!${NO_COLOR}\n"
  exit 1
fi

[ ! -d $SRC ] && mkdir -p $SRC

##################
# --- config --- #
##################

APP_NAME='git'
COMMAND=$1
EXTENSION='tar.gz'
JOB_NAME="Git#${COMMAND}"
SITE='https://www.kernel.org/pub/software/scm/git'
VERSION=$2

CURRENT="${INSTALL_DIR}/${APP_NAME}/current"
PREFIX="${INSTALL_DIR}/${APP_NAME}/${VERSION}"

FOLDER_NAME="git-${VERSION}"
FILE_NAME="${FOLDER_NAME}.${EXTENSION}"
DOWNLOAD_URL="https://www.kernel.org/pub/software/scm/git/${FILE_NAME}"

#####################
# --- functions --- #
#####################

activate() {
  check_install
  deactivate
  current_link
  create_links
  version
}

begin() {
  echo -e '-------------------------------------'
  echo -e "${GRAY}Starting ${JOB_NAME}...${NO_COLOR}\n"
}

check_current() {
  [ ! -L $CURRENT ] && exit
}

check_install() {
  [ ! -d $PREFIX ] && install
}

clean() {
  rm -rf ${SRC}/${FOLDER_NAME}
}

compile() {
  make && make install
}

configure() {
  cd $FOLDER_NAME

  ./configure --prefix=${PREFIX}
}

create_links() {
  for dir in bin sbin; do
    [ ! -d "${CURRENT}/${dir}" ] && continue

    for file in $(ls ${PREFIX}/${dir}); do
      ln -s "${CURRENT}/${dir}/${file}" "/usr/local/${dir}/${file}"
    done
  done
}

current_link() {
  ln -s $PREFIX $CURRENT
}

deactivate() {
  check_current
  remove_links
}

dependencies() {
  apt-get install build-essential     -qq -y
  apt-get install gettext             -qq -y
  apt-get install libcurl4-gnutls-dev -qq -y
  apt-get install libexpat1-dev       -qq -y
}

download() {
  cd $SRC

  if [ ! -e $FILE_NAME ]; then
    echo -e "Downloading from ${DOWNLOAD_URL}"

    wget -qO $FILE_NAME $DOWNLOAD_URL 2> /dev/null

    if [ $? != 0 ]; then
      echo -e "${RED}Invalid version (${VERSION}), check avaliable one at: ${SITE}\n${NO_COLOR}"
      exit 1
    fi
  fi
}

end() {
  echo -e "\n${GREEN}Done!${NO_COLOR}"
  echo -e "-------------------------------------\n"
}

extract_tar_bz2() {
  clean
  tar jxf ${SRC}/${FILE_NAME}
}

extract_tar_gz() {
  clean
  tar zxf ${SRC}/${FILE_NAME}
}

install() {
  download
  extract_tar_gz
  dependencies
  prepare
  configure
  compile
}

prepare() {
  mkdir -p $PREFIX
}

remove_links() {
  for dir in bin sbin; do
    [ ! -d "${CURRENT}/${dir}" ] && continue

    for file in $(ls ${CURRENT}/${dir}); do
      ITEM="${INSTALL_DIR}/${dir}/${file}"

      [ -L $ITEM ] && unlink $ITEM
    done
  done

  unlink $CURRENT
}

version() {
  echo
  echo $(git --version)
}

###################
# --- install --- #
###################

begin

case "${COMMAND}" in
  install)
    install
  ;;

  activate)
    activate
  ;;

  deactivate)
    deactivate
  ;;

  *)
    echo -e "${YELLOW}Usage: ${0} {install|activate|deactivate} {version}${NO_COLOR}\n"
    exit 3
  ;;
esac

end
