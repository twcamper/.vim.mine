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


case $1 in
  clean ) clean $HOME;;
  local_install  ) local_install $HOME;;
esac
