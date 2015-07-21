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
  create_current_link
  create_links
}

activation() {
  install

  deactivate
  activate

  version
}

begin() {
  echo -e '-------------------------------------'
  echo -e "${GRAY}Starting ${JOB_NAME}...${NO_COLOR}\n"
}

create_current_link() {
  if [ -L $CURRENT ]; then
    echo -e "[check current] link ${PREFIX} already exists"
  else
    echo -e "[check current] link ${CURRENT} does not exists"

    create_current_link
  fi
}

clean() {
  echo -e "[clean] ${SRC}/${FILE_NAME}"

  rm -rf ${SRC}/${FOLDER_NAME}
}

compile() {
  echo -e "[compile] making"

  make
  make install
}

configure() {
  echo -e "[configure] prefix as ${PREFIX}"

  cd $FOLDER_NAME

  ./configure --prefix=${PREFIX}
}

create_links() {
  for dir in bin sbin; do
    if [ ! -d "${CURRENT}/${dir}" ]; then
      echo -e "[create_links] skipping ${CURRENT}/${dir}"

      continue
    fi

    for file in $(ls ${PREFIX}/${dir}); do
      from=/usr/local/${dir}/${file}
      to=${CURRENT}/${dir}/${file}

      echo -e "[create_links] creating ${from} -> ${to}"

      ln -s $to $from
    done
  done
}

create_current_link() {
  echo -e "[create_current_link] linking ${CURRENT} -> ${PREFIX}"

  ln -s $PREFIX $CURRENT
}

deactivate() {
  remove_current_link
  remove_links
}

dependencies() {
  echo -e "[dependencies] ${SRC}/${FILE_NAME}"

  apt-get install build-essential     -qq -y
  apt-get install gettext             -qq -y
  apt-get install libcurl4-gnutls-dev -qq -y
  apt-get install libexpat1-dev       -qq -y
}

download() {
  echo -e "[download] downloading ${FILE_NAME} on ${SRC} from ${DOWNLOAD_URL}"

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
  echo -e "[extract] ${SRC}/${FILE_NAME}"

  clean
  tar zxf ${SRC}/${FILE_NAME}
}


install() {
  if [ -d $PREFIX ]; then
    echo -e "[check install] installation (${PREFIX}) already installed"
  else
    echo -e "[check install] installation (${PREFIX}) does not exists"

    install
  fi
}

installation() {
  echo -e "[install] starting..."

  download
  extract_tar_gz
  dependencies
  prepare
  configure
  compile
}

prepare() {
  echo -e "[prepare] making dir ${PREFIX}"

  mkdir -p $PREFIX
}

remove_current_link() {
  if [ -L $CURRENT ]; then
    echo -e "[remove_current_link] removing (${CURRENT})"

    unlink $CURRENT
  else
    echo -e "[remove_current_link] link ${CURRENT} does not exists"
  fi
}

remove_links() {
  echo -e "[remove_links] starting..."

  for dir in bin sbin; do
    if [ ! -d "${CURRENT}/${dir}" ]; then
      echo -e "[remove_links] skipping ${CURRENT}/${dir}"

      continue
    fi

    for file in $(ls ${CURRENT}/${dir}); do
      item="${INSTALL_DIR}/${dir}/${file}"

      if [ -L $item ]; then
        echo -e "[remove_links] removing ${item}"

        unlink $item
      fi
    done
  done
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
    installation
  ;;

  activate)
    activation
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
