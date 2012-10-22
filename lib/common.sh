has_janus()
{
  [[ -e $MAIN_USER_HOME/.vim/janus/vim/vimrc ]]
}

restore_janus_links()
{
  ln -sfv $HOME/.vim/janus/vim/vimrc $HOME/.vimrc
  ln -sfv $HOME/.vim/janus/vim/gvimrc $HOME/.gvimrc
}

restore_or_remove()
{
  if [ -e "$1.old" ];then
    mv -fv $1.old $1
  else
    if [[ -h $1 ]]; then
      rm -fv $1
    else
      echo Not removing "$1" because it is not a symlink
    fi
  fi
}

restore_or_remove_dir()
{
  local DIR=$1
  if [[ -d $DIR ]]; then
    if [[ -h $DIR ]]; then
      rm -rfv $DIR
      if [[ -d "$DIR.old" ]]; then
        mv -fv $DIR.old $DIR
      fi
    else
      echo Not removing "$DIR" because it is not a symlink
    fi
  else
    if [[ -e $DIR ]]; then
      echo $DIR is not a dir
    fi
  fi
}

clean_special_cases()
{
  local DIR=$1

  if ! has_janus ; then
    # ~/.gvimrc when there is no janus
    local GVIMRC=$DIR/.gvimrc
    if [[ -h $GVIMRC ]]; then
      restore_or_remove $GVIMRC
    fi
    local OLD=$GVIMRC.old
    if [[ -h $OLD ]]; then
      if ls -l $OLD | grep -e '.vim/janus/vim/gvimrc$'; then
        rm -fv $OLD
      fi
    fi
  fi

  # swap dirs
  rm -rvf $DIR/.vim.local

  # ~/.janus
  restore_or_remove_dir $DIR/.janus

}

clean()
{
  local DIR=$1
  for t in .vimrc .gvimrc .vimrc.before .vimrc.after .gvimrc.before .gvimrc.after vimrc gvimrc vimrc.local gvimrc.local
  do
    path=$DIR/$t
    if [[ -h "$path" ]];then
      restore_or_remove $path
    fi
  done

  clean_special_cases $DIR
}

save_and_link()
{
  local TARGET=$1
  local LINK_NAME=$2

  # save off if it exists as a symlink or a regular file.
  # the symlink might be broken or not.
  if [[ -h $LINK_NAME || -e $LINK_NAME ]]; then
    mv -fv $LINK_NAME $LINK_NAME.old
  fi
  ln -sfv $TARGET $LINK_NAME
}

save_and_link_dir()
{
  local TARGET=$1
  local LINK_DIR=$2
  local LINK_NAME=$LINK_DIR/`basename $TARGET`
  if [[ -d $LINK_NAME ]]; then
    #cp -rv  $LINK_NAME $LINK_NAME.old
    #rm -rvf $LINK_NAME
    mv -fv $LINK_NAME $LINK_NAME.old
  fi
  link_dir $TARGET $LINK_DIR
}
