bash_vim_alias_reminder()
{
  echo
  echo "************************************************************"
  echo  Source $SCRIPT_DIR/common/bash.vim_aliases.sh
  echo  in ~/.bash_aliases or /etc/profile
  echo  if you want the Ctrl-s 'save' mapping in the console/terminal
  echo "************************************************************"
  echo
  REMINDED=true
}

ubuntu_home_reset_reminder()
{
  if uname -a | grep -i Ubuntu; then
    echo
    echo "********************************************************************"
    echo '$HOME' is reset to \"$HOME\" for user \"$USER\" on Ubuntu.
    echo Therefore, just use \"$ $0 self\" because you\'ll get all your
    echo vim settings when running as root anyway.
    echo "********************************************************************"
    echo
    exit 1
  fi
}

