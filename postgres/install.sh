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

SITE_NAME=${3:-'blogy'}
DATABASE=${2:-'blogy_production'}
USERNAME=${1:-'deploy'}

##################
# --- config --- #
##################

JOB_NAME="Postgres#install"

# folders
CONFIG_FOLDER=/var/www/${SITE_NAME}/config

# files
DATABASE_FILE=${CONFIG_FOLDER}/database.yml
PG_HBA_FILE=/etc/postgresql/*/main/pg_hba.conf

# local
LOCAL_FOLDER=/tmp/installers/postgres
LOCAL_DATABASE_FILE=${LOCAL_FOLDER}/config/database.yml
LOCAL_PG_HBA_FILE=${LOCAL_FOLDER}/config/pg_hba.conf

#####################
# --- functions --- #
#####################

apt_get() {
  apt-get install postgresql-server-dev-all -qq -y
  apt-get install postgresql-contrib        -qq -y
  apt-get install postgresql                -qq -y
}

ask_password() {
  echo
  read -sp "${1}" PASSWORD

  if [ "${PASSWORD}" == '' ]; then
    echo -e "${RED}Password missing!${NO_COLOR}\n" && exit 1
  fi
}

begin() {
  echo -e "-------------------------------------"
  echo -e "${GRAY}Starting ${JOB_NAME}...${NO_COLOR}\n"
}

change_password() {
  sudo -u postgres psql template1 -c "ALTER USER $1 with password '${PASSWORD}';"
}

copy_database_conf() {
  cat $LOCAL_DATABASE_FILE | \
  sed s,{{database}},${DATABASE},g | \
  sed s,{{password}},${PASSWORD},g | \
  sed s,{{username}},${USERNAME},g > $DATABASE_FILE
}

create_db() {
  sudo -u postgres createdb $DATABASE
}

create_user() {
  sudo -u postgres psql -c "CREATE ROLE $1 WITH createdb login password '${PASSWORD}';"
}

end() {
  echo -e "${GREEN}Done!${NO_COLOR}"
  echo -e "-------------------------------------\n"
}

prepare() {
  mkdir -p $CONFIG_FOLDER
}

set_pg_hba() {
  cat $LOCAL_PG_HBA_FILE | sed s,{{method}},${1},g > $DATABASE_FILE
}

start() {
  service postgresql start
}

stop() {
  service postgresql stop
}

version() {
  echo $(postgres -v)
}

###################
# --- install --- #
###################

begin

apt_get
stop && \
set_pg_hba trust && \
start && \
ask_password '"postgres" new password: ' && \
change_password postgres && \
ask_password "\"${USERNAME}\" new password: " && \
create_user $USERNAME && \
create_db && \
set_pg_hba md5 && \
prepare && \
copy_database_conf

end
