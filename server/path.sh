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

###################
# --- configs --- #
###################

JOB_NAME='Path#install'

#####################
# --- functions --- #
#####################

append() {
  FILE_PATH=$1
  ENTRY=$2

  RESULT=`grep "${ENTRY}" ${FILE_PATH}`

  [ "${RESULT}" == '' ] && echo $ENTRY >> $FILE_PATH
}

begin() {
  echo -e "-------------------------------------"
  echo -e "${GRAY}Starting ${JOB_NAME}...${NO_COLOR}\n"
}

end() {
  echo -e "${GREEN}Done!${NO_COLOR}"
  echo -e "-------------------------------------\n"
}

environment() {
  echo 'export PATH=/opt/local/bin:/opt/local/sbin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/usr/local/ruby/gems/bin' >  /etc/environment
  echo 'export RAILS_ENV=production'                                                                                                      >> /etc/environment
  echo 'export GEM_HOME=/usr/local/ruby/gems'                                                                                             >> /etc/environment
  echo 'export LC_ALL=en_US.UTF-8'                                                                                                        >> /etc/environment
}

profile() {
  append /etc/profile 'export PATH=/opt/local/bin:/opt/local/sbin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/usr/local/ruby/gems/bin'
  append /etc/profile 'export RAILS_ENV=production'
  append /etc/profile 'export GEM_HOME=/usr/local/ruby/gems'
  append /etc/profile 'export LC_ALL=en_US.UTF-8'
}

sudoers() {
  cp /tmp/installers/server/files/sudoers /etc/sudoers
}

begin

profile
environment
sudoers

end
