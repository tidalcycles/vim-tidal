if exists("g:loaded_tidal") || &cp || v:version < 700
  finish
endif
let g:loaded_tidal = 1

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Functions
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
function! s:Hush()
  execute 'SlimeSend1 hush'
endfunction

function! s:Silence(stream)
  execute 'SlimeSend1 d' . a:stream . ' silence'
endfunction

function! s:Play(stream)
  let res = search('^\s*d' . a:stream)
  if res > 0
    execute "normal! vip:SlimeSend\<cr>"
  else
    echo "d" . a:stream . " was not found"
  endif
endfunction

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Commands
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
command! -nargs=0 TidalHush call s:Hush()
command! -nargs=1 TidalSilence call s:Silence(<args>)
command! -nargs=1 TidalPlay call s:Play(<args>)

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Configuration
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" vim-slime global options
let g:slime_target="tmux"
let g:slime_paste_file=tempname()
let g:slime_default_config={"socket_name": "default", "target_pane": "tidal:0.1"}
let g:slime_no_mappings=1
