#! /usr/bin/env bash

LOCAL_TARGETS=".vimrc .vimrc.before .vimrc.after .gvimrc.before .gvimrc.after"

local_install()
{
  local HOME=$1
  save $HOME
  case `uname -s` in
    Linux )
      ln -s $HOME/.vim.mine/linux/local_install/.vimrc $HOME/.vimrc
      ln -s $HOME/.vim.mine/linux/local_install/.vimrc.after $HOME/.vimrc.after
      ln -s $HOME/.vim.mine/linux/.gvimrc.after $HOME/.gvimrc.after
      ;;
    Darwin )
      ln -s $HOME/.vim.mine/linux/local_install/.vimrc.after
      ;;
  esac

}

save()
{
  local HOME=$1
  for t in $LOCAL_TARGETS
  do
    path=$HOME/$t
    if [ -e "$path" ]
    then
      mv $path $path.old
    fi
  done
}

clean()
{
  local HOME=$1
  for t in $LOCAL_TARGETS
  do
    path=$HOME/$t
    if [ -e $path ]
    then
      #echo $path.old
      if [ -e "$path.old" ]
      then
        mv $path.old $path
      else
        rm $path
      fi
    fi
  done
}

clean_global()
{
  echo clean_global
}

case $1 in
  clean ) clean $HOME;;
  local_install  ) local_install $HOME;;
esac

###  NOTES ####
# Global install
# 0 - write clean_global()
# 1 - (as root) ln -s $INSTALLING_USER_HOME/.vim.mine/common/settings.vim /etc/vim/vimrc.local
# 2 - installing user home
#        - save
#        - links to:
#             $HOME/.vim.mine/linux/global_install/.vimrc
#             $HOME/.vim.mine/linux/global_install/.vimrc.after
#             $HOME/.vim.mine/linux/.gvimrc.after
# 3 - root dir (as root)
#        - save
#        - links to:
#             $INSTALLING_USER_HOME/.vim  # janus dir needed for source calls?
#             $INSTALLING_USER_HOME/.vim.mine  #  needed for source calls?
#             $INSTALLING_USER_HOME/.vimrc
#             $INSTALLING_USER_HOME/.vimrc.after
#             if $INSTALLING_USER_HOME/.gvimrc
#                 $INSTALLING_USER_HOME/.gvimrc 
#                 $INSTALLING_USER_HOME/.gvimrc.after
# 4 - each remaining /home/dir
#      1 - same as root dir install
#      2 - chown the links to user:group
#           HAVE A GOOD THINK ABOUT THE GROUP PERMISSIONS FOR THIS!!
#             we probably want to create a special group and add root and /home/everybody
#
# OTHER CASES
#  1 - mac global
#  2 - no janus (linux local and global, mac local and global)
#        - is .gvimrc a sym link to janus or a regular file?
