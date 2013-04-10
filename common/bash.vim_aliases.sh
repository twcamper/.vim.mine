# Disable bash Ctrl-S ('halt output') key mapping so we may use it for file save in vim
#
# This is needed ONLY for the text-mode console, not for anything run
# under X.

# Source it in an appropriate bash config file such as ~/.bash_aliases or
# /etc/profile.
#
vim-no-halted-output()
{
  # save current options
  case `uname -s` in
    Linux )
      local STTYOPTS="$(stty --save)"
      ;;
    Darwin )
      local STTYOPTS="$(stty -g)"
      ;;
  esac

  stty stop '' -ixoff              # disable output interuption
  command "$@"                     # call version of vim with any args
  stty "$STTYOPTS"                 # restore normal tty behavior after we've left vim
}

vim()
{
  vim-no-halted-output $FUNCNAME "$@"
}
vi()
{
  vim-no-halted-output $FUNCNAME "$@"
}
vim.tiny()
{
  vim-no-halted-output $FUNCNAME "$@"
}
