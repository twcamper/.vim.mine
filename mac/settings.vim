"any mac specific options or mappings go here
set fileformat=unix
set dy=uhex
au BufEnter /private/tmp/crontab.* setl backupcopy=yes
set t_Co=16  " at 256, we get blinking text in Terminal
let g:syntastic_enable_signs=0   " quiet warnings for Mac cmd line vim (unsupported feature)
