#!/bin/bash

##################
# --- Common --- #
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

################
# --- vars --- #
################

GROUP='www-data'
SERVER_NAME='danca.me'
SITE_NAME='danca'
USERNAME='deploy'

###################
# --- configs --- #
###################

APP_NAME='nginx'
COMMAND=$1
EXTENSION='tar.gz'
JOB_NAME="NGINX#${COMMAND}"
SITE='http://nginx.org/download'
VERSION=$2

CURRENT="${INSTALL_DIR}/${APP_NAME}/current"
PREFIX="${INSTALL_DIR}/${APP_NAME}/${VERSION}"

FOLDER_NAME="nginx-${VERSION}"
FILE_NAME="${FOLDER_NAME}.${EXTENSION}"
DOWNLOAD_URL="http://nginx.org/download/${FILE_NAME}"

# static folders
ETC_FOLDER=/etc/nginx
INIT_FOLDER=/etc/init
LIB_FOLDER=/var/lib/nginx
LOG_FOLDER=/var/log/nginx
PID_FOLDER=/var/run/nginx/
WWW_FOLDER=/var/www

# static files
LOCK_FILE=/var/lock/nginx.lock

# folders
BODY_FOLDER=${LIB_FOLDER}/body
FASTCGI_FOLDER=${LIB_FOLDER}/fastcgi
PROXY_FOLDER=${LIB_FOLDER}/proxy
SITES_AVAILABLE_FOLDER=${ETC_FOLDER}/sites-available
SITES_ENABLED_FOLDER=${ETC_FOLDER}/sites-enabled
SSL_FOLDER=${ETC_FOLDER}/ssl

AVAILABLE_SITE_FILE=${SITES_AVAILABLE_FOLDER}/${SITE_NAME}.conf
ENABLED_SITE_FILE=${SITES_ENABLED_FOLDER}/${SITE_NAME}.conf

# files
ACCESS_LOG_FILE=${LOG_FOLDER}/access.log
CONF_FILE=${ETC_FOLDER}/nginx.conf
ERROR_LOG_FILE=${LOG_FOLDER}/error.log
INIT_FILE=${INIT_FOLDER}/nginx.conf
SITE_ENABLED_FILE=${ETC_FOLDER}/sites-enabled/${SITE_NAME}.conf

# local
LOCAL_FOLDER=/tmp/installers/nginx
LOCAL_CONF_FILE=${LOCAL_FOLDER}/etc/nginx/nginx.conf
LOCAL_INIT_FILE=${LOCAL_FOLDER}/etc/init/nginx.conf
LOCAL_SITE_FILE=${LOCAL_FOLDER}/etc/nginx/sites-available/site.conf

#####################
# --- Functions --- #
#####################

begin() {
  echo -e "-------------------------------------"
  echo -e "${GRAY}Starting ${JOB_NAME}...${NO_COLOR}\n"
}

check_current() {
  [ ! -L $CURRENT ] && exit
}

check_install() {
  [ ! -d $PREFIX ] && ${0} install $VERSION
}

clean() {
  rm -rf ${SRC}/${FOLDER_NAME}
}

compile() {
  make && make install
}

configure() {
  cd $FOLDER_NAME

  ./configure --prefix=${PREFIX} \
    --conf-path=${CONF_FILE} \
    --http-client-body-temp-path=${BODY_FOLDER} \
    --http-fastcgi-temp-path=${FASTCGI_FOLDER} \
    --http-proxy-temp-path=${PROXY_FOLDER} \
    --lock-path=${LOCK_FILE} \
    --with-debug \
    --with-http_gzip_static_module \
    --with-http_realip_module \
    --with-http_ssl_module \
    --with-ipv6
}

copy_app_conf() {
  cat $LOCAL_CONF_FILE | \
  sed s,{{group}},${GROUP},g | \
  sed s,{{site_name}},${SITE_NAME},g | \
  sed s,{{username}},${USERNAME},g > $CONF_FILE
}

copy_init_conf() {
  cat $LOCAL_INIT_FILE | \
  sed s,{{install_dir}},${INSTALL_DIR},g > $INIT_FILE
}

copy_site_conf() {
  cat $LOCAL_SITE_FILE | \
  sed s,{{group}},${GROUP},g | \
  sed s,{{server_name}},${SERVER_NAME},g | \
  sed s,{{site_name}},${SITE_NAME},g | \
  sed s,{{username}},${USERNAME},g > $AVAILABLE_SITE_FILE
}

create_links() {
  for dir in bin sbin; do
    [ ! -d "${CURRENT}/${dir}" ] && continue

    for file in $(ls ${PREFIX}/${dir}); do
      ln -s "${CURRENT}/${dir}/${file}" "/usr/local/${dir}/${file}"
    done
  done
}

create_site_link() {
  [ -L $ENABLED_SITE_FILE ] && unlink $ENABLED_SITE_FILE

  ln -s $AVAILABLE_SITE_FILE $ENABLED_SITE_FILE
}

current_link() {
  ln -s $PREFIX $CURRENT
}

dependencies() {
  # Support regex whose syntax and semantics are close of the Perl 5.
  # http://packages.debian.org/wheezy/libpcre3-dev
  apt-get install libpcre3-dev -qq -y


  # Part of the OpenSSL implementation of SSL.
  # https://packages.debian.org/wheezy/libssl-dev
  apt-get install libssl-dev -qq -y

  # Implementing the deflate compression method found in gzip and PKZIP.
  # http://packages.debian.org/wheezy/zlib1g-dev
  apt-get install zlib1g-dev -qq -y
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
  echo -e "${GREEN}Done!${NO_COLOR}"
  echo -e "-------------------------------------\n"
}

extract() {
  clean
  tar zxf ${SRC}/${FILE_NAME}
}

force_deactivate() {
  ${0} deactivate
}

installed() {
  echo -e "\n${YELLOW}Run '${0} activate ${VERSION}' to activate this version.${NO_COLOR}\n"
}

prepare() {
  mkdir -p $BODY_FOLDER
  mkdir -p $ETC_FOLDER
  mkdir -p $FASTCGI_FOLDER
  mkdir -p $INIT_FOLDER
  mkdir -p $LIB_FOLDER
  mkdir -p $LOG_FOLDER
  mkdir -p $PID_FOLDER
  mkdir -p $PREFIX
  mkdir -p $PROXY_FOLDER
  mkdir -p $SITES_AVAILABLE_FOLDER
  mkdir -p $SITES_ENABLED_FOLDER
  mkdir -p $SSL_FOLDER
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

result() {
  echo
  echo -e "${YELLOW}-${NO_COLOR} conf-path=${CONF_FILE}"
  echo -e "${YELLOW}-${NO_COLOR} http-client-body-temp-path=${BODY_FOLDER}"
  echo -e "${YELLOW}-${NO_COLOR} http-fastcgi-temp-path=${FASTCGI_FOLDER}"
  echo -e "${YELLOW}-${NO_COLOR} http-proxy-temp-path=${PROXY_FOLDER}"
  echo -e "${YELLOW}-${NO_COLOR} lock-path=${LOCK_FILE}"
  echo -e "${YELLOW}-${NO_COLOR} prefix=${PREFIX}"
  echo -e "${YELLOW}-${NO_COLOR} with-debug"
  echo -e "${YELLOW}-${NO_COLOR} with-http_gzip_static_module"
  echo -e "${YELLOW}-${NO_COLOR} with-http_realip_module"
  echo -e "${YELLOW}-${NO_COLOR} with-http_ssl_module"
  echo -e "${YELLOW}-${NO_COLOR} with-ipv6"
  echo
}

version() {
  echo $(nginx -v)
}

###################
# --- Install --- #
###################

begin

case "${COMMAND}" in
  install)
    download
    extract
    dependencies
    prepare
    configure
    compile
    installed $0
  ;;

  activate)
    check_install
    force_deactivate
    current_link
    create_links
    result
    version
  ;;

  deactivate)
    check_current
    remove_links
  ;;

  configure)
    prepare
    copy_app_conf
    copy_site_conf
    create_site_link
    copy_init_conf
    version
  ;;

  *)
    echo -e "${YELLOW}Usage: ${0} {install|activate|deactivate|configure} {version}${NO_COLOR}\n"
    exit 3
  ;;
esac

end
