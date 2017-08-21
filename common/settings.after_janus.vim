" This file is sourced by a *vim*rc file.
" It is NOT read direclty be either vim or any Janus plugin.
"
nnoremap <silent> <Leader>b :BuffergatorToggle<CR>
let g:NERDSpaceDelims=1
let g:syntastic_auto_jump=1
let g:syntastic_auto_loc_list=1

" stop annoying warning from popping up before it gives me a
" chance to use the variable I just defined in Ruby
let g:syntastic_quiet_messages = { "level": "warnings",
      \ "regex": 'assigned but unused variable'}
      " \ "file":  '\.rb$' }  " I can't get the file name match to work, so
      " all errors were being filtered.

" python version
let g:syntastic_python_python_exec = system('which python3')

au FileType javascript setlocal tabstop=4 shiftwidth=4
" don't hide quotes in json
let g:vim_json_syntax_conceal = 0
