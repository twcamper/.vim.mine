#! /usr/bin/env bash

ALL_ARGS_AS_A_STRING=$*
THIS_SCRIPT_FILE=$0
SCRIPT_DIR="$( cd  "$( dirname $THIS_SCRIPT_FILE )" && pwd )"

# the NON-ROOT home dir of the installing user, i.e., the runner of this script
# DO NOT RUN AS ROOT! pattern is for "/{home,Users}/username"
MAIN_USER_HOME=`echo $SCRIPT_DIR | grep -oE "^/(home|Users)/[^\/]+"`
MAIN_USER=`basename $MAIN_USER_HOME`

source $SCRIPT_DIR/lib/common.sh
case `uname -s` in
  Linux )
    USERS_HOME=/home
    source $SCRIPT_DIR/lib/gnu-linux.sh
    ;;
  Darwin )
    USERS_HOME=/Users
    source $SCRIPT_DIR/lib/mac.sh
    ;;
esac

if [[ `id -u` == 0 ]]; then
  ROOT_HOME=$HOME

  #######################################################
  #
  # RUN FUNCTION (SUB-ROUTINE) AS ROOT
  #
  # '$@' is all arguments, i.e., the function name ($1)
  #       and any subsequent args ($2, etc)
  #
  # This is called from a 'sudo' call below.
  #######################################################
  $@
else
  ###########################
  #
  # VALIDATE AND RUN USER CLI COMMAND
  #
  ###########################
  case $ALL_ARGS_AS_A_STRING in
    clean\ self )
      clean $HOME
      ;;
    clean\ all[-_]users )
      sudo $THIS_SCRIPT_FILE clean_all
      ;;
    self )
      install_to_my_home
      ;;
    all[-_]users )
      sudo $THIS_SCRIPT_FILE install_for_all_users
      ;;
    restore[-_]janus )
      restore_janus_links
      ;;
    * )
      echo Usage:
      echo "       $ $THIS_SCRIPT_FILE [clean] all_users|self|restore_janus"
      exit 1
  esac
fi
