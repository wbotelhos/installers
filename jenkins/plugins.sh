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

# change it!
PLUGINS='brakeman mailer greenballs git build-monitor-plugin rubyMetrics antisamy-markup-formatter matrix-auth violations'
TOMCAT_PATH=/var/lib/tomcat
UNINSTALL='ant cvs javadoc junit ldap maven-plugin pam-auth subversion translation windows-slaves'
URL='http://localhost:8080'

JOB_NAME='Jenkins#plugins'
SITE='https://wiki.jenkins-ci.org/display/JENKINS/Plugins'

########################
# --- Dependencies --- #
########################

if [ ! -e /var/lib/tomcat ]; then
  echo -e "${RED}Install tomcat first!${NO_COLOR}\n"
  exit 1
elif [ ! -e /var/lib/tomcat/webapps ]; then
  echo -e "${RED}Install jenkins first!${NO_COLOR}\n"
  exit 1
fi

#####################
# --- Functions --- #
#####################

ask() {
  read -p 'Context path (/): ' CONTEXT

  if [ "${CONTEXT}" == '' ]; then
    CONTEXT='ROOT'
  else
    CONTEXT=`echo $CONTEXT | sed s,^\\s+,, | sed s,\\s+$,, | sed s,^/*,,`
  fi

  read -p 'User (tomcat): ' USERNAME

  if [ "${USERNAME}" == '' ]; then
    USERNAME='tomcat'
  else
    USERNAME=`whoami`
  fi

  PLUGINS_PATH=${TOMCAT_PATH}/webapps/${CONTEXT}/WEB-INF/plugins
  HOME_PLUGINS_PATH=/home/${USERNAME}/.jenkins/plugins
}

begin() {
  echo -e "-------------------------------------"
  echo -e "${GRAY}Starting ${JOB_NAME}...${NO_COLOR}\n"
}

cde() {
  cd $PLUGINS_PATH
}

dependencies() {
  DATA=`unzip -p ${PLUGINS_PATH}/${1}.hpi META-INF/MANIFEST.MF`
  DATA=`echo $DATA | tr -d ' |\r'`
  DEPS=`echo $DATA | sed 's/.*Dependencies:\(.*\)Plugin-Developers.*/\1/'`

  if ! [[ $DEPS == '' || $DEPS =~ ^Manifest.* ]]; then
    DEPS=`echo $DEPS | tr ',' '\n' | grep -v "resolution:=optional" | awk -F ':' '{print $1 }'`
    DEPS=`echo $DEPS | tr '\n' ' '`

    echo -e "${YELLOW}Dependencies:${NO_COLOR} ${DEPS}"

    for dep in $DEPS; do
      install $dep
    done
  fi
}

download() {
  echo -e "\nDownloading from $1"

  wget $1 2> /dev/null

  if [ $? != 0 ]; then
    echo -e "${RED}Incorret url ($1), check it out: ${SITE}\n${NO_COLOR}"
    exit 1
  fi
}

end() {
  echo -e "${GREEN}\nDone!${NO_COLOR}"
  echo -e "-------------------------------------\n"
}

install() {
  remove $1
  download "updates.jenkins-ci.org/latest/${1}.hpi"
  dependencies $1
}

permission() {
  chown -R ${USERNAME}:${USERNAME} $PLUGINS_PATH
}

remove() {
  rm -f ${PLUGINS_PATH}/${1}.hpi
}

restart() {
  sudo service tomcat stop
  sudo service tomcat start
}

uninstall() {
  if [ "${UNINSTALL}" == '*' ]; then
    rm -f ${PLUGINS_PATH}/*

    find ${HOME_PLUGINS_PATH}/* -type f -not -name '*.bak' | xargs rm -rf
  else
    for plugin in ${UNINSTALL}; do
      rm -f ${PLUGINS_PATH}/${plugin}

      rm -rf ${HOME_PLUGINS_PATH}/${plugin}
      rm -f ${HOME_PLUGINS_PATH}/${plugin}.jpi
    done
  fi
}

###################
# --- Install --- #
###################

begin

ask
uninstall
cde

for plugin in $PLUGINS; do
  install $plugin
done

permission
restart

end
